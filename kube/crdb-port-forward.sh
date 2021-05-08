mkdir -p ~/.cockroach-certs/minikube
cd ~/.cockroach-certs/minikube
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/ca.crt >ca.crt
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/client.root.key >client.root.key
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/client.root.crt >client.root.crt

nohup kubectl port-forward services/cockroachdb-public 26258:26257 -n default >/tmp/portForward2.log & 