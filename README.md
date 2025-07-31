# kubectl-project1
Multi-service bookstore application using Kubernetes in Minikube. Includes backend services, frontend, database, API gateway (Ingress), autoscaling, monitoring, secrets, config, CI/CD readiness, and rollback simulations.


                     [ External User ]
                            |
                      [ Ingress Controller ]
                            |
                ----------------------------
               |             |             |
           [frontend]   [api-gateway]   [metrics]
               |             |
               |         ------------       
               |        |    |    |   |
               |    [user] [book] [order]
               |             |
               |         [mysql/postgres]


| Component       | Description                                    |
| --------------- | ---------------------------------------------- |
| `frontend`      | React or static HTML web frontend              |
| `api-gateway`   | Node.js/Express proxy routing to microservices |
| `user-service`  | Auth/registration microservice (Node/Python)   |
| `book-service`  | Book catalog (Go/Python)                       |
| `order-service` | Order placement, confirmation                  |
| `mysql`         | MySQL or PostgreSQL database                   |
| `prometheus`    | Metrics & monitoring                           |
| `grafana`       | Dashboards                                     |


| Feature             | Where it’s applied                                          |
| ------------------- | ----------------------------------------------------------- |
| **Deployments**     | All services                                                |
| **Services**        | Internal service-to-service communication                   |
| **Ingress**         | API gateway or frontend ingress with hostname routing       |
| **ConfigMaps**      | ENV vars for DB host, feature toggles, etc.                 |
| **Secrets**         | DB password, API tokens                                     |
| **Health Probes**   | Readiness and liveness checks in all microservices          |
| **HPA**             | Autoscale book-service based on CPU                         |
| **Rolling Updates** | Push new frontend image and test `kubectl rollout` commands |
| **Rollback**        | Simulate failed deployment and rollback                     |
| **Helm**            | Package the entire setup as a Helm chart (or subcharts)     |
| **RBAC**            | Limit access for monitoring tools                           |
| **Volumes**         | PVCs for MySQL or Redis                                     |
| **Monitoring**      | Prometheus + Grafana for pod/app monitoring                 |


Steps:
1. initialize minikube
```minikube start --cpus=4 --memory=8192```
```minikube addons enable ingress```
```minikube addons enable metrics-server```

2. deploy database (mysql folder):
- mysql-pvc
- mysql-secret the mysql root password
- mysql-service headless for service which require stable network identities for their pods, allowing direct access for tasks like replication, sharding, or failover. 
- mysql-statefulset, the mysql statefulset

```cd mysql```
```kubectl apply -f .```
```kubectl exec -it mysql-0 -- mysql -u root -p mysql``` - password123 by default change in mysql-secret with encode64

3. deploy book service
- For this one I created a simple mock (using flask python) book-service container image and pushed it to my docker hub (5upreme/book-service)

```cd book-service```
```kubectl apply -f .```

to test:
```
kubectl run debug --rm -it --image=curlimages/curl -- sh

# Inside:
curl http://book-service.default.svc.cluster.local
curl http://book-service.default.svc.cluster.local/health
```

4. deploy api-gateway, frontend & ingress
- containerize the api-gateway, frontend & apply the yamls
- enable ingress in the minikube (if this one doesn't install the nginx ingress controller, go to ingress and execute the .sh script), make sure the ip is right in /etc/hosts (don't forget to minikube tunnel)


PROGRESS UPDATE:
I am separating the docker-mock-app to another repo, to practice Github actions, the best practice for the pipeline, linting, testing and etc.

Separating front-end & api-gateway. Will add the rollbacks, updates and etc to the kubectl soon.
