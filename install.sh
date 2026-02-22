#!/bin/bash

# 1. Criar diretórios necessários
echo "Criando diretórios..."
mkdir -p /data/coolify/custom_configs

# 2. Baixar os arquivos de Bypass do SEU GitHub
# Substitua 'SEU_USUARIO' pelo seu nome no GitHub
RAW_URL="https://raw.githubusercontent.com/SEU_USUARIO/meu-chatwoot-unlocked/main"

echo "Baixando arquivos de configuração..."
curl -sSL "$RAW_URL/configs/fazer_ai_hub.rb" -o /data/coolify/custom_configs/fazer_ai_hub.rb
curl -sSL "$RAW_URL/configs/features_helper.rb" -o /data/coolify/custom_configs/features_helper.rb

# 3. Baixar o docker-compose.yml
curl -sSL "$RAW_URL/docker-compose.yml" -o /data/coolify/docker-compose.yml

echo "Arquivos instalados com sucesso em /data/coolify/custom_configs/"
echo "Agora basta importar o docker-compose no seu Coolify."
