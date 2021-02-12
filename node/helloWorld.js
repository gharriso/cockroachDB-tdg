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
      'SELECT  now()'
    );
    console.log('Time from database: ', data.rows[0].now);
  } catch (error) {
    console.log(error.stack);
  }
  process.exit(0);
}

main();
