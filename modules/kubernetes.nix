{ pkgs, ... }:

# Client tooling for k3s/Argo CD work. Clusters run inside Docker through k3d
# (`k3d cluster create`), so this module needs modules/docker.nix and adds no
# system services: deleting a cluster leaves nothing behind on the host.
{
  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
    kustomize
    k3d
    k9s
    argocd
    kubeseal
    kubeconform
    cmctl
    openssl
  ];
}
