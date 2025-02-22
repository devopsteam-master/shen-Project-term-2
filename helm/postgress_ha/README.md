# 🚀 PostgreSQL HA - High Availability Setup & Testing Guide

This guide provides **step-by-step instructions** for deploying **PostgreSQL in High Availability (HA)** mode using **Bitnami's Helm chart**, and testing **failover scenarios** to validate **replication and recovery**.

---

## 📦 **1. Prerequisites**

- A running **Kubernetes cluster**
- **Helm** installed (`helm version` to check)
- **Kubernetes CLI (kubectl)** configured (`kubectl version` to check)
- **values.yaml** configured with HA settings (located at `./helm/postgresql/values.yaml`)

---

## ⚙️ **2. Installation Steps**

### **Add Bitnami Repository (If not already added)**

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### **Install PostgreSQL HA with Helm**

```sh
helm install postgresql-ha bitnami/postgresql-ha -f ./helm/postgresql/values.yaml -n mecan
```

- **Namespace:** `mecan` (Change to your preferred namespace)
- **Configuration:** Refer to `values.yaml` for custom settings such as:
  - **Replication Architecture**
  - **Persistence Settings**
  - **Resource Requests and Limits**
  - **Authentication and Database Initialization**

---

## 🔍 **3. Verify High Availability (HA)**

### **Check the Role of Each Node**

For each pod, run the following command to check if it is the **master** or a **replica**:

```sh
kubectl exec -it -n mecan postgresql-ha-postgresql-0 -- bash
psql -U postgres -c "SELECT pg_is_in_recovery();"
```

- `f (false)` indicates **master**
- `t (true)` indicates **replica**

#### **Example Output:**

```plaintext
 pg_is_in_recovery 
-------------------
 f  # Indicates this node is the master
(1 row)
```

Repeat this for all nodes (`0`, `1`, `2`):

```sh
kubectl exec -it -n mecan postgresql-ha-postgresql-1 -- bash
psql -U postgres -c "SELECT pg_is_in_recovery();"

kubectl exec -it -n mecan postgresql-ha-postgresql-2 -- bash
psql -U postgres -c "SELECT pg_is_in_recovery();"
```

---

## 🧪 **4. Test Data Replication Across Nodes**

### **1. Add Data to the Master Node**

Connect to the **master node** and add data to the database:

```sh
psql -U postgres
CREATE TABLE test_table (id SERIAL PRIMARY KEY, value TEXT);
INSERT INTO test_table (value) VALUES ('Test Data');
```

### **2. Verify Data on All Nodes**

Connect to each **replica** and verify the **replicated data**:

```sh
psql -U postgres -c "SELECT * FROM test_table;"
```

#### **Expected Output:**

```plaintext
 id |   value   
----+------------
  1 | Test Data
(1 row)
```

---

## 🆘 **5. Simulate Failover Scenario**

### **Delete the Master Node**

```sh
kubectl delete pod -n mecan postgresql-ha-postgresql-0
```

- Wait for **PostgreSQL HA** to **promote a replica** to **master**.
- Verify the **new master** by running:

```sh
kubectl exec -it -n mecan postgresql-ha-postgresql-1 -- bash
psql -U postgres -c "SELECT pg_is_in_recovery();"
```

- The output `f (false)` confirms the **master role**.

---

## 📈 **6. Scaling the StatefulSet**

### **1. Scale Down from 3 to 2 Replicas**

```sh
kubectl scale statefulset postgresql-ha-postgresql --replicas=2 -n mecan
```

### **2. Add Data to the Master**

```sh
psql -U postgres
INSERT INTO test_table (value) VALUES ('New Data After Scaling');
```

### **3. Scale Up to 3 Replicas**

```sh
kubectl scale statefulset postgresql-ha-postgresql --replicas=3 -n mecan
```

### **4. Verify Data on the New Replica**

```sh
psql -U postgres -c "SELECT * FROM test_table;"
```

#### **Expected Output:**

```plaintext
 id |          value          
----+--------------------------
  1 | Test Data
  2 | New Data After Scaling
(2 rows)
```