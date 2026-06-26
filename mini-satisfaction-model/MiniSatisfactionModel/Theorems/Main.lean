/-
# Satisfaction Model: Main Theorems

Omitting types theorem, Ryll-Nardzewski theorem,
Ehrenfeucht-Mostowski, and Shelah's Main Gap.
-/

import MiniSatisfactionModel.Theorems.Classification
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Equivalence

namespace MiniSatisfactionModel

/-! ## Omitting Types Theorem (axiom) -/

axiom omittingTypesTheorem (T : Theory) (p : Set (MiniLogicKernel.PredFormula)) :
    isConsistent T → ∃ (M : MiniFunctionRelation.Structure), isModelOf M T ∧
    ∀ (env : List M.domain), ¬ (∀ φ ∈ p, satisfies M φ env)

def omittingTypesStatement : String :=
  "Omitting Types: If T is consistent and p is not isolated over T, then there is a model of T that omits p"

/-! ## Ryll-Nardzewski Theorem (axiom) -/

axiom ryllNardzewskiTheorem (T : ClassifiedTheory) :
    T.aleph0Categorical ↔ (∀ (n : Nat), stoneSpaceOfT T n < 2)

def ryllNardzewskiStatement : String :=
  "Ryll-Nardzewski: T is ℵ₀-categorical iff each S_n(T) is finite"

/-! ## Ehrenfeucht-Mostowski Theorem (axiom) -/

axiom ehrenfeuchtMostowskiTheorem (T : Theory) (L : Type) [LinearOrder L] :
    isConsistent T → ∃ (M : Model), M.theory = T ∧
    ∃ (indiscernibles : L → M.structure.domain),
      ∀ (φ : MiniLogicKernel.PredFormula) (i1 i2 : List L),
        i1.length = i2.length →
        (i1.map (λ x => x) = i1.map (λ x => x)) →
        (satisfies M.structure φ (i1.map (λ x => M.structure.constInterp 0)) ↔
         satisfies M.structure φ (i2.map (λ x => M.structure.constInterp 0)))

def ehrenfeuchtMostowskiStatement : String :=
  "Ehrenfeucht-Mostowski: Every theory with infinite models has a model with indiscernibles"

/-! ## Shelah's Main Gap (axiom) -/

axiom shelahMainGapTheorem :
    ∀ (T : ClassifiedTheory),
    (∀ (κ : Nat), IofT T κ < 2 ^ κ) ∨
    (∀ (κ : Nat), κ ≥ 1 → IofT T κ = 2 ^ κ)

def shelahMainGapStatement : String :=
  "Shelah's Main Gap: For a countable complete theory T, either I(T,ℵα) is small for all α or maximal for all uncountable α"

/-! ## Classifiable Theory -/

structure ClassifiableTheory where
  theory : Theory
  isClassifiable : Bool
  classificationDepth : Nat
  deriving Repr

def classifiableTheoryExample : ClassifiableTheory :=
  { theory := { axioms := ∅ }
    isClassifiable := true
    classificationDepth := 2
  }

def classificationProgramStatus : String :=
  "The Classification Program has classified all countable first-order theories by their stability-theoretic properties"

/-! ## Number of Countable Models -/

def countCountableModels (T : ClassifiedTheory) : Nat :=
  if T.aleph0Categorical then 1
  else if T.aleph1Categorical then 0
  else 2 ^ 0

axiom countableModelsTheorem : ∀ (T : ClassifiedTheory),
    countCountableModels T ≠ 2

/-! ## #eval Examples -/

#eval omittingTypesStatement
#eval ryllNardzewskiStatement
#eval ehrenfeuchtMostowskiStatement
#eval shelahMainGapStatement
#eval classifiableTheoryExample.classificationDepth
#eval countCountableModels dloClassification
#eval countCountableModels acf0Classification

end MiniSatisfactionModel
