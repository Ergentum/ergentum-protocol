#!/bin/bash

# =============================================================================
# ERGENTUM AI NETWORK — NODE ONBOARDING SCRIPT
# =============================================================================
# Script para instalar e registar um node na rede Ergentum testnet
# =============================================================================

set -e  # Exit on error

# Configurações
PROJECT_ID="previewFZSkdGLmFoPnhmBeaabqATX4Y1Q0Jz4f"
BASE_URL="https://cardano-preview.blockfrost.io/api/v0"
SCRIPT_ADDR="addr_test1wrymtz3fpqqt2zlmkxg2j747zdm678x9lkkc6zpj5mdhjsqqw2qnx"
POLICY_ID="f0aed7733ac89c0ad46bccb3f9b730edec6ccfbc68b2c7890019540b"
TOKEN_NAME="ERGON"
TOKEN_HEX="4552474f4e"
TESTNET_MAGIC=2

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =============================================================================
# 1. VERIFICAR DEPENDÊNCIAS
# =============================================================================
check_dependencies() {
    log_info "Verificando dependências..."
    
    # Verificar cardano-cli
    if command -v cardano-cli &> /dev/null; then
        CARDANO_VERSION=$(cardano-cli --version | head -n1)
        log_success "Cardano CLI encontrado: $CARDANO_VERSION"
    else
        log_error "cardano-cli não encontrado. Instale com:"
        echo "  curl -sS -L https://github.com/IntersectMBO/cardano-node/releases/latest/download/cardano-node-*-linux.tar.gz | tar -xz"
        echo "  sudo cp cardano-node-*/bin/* /usr/local/bin/"
        exit 1
    fi
    
    # Verificar Python3
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        log_success "Python3 encontrado: $PYTHON_VERSION"
        
        # Verificar módulo requests
        if python3 -c "import requests" &> /dev/null; then
            log_success "Módulo Python 'requests' instalado"
        else
            log_warning "Módulo 'requests' não encontrado. Instalando..."
            pip3 install requests --quiet
            log_success "Módulo 'requests' instalado"
        fi
    else
        log_error "Python3 não encontrado. Instale com:"
        echo "  sudo apt-get install python3 python3-pip"
        exit 1
    fi
    
    # Verificar Aiken (opcional)
    if command -v aiken &> /dev/null; then
        AIKEN_VERSION=$(aiken --version)
        log_success "Aiken encontrado: $AIKEN_VERSION"
    else
        log_warning "Aiken não encontrado (opcional para desenvolvimento)"
    fi
    
    log_success "Todas as dependências verificadas ✓"
}

# =============================================================================
# 2. CRIAR WALLET NOVA
# =============================================================================
create_wallet() {
    log_info "Criando nova wallet para o node..."
    
    # Criar directório para a wallet
    WALLET_DIR="ergentum_node_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$WALLET_DIR"
    cd "$WALLET_DIR"
    
    # Gerar chaves
    log_info "Gerando chaves de pagamento..."
    cardano-cli address key-gen \
        --verification-key-file payment.vkey \
        --signing-key-file payment.skey
    
    # Gerar endereço
    log_info "Gerando endereço testnet..."
    cardano-cli address build \
        --payment-verification-key-file payment.vkey \
        --testnet-magic $TESTNET_MAGIC \
        --out-file payment.addr
    
    NODE_ADDRESS=$(cat payment.addr)
    log_success "Wallet criada em: $(pwd)"
    log_success "Endereço do node: $NODE_ADDRESS"
    
    # Mostrar instruções para faucet
    echo ""
    log_info "📋 INSTRUÇÕES PARA OBTER tADA:"
    echo "  1. Vai a: https://docs.cardano.org/cardano-testnet/tools/faucet"
    echo "  2. Seleciona 'Preview Testnet'"
    echo "  3. Coloca o endereço: $NODE_ADDRESS"
    echo "  4. Pede 1000 tADA (suficiente para registar node)"
    echo ""
    
    cd ..
}

# =============================================================================
# 3. AGUARDAR CONFIRMAÇÃO DE FUNDOS
# =============================================================================
wait_for_funds() {
    log_info "Aguardando confirmação de fundos..."
    
    cd "$WALLET_DIR"
    NODE_ADDRESS=$(cat payment.addr)
    
    while true; do
        log_info "Verificando saldo..."
        
        # Usar Blockfrost para verificar saldo
        RESPONSE=$(curl -s -H "project_id: $PROJECT_ID" \
            "$BASE_URL/addresses/$NODE_ADDRESS")
        
        if echo "$RESPONSE" | grep -q "amount"; then
            # Extrair saldo em lovelace
            LOVELACE=$(echo "$RESPONSE" | grep -o '"lovelace":"[^"]*"' | cut -d'"' -f4)
            
            if [ -n "$LOVELACE" ] && [ "$LOVELACE" -gt 10000000 ]; then  # > 10 tADA
                ADA=$((LOVELACE / 1000000))
                log_success "Fundos confirmados! Saldo: $ADA tADA"
                break
            else
                log_info "Saldo insuficiente ou pendente. Aguardando 30 segundos..."
                sleep 30
            fi
        else
            log_info "Endereço ainda não encontrado na blockchain. Aguardando 30 segundos..."
            sleep 30
        fi
    done
    
    cd ..
}

# =============================================================================
# 4. ESCOLHER TIER DO NODE
# =============================================================================
choose_tier() {
    log_info "Escolha o tier do seu node:"
    echo ""
    echo "  1) Light Node"
    echo "     - Stake mínimo: 1,000 ERGON"
    echo "  1) Light Node"
    echo "     - Hardware: VPS, CPU, 3-7B modelo"
    echo "     - Recompensas: 1.0× base"
    echo "     - Stake: voluntário (mais stake = mais multiplicador)"
    echo ""
    echo "  2) Standard Node"
    echo "     - Hardware: RTX 3060+, 13-34B modelo"
    echo "     - Recompensas: 1.3× base"
    echo "     - Stake: voluntário"
    echo ""
    echo "  3) Professional Node"
    echo "     - Hardware: RTX 4090+, 70B modelo"
    echo "     - Recompensas: 2.0× base"
    echo "     - Stake: voluntário"
    echo ""
    echo "  4) Sovereign Node"
    echo "     - Hardware: 2x RTX 4090+, 70B local, zero APIs"
    echo "     - Recompensas: 4.0× base"
    echo "     - Stake: voluntário"
    echo ""
    
    while true; do
        read -p "Selecione o tier (1-4): " TIER_CHOICE
        
        case $TIER_CHOICE in
            1)
                TIER_NAME="Light"
                TIER_VALUE=1
                STAKE_MIN=1000  # Sugerido, não obrigatório
                break
                ;;
            2)
                TIER_NAME="Standard"
                TIER_VALUE=2
                STAKE_MIN=10000  # Sugerido, não obrigatório
                break
                ;;
            3)
                TIER_NAME="Professional"
                TIER_VALUE=3
                STAKE_MIN=50000  # Sugerido, não obrigatório
                break
                ;;
            4)
                TIER_NAME="Sovereign"
                TIER_VALUE=4
                STAKE_MIN=100000  # Sugerido, não obrigatório
                break
                ;;
            *)
                log_error "Opção inválida. Tente novamente."
                ;;
        esac
    done
    
    log_success "Tier selecionado: $TIER_NAME"
    log_info "Requisitos de hardware: $TIER_NAME"
    
    # Informar sobre stake voluntário
    echo ""
    log_info "📝 NOTA SOBRE STAKE:"
    echo "   O stake é VOLUNTÁRIO — não é obrigatório para registar o node."
    echo "   No entanto, stake adicional aumenta o multiplicador de recompensas:"
    echo "   - Sem stake: multiplicador base do tier"
    echo "   - Com stake: multiplicador aumentado proporcionalmente"
    echo ""
    log_info "ERGON tokens estão disponíveis através do faucet da comunidade."
}

# =============================================================================
# 5. REGISTAR NODE NO CONTRATO
# =============================================================================
register_node() {
    log_info "Preparando registo do node no contrato..."
    
    cd "$WALLET_DIR"
    
    # Obter VKey Hash do node
    log_info "Obtendo VKey Hash..."
    VKEY_HASH=$(cardano-cli address key-hash \
        --payment-verification-key-file payment.vkey)
    
    # Criar datum para o node
    log_info "Criando datum para node $TIER_NAME..."
    cat > node_datum.json << DATUM_EOF
{
 "constructor": 0,
 "fields": [
   {"bytes": "$VKEY_HASH"},
   {"int": $TIER_VALUE},
   {"int": $STAKE_MIN},
   {"constructor": 0, "fields": []}
 ]
}
DATUM_EOF
    
    log_success "Datum criado:"
    cat node_datum.json
    echo ""
    
    # Verificar UTXOs disponíveis
    log_info "Verificando UTXOs disponíveis..."
    RESPONSE=$(curl -s -H "project_id: $PROJECT_ID" \
        "$BASE_URL/addresses/$NODE_ADDRESS/utxos")
    
    # Encontrar primeiro UTXO com ADA
    TX_HASH=$(echo "$RESPONSE" | grep -o '"tx_hash":"[^"]*"' | head -1 | cut -d'"' -f4)
    TX_INDEX=$(echo "$RESPONSE" | grep -o '"output_index":[0-9]*' | head -1 | cut -d':' -f2)
    
    if [ -z "$TX_HASH" ]; then
        log_error "Nenhum UTXO encontrado. Verifique se tem tADA no endereço."
        exit 1
    fi
    
    log_success "UTXO encontrado: ${TX_HASH}#${TX_INDEX}"
    
    # Calcular valores (modo dry-run primeiro)
    log_info "Calculando valores da transacção..."
    
    # Obter quantidade de ADA no UTXO
    LOVELACE=$(echo "$RESPONSE" | grep -o '"lovelace":"[^"]*"' | head -1 | cut -d'"' -f4)
    ADA=$((LOVELACE / 1000000))
    
    # Valores estimados
    FEE=1000000  # 1 tADA
    TO_CONTRACT=2000000  # 2 tADA para contrato
    CHANGE=$((LOVELACE - FEE - TO_CONTRACT))
    
    if [ "$CHANGE" -lt 1000000 ]; then  # Menos de 1 tADA de troco
        log_error "Saldo insuficiente para fee + contrato. Precisa de pelo menos 3 tADA."
        exit 1
    fi
    
    log_info "Valores calculados:"
    log_info "  Input: $ADA tADA"
    log_info "  Fee: 1 tADA"
    log_info "  Para contrato: 2 tADA"
    log_info "  Troco: $((CHANGE / 1000000)) tADA"
    
    # Perguntar se quer continuar
    read -p "Deseja submeter a transacção? (s/n): " CONFIRM_SUBMIT
    
    if [[ "$CONFIRM_SUBMIT" != "s" && "$CONFIRM_SUBMIT" != "S" ]]; then
        log_warning "Transacção cancelada pelo utilizador (modo dry-run)"
        log_success "Script executado em modo de teste. Para submeter realmente, execute novamente e confirme."
        exit 0
    fi
    
    # Construir transacção
    log_info "Construindo transacção..."
    cardano-cli transaction build-raw \
        --tx-in "${TX_HASH}#${TX_INDEX}" \
        --tx-out "$SCRIPT_ADDR+$TO_CONTRACT" \
        --tx-out-datum-hash-file node_datum.json \
        --tx-out "$NODE_ADDRESS+$CHANGE" \
        --fee $FEE \
        --out-file register_node.raw
    
    # Assinar transacção
    log_info "Assinando transacção..."
    cardano-cli transaction sign \
        --tx-body-file register_node.raw \
        --signing-key-file payment.skey \
        --testnet-magic $TESTNET_MAGIC \
        --out-file register_node.signed
    
    # Submeter via Blockfrost
    log_info "Submetendo transacção via Blockfrost..."
    
    # Converter para CBOR
    CBOR_HEX=$(python3 -c "
import json
with open('register_node.signed') as f:
    tx = json.load(f)
print(tx['cborHex'])
")
    
    # Submeter
    RESPONSE=$(curl -s -X POST \
        -H "project_id: $PROJECT_ID" \
        -H "Content-Type: application/cbor" \
        --data "$(echo $CBOR_HEX | xxd -r -p)" \
        "$BASE_URL/tx/submit")
    
    if echo "$RESPONSE" | grep -q '^"[0-9a-f]*"$'; then
        TX_HASH=$(echo "$RESPONSE" | tr -d '"')
        log_success "✅ Transacção submetida com sucesso!"
        echo "$TX_HASH" > tx_hash.txt
    else
        log_error "Erro ao submeter transacção: $RESPONSE"
        exit 1
    fi
    
    cd ..
}

# =============================================================================
# 6. MOSTRAR RESUMO FINAL
# =============================================================================
show_summary() {
    log_info "📊 RESUMO DO REGISTO DO NODE"
    echo ""
    echo "  Endereço do node: $NODE_ADDRESS"
    echo "  Tier selecionado: $TIER_NAME"
    echo "  Stake sugerido: $STAKE_MIN ERGON (voluntário)"
    echo "  TX Hash de registo: $TX_HASH"
    echo ""
    echo "  🔗 Verificar no explorer:"
    echo "  https://preview.cardanoscan.io/transaction/$TX_HASH"
    echo ""
    echo "  📁 Ficheiros guardados em: $WALLET_DIR/"
    echo "    - payment.vkey / payment.skey (chaves do node)"
    echo "    - payment.addr (endereço)"
    echo "    - node_datum.json (datum do registo)"
    echo "    - tx_hash.txt (hash da transacção)"
    echo ""
    log_success "✅ Node registado com sucesso na rede Ergentum!"
    echo ""
    echo "  Próximos passos:"
    echo "  1. Aguardar confirmação da transacção (2-3 minutos)"
    echo "  2. Configurar o software do node"
    echo "  3. Participar na rede e começar a ganhar recompensas"
    echo ""
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================
main() {
    clear
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║        ERGENTUM AI NETWORK — NODE ONBOARDING            ║"
    echo "║                Cardano Preview Testnet                  ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    
    # 1. Verificar dependências
    check_dependencies
    
    # 2. Criar wallet
    create_wallet
    
    # 3. Aguardar fundos
    wait_for_funds
    
    # 4. Escolher tier
    choose_tier
    
    # 5. Registar node
    register_node
    
    # 6. Mostrar resumo
    show_summary
}

# Executar função principal
main "$@"
