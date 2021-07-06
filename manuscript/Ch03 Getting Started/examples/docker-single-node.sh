docker volume create crdb1

docker run -d \
--name=crdb1 \
--hostname=crdb1 \
-p 26257:26257 -p 8080:8080  \
-v "crdb1:/cockroach/cockroach-data"  \
cockroachdb/cockroach:latest start-single-node  \
--insecure 

 docker exec -it `docker ps|grep crdb1|cut -f1 -d' '` cockroach sql --insecure