provider "azurerm" {
  features {}
}

module "aks" {
  source = "git@github.com:flavius-dinu/terraform-az-aks.git?ref=v1.0.3"
  kube_params = {
    kube1 = {
      name                = "kube1"
      rg_name             = "rg1"
      rg_location         = "westeurope"
      dns_prefix          = "kube"
      identity            = [{}]
      enable_auto_scaling = false
      max_count           = 1
      min_count           = 1
      node_count          = 1
      np_name             = "kube1"
      export_kube_config  = true
      kubeconfig_path     = "./config"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = module.aks.kube_config_path["kube1"]
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = module.aks.kube_config["kube1"].0.host
#     username               = module.aks.kube_config["kube1"].0.username
#     password               = module.aks.kube_config["kube1"].0.password
#     client_certificate     = base64decode(module.aks.kube_config["kube1"].0.client_certificate)
#     client_key             = base64decode(module.aks.kube_config["kube1"].0.client_key)
#     cluster_ca_certificate = base64decode(module.aks.kube_config["kube1"].0.cluster_ca_certificate)
#   }
# }

module "helm" {
  source = "git@github.com:flavius-dinu/terraform-helm-release.git?ref=v1.0.0"
  helm = {
    argo = {
      name             = "argocd"
      repository       = "https://argoproj.github.io/argo-helm"
      chart            = "argo-cd"
      create_namespace = true
      namespace        = "argocd"
    }
  }
}
