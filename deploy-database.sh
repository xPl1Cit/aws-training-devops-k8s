#!/bin/bash

kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
helm install backend-db oci://registry-1.docker.io/bitnamicharts/postgresql