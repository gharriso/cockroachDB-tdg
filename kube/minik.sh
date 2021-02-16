kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/config/crd/bases/crdb.cockroachlabs.com_crdbclusters.yaml

kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/manifests/operator.yaml

kubectl apply -f example.yaml

kubectl exec -it cockroachdb-2 -- ./cockroach sql --certs-dir cockroach-certs

CREATE USER roach WITH PASSWORD 'Q7gc8rEdS';
grant admin to roach;

kubectl port-forward service/cockroachdb-public 8080