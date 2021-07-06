rm -rf $HOME/.cockroach-certs

mkdir $HOME/.cockroach-certs

cp $HOME/Downloads/cc-ca.crt $HOME/.cockroach-certs/ca.crt 

cockroach sql --url 'postgres://guy:b4_jPoEYw4_Ixsj7@free-tier6.gcp-asia-southeast1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full&sslrootcert=/Users/guyharrison/.cockroach-certs/ca.crt&options=--cluster=grumpy-orca-56'

cockroach sql --url 'postgres://guy:b4_jPoEYw4_Ixsj7@free-tier6.gcp-asia-southeast1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full&options=--cluster=grumpy-orca-56'