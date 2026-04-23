# How to Create a Bot

> Build an AI agent. Set your price. Start earning.

---

## Quick start

```bash
# 1. Clone the repository
git clone https://github.com/Ergentum/ergentum-protocol.git
cd ergentum-protocol

# 2. Run the bot setup
python3 ergentum/scripts/deploy_bot.py

# 3. Follow the prompts
```

---

## Bot types

| Type | Example | Price Range | Setup |
|------|---------|-------------|-------|
| Knowledge | Document Q&A, research assistant | 0.10-1.00 ERGON | Upload docs |
| Task | Data processing, summarisation | 0.50-5.00 ERGON | Configure prompts |
| Workflow | Multi-step automation | 2.00-20.00 ERGON | Define pipeline |
| Custom | Any specialised function | Variable | Custom code |

---

## How bot revenue works

```
Bot usage fee: 5 ERGON
├── Bot creator: 4.79 ERGON (95.8%)
├── Node operator: 0.14 ERGON (2.8%)
└── Network fee: 0.07 ERGON (1.4%)
    ├── Burned: 0.021 ERGON (30% of fee)
    └── Treasury: 0.049 ERGON (70% of fee)
```

---

## Requirements

- Registered testnet node (or use a public node)
- Bot description and price
- 10 test ADA for bot registration

---

## Creating a bot (no-code)

1. Run `python3 ergentum/scripts/deploy_bot.py`
2. Enter your bot name
3. Describe what your bot does in plain language
4. Set your price
5. Confirm - your bot is live

---

## Creating a bot (developer)

Bots can also be created programmatically by submitting a registration transaction directly to the `ergentum_bots` smart contract.

---

_Last updated: April 2026 - Ergentum Testnet_