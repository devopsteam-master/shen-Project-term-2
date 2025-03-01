# 🚀 ETCD Backup to MinIO using Kubernetes CronJob

This guide provides step-by-step instructions to configure a **Kubernetes CronJob** to take an **ETCD backup** and upload it to **MinIO** securely. Ensure all required files are present in this repository before proceeding.

---

## 📦 **1. Prerequisites**

- Kubernetes cluster up and running (e.g., kind, minikube, or any cloud provider)
- `kubectl` configured to interact with the cluster
- **MinIO** properly installed and accessible via **S3 API**
- **MinIO Client (`mc`)** installed locally
- Proper **Ingress configuration** for **large file uploads**

---

## 📂 **2. Create Bucket and Configure MinIO**

### 🟢 **Create Bucket with CLI**

```sh
mc mb mecan/etcd-backup
mc ls mecan
```

### 🟢 **Create User (`etcd-backup`) with MinIO CLI**

```sh
mc admin user add mecan \
    etcd-backup \
    vsdcsfweek7BbHGddsdew7V73XqbigW
```

### 🟢 **Verify User Creation**

```sh
mc admin user ls mecan
```

### 🟢 **Create and Attach Policy for `etcd-backup` User**

```sh
mc admin policy create mecan \
    etcd-backup minio/etcd-backup-policy.json
mc admin policy ls mecan

mc admin policy attach mecan etcd-backup --user etcd-backup
mc admin policy entities mecan --user etcd-backup
```

---

## 📅 **3. Deploy Kubernetes CronJob for ETCD Backup**

### 🟢 **Apply CronJob Manifest**

```sh
kubectl apply -f manifest.yaml
kubectl get cronjobs -n kube-system
```

### 🟢 **Trigger Backup Manually (Optional)**

```sh
kubectl -n kube-system create job sample --from=cronjob/etcd-backup-cronjob
```

### 🟢 **Check Backup Status in MinIO**

```sh
mc ls mecan/etcd-backup
```

---

## 🚦 **4. Important NGINX Ingress Annotations for Large File Uploads**

Add the following **annotations** to **Ingress** to **support large file uploads**:

```yaml
nginx.ingress.kubernetes.io/proxy-body-size: "0"
nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
```

- **`proxy-body-size: "0"`**: Allows **unlimited upload size**.
- **`proxy-read-timeout: "600"`**: Extends the **read timeout**.
- **`proxy-send-timeout: "600"`**: Extends the **send timeout**.

---

## ✅ **5. Validation Steps**

- Confirm that **CronJob** is scheduled properly:

```sh
kubectl get cronjob -n kube-system
```

- Verify **manual job execution**:

```sh
kubectl get jobs -n kube-system
```

- Check the **MinIO bucket** for **successful backups**:

```sh
mc ls mecan/etcd-backup
```

- Review **Kubernetes pod logs** for **backup process**:

```sh
kubectl logs <backup-pod-name> -n kube-system
```

---

## 🛠️ **Troubleshooting**

- Ensure the **MinIO user and policy** are **correctly configured**.
- Validate **MinIO client (`mc`)** can **upload files manually**.
- Check for **Ingress errors** related to **file upload size**.

---

If you follow these steps, your **ETCD backups** will be securely **stored in MinIO**, and you'll have a **reliable recovery strategy** in place!

