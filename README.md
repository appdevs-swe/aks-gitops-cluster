# aks-gitops-cluster


## Provision cluster

Create a resource group
`az group create -n bg-gitops-rg -l westeurope`

Deploy the bicep templates to the resource group

`az deployment group create -g bg-gitops-rg --template-file deploy/bicep/main.bicep`

## Setup OSM

Install `osm cli`

Linux example:
```
release=v1.1.0
curl -L https://github.com/openservicemesh/osm/releases/download/${release}/osm-${release}-linux-amd64.tar.gz | tar -vxzf -
sudo mv ./linux-amd64/osm /usr/local/bin/osm
osm version
```

Install OSM controll plane:

```
export osm_namespace=osm-system # Replace osm-system with the namespace where OSM will be installed
export osm_mesh_name=osm # Replace osm with the desired OSM mesh name

osm install \
    --mesh-name "$osm_mesh_name" \
    --osm-namespace "$osm_namespace" \
    --set=osm.enablePermissiveTrafficPolicy=true \
    --set=osm.deployPrometheus=true \
    --set=osm.deployGrafana=true \
    --set=osm.deployJaeger=true
```

Alternative: Add OSM add-on (might not work as we can't install prometheus and grafana)

```
az aks enable-addons \
  --resource-group bg-gitops-rg \
  --name bg-gitops \
  --addons open-service-mesh
```

## Setup Flux

Install `flux cli`

```
curl -s https://fluxcd.io/install.sh | sudo bash
. <(flux completion bash)
flux install
```

Alternative: Add GitOps add-on

```
az k8s-extension create -g bg-gitops-rg -c bg-gitops -t managedClusters --name flux --extension-type microsoft.flux
```

## Setup Flagger


Install flagger helm chart

```
helm repo add flagger https://flagger.app
helm upgrade -i flagger flagger/flagger \
--namespace=osm-system \
--set crd.create=false \
--set meshProvider=osm \
--set metricsServer=http://osm-prometheus.osm-system.svc:7070
```

Setup the load tester

```
helm upgrade -i flagger-loadtester flagger/loadtester \
--namespace=apps \
--set cmd.timeout=1h \
--set cmd.namespaceRegexp=''
```

## Setup Ingress controller

```
NAMESPACE=ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"=kpbggitops
```



