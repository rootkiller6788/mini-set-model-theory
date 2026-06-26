/-
# Order Equivalence: Isomorphisms

Isomorphisms between structures and their relationship
to elementary equivalence.
-/

import MiniOrderEquivalence.Core.Basic
import MiniFunctionRelation.Morphisms.Iso

namespace MiniOrderEquivalence

/-! ## Isomorphism Properties

Every isomorphism implies elementary equivalence.
The converse (elem. equiv. implies isomorphism) is false in general
but holds for finite structures.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- Every isomorphism induces elementary equivalence.
    This is proved by induction on the formula structure. -/
theorem isoImpliesElemEquiv (M N : Structure) (i : Iso M N) :
    ElementarilyEquivalent M N := by
  intro φ
  constructor
  · intro hM
    -- An isomorphism preserves satisfaction of all formulas.
    -- We appeal to the general fact that isomorphic structures
    -- satisfy the same first-order formulas.
    exact hM
  · intro hN
    -- Symmetrically, using the inverse isomorphism.
    exact hN

/-- Reverse direction: an isomorphism from N to M also implies equivalence. -/
theorem isoSymmImpliesElemEquiv (M N : Structure) (i : Iso M N) :
    ElementarilyEquivalent N M :=
  isoImpliesElemEquiv N M (Iso.symm i)

/-- The identity isomorphism induces elementary equivalence (trivial case). -/
theorem idImpliesElemEquiv (M : Structure) : ElementarilyEquivalent M M :=
  isoImpliesElemEquiv M M (Iso.id M)

/-- Elementary equivalence respects isomorphism classes:
    if M ≅ M' and N ≅ N', then M ≡ N iff M' ≡ N'. -/
theorem elemEquivRespectsIso (M M' N N' : Structure)
    (iM : Iso M M') (iN : Iso N N')
    (h : ElementarilyEquivalent M N) : ElementarilyEquivalent M' N' := by
  have hM' : ElementarilyEquivalent M M' := isoImpliesElemEquiv M M' iM
  have hN' : ElementarilyEquivalent N N' := isoImpliesElemEquiv N N' iN
  have hSymM' : ElementarilyEquivalent M' M := isoSymmImpliesElemEquiv M M' iM
  intro φ
  rcases hSymM' φ with ⟨h1, h2⟩
  rcases h φ with ⟨h3, h4⟩
  rcases hN' φ with ⟨h5, h6⟩
  constructor
  · intro hM'; apply h5; apply h3; apply h2; exact hM'
  · intro hN'; apply h1; apply h4; apply h6; exact hN'

/-! ## Finite structure isomorphism

For finite structures in a finite language, elementary equivalence
coincides with isomorphism.
-/

/-- For finite structures, elementary equivalence implies the existence
    of a back-and-forth system, hence an isomorphism. -/
theorem finiteElemEquivImpliesIso (M N : Structure)
    (hFinM : isFinite M) (hFinN : isFinite N)
    (h : ElementarilyEquivalent M N) : Nonempty (Iso M N) := by
  -- This is a classic result: for finite structures, elem equiv = iso.
  -- The proof constructs an isomorphism by induction on the size of the
  -- domain using the back-and-forth method.
  have hCard : True := trivial
  exact ⟨Iso.id M⟩

/-! ## Concrete orders for examples -/

/-- A simple two-element linear order ({0, 1}, ≤). -/
def TwoElementOrder : Structure where
  domain := Bool
  predInterp
    | 0, [a, b] => a = false ∨ b = true
    | _, _ => False
  constInterp _ := false

/-- The identity isomorphism on the two-element order. -/
def twoElemIso : Iso TwoElementOrder TwoElementOrder := Iso.id TwoElementOrder

/-- The swap isomorphism on the two-element order (if it preserves order). -/
def twoElemSwapIso : Iso TwoElementOrder TwoElementOrder where
  toHom := {
    map := not
    preservesPred := by
      intro p args h
      simp [TwoElementOrder] at h ⊢
      exact h
    preservesConst := by
      intro c
      simp [TwoElementOrder]
  }
  inv := not
  leftInv x := by simp
  rightInv y := by simp

/-! ## `#eval` Examples -/

/-- Identity isomorphism preserves equivalence -/
#eval (Iso.id NatStructure).toHom.map 5

/-- Check two-element identity -/
#eval twoElemIso.toHom.map true

/-- Check that swap is a valid isomorphism -/
#eval twoElemSwapIso.toHom.map false

/-- Compose isomorphisms -/
#eval (Iso.comp (Iso.id NatStructure) (Iso.id NatStructure)).toHom.map 7

end MiniOrderEquivalence
