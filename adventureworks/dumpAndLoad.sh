pg_dump -x --no-comments --inserts -d Adventureworks -f Adventureworks1.pgdump
cockroach nodelocal upload Adventureworks.pgdump Adventureworks1.pgdump --host=mbp1 --insecure
echo "import pgdump 'nodelocal://1/Adventureworks1.pgdump' WITH ignore_unsupported_statements;" | cockroach sql --database=adventureworks --host=mbp1 --insecure
