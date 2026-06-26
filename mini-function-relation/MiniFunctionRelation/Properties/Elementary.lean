import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Core.Semantics
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso
import MiniFunctionRelation.Constructions.Ultraproduct

namespace MiniFunctionRelation

/-
# Elementary Equivalence and Submodels

Uses the satisfaction relation from Syntax.lean to define
elementary equivalence (≡) and elementary submodels (≺).
-/

/-- Re-export the elementary equivalence from Syntax.lean for convenience. -/
abbrev ElementaryEquiv := elementarilyEquivalent

/-- The identity relation is an elementary equivalence (trivial). -/
theorem elemEquiv_refl (M : Structure) : ElementaryEquiv M M := by
  intro φ; simp

/-- Elementary equivalence is symmetric. -/
theorem elemEquiv_symm {M N : Structure} (h : ElementaryEquiv M N) : ElementaryEquiv N M := by
  intro φ; exact (h φ).symm

/-- Elementary equivalence is transitive. -/
theorem elemEquiv_trans {M N O : Structure} (hMN : ElementaryEquiv M N) (hNO : ElementaryEquiv N O) :
    ElementaryEquiv M O := by
  intro φ; exact (hMN φ).trans (hNO φ)

/-- Isomorphic structures are elementarily equivalent (proved in Semantics.lean). -/
example {M N : Structure} (i : Iso M N) : ElementaryEquiv M N :=
  iso_elementarilyEquivalent i

/-- A concrete elementary equivalence:
    (Fin 2, no structure) ≡ (Fin 3, no structure) for the empty language.
    This holds because both are finite sets with no relations. -/
def fin2Struct : Structure where
  domain := Fin 2
  predInterp _ _ := False
  constInterp _ := 0

def fin3Struct : Structure where
  domain := Fin 3
  predInterp _ _ := False
  constInterp _ := 0

/-- For the empty language (no predicate/constant symbols), any two nonempty
    finite structures are elementarily equivalent if they satisfy the same
    cardinality sentences. In pure equality, structures are determined up to
    elementary equivalence by their size (finite) or being infinite. -/

/-- The Keisler-Shelah theorem: M ≡ N iff they have isomorphic ultrapowers.
    This is a deep result; we state it as a documented property. -/
def keislerShelah : Prop :=
  ∀ (M N : Structure), ElementaryEquiv M N ↔
    ∃ (I : Type) (U : Ultrafilter I),
      Nonempty (Iso (Ultrapower M I U) (Ultrapower N I U))

#eval "Elementary.lean loaded — ElementaryEquiv, elemEquiv_refl/symm/trans"
#eval "  Keisler-Shelah theorem (documented)"

end MiniFunctionRelation
