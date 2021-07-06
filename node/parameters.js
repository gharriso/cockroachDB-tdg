const pg = require('pg');
const Cursor = require('pg-cursor');

if (process.argv.length != 3) {
    console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
    process.exit(1);
}
const connectionString = process.argv[2];

const pool = new pg.Pool({
    connectionString
});
// const connection = await pool.connect();
const connection = new pg.Client(connectionString);


async function main() {
    try {
        await connection.connect();
        // Check parameters

        await connection.query('USE movr');
        await connection.query('set tracing=on');
        // await traceStats(connection);
        const sql = `SELECT u.name FROM movr.rides r   
                      JOIN movr.users u ON (r.rider_id=u.id)   
                     WHERE r.id=$1`;
        const results = await connection.query(sql, ['ffc3c373-63ec-43fe-98ff-311f29424d8b']);
        console.log(results.rows[0].name);
        console.log('done');
       // await traceStats(connection);
    } catch (error) {
        console.error(error.stack);
    }
    // process.exit(0);
}

function cursorRead(cursor, batchSize) {
    return new Promise((resolve, reject) => {
        cursor.read(batchSize, async (err, rows) => {
            if (err) {
                reject(err);
            }
            resolve(rows);
        });
    });
}

async function newRide(city, riderId, vehicleId, startAddress) {
    const connection = new pg.Client(connectionString);
    await connection.connect();
    const sql = `INSERT INTO movr.rides
                 (id, city,rider_id,vehicle_id,start_address,start_time)
                 VALUES(gen_random_uuid(), $1,$2,$3,$4,now())`;
    await connection.query(sql, [city, riderId, vehicleId, startAddress]);
    await connection.close();
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

main();
