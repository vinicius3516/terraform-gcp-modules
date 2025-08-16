# Módulos Terraform para Google Cloud Platform (GCP)

Este repositório contém uma coleção de módulos Terraform reutilizáveis para provisionar recursos no Google Cloud Platform (GCP).  
Cada módulo é projetado para ser autônomo e facilmente integrado em diferentes projetos Terraform, promovendo a reutilização de código e as melhores práticas de IaC (Infrastructure as Code).

## Pré-requisitos

Antes de utilizar estes módulos, garanta que você tenha:

- **Terraform** instalado (versão 1.0.0 ou superior).
- Uma **Conta GCP** ativa.
- **gcloud CLI** configurado com as credenciais apropriadas.
- Um **projeto GCP** configurado, com a **API do Compute Engine e GKE habilitadas**.

## Módulos Disponíveis

Abaixo está a lista de módulos atualmente disponíveis neste repositório.  
Para adicionar um novo módulo, crie um novo diretório em `modules/` e atualize esta tabela.

| Módulo | Descrição |
| :--- | :--- |
| `vpc` | Cria uma Virtual Private Cloud (VPC) no GCP, incluindo sub-redes, tabelas de rotas e firewall rules. |
| `gke` | Provisiona um cluster do Google Kubernetes Engine (GKE), incluindo nós e configurações de rede. |

## Como Usar

Para utilizar um módulo em seu projeto Terraform, adicione um bloco `module` ao seu código, apontando para o diretório do módulo desejado.  
Lembre-se de sempre conferir as variáveis requeridas por cada módulo.

### Exemplo: Utilizando o módulo VPC

```hcl
module "gke" {
  source            = "git::https://github.com/vinicius3516/terraform-gcp-modules.git//modules/gke?ref=main"
  environment       = var.environment
  region            = var.region
  project_id        = var.project_id
  vpc_name          = module.vpc.vpc_name
  subnet_name       = module.vpc.subnet_name
  master_cidr       = var.master_cidr
  gke_num_nodes     = var.gke_num_nodes
  preemptible_nodes = var.preemptible_nodes
  machine_type      = var.machine_type
  disk_size_gb      = var.disk_size_gb
  min_node_count    = var.min_node_count
  max_node_count    = var.max_node_count
}

