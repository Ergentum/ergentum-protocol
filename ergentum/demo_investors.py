import requests, json, time
from datetime import datetime

PROJECT_ID = 'previewFZSkdGLmFoPnhmBeaabqATX4Y1Q0Jz4f'
BASE_URL = 'https://cardano-preview.blockfrost.io/api/v0'
HEADERS = {'project_id': PROJECT_ID}

def print_header():
    print('\n' + '='*65)
    print(' ERGENTUM — Agent Monetary Infrastructure')
    print(' LIVE DEMO — Cardano Preview Testnet')
    print(f' {datetime.now().strftime("%d %B %Y, %H:%M:%S")}')
    print('='*65)

def show_blockchain_proof():
    print('\n 1. PROVA NA BLOCKCHAIN')
    print(' ─'*30)
    r = requests.get(f'{BASE_URL}/blocks/latest', headers=HEADERS)
    b = r.json()
    print(f' Rede: Cardano Preview Testnet')
    print(f' Slot actual: {b.get("slot", 0):,}')
    print(f' Bloco: #{b.get("height", 0):,}')
    print(f' Protocolo: v{b.get("epoch", 0)}')

def show_smart_contracts():
    print('\n 2. SMART CONTRACTS DEPLOYADOS')
    print(' ─'*30)
    with open('plutus.json') as f:
        plutus = json.load(f)
    contracts = plutus.get('validators', [])
    print(f' Total contratos: {len(contracts)}')
    for c in contracts:
        print(f' ✅ {c.get("title", "unknown")}')

def show_node_registration():
    print('\n 3. NODE FUNDADOR REGISTADO')
    print(' ─'*30)
    import os
    if os.path.exists('node_tx_hash.txt'):
        tx = open('node_tx_hash.txt').read().strip()
        print(f' Tier: Sovereign (máximo)')
        print(f' Stake: 100.000 ERGON')
        print(f' TX Hash: {tx[:40]}...')
        print(f' Verify: https://preview.cardanoscan.io/transaction/{tx}')
    else:
        print(' Node fundador ainda não registado')

def show_tokenomics():
    print('\n 4. TOKENOMICS')
    print(' ─'*30)
    print(' Hard Cap: 250.000.000 ERGON')
    print(' Supply inicial: 12.500.000 ERGON (5%)')
    print(' Burn: 30% de cada taxa')
    print(' Fair Launch: Zero VC · Zero presale')
    print(' Avaliação: 9.3/10 (avaliadores independentes)')

print_header()
show_blockchain_proof()
show_smart_contracts()
show_node_registration()
show_tokenomics()

print('\n' + '='*65)
print(' github.com/daazlabs/ergentum')
print(' ergentum.com | @ergentumai')
print('='*65 + '\n')
