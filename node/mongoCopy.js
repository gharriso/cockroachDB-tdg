const {
    Client
} = require('pg');

const { MongoClient } = require('mongodb');

// Connect to the database.
const config = {
    user: 'root',
    host: 'localhost',
    database: 'json',
    port: 26257
};
const mongoURI = 'mongodb://localhost:27017/MongoDBTuningBook';

const cdb = new Client(config);
let counter = 0;
async function main() {
    try {
        await cdb.connect();

        await cdb.query('BEGIN');
        const mongo = await MongoClient.connect(mongoURI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        })
        const mdb = mongo.db();

        let cursor = mdb.collection('customers').find().limit(1000);

        for (let doc = await cursor.next(); doc != null; doc = await cursor.next()) {
            const res = await cdb.query('INSERT INTO customersjson(customerid,jsondata', [counter, doc]);
        }
        console.log(counter);
        cdb.query('END');

    } catch (error) {
        console.log(error.stack);
    }
    process.exit(0);
}

main();
