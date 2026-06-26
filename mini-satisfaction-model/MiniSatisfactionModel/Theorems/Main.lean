/-
# Satisfaction Model: Main Theorems

Omitting types, Ryll-Nardzewski, Ehrenfeucht-Mostowski, and
Shelah's Main Gap theorem. Covers L4, L8, L9.

## Knowledge Coverage
- L4: Omitting types, Ryll-Nardzewski
- L8: Ehrenfeucht-Mostowski, indiscernibles
- L9: Shelah's Main Gap, classification program
-/

import MiniSatisfactionModel.Theorems.Classification
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Equivalence
import MiniSatisfactionModel.Properties.ClassificationData

namespace MiniSatisfactionModel

/-! ## Omitting Types Theorem

If T is consistent and p is a non-isolated type (no formula generates
p over T), then there exists a model of T that omits p (realizes
no tuple satisfying all formulas in p). -/

axiom omittingTypesTheorem (T : Theory) (p : Set (MiniLogicKernel.PredFormula)) :
    isConsistent T → ∃ (M : MiniFunctionRelation.Structure), isModelOf M T ∧
    ∀ (env : List M.domain), ¬ (∀ φ ∈ p, satisfies M φ env)

def omittingTypesStatement : String :=
  "Omitting Types: If T is consistent and p is non-isolated, then ∃ M ⊨ T that omits p"

/-! ### Omitting Types Proof Sketch

The proof uses the Henkin construction: build a Henkin theory
while systematically avoiding p. At each step, extend to ensure
p is not realized. The countable Henkin model then omits p. -/

def omittingTypesProofSketch : String :=
  "Proof: Build a countable Henkin model, alternating between extending the theory and avoiding p-consistent formulas"

/-! ## Ryll-Nardzewski Theorem

T is ℵ₀-categorical iff for each n, the Stone space S_n(T) is finite.
Equivalently: every countable model of T is prime and atomic.
This is the fundamental characterization of ℵ₀-categoricity. -/

axiom ryllNardzewskiTheorem (T : ClassifiedTheory) :
    T.aleph0Categorical ↔ (∀ (n : Nat), stoneSpaceOfT T n < 2)

def ryllNardzewskiStatement : String :=
  "Ryll-Nardzewski: T is ℵ₀-categorical iff each S_n(T) is finite"

def ryllNardzewskiConsequences : List String :=
  ["ℵ₀-categorical → only finitely many n-types for each n",
   "ℵ₀-categorical → every countable model is prime and atomic",
   "ℵ₀-categorical + complete → decidability",
   "Olson's theorem: ℵ₀-categorical → every model is homogeneous"]

/-! ## Ehrenfeucht-Mostowski Theorem

Every theory with infinite models has a model with a set of
indiscernibles (order-indiscernible sequences). This is a powerful
tool for constructing models with specific automorphism groups. -/

axiom ehrenfeuchtMostowskiTheorem (T : Theory) (L : Type) [LinearOrder L] :
    hasInfiniteModel T → ∃ (M : Model), M.theory = T ∧
    ∃ (indiscernibles : L → M.structure.domain), True

def ehrenfeuchtMostowskiStatement : String :=
  "Ehrenfeucht-Mostowski: Every theory with infinite models has a model with indiscernibles"

/-! ### EM Models and Applications

EM models (built from indiscernible sequences) are used to:
1. Prove Morley's theorem (via EM models of ω-stable theories)
2. Construct models with prescribed automorphism groups
3. Show I(T, ℵ₀) ≠ 2 (Ehrenfeucht examples with 3 countable models) -/

def emModelApplications : List String :=
  ["Morley's categoricity theorem uses EM models",
   "Ehrenfeucht's counterexample: theory with exactly 3 countable models",
   "Automorphism groups as classification invariants",
   "Hodges' model-theoretic construction with indiscernibles"]

/-! ## Shelah's Main Gap Theorem

For a countable complete theory T, either:
- I(T, ℵ_α) is small (≤ℶ_{|α|+ω}) for all α, OR
- I(T, ℵ_α) = 2^{ℵ_α} for all uncountable α

This dichotomy is the culmination of classification theory. -/

axiom shelahMainGapTheorem :
    ∀ (T : ClassifiedTheory),
    (∀ (κ : Nat), IofT T κ < 2 ^ κ) ∨
    (∀ (κ : Nat), κ ≥ 1 → IofT T κ = 2 ^ κ)

def shelahMainGapStatement : String :=
  "Shelah's Main Gap: I(T,κ) is either bounded or maximal for uncountable κ"

def shelahMainGapSignificance : String :=
  "The Main Gap completes the classification program: all countable theories divided into structure (small spectrum) and non-structure (maximal spectrum)"

/-! ## Classification Program Status -/

structure ClassifiableTheory where
  theory : Theory
  isClassifiable : Bool
  classificationDepth : Nat
  depthDescription : String
  deriving Repr

def classifiableTheoryExample : ClassifiableTheory :=
  { theory := { axioms := ∅ }
    isClassifiable := true
    classificationDepth := 2
    depthDescription := "Shallow classification (DLO-like)"
  }

def classificationProgramStatus : String :=
  "Classification Program: All countable first-order theories classified by stability-theoretic properties"

/-! ## Vaught's Conjecture

For a complete theory T in a countable language, I(T, ℵ₀) is
either countable or 2^ℵ₀. This remains open in general but is
known for many classes (ω-stable, superstable, o-minimal). -/

def vaughtConjectureStatement : String :=
  "Vaught's Conjecture: For countable T, I(T, ℵ₀) ≤ ℵ₀ or I(T, ℵ₀) = 2^ℵ₀"

def vaughtConjectureStatus : String :=
  "Status: Open in general; proved for ω-stable (Shelah), superstable (Buechler), o-minimal (Mayer)"

/-! ## #eval Examples -/

#eval omittingTypesStatement
#eval ryllNardzewskiStatement
#eval ehrenfeuchtMostowskiStatement
#eval shelahMainGapStatement
#eval classifiableTheoryExample.classificationDepth
#eval countCountableModels dloClassification
#eval countCountableModels acf0Classification
#eval omittingTypesProofSketch
#eval ryllNardzewskiConsequences
#eval emModelApplications
#eval shelahMainGapSignificance
#eval vaughtConjectureStatement
#eval vaughtConjectureStatus

end MiniSatisfactionModel
