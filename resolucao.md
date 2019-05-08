# Desafio 1 - Resolução'''
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

    ` docker build -t desafio:1.0.0 . `

## tag  na imagem 
    
    ` docker tag desafio:1.0.0 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0 `

## Enviar para o ECR 

   `  docker push 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0 `

#Estrutura ECS 
### criar usa Key pair em EC2 > Network Security > Key pair
##Criar task definition --- arquivo json com detalhes dessa criacao  
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
#Criar task 


### linhas de Comando 
#gerar o esqueleto do Container definition  (somente para conhecimento caso necessite validar o Container definition) 
aws ecs register-task-definition --generate-cli-skeleton
#Executar comando para gerar versao nova task definition
###(premissa instalar o jq- json query windows choco install jq  )
`export CONTAINER_DEFINITION=$(cat cd.json)`
`export TASK_VERSION=$(aws ecs register-task-definition --family desafio-fam --container-definitions "$CONTAINER_DEFINITION" | jq --raw-output '.taskDefinition.revision')`
#executar comando para ativar o servico e a tarefa nova 
`$(aws ecs update-service --cluster desafio-cluster --service desafio-service --task-definition desafio-fam:$TASK_VERSION | jq --raw-output '.service.serviceName')`


