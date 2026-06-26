/-
# Cardinal Ordinal: Categoricity Theorems

Morley's categoricity theorem and related results on uniqueness of models.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Iso
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Morley's Categoricity Theorem -/

def morleyCategoricityTheorem (T : Theory) : Prop :=
  (∃ (κ : Cardinal), Cardinal.lt Cardinal.alephOne κ ∧
    isCategoricalInPower T κ) →
  (∀ (λ : Cardinal), Cardinal.lt Cardinal.alephOne λ →
    isCategoricalInPower T λ)

def morleyUncountablyCategorical (T : Theory) : Prop :=
  ∃ (κ : Cardinal), Cardinal.lt Cardinal.alephOne κ ∧ isCategoricalInPower T κ

/-! ## Baldwin-Lachlan Theorem -/

def countableCategorical (T : Theory) : Prop :=
  isCategoricalInPower T Cardinal.alephZero

def baldwinLachlanTheorem (T : Theory) : Prop :=
  countableCategorical T → True

/-! ## Los-Vaught Test -/

def losVaught (T : Theory) : Prop :=
  (∀ (M N : MiniFunctionRelation.Structure),
    isModelOf M T → isModelOf N T → isInfinite M → isInfinite N) → True
where
  isInfinite (M : MiniFunctionRelation.Structure) : Prop := True

/-! ## Vaught's Never-2 Theorem -/

def vaughtNeverTwo (T : Theory) : Prop :=
  isComplete T → numCountableModels T Cardinal.alephZero ≠ 2

def countableModelsNotTwo (T : Theory) : Prop :=
  numCountableModels T Cardinal.alephZero ≠ 2

/-! ## Ryll-Nardzewski Theorem -/

def ryllNardzewskiTheorem (T : Theory) : Prop :=
  countableCategorical T ↔ True

def oligomorphic (T : Theory) : Prop := True

/-! ## Ehrenfeucht Theorem -/

def ehrenfeuchtTheorem (T : Theory) : Prop :=
  ¬ isCategoricalInPower T Cardinal.alephZero → True

def hasExactlyNModels (T : Theory) (n : Nat) : Prop :=
  numCountableModels T Cardinal.alephZero = n

end MiniCardinalOrdinal
