# Documentação Técnica - Ergentum Node Registration

## Arquitectura do Smart Contract

### Tipos de Dados

#### NodeTier (Enum)
```aiken
type NodeTier {
  Light        // Stake mínimo: 1,000 ADA
  Standard     // Stake mínimo: 5,000 ADA
  Professional // Stake mínimo: 25,000 ADA
  Sovereign    // Stake mínimo: 100,000 ADA
```

#### NodeRegistration (Datum)
```aiken
type NodeRegistration {
  node_id: VerificationKeyHash,  // Hash da chave pública do node
  tier: NodeTier,                // Tier do node
  stake_amount: Int              // Quantidade de ADA em stake
}
```

#### Redeemer (Enum)
```aiken
type Redeemer {
  Register    // Para registar um novo node
  Unregister  // Para cancelar o registo de um node
}
```

### Validações Implementadas

#### 1. Validação de Registo (`Register`)
- **Stake mínimo:** Verifica se `stake_amount` >= mínimo para o `tier`
- **Output do node:** Verifica se há um output para o `payment_credential` do node
- **Payment credential:** Usa `PubKeyCredential` com `verification_key_hash`

#### 2. Validação de Cancelamento (`Unregister`)
- **Autorização:** Apenas o `node_id` pode cancelar
- **Assinaturas:** Verifica tanto `signatories` como `extra_signatories`
- **Segurança:** Previne cancelamento não autorizado

### Correções Técnicas Implementadas

#### 1. `VerificationKeyHash` em vez de `ByteArray`
- **Antes:** `node_id: ByteArray`
- **Depois:** `node_id: VerificationKeyHash`
- **Benefício:** Type safety e semântica correcta para chaves públicas

#### 2. `payment_credential` para verificação de endereços
- **Antes:** Comparação directa de `address`
- **Depois:** Extração de `payment_credential` do `PubKeyAddress`
- **Benefício:** Suporte correcto para endereços Cardano

#### 3. `extra_signatories` para autorização
- **Antes:** Apenas `signatories`
- **Depois:** `signatories ++ extra_signatories`
- **Benefício:** Suporte para assinaturas adicionais

### Fluxo de Transacções

#### Registo de Node:
1. Transacção com `Redeemer.Register`
2. Output com `payment_credential` correspondente ao `node_id`
3. `stake_amount` suficiente para o `tier`
4. Validator retorna `True`

#### Cancelamento de Node:
1. Transacção com `Redeemer.Unregister`
2. Assinatura do `node_id` em `signatories` ou `extra_signatories`
3. Validator retorna `True`

### Testes Implementados

#### Testes de Registo:
- `register_light_node()` - Registo válido com stake suficiente
- `register_light_node_insufficient_stake()` - Registo inválido com stake insuficiente

#### Testes de Cancelamento:
- `unregister_by_owner()` - Cancelamento autorizado pelo owner
- `unregister_by_unauthorized()` - Cancelamento não autorizado
- `unregister_with_normal_signatory()` - Cancelamento com signatory normal

### Deployment

#### Pré-requisitos:
1. Cardano CLI configurado
2. Wallet com funds para fees
3. Testnet ou Mainnet access

#### Comandos:
```bash
# Compilar e testar
./scripts/deploy.sh

# Gerar endereço do script
cardano-cli address build --payment-script-file plutus.json --testnet-magic 1097911063 --out-file script.addr

# Construir transacção
cardano-cli transaction build --tx-in <UTXO> --tx-out $(cat script.addr)+2000000 --tx-out-datum-hash-file datum.json --change-address <YOUR_ADDRESS> --testnet-magic 1097911063 --out-file tx.raw

# Assinar e submeter
cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file payment.skey --testnet-magic 1097911063 --out-file tx.signed
cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063
```

### Segurança

#### Considerações:
1. **Stake mínimo:** Previne nodes com stake insuficiente
2. **Autorização:** Apenas owner pode cancelar
3. **Type safety:** Tipos correctos previnem erros
4. **Test coverage:** Testes abrangentes para casos edge

#### Melhorias Futuras:
1. **Time locks:** Período mínimo de stake
2. **Slashing:** Penalidades para comportamento malicioso
3. **Governance:** Votação para alterações de parâmetros
4. **Upgradability:** Mecanismo para upgrade do contrato
