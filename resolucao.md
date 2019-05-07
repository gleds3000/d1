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
executar o camando para passar o uso do json  ou colar na aba json da task definition 

#Criar Servico 

# Criar task 





#Criar cluster 

#criar servico 

#Criar task 
