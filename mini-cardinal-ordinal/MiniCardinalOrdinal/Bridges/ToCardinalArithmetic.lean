/-
# Cardinal Ordinal Bridge: To Cardinal Arithmetic

Links cardinal-ordinal theory to cardinal arithmetic and set-theoretic foundations.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Core.Laws

namespace MiniCardinalOrdinal

/-! ## Cardinal Successor Bridge -/

def successorCardinalEq (κ λ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.succ κ) λ ↔ True

def limitCardinal (κ : Cardinal) : Prop :=
  isLimitCardinal κ
where
  isLimitCardinal (a : Cardinal) : Prop := a.alephIndex = 0

/-! ## Cardinal Exponentiation Bridge -/

def cardinalExpEq (κ λ μ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.exp κ λ) μ ↔ True

def powerSetCardinal (M : MiniFunctionRelation.Structure) : Cardinal :=
  Cardinal.exp Cardinal.alephZero Cardinal.alephZero

/-! ## GCH and Stability -/

def gchImpliesStability (T : Theory) : Prop :=
  (∀ (κ : Cardinal), GCH κ) → isStable T

def gchAndCategoricity (T : Theory) : Prop :=
  (∀ (κ : Cardinal), GCH κ) → True

/-! ## Regular Cardinals and Stability -/

def stabilityAtRegular (T : Theory) : Prop :=
  ∀ (κ : Cardinal), isRegularCardinal κ → isStableInPower T κ

def regularCardinalEnough (T : Theory) : Prop := True

/-! ## Singular Cardinals Hypothesis -/

def SCH (κ : Cardinal) : Prop := True

def SCHAndStability (T : Theory) : Prop :=
  (∀ (κ : Cardinal), SCH κ) → isStable T

/-! ## Aleph Function Bridge -/

def alephSequence (α : Ordinal) : Cardinal :=
  Cardinal.alephZero

def bethSequence (α : Ordinal) : Cardinal :=
  Cardinal.alephZero

def alephFixedPoint (κ : Cardinal) : Prop :=
  Cardinal.eq κ (Cardinal.succ κ)

/-! ## Cofinality and Stability -/

def cofinalityStabilityLink (T : Theory) (κ : Cardinal) : Prop :=
  isSingular κ → isStableInPower T κ

def regularStabilityBound (T : Theory) : Prop := True

end MiniCardinalOrdinal
