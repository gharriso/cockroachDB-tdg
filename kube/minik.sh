minikube start --cpus=6 --memory=12000mb --profile=crdb  --driver=hyperkit

kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/config/crd/bases/crdb.cockroachlabs.com_crdbclusters.yaml

kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/manifests/operator.yaml

curl -O https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/examples/example.yaml

cat example.yaml|sed 's/60Gi/10Gi/' >myconfig.yaml

kubectl apply -f myconfig.yaml

kubectl exec -it cockroachdb-2 -- ./cockroach sql --certs-dir cockroach-certs

kubectl exec -it cockroachdb-2 -- ./cockroach workload init bank --certs-dir cockroach-certs

CREATE USER roach WITH PASSWORD 'Q7gc8rEdS';
grant admin to roach;
alter user root with password 'root';

nohup kubectl port-forward service/cockroachdb-public 8080 >portForward1.log & 

kubectl get service
kubectl edit service cockroachdb-public
# Chagne type: ClusterIP to type: NodePort
kubectl expose service cockroachdb-public --type=NodePort 
#kubectl expose service cockroachdb-public --port=26257 --target-port=26257 --name=cp --type=LoadBalancer
kubectl get service

rm -rf certs
mkdir certs 
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/ca.crt >certs/ca.crt
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/client.root.key >certs/client.root.key
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/client.root.crt >certs/client.root.crt
chmod 600 certs/*

kubectl port-forward services/cockroachdb-public 26258:26257 -n default   &
cockroach sql --port 26258 --certs-dir certs 
