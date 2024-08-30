dvpdo - DeVelopment pod(PDO) manager utility
============================================

Toolkit that helps maintaining development pods on kubernetes.

## Quickstart

### Installation

Copy `/bin/dvpdo` to an adequate directory that is in the `$PATH` variable.

### Workspace site creation

```shell
$ mkdir workspace
$ cd workspace
$ dvpdo init
$ dvpdo apply
```

### Building and deploying the devpdo image

Builds the `Dockerfile` within the workspace and deploys it.

```shell
$ dppdo build
$ dvpdo push
```

### Using the workspace

```shell
$ pwd
... workspace ...
$ dvpdo up
```

```shell
$ pwd
... workspace ...
$ dvpdo down
```

## Commands

### `dvpdo login`
A facade for the `oc login` command of the `oc` CLI utility for openshift.
Asks for the credentials if kubernetes is not accessible.

### `dvpdo init`
Initialize a dvpdo site in a local directory. The `devpdo` utility
will initialize a workspace site with basic setup.

### `dvpdo apply`
Deploy the manifests to the target kubernetes namespace.
Run preliminary setup scripts.

### `dvpdo build`
Build the devpdo image.  The build is done remotely on openshift using the 

### `dvpdo start`
Start the dev pod environment. Update the site with the new image
if necessary.

### `dvpdo stop`
Stop or pause the dev pod.  Workspace isn't destroyed

### `dvpdo delete`
Delete all the manifests from kubernetes.
