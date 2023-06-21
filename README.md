# BC Gov Platform Services

This repository is used to help setup an OpenShift Local environment with projects
setup in the same way BC Gov Platform Services does. The script will create the 
following namespace/projects.

* *plate*-tools
* *plate*-dev
* *plate*-test
* *plate*-prod

# Prerequisites

* OpenShift Local installed and started
* bash environment, git bash will work
* OpenShift CLI (oc) installed
* sed installed

# Usage

A `plate` or `license plate` is a random set of 6 lower case hexidecimal characters. There are 
two scripts `create.sh` and `delete.sh`. Both scripts will attempt to login to OpenShift Local
as `developer` prior to executing the operations.

## Create

To create a set of projects under a random plate,

```bash
./create.sh 
```

Will produce something along the lines of,

```
Logging in to OpenShift Local ...
Creating plate 4ddd55 ...
4ddd55-dev: Creating project ...
4ddd55-dev: Creating the default network policy...
4ddd55-dev: Creating same namespace network policy ...
4ddd55-dev: Creating ingress network policy ...
4ddd55-test: Creating project ...
4ddd55-test: Creating the default network policy...
4ddd55-test: Creating same namespace network policy ...
4ddd55-test: Creating ingress network policy ...
4ddd55-prod: Creating project ...
4ddd55-prod: Creating the default network policy...
4ddd55-prod: Creating same namespace network policy ...
4ddd55-prod: Creating ingress network policy ...
4ddd55-tools: Creating project ...
4ddd55-tools: Creating the default network policy...
4ddd55-tools: Creating role binding to allow image pull from 4ddd55-dev, 4ddd55-test and 4ddd55-prod namespaces...
```

To create a set of projects under a specific plate, ie to mirror your real environment,

```bash
./create.sh c0ffee
```

## Delete

To delete a plate,

```bash
./delete.sh c0ffee
```
