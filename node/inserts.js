const pg = require('pg');
const format = require('pg-format');

async function main() {
    if (process.argv.length != 3) {
        console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
        process.exit(1);
    }
    const connectionString = process.argv[2];
    const connection = new pg.Client(connectionString);
    await connection.connect();
    await connection.query('USE chapter06');
    await connection.query('DROP TABLE if EXISTS insertTestP2');
    await connection.query('CREATE TABLE insertTestP2(id int primary key,x string,y int)');

    const arrayData = [
        [1, 'fred', 1],
        [2, 'fred', 2]
    ];

    const sql = format('INSERT INTO insertTestP2(id,x,y) VALUES  %L returning id', arrayData);

    await connection.query(sql);

    process.exit(0);
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