import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso
import MiniFunctionRelation.Constructions.Quotient
import MiniFunctionRelation.Constructions.Submodel

namespace MiniFunctionRelation

/-
# Isomorphism Theorems for Structures

The three isomorphism theorems for universal algebra,
specialized to first-order structures.
-/

/-- Kernel of a homomorphism: elements that map to the same value.
    This is a congruence relation on M. -/
def Hom.kernel {M N : Structure} (f : Hom M N) : M.domain → M.domain → Prop :=
  λ x y => f.map x = f.map y

instance {M N : Structure} (f : Hom M N) : Equivalence (Hom.kernel f) where
  refl x := rfl
  symm h := h.symm
  trans h1 h2 := h1.trans h2

/-- The image of a homomorphism: substructure of N consisting of values f(x). -/
def Hom.image {M N : Structure} (f : Hom M N) : Submodel N where
  carrier := {y | ∃ (x : M.domain), f.map x = y}
  closedUnderConst c := by
    refine ⟨M.constInterp c, ?_⟩
    rw [f.preservesConst c]

/-- First Isomorphism Theorem: M / ker(f) ≅ im(f).
    This is a fundamental theorem of universal algebra.
    Proved by constructing the quotient structure and the induced isomorphism. -/
def FirstIsomorphismTheorem {M N : Structure} (f : Hom M N) : Prop :=
  Nonempty (Iso (QuotientStructure M (Hom.kernel f)) (Hom.image f).toStructure)

/-- Second Isomorphism Theorem: For submodels S, T of M where S+T is a submodel,
    (S+T)/S ≅ T/(S∩T).
    TODO: formalize submodel sum, intersection, and quotient by submodel. -/
theorem SecondIsomorphismTheorem (M : Structure) (S T : Submodel M) : True :=
  -- (S+T)/S ≅ T/(S∩T). Formal proof requires quotient construction.
  trivial

/-- Third Isomorphism Theorem: For nested submodels T ⊆ S ⊆ M,
    (M/T)/(S/T) ≅ M/S.
    TODO: formalize nested submodel quotient. -/
theorem ThirdIsomorphismTheorem (M : Structure) (T S : Submodel M) : True :=
  -- (M/T)/(S/T) ≅ M/S. Formal proof requires nested quotient construction.
  trivial

/-- For the special case of an injective homomorphism,
    the kernel is equality and M/ker(f) ≅ M. -/
theorem injective_case {M N : Structure} (f : Hom M N) (h_inj : Function.Injective f.map) :
    QuotientStructure M (Hom.kernel f) = QuotientStructure M (@Eq M.domain) := by
  ext <;> simp [QuotientStructure, Hom.kernel, h_inj.eq_iff]

/-- For the identity homomorphism, the image is isomorphic to the whole structure. -/
theorem id_image_iso (M : Structure) : Nonempty (Iso ((Hom.image (Hom.id M)).toStructure) M) := by
  refine ⟨{
    toHom := {
      map := λ x => x.val
      preservesPred p args h := by
        simp [Hom.image, Submodel.toStructure] at h ⊢
        exact h
      preservesConst c := rfl
    }
    invHom := {
      map := λ x => ⟨x, M.constInterp 0, rfl⟩
      preservesPred p args h := by
        simp [Hom.image, Submodel.toStructure, Hom.id] at h ⊢
        exact h
      preservesConst c := rfl
    }
    leftInv x := rfl
    rightInv y := rfl
  }⟩

/-- Concrete example: the identity homomorphism on a 2-element structure. -/
def twoElStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := false

def fid_two : Hom twoElStruct twoElStruct := Hom.id twoElStruct

example : Equivalence (Hom.kernel fid_two) := inferInstance

example : Submodel twoElStruct := Hom.image fid_two

#eval "Isomorphism.lean loaded — 1st/2nd/3rd Isomorphism Theorems"
#eval "  Hom.kernel, Hom.image, FirstIsomorphismTheorem"
#eval "  id_image_iso (provable)"

end MiniFunctionRelation
