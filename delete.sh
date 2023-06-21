#!/usr/bin/env bash

if [[ -z $1 || ! $1 =~ ^[a-f0-9]{6}$ ]]; then
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

echo "Deleting plate $PLATE ..."

for suffix in tools dev test prod
do
  NS=${PLATE}-${suffix}
  oc get project ${NS} > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "${NS}: deleting project ..."
    oc delete project ${NS} > /dev/null
  else
    echo "${NS}: Project does not exist..."
  fi
done
