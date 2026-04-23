# Technical Documentation — Ergentum Smart Contracts

> Smart contract architecture, validation logic, and deployment for the Ergentum network.

---

## Contract Architecture

Ergentum uses four Aiken smart contracts on Cardano, following the eUTXO model.

| Contract | Purpose | Datum | Redeemer |
|----------|---------|-------|----------|
| ergentum_node | Node registration and tier management | NodeRegistration | Register / Unregister |
| ergentum_rewards | Reward distribution logic | RewardDatum | ClaimDistribute |
| ergentum_bots | Bot registry and deployment | BotRegistration | Register / Deregister |
| ergentum_fees | Transaction fees and 30% burn | FeeDatum | PayFee |

All contracts share the same script address on testnet:
`addr_test1wrymtz3fpqqt2zlmkxg2j747zdm678x9lkkc6zpj5mdhjsqqw2qnx`

---

## Data Types

### NodeTier (Enum)

```aiken
type NodeTier {
  Light        // No minimum stake required
  Standard     // Mid-range hardware (RTX 3060+)
  Professional // High-end hardware (RTX 4090+)
  Sovereign    // Enterprise-grade (2x RTX 4090+)
}
```

### NodeRegistration (Datum)

```aiken
type NodeRegistration {
  node_id: VerificationKeyHash,  // Hash of the node's public key
  tier: NodeTier,                // Hardware-defined tier
  stake_amount: Int              // Voluntary ADA stake amount
}
```

### Redeemer

```aiken
type Redeemer {
  Register    // Register a new node
  Unregister  // Cancel node registration
}
```

---

## Validation Logic

### 1. Register Validation

When a node operator registers on-chain, the contract checks:

- **Stake minimum:** Verifies `stake_amount >= tier_minimum`
- **Node output:** Ensures a UTXO exists at the node's `payment_credential`
- **Payment credential:** Uses `PubKeyCredential` with `verification_key_hash`

### 2. Unregister Validation

When a node operator cancels their registration:

- **Authorisation:** Only the `node_id` owner can unregister
- **Signatures:** Checks both `signatories` and `extra_signatories`
- **Security:** Prevents unauthorised cancellation

---

## Technical Corrections Implemented

### 1. `VerificationKeyHash` instead of `ByteArray`
- **Before:** `node_id: ByteArray`
- **After:** `node_id: VerificationKeyHash`
- **Benefit:** Type safety and correct semantics for public keys

### 2. `payment_credential` for address verification
- **Before:** Direct address comparison
- **After:** Extract `payment_credential` from `PubKeyAddress`
- **Benefit:** Proper support for Cardano addressing

### 3. `extra_signatories` for authorisation
- **Before:** Only `signatories`
- **After:** `signatories ++ extra_signatories`
- **Benefit:** Support for additional signing keys

---

## Transaction Flow

### Node Registration

```
1. Create datum with NodeRegistration
   ├─ node_id: VerificationKeyHash
   ├─ tier: Light | Standard | Professional | Sovereign
   └─ stake_amount: Int

2. Build transaction with Redeemer.Register
   ├─ Input: Wallet UTXO
   ├─ Output: Contract address + datum + stake
   └─ Sign: Node's signing key

3. Submit to blockchain
   └─ Verify: Check UTXO at contract address
```

### Node Unregistration

```
1. Build transaction with Redeemer.Unregister
   ├─ Input: Contract UTXO (locked with node's datum)
   ├─ Output: Back to node's wallet
   └─ Sign: Node's signing key (must match node_id)

2. Submit to blockchain
   └─ Verify: UTXO returned to wallet
```

---

## Tokenomics Contract

### Fee Distribution

The `ergentum_fees` contract enforces the fee model:

```
Service payment:     5,000,000 lovelace (5 tADA)
├─ Bot creator:      4,990,000 lovelace (99.8%)
├─ Network fee:         10,000 lovelace (0.2%)
│  ├─ Burn:              3,000 lovelace (30%)
│  └─ Node reward:       7,000 lovelace (70%)
└─ Cardano TX fee:          1 lovelace
```

### ERGON Token

- **Policy ID:** `f0aed7733ac89c0ad46bccb3f9b730edec6ccfbc68b2c7890019540b`
- **Standard:** CIP-68
- **Hard cap:** 250,000,000 ERGON
- **Initial supply:** 12,500,000 ERGON (5%)

---

## Deployment

### Prerequisites

- Cardano CLI 9.4.1+
- Wallet with testnet ADA
- Python 3.10+
- `requests` library (Blockfrost API)

### Step 1: Compile contracts

```bash
cd ergentum
aiken build
# Output: plutus.json
```

### Step 2: Generate script address

```bash
cardano-cli address build \
  --payment-script-file plutus.json \
  --testnet-magic 2 \
  --out-file script.addr
```

### Step 3: Build and submit registration

```bash
# Using the deployment script
python3 scripts/deploy.py

# Or manually:
cardano-cli transaction build \
  --tx-in <UTXO> \
  --tx-out $(cat script.addr)+2000000 \
  --tx-out-datum-hash-file datum.json \
  --change-address <YOUR_ADDRESS> \
  --testnet-magic 2 \
  --out-file tx.raw

cardano-cli transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --testnet-magic 2 \
  --out-file tx.signed

cardano-cli transaction submit \
  --tx-file tx.signed \
  --testnet-magic 2
```

---

## Security

### Current protections

1. **Minimum stake by tier:** Prevents low-quality node registrations
2. **Authorisation:** Only the owner can unregister
3. **Type safety:** Correct Aiken types prevent common errors
4. **Test coverage:** Comprehensive tests for edge cases

### Planned improvements

1. **Time locks:** Minimum stake period
2. **Slashing:** Penalties for malicious behaviour
3. **Governance:** On-chain voting for parameter changes
4. **Upgradability:** Contract upgrade mechanism (via governance)

---

## Testnet Transactions

All contracts and registrations are publicly verifiable:

| Item | TX Hash |
|------|---------|
| Smart Contract Deploy | `c9eef1c7ca2e16d38472466c7d8fe7bb9f024a2ae4057546d61fbc176ad2136d` |
| Founding Node Register | `6310fdc0e543020439ef18ae08344f391f82d28089cb27818ed16ae692da981d` |
| ERGON Token Mint | `c66a50e761827c3b6dd780cde5d673f48b431545f8d55048790b093bc04d9464` |
| Bot Registration (Dev) | `baa26469d6646c03eaa434e6ca281ccad3f5c70b5403b8d6fb96015f4d09e20c` |
| Bot Registration (Docs) | `948796fc39458dbac497bcb39e1830e75f994f7607c791891a0f35b1ee0d99a4` |
| Bot Registration (Assist) | `5c82e74a3ce5b7dcf40a754f14bd29f0a7f5ee3f269db52304abc3eabf5a5008` |
| Service Simulation 1 | `27b8199137375951b126d09b5183594819c85bdf09be73477e09c3b912c89efb` |
| Service Simulation 2 | `cf0359a9522dd1bec3c82706100425dee19096099351431bb265852206bcaa63` |

**Explorer:** https://preview.cardanoscan.io

---

## Source Code

The full contract source code is available at:
https://github.com/Ergentum/ergentum-protocol

- `ergentum/validators/ergentum_node.ak`
- `ergentum/validators/ergentum_bots.ak`
- `ergentum/validators/ergentum_rewards.ak`
- `ergentum/validators/ergentum_fees.ak`

---

*Last updated: April 2026 · Ergentum Testnet*
