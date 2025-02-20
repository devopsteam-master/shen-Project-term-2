# 🚀 Voting App - Kubernetes Deployment with Helm

This commit introduces a **Helm-based deployment** for the **Voting App**, which consists of **five components**: `vote`, `result`, `worker`, `redis`, and `postgresql`. The application is deployed on a **Kubernetes cluster** using **Helm charts**, with **Ingress** configured for `vote` and `result` services.

---

## 🗂️ **Project Structure**

```
helm/
├── postgresql
│   ├── Chart.yaml
│   ├── templates
│   │   ├── db-deployment.yaml
│   │   └── db-service.yaml
│   └── values.yaml
├── redis
│   ├── Chart.yaml
│   ├── templates
│   │   ├── redis-deployment.yaml
│   │   └── redis-service.yaml
│   └── values.yaml
├── result
│   ├── Chart.yaml
│   ├── templates
│   │   ├── result-deployment.yaml
│   │   ├── result-ingress.yml
│   │   └── result-service.yaml
│   └── values.yaml
├── vote
│   ├── Chart.yaml
│   ├── templates
│   │   ├── vote-deployment.yaml
│   │   ├── vote-ingress.yml
│   │   └── vote-service.yaml
│   └── values.yaml
└── worker
    ├── Chart.yaml
    ├── templates
    │   └── worker-deployment.yaml
    └── values.yaml
```

---

## 🚦 **Current Implementation Steps**

### 1. **Setup Ingress & Update `/etc/hosts`**

The `vote` and `result` services are now accessible through **Ingress**, configured with the following domains:

```plaintext
127.0.0.1 vote.devops.local
127.0.0.1 result.devops.local
```

Update your `/etc/hosts` file to map these domains to `localhost`.

---

### 2. **Install All Components with Helm**

Deploy all services using the following Helm commands:

```bash
helm upgrade --install vote ./vote
helm upgrade --install result ./result
helm upgrade --install worker ./worker
helm upgrade --install redis ./redis
helm upgrade --install postgresql ./postgresql
```

---

### 3. **Verify Application in Browser**

- **Vote Service:** [http://vote.devops.local](http://vote.devops.local)  
- **Result Service:** [http://result.devops.local](http://result.devops.local)

---

## 🎯 **Next Steps: High Availability (HA) for Redis & PostgreSQL**

The **next goal** is to switch **Redis** and **PostgreSQL** to **High Availability (HA) mode** using **Bitnami's Helm charts**:

### 🟢 **Planned Actions:**
1. Replace **custom Helm charts** for `redis` and `postgresql` with **Bitnami's HA charts**:
  

2. **Validate High Availability**:
   - Ensure **Redis Sentinel** is configured for failover.
   - Check **PostgreSQL replication status**.

3. **Update Documentation** with HA implementation details.

---

## 📋 **To-Do Checklist**

- [x] Set up **Helm directory** and create individual charts for `vote`, `result`, `worker`, `redis`, `postgresql`.
- [x] Add **Ingress** for `vote` and `result` services.
- [x] Configure `/etc/hosts` for local domain access.
- [x] Install all components using **Helm**.
- [x] Verify **vote** and **result** services in the **browser**.
- [ ] Convert **Redis** and **PostgreSQL** to **High Availability** using **Bitnami charts**.
- [ ] Validate **HA setup** and **test failover scenarios**.
- [ ] Update the **README.md** with **HA changes**.
