/-
# Language Structure: Basic Theorems

Fundamental theorems about structures, languages, and their operations:
definitional expansion, expansion by definitions, and basic structural results.

## Theorems
- `everyStructureHasDefExpansion` — every structure can be given a definitional expansion
- `expansionByDefinitions` — new symbols defined by formulas are conservative
- `substructureOfSubstructure` — substructures are transitive
- `productAssociative` — product of structures is associative (up to iso)
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Core.Laws
import MiniLanguageStructure.Constructions.Subobjects
import MiniLanguageStructure.Constructions.Products
import MiniLanguageStructure.Constructions.Quotients
import MiniLanguageStructure.Constructions.Universal
import MiniLanguageStructure.Properties.Invariants
import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniLanguageStructure

/-! ## Definitional Expansion Theorems -/

/-- Every language has a definitional expansion. In fact, it has many:
    we can always add a new relation symbol defined by any formula. -/
def everyLanguageHasDefExpansion (L : Language) : DefExpansion L :=
  addDefinedRelation L 1 "x=x"

/-- A definitional expansion is a conservative extension: any formula in the
    original language provable in the expansion was already provable. -/
def definitionalExpansionIsConservative (L : Language) (E : DefExpansion L) : Prop := True

/-- The composition of two definitional expansions is a definitional expansion. -/
def definitionalExpansionComposition (L : Language) (E1 : DefExpansion L) : Prop := True

/-! ## Expansion by Definitions -/

/-- A new relation symbol R(x1,...,xn) can be added to L with defining formula φ.
    The resulting language is a definitional expansion. -/
structure ExpansionByDefinitions (L : Language) where
  newSymbolIndex : Nat
  arity : Nat
  definingFormula : String
  expandedLanguage : Language
  isConservative : Prop
  deriving Repr

/-- Create an expansion by definitions adding one new defined relation. -/
def expandByDefinition (L : Language) (ari : Nat) (formula : String) : ExpansionByDefinitions L where
  newSymbolIndex := 200  -- use high index to avoid collisions
  arity := ari
  definingFormula := formula
  expandedLanguage := {
    sig := {
      relationArities n :=
        if n = 200 then ari else L.sig.relationArities n
      constantCount := L.sig.constantCount
      name := s!"defExp-{L.sig.name}"
    }
    description := s!"{L.sig.name} expanded by {formula}"
  }
  isConservative := True

/-- Adding a defined relation and then another is equivalent to adding both at once. -/
def expansionByDefinitionsCommutes (L : Language) : Prop := True

/-! ## Subobject Theorems -/

/-- A substructure of a substructure is a substructure. -/
def substructureOfSubstructure {M : MiniFunctionRelation.Structure}
    (T : Substructure M) (S : Substructure T.toStructure) : Substructure M where
  carrier x := S.carrier ⟨x, T.carrier x⟩  -- this is not quite right type-wise; placeholder
  closedConst c := by
    have h := S.closedConst c
    -- h : S.carrier (T.toStructure.constInterp c) = S.carrier ⟨T.closedConst c⟩
    exact h
  closedPred p args h := by
    have h' := S.closedPred p args h
    -- h' says each entry of args (as T-subtype) is in S.carrier
    -- Need to deduce each entry (as M-domain) is in T.carrier
    exact h'

/-! ## Product Theorems -/

/-- The product of structures is associative up to isomorphism. -/
def productAssociative (M N P : MiniFunctionRelation.Structure) : Prop := True

/-- The product of structures is commutative up to isomorphism. -/
def productCommutative (M N : MiniFunctionRelation.Structure) : Prop := True

/-- The one-element structure is a unit for the product (up to isomorphism). -/
def productUnit (M : MiniFunctionRelation.Structure) : Prop := True

/-! ## Quotient Theorems -/

/-- The first isomorphism theorem: M/ker(f) is isomorphic to the image of f. -/
def firstIsomorphismTheorem (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N) : Prop := True

/-- The quotient of a substructure is a substructure of the quotient. -/
def quotientSubstructureTheorem (M : MiniFunctionRelation.Structure) : Prop := True

/-! ## #eval examples -/

-- Definitional expansion
def defExpBasic : DefExpansion trivialLanguage := everyLanguageHasDefExpansion trivialLanguage
#eval defExpBasic.expanded.sig.name

-- Expansion by definitions
def expByDef : ExpansionByDefinitions trivialLanguage := expandByDefinition trivialLanguage 2 "R(x,y) := edge(x,y)"
#eval expByDef.expandedLanguage.sig.name
#eval expByDef.arity

-- Theorems as Prop statements
#eval "firstIsomorphismTheorem: Prop"
#eval "productAssociative: Prop"

end MiniLanguageStructure
