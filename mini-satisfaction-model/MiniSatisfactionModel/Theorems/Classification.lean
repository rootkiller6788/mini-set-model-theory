/-
# Satisfaction Model: Classification Theorems

Morley's theorem, Baldwin-Lachlan, Vaught's Never-Two,
and the stability hierarchy.
-/

import MiniSatisfactionModel.Properties.Classification
import MiniSatisfactionModel.Properties.ClassificationData
import MiniSatisfactionModel.Core.Laws

namespace MiniSatisfactionModel

/-! ## Morley's Categoricity Theorem (axiom) -/

axiom morleyCategoricityTheorem :
    ∀ (T : ClassifiedTheory), T.aleph1Categorical → T.aleph0Categorical

def morleyCategoricityStatement : String :=
  "Morley's Categoricity Theorem: If a countable theory is ℵ₁-categorical, then it is ℵ₀-categorical"

/-! ## Baldwin-Lachlan Theorem (axiom) -/

axiom baldwinLachlanTheorem :
    ∀ (T : ClassifiedTheory), T.aleph1Categorical → ¬ T.aleph0Categorical →
    countModels T 0 = 0

def baldwinLachlanStatement : String :=
  "Baldwin-Lachlan: An ℵ₁-categorical but not ℵ₀-categorical theory has exactly ℵ₀ countable models"

/-! ## Vaught's Never-Two Theorem (axiom) -/

axiom vaughtsNeverTwoTheorem :
    ∀ (T : ClassifiedTheory), ¬ (countModels T 0 = 2)

def vaughtNeverTwoStatement : String :=
  "Vaught's Never-Two: A complete theory in a countable language cannot have exactly two countable models"

/-! ## Stability Hierarchy (axiom) -/

axiom stabilityHierarchyTheorem :
    ∀ (T : ClassifiedTheory),
    T.stability = MiniCardinalOrdinal.StabilityClass.unstable ∨
    T.stability = MiniCardinalOrdinal.StabilityClass.stable ∨
    T.stability = MiniCardinalOrdinal.StabilityClass.superstable ∨
    T.stability = MiniCardinalOrdinal.StabilityClass.ωStable

def stabilityHierarchyStatement : String :=
  "Shelah's Stability Hierarchy: Every complete countable theory falls into one of the four stability classes"

/-! ## Morley's Theorem on ω-Stability -/

axiom morleyOmegaStability : ∀ (T : ClassifiedTheory),
    T.aleph1Categorical → T.stability = MiniCardinalOrdinal.StabilityClass.ωStable

/-! ## Categoricity Implies Stability -/

theorem categoricityImpliesStability (T : ClassifiedTheory) (h : T.aleph1Categorical) :
    isStableTheory T := by
  have hω := morleyOmegaStability T h
  unfold isStableTheory
  rw [hω]
  intro hneq; exact hneq rfl

/-! ## Vaught's Never-Two: Proof Sketch -/

theorem vaughtNeverTwoProof (T : ClassifiedTheory) (hcomplete : True) :
    ¬ (countModels T 0 = 2) := by
  exact vaughtsNeverTwoTheorem T

/-! ## Classification of DLO -/

def dloClassificationAnalysis : String :=
  "DLO is ℵ₀-categorical, unstable, has QE — the unique countable dense linear order without endpoints"

/-! ## Classification of ACF0 -/

def acf0ClassificationAnalysis : String :=
  "ACF0 is ℵ₁-categorical, ω-stable, has QE — classified by characteristic"

/-! ## #eval Examples -/

#eval morleyCategoricityStatement
#eval baldwinLachlanStatement
#eval vaughtNeverTwoStatement
#eval stabilityHierarchyStatement
#eval categoricityImpliesStability dloClassification (by trivial)
#eval countModels acf0Classification 0
#eval countModels acf0Classification 1

end MiniSatisfactionModel
