use aiken/list
use aiken/transaction.{ScriptContext, Transaction}
use aiken/transaction/credential.{VerificationKey}

// Datum de uma transacção de serviço
pub type FeeDatum {
 payer: VerificationKey,
 service_value: Int, // Valor do serviço em lovelace
 fee_amount: Int, // 0.2% do service_value
 burn_amount: Int, // 30% do fee_amount
 epoch: Int,
}

// Acções
pub type FeeRedeemer {
 PayFee // Pagar taxa de serviço
 BurnFee // Queimar porção deflacionária
}

// Calcular fee: 0.2% do valor
fn calculate_fee(service_value: Int) -> Int {
 service_value * 2 / 1000
}

// Calcular burn: 30% da fee
fn calculate_burn(fee: Int) -> Int {
 fee * 30 / 100
}

// Validar que os valores estão correctos
fn valid_amounts(datum: FeeDatum) -> Bool {
 let expected_fee = calculate_fee(datum.service_value)
 let expected_burn = calculate_burn(datum.fee_amount)
 datum.fee_amount == expected_fee &&
 datum.burn_amount == expected_burn
}

validator ergentum_fees {
 spend(_datum: Option<Data>, datum: FeeDatum, redeemer: FeeRedeemer, ctx: ScriptContext) -> Bool {
   let Transaction { extra_signatories, .. } = ctx.transaction
   when redeemer is {
     PayFee ->
       // Valores correctos + pagador assinou
       valid_amounts(datum) &&
       list.has(extra_signatories, datum.payer)
     BurnFee ->
       // Qualquer participante pode iniciar o burn
       valid_amounts(datum)
   }
 }
}
