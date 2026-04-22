use aiken/list
use aiken/transaction.{ScriptContext, Transaction}
use aiken/transaction/credential.{VerificationKey}

pub type NodeTier {
 Light
 Standard
 Professional
 Sovereign
}

pub type NodeDatum {
 node_id: VerificationKey,
 tier: NodeTier,
 stake_amount: Int,
}

pub type NodeRedeemer {
 Register
 Unregister
}

fn min_stake(tier: NodeTier) -> Int {
 when tier is {
 Light -> 1000
 Standard -> 5000
 Professional -> 25000
 Sovereign -> 100000
 }
}

validator ergentum_node {
 spend(_datum: Option<Data>, datum: NodeDatum, redeemer: NodeRedeemer, ctx: ScriptContext) -> Bool {
 let Transaction { extra_signatories, .. } = ctx.transaction
 when redeemer is {
 Register ->
 datum.stake_amount >= min_stake(datum.tier)
 Unregister ->
 list.has(extra_signatories, datum.node_id)
 }
 }
}
