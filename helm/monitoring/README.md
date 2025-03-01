## Monitoring Helm Chart

**Step 1:** Add helm repository and update all repo
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo list
helm repo update
```

**Step 2:** Check and change Values file
```bash
vim helm.values.yaml
```

**Step 3:** Deploy kube prometheus stack
```bash
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    -f kube-prometheus-stack/helm.values.yaml \
     --create-namespace
```

**Step 4:** Create a pod for getting etcd certificates and save its name in podname variable
```bash
kubectl apply -f get-etcd-cert.yaml
podname=$(kubectl get pods -o=jsonpath='{.items[0].metadata.name}' -n default | grep get-etcd-cert)
```

**Step 5:** Create secrets
```bash
kubectl create secret generic etcd-client-cert -n monitoring \
--from-literal=etcd-ca="$(kubectl exec $podname -n default -- cat /etc/kubernetes/pki/etcd/ca.crt)" \
--from-literal=etcd-client="$(kubectl exec $podname -n default -- cat /etc/kubernetes/pki/apiserver-etcd-client.crt)" \
--from-literal=etcd-client-key="$(kubectl exec $podname -n default -- cat /etc/kubernetes/pki/apiserver-etcd-client.key)"
```