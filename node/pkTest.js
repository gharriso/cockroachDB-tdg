// Example of connecting to CockroachDB using NodeJS

const CrClient = require('pg').Client;
 // load pg client
const debug = false;

async function main() {
    try {
        // Check parameters
        if (process.argv.length != 5) {
            console.log('Usage: node helloWorld.js nConnections nRows CONNECTION_URI');
            process.exit(1);
        }
        // Establish a connection using the command line URI
        const nConnections = process.argv[2];
        const nRows = process.argv[3];
        const connectionString = process.argv[4];
        const connections = [];
        for (let ci = 0; ci < nConnections; ci++) {
            connections[ci] = new CrClient(connectionString);
            await connections[ci].connect();
            const data = await connections[ci].query(
                `SELECT CONCAT('Hello from CockroachDB at ',
                                CAST (NOW() as STRING)) as hello`
            );
            // Print out the error message
            console.log(data.rows[0].hello);
            await connections[ci].query('use Chapter05');
        }
        await createTables(connections[0]);
        const data = dataBatch(nRows);
        await insertTest(connections, 'int_keyed', true, data);
        await insertTest(connections, 'seq_keyed', false, data);
        await insertTest(connections, 'uuid_keyed', false, data);
        await insertTest(connections, 'serial_keyed', false, data);
        await insertTest(connections, 'hash_keyed', true, data);
    } catch (error) {
        console.log(error.stack);
    }
    // Exit
    process.exit(0);
}

function dataBatch(rows) {
    const data = [];
    for (let ri = 0; ri < rows; ri += 1) {
        data.push({
            pk: ri,
            id: ri,
            rnumber: Math.random(),
            rstring: Math.random().toString(36).replace(/[^a-z]+/g, '')
        });
    }
    return (data);
}

async function insertTest(connections, tableName, insertPk, data) {
    const start = new Date();
    let sqlText = `INSERT INTO ${tableName} (id,rnumber,rstring) VALUES($1,$2,$3)`;
    if (insertPk) {
        sqlText = `INSERT INTO ${tableName} (pk,id,rnumber,rstring) VALUES($1,$2,$3, $4)`;
    }

    const promises = []; 
    const pi = 0;
    let di = 0;
    for (let dataCounter = 0; dataCounter < data.length; dataCounter += connections.length) {
        for (let ci = 0; ci < connections.length; ci += 1) {
            di = dataCounter + ci; // Need to assign keys round robin
            if (di+1 > data.length) break;
            const myData = data[di];
            if (insertPk) {
                promises[pi] = connections[ci].query(sqlText, [myData.pk, myData.id, myData.rnumber, myData.rstring]);
            } else {
                promises[pi] = connections[ci].query(sqlText, [myData.id, myData.rnumber, myData.rstring]);
            }
        }
    }
    await Promise.all(promises).then((promiseOut) => {
        if (debug) console.log(promiseOut);
    });
    console.log(`${data.length} rows inserted into ${tableName} in ${((new Date()) - start)} ms`);
    const rs1 = await connections[0].query(
        `SELECT COUNT(*) AS n FROM ${tableName}`
    );
    // Print out the error message
    console.log(rs1.rows[0].n, ' rows inserted');
}

async function createTables(connection) {
    const statements = [];
    statements.push('DROP TABLE seq_keyed');
    statements.push('DROP TABLE serial_keyed');
    statements.push('DROP TABLE uuid_keyed');
    statements.push('DROP TABLE hash_keyed');
    statements.push('DROP TABLE int_keyed');
    statements.push('DROP SEQUENCE seq_seq;');
    statements.push('CREATE SEQUENCE seq_seq');
    statements.push(`
    CREATE TABLE seq_keyed  (
        pk INT NOT NULL PRIMARY KEY DEFAULT nextval('seq_seq')  ,
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push(`
    CREATE TABLE serial_keyed  (
        pk SERIAL PRIMARY KEY NOT NULL  ,
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push(`
    CREATE TABLE uuid_keyed  (
        pk uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(), 
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push(`
    CREATE TABLE int_keyed  (
        pk int not null primary key,
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push('SET experimental_enable_hash_sharded_indexes=on');
    statements.push(`
    CREATE TABLE hash_keyed  (
        pk int NOT NULL,
        id int,
        rnumber float,
        rstring STRING,
        PRIMARY KEY (pk) USING HASH WITH BUCKET_COUNT=6
    )`);
    for (let si = 0; si < statements.length; si += 1) {
        console.log(statements[si]);
        try {
            await connection.query(statements[si]);
        } catch (error) {
            console.log(error.message, ' while executing ', statements[si]);
        }
    }
}

main();
