# fluxcd-webui

Experimental Dockerimage for [FluxCD v2 webui](https://github.com/fluxcd/webui)

## kubeconfig file

The file needs at least the following "permissions" to the Cluster API:
```
- apiGroups:
  - "source.toolkit.fluxcd.io"
  - "kustomize.toolkit.fluxcd.io"
  - "helm.toolkit.fluxcd.io"
  resources:
  - gitrepositories
  - helmrepositories
  - helmcharts
  - buckets
  - kustomizations
  - helmreleases
  verbs:
  - get
  - list
  - update
- apiGroups:
  - ""
  resources:
  - namespaces
  - events
  verbs:
  - list
- apiGroups:
  - "apps"
  resources:
  - deployments
  verbs:
  - list
```

## Run the image

In order for the UI to access the Cluster API, the kubeconfig file needs to be mounted inside the container.

`docker run -d -p 8080:9000 -v /local-path/.kube/config:/root/.kube/config adrianberger/fluxcd-webui`
