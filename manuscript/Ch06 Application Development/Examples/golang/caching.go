package main

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/pgxpool"
)

var pool pgxpool.Pool
var err string

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Missing URL argument")
		os.Exit(1)
	}
	uri := os.Args[1]
	ctx := context.Background()
	config, err := pgxpool.ParseConfig(uri)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	config.MaxConns = 40
	*pool, err = pgxpool.ConnectConfig(ctx, config)

	connection, err := pool.Acquire(ctx)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer pool.Close()
	name := getUserName("ffc3c373-63ec-43fe-98ff-311f29424d8b")
	fmt.Fprintf(os.Stdout, "%v\n", name)
}

func getUserName(userId string) string {
	conn, err := pool.Acquire(context.Background())
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	sql := `SELECT name FROM movr.users WHERE id=$1`
	rows, err := conn.Query(context.Background(), sql, userId)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	if !rows.Next() {
		return "Invalid userId"
	} else {
		var name string
		rows.Scan(&name)
		return (name)
	}
}
