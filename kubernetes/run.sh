# https://github.com/bitnami/charts/tree/master/bitnami/minio
# https://github.com/traefik/traefik-helm-chart

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=" --no-deploy traefik --no-deploy kubernetes-dashboard"  sh -

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

helm upgrade --install traefik -f traefik/traefik.yaml traefik/traefik
helm upgrade --install minio -f minio/minio.yaml bitnami/minio

