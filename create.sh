#!/usr/bin/env bash

if [[ -z $1 ]]; then
  PLATE=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 6 | head -n 1)
elif [[ ! $1 =~ ^[a-f0-9]{6}$ ]]; then
  echo "Invalid plate specified, must be 6 lowercase hex characters: $1"
  exit 1
else
  PLATE=$1
fi

echo "Logging in to OpenShift Local ..."
oc login -u developer https://api.crc.testing:6443 > /dev/null
if [ $? -ne 0 ]; then
  echo "Error logging into OpenShift Local, has it been started?"
  exit 2
fi

echo "Creating plate $PLATE ..."

for suffix in dev test prod tools
do
  NS=${PLATE}-${suffix}
  oc get project ${NS} > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${NS}: deleting project ..."
    oc delete project ${NS} > /dev/null
  fi
  echo "${NS}: Creating project ..."
  oc new-project ${NS} --skip-config-write=true > /dev/null
  echo "${NS}: Creating the default network policy..."
  oc apply -n ${NS} -f network-policies/platform-services-controlled-default.yaml > /dev/null

  if [[ "${suffix}" != "tools" ]]; then
    echo "${NS}: Creating same namespace network policy ..."
    oc apply -n ${NS} -f network-policies/allow-same-namespace.yaml > /dev/null
    echo "${NS}: Creating ingress network policy ..."
    oc apply -n ${NS} -f network-policies/allow-from-openshift-ingress.yaml > /dev/null
  else
    # create the permissions to pull from dev, test or prod
    echo "${NS}: Creating role binding to allow image pull from ${PLATE}-dev, ${PLATE}-test and ${PLATE}-prod namespaces..."
    sed -e "s/xxxxxx/$PLATE/g" role-bindings/project-image-puller.yaml | oc apply -n ${NS} -f - > /dev/null
  fi
done
