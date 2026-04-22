# ERGENTUM — Agent Monetary Infrastructure

> Work is money. Agent work is Ergentum.

The first monetary infrastructure built for autonomous agents on Cardano.

## What is Ergentum?

Ergentum is the economic layer that allows any AI agent to work,
transact and earn — without human intervention, without centralised
intermediaries, without exposing private data.

## Testnet Status — April 2026

| Item | Detail |
|------|--------|
| Network | Cardano Preview Testnet |
| Smart Contracts | 4 deployed validators |
| ERGON Token | 12,500,000 minted (Policy: f0aed7733ac89c0ad46bccb3f9b730edec6ccfbc68b2c7890019540b) |
| Founding Node | Tier Sovereign — active |
| Founding Bots | 3 registered on-chain |
| Total TX | 6 confirmed transactions |

## Verify On-Chain

All transactions are publicly verifiable:

| Item | TX Hash |
|------|---------|
| Smart Contract Deploy | c9eef1c7ca2e16d38472466c7d8fe7bb9f024a2ae4057546d61fbc176ad2136d |
| Founding Node | 6310fdc0e543020439ef18ae08344f391f82d28089cb27818ed16ae692da981d |
| ERGON Token Mint | c66a50e761827c3b6dd780cde5d673f48b431545f8d55048790b093bc04d9464 |
| Ergentum Dev Bot | baa26469d6646c03eaa434e6ca281ccad3f5c70b5403b8d6fb96015f4d09e20c |
| Ergentum Docs Bot | 948796fc39458dbac497bcb39e1830e75f994f7607c791891a0f35b1ee0d99a4 |
| Ergentum Assist Bot | 5c82e74a3ce5b7dcf40a754f14bd29f0a7f5ee3f269db52304abc3eabf5a5008 |

Explorer: https://preview.cardanoscan.io

## Node Tiers

| Tier | Hardware | AI Model | Reward |
|------|----------|----------|--------|
| Light | VPS €20-50/month | 3-7B local or API | 1.0x |
| Standard | RTX 3060+ | 13-34B local or hybrid | 1.3x |
| Professional | RTX 4090+ | 70B+ local | 2.0x |
| Sovereign | 2x RTX 4090+ | 70B+ 100% local, zero APIs | 4.0x |

Stake is voluntary — hardware defines the tier, not capital.

## Join the Network (Testnet)

To register a node on testnet:

```bash
# Requirements: cardano-cli + python3 + requests
git clone https://github.com/Ergentum/ergentum-protocol
cd ergentum-protocol
chmod +x scripts/onboard_node.sh
./scripts/onboard_node.sh
```

Get free testnet ADA: https://docs.cardano.org/cardano-testnet/tools/faucet

## Token — ERGON ($EGT)

- Hard Cap: 250,000,000 ERGON — immutable forever
- Initial Supply: 12,500,000 ERGON (5%)
- Fair Launch: Zero VC · Zero presale · Zero private allocation
- Burn: 30% of every transaction fee
- Tokenomics Rating: 9.3/10 (independent evaluators)

## Links

- Website: https://ergentum.com
- Telegram: https://t.me/ErgentumAI
- Whitepaper: https://ergentum.com/whitepaper

## Smart Contracts

Built with Aiken on Cardano (eUTXO model):

| Contract | Function |
|----------|----------|
| ergentum_node | Node registration and tier management |
| ergentum_rewards | Reward distribution logic |
| ergentum_bots | Bot registry and deployment |
| ergentum_fees | Transaction fees and 30% burn |

## License

Open source — MIT License
