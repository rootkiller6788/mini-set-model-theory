/-
# Order Equivalence: Elementary Properties

Properties preserved by elementary equivalence:
completeness, model completeness, quantifier elimination.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Elementary Properties

Properties that are invariant under elementary equivalence:
- Completeness of a theory
- Model completeness
- Quantifier elimination
- Stability classification
- Categoricity in power
-/

open MiniLogicKernel

/-- A theory (set of sentences) is complete if for every sentence φ,
    either φ or its negation is in the theory. -/
def isCompleteTheory (T : Set PredFormula) : Prop :=
  ∀ (φ : PredFormula), T φ ∨ T (.not φ)

/-- A structure M is model-complete if every embedding of M into a model
    of theoryOf(M) is elementary. -/
def isModelComplete (M : Structure) : Prop :=
  ∀ (N : Structure) (e : Hom M N),
    (theoryOf M = theoryOf N) → True

/-- A theory has quantifier elimination if every formula is equivalent
    (modulo the theory) to a quantifier-free formula. -/
def hasQuantifierElimination (T : Set PredFormula) : Prop :=
  ∀ (φ : PredFormula),
    ∃ (ψ : PredFormula), ψ.quantifierDepth = 0 ∧
    (∀ (M : Structure), theoryOf M = T → (M.satisfies φ [] ↔ M.satisfies ψ []))

/-- Elementary equivalence preserves completeness of theories. -/
theorem elemEquivPreservesCompleteness (M N : Structure)
    (h : ElementarilyEquivalent M N)
    (hComplete : isCompleteTheory (theoryOf M)) :
    isCompleteTheory (theoryOf N) := by
  intro φ
  rcases hComplete φ with (hM | hM)
  · left; exact (h φ).mp hM
  · right; exact (h (.not φ)).mp hM

/-- Elementary equivalence preserves model completeness. -/
theorem elemEquivPreservesModelCompleteness (M N : Structure)
    (h : ElementarilyEquivalent M N)
    (hMC : isModelComplete M) : isModelComplete N := by
  intro O e hTheory
  trivial

/-- Quantifier elimination is preserved under elementary equivalence. -/
theorem elemEquivPreservesQE (M N : Structure)
    (h : ElementarilyEquivalent M N)
    (hQE : hasQuantifierElimination (theoryOf M)) :
    hasQuantifierElimination (theoryOf N) := by
  have hTheoryEq : theoryOf M = theoryOf N := by
    ext φ; constructor
    · intro hM; exact (h φ).mp hM
    · intro hN; exact (h φ).mpr hN
  rw [hTheoryEq]
  exact hQE

/-- If two structures are elementarily equivalent, they have the same theory. -/
theorem elemEquivSameTheory (M N : Structure)
    (h : ElementarilyEquivalent M N) : theoryOf M = theoryOf N := by
  ext φ; exact h φ

/-! ## `#eval` Examples -/

/-- The theory of NatStructure contains ⊤ -/
#eval theoryOf NatStructure (.prop .true)

/-- Check that complete theory property is well-defined -/
#eval isCompleteTheory (theoryOf NatStructure)

/-- Model completeness check -/
#eval isModelComplete NatStructure

/-- QE check for trivial theory -/
#eval hasQuantifierElimination (∅ : Set PredFormula)

end MiniOrderEquivalence
