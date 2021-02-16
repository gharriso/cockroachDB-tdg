if [ $# -eq 0 ];then 
  echo "Usage $0 postgresURL"
  exit
fi
for wl in bank intro kv movr startrek tpcc ycsb; do
  cockroach workload init $wl $1
done