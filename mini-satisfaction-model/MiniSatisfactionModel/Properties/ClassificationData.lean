/-
# Satisfaction Model: Classification Data

Model invariants: type spaces, Stone space of S_n(T), stability spectrum.
Classification-theoretic data computed from theories.
-/

import MiniSatisfactionModel.Properties.Classification
import MiniCardinalOrdinal.Core.Basic

namespace MiniSatisfactionModel

/-! ## Spectrum Function -/

def spectrumFunction (T : ClassifiedTheory) (κ : Nat) : Nat :=
  match T.stability with
  | .unstable => 2 ^ κ
  | .stable => κ
  | .superstable => κ + 1
  | .ωStable => κ
  | .totallyTranscendental => 1

def IofT (T : ClassifiedTheory) (κ : Nat) : Nat :=
  spectrumFunction T κ

/-! ## Type Spaces -/

def typeSpace (T : ClassifiedTheory) (n : Nat) : Set (List (MiniLogicKernel.PredFormula)) :=
  { p | True }

def stoneSpaceOfT (T : ClassifiedTheory) (n : Nat) : Nat :=
  typeSpace T n |>.toList.length

/-! ## Stability Spectrum -/

def stabilitySpectrum (T : ClassifiedTheory) : List (Nat × MiniCardinalOrdinal.StabilityClass) :=
  [(0, T.stability)]

def isStableIn (T : ClassifiedTheory) (κ : Nat) : Bool :=
  match T.stability with
  | .unstable => false
  | .stable => true
  | .superstable => true
  | .ωStable => true
  | .totallyTranscendental => true

/-! ## Counting Models -/

def countModels (T : ClassifiedTheory) (κ : Nat) : Nat :=
  if T.aleph0Categorical && κ = 0 then 1
  else if T.aleph1Categorical && κ = 1 then 1
  else spectrumFunction T κ

/-! ## Classification Invariants -/

structure ModelInvariants (T : ClassifiedTheory) where
  cardinality : Nat
  morleyRank : Nat
  stabilityClass : MiniCardinalOrdinal.StabilityClass
  num1Types : Nat
  num2Types : Nat
  isTotalTranscendental : Bool
  deriving Repr

def computeInvariants (T : ClassifiedTheory) : ModelInvariants T :=
  { cardinality := 0
    morleyRank := 1
    stabilityClass := T.stability
    num1Types := stoneSpaceOfT T 1
    num2Types := stoneSpaceOfT T 2
    isTotalTranscendental := T.stability == .totallyTranscendental
  }

/-! ## Morley Rank -/

def morleyRank (T : ClassifiedTheory) (φ : MiniLogicKernel.PredFormula) : Nat := 0

def morleyDegree (T : ClassifiedTheory) (φ : MiniLogicKernel.PredFormula) (α : Nat) : Nat := 1

/-! ## Stable Theories -/

def isStableTheory (T : ClassifiedTheory) : Bool :=
  T.stability != MiniCardinalOrdinal.StabilityClass.unstable

def isSuperstableTheory (T : ClassifiedTheory) : Bool :=
  match T.stability with
  | .superstable | .ωStable | .totallyTranscendental => true
  | _ => false

/-! ## Categoricity Data -/

def categoricityInPower (T : ClassifiedTheory) (κ : Nat) : Bool :=
  countModels T κ = 1

def isCategorical (T : ClassifiedTheory) (κ : Nat) : Prop :=
  countModels T κ = 1

/-! ## Shelah's Classification -/

def shelahClass (T : ClassifiedTheory) : String :=
  match T.stability with
  | .unstable => "Class I (unstable)"
  | .stable => "Class II (stable)"
  | .superstable => "Class III (superstable)"
  | .ωStable => "Class IV (ω-stable)"
  | .totallyTranscendental => "Class IV (totally transcendental)"

/-! ## #eval Examples -/

#eval spectrumFunction dloClassification 0
#eval spectrumFunction acf0Classification 1
#eval isStableIn dloClassification 0
#eval isStableIn acf0Classification 0
#eval shelahClass dloClassification
#eval shelahClass acf0Classification
#eval countModels dloClassification 0
#eval computeInvariants rcfClassification

end MiniSatisfactionModel
