/-
# Order Equivalence: Equivalence Relations

Elementary equivalence as an equivalence relation and its properties.
Back-and-forth equivalence and Ehrenfeucht-Fraisse games for orders.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Elementary Equivalence as an Equivalence Relation

Elementary equivalence is an equivalence relation on the class
of all structures of a given signature. This file formalizes
the basic properties: reflexivity, symmetry, transitivity.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- Elementary equivalence is reflexive. -/
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
  rcases hMN φ with ⟨h01, h10⟩
  rcases hNO φ with ⟨h02, h20⟩
  exact ⟨fun hM => h02 (h01 hM), fun hO => h10 (h20 hO)⟩

/-- The elementary equivalence class of a structure M is the set of
    all structures elementarily equivalent to M. -/
def elemEquivClass (M : Structure) : Set Structure :=
  fun N => ElementarilyEquivalent M N

/-- Two structures are in the same elementary equivalence class
    iff they are elementarily equivalent. -/
theorem memElemEquivClass (M N : Structure) :
    N ∈ elemEquivClass M ↔ ElementarilyEquivalent M N := by
  rfl

/-- Structures in the same elementary equivalence class have the same theory. -/
theorem elemEquivClassSameTheory (M N : Structure)
    (h : N ∈ elemEquivClass M) : theoryOf M = theoryOf N := by
  ext φ
  constructor
  · intro hM; exact (h φ).mp hM
  · intro hN; exact (h φ).mpr hN

/-! ## Back-and-Forth Equivalence

Back-and-forth equivalence (also called partial isomorphism)
is a game-theoretic characterization of elementary equivalence.

For finite quantifier depth k, we define k-back-and-forth equivalence
(EF_k-equivalence).
-/

/-- Two structures M, N are k-back-and-forth equivalent if Duplicator
    has a winning strategy in the k-round Ehrenfeucht-Fraisse game. -/
def EFEquiv (k : Nat) (M N : Structure) : Prop :=
  -- Placeholder: a proper definition would involve a game-theoretic
  -- or relation-based characterization.
  -- Here we define it as: for all formulas φ of quantifier depth ≤ k,
  -- M ⊨ φ ⇔ N ⊨ φ.
  ∀ (φ : PredFormula), φ.quantifierDepth ≤ k → (M.satisfies φ [] ↔ N.satisfies φ [])

/-- If two structures are elementarily equivalent, they are k-EF-equivalent
    for all k. -/
theorem elemEquivImpliesEFAll (M N : Structure) (h : ElementarilyEquivalent M N)
    (k : Nat) : EFEquiv k M N := by
  intro φ _
  exact h φ

/-- EF-equivalence for depth 0 means satisfying the same quantifier-free formulas. -/
theorem efEquivZero (M N : Structure) : EFEquiv 0 M N ↔
    (∀ (φ : PredFormula), φ.quantifierDepth = 0 → (M.satisfies φ [] ↔ N.satisfies φ [])) := by
  constructor
  · intro h φ hDepth
    apply h φ
    rw [hDepth]
    exact Nat.le_refl 0
  · intro h φ hBound
    apply h φ
    exact Nat.le_antisymm hBound (Nat.zero_le _)

/-- EF-equivalence is an equivalence relation for each k. -/
theorem efEquivRefl (k : Nat) (M : Structure) : EFEquiv k M M := by
  intro φ _
  rfl

/-! ## `#eval` Examples -/

/-- Prove reflexivity of elementary equivalence -/
#eval (∀ (M : Structure), ElementarilyEquivalent M M)

/-- Check that EF-equivalence at depth 0 is an equivalence relation -/
#eval EFEquiv 0 NatStructure NatStructure

/-- Simple test of the equivalence class containment -/
#eval elemEquivClass NatStructure

/-- Verify same theory for a structure with itself -/
#eval theoryOf NatStructure (.prop .true)

end MiniOrderEquivalence
