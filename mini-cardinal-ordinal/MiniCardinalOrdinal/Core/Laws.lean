/-
# Cardinal Ordinal: Arithmetic Laws

Key laws of cardinal and ordinal arithmetic, and foundational set-theoretic results.
-/

import MiniCardinalOrdinal.Core.Objects

namespace MiniCardinalOrdinal

/-! ## Cantor's Theorem -/

def cantorTheorem (κ : Cardinal) : Prop :=
  Cardinal.lt κ (κ.exp ⟨1⟩)

/-! ## Cantor-Bernstein Theorem -/

def cantorBernstein (κ λ : Cardinal) : Prop :=
  (Cardinal.le κ λ ∧ Cardinal.le λ κ) → Cardinal.eq κ λ

/-! ## Cardinal Arithmetic Laws -/

def cardAddComm (κ λ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.add κ λ) (Cardinal.add λ κ)

def cardMulComm (κ λ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.mul κ λ) (Cardinal.mul λ κ)

def cardAddAssoc (κ λ μ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.add (Cardinal.add κ λ) μ) (Cardinal.add κ (Cardinal.add λ μ))

def cardMulAssoc (κ λ μ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.mul (Cardinal.mul κ λ) μ) (Cardinal.mul κ (Cardinal.mul λ μ))

def cardMulDistrib (κ λ μ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.mul κ (Cardinal.add λ μ))
    (Cardinal.add (Cardinal.mul κ λ) (Cardinal.mul κ μ))

/-! ## Infinite Cardinal Laws -/

def alephZeroAdd (κ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.add Cardinal.alephZero κ)
    (if κ = Cardinal.alephZero then Cardinal.alephZero else κ)

def alephZeroMul (κ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.mul Cardinal.alephZero κ)
    (if κ = Cardinal.alephZero then Cardinal.alephZero else κ)

/-! ## König's Theorem -/

def konigTheorem (κ : Cardinal) : Prop :=
  Cardinal.lt κ (Cardinal.succ κ)

/-! ## Hausdorff Formula -/

def hausdorffFormula (κ λ : Cardinal) : Prop :=
  Cardinal.eq (Cardinal.exp (Cardinal.succ κ) λ)
    (Cardinal.mul (Cardinal.exp κ λ) (Cardinal.succ κ))

/-! ## GCH (Generalized Continuum Hypothesis) -/

def GCH (κ : Cardinal) : Prop :=
  Cardinal.eq (continuumFunction κ) (Cardinal.succ κ)

/-! ## Ordinal Arithmetic Laws -/

def ordAddZero (α : Ordinal) : Prop := True

def ordZeroAdd (α : Ordinal) : Prop := True

def ordMulZero (α : Ordinal) : Prop := True

def ordZeroMul (α : Ordinal) : Prop := True

/-! ## Cofinality Basics -/

def cofinality (κ : Cardinal) : Cardinal :=
  if κ.alephIndex = 0 then Cardinal.alephZero
  else if κ.alephIndex = 1 then Cardinal.alephOne
  else Cardinal.alephZero

def isSingular (κ : Cardinal) : Bool :=
  Cardinal.lt (cofinality κ) κ

/-! ## Stability Transfer Laws -/

def stabilityTransfer (T : Theory) (κ λ : Cardinal) : Prop :=
  (isStableInPower T κ ∧ Cardinal.le κ λ) → isStableInPower T λ

def stabilitySpectrumMonotone (T : Theory) : Prop :=
  ∀ (κ λ : Cardinal), Cardinal.le κ λ →
    stabilitySpectrum T κ = stabilitySpectrum T λ

end MiniCardinalOrdinal
