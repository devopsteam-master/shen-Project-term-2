# 🚀 Kubernetes Metrics Server Installation and Configuration Guide

The **Metrics Server** is a scalable and efficient solution for collecting **resource metrics** (CPU, memory) from **Kubernetes nodes** and **pods**. These metrics are exposed through the **Metrics API**, enabling **autoscaling** with **Horizontal Pod Autoscaler (HPA)** and **Vertical Pod Autoscaler (VPA)**.

---

## 📦 **1. What is the Metrics Server?**

- Collects **resource metrics** from **Kubelets**.
- Exposes metrics via the **Metrics API** to the **Kubernetes API server**.
- Enables use of **`kubectl top`** for quick metrics access.
- Supports **autoscaling** with **HPA** and **VPA**.
- Not intended for **monitoring solutions** (e.g., Prometheus).

---

## ⚙️ **2. Installing the Metrics Server**

### **Apply the Default Metrics Server Manifest**

```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

- This command will deploy the **Metrics Server** in the **kube-system namespace**.

### **Verify Installation**

```sh
kubectl get all -n kube-system | grep metrics-server
```

#### **Expected Output:**

```plaintext
pod/metrics-server-abcdef12345-xyz   1/1     Running   0          30s
service/metrics-server               ClusterIP   10.96.0.1   <none>        443/TCP   30s
deployment.apps/metrics-server       1/1     1            1           30s
```

---

## 🔍 **3. Testing the Metrics Server**

### **Check Pod Metrics**

```sh
kubectl top pod -n <namespace>
```

- Displays **CPU** and **Memory** usage for **pods** in the specified namespace.

### **Check Node Metrics**

```sh
kubectl top node
```

- Shows **CPU** and **Memory** metrics for **all nodes** in the cluster.

#### **Example Output:**

```plaintext
NAME        CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
node-1      100m         10%    500Mi           25%
node-2      150m         15%    600Mi           30%
```

---

## 🛠️ **4. Troubleshooting Common Issues**

If you see errors like:

```plaintext
Error from server (ServiceUnavailable): the server is currently unable to handle the request (get pods.metrics.k8s.io)
```

### ✅ **Fix Metric Server Configuration**

1. **Edit the Metrics Server Deployment**:

```sh
kubectl edit deployment metrics-server -n kube-system
```

2. **Add the following flags to the container args**:

```yaml
spec:
  containers:
  - args:
    - --kubelet-insecure-tls
    - --authorization-always-allow-paths=/livez,/readyz
```

3. **Save and Exit**.

### 🔄 **Restart the Metrics Server Pod**

```sh
kubectl rollout restart deployment metrics-server -n kube-system
```

### 🚦 **Verify the Status Again**

```sh
kubectl get pods -n kube-system | grep metrics-server
kubectl top nodes
kubectl top pods -A
```

---

## 💡 **5. Useful Commands**

### **Check Metrics Server Logs**

```sh
kubectl logs -n kube-system deployment/metrics-server
```

### **Force Pod Restart**

```sh
kubectl delete pod -n kube-system -l k8s-app=metrics-server
```

### **Verify API Availability**

```sh
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes
kubectl get --raw /apis/metrics.k8s.io/v1beta1/pods
```

---

## 🔍 **6. Validate Metrics Server with Autoscaling**

### **Create an Example HPA**

```sh
kubectl autoscale deployment <your-deployment> --cpu-percent=50 --min=1 --max=5
```

- Check the **HPA status**:

```sh
kubectl get hpa
```

#### **Expected Output:**

```plaintext
NAME               REFERENCE                     TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
example-hpa        Deployment/example-app        10%/50%   1         5         1          1m
```

---

## 📋 **7. Best Practices**

- The **Metrics Server** should not be used for **long-term monitoring**; use **Prometheus** or a similar tool for that purpose.
- Avoid exposing the **Metrics Server** to **external networks** as it uses **insecure TLS** (`--kubelet-insecure-tls`).
- **Regularly monitor** the health of the **Metrics Server** with:

```sh
kubectl get apiservices | grep metrics
```

---

## 🔥 **8. Cleanup**

If needed, you can **uninstall the Metrics Server** with:

```sh
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify that the **Metrics Server** components are removed:

```sh
kubectl get all -n kube-system | grep metrics-server
```

---

## 🚦 **9. Next Steps**

- Implement **Horizontal Pod Autoscaling (HPA)** for workloads.
- Combine with **Prometheus Adapter** for **custom metrics autoscaling**.
- Integrate **Grafana dashboards** for **visualizing cluster resource usage**.
