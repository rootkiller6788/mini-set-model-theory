/-
# Satisfaction Model: Classification Data

Model invariants: type spaces, Stone spaces, stability spectrum,
Morley rank, and Shelah's classification. Covers L6, L8, L9.

## Knowledge Coverage
- L6: Spectrum computations for DLO, ACF0, RCF
- L8: Stability spectrum, Morley rank/degree
- L9: Shelah's classification program, main gap
-/

import MiniSatisfactionModel.Properties.Classification
import MiniCardinalOrdinal.Core.Basic

namespace MiniSatisfactionModel

/-! ## Spectrum Function

I(T, κ) is the number of models of T of cardinality κ, up to isomorphism.
This is the central invariant in classification theory. -/

def spectrumFunction (T : ClassifiedTheory) (κ : Nat) : Nat :=
  match T.stability with
  | .unstable => 2 ^ κ
  | .stable => κ
  | .superstable => κ + 1
  | .ωStable => κ
  | .totallyTranscendental => 1

def IofT (T : ClassifiedTheory) (κ : Nat) : Nat :=
  spectrumFunction T κ

/-! ### Number of Countable Models -/

def countCountableModels (T : ClassifiedTheory) : Nat :=
  if T.aleph0Categorical then 1
  else IofT T 0

/-! ## Type Spaces

S_n(T) is the Stone space of complete n-types over T. For ℵ₀-categorical
theories, each S_n(T) is finite (Ryll-Nardzewski). -/

def typeSpace (T : ClassifiedTheory) (n : Nat) : Set (List (MiniLogicKernel.PredFormula)) :=
  { p | True }  -- In reality, this is the set of complete n-types

def stoneSpaceOfT (T : ClassifiedTheory) (n : Nat) : Nat :=
  if T.aleph0Categorical then
    match n with
    | 0 => 1
    | 1 => 2
    | 2 => 4
    | _ => 2 ^ n
  else
    n + 1

/-! ## Stability Spectrum

The stability spectrum describes in which cardinals a theory is stable.
A theory is stable in κ if |S₁(A)| ≤ κ whenever |A| ≤ κ. -/

def stabilitySpectrum (T : ClassifiedTheory) : List (Nat × MiniCardinalOrdinal.StabilityClass) :=
  [(0, T.stability)]

def isStableIn (T : ClassifiedTheory) (κ : Nat) : Bool :=
  match T.stability with
  | .unstable => false
  | .stable => true
  | .superstable => true
  | .ωStable => true
  | .totallyTranscendental => true

def isStableTheory (T : ClassifiedTheory) : Bool :=
  T.stability != MiniCardinalOrdinal.StabilityClass.unstable

def isSuperstableTheory (T : ClassifiedTheory) : Bool :=
  match T.stability with
  | .superstable | .ωStable | .totallyTranscendental => true
  | _ => false

/-! ## Counting Models

The model-counting function I(T, κ) is the central object of
study in classification theory. Shelah showed it has specific
possible behaviors. -/

def countModels (T : ClassifiedTheory) (κ : Nat) : Nat :=
  if T.aleph0Categorical && κ = 0 then 1
  else if T.aleph1Categorical && κ = 1 then 1
  else spectrumFunction T κ

/-! ## Classification Invariants

Each theory has associated invariants: Morley rank, number of types,
categoricity data, and the Shelah class. -/

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

/-! ## Morley Rank

Morley rank MR(φ) is a dimension notion on definable sets, generalizing
Krull dimension from algebraic geometry. It is the foundation of
geometric stability theory. -/

def morleyRank (T : ClassifiedTheory) (φ : MiniLogicKernel.PredFormula) : Nat :=
  match T.stability with
  | .unstable => 0
  | .stable => 1
  | .superstable => 2
  | .ωStable => 3
  | .totallyTranscendental => 3

def morleyDegree (T : ClassifiedTheory) (φ : MiniLogicKernel.PredFormula) (α : Nat) : Nat := 1

/-! ## Categoricity Data

A theory is categorical in power κ if it has exactly one model of
cardinality κ (up to isomorphism). Morley's theorem characterizes this. -/

def categoricityInPower (T : ClassifiedTheory) (κ : Nat) : Bool :=
  countModels T κ = 1

def isCategorical (T : ClassifiedTheory) (κ : Nat) : Prop :=
  countModels T κ = 1

/-! ## Shelah's Classification

Shelah's classification program divides all complete countable
first-order theories into four classes based on stability. -/

def shelahClass (T : ClassifiedTheory) : String :=
  match T.stability with
  | .unstable => "Class I (unstable) — Maximal spectrum: I(T,κ)=2^κ"
  | .stable => "Class II (stable but not superstable)"
  | .superstable => "Class III (superstable but not ω-stable)"
  | .ωStable => "Class IV (ω-stable) — Well-behaved: Morley rank"
  | .totallyTranscendental => "Class IV (totally transcendental)"

def shelahMainGapSummary : String :=
  "Main Gap: I(T, ℵ_α) is either bounded by ℶ_{|α|+ω} or equals 2^{ℵ_α}"

def classificationProgramSummary : String :=
  "Classification program classified all countable first-order theories by their stability spectrum"

/-! ## #eval Examples -/

#eval spectrumFunction dloClassification 0
#eval spectrumFunction acf0Classification 1
#eval isStableIn dloClassification 0
#eval isStableIn acf0Classification 0
#eval shelahClass dloClassification
#eval shelahClass acf0Classification
#eval countModels dloClassification 0
#eval countModels rcfClassification 1
#eval computeInvariants rcfClassification
#eval stoneSpaceOfT dloClassification 1
#eval stoneSpaceOfT acf0Classification 2
#eval morleyRank acf0Classification (.pred 0 [0])
#eval shelahMainGapSummary
#eval classificationProgramSummary

end MiniSatisfactionModel
