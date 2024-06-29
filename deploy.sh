#!/usr/bin/bash

PSQL_VOLUME_PATH=/mnt/pv/psql

create() {
    microk8s.kubectl create -f yaml/psql-service.yaml
    microk8s.kubectl create -f yaml/psql-configmap.yaml
    microk8s.kubectl create -f yaml/psql-volume.yaml
    microk8s.kubectl create -f yaml/psql-deployment.yaml
}

delete() {
    microk8s.kubectl delete -f yaml/psql-deployment.yaml
    microk8s.kubectl delete -f yaml/psql-volume.yaml
    microk8s.kubectl delete -f yaml/psql-configmap.yaml
    microk8s.kubectl delete -f yaml/psql-service.yaml

    if [ -d "$PSQL_VOLUME_PATH" ]; then
        echo "Deleting PostgreSQL volume...."
        rm -rf "$PSQL_VOLUME_PATH"
    fi
}

case "$1" in
  --create)
    create
    ;;
  --delete)
    delete
    ;;
  *)
    echo "Usage: $0 {--create|--delete}"
    exit 1
    ;;
esac
