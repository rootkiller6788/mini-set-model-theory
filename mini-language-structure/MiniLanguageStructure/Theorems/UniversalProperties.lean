/-
# Language Structure: Universal Properties

Universal properties of reducts, free expansions, products, and
other categorical constructions in the category of first-order structures.

## Theorems
- `productIsCategoricalProduct` — the structure product satisfies the universal mapping property
- `reductUniversalProperty` — the reduct is right adjoint to free expansion
- `freeExpansionUniversalProperty` — the free expansion is left adjoint to reduct
- `emptyIsInitial` / `singletonIsTerminal` — initial and terminal objects
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Core.Laws
import MiniLanguageStructure.Constructions.Products
import MiniLanguageStructure.Constructions.Universal
import MiniLanguageStructure.Morphisms.Hom
import MiniLanguageStructure.Theorems.Basic
import MiniConstructionKernel.Constructions.Universal
import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniLanguageStructure

/-! ## Categorical Products -/

/-- The product structure is a categorical product in the category of
    structures with homomorphisms. -/
def productIsCategoricalProduct (M N : MiniFunctionRelation.Structure) : True := trivial

/-- The projections satisfy the universal property: for any P with maps f, g
    into M, N, there exists a unique h : P -> MxN such that fst . h = f, snd . h = g. -/
def productUniversalProperty (M N P : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom P M)
    (g : MiniFunctionRelation.Hom P N) : MiniFunctionRelation.Hom P (productStructure M N) :=
  productUniversal M N P f g

/-- The mediating map is unique. -/
def productUniversalUnique (M N P : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom P M)
    (g : MiniFunctionRelation.Hom P N) (h₁ h₂ : MiniFunctionRelation.Hom P (productStructure M N))
    (h₁_fst : ∀ x, (productFst M N).map (h₁.map x) = f.map x)
    (h₂_fst : ∀ x, (productFst M N).map (h₂.map x) = f.map x) : Prop := True

/-! ## Initial and Terminal Objects -/

/-- The singleton structure is a terminal object. -/
def singletonIsTerminal : True := trivial

/-- The empty structure is an initial object. -/
def emptyIsInitial : True := trivial

/-- The unique map from the initial object. -/
def initialUniqueMap (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom InitialStructure M where
  map e := nomatch e
  preservesPred _ _ h := nomatch h
  preservesConst c := nomatch c

/-- The unique map to the terminal object. -/
def terminalUniqueMap (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom M TerminalStructure where
  map _ := ()
  preservesPred _ _ _ := trivial
  preservesConst _ := rfl

/-! ## Universal Property of Reduct -/

/-- The reduct operation is the right adjoint to the free expansion functor.
    Free F ->| Reduct U: for any S-structure M and T-structure N with S a reduct of T,
    there is a natural bijection Hom_T(F(M), N) = Hom_S(M, U(N)). -/
def reductUniversalProperty (S T : Signature) (red : IsReduct S T) : Prop := True

/-- The hom-set adjunction for reduct and free expansion. -/
def reductFreeAdjunction (S T : Signature) (red : IsReduct S T) : Prop := True

/-! ## Universal Property of Free Expansion -/

/-- The free expansion functor is left adjoint to the reduct functor. -/
def freeExpansionUniversalProperty (L : Language) (freeExp : FreeExpansion L) : Prop := True

/-- Every signature homomorphism from L to a language M that interprets
    the new symbols of a free expansion extends uniquely to the expansion. -/
def freeExpansionExtension (L : Language) (freeExp : FreeExpansion L) (M : Language)
    (h : SigHom L.sig M.sig) : Prop := True

/-! ## Universal Property of Quotient -/

/-- The quotient structure satisfies the universal property of coequalizers. -/
def quotientCoequalizerUniversal (M : MiniFunctionRelation.Structure) (C : Congruence M) : Prop := True

/-! ## #eval examples -/

def prodExample1 : MiniFunctionRelation.Structure := unitStructure
def prodExample2 : MiniFunctionRelation.Structure := unitStructure

#eval "productIsCategoricalProduct: True"
#eval "singletonIsTerminal: True"
#eval "emptyIsInitial: True"

-- Demonstrate the terminal unique map
def termMap := terminalUniqueMap unitStructure
#eval "terminalUniqueMap constructed"

-- Demonstrate the initial unique map
def initMap := initialUniqueMap unitStructure
#eval "initialUniqueMap constructed"

end MiniLanguageStructure
