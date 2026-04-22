#!/bin/bash

# =============================================================================
# ERGENTUM AI NETWORK — NODE ONBOARDING SCRIPT
# =============================================================================
# Script to install and register a node on the Ergentum testnet
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
    log_info "Checking dependencies..."
    
    # Verificar cardano-cli
    if command -v cardano-cli &> /dev/null; then
        CARDANO_VERSION=$(cardano-cli --version | head -n1)
        log_success "Cardano CLI found: $CARDANO_VERSION"
    else
        log_error "cardano-cli not found. Instale com:"
        echo "  curl -sS -L https://github.com/IntersectMBO/cardano-node/releases/latest/download/cardano-node-*-linux.tar.gz | tar -xz"
        echo "  sudo cp cardano-node-*/bin/* /usr/local/bin/"
        exit 1
    fi
    
    # Verificar Python3
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        log_success "Python3 found: $PYTHON_VERSION"
        
        # Verificar módulo requests
        if python3 -c "import requests" &> /dev/null; then
            log_success "Python module .requests. installed"
        else
            log_warning "Module .requests. not found. Instalando..."
            pip3 install requests --quiet
            log_success "Module .requests. installed"
        fi
    else
        log_error "Python3 not found. Instale com:"
        echo "  sudo apt-get install python3 python3-pip"
        exit 1
    fi
    
    # Verificar Aiken (opcional)
    if command -v aiken &> /dev/null; then
        AIKEN_VERSION=$(aiken --version)
        log_success "Aiken found: $AIKEN_VERSION"
    else
        log_warning "Aiken not found (optional for development)"
    fi
    
    log_success "All dependencies verified ✓"
}

# =============================================================================
# 2. CRIAR WALLET NOVA
# =============================================================================
create_wallet() {
    log_info "Creating new wallet for the node..."
    
    # Criar directório para a wallet
    WALLET_DIR="ergentum_node_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$WALLET_DIR"
    cd "$WALLET_DIR"
    
    # Gerar chaves
    log_info "Generating payment keys..."
    cardano-cli address key-gen \
        --verification-key-file payment.vkey \
        --signing-key-file payment.skey
    
    # Gerar address
    log_info "Generating testnet address..."
    cardano-cli address build \
        --payment-verification-key-file payment.vkey \
        --testnet-magic $TESTNET_MAGIC \
        --out-file payment.addr
    
    NODE_ADDRESS=$(cat payment.addr)
    log_success "Wallet created at: $(pwd)"
    log_success "Node address: $NODE_ADDRESS"
    
    # Mostrar instruções para faucet
    echo ""
    log_info "📋 INSTRUCTIONS TO GET tADA:"
    echo "  1. Go to: https://docs.cardano.org/cardano-testnet/tools/faucet"
    echo "  2. Select .Preview Testnet."
    echo "  3. Enter the address: $NODE_ADDRESS"
    echo "  4. Request 1000 tADA (enough to register node)"
    echo ""
    
    cd ..
}

# =============================================================================
# 3. AGUARDAR CONFIRMAÇÃO DE FUNDOS
# =============================================================================
wait_for_funds() {
    log_info "Waiting for funds confirmation..."
    
    cd "$WALLET_DIR"
    NODE_ADDRESS=$(cat payment.addr)
    
    while true; do
        log_info "Checking balance..."
        
        # Usar Blockfrost para verificar saldo
        RESPONSE=$(curl -s -H "project_id: $PROJECT_ID" \
            "$BASE_URL/addresses/$NODE_ADDRESS")
        
        if echo "$RESPONSE" | grep -q "amount"; then
            # Extrair saldo em lovelace
            LOVELACE=$(echo "$RESPONSE" | grep -o '"lovelace":"[^"]*"' | cut -d'"' -f4)
            
            if [ -n "$LOVELACE" ] && [ "$LOVELACE" -gt 10000000 ]; then  # > 10 tADA
                ADA=$((LOVELACE / 1000000))
                log_success "Funds confirmed! Balance: $ADA tADA"
                break
            else
                log_info "Insufficient or pending balance. Waiting 30 seconds..."
                sleep 30
            fi
        else
            log_info "Address not yet found on blockchain. Waiting 30 seconds..."
            sleep 30
        fi
    done
    
    cd ..
}

# =============================================================================
# 4. ESCOLHER TIER DO NODE
# =============================================================================
choose_tier() {
    log_info "Choose your node tier:"
    echo ""
    echo "  1) Light Node"
    echo "     - Stake mínimo: 1,000 ERGON"
    echo "  1) Light Node"
    echo "     - Hardware: VPS, CPU, 3-7B model"
    echo "     - Rewards: 1.0× base"
    echo "     - Stake: voluntary (more stake = higher multiplier)"
    echo ""
    echo "  2) Standard Node"
    echo "     - Hardware: RTX 3060+, 13-34B model"
    echo "     - Rewards: 1.3× base"
    echo "     - Stake: voluntary"
    echo ""
    echo "  3) Professional Node"
    echo "     - Hardware: RTX 4090+, 70B model"
    echo "     - Rewards: 2.0× base"
    echo "     - Stake: voluntary"
    echo ""
    echo "  4) Sovereign Node"
    echo "     - Hardware: 2x RTX 4090+, 70B local, zero APIs"
    echo "     - Rewards: 4.0× base"
    echo "     - Stake: voluntary"
    echo ""
    
    while true; do
        read -p "Select tier (1-4): " TIER_CHOICE
        
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
                log_error "Invalid option. Try again."
                ;;
        esac
    done
    
    log_success "Tier selected: $TIER_NAME"
    log_info "Hardware requirements: $TIER_NAME"
    
    # Informar sobre stake voluntário
    echo ""
    log_info "📝 NOTE ABOUT STAKE:"
    echo "   Stake is VOLUNTARY — not required to register the node."
    echo "   However, additional stake increases the reward multiplier:"
    echo "   - No stake: base tier multiplier"
    echo "   - With stake: multiplier increased proportionally"
    echo ""
    log_info "ERGON tokens are available through the community faucet."
}

# =============================================================================
# 5. REGISTAR NODE NO CONTRATO
# =============================================================================
register_node() {
    log_info "Preparing node registration on the contract..."
    
    cd "$WALLET_DIR"
    
    # Obter VKey Hash do node
    log_info "Getting VKey Hash..."
    VKEY_HASH=$(cardano-cli address key-hash \
        --payment-verification-key-file payment.vkey)
    
    # Criar datum para o node
    log_info "Creating datum for node $TIER_NAME..."
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
    log_info "Checking available UTXOs..."
    RESPONSE=$(curl -s -H "project_id: $PROJECT_ID" \
        "$BASE_URL/addresses/$NODE_ADDRESS/utxos")
    
    # Encontrar primeiro UTXO com ADA
    TX_HASH=$(echo "$RESPONSE" | grep -o '"tx_hash":"[^"]*"' | head -1 | cut -d'"' -f4)
    TX_INDEX=$(echo "$RESPONSE" | grep -o '"output_index":[0-9]*' | head -1 | cut -d':' -f2)
    
    if [ -z "$TX_HASH" ]; then
        log_error "No UTXO found. Check if you have tADA at the address."
        exit 1
    fi
    
    log_success "UTXO found: ${TX_HASH}#${TX_INDEX}"
    
    # Calcular valores (modo dry-run primeiro)
    log_info "Calculating transaction values..."
    
    # Obter quantidade de ADA no UTXO
    LOVELACE=$(echo "$RESPONSE" | grep -o '"lovelace":"[^"]*"' | head -1 | cut -d'"' -f4)
    ADA=$((LOVELACE / 1000000))
    
    # Valores estimados
    FEE=1000000  # 1 tADA
    TO_CONTRACT=2000000  # 2 tADA para contrato
    CHANGE=$((LOVELACE - FEE - TO_CONTRACT))
    
    if [ "$CHANGE" -lt 1000000 ]; then  # Menos de 1 tADA de troco
        log_error "Insufficient balance for fee + contract. Need at least 3 tADA."
        exit 1
    fi
    
    log_info "Calculated values:"
    log_info "  Input: $ADA tADA"
    log_info "  Fee: 1 tADA"
    log_info "  To contract: 2 tADA"
    log_info "  Change: $((CHANGE / 1000000)) tADA"
    
    # Perguntar se quer continuar
    read -p "Do you want to submit the transaction? (y/n): " CONFIRM_SUBMIT
    
    if [[ "$CONFIRM_SUBMIT" != "s" && "$CONFIRM_SUBMIT" != "S" ]]; then
        log_warning "Transaction cancelled by user (dry-run mode)"
        log_success "Script executed in test mode. To actually submit, run again and confirm."
        exit 0
    fi
    
    # Construir transacção
    log_info "Building transaction..."
    cardano-cli transaction build-raw \
        --tx-in "${TX_HASH}#${TX_INDEX}" \
        --tx-out "$SCRIPT_ADDR+$TO_CONTRACT" \
        --tx-out-datum-hash-file node_datum.json \
        --tx-out "$NODE_ADDRESS+$CHANGE" \
        --fee $FEE \
        --out-file register_node.raw
    
    # Assinar transacção
    log_info "Signing transaction..."
    cardano-cli transaction sign \
        --tx-body-file register_node.raw \
        --signing-key-file payment.skey \
        --testnet-magic $TESTNET_MAGIC \
        --out-file register_node.signed
    
    # Submeter via Blockfrost
    log_info "Submitting transaction via Blockfrost..."
    
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
        log_success "✅ Transaction submitted successfully!"
        echo "$TX_HASH" > tx_hash.txt
    else
        log_error "Error submitting transaction: $RESPONSE"
        exit 1
    fi
    
    cd ..
}

# =============================================================================
# 6. MOSTRAR RESUMO FINAL
# =============================================================================
show_summary() {
    log_info "📊 NODE REGISTRATION SUMMARY"
    echo ""
    echo "  Node address: $NODE_ADDRESS"
    echo "  Tier selected: $TIER_NAME"
    echo "  Suggested stake: $STAKE_MIN ERGON (voluntário)"
    echo "  Registration TX Hash: $TX_HASH"
    echo ""
    echo "  🔗 Verify on explorer:"
    echo "  https://preview.cardanoscan.io/transaction/$TX_HASH"
    echo ""
    echo "  📁 Files saved at: $WALLET_DIR/"
    echo "    - payment.vkey / payment.skey (node keys)"
    echo "    - payment.addr (address)"
    echo "    - node_datum.json (registration datum)"
    echo "    - tx_hash.txt (transaction hash)"
    echo ""
    log_success "✅ Node successfully registered on the Ergentum network!"
    echo ""
    echo "  Next steps:"
    echo "  1. Wait for transaction confirmation (2-3 minutes)"
    echo "  2. Configure the node software"
    echo "  3. Participate in the network and start earning rewards"
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
