#!/usr/bin/env python3

import psycopg2
 
def main():
  uri='postgresql://root@localhost:26257/bank?sslmode=disable'
  conn = psycopg2.connect(uri)
  with conn.cursor() as cur:
    cur.execute("SELECT CONCAT('Hello from CockroachDB at ',CAST (NOW() as STRING))")
    data=cur.fetchone()
    print("%s" % data[0])

main()