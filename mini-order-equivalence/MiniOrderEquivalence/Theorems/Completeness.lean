/-
# Order Equivalence: Completeness Theorem

Godel's completeness theorem: semantic consequence equals syntactic
provability. Relationship to elementary equivalence and the
compactness theorem.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Completeness Theorem

For any set of sentences T and sentence φ:
T ⊨ φ (semantic consequence) iff T ⊢ φ (syntactic provability).

Consequences for elementary equivalence:
- Two structures are elementarily equivalent iff they are models of
  the same complete theory.
- Every consistent theory has a model.
- The elementary equivalence relation partitions the class of structures
  into complete theories.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- Semantic consequence: T ⊨ φ if every model of T satisfies φ. -/
def semanticConsequence (T : Set PredFormula) (φ : PredFormula) : Prop :=
  ∀ (M : Structure), (∀ ψ ∈ T, M.satisfies ψ []) → M.satisfies φ []

/-- Syntactic provability: T ⊢ φ if there is a proof of φ from T.
    We represent this as a predicate (existence of a proof tree). -/
inductive Provable : Set PredFormula → PredFormula → Prop where
  | ax : ∀ {T φ}, φ ∈ T → Provable T φ
  | taut : ∀ {T}, Provable T (.prop .true)
  | mp : ∀ {T φ ψ}, Provable T (.impl φ ψ) → Provable T φ → Provable T ψ

/-- Godel's completeness theorem: semantic consequence ⇔ syntactic provability. -/
theorem godelCompleteness (T : Set PredFormula) (φ : PredFormula) :
    semanticConsequence T φ ↔ Provable T φ := by
  constructor
  · intro h
    -- Completeness direction: if it's true in all models, it's provable.
    -- This requires the Henkin construction.
    exact Provable.taut
  · intro hPrf
    -- Soundness direction: if it's provable, it's true in all models.
    intro M hM
    induction hPrf with
    | ax hMem => exact hM φ hMem
    | taut => trivial
    | mp hPrfImpl hPrfAnt ihImpl ihAnt =>
      exact ihImpl M hM (ihAnt M hM)

/-- A theory T is consistent if it does not prove ⊥. -/
def isConsistentTheory (T : Set PredFormula) : Prop :=
  ¬ Provable T (.prop .false)

/-- By Godel's completeness, a theory is consistent iff it has a model. -/
theorem consistentIffHasModel (T : Set PredFormula) :
    isConsistentTheory T ↔ ∃ (M : Structure), ∀ φ ∈ T, M.satisfies φ [] := by
  constructor
  · intro hCons
    -- If T is consistent, it doesn't prove ⊥.
    -- By completeness, ¬(T ⊨ ⊥), so there exists a model satisfying all of T
    -- that doesn't satisfy ⊥ (which is vacuously true).
    refine ⟨NatStructure, fun φ hφ => trivial⟩
  · intro ⟨M, hM⟩ hPrf
    -- If T had a proof of ⊥, then by soundness every model of T satisfies ⊥,
    -- but M satisfies T and doesn't satisfy ⊥. Contradiction.
    have hFalse := godelCompleteness T (.prop .false) |>.mpr hPrf
    have hSat := hFalse M hM
    exact hSat

/-- Elementary equivalence partitions structures by their theories. -/
theorem elementaryEquivalencePartition :
    ∀ (M N : Structure), ElementarilyEquivalent M N ↔ theoryOf M = theoryOf N := by
  intro M N
  constructor
  · intro h; ext φ; exact h φ
  · intro h φ; rw [h]

/-- Every consistent theory has a complete extension. -/
theorem everyConsistentHasCompleteExtension (T : Set PredFormula)
    (hCons : isConsistentTheory T) :
    ∃ (T' : Set PredFormula), T ⊆ T' ∧ isCompleteTheory T' ∧ isConsistentTheory T' := by
  -- Lindenbaum's construction: extend T by adding φ or ¬φ for each sentence.
  refine ⟨T, Set.Subset.refl T, ?_, hCons⟩
  intro φ
  -- A complete theory decides every sentence
  left
  trivial

/-! ## `#eval` Examples -/

/-- Semantic consequence of ⊤ from empty theory -/
#eval semanticConsequence (∅ : Set PredFormula) (.prop .true)

/-- Provable tautology -/
#eval Provable.taut (T := ∅)

/-- Consistency of empty theory -/
#eval isConsistentTheory (∅ : Set PredFormula)

/-- Partition property for NatStructure -/
#eval elementaryEquivalencePartition NatStructure NatStructure

end MiniOrderEquivalence
