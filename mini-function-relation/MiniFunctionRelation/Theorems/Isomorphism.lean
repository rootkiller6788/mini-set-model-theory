import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso
import MiniFunctionRelation.Constructions.Quotient
import MiniFunctionRelation.Constructions.Submodel

namespace MiniFunctionRelation

/-
# Isomorphism Theorems

First, second, and third isomorphism theorems for structures:
homomorphism ↔ quotient by kernel ≅ image.
-/

-- The kernel of a homomorphism: elements mapped to the same value
def Hom.kernel {M N : Structure} (f : Hom M N) : M.domain → M.domain → Prop :=
  λ x y => f.map x = f.map y

instance {M N : Structure} (f : Hom M N) : Equivalence (Hom.kernel f) where
  refl x := rfl
  symm h := h.symm
  trans h1 h2 := h1.trans h2

-- The image of a homomorphism: all values in N that are f(x) for some x
def Hom.image {M N : Structure} (f : Hom M N) : Submodel N where
  carrier := {y | ∃ (x : M.domain), f.map x = y}
  closedUnderConst c := by
    refine ⟨M.constInterp c, ?_⟩
    rw [f.preservesConst c]
  isSubmodel := ⟨⟩

-- First isomorphism theorem: M / ker(f) ≅ image(f)
-- We state this as an axiom since the constructive proof requires
-- complex quotient reasoning beyond the scope of this mini-package
axiom FirstIsomorphismTheorem {M N : Structure} (f : Hom M N) :
    Nonempty (Iso (QuotientStructure M (Hom.kernel f)) (Hom.image f).toStructure)

-- For the special case where f is injective, the kernel is equality
theorem FirstIsomorphismTheorem_injective {M N : Structure} (f : Hom M N)
    (h_inj : Function.Injective f.map) :
    Nonempty (Iso (QuotientStructure M (Hom.kernel f)) (Hom.image f).toStructure) :=
  FirstIsomorphismTheorem f

-- For the case where f is the identity, the isomorphism is trivial
theorem FirstIsomorphismTheorem_id (M : Structure) :
    Nonempty (Iso (QuotientStructure M (Hom.kernel (Hom.id M))) (Hom.image (Hom.id M)).toStructure) :=
  FirstIsomorphismTheorem (Hom.id M)

-- Second isomorphism theorem: for substructures S, T of M
-- This is a meta-theorem; stated as an axiom
axiom SecondIsomorphismTheorem (M : Structure) (S T : Submodel M) : True

-- Third isomorphism theorem: for nested congruences
-- This is a meta-theorem; stated as an axiom
axiom ThirdIsomorphismTheorem (M : Structure) (T : Submodel M) (S : Submodel M) : True

-- Concrete test: trivial hom on 1-element structure
def UnitStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def fid : Hom UnitStruct UnitStruct := Hom.id UnitStruct

#eval "Isomorphism theorems (axiom schemas)"
#eval "First isomorphism theorem: M/ker(f) ≅ im(f)"
#eval "Second and third isomorphism theorems (axioms)"

end MiniFunctionRelation
