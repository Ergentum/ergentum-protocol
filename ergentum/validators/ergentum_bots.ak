use aiken/list
use aiken/transaction.{ScriptContext, Transaction}
use aiken/transaction/credential.{VerificationKey}

// Categorias de bots
pub type BotCategory {
 Legal // Jurídico
 Medical // Médico
 Finance // Financeiro
 Technical // Técnico
 General // Geral
}

// Datum do bot registado
pub type BotDatum {
 bot_id: VerificationKey,
 creator_id: VerificationKey,
 category: BotCategory,
 deploy_fee: Int, // Fee pago em lovelace (simulando ERGON)
 active: Bool,
}

// Acções
pub type BotRedeemer {
 Deploy // Registar bot (paga fee)
 Deactivate // Desactivar bot
 Update // Actualizar metadados
}

// Fee mínima de deploy: 100 ERGON simulados
fn min_deploy_fee() -> Int {
  100
}

validator ergentum_bots {
 spend(_datum: Option<Data>, datum: BotDatum, redeemer: BotRedeemer, ctx: ScriptContext) -> Bool {
   let Transaction { extra_signatories, .. } = ctx.transaction
   when redeemer is {
     Deploy ->
       // Bot válido: fee mínima paga + criador assinou
       datum.deploy_fee >= min_deploy_fee() &&
       list.has(extra_signatories, datum.creator_id)
     Deactivate ->
       // Só o criador pode desactivar
       list.has(extra_signatories, datum.creator_id)
     Update ->
       // Só o criador pode actualizar
       list.has(extra_signatories, datum.creator_id)
   }
 }
}
