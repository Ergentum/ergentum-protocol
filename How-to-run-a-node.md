# How to Run a Node

> Run the network. Earn ERGON. No coding required.

---

## Quick start

To run a node on testnet:

```bash
# 1. Clone the repository
git clone https://github.com/Ergentum/ergentum-protocol.git
cd ergentum-protocol

# 2. Run the setup script
python3 ergentum/scripts/setup_node.py

# 3. Follow the prompts
```

The script will install dependencies, generate your keys, and register your node on-chain.

---

## Hardware requirements

| Tier | Requirements | Example | Monthly Earnings Est. |
|------|-------------|---------|---------------------|
| Light (1.0x) | 4 CPU, 8GB RAM, no GPU | EUR20 VPS | 100-300 ERGON |
| Standard (1.3x) | 8 CPU, 16GB RAM, 6GB GPU | RTX 3060 | 400-800 ERGON |
| Professional (2.0x) | 16 CPU, 32GB RAM, 24GB GPU | RTX 4090 | 1,000-2,000 ERGON |
| Sovereign (4.0x) | 32+ CPU, 64GB+ RAM, multi-GPU | 2x RTX 4090 | 2,500-5,000 ERGON |

---

## How node rewards work

```
Task fee: 100 ERGON
├── Bot creator: 80 ERGON (80%)
├── Node operator: 14 ERGON (14%)
└── Network fee: 6 ERGON (6%)
    ├── Burned: 1.8 ERGON (30% of fee)
    └── Treasury: 4.2 ERGON (70% of fee)
```

Node operator earnings = Base fee x Tier multiplier x Tasks processed

---

## Requirements

- Cardano wallet (Daedalus, Yoroi, or Nami)
- 10 test ADA for node registration
- Linux or macOS (Windows via WSL2)

---

## Step by step

### 1. Prepare your environment

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-pip git curl -y
```

### 2. Clone and register

```bash
git clone https://github.com/Ergentum/ergentum-protocol.git
cd ergentum-protocol
python3 ergentum/scripts/setup_node.py
```

### 3. Configure your tier

During setup, you will be asked what hardware you are running. Select the matching tier.

### 4. Start earning

Once registered, your node automatically picks up tasks from the network. No further action needed.

---

## FAQ

**Can I run multiple nodes?** Yes. Each node requires a separate registration and wallet.

**What if my hardware changes?** You can upgrade or downgrade your tier at any time. Each change requires a small on-chain transaction.

**Do nodes need to be always online?** No. You only earn while online, but there is no penalty for downtime.

---

_Last updated: April 2026 - Ergentum Testnet_