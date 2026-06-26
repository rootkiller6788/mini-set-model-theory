/-
# Cardinal Ordinal: Preservation Theorems

Stability and invariants preserved under model-theoretic constructions.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Stability Preservation -/

def stabilityUnderReduct (T : Theory) : Prop := True

def stabilityUnderExpansion (T : Theory) : Prop := True

def stabilityUnderInterpretation (T S : Theory) : Prop := True

def stabilityPreservedByProduct (T : Theory) : Prop := True

/-! ## Categoricity Preservation -/

def categoricityTransfer (T : Theory) (κ λ : Cardinal) : Prop :=
  (isCategoricalInPower T κ ∧ Cardinal.lt κ λ) → isCategoricalInPower T λ

def morleyCategoricity (T : Theory) : Prop :=
  ∃ (κ : Cardinal), Cardinal.lt Cardinal.alephOne κ ∧ isCategoricalInPower T κ →
  ∀ (λ : Cardinal), Cardinal.lt Cardinal.alephOne (Cardinal.succ λ) →
  isCategoricalInPower T (Cardinal.succ λ)

/-! ## Rank Preservation -/

def morleyRankUnderExpansion (T : Theory) : Prop := True

def morleyRankUnderInterpretation (T S : Theory) : Prop := True

/-! ## Forking Preservation -/

def nonforkingUnderSubstructure (T : Theory) : Prop := True

def nonforkingUnderUnion (T : Theory) : Prop := True

def symmetryOfForking (T : Theory) : Prop := True

def transitivityOfForking (T : Theory) : Prop := True

/-! ## Indiscernible Preservation -/

def indiscernibleSequence (T : Theory) (I : List Nat) : Prop := True

def indiscerniblesExist (T : Theory) : Prop := True

def orderIndiscernibles (T : Theory) : Prop := True

end MiniCardinalOrdinal
