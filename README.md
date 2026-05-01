# Projeto de Automacao de Infraestrutura e Orquestracao

Este repositorio apresenta o projeto final desenvolvido para a formacao na plataforma DIO.me. O escopo abrange o provisionamento de infraestrutura como codigo (IaC) e a gestao de containers, simulando fluxos reais de operacao e confiabilidade de sistemas (SRE).

### Tecnologias Implementadas
* **AWS CloudFormation**: Gerenciamento de stacks e recursos nativos AWS.
* **Terraform**: Provisionamento de infraestrutura escalavel via HCL.
* **Kubernetes (Minikube)**: Orquestracao de microservicos e gestao de replicas.
* **AWS CLI**: Administracao de servicos via interface de linha de comando.
* **Git**: Versionamento de codigo e controle de mudancas.

### Estrutura do Repositorio
* **/cloudformation**: Templates YAML para provisionamento de rede e computacao.
* **/terraform**: Modulos para automacao de VPC, Security Groups e instancias EC2.
* **/k8s**: Manifestos de Deployment e Service para orquestracao de containers.

### Procedimentos de Execucao

### Infraestrutura como Codigo (Terraform)
1. Inicializar o provider: `terraform init`
2. Validar o plano de execucao: `terraform plan`
3. Aplicar a infraestrutura: `terraform apply -auto-approve`

### Orquestracao de Containers (Kubernetes)
1. Iniciar o cluster local: `minikube start --driver=docker`
2. Aplicar manifestos: `kubectl apply -f k8s/nginx-deployment.yaml`
3. Validar status dos recursos: `kubectl get all`

### Resultados do Projeto
* **Padronizacao**: Implementacao de ambientes identicos e replicaveis via IaC.
* **Escalabilidade**: Configuracao de replicas de pods para alta disponibilidade.
* **Governança**: Controle rigoroso do ciclo de vida dos recursos para otimizacao de custos em nuvem.

### Autor
**Joao Breno da Silva**
* Estagiario na Deal Group
* Academico de Tecnologia da Informacao na Universidade Estacio de Sa
* Area de atuacao: DevOps, SRE e Automação de Infraestrutura

### Evidencia de Operacao (Kubernetes)
<img width="824" height="260" alt="k8s-evidence png" src="https://github.com/user-attachments/assets/8ebe4cee-79fb-4008-8048-c0783ba3267b" />


