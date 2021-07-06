const CrClient = require('pg').Client;

async function main() {
    try {
        if (process.argv.length != 3) {
            console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
            process.exit(1);
        }

        const connection = new CrClient(process.argv[2]);
        await connection.connect();

        await connection.query('DROP TABLE IF EXISTS names');
        await connection.query('CREATE TABLE names (name String NOT NULL)');
        await connection.query(`INSERT INTO names (name) 
                                VALUES('Ben'),('Jesse'),('Guy')`);

        const data = await connection.query('SELECT name from names');
        data.rows.forEach((row) => {
            console.log(row.name);
        });
    } catch (error) {
        console.error(error.stack);
    }
    process.exit(0);
}

main();
