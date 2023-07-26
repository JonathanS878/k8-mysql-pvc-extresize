#!/bin/bash

cd ./MySQL

kubectl create ns mysql

kubectl apply -f storage-class.yaml -n mysql
kubectl apply -f service-mysql.yaml -n mysql
kubectl apply -f secret-mysql.yaml -n mysql
kubectl apply -f pvc-mysql.yaml -n mysql
kubectl apply -f deployment-mysql.yaml -n mysql

echo "successfully applied all"
