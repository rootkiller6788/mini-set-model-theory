/-
# Language Structure: Products

Product structures, disjoint union of languages, product signatures,
and many-sorted languages.

## Definitions
- `productStructure` — product of two structures
- `productFst` / `productSnd` — projection homomorphisms
- `productUniversal` — universal property of the product
- `DisjointUnion` — disjoint union of two languages
- `ProductSignature` — product of two signatures
- `ManySortedLanguage` — language with multiple sorts
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Core.Laws
import MiniLanguageStructure.Morphisms.Hom
import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniLanguageStructure

/-! ## Product of Structures -/

/-- The product of two structures: domain is the Cartesian product,
    relations hold if they hold in both components. -/
def productStructure (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain × N.domain
  predInterp p args := M.predInterp p (args.map Prod.fst) ∧ N.predInterp p (args.map Prod.snd)
  constInterp c := (M.constInterp c, N.constInterp c)

/-- First projection from product. -/
def productFst (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom (productStructure M N) M where
  map := Prod.fst
  preservesPred _ _ h := h.1
  preservesConst _ := rfl

/-- Second projection from product. -/
def productSnd (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom (productStructure M N) N where
  map := Prod.snd
  preservesPred _ _ h := h.2
  preservesConst _ := rfl

/-- Universal property of the product. -/
def productUniversal (M N P : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom P M)
    (g : MiniFunctionRelation.Hom P N) : MiniFunctionRelation.Hom P (productStructure M N) where
  map x := (f.map x, g.map x)
  preservesPred p args h := ⟨f.preservesPred p args h, g.preservesPred p args h⟩
  preservesConst c := by simp [f.preservesConst, g.preservesConst]

/-! ## Disjoint Union of Languages -/

/-- The disjoint union of two languages places their symbols side-by-side.
    Relation symbols and constants are interleaved: even indices for L,
    odd indices for M. -/
structure DisjointUnion (L M : Language) where
  combined : Language
  leftInj : SigHom L.sig combined.sig
  rightInj : SigHom M.sig combined.sig
  deriving Repr

/-- Construct the disjoint union of two languages. -/
def disjointUnion (L M : Language) : DisjointUnion L M where
  combined := {
    sig := {
      relationArities n :=
        if n % 2 = 0 then L.sig.relationArities (n / 2)
        else M.sig.relationArities (n / 2)
      constantCount := L.sig.constantCount + M.sig.constantCount
      name := s!"{L.sig.name}⊔{M.sig.name}"
    }
    description := s!"disjoint union of {L.sig.name} and {M.sig.name}"
  }
  leftInj := {
    relMap n := 2 * n
    constMap c := c
  }
  rightInj := {
    relMap n := 2 * n + 1
    constMap c := L.sig.constantCount + c
  }

/-! ## Product Signatures -/

/-- The product signature of two signatures has a relation for each pair
    of relations (one from each signature) of the same arity. -/
structure ProductSignature (S T : Signature) where
  productSig : Signature
  projL : SigHom productSig S
  projR : SigHom productSig T
  deriving Repr

/-- Construct the product of two signatures.
    The product has max arity for each pair and the max of constants. -/
def productSignature (S T : Signature) : ProductSignature S T where
  productSig := {
    relationArities n := max (S.relationArities n) (T.relationArities n)
    constantCount := max S.constantCount T.constantCount
    name := s!"{S.name}×{T.name}"
  }
  projL := { relMap := id, constMap := id }
  projR := { relMap := id, constMap := id }

/-- The product of two languages (via their signatures). -/
def productLanguage (L M : Language) : Language :=
  let ps := productSignature L.sig M.sig
  { sig := ps.productSig, description := s!"product of {L.sig.name} and {M.sig.name}" }

/-! ## Many-Sorted Languages -/

/-- A many-sorted language has multiple sorts (domains), each with its own
    relation and constant symbols typed by sort. -/
structure ManySortedLanguage where
  sorts : List String
  relations : List (List Nat × Nat)  -- (sort indices, arity) for each relation
  constants : List (Nat × Nat)       -- (sort index, constant index)
  name : String
  deriving Repr

/-- Create a single-sorted language from a standard language. -/
def singleSorted (L : Language) : ManySortedLanguage where
  sorts := [L.sig.name]
  relations := (List.range 100).filterMap fun n =>
    let a := L.sig.relationArities n
    if a > 0 then some ([0], a) else none
  constants :=
    (List.range L.sig.constantCount).map fun c => (0, c)
  name := s!"1-sorted-{L.sig.name}"

/-- Extend a many-sorted language with an additional sort. -/
def addSort (M : ManySortedLanguage) (sortName : String) : ManySortedLanguage where
  sorts := M.sorts ++ [sortName]
  relations := M.relations
  constants := M.constants
  name := s!"{M.name}+{sortName}"

/-! ## #eval examples -/

-- Product of two unit structures
def prodUnits := productStructure unitStructure unitStructure
#eval "Product structure defined: domain = Unit × Unit"

def fstHom := productFst unitStructure unitStructure
#eval "First projection defined"

def sndHom := productSnd unitStructure unitStructure
#eval "Second projection defined"

-- Disjoint union of languages
def duExample := disjointUnion trivialLanguage emptyLanguage
#eval duExample.combined.sig.name

-- Product signature
def psExample := productSignature trivialSignature emptySignature
#eval psExample.productSig.name

-- Many-sorted language
def msLang := singleSorted trivialLanguage
#eval msLang.name
#eval msLang.sorts.length

-- Add a sort
def msLang2 := addSort msLang "aux"
#eval msLang2.sorts.length

end MiniLanguageStructure
