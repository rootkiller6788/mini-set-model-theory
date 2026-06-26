import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Core.Semantics

namespace MiniFunctionRelation

/-
# Equivalence Relations on Structures

Isomorphism equivalence, elementary equivalence (via Syntax.lean),
and other equivalence notions on the class of structures.
-/

/-- Isomorphism equivalence: M ≅ N.
    Reuses the Iso type from Morphisms/Iso.lean. -/
def IsoEquiv (M N : Structure) : Prop := Nonempty (Iso M N)

theorem IsoEquiv.refl (M : Structure) : IsoEquiv M M :=
  ⟨Iso.id M⟩

theorem IsoEquiv.symm {M N : Structure} (h : IsoEquiv M N) : IsoEquiv N M := by
  rcases h with ⟨i⟩; exact ⟨Iso.symm i⟩

theorem IsoEquiv.trans {M N O : Structure} (hMN : IsoEquiv M N) (hNO : IsoEquiv N O) :
    IsoEquiv M O := by
  rcases hMN with ⟨i⟩; rcases hNO with ⟨j⟩; exact ⟨Iso.comp j i⟩

/-- Elementary equivalence: M ≡ N.
    Defined in Syntax.lean as `elementarilyEquivalent`. -/

/-- Isomorphism implies elementary equivalence (proved in Semantics.lean). -/
theorem iso_implies_elemEquiv {M N : Structure} (i : Iso M N) : elementarilyEquivalent M N :=
  iso_elementarilyEquivalent i

/-- The converse is false in general: e.g., (ℚ, <) ≡ (ℝ, <) but ℚ ≇ ℝ as orders
    (one is countable, the other uncountable). -/
def nonIsomorphicButElemEquiv : Prop :=
  ∃ (M N : Structure), elementarilyEquivalent M N ∧ ¬ IsoEquiv M N

/-- Homotopy equivalence of structures (a notion from categorical logic).
    Two structures are homotopy equivalent if there exist homomorphisms
    f: M→N and g: N→M such that g∘f and f∘g are homotopic to identity.
    (Simplified: we use the existence of a retraction/section.) -/
def HomotopyEquiv (M N : Structure) : Prop :=
  ∃ (f : Hom M N) (g : Hom N M),
    (∀ (x : M.domain), g.map (f.map x) = x) ∧
    (∀ (y : N.domain), f.map (g.map y) = y)

/-- Homotopy equivalence implies isomorphism in the category of structures
    (since we don't have a notion of homotopy between homs).
    With our definition, HomotopyEquiv = Iso. -/
theorem homotopyEquiv_iff_iso (M N : Structure) : HomotopyEquiv M N ↔ IsoEquiv M N := by
  constructor
  · rintro ⟨f, g, h_left, h_right⟩
    refine ⟨{
      toHom := f
      invHom := g
      leftInv := h_left
      rightInv := h_right
    }⟩
  · rintro ⟨i⟩
    refine ⟨i.toHom, i.invHom, i.leftInv, i.rightInv⟩

/-- The category of structures with homs forms a concrete category.
    The equivalence relations defined here correspond to:
    - IsoEquiv = isomorphism in the categorical sense
    - ElementaryEquiv = equivalence in the logic sense
    - HomotopyEquiv = categorical equivalence -/

/-- Concrete examples of isomorphic structures. -/
def UnitStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def AnotherUnit : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-- Two 1-element structures with different predicates are NOT isomorphic. -/
theorem diff_pred_not_iso : ¬ IsoEquiv UnitStruct AnotherUnit := by
  intro h
  rcases h with ⟨i⟩
  have h_true : AnotherUnit.predInterp 0 [] := by simp [AnotherUnit]
  have h_contra : UnitStruct.predInterp 0 [] := i.invHom.preservesPred 0 [] h_true
  simp [UnitStruct] at h_contra

/-- Evaluation examples. -/
#eval "Equivalence.lean loaded"
#eval "  IsoEquiv (refl, symm, trans)"
#eval "  elementarilyEquivalent (via Syntax.lean)"
#eval "  HomotopyEquiv ↔ Iso"

end MiniFunctionRelation
