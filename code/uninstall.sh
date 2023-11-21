#!/bin/sh
oc patch k8sgpt k8sgpt-local-ai -p '{"metadata":{"finalizers":null}}' --type=merge -n k8sgpt-operator-system
oc delete k8sgpt k8sgpt-local-ai -n k8sgpt-operator-system
helm uninstall release -n k8sgpt-operator-system 
helm uninstall local-ai  -n default