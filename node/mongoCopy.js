const {
    Client
} = require('pg');

const {
    MongoClient
} = require('mongodb');

// Connect to the database.
const config = {
    user: 'root',
    host: 'localhost',
    database: 'json',
    port: 26257
};
const mongoURI = 'mongodb://localhost:27017/MongoDBTuningBook';
// reate database json
// use json
// create table customersjson(id int primary key, jsondata jsonb)

const cdb = new Client(config);
let counter = 0;

async function main() {
    try {
        await cdb.connect();
        const mongo = await MongoClient.connect(mongoURI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        const mdb = mongo.db();

        const cursor = mdb.collection('customers').find().limit(1000);
        await cdb.query('TRUNCATE TABLE customersjson');
        for (let doc = await cursor.next(); doc != null; doc = await cursor.next()) {
            counter += 1;
            await cdb.query('INSERT INTO customersjson(customerid,jsondata) VALUES($1,$2)', [counter, doc]);
            console.log(doc);
        }
        console.log(counter);
    } catch (error) {
        console.log(error.stack);
    }
    process.exit(0);
}

main();
