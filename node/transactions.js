const pg = require('pg');


if (process.argv.length != 7) {
    console.log(`Usage: node ${process.argv[1]} CONNECTION_URI threads loops sleepMs nLocations`);
    process.exit(1);
}

const connectionString = process.argv[2];
const threads = parseInt(process.argv[3]);
const loops = parseInt(process.argv[4]);
const sleepTime = parseInt(process.argv[5]);
const nLocations = parseInt(process.argv[6]);

const pool = new pg.Pool({
    connectionString,
    max: 100
});
// const connection = await pool.connect();
const connection = new pg.Client(connectionString);


const locationIds = [];
const elapsedTimes = {
    noRetry: [],
    retry: [],
    forUpdate: []
};

async function main() {
    const debug = false;
    try {
        await connection.connect();
        // Check parameters

        await setup(nLocations);
        let promises = [];

        const locations = await connection.query('SELECT id FROM locations');

        locations.rows.forEach((loc) => {
            locationIds.push(loc.id);
        });

        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        console.log(randomId, randomValue);
        await takeMeasurement(randomId, randomValue);



        // Calls without retry

        const start = new Date();
        promises = [];
        for (let ti = 0; ti < threads; ti++) {
            promises.push(multiMeasurements(loops));
        }
        let successCount = 0;
        await Promise.all(promises).then((promise) => {
            promise.forEach((p) => {
                successCount += p;
            });
        });
        console.log(`threads ${threads} loops ${loops} sleep ${sleepTime} locations ${nLocations}`);
        console.log('success ', successCount, ' ', (successCount * 100) / (loops * threads), '%');
        console.log('elapsed ', ((new Date()) - start));

        // Retry
        const start2 = new Date();
        promises = [];
        for (let ti = 0; ti < threads; ti++) {
            promises.push(multiMeasurementsRetry(loops));
        }
        let retryCount = 0;
        await Promise.all(promises).then((promise) => {
            promise.forEach((p) => {
                retryCount += p;
            });
        });
        console.log('retries ', retryCount, ' ', (retryCount * 100) / (loops * threads), '%');
        console.log('elapsed ', ((new Date()) - start2));

        // Calls with FOR UPDATE
        const start3 = new Date();
        promises = [];
        for (let ti = 0; ti < threads; ti++) {
            promises.push(multiMeasurementsForUpdate(loops));
        }
        successCount = 0;
        await Promise.all(promises).then((promise) => {
            promise.forEach((p) => {
                successCount += p;
            });
        });
        console.log('success ', successCount, ' ', (successCount * 100) / (loops * threads), '%');
        console.log('elapsed ', ((new Date()) - start3));

        Object.keys(elapsedTimes).forEach((type) => {
            console.log(type, ' avg ', avg(elapsedTimes[type]));
        });

        if (debug) traceStats(connection);
        process.exit(0);
    } catch (error) {
        console.error(error.stack);
    }
    // process.exit(0);
}

async function takeMeasurement(locationId, measurement) {
    let success = false;
    const measurementTime = new Date();
    const connection = await pool.connect();
    try {
        await connection.query('BEGIN TRANSACTION');
        await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);
        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        console.error(error.message);
        connection.query('ROLLBACK');
        success = false;
    }
    connection.release();
    return (success);
}

async function takeMeasurementForUpdate(locationId, measurement) {
    let success = false;
    const connection = await pool.connect();
    const measurementTime = new Date();
    try {
        await connection.query('BEGIN TRANSACTION');
        await connection.query(`SELECT id FROM locations 
                                 WHERE id=$1
                                   FOR UPDATE`, [locationId]);
        const insertReturn = await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2) RETURNING (measurement_timestamp)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);

        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        console.error(error.message);
        connection.query('ROLLBACK');
    }
    connection.release();
    return (success);
}

function avg(array) {
    let sum = 0;
    for (let i = 0; i < array.length; i++) {
        sum += array[i];
    }
    return (sum / array.length);
}

async function takeMeasurementWithRetry(locationId, measurement, maxRetries) {
    const connection = await pool.connect();
    const measurementTime = new Date();
    let retryCount = 0;
    let transactionEnd = false;
    while (!transactionEnd) {
        retryCount += 1;
        if (retryCount >= maxRetries) {
            throw Error('Maximum retry count exceeded');
        } else {
            try {
                await connection.query('BEGIN TRANSACTION');
                await connection.query(
                    `INSERT INTO measurements
                                        (locationId,measurement) 
                                        VALUES($1,$2)`,
                    [locationId, measurement]
                );
                await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
                    [measurement, measurementTime, locationId]);
                await connection.query('COMMIT');
                transactionEnd = true;
            } catch (error) {
                if (error.code == '40001') { // Rollback and retry
                    connection.query('ROLLBACK');
                    const sleepTime = (2 ** retryCount) * 100 + Math.ceil(Math.random() * 100);
                    console.warn('Sleeping for ', sleepTime);
                    await sleep(sleepTime);
                } else {
                    console.log('aborted ', error.message);
                    transactionEnd = true;
                }
            }
        }
    }
    connection.release();
    return (retryCount);
}

async function multiMeasurements(count) {
    let successCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await takeMeasurement(randomId, randomValue);
        elapsedTimes.noRetry.push((new Date()) - start);
        await sleep(sleepTime);
        if (s) successCount += 1;
    }
    return (successCount);
}

async function setup(locationCount) {
    try {
        const sqls = [];
        sqls.push('DROP TABLE IF EXISTS measurements');
        sqls.push('DROP TABLE IF EXISTS locations');

        sqls.push(`CREATE TABLE locations (id uuid primary KEY DEFAULT gen_random_uuid(),
                                            description STRING NOT NULL,
                                            last_measurement float,
                                            last_timestamp timestamp)`);

        sqls.push(`CREATE TABLE measurements (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                               locationId uuid NOT NULL ,
                               measurement_timestamp timestamp DEFAULT now(),
                               measurement float,
                               CONSTRAINT measurement_fk1 FOREIGN KEY (locationId) REFERENCES locations(id))`);

        sqls.push(`INSERT INTO locations (description )
            WITH RECURSIVE series AS 
                ( SELECT 0 AS id
                    UNION ALL 
                SELECT id +1 AS id
                    FROM series
                    WHERE id < ${locationCount} ) 
            SELECT  md5(random()::STRING) randomString  FROM series `);
        for (let si = 0; si < sqls.length; si++) {
            console.log(sqls[si]);
            await connection.query(sqls[si]);
        }
    } catch (error) {
        console.log(error.message);
    }
}

async function multiMeasurementsForUpdate(count) {
    let successCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await takeMeasurementForUpdate(randomId, randomValue);
        elapsedTimes.forUpdate.push((new Date()) - start);
        await sleep(sleepTime);
        if (s) successCount += 1;
    }
    return (successCount);
}

async function multiMeasurementsRetry(count) {
    let retryCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await takeMeasurementWithRetry(randomId, randomValue, 100000);
        elapsedTimes.retry.push((new Date()) - start);
        await sleep(sleepTime);
        retryCount += s;
    }
    return (retryCount);
}



async function traceStats(connection) {
    let sql = `SELECT age , message
                    FROM [SHOW TRACE FOR SESSION]
                    WHERE message LIKE 'query cache miss'
                    OR message LIKE 'rows affected%'
                    OR message LIKE '%executing PrepareStmt%'
                    OR message LIKE 'executing:%'
                    ORDER BY age`;
    sql = 'show trace for session';
    console.log(sql);
    const data = await connection.query(sql);
    console.log(data.rows);
    await connection.query('set tracing=on');
}

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

main();
