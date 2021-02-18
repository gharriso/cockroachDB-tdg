kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/config/crd/bases/crdb.cockroachlabs.com_crdbclusters.yaml

kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/manifests/operator.yaml

kubectl apply -f example.yaml

kubectl exec -it cockroachdb-2 -- ./cockroach sql --certs-dir cockroach-certs

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
mkdir certs;cd certs
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/ca.crt >ca.crt
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/client.root.key >client.root.key
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/client.root.crt >client.root.crt

nohup kubectl port-forward services/cockroachdb-public 26257:26257 8080:8080 -n default >portForward2.log & 
 
cockroach sql --port 26257 --certs-dir certs 