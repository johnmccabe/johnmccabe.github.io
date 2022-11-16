---
aliases:
- /technology/projects/openfaas-on-EKS/
categories:
- Technology
- Projects
date: "2018-06-05T00:00:00Z"
tags:
- cncf
- openfaas
- kubernetes
- project
- aws
- eks
title: Deploying OpenFaaS on AWS EKS
---
With todays release of [Amazons EKS platform](https://aws.amazon.com/eks/) I had a quick look at whats involved in deploying [OpenFaaS](https://www.openfaas.com) on EKS.

Turned out to be extremely straight forward by following both the [EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) and [OpenFaaS Kubernetes Guide](https://docs.openfaas.com/deployment/kubernetes/)

## Steps

- Follow the [EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) steps 1, 2 and 3.
- Follow the [OpenFaaS Kubernetes Guide](https://docs.openfaas.com/deployment/kubernetes/), remembering to `kubectl apply` the `cloud/lb.yaml` config to make the cluster public
- Get the gateways public address with:
    ```
    kubectl get svc -o wide -n openfaas gateway
    ```
  You can then connect to the gateway at that address on port `8080` via the UI or CLI.

And thats it, you have a running OpenFaaS cluster.

![center-aligned-image](/assets/openfaas-on-eks/openfaas-eks.png)

Now this initial run through was very brief, so I've not bothered setting up the Kong or Traefik OpenFaaS guides for SSL termination or auth yet, but I've no doubt that they'll be as straight forward to setup as the main platform.

Very impressed so far that it **just worked**.

Looking forward to seeing the tools that appear around this, fellow [OpenFaaS](https://www.openfaas.com/) contributor [@stefanprodan](https://twitter.com/stefanprodan) let us know about the [WeaveWorks](https://twitter.com/weaveworks) [`eksctl`](https://eksctl.io/) tool thats out already, will have to give that a crack as well, should drastically simplify the process.