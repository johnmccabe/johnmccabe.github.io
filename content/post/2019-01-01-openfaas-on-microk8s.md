---
aliases:
- /technology/projects/openfaas-on-microk8s/
categories:
- Technology
- Projects
date: "2019-01-01T00:00:00Z"
excerpt: As part of the seasonal home lab tidy-up I reinstalled Ubuntu Bionic Beaver
  (18.04) on my NUC and instead of using kubeadm to deploy Kubernetes I turned to
  Canonicals MicroK8s Snap and was blown away by the speed and ease with which I could
  get a basic lab environment up and running.
image:
  path: /assets/openfaas-on-microk8s/dobby_snap_openfaas.gif
  thumbnail: /assets/openfaas-on-microk8s/dobby_snap_openfaas.gif
tags:
- cncf
- openfaas
- kubernetes
- project
- ubuntu
- microk8s
title: Deploy OpenFaaS with MicroK8s
---

As part of the seasonal home lab tidy-up I reinstalled [Ubuntu Bionic Beaver (18.04)](http://releases.ubuntu.com/18.04/) on my [NUC](https://www.intel.com/content/www/us/en/products/docs/boards-kits/nuc/nuc-kit-nuc6i7kyk-features-configurations.html) and instead of using `kubeadm` to deploy Kubernetes I turned to [Canonicals MicroK8s Snap package](https://microk8s.io/) and was blown away by the speed and ease with which I could get a basic lab environment up and running.

This post takes you through the steps involved in getting MicroK8s up and running on an Ubuntu Bionic node and tops it off with deploying [OpenFaaS](https://www.openfaas.com/) and using it with the MicroK8s supplied registry addon.

[![asciicast](https://asciinema.org/a/219274.svg)](https://asciinema.org/a/219274)

## What is a Snap

![center-aligned-image](/assets/openfaas-on-microk8s/snapcraft.png)

A *Snap* is a universal package which can deployed on a wide range of Linux distributions, it bundles dependencies and config, simplifying installs to a single standard command. On the surface its quite similar to the recent [CNAB project](https://cnab.io/) but predates it by over 4 years, having started out as Click - Canonicals packaging solution for Mobile.

The `snap` CLI (also referred to as [Snapcraft](https://snapcraft.io/)) has been part of Ubuntu since Xenial (16.04) and can be installed on a wide selection of [other distros](https://docs.snapcraft.io/installing-snapd/6735).

## What is MicroK8s

MicroK8s is a Kubernetes distribution targetting workstations and applications, and is distributed as a single snap package that can be deployed on 42 flavours of Linux.

The project refers to the simplicity of getting up and running as being *zero-ops*, and I have to admit they're not overstating the ease with which you can deploy your own MicroK8s instance.

## Installing MicroK8s

The steps described in this post were carried out on a fresh Ubuntu Bionic installation.

1. Install MicroK8s using the Snapcraft CLI, having previously used Minikube for dev Kubernetes installs I was very surprised by the speed with which this completed - initially thinking that it hadn't worked.

    ```shell
    $ sudo snap install microk8s --classic
    microk8s v1.13.1 from Canonical✓ installed
    ```

2. You can display detailed information about the installed MicroK8s snap

    Here we can see the installed commands (all prefixed by `microk8s.`), services and Kubernetes version (`v1.13.1`).

    ```shell
    $ snap info microk8s
    name:      microk8s
    summary:   Kubernetes for workstations and appliances
    publisher: Canonical✓
    contact:   https://github.com/ubuntu/microk8s
    license:   unset
    description: |
      MicroK8s is a small, fast, secure, single node Kubernetes that installs on just about any Linux
      box. Use it for offline development, prototyping, testing, or use it on a VM as a small, cheap,
      reliable k8s for CI/CD. It's also a great k8s for appliances - develop your IoT apps for k8s and
      deploy them to MicroK8s on your boxes.
    commands:
      - microk8s.config
      - microk8s.disable
      - microk8s.docker
      - microk8s.enable
      - microk8s.inspect
      - microk8s.istioctl
      - microk8s.kubectl
      - microk8s.reset
      - microk8s.start
      - microk8s.status
      - microk8s.stop
    services:
      microk8s.daemon-apiserver:          simple, enabled, active
      microk8s.daemon-apiserver-kicker:   simple, enabled, active
      microk8s.daemon-controller-manager: simple, enabled, active
      microk8s.daemon-docker:             simple, enabled, active
      microk8s.daemon-etcd:               simple, enabled, active
      microk8s.daemon-kubelet:            simple, enabled, active
      microk8s.daemon-proxy:              simple, enabled, active
      microk8s.daemon-scheduler:          simple, enabled, active
    snap-id:      EaXqgt1lyCaxKaQCU349mlodBkDCXRcg
    tracking:     stable
    refresh-date: today at 11:23 GMT
    channels:
      stable:         v1.13.1  (354) 229MB classic
      candidate:      v1.13.1  (354) 229MB classic
      beta:           v1.13.1  (354) 229MB classic
      edge:           v1.13.1  (372) 229MB classic
      1.13/stable:    v1.13.1  (356) 229MB classic
      1.13/candidate: v1.13.1  (356) 229MB classic
      1.13/beta:      v1.13.1  (356) 229MB classic
      1.13/edge:      v1.13.1  (371) 229MB classic
      1.12/stable:    v1.12.4  (362) 251MB classic
      1.12/candidate: v1.12.4  (362) 251MB classic
      1.12/beta:      v1.12.4  (362) 251MB classic
      1.12/edge:      v1.12.4  (362) 251MB classic
      1.11/stable:    v1.11.6  (361) 245MB classic
      1.11/candidate: v1.11.6  (361) 245MB classic
      1.11/beta:      v1.11.6  (361) 245MB classic
      1.11/edge:      v1.11.6  (361) 245MB classic
      1.10/stable:    v1.10.12 (364) 200MB classic
      1.10/candidate: v1.10.12 (364) 200MB classic
      1.10/beta:      v1.10.12 (364) 200MB classic
      1.10/edge:      v1.10.12 (364) 200MB classic
    installed:        v1.13.1  (354) 229MB classic
    ```

3. Wait for MicroK8s to complete its startup before proceeding.
    ```shell
    $ microk8s.status --wait-ready
    microk8s is running
    addons:
    gpu: disabled
    storage: disabled
    registry: disabled
    ingress: disabled
    dns: disabled
    metrics-server: disabled
    istio: disabled
    dashboard: disabled
    ```

4. The base MicroK8s install is bare-bones so we want to install some of the provided addons.

5. Enable the DNS Addon which deploys `kube-dns` for us.
    ```shell
    $ microk8s.enable dns
    Enabling DNS
    Applying manifest
    service/kube-dns created
    serviceaccount/kube-dns created
    configmap/kube-dns created
    deployment.extensions/kube-dns created
    Restarting kubelet
    DNS is enabled
    ```

6. Enable the Registry Addon which deploys a docker private registry and expose it on localhost:32000. The storage addon will be enabled as part of this addon.

    The storage addon creates volumes in `/var/snap/microk8s/common/default-storage`.

    ```shell
    $ microk8s.enable registry
    Enabling the private registry
    Enabling default storage class
    deployment.extensions/hostpath-provisioner unchanged
    storageclass.storage.k8s.io/microk8s-hostpath unchanged
    Storage will be available soon
    Applying registry manifest
    namespace/container-registry created
    persistentvolumeclaim/registry-claim created
    deployment.extensions/registry created
    service/registry created
    The registry is enabled
    ```

7. MicroK8s provides the `kubectl` CLI out of the box which allows us to take a look at whats going on.

    ```shell
    $ microk8s.kubectl get nodes
    NAME   STATUS   ROLES    AGE   VERSION
    nuc    Ready    <none>   41m   v1.13.1

    $ microk8s.kubectl get all --namespace kube-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    pod/hostpath-provisioner-599db8d5fb-qcbn2   1/1     Running   0          16s
    pod/kube-dns-6ccd496668-9k4kl               3/3     Running   0          22s

    NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
    service/kube-dns   ClusterIP   10.152.183.10   <none>        53/UDP,53/TCP   22s

    NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/hostpath-provisioner   1/1     1            1           16s
    deployment.apps/kube-dns               1/1     1            1           22s

    NAME                                              DESIRED   CURRENT   READY   AGE
    replicaset.apps/hostpath-provisioner-599db8d5fb   1         1         1       16s
    replicaset.apps/kube-dns-6ccd496668               1         1         1       22s

    ```

8. Create snap aliases for the `kubectl` and `docker` commands.

    **NOTE:** we need to alias `docker` so that the `faas-cli` command can function.

    ```shell
    sudo snap alias microk8s.kubectl kubectl
    sudo snap alias microk8s.docker docker
    ```

9. [Optional] You can also enable the dashboard if desired.

    ```shell
    $ microk8s.enable dashboard
    Enabling dashboard
    secret/kubernetes-dashboard-certs created
    serviceaccount/kubernetes-dashboard created
    deployment.apps/kubernetes-dashboard created
    service/kubernetes-dashboard created
    service/monitoring-grafana created
    service/monitoring-influxdb created
    service/heapster created
    deployment.extensions/monitoring-influxdb-grafana-v4 created
    serviceaccount/heapster created
    configmap/heapster-config created
    configmap/eventer-config created
    deployment.extensions/heapster-v1.5.2 created
    dashboard enabled
    ```

    And then expose the dashboard using `kubectl proxy`, note that I'm making it accesible from other hosts in my lab network here.

    ```shell
    kubectl proxy --address='0.0.0.0' --accept-hosts='^localhost$,^nuc$'
    ```

## Installing OpenFaaS

We can now install OpenFaaS using `kubectl` as described on the [docs site](https://docs.openfaas.com/deployment/kubernetes/#b-deploy-using-kubectlyaml-for-development-only).

1. Clone the faas-netes repository.

    ```shell
    $ git clone https://github.com/openfaas/faas-netes
    Cloning into 'faas-netes'...
    remote: Enumerating objects: 20, done.
    remote: Counting objects: 100% (20/20), done.
    remote: Compressing objects: 100% (15/15), done.
    remote: Total 4720 (delta 3), reused 12 (delta 3), pack-reused 4700
    Receiving objects: 100% (4720/4720), 4.73 MiB | 5.17 MiB/s, done.
    Resolving deltas: 100% (2560/2560), done.
    ```

2. Create the OpenFaaS Namespaces.

    ```shell
    $ cd faas-netes
    $ kubectl apply -f ./namespaces.yml
    namespace/openfaas created
    namespace/openfaas-fn created
    ```

3. Deploy OpenFaaS.

    ```shell
    $ kubectl apply -f ./yaml
    configmap/alertmanager-config created
    deployment.apps/alertmanager created
    service/alertmanager created
    deployment.apps/gateway created
    service/gateway created
    deployment.apps/nats created
    service/nats created
    configmap/prometheus-config created
    deployment.apps/prometheus created
    service/prometheus created
    deployment.apps/queue-worker created
    serviceaccount/faas-controller created
    role.rbac.authorization.k8s.io/faas-controller created
    rolebinding.rbac.authorization.k8s.io/faas-controller-fn created
    ```

4. Confirm OpenFaaS is deployed.

    ```shell
    $ kubectl get deployments --namespace openfaas
    NAME           READY   UP-TO-DATE   AVAILABLE   AGE
    alertmanager   1/1     1            1           40s
    gateway        1/1     1            1           40s
    nats           1/1     1            1           40s
    prometheus     1/1     1            1           40s
    queue-worker   1/1     1            1           40s
    ```

5. The UI will now be accessible on port `31112`, as I'm connecting remotely I access this via [http://nuc:31112/ui/](http://nuc:31112/ui/) (you may want to connect to [http://localhost:31112/ui/](http://localhost:31112/ui/) if you've deployed this locally).

## Creating a Function

The process for creating a function is standard with one small requirement, you must set the image prefix to `localhost:32000` as we'll be using the registry addon enabled in the earlier sections.

1. Install the OpenFaaS CLI as described [here](https://docs.openfaas.com/cli/install/).

2. Create a new function, setting the `--gateway` and `--prefix` flags appropriately.

    As mentioned above you *must* set the prefix to `localhost:32000`, if you are running locally you can omit the `--gateway` flag completely and use the default.

    ```shell
    $ faas-cli new --lang python --gateway http://nuc:31112 --prefix localhost:32000 myecho
    2019/01/01 12:56:50 No templates found in current directory.
    2019/01/01 12:56:50 Attempting to expand templates from https://github.com/openfaas/templates.git
    2019/01/01 12:56:51 Fetched 14 template(s) : [csharp dockerfile go go-armhf java8 node node-arm64 node-armhf php7 python python-armhf python3 python3-armhf ruby] from https://github.com/openfaas/templates.git
    Folder: myecho created.
      ___                   _____           ____
    / _ \ _ __   ___ _ __ |  ___|_ _  __ _/ ___|
    | | | | '_ \ / _ \ '_ \| |_ / _` |/ _` \___ \
    | |_| | |_) |  __/ | | |  _| (_| | (_| |___) |
    \___/| .__/ \___|_| |_|_|  \__,_|\__,_|____/
          |_|


    Function created in folder: myecho
    Stack file written: myecho.yml
    ```

3. Build the function.

    ```shell
    $ faas-cli build -f ./myecho.yml
    [0] > Building myecho.
    Clearing temporary build folder: ./build/myecho/
    Preparing ./myecho/ ./build/myecho/function
    Building: localhost:32000/myecho:latest with python template. Please wait..
    Sending build context to Docker daemon  8.192kB
    Step 1/25 : FROM python:2.7-alpine
    2.7-alpine: Pulling from library/python
    cd784148e348: Pull complete
    30f71ecab593: Pull complete
    ed606575a835: Pull complete
    9c862b3c365f: Pull complete
    Digest: sha256:bf950979b88495f4d36091499a99eff17c28709231768af3b0e17c7f35243942
    Status: Downloaded newer image for python:2.7-alpine
    ---> 66c225e226f9
    ...snip...
    Step 25/25 : CMD ["fwatchdog"]
    ---> Running in 5eb337e01000
    Removing intermediate container 5eb337e01000
    ---> 87d651b5e184
    Successfully built 87d651b5e184
    Successfully tagged localhost:32000/myecho:latest
    Image: localhost:32000/myecho:latest built.
    [0] < Building myecho done.
    [0] worker done.
    ```

4. Deploy the function.

    ```shell
    $ faas-cli push -f ./myecho.yml
    [0] > Pushing myecho [localhost:32000/myecho:latest].
    The push refers to repository [localhost:32000/myecho]
    50682314b263: Pushed
    ...snip...
    7bff100f35cb: Pushed
    latest: digest: sha256:e78d0e594e5833511f901fa6123491d617dc295419c4c7540e0001b56111107a size: 3655
    [0] < Pushing myecho [localhost:32000/myecho:latest] done.
    [0] worker done.
    ```

    ```shell
    $ faas-cli deploy -f ./myecho.yml
    Deploying: myecho.

    Deployed. 202 Accepted.
    URL: http://nuc:31112/function/myecho
    ```

5. List the deployed functions.

    ```shell
    $ faas-cli ls
    Function                        Invocations     Replicas
    myecho                          0               1
    ```

6. Invoke the function.

    ```shell
    $ echo "Hello MicroK8s" | faas-cli invoke -f myecho.yml myecho
    Hello MicroK8s
    ```


## Optional Extras

### Install Specific Kubernetes Release

You can install a specific version of Kubernetes by setting the `--channel`. To see a list of the available channels you can run the `snap info microk8s` command (see earlier in the post for example output).

For example, to install `1.12/stable`.

```shell
snap install microk8s --classic --channel=1.12/stable
```

### Snap Environment Variables

As the Snap environments are self-contained you need to run a shell inside a snap command to query their settings, for example the Storage Addon creates a directory under `$SNAP_COMMON`, we can check what thats set to by running the `env` command inside the `microk8s.kubectl` shell.

```shell
snap run --shell microk8s.kubectl
env
```