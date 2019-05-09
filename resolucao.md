# Desafio 1 - Resolução
Escolho essa opcao de subir via ECS a aplicacao / contanier, 
pois os recursos entregam estabilidade e resiliência. e pronto para fall back   
## Objetivo:
    > Disponibilizar imagem da aplicacao para docker 
    > Criar estrutura no servico  AWS ECS  
    > obter ip publico da EC2 / docker
### Pre requisitos 
>  windows ou linux ou EC2 AMI linux ou Windows 
>  docker 
>  aws CLI    
#  Login AWS
## Será utilizado ECS -com o template da EC2  
estruturação da app
- estrutura de pastas - organização
- criacao do arquivo Dockerfile 
acessar AWS console, acessar serviço AWS ECR criar repositorio no AWS ECR - Nome:desafio
na maquina de desenvolvimento com docker      

### Login aws CLI -ok
# Para windows powershell
  `Invoke-Expression -Command (aws ecr get-login --no-include-email) `

## linux ou mac bash - 
   ` $(aws ecr get-login --no-include-email) `

## Build da imagem

  ` docker build -t desafio:1.0.0 .`

## tag  na imagem 
    
  ` docker tag desafio:1.0.0 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0 `

## Enviar para o ECR 

  ` docker push 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0 `

# Estrutura ECS 
*criar usa Key pair em EC2 > Network Security > Key pair*
## Criar task definition --- arquivo json com detalhes dessa criacao  
    Para criar o cluster usar acessar o AWS ECS 
    Selecionar em " Select cluster template" :  EC2 Linux + Networking  
    proximo passo 
##Configure cluster >  Cluster name : desafio-cluster
    
   > configure uma instancia - 
   > tipo:  t2.micro
   > qtd: 1 
   > ebs: 22 Gib
   > key pair (se criou): keypairdesafio  
   as demais etapas
   > configurar vpc, Subnets, Security group como default 
   >  
# task definition > Acessar o cluster item  task definition 
  > criar o arquivo  Container Definitions json cd.json (consta no repo)
ou 
> prencher com dados de configuracao da app 
    temos como entendimento: 
    Requires compatibilities: EC2
    imagem : 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0
    volume null
    portas 5000
    workdir(diretorio de trabalho da app) /app
> Executar o camando ou passar para o uso do json copiando e colar o container definition no Configure via JSON da task definition (disponivel na sessão linhas de comando) 

#Criar Servico  
no cluster Desafio aba "Service"  create 
>launch type: EC2
>Number of tasks:1  
>Configure network: conforme o default caso nao exista precisa criar
>Set Auto Scaling: Não -  obs um dos motivos de usar ECS é esse poder usar Auto Scaling nas app.
> Create service - ok  - ECS Service status - 4 of 4 complete
#Criar task 
>run task >  launch type: EC2
> informar cluster vpc (selecionar a default)
> informar uma subnet 
> run task 

# EC2 com o ip publico ou host ja eh possivel acessar a app. 

# gerando por linha de comando ou atualizando infra ECS 
### tudo por linhas de Comando  

## Passo 1:  Criar o Cluster
 ` aws ecs create-cluster --cluster-name Desafio-cluster`
## Passo 2: criar uma EC2 com a imagem: Amazon ECS AMI
exemplo amzn-ami-2018.03.p-amazon-ecs-optimized
https://console.aws.amazon.com/ec2/v2/home?region=us-east-2#LaunchInstanceWizard:ami=ami-0351a163d5f20e068
## Passo 3: checar se tudo foi criado EC2 executando o agent docker 1.27 (up 2019)
` aws ecs list-container-instances --cluster desafio-cluster `

## Paaso 4: validar e descrever o container definition
  `aws ecs describe-container-instances --cluster desafio-cluster --container-instances container_instance_ID`
## Passo 5: Register a Task Definition
  `aws ecs register-task-definition --cli-input-json file://cd.json`
## Passo 6: validar a Task Definitions
  `aws ecs list-task-definitions`
## Passo 7: Executar a Task
  `aws ecs run-task --cluster desafio-cluster --task-definition desafio:1 --count 1`
## Passo 8: validar Tasks
  `aws ecs list-tasks --cluster desafio-cluster` 
## Passo 9: validar a Running Task - status running. 
  `aws ecs describe-tasks --cluster desafio-cluster --task task_ID`

*Alguns testes realizado para deixar a infra ok*

#gerar o esqueleto do Container definition  (somente para conhecimento caso necessite validar o Container definition) 
`aws ecs register-task-definition --generate-cli-skeleton`
# 
# Executar comando para gerar versao nova task definition
### (premissa instalar o jq- json query windows choco install jq  )
`export CONTAINER_DEFINITION=$(cat cd.json)`
`export TASK_VERSION=$(aws ecs register-task-definition --family desafio-fam --container-definitions "$CONTAINER_DEFINITION" | jq --raw-output '.taskDefinition.revision')`
# Executar comando para ativar o servico e a tarefa nova 
`$(aws ecs update-service --cluster desafio-cluster --service desafio-service --task-definition desafio-fam:$TASK_VERSION | jq --raw-output '.service.serviceName')`



#
