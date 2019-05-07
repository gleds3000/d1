''' Desafio 1 - Resolução'''
Escolho essa opcao de subir via ECS a aplicacao / contanier, 
pois os recursos entregam estabilidade e resiliência. e pronto para fall back   
### Objetivo:
    - Disponibilizar imagem da aplicacao para docker 
    - Criar estrutura no servico  AWS ECS  
    - obter ip publico da EC2 / docker
##  Login AWS
# Será utilizado ECS -no template da EC2  
estruturação da app
- estrutura de pastas - organização
- criacao do arquivo Dockerfile 
acessar AWS console, acessar serviço AWS ECR criar repositorio no AWS ECR - Nome:desafio
na maquina de desenvolvimento com docker      

## Login aws CLI 
# Para windows powershell
    Invoke-Expression -Command (aws ecr get-login --no-include-email)

# linux ou mac bash - 
    $(aws ecr get-login --no-include-email)

## Build da imagem

    # docker build -t desafio:1.0.0 .

## tag  na imagem 
    
    # docker tag desafio:1.0.0 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0

## Enviar para o ECR 

    # docker push 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0

#Estrutura ECS 

##Criar task definition --- arquivo json com detalhes dessa criacao  
    Para criar o cluster usar acessar o AWS ECS 
    Selecionar em " Select cluster template" :  EC2 Linux + Networking  
    proximo passo 
   # Configure cluster >  Cluster name : desafio-cluster
    marcar opcao criar vazio : Create an empty cluster
    
# task definition > Acessar o cluster item  task definition 
criar o arquivo  Container Definitions json cd.json (consta no repo)
ou 
prencher com dados de configuracao da app 
    temos como entendimento: 
    Requires compatibilities: EC2
    imagem : 694252404448.dkr.ecr.us-east-1.amazonaws.com/desafio:1.0.0
    volume null
    portas 5000
    workdir(diretorio de trabalho da app) /app
executar o camando ou passar para o uso do json copiando e colar o container definition no Configure via JSON da task definition 

linha de Comando 
#gerar o esqueleto do Container definition 
aws ecs register-task-definition --generate-cli-skeleton
#Executar comando para gerar versao nova 
###(premissa instalar o jq- json query windows choco install jq  )
export CONTAINER_DEFINITION=$(cat cd.json)
export TASK_VERSION=$(aws ecs register-task-definition --family desafio-fam --container-definitions "$CONTAINER_DEFINITION" | jq --raw-output '.taskDefinition.revision')
#executar comando para ativar o servico e a tarefa nova 
    $(aws ecs update-service --cluster desafio-cluster --service desafio-service --task-definition desafio-fam:$TASK_VERSION | jq --raw-output '.service.serviceName')


#Criar Servico 

# Criar task 





#Criar cluster 

#criar servico 

#Criar task 
