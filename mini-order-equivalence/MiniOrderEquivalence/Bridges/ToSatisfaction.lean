/-
# Order Equivalence: Bridge to Satisfaction

Connections between elementary equivalence and the satisfaction relation.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Bridge to Satisfaction

Elementary equivalence as a generalization of the satisfaction relation:
- M ≡ N means M and N satisfy exactly the same sentences.
- The satisfaction relation ⊨ can be analyzed through the lens of
  elementary equivalence classes.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- The satisfaction relation as a binary relation between structures
    and formulas. -/
def satisfies (M : Structure) (φ : PredFormula) : Prop := M.satisfies φ []

/-- Elementary equivalence can be defined via the satisfaction relation:
    M ≡ N iff for all φ, M ⊨ φ ↔ N ⊨ φ. -/
theorem elemEquivViaSatisfaction (M N : Structure) :
    ElementarilyEquivalent M N ↔ (∀ φ, satisfies M φ ↔ satisfies N φ) := by
  rfl

/-- The satisfaction class of a formula φ is the set of structures
    that satisfy φ. -/
def satisfactionClass (φ : PredFormula) : Set Structure :=
  fun M => satisfies M φ

/-- Two formulas φ, ψ are logically equivalent if they have the same
    satisfaction class. -/
def logicallyEquivalent (φ ψ : PredFormula) : Prop :=
  satisfactionClass φ = satisfactionClass ψ

/-- Logical equivalence implies elementary equivalence for all pairs
    of structures. -/
theorem logicalEquivImpliesElemEquivAll (φ ψ : PredFormula)
    (h : logicallyEquivalent φ ψ) (M N : Structure) :
    satisfies M φ → satisfies N ψ := by
  rw [h] at M
  intro hM
  exact hM

/-- The satisfaction lemma: complex formulas are satisfied based on
    the satisfaction of subformulas. -/
theorem satisfactionLemma_and (M : Structure) (φ ψ : PredFormula) :
    satisfies M (.and φ ψ) ↔ satisfies M φ ∧ satisfies M ψ := by
  simp [satisfies, MiniLogicKernel.Structure.satisfies]

/-- Satisfaction of negation. -/
theorem satisfactionLemma_not (M : Structure) (φ : PredFormula) :
    satisfies M (.not φ) ↔ ¬ satisfies M φ := by
  simp [satisfies, MiniLogicKernel.Structure.satisfies]

/-- Satisfaction of implication. -/
theorem satisfactionLemma_impl (M : Structure) (φ ψ : PredFormula) :
    satisfies M (.impl φ ψ) ↔ (satisfies M φ → satisfies M ψ) := by
  simp [satisfies, MiniLogicKernel.Structure.satisfies]

/-- A formula is valid if it is satisfied by all structures. -/
def isValid (φ : PredFormula) : Prop :=
  satisfactionClass φ = Set.univ

/-- A formula is satisfiable if some structure satisfies it. -/
def isSatisfiableFormula (φ : PredFormula) : Prop :=
  satisfactionClass φ ≠ ∅

/-- Tautologies are valid. -/
theorem tautologyIsValid : isValid (.prop .true) := by
  ext M; simp [satisfactionClass, satisfies, isValid, MiniLogicKernel.Structure.satisfies]

/-! ## `#eval` Examples -/

/-- Satisfaction class of ⊤ -/
#eval satisfactionClass (.prop .true)

/-- Logical equivalence check -/
#eval logicallyEquivalent (.prop .true) (.prop .true)

/-- Satisfaction lemma for ∧ -/
#eval satisfactionLemma_and NatStructure (.prop .true) (.prop .true)

/-- Tautology validation -/
#eval tautologyIsValid

end MiniOrderEquivalence
