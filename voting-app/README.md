# Voting App Docker Image Build and Push

This directory contains a script (`repush.sh`) that automates the process of building and pushing Docker images for the **vote**, **worker**, and **result** applications. The images are used to deploy the services with **Helm** in the Kubernetes cluster, which are connected to **Redis Sentinel** and **PostgreSQL HA**.

## 📝 **Overview**

The `repush.sh` script allows you to quickly **build and push** the Docker images for the `vote`, `worker`, and `result` services. This is useful when there are changes in any of these services, and you need to rebuild and push the updated images to **Docker Hub** for deployment.

### **Usage**

1. **Build and Push Docker Images**:
   The script prompts you to select which Docker image you want to build and push.

   **Run the script** with:
   ```bash
   ./repush.sh
   ```

2. **Select Which Image to Push**:
   You will be presented with the following choices:
   - `1. Vote`
   - `2. Worker`
   - `3. Result`
   - `4. All`

   Based on your selection, the script will:
   - Build the Docker image for the selected app (vote, worker, result).
   - Push the image to **Docker Hub** under the username `h0x3ein` (as defined in the script).

### **Details of the Script Logic**

- **Vote App**:
  The script will navigate to the `./vote/` directory, build the Docker image for the **vote** application, and push it to Docker Hub.

- **Worker App**:
  Similarly, the script will navigate to the `./worker/` directory, build the Docker image for the **worker** application, and push it to Docker Hub.

- **Result App**:
  The same process applies to the **result** application. The script will build and push the image for the result app located in the `./result/` directory.

- **All Applications**:
  If you choose option `4`, the script will build and push **all three images** (vote, worker, and result) in sequence.

### **Docker Image Naming Convention**

- **Vote Image**: `h0x3ein/examplevotingapp_vote`
- **Worker Image**: `h0x3ein/examplevotingapp_worker`
- **Result Image**: `h0x3ein/examplevotingapp_result`

### **Example**:

To rebuild and push the **vote** app image, select option `1`:
```bash
Select which Docker image to push:
1. Vote
2. Worker
3. Result
4. All
Enter your choice (1-4): 1
```

---

## 🚀 **Helm Deployment**

Once the Docker images are pushed to **Docker Hub**, they can be used in the **Helm deployment** for the `vote`, `worker`, and `result` services in your **Kubernetes** environment.

1. **Deploy with Helm**:
   After pushing the images, use the following commands to deploy or update the services via Helm:

   ```bash
   helm upgrade --install vote ./vote
   helm upgrade --install worker ./worker
   helm upgrade --install result ./result
   ```

2. **Redis Sentinel & PostgreSQL HA**:
   These apps are now connected to **Redis Sentinel** for session management and **PostgreSQL HA** for the database, which is configured through your Kubernetes manifests.

---

## 🔄 **Rebuilding and Pushing Images**

If you make changes to any of the `vote`, `worker`, or `result` services, you can rerun the script to rebuild and push the new images to Docker Hub.

1. Modify the code in the desired directory (`vote`, `worker`, or `result`).
2. Run `repush.sh` to rebuild and push the images to Docker Hub.

---

## 🛠 **Customization**

- You can modify the script to **change the Docker Hub username** or **customize the image tags** based on the environment (e.g., `dev`, `staging`, `prod`).
- The script is designed to be flexible, allowing you to select individual images or push all images with one command.

---

## ⚠️ **Important Notes**

- Ensure that **Docker** is running and you are **logged in** to your Docker Hub account before running the script.
- If you're pushing to a private Docker repository, make sure that the **authentication** credentials are set up in your Docker configuration.

---

### **Next Steps**:

- **Test the image deployment** in your **Kubernetes environment** to ensure everything is working correctly after pushing the images.
- **Monitor the deployed services** using **Prometheus** and **Grafana** to ensure that Redis Sentinel and PostgreSQL HA are functioning as expected.

