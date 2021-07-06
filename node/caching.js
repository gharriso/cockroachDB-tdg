const pg = require('pg');
const Cursor = require('pg-cursor');

if (process.argv.length != 3) {
    console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
    process.exit(1);
}
const connectionString = process.argv[2];

// const connection = await pool.connect();
const connection = new pg.Client(connectionString);


async function main() {
    try {
        // Check parameters
        await connection.connect();
        await connection.query('USE movr');

        // await traceStats(connection);
        const sql = 'SELECT id,name FROM movr.users';
        userIds = [];
        const users = await connection.query(sql);
        users.rows.forEach((user) => {
            userIds.push(user.id);
        });
        console.log(userIds);
        console.log(await getUserName(userIds[0]));
 
    } catch (error) {
        console.error(error.stack);
    }
    process.exit(0);
}

async function getUserName(userId) {
    const nameData = await connection.query('SELECT name FROM movr.users WHERE id=$1', [userId]);
    return (nameData.rows[0].name);
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
