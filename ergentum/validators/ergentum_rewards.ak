use aiken/list
use aiken/transaction.{ScriptContext, Transaction}
use aiken/transaction/credential.{VerificationKey}

// Datum com dados de recompensa do node
pub type RewardDatum {
  node_id: VerificationKey,
  quality_score: Int, // 0-100 baseado em uptime/latência
  hardware_score: Int, // 0-100 baseado em tier
  epoch: Int, // Época de referência
}

// Acções possíveis
pub type RewardRedeemer {
  ClaimReward // Node reclama recompensa
  UpdateScore // Actualiza score (só oracle autorizado)
}

// Calcular recompensa: 70% qualidade + 30% hardware
fn calculate_reward(datum: RewardDatum, base_reward: Int) -> Int {
  let quality_part = base_reward * 70 / 100 * datum.quality_score / 100
  let hardware_part = base_reward * 30 / 100 * datum.hardware_score / 100
  quality_part + hardware_part
}

validator ergentum_rewards {
  spend(_datum: Option<Data>, datum: RewardDatum, redeemer: RewardRedeemer, ctx: ScriptContext) -> Bool {
    let Transaction { extra_signatories, .. } = ctx.transaction
    when redeemer is {
      ClaimReward ->
        // Só o próprio node pode reclamar
        list.has(extra_signatories, datum.node_id)
      UpdateScore ->
        // Qualquer signatário autorizado pode actualizar
        list.length(extra_signatories) > 0
    }
  }
}