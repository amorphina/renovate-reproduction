resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "oci://gitlab.example.com:5000/group/subgroup"
  chart            = "my-chart"
  create_namespace = true
  namespace        = "argocd"
  skip_crds        = false
  version          = "2.0.0"
  values = [
    file("${path.module}/config/argocd/values.yaml")
  ]
  set {
    name  = "argo-cd.configs.repositories.gitops.username"
    value = var.argocd_git_username
  }
  set {
    name  = "argo-cd.configs.repositories.gitops.password"
    value = sensitive(var.argocd_git_password)
  }
  set {
    name  = "app_config.targetRevision"
    value = var.app_config_targetrevision
  }
  set {
    name  = "argo-cd.configs.repositories.gitops.url"
    value = var.argocd_git_url
  }

  lifecycle {
    ignore_changes = [
      values,
      version,
      chart,
      repository,
    ]

  }

}
