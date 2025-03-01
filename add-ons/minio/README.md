# 🚀 MinIO Installation and Configuration Guide

The **MinIO** object storage is a high-performance, **S3-compatible solution** that is ideal for **storing backup data**, including use cases with **Velero** for **Kubernetes backup and restore**. This guide covers **installation**, **console-based configuration**, and **setup for Velero integration**.

---

## 📦 **1. Prerequisites**

- **Kubernetes cluster** up and running.
- **Helm** installed (`helm version` to verify).
- **MinIO Client (`mc`)** installed on your **local machine**.
- **Ingress Controller** (e.g., **NGINX Ingress**) installed and configured.

---

## 📝 **2. Update `/etc/hosts` File**

Add the following entries to your **`/etc/hosts`** file:

```plaintext
127.0.0.1 minio.devops.local
127.0.0.1 object.devops.local
```

- **`minio.devops.local`**: Used to **access MinIO Console**.
- **`object.devops.local`**: **S3 endpoint** for **MinIO Client (`mc`)**.

---

## ⚙️ **3. Install MinIO Using Helm**

### 🟢 **Step 1: Add MinIO Helm Repository**

```sh
helm repo add minio https://charts.min.io/
helm repo update
```

---

### 🟢 **Step 2: Prepare `values.yaml` for MinIO Installation**

The `values.yaml` is exist in the directory

---

### 🟢 **Step 3: Deploy MinIO**

```sh
helm upgrade --install minio minio/minio \
    --namespace minio \
    -f values.yaml \
    --create-namespace
```

---

### 🔍 **Step 4: Verify MinIO Installation**

```sh
kubectl get all -n minio
```

#### **Expected Output:**

```plaintext
NAME                                      READY   STATUS    RESTARTS   AGE
pod/minio-0                               1/1     Running   0          2m

NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/minio              ClusterIP   10.96.123.45     <none>        9000/TCP   2m
service/minio-console      ClusterIP   10.96.67.89      <none>        9001/TCP   2m

NAME                                  READY   AGE
statefulset.apps/minio                 1/1     2m
```

---

## 🌐 **5. Access MinIO Console**

- **URL:** [https://minio.devops.local](https://minio.devops.local)
- **Login Credentials:**
  - **Username:** `adminasdasdasd`
  - **Password:** `admiasdasdasdn`

---

## 🧪 **6. Configure MinIO with MinIO Client (`mc`)**

---

### 🟢 **1. Create a Bucket for Velero Backups**

1. **Set MinIO Alias in `mc`:**

```sh
mc alias set Mecan http://object.devops.local/ adminasdasdasd admiasdasdasdn
```

2. **List Existing Buckets:**

```sh
mc ls Mecan
```

3. **Create a New Bucket:**

```sh
mc mb Mecan/velero-backup
```

4. **Verify the Bucket Creation:**

```sh
mc ls Mecan
```

#### **Expected Output:**

```plaintext
[2025-02-25 10:49:41 +0330]     0B velero-backup/
```

---

### 🟢 **2. Create a User for Velero**

1. **List Existing Users:**

```sh
mc admin user list Mecan
```

2. **Create a New User (`velero`):**

```sh
mc admin user add Mecan velero yPqyTVtTDBsqI3vfo9D8QK5isZnznhhlFEBKiH
```

3. **Verify the New User:**

```sh
mc admin user list Mecan
```

---

### 🟢 **3. Create and Apply a Policy for Velero**

1. **List Existing Policies:**

```sh
mc admin policy list Mecan
```

2. **Create a Policy File (`velero-policy.json`):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::velero-backup"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::velero-backup/*"
      ]
    }
  ]
}
```

3. **Apply the Policy to MinIO:**

```sh
mc admin policy create Mecan velero ./velero-policy.json
```

4. **Verify the Policy Creation:**

```sh
mc admin policy list Mecan
```

---

### 🟢 **4. Attach the Policy to the Velero User**

```sh
mc admin policy attach Mecan velero --user velero
```

5. **Verify Policy Attachment:**

```sh
mc admin policy list Mecan
```

---

## 🛠️ **7. Validate MinIO and Velero Readiness**

- **Test Bucket Accessibility** with the **Velero User**:

```sh
mc ls Mecan/velero-backup
```

- **Ensure User Permissions** by **uploading and deleting a test file**:

```sh
echo "test content" > testfile.txt
mc cp testfile.txt Mecan/velero-backup
mc rm Mecan/velero-backup/testfile.txt
```

---

## 📋 **8. Troubleshooting Tips**

### 🚨 **Issue:** Cannot Access MinIO Console

- Verify **Ingress Status**:

```sh
kubectl get ingress -n minio
```

- Check **Pod Logs** for Errors:

```sh
kubectl logs -l app=minio -n minio
```

---

### 🚨 **Issue:** `mc` Fails to Connect to MinIO

- Ensure the **alias** is set up correctly:

```sh
mc alias list
```

- Verify **MinIO service availability**:

```sh
curl -k https://object.devops.local
```

---

## 🔄 **9. Cleanup Resources**

```sh
helm uninstall minio -n minio
kubectl delete namespace minio
```

---

## 🚦 **10. Next Steps**

- Integrate **MinIO** with **Velero** for **Kubernetes backups**.
- Set up **scheduled backups** and **data retention policies**.
- Monitor **MinIO health** and **bucket status** using **Grafana dashboards**.

---

## 📂 **References**

- [MinIO Documentation](https://min.io/docs/)
- [MinIO Client (`mc`) Documentation](https://min.io/docs/minio/linux/reference/minio-mc.html)
- [Helm Chart for MinIO](https://artifacthub.io/packages/helm/minio/minio)
