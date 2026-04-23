# Technical Documentation - Ergentum Smart Contracts

> Technical reference for developers and auditors.

---

## Overview

Ergentum uses four smart contracts on Cardano, written in Aiken:

- `ergentum_node` - Node registration and tier management
- `ergentum_rewards` - Reward calculation and distribution
- `ergentum_bots` - Bot registration and reputation tracking
- `ergentum_fees` - Fee collection and token burning

All deployed on Cardano Preview Testnet.

---

## Network parameters (testnet)

| Parameter | Value |
|-----------|-------|
| Network | Cardano Preview Testnet |
| Script address | `addr_test1wrymtz3fpqqt2zlmkxg2j747zdm678x9lkkc6zpj5mdhjsqqw2qnx` |
| ERGON policy ID | `f0aed7733ac89c0ad46bccb3f9b730edec6ccfbc68b2c7890019540b` |
| Total ERGON supply | 12,500,000 tokens |

---

## Data types

### NodeRegistration

```aiken
pub type NodeRegistration {
  owner: VerificationKeyHash,
  tier: Int,
  stake: Int,
}
```

### BotRegistration

```aiken
pub type BotRegistration {
  creator: VerificationKeyHash,
  price: Int,
  reputation: Int,
}
```

---

## Validators

### node_validator

Validates node registration. Verifies:
- Owner controls the signing key
- Tier is 1-4
- Minimum stake is met

### bot_validator

Validates bot registration. Verifies:
- Creator controls the signing key
- Price is above minimum
- Bot is not already registered

---

## Explorer links

| Transaction | Hash |
|-------------|------|
| Node registration | `6310fdc0e543020439ef18ae08344f391f82d28089cb27818ed16ae692da981d` |
| ERGON mint | `c66a50e761827c3b6dd780cde5d673f48b431545f8d55048790b093bc04d9464` |
| Dev bot | `baa26469d6646c03eaa434e6ca281ccad3f5c70b5403b8d6fb96015f4d09e20c` |
| Docs bot | `948796fc39458dbac497bcb39e1830e75f994f7607c791891a0f35b1ee0d99a4` |
| Assist bot | `5c82e74a3ce5b7dcf40a754f14bd29f0a7f5ee3f269db52304abc3eabf5a5008` |
| Service TX | `cf0359a9522dd1bec3c82706100425dee19096099351431bb265852206bcaa63` |

---

_Last updated: April 2026 - Ergentum Testnet_