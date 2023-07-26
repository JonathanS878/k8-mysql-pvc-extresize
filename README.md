## Overview
In this project, we will apply the following files to set up and test a MySQL deployment on Kubernetes:
- `deployment-mysql.yaml`
- `pvc-mysql.yaml`
- `secret-mysql.yaml`
- `service-mysql.yaml`
- `storage-class.yaml`

By following the instructions below, we will ensure that our PersistentVolumeClaim (PVC) is consistent, and our data is properly preserved.

## Prerequisites
Before getting started, ensure you have the following tools installed on your system:
- kubectl
- minikube

Also, you need to have `mysql-server` installed to connect to the database. Install it using the following command:
```bash
sudo apt install mysql-server
```

## Preparation
1. Change the MySQL root password to base64 and update the `secret-mysql.yaml` file with the encoded password.
   ```bash
   echo -n 'Sht@DlER424' | base64
   ```
   Copy the output and paste it into the `secret-mysql.yaml` file under `data.MYSQL_ROOT_PASSWORD`.

2. Clone this repository:
   ```bash
   git clone <repository_url>
   ```

3. Apply all files using the provided script:
   ```bash
   ./apply-all.sh
   ```

Great! Now we are all set to proceed with the extresize process.

## Extresize Steps
1. Ensure that the MySQL pod is in the "Running" status:
   ```bash
   kubectl get all -n mysql
   ```

2. Get the service URL to connect to the MySQL database:
   ```bash
   minikube service mysql -n mysql
   ```

3. Connect to the MySQL database using the following command. Replace `<enter_port>` with the actual port obtained from the previous step:
   ```bash
   mysql --host=127.0.0.1 --port=<enter_port> --user=jondoe --password mysql-db
   ```

4. Enter the password when prompted:
   ```
   Enter password: Sht@DlER424
   ```

5. Create a table named "employees" in the "mysql-db" database to check if the PVC is consistent:
   ```sql
   USE mysql-db;
   CREATE TABLE employees (
       id INT PRIMARY KEY,
       name VARCHAR(50) NOT NULL,
       age INT,
       department VARCHAR(50),
       email VARCHAR(100),
       salary DECIMAL(10, 2)
   );
   SHOW TABLES;
   ```

6. Delete the pod to simulate a failure:
   ```bash
   kubectl delete pod --all -n mysql
   ```

7. Ensure that the MySQL pod is in the "Running" status again. The replicaset will automatically create a new pod:
   ```bash
   kubectl get all -n mysql
   ```

8. Get the service URL again, as the port might have changed:
   ```bash
   minikube service mysql -n mysql
   ```

9. Connect again to the MySQL database using the same command as before:
   ```bash
   mysql --host=127.0.0.1 --port=<enter_port> --user=jondoe --password mysql-db
   ```

10. Enter the password when prompted:
    ```
    Enter password: Sht@DlER424
    ```

11. Enter the "mysql-db" database and check if the table "employees" still exists:
    ```sql
    USE mysql-db;
    SHOW TABLES;
    ```

If you see the table "employees" after performing the above steps, congratulations! Our PersistentVolumeClaim is working correctly. Well done! ;)  