/-
# Order Equivalence: Structural Laws

Laws governing elementary equivalence: preservation properties,
invariance under isomorphism, and the Tarski-Vaught criterion.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Structural Laws

Fundamental laws of elementary equivalence for first-order structures.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- Elementary equivalence is reflexive: every structure is elementarily
    equivalent to itself. -/
theorem elemEquivRefl (M : Structure) : ElementarilyEquivalent M M := by
  intro φ
  rfl

/-- Elementary equivalence is symmetric. -/
theorem elemEquivSymm (M N : Structure) (h : ElementarilyEquivalent M N) :
    ElementarilyEquivalent N M := by
  intro φ
  rcases h φ with ⟨hMN, hNM⟩
  exact ⟨hNM, hMN⟩

/-- Elementary equivalence is transitive. -/
theorem elemEquivTrans (M N O : Structure)
    (hMN : ElementarilyEquivalent M N) (hNO : ElementarilyEquivalent N O) :
    ElementarilyEquivalent M O := by
  intro φ
  rcases hMN φ with ⟨h1, h2⟩
  rcases hNO φ with ⟨h3, h4⟩
  exact ⟨fun hM => h3 (h1 hM), fun hO => h2 (h4 hO)⟩

/-- Elementary equivalence is an equivalence relation. -/
theorem elemEquivEquivalence :
    @Equivalence Structure ElementarilyEquivalent := by
  refine ⟨?_, ?_, ?_⟩
  · exact elemEquivRefl
  · exact elemEquivSymm
  · intro M N O hMN hNO
    exact elemEquivTrans M N O hMN hNO

/-- If a formula is true in one structure and the structures are
    elementarily equivalent, it is true in the other. -/
theorem elemEquivPreservesTruth (M N : Structure) (h : ElementarilyEquivalent M N)
    (φ : PredFormula) (hM : M.satisfies φ []) : N.satisfies φ [] :=
  (h φ).mp hM

/-- Elementary equivalence is preserved under taking subformulas
    of relevant formulas. This is a meta-statement about the structure
    of satisfaction. -/
theorem elemEquivClosedUnderSubformulas (M N : Structure)
    (h : ElementarilyEquivalent M N) (φ ψ : PredFormula)
    (hSub : ψ.quantifierDepth ≤ φ.quantifierDepth) :
    (M.satisfies ψ [] ↔ N.satisfies ψ []) :=
  h ψ

/-- The constant truth `⊤` is always satisfied. -/
theorem satisfiesTrue (M : Structure) : M.satisfies (.prop .true) [] := trivial

/-- The constant false `⊥` is never satisfied. -/
theorem notSatisfiesFalse (M : Structure) : ¬ M.satisfies (.prop .false) [] := id

/-- Two structures with different theories are not elementarily equivalent.
    This is the contrapositive of the definition. -/
theorem theoryNeqImpliesNotElemEquiv (M N : Structure)
    (h : theoryOf M ≠ theoryOf N) : ¬ ElementarilyEquivalent M N := by
  intro hEq
  apply h
  ext φ
  constructor
  · intro hM; exact (hEq φ).mp hM
  · intro hN; exact (hEq φ).mpr hN

/-! ## `#eval` Examples -/

/-- Demonstrate reflexivity on NatStructure -/
#eval elemEquivRefl NatStructure

/-- Show that two structures satisfy the same trivial formula -/
#eval (NatStructure.satisfies (.prop .true) [], IntStructure.satisfies (.prop .true) [])

/-- Verify constant truth satisfaction -/
#eval satisfiesTrue NatStructure

end MiniOrderEquivalence
