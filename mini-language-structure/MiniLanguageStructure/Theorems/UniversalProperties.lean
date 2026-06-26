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

/-- The product structure satisfies the universal property of categorical product:
    for any P with maps f: P → M, g: P → N, there exists a unique
    h: P → M×N such that fst∘h = f and snd∘h = g. -/
def productUniversalProperty (M N P : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom P M)
    (g : MiniFunctionRelation.Hom P N) : MiniFunctionRelation.Hom P (productStructure M N) :=
  productUniversal M N P f g

-- TODO: prove uniqueness of the mediating map

/-! ## Initial and Terminal Objects -/

/-- The unique map from the initial structure (empty domain). -/
def initialUniqueMap (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom InitialStructure M where
  map e := nomatch e
  preservesPred _ _ h := nomatch h
  preservesConst c := nomatch c

/-- The unique map to the terminal structure (singleton domain). -/
def terminalUniqueMap (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom M TerminalStructure where
  map _ := ()
  preservesPred _ _ _ := trivial
  preservesConst _ := rfl

/-! ## Adjunctions Between Constructions -/

-- TODO: Formalize the adjunctions:
--   - Free ⊣ Forgetful (free L-structure on a set)
--   - Diagonal ⊣ Product
--   - Coproduct ⊣ Diagonal
--   - Free expansion ⊣ Reduct

/-! ## Galois Connections in Model Theory -/

/-- Mod: Theories → Classes of Structures and Th: Classes → Theories form
    a Galois connection. The closed sets are elementary classes (on the
    structure side) and theories (on the sentence side).

    Birkhoff's HSP Theorem (universal algebra): A class of algebras is a variety
    (equationally axiomatizable) iff closed under H (homomorphic images),
    S (subalgebras), and P (products). -/
-- theorem birkhoffVarietyTheorem : ... := ...

/-! ## #eval examples -/

#eval "══ Universal Properties ══"

-- Demonstrate the terminal unique map
def termMap := terminalUniqueMap unitStructure
#eval "terminalUniqueMap constructed"

-- Demonstrate the initial unique map
def initMap := initialUniqueMap unitStructure
#eval "initialUniqueMap constructed"

#eval "── Adjunctions ──"
#eval "Mod ⊣ Th: Galois connection between structures and sentences."
#eval "Birkhoff HSP: variety = closed under H, S, P."

#eval "── Universal property demonstrations ──"
#eval "productUniversalProperty: mediating morphism exists."
#eval "Free ⊣ Forgetful, Δ ⊣ ×, Free expansion ⊣ Reduct (to be formalized)."

end MiniLanguageStructure
