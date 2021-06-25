#!/usr/bin/env python3

import psycopg2
import sys
import time
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  connection = psycopg2.connect(uri)
  cursor=connection.cursor()
  cursor.execute("use chapter06")
  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """)
  for x in range(0, 9):
      row=cursor.fetchone()
      print(row)
  end=time.time()
  print(end-start)

  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """)
  rows=cursor.fetchall()
  print("%s rows returned" % len(rows))
  for x in range(0, 9):
      print(rows[x])
  
  end=time.time()
  print(end-start)  

  start=time.time()
  cursor.execute("""SELECT post_timestamp, summary 
                      FROM blog_posts ORDER BY post_timestamp DESC """) 
  rows = cursor.fetchmany(size=10)
  for x in range(0,len(rows)):
      print(rows[x])
  end=time.time()
  print(end-start)  
 

main()