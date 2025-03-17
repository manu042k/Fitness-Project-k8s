# Fitness-k8's

### Step 1: Apply Secrets and ConfigMaps (Recommended First Step)
> **Note:** While it's not mandatory to apply secrets first, it's strongly recommended to avoid deployment errors due to missing environment variables.

- Navigate to the `secrets` folder.
- Run the following command to apply all secrets:
  ```bash
  kubectl apply -f <yaml-file>
  ```
  Once done, verify using:
  ```bash
  kubectl get secrets
  ```
- Check for any ConfigMap YAML files in the same folder or elsewhere. If found, apply them similarly:
  ```bash
  kubectl apply -f <yaml-file>
  ```
  Once done, verify using:
  ```bash
  kubectl get configmaps
  ```

### Step 2: Deploy the Application
- Navigate to the respective folder containing the deployment files.
- Run the following command to deploy the resources:
  ```bash
  kubectl apply -f <yaml-file>
  ```
  After running the file, verify using:
   ```bash
    kubectl get deployments
    kubectl get pods
    ```

### Step 3: Verify Deployment Status
- Check if the deployment is ready and running:
  ```bash
  kubectl get deployments
  ```
- Verify pod status to ensure the application is running correctly:
  ```bash
  kubectl get pods
  ```
  - The `READY` column should display `1/1` for healthy pods.

### Step 4: Troubleshooting
- If the `READY` column shows `0/1` or any error, inspect the pod for details:
  ```bash
  kubectl describe pod <pod-name>
  ```
- To view error logs for further insights:
  ```bash
  kubectl logs <pod-name>
  ```

### Step 5: Accessing Pods and Databases
- To interact with a running pod's shell:
  ```bash
  kubectl exec -it <pod-name> -- /bin/sh
  ```
- For database pods (e.g., PostgreSQL), run the following command to access the database directly:
  ```bash
  kubectl exec -it <pod-name> -- psql -U <username> -d <db-name>
  ```
  - Use `postgres` as the database name in most cases
  - Using the **[exec -it]** command is a good way to verify if a pod is accessible and stable. Try running it on one of the pods in the deployment.

