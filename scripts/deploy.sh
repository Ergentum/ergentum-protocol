#!/bin/bash
# deploy.sh
# Script de deploy para o smart contract Ergentum Node Registration

set -e

echo "🚀 Iniciando deploy do contrato Ergentum Node Registration..."

# Configurar PATH para Aiken
export PATH="/home/daazlabs/.aiken/bin:$PATH"

# Navegar para o directório do projecto
cd /home/daazlabs/ergentum/ergentum

echo "📦 Verificando dependências..."
aiken check

echo "🔧 Compilando smart contract..."
aiken build

echo "🧪 Executando testes..."
if aiken test; then
    echo "✅ Todos os testes passaram!"
else
    echo "❌ Testes falharam. Corrigir antes do deploy."
    exit 1
fi

echo "📊 Gerando script compilado..."
# O Aiken gera os scripts compilados automaticamente
# Eles estarão disponíveis em ./plutus.json

echo "🎯 Preparando para deploy na testnet..."
echo "Nota: Para deploy real, precisas de:"
echo "1. Cardano CLI configurado"
echo "2. Wallet com funds para fees"
echo "3. Endereço para onde enviar o script"
echo ""
echo "Comandos sugeridos para deploy:"
echo "# cardano-cli address build --payment-script-file plutus.json --testnet-magic 1097911063 --out-file script.addr"
echo "# cardano-cli transaction build --tx-in <UTXO> --tx-out $(cat script.addr)+2000000 --tx-out-datum-hash-file datum.json --change-address <YOUR_ADDRESS> --testnet-magic 1097911063 --out-file tx.raw"
echo "# cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file payment.skey --testnet-magic 1097911063 --out-file tx.signed"
echo "# cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063"

echo ""
echo "✅ Smart contract compilado e testado com sucesso!"
echo "📁 Script compilado: ./plutus.json"
echo "📁 Endereço do script: ./script.addr (após executar cardano-cli)"
