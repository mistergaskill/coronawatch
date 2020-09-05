# Setup
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Install minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

# Running
`minikube start --driver=<driver_name>`
172.17.0.1

# How to Connect to the Database
>Config found in docker-compose.yml and postgres.env

jdbc:postgresql://localhost:5432/coronawatch