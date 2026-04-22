import requests, json, subprocess, sys

PROJECT_ID = 'previewFZSkdGLmFoPnhmBeaabqATX4Y1Q0Jz4f'
BASE_URL = 'https://cardano-preview.blockfrost.io/api/v0'
HEADERS = {'project_id': PROJECT_ID}

WALLET_ADDR = open('payment.addr').read().strip()
SCRIPT_ADDR = 'addr_test1wrymtz3fpqqt2zlmkxg2j747zdm678x9lkkc6zpj5mdhjsqqw2qnx'

def get_utxos():
    r = requests.get(f'{BASE_URL}/addresses/{WALLET_ADDR}/utxos', headers=HEADERS)
    return r.json()

def get_protocol_params():
    r = requests.get(f'{BASE_URL}/epochs/latest/parameters', headers=HEADERS)
    return r.json()

def submit_tx(signed_file):
    with open(signed_file) as f:
        tx = json.load(f)
    cbor_bytes = bytes.fromhex(tx['cborHex'])
    headers = {**HEADERS, 'Content-Type': 'application/cbor'}
    r = requests.post(f'{BASE_URL}/tx/submit', headers=headers, data=cbor_bytes)
    return r.status_code, r.text

print('=== ERGENTUM NODE REGISTRATION ===')
print('Wallet:', WALLET_ADDR)
print('Script:', SCRIPT_ADDR)

# Obter UTXOs
utxos = get_utxos()
if not utxos or isinstance(utxos, dict):
    print('ERRO: Sem UTXOs disponíveis')
    sys.exit(1)

utxo = utxos[0]
utxo_id = f"{utxo['tx_hash']}#{utxo['output_index']}"
balance = int(utxo['amount'][0]['quantity'])

print(f'UTXO: {utxo_id}')
print(f'Saldo: {balance//1000000} tADA')

# Calcular valores
fee = 1000000  # 1 tADA
node_deposit = 2000000  # 2 tADA para o contrato
change = balance - fee - node_deposit

print(f'Fee: {fee//1000000} tADA')
print(f'Deposit: {node_deposit//1000000} tADA')
print(f'Troco: {change//1000000} tADA')

# Construir transacção COM DATUM
result = subprocess.run([
    'cardano-cli',
    'transaction', 'build-raw',
    '--tx-in', utxo_id,
    '--tx-out', f'{SCRIPT_ADDR}+{node_deposit}',
    '--tx-out-datum-hash-file', 'node_datum.json',
    '--tx-out', f'{WALLET_ADDR}+{change}',
    '--fee', str(fee),
    '--out-file', 'register_node.raw'
], capture_output=True, text=True)

if result.returncode != 0:
    print('ERRO build-raw:', result.stderr)
    sys.exit(1)

print('Transacção construída: register_node.raw')

# Assinar
result = subprocess.run([
    'cardano-cli',
    'transaction', 'sign',
    '--tx-body-file', 'register_node.raw',
    '--signing-key-file', 'payment.skey',
    '--testnet-magic', '2',
    '--out-file', 'register_node.signed'
], capture_output=True, text=True)

if result.returncode != 0:
    print('ERRO sign:', result.stderr)
    sys.exit(1)

print('Transacção assinada: register_node.signed')

# Submeter
print('Submetendo...')
status, response = submit_tx('register_node.signed')
print(f'Status: {status}')
print(f'Response: {response}')

if status == 200:
    print(f'SUCESSO! TX Hash: {response}')
    with open('node_tx_hash.txt', 'w') as f:
        f.write(response.strip('"'))
else:
    print('ERRO na submissão')
