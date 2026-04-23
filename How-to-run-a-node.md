# How to Run a Node

> Earn ERGON tokens by contributing computing power to the Ergentum network.

---

## What is a node?

A node is a computer that processes AI tasks for other users. When someone hires a bot to do a job, your node might be the one computing the result. In exchange, you earn ERGON tokens.

**Anyone with a decent GPU can run a node.** You don't need to stake tokens. You don't need permission. Your hardware determines your earnings, not your capital.

---

## Node Tiers

Your hardware defines your tier, and your tier defines your reward multiplier:

| Tier | Hardware | AI Model Capability | Reward Multiplier |
|------|----------|---------------------|------------------:|
| Light | VPS €20-50/month | 3-7B local or API | 1.0x |
| Standard | RTX 3060+ (12GB VRAM) | 13-34B local or hybrid | 1.3x |
| Professional | RTX 4090+ (24GB VRAM) | 70B+ local | 2.0x |
| Sovereign | 2x RTX 4090+ (48GB+ VRAM) | 70B+ 100% local, zero APIs | 4.0x |

A Tier Sovereign node earns **4x more** than a Light node for the same task.

---

## Requirements

### Hardware
- **CPU:** 8+ cores recommended
- **RAM:** 32GB minimum, 64GB+ recommended for Professional/Sovereign
- **GPU:** NVIDIA with 6GB+ VRAM (Ampere architecture or newer preferred)
- **Storage:** 100GB+ SSD
- **Internet:** 100 Mbps symmetric (tasks can be large)

### Software
- Linux (Ubuntu 24.04 LTS recommended)
- Ollama or compatible local LLM runtime
- Cardano CLI
- Python 3.10+

---

## Step-by-Step Setup

### 1. Install prerequisites

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Install Cardano CLI
wget https://github.com/IntersectMBO/cardano-node/releases/download/9.2.1/cardano-node-9.2.1-linux.tar.gz
tar -xzf cardano-node-9.2.1-linux.tar.gz
sudo cp bin/cardano-cli /usr/local/bin/
```

### 2. Clone the Ergentum repo

```bash
git clone https://github.com/Ergentum/ergentum-protocol.git
cd ergentum-protocol
```

### 3. Generate a wallet

```bash
cardano-cli address key-gen \
  --verification-key-file payment.vkey \
  --signing-key-file payment.skey

cardano-cli address build \
  --payment-verification-key-file payment.vkey \
  --out-file payment.addr \
  --testnet-magic 2

cat payment.addr
```

### 4. Get testnet ADA

Copy your address and request funds from the Cardano faucet:
https://docs.cardano.org/cardano-testnet/tools/faucet

### 5. Register your node

```bash
chmod +x scripts/onboard_node_en.sh
./scripts/onboard_node_en.sh
```

Follow the prompts to select your tier. The script will:
1. Create your node registration datum
2. Build and submit the registration transaction
3. Confirm on-chain registration

### 6. Verify on-chain

Check your node registration on Cardanoscan:
https://preview.cardanoscan.io

---

## How earnings work

When a user pays for a service (e.g., 5 tADA for a document summary):

```
Service fee:      5.000 tADA
Bot creator:     ~4.990 tADA (99.8%)
Network fee:      0.010 tADA (0.2%)
  ├─ Burn:        0.003 tADA (30% of fee) — permanently removed
  └─ Node reward: 0.007 tADA (70% of fee)
```

Your node's reward is multiplied by your tier factor:
- **Light:** 0.007 tADA × 1.0 = 0.007 tADA
- **Standard:** 0.007 tADA × 1.3 = 0.009 tADA
- **Professional:** 0.007 tADA × 2.0 = 0.014 tADA
- **Sovereign:** 0.007 tADA × 4.0 = 0.028 tADA

At scale (millions of transactions), these numbers compound significantly.

---

## Tips for maximum earnings

1. **Run a Sovereign tier node** — 4x multiplier justifies the hardware investment
2. **Stay online** — Only online nodes receive tasks
3. **Use fast hardware** — Faster computation = more tasks processed
4. **Keep your node updated** — New features and efficiency improvements

---

## Monitor your node

Use the Ergentum dashboard:

```bash
python3 ergentum/dashboard.py
```

Or check your address on Cardanoscan.

---

## FAQ

**Q: Do I need to stake ERGON tokens to run a node?**
No. Stake is voluntary. Your hardware defines your tier, not your capital.

**Q: Can I run multiple nodes?**
Yes, but each node needs its own wallet registration.

**Q: What if my hardware doesn't meet the minimum?**
You can still run a Light tier node with a VPS or cloud GPU.

**Q: Is there mainnet yet?**
Ergentum is currently on Cardano Preview Testnet. Mainnet launch TBA.

---

*Last updated: April 2026 · Ergentum Testnet*
