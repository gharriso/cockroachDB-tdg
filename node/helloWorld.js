const {
  Client
} = require('pg');

// Connect to the database.
const config = {
  user: 'root',
  host: 'localhost',
  database: 'defaultdb',
  port: 26257
};

const pgClient = new Client(config);

async function main() {
  try {
    await pgClient.connect();
    const data = await pgClient.query(
      "SELECT CONCAT('Hello from CockroachDB at ',CAST (NOW() as STRING)) as hello"
    );
    console.log(data.rows[0].hello);
  } catch (error) {
    console.log(error.stack);
  }
  process.exit(0);
}

main();
