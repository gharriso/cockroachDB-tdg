#!/usr/bin/env python3

import psycopg2
import sys
 
def main():
  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")

  uri=sys.argv[1]

  conn = psycopg2.connect(uri)
  print("%s" % uri)
  conn = psycopg2.connect(uri)
  cur=conn.cursor()
  sql="""SELECT u.name FROM movr.rides r 
           JOIN movr.users u ON (r.rider_id=u.id) 
          WHERE r.id=$1"""
  cur.execute('use movr')
  cur.execute('PREPARE prepStmt AS '+sql)
  riderId='ffc3c373-63ec-43fe-98ff-311f29424d8b'
  #cur.execute("execute prepStmt(%s)" % riderId)
  cur.execute("EXECUTE prepStmt('%s')" % riderId)
  for row in cur:
      print("%s"%row[0])
  execPrepared(conn,riderId)

  

def execPrepared(conn, riderId):
  cur=conn.cursor()
  cur.execute("EXECUTE prepStmt('%s')" % riderId)
  for row in cur:
      print("%s"%row[0])

main()