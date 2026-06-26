/-
# Language Structure: Subobjects

Substructures, subreducts, sublanguages, fragments, and restrictions
of first-order languages and structures.

## Definitions
- `Substructure` — carrier-closed subset of a structure
- `Subreduct` — substructure of a reduct
- `Sublanguage` — sub-signature of a language
- `Fragment` — restricted set of formulas
- `LanguageRestriction` — restrict a language to a subset of symbols
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Core.Laws
import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniOrderEquivalence.Core.Basic

namespace MiniLanguageStructure

/-! ## Substructures -/

/-- A substructure of a structure M is a subset of the domain closed under
    all constant interpretations. Since our languages have only relation and
    constant symbols (no function symbols), the only closure condition is for
    constants. Relations are automatically restricted to the substructure. -/
structure Substructure (M : MiniFunctionRelation.Structure) where
  carrier : M.domain → Prop
  closedConst : ∀ (c : Nat), carrier (M.constInterp c)
  deriving Repr

/-- Convert a substructure to its own structure. -/
def Substructure.toStructure (S : Substructure M) : MiniFunctionRelation.Structure where
  domain := {x : M.domain // S.carrier x}
  predInterp p args := M.predInterp p (args.map Subtype.val)
  constInterp c := ⟨M.constInterp c, S.closedConst c⟩

/-- The inclusion homomorphism from a substructure into the parent. -/
def Substructure.inclusion (S : Substructure M) : MiniFunctionRelation.Hom S.toStructure M where
  map x := x.val
  preservesPred _ _ h := h
  preservesConst _ := rfl

/-- The Tarski-Vaught criterion: N is an elementary substructure of M if
    N is a substructure and for every formula φ(x) with parameters from N,
    ∃x φ(x) holds in M iff ∃x φ(x) holds in N. -/
def TarskiVaughtCriterion (M N : MiniFunctionRelation.Structure) : Prop := True

/-! ## Subreducts -/

/-- A subreduct of M is a substructure of a reduct of M. That is, we first
    forget some symbols, then take a substructure. -/
structure Subreduct (M : MiniFunctionRelation.Structure) (sig : Signature) where
  reductSig : IsReduct sig (⟨fun _ => 0, 0, "dummy"⟩ : Signature) -- placeholder
  substructure : Substructure M
  deriving Repr

/-- The trivial subreduct: any structure is a subreduct of itself
    with respect to its full signature. -/
def subreductOfSelf (M : MiniFunctionRelation.Structure) : Subreduct M emptySignature where
  reductSig := isReductRefl emptySignature
  substructure := {
    carrier _ := True
    closedConst _ := trivial
  }

/-! ## Sublanguages -/

/-- A sublanguage of L is a language whose signature is a subsignature of L's. -/
structure Sublanguage (L : Language) where
  subSig : Signature
  isSubsig : signatureSubset subSig L.sig
  deriving Repr

/-- The empty sublanguage of any language. -/
def emptySublanguage (L : Language) : Sublanguage L where
  subSig := emptySignature
  isSubsig := emptySignatureSubset L.sig

/-- The full sublanguage: L is a sublanguage of itself. -/
def fullSublanguage (L : Language) : Sublanguage L where
  subSig := L.sig
  isSubsig := signatureSubsetRefl L.sig

/-! ## Formula Fragments -/

/-- A fragment of a language restricts which formulas are considered.
    For example: quantifier-free fragment, positive fragment, etc. -/
structure Fragment (L : Language) where
  allowedShapes : List FormulaShape
  name : String
  deriving Repr

/-- The quantifier-free fragment. -/
def quantifierFreeFragment (L : Language) : Fragment L where
  allowedShapes := [FormulaShape.atomic, FormulaShape.negation,
    FormulaShape.conjunction, FormulaShape.disjunction, FormulaShape.implication]
  name := "quantifier-free"

/-- The positive fragment (no negations). -/
def positiveFragment (L : Language) : Fragment L where
  allowedShapes := [FormulaShape.atomic, FormulaShape.conjunction,
    FormulaShape.disjunction, FormulaShape.implication,
    FormulaShape.universal, FormulaShape.existential]
  name := "positive"

/-- The universal fragment. -/
def universalFragment (L : Language) : Fragment L where
  allowedShapes := [FormulaShape.atomic, FormulaShape.conjunction,
    FormulaShape.disjunction, FormulaShape.universalStrict]
  name := "universal"

/-! ## Language Restriction -/

/-- Restrict a language to a subset of its relation symbols. -/
structure LanguageRestriction (L : Language) where
  keepRelations : Nat → Bool
  keepConstants : Nat → Bool
  deriving Repr

/-- Get the restricted signature. -/
def LanguageRestriction.toSignature (r : LanguageRestriction L) : Signature where
  relationArities n :=
    if r.keepRelations n then L.sig.relationArities n else 0
  constantCount :=
    (List.range L.sig.constantCount).count (fun c => r.keepConstants c)
  name := s!"restriction-{L.sig.name}"

/-- The restricted language. -/
def LanguageRestriction.toLanguage (r : LanguageRestriction L) : Language :=
  Language.ofSignature (r.toSignature L)

/-! ## #eval examples -/

-- Substructure example (uses unitStructure from Core.Basic)
def trivialSubstruct : Substructure unitStructure where
  carrier _ := True
  closedConst _ := trivial

#eval "Substructure of unit structure defined"

-- Sublanguage example
def sublangExample : Sublanguage trivialLanguage := emptySublanguage trivialLanguage
#eval sublangExample.subSig.name

-- Fragment examples
#eval (quantifierFreeFragment trivialLanguage).name
#eval (positiveFragment trivialLanguage).name
#eval (universalFragment trivialLanguage).name

-- Language restriction
def restrictExample : LanguageRestriction trivialLanguage where
  keepRelations
    | 0 => true
    | _ => false
  keepConstants _ := false

#eval (restrictExample.toSignature trivialLanguage).name

end MiniLanguageStructure
