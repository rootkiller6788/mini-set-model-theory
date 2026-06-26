/-
# Cardinal Ordinal: Stability Theorems

The stability spectrum and classification of stable theories.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants
import MiniCardinalOrdinal.Properties.ClassificationData

namespace MiniCardinalOrdinal

/-! ## Stability Spectrum Theorem -/

def stabilitySpectrumTheorem (T : Theory) : Prop :=
  (∃ (κ : Cardinal), isStableInPower T κ) ↔
  (∃ (λ : Cardinal), ∀ (μ : Cardinal), Cardinal.le λ μ → isStableInPower T μ)

def stableInAllPowers (T : Theory) : Prop :=
  ∀ (κ : Cardinal), isStableInPower T κ

/-! ## Unstable Formula Characterisation -/

def orderPropertyTheorem (T : Theory) : Prop :=
  hasOrderProperty T ↔ ¬ isStable T

def independencePropertyTheorem (T : Theory) : Prop :=
  hasIndependenceProperty T ↔ ¬ NIP T

def strictOrderPropertyTheorem (T : Theory) : Prop :=
  hasStrictOrderProperty T ↔ ¬ NSOP T

/-! ## Forking Calculus -/

def finiteForkingTheorem (T : Theory) : Prop :=
  isStable T → forkingEqualsDividing T

def extensionProperty (T : Theory) : Prop :=
  isStable T → True

def stationarity (T : Theory) : Prop :=
  isStable T → True

/-! ## ω-Stability and Prime Models -/

def ωStableImpliesTotallyTranscendental (T : Theory) : Prop :=
  isωStable T → isTotallyTranscendental T

def primeModelOver (T : Theory) (A : Set Nat) : Prop := True

def primeModelUnique (T : Theory) : Prop :=
  isωStable T → True

/-! ## Shelah's Uniqueness Theorem -/

def shelahUniqueness (T : Theory) : Prop :=
  isωStable T → True

def constructibleModel (T : Theory) (M : MiniFunctionRelation.Structure) : Prop :=
  isModelOf M T ∧ isωStable T

end MiniCardinalOrdinal
