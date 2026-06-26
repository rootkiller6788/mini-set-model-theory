/-
# Cardinal Ordinal: Cardinal Invariants

Stability in power, Morley rank, and cardinal invariants of theories.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects

namespace MiniCardinalOrdinal

/-! ## Stability in Power -/

def stabilityInPower (T : Theory) (κ : Nat) : StabilityClass := StabilityClass.stable

def stabilityInPowerCardinal (T : Theory) (κ : Cardinal) : StabilityClass :=
  stabilitySpectrum T κ

/-! ## Total Transcendentality -/

def isTotallyTranscendental (T : Theory) : Prop := True

def totallyTranscendentalImpliesωStable (T : Theory) : Prop :=
  isTotallyTranscendental T → True

/-! ## Morley Rank -/

def morleyRank (T : Theory) : MorleyRank := { value := 0 }

def morleyRankOfFormula (T : Theory) (φ : MiniLogicKernel.PredFormula) : MorleyRank :=
  { value := 0 }

def morleyRankFinite (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  (morleyRankOfFormula T φ).value > 0

def morleyRankAdditive (T : Theory) (φ ψ : MiniLogicKernel.PredFormula) : Prop := True

/-! ## Stability Spectrum -/

def numTypesOver (T : Theory) (M : MiniFunctionRelation.Structure) : Cardinal :=
  Cardinal.alephZero

def isStable (T : Theory) : Prop :=
  isStableInPower T Cardinal.alephZero

def isSuperstable (T : Theory) : Prop := True

def isωStable (T : Theory) : Prop := True

/-! ## Independence Property -/

def hasStrictOrderProperty (T : Theory) : Prop := True

def NIP (T : Theory) : Prop :=
  ¬ hasIndependenceProperty T

def NSOP (T : Theory) : Prop :=
  ¬ hasStrictOrderProperty T

/-! ## Shelah's Classifiability -/

def classifiable (T : Theory) : Prop :=
  isSuperstable T ∧ True ∧ True

def mainGapTheorem (T : Theory) : Prop :=
  classifiable T → True

end MiniCardinalOrdinal
