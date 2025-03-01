# 🚀 Velero Installation and Backup/Restore Guide

This guide provides a step-by-step process for installing Velero, configuring it with an existing MinIO setup, and validating the setup by performing a backup and restore operation using Velero.

---

## 📦 **1. Prerequisites**

- An existing MinIO setup with:
  - `minio.devops.local` (MinIO Console)
  - `object.devops.local` (MinIO S3 API)
- Kubernetes cluster up and running (e.g., kind, minikube, or any cloud provider)
- `kubectl` configured to interact with the cluster
- `helm` installed on your local machine
- Velero CLI installed

```sh
127.0.0.1 minio.devops.local
127.0.0.1 object.devops.local
```

---

## ☁️ **2. Install Velero**

### 🟢 **Add Helm Repository and Install Velero**

```sh
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts/
helm repo update

helm upgrade --install velero vmware-tanzu/velero \
    --namespace velero \
    -f values.yaml \
    --create-namespace
```

### 🟢 **Download and Install Velero CLI**

```sh
wget https://github.com/vmware-tanzu/velero/releases/download/v1.15.2/velero-v1.15.2-linux-amd64.tar.gz
tar -xvf velero-v1.15.2-linux-amd64.tar.gz
sudo mv velero /usr/local/bin
```

---

## 🔍 **3. Test Backup and Restore with Velero**

### 🟢 **Check Backup Storage Location**

```sh
velero backup-location get
```

### 🟢 **Create a Backup for Ingress Resources**

```sh
velero backup create ingress-backup --include-resources ingress
```

### 🟢 **Describe the Backup**

```sh
velero backup describe ingress-backup
```

### 🟢 **Simulate Data Loss (Delete Ingress)**

```sh
kubectl delete -n monitoring ingress prometheus-stack-grafana
```

### 🟢 **Restore the Backup**

```sh
velero restore create ingress-restore --from-backup=ingress-backup
```

### 🟢 **Verify Restoration**

```sh
kubectl get ingress -n monitoring
```

---

## ✅ **4. Validation**

- Confirm that **Velero** can list **backup storage locations**
- Successfully create and restore a **backup** of the **ingress resource**

---

## 🚦 **Troubleshooting Tips**

- Check Velero logs:
```sh
kubectl logs -l app.kubernetes.io/name=velero -n velero
```

- Validate Ingress configuration:
```sh
kubectl describe ingress -n velero
```

