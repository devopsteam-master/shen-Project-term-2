# 🚀 Redis Sentinel - High Availability Setup & Testing Guide

This guide provides **step-by-step instructions** for setting up **Redis Sentinel** with **High Availability (HA)** using **Bitnami's Helm chart** and testing **failover scenarios** in a **Kubernetes cluster**.

---

## 📦 **1. Prerequisites**

- A running **Kubernetes cluster**
- **Helm** installed (`helm version` to check)
- **Kubernetes CLI (kubectl)** configured (`kubectl version` to check)

---

## ⚙️ **2. Installation Steps**

### **Add Bitnami Repository (If not already added)**

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### **Install Redis Sentinel with Helm**

```sh
helm upgrade --install redis-sentinel bitnami/redis --values ./helm/redis/values.yaml -n mecan
```

- **Namespace:** `mecan` (You can change it to your preferred namespace)
- **Configuration:** Refer to the **values.yaml** file located at `./helm/redis/values.yaml` for custom settings such as:
  - **Replication Architecture**
  - **Sentinel Configuration**
  - **Persistence Settings**
  - **Resource Requests and Limits**
  - **Authentication**

---

## 🔍 **3. Testing High Availability (HA)**

### **Connect to Redis Nodes**

```sh
kubectl exec -it -n mecan redis-sentinel-node-0 -- redis-cli -h localhost -p 6379 -a password
kubectl exec -it -n mecan redis-sentinel-node-1 -- redis-cli -h localhost -p 6379 -a password
kubectl exec -it -n mecan redis-sentinel-node-2 -- redis-cli -h localhost -p 6379 -a password
```

### **Verify Redis Status**

```sh
info
```

- Check **role** of the node (**master** or **replica**):

```sh
role
```

### **Add and Retrieve a Key**

- **In Master Node:**

```sh
set mykey "Hello from primary"
```

- **In Any Node:**

```sh
get mykey
```

You should see the value:
```plaintext
"Hello from primary"
```

---

## 🆘 **4. Simulate Failover**

### **Delete the Master Node**

```sh
kubectl delete pod -n mecan redis-sentinel-node-0
```

- Wait for **Redis Sentinel** to elect a new **master**.
- Verify the new **master** by checking the **role** of all nodes:

```sh
kubectl exec -it -n mecan redis-sentinel-node-1 -- redis-cli -h localhost -p 6379 -a password role
```

- The output should show the **master** role for a different node.

---

## 📈 **5. Scaling the StatefulSet**

### **Scale Down to 2 Replicas**

```sh
kubectl scale statefulset redis-sentinel-node --replicas=2 -n mecan
```

- **Add a Key** to the **master** node:

```sh
set mykey2 "Key from primary before scaling up"
```

### **Scale Up to 3 Replicas**

```sh
kubectl scale statefulset redis-sentinel-node --replicas=3 -n mecan
```

### **Verify Key Synchronization**

- **Check keys in the new replica**:

```sh
kubectl exec -it -n mecan redis-sentinel-node-2 -- redis-cli -h localhost -p 6379 -a password
KEYS *
get mykey2
```

You should see:
```plaintext
"Key from primary before scaling up"
```