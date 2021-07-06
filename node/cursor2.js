const { Pool } = require('pg')
const Cursor = require('pg-cursor')
const pool = new Pool();
const client = await pool.connect()
const cursor = client.query(new Cursor('select * from generate_series(0, 5)'))
cursor.read(100, (err, rows) => {
  if (err) {
    throw err
  }
  assert(rows.length == 6)
  cursor.read(100, (err, rows) => {
    assert(rows.length == 0)
  })
})