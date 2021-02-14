package main

import (
	"fmt"
	"github.com/jackc/pgx"
	"os"
	"context"
)

func main() {
	uri:="postgresql://root@localhost:26257/bank?ssl=disabled"
	conn, err := pgx.Connect(context.Background(), uri)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
		os.Exit(1)
	}
	var  text string;
	err = conn.QueryRow(context.Background(), 
		"SELECT CONCAT('Hello from CockroachDB at ',CAST (NOW() as STRING))").Scan(&text)
	if err != nil {
			fmt.Fprintf(os.Stderr, "QueryRow failed: %v\n", err)
			os.Exit(1)
	}
	
		fmt.Println(text)
}