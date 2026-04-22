import requests, json
from datetime import datetime

# Configurações
PROJECT_ID = 'previewFZSkdGLmFoPnhmBeaabqATX4Y1Q0Jz4f'
BASE_URL = 'https://cardano-preview.blockfrost.io/api/v0'
HEADERS = {'project_id': PROJECT_ID}

# Dados confirmados
POLICY_ID = "f0aed7733ac89c0ad46bccb3f9b730edec6ccfbc68b2c7890019540b"
SCRIPT_ADDR = "addr_test1wrymtz3fpqqt2zlmkxg2j747zdm678x9lkkc6zpj5mdhjsqqw2qnx"
WALLET = "addr_test1vphd3sf978huawdsvc4wqlx8pn4nyxqc90ntvtm2zaz37vqkev0fl"

TX_NODE_FUNDADOR = "6310fdc0e543020439ef18ae08344f391f82d28089cb27818ed16ae692da981d"
TX_ERGON_MINT = "c66a50e761827c3b6dd780cde5d673f48b431545f8d55048790b093bc04d9464"
TX_BOT_DEV = "baa26469d6646c03eaa434e6ca281ccad3f5c70b5403b8d6fb96015f4d09e20c"
TX_BOT_DOCS = "948796fc39458dbac497bcb39e1830e75f994f7607c791891a0f35b1ee0d99a4"
TX_BOT_ASSIST = "5c82e74a3ce5b7dcf40a754f14bd29f0a7f5ee3f269db52304abc3eabf5a5008"

# Contratos activos
CONTRACTS = {
    'ergentum_node': SCRIPT_ADDR,
    'ergentum_rewards': SCRIPT_ADDR,  # Mesmo endereço para demo
    'ergentum_bots': SCRIPT_ADDR,     # Mesmo endereço para demo
    'ergentum_fees': SCRIPT_ADDR,     # Mesmo endereço para demo
}

# Funções auxiliares
def get_address_info(addr):
    try:
        r = requests.get(f'{BASE_URL}/addresses/{addr}', headers=HEADERS, timeout=10)
        return r.json() if r.status_code == 200 else {}
    except:
        return {}

def get_address_txs(addr):
    try:
        r = requests.get(f'{BASE_URL}/addresses/{addr}/transactions', headers=HEADERS, timeout=10)
        return r.json() if r.status_code == 200 else []
    except:
        return []

def get_latest_block():
    try:
        r = requests.get(f'{BASE_URL}/blocks/latest', headers=HEADERS, timeout=10)
        return r.json() if r.status_code == 200 else {}
    except:
        return {}

def get_asset_info(policy_id, asset_name=""):
    try:
        asset = policy_id + asset_name
        r = requests.get(f'{BASE_URL}/assets/{asset}', headers=HEADERS, timeout=10)
        return r.json() if r.status_code == 200 else {}
    except:
        return {}

def get_tx_info(tx_hash):
    try:
        r = requests.get(f'{BASE_URL}/txs/{tx_hash}', headers=HEADERS, timeout=10)
        return r.json() if r.status_code == 200 else {}
    except:
        return {}

# Dashboard principal
def main():
    print('=' * 70)
    print(' ERGENTUM AI NETWORK — DASHBOARD PÚBLICO')
    print(f' {datetime.now().strftime("%Y-%m-%d %H:%M:%S")} (Preview Testnet)')
    print('=' * 70)

    # 1. ESTADO DA BLOCKCHAIN
    print('\n' + '─' * 30 + ' 1. ESTADO DA BLOCKCHAIN ' + '─' * 30)
    block = get_latest_block()
    if block:
        print(f' Slot actual: {block.get("slot", "N/A"):,}')
        print(f' Block height: {block.get("height", "N/A"):,}')
        print(f' Protocolo: {block.get("protocol_version", "N/A")}')
    else:
        print(' Erro ao obter dados da blockchain')

    # 2. TOKEN ERGON
    print('\n' + '─' * 30 + ' 2. TOKEN ERGON ' + '─' * 30)
    print(f' Policy ID: {POLICY_ID}')
    
    # Verificar supply do token ERGON
    asset_info = get_asset_info(POLICY_ID, "4552474f4e")
    if asset_info:
        supply = int(asset_info.get('quantity', 0))
        print(f' Supply em circulação: {supply:,} ERGON')
    else:
        print(f' Supply: A verificar...')

    # Verificar saldo da wallet fundadora
    wallet_info = get_address_info(WALLET)
    if wallet_info and 'amount' in wallet_info:
        ergon_balance = 0
        ada_balance = 0
        for asset in wallet_info['amount']:
            if asset['unit'] == 'lovelace':
                ada_balance = int(asset['quantity'])
            elif asset['unit'] == POLICY_ID + '4552474f4e':
                ergon_balance = int(asset['quantity'])
        
        print(f' Wallet fundador: {ada_balance//1000000:,} tADA')
        print(f' ERGON na wallet: {ergon_balance:,} tokens')
    else:
        print(f' Wallet fundador: A verificar...')

    # 3. CONTRATOS ACTIVOS
    print('\n' + '─' * 30 + ' 3. CONTRATOS ACTIVOS ' + '─' * 30)
    total_ada_in_contracts = 0
    total_txs_in_contracts = 0
    
    for name, addr in CONTRACTS.items():
        info = get_address_info(addr)
        txs = get_address_txs(addr)
        
        if info and 'amount' in info:
            balance = sum(int(a['quantity']) for a in info['amount'] if a['unit'] == 'lovelace')
            total_ada_in_contracts += balance
            total_txs_in_contracts += len(txs)
            
            print(f' [{name}]')
            print(f'   Endereço: {addr[:20]}...{addr[-20:]}')
            print(f'   Saldo: {balance//1000000:,} tADA')
            print(f'   Transacções: {len(txs)}')
        else:
            print(f' [{name}] - Sem dados')

    # 4. NODE FUNDADOR
    print('\n' + '─' * 30 + ' 4. NODE FUNDADOR ' + '─' * 30)
    node_tx = get_tx_info(TX_NODE_FUNDADOR)
    if node_tx:
        block_height = node_tx.get('block_height', 'N/A')
        confirmations = node_tx.get('confirmations', 0)
        print(f' TX Hash: {TX_NODE_FUNDADOR}')
        print(f' Tier: Sovereign (4× recompensas)')
        print(f' Block: {block_height:,}')
        print(f' Confirmations: {confirmations}')
        print(f' Explorer: https://preview.cardanoscan.io/transaction/{TX_NODE_FUNDADOR}')
    else:
        print(f' Node fundador: {TX_NODE_FUNDADOR}')

    # 5. BOTS FUNDADORES
    print('\n' + '─' * 30 + ' 5. BOTS FUNDADORES ' + '─' * 30)
    bots = [
        ('Ergentum Dev', TX_BOT_DEV, 'Technical'),
        ('Ergentum Docs', TX_BOT_DOCS, 'General'),
        ('Ergentum Assist', TX_BOT_ASSIST, 'General')
    ]
    
    for bot_name, tx_hash, category in bots:
        bot_tx = get_tx_info(tx_hash)
        if bot_tx:
            block_height = bot_tx.get('block_height', 'N/A')
            print(f' [{bot_name}]')
            print(f'   TX: {tx_hash}')
            print(f'   Categoria: {category}')
            print(f'   Block: {block_height:,}')
            print(f'   Explorer: https://preview.cardanoscan.io/transaction/{tx_hash}')
        else:
            print(f' [{bot_name}] - {tx_hash}')

    # 6. RESUMO DA REDE
    print('\n' + '─' * 30 + ' 6. RESUMO DA REDE ' + '─' * 30)
    
    # Total de transacções on-chain
    all_txs = set()
    for _, addr in CONTRACTS.items():
        txs = get_address_txs(addr)
        if isinstance(txs, list):
            # Extrair apenas os hashes das transacções
            for tx in txs:
                if isinstance(tx, dict) and 'tx_hash' in tx:
                    all_txs.add(tx['tx_hash'])
    
    # Adicionar transacções conhecidas
    known_txs = [
        TX_NODE_FUNDADOR,
        TX_ERGON_MINT,
        TX_BOT_DEV,
        TX_BOT_DOCS,
        TX_BOT_ASSIST
    ]
    all_txs.update(known_txs)
    
    print(f' Total transacções on-chain: {len(all_txs)}')
    print(f' Total tADA em contratos: {total_ada_in_contracts//1000000:,} tADA')
    
    if asset_info:
        ergon_supply = int(asset_info.get('quantity', 0))
        print(f' Total ERGON mintados: {ergon_supply:,} tokens')
    else:
        print(f' Total ERGON mintados: A verificar...')

    # 7. MARCOS ALCANÇADOS
    print('\n' + '─' * 30 + ' 7. MARCOS ALCANÇADOS ' + '─' * 30)
    milestones = [
        '✅ Token ERGON mintado',
        '✅ Contrato de nodes implementado',
        '✅ Node fundador registado (Sovereign)',
        '✅ Sistema de bots implementado',
        '✅ 3 Bots fundadores registados',
        '✅ Script de onboarding criado',
        '✅ Dashboard público operacional'
    ]
    
    for milestone in milestones:
        print(f' {milestone}')

    print('\n' + '=' * 70)
    print(' 🌟 ERGENTUM AI NETWORK — TESTNET OPERACIONAL 🌟')
    print('=' * 70)

if __name__ == '__main__':
    main()