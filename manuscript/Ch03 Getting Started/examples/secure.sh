rm -rf certs my-safe-directory


mkdir certs my-safe-directory

# CA certificate and keypair
cockroach cert create-ca \
    --certs-dir=certs \
    --ca-key=my-safe-directory/ca.key
 
# certificate and keypari for localhost 
cockroach cert create-node localhost `hostname` --certs-dir=certs \
    --ca-key=my-safe-directory/ca.key

# certificate for the root user 
cockroach cert create-client root \
    --certs-dir=certs \
    --ca-key=my-safe-directory/ca.key
# start single node 
cockroach start-single-node --certs-dir=certs --background

 cockroach sql --certs-dir=certs --certs-dir=certs   