import requests
import json
import subprocess

PROJECT_ID = "previewFZSkdGLmFoPnhmBeaabqATX4Y1Q0Jz4f"
BASE_URL = "https://cardano-preview.blockfrost.io/api/v0"
HEADERS = {"project_id": PROJECT_ID}
ADDRESS = "addr_test1vphd3sf978huawdsvc4wqlx8pn4nyxqc90ntvtm2zaz37vqkev0fl"

def get_utxos():
    r = requests.get(f"{BASE_URL}/addresses/{ADDRESS}/utxos", headers=HEADERS)
    return r.json()

def get_protocol_params():
    r = requests.get(f"{BASE_URL}/epochs/latest/parameters", headers=HEADERS)
    return r.json()

def get_latest_block():
    r = requests.get(f"{BASE_URL}/blocks/latest", headers=HEADERS)
    return r.json()

def test_connection():
    r = requests.get(f"{BASE_URL}/health", headers=HEADERS)
    print("Blockfrost:", r.json())

if __name__ == "__main__":
    print("=== ERGENTUM DEPLOY SCRIPT ===")
    
    print("\n1. Testando conexão Blockfrost...")
    test_connection()
    
    print("\n2. Verificando UTXOs...")
    utxos = get_utxos()
    print(json.dumps(utxos, indent=2))
    
    print("\n3. Parâmetros do protocolo...")
    params = get_protocol_params()
    print(f" Min fee A: {params.get('min_fee_a')}")
    print(f" Min fee B: {params.get('min_fee_b')}")
    print(f" Protocolo: {params.get('protocol_major_ver')}.{params.get('protocol_minor_ver')}")
    
    print("\n4. Bloco mais recente...")
    block = get_latest_block()
    print(f" Slot: {block.get('slot')}")
    print(f" Height: {block.get('height')}")
    
    print("\n=== AMBIENTE PRONTO PARA DEPLOY ===")
