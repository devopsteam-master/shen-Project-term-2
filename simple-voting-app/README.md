# Example Voting App - Kubernetes Deployment

## Quick Start

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/dockersamples/example-voting-app.git
   cd example-voting-app/k8s-specifications
   ```

2. **Deploy with Kubernetes:**

   Apply the manifests to create the resources:

   ```bash
   kubectl apply -f .
   ```

3. **Port Forward to Access Services:**

   - Forward the `vote` service:

     ```bash
     kubectl port-forward --address 0.0.0.0 service/vote 8080:8080
     ```

   - Forward the `result` service:

     ```bash
     kubectl port-forward --address 0.0.0.0 service/result 8081:8081
     ```

4. **Access the Services:**

   - Vote: [http://localhost:8080](http://localhost:8080) or [http://PUBLIC_IP:8080](http://localhost:8080)
   - Result: [http://localhost:8081](http://localhost:8081) or [http://PUBLIC_IP:8081](http://PUBLIC_IP:8081)
