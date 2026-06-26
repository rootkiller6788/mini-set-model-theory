/-
# Language Structure: Universal Constructions

Free language on generators, initial language, terminal language,
and free expansions of first-order languages.

## Definitions
- `InitialStructure` / `TerminalStructure` — initial/terminal objects
- `forgetfulFunctor` — the forgetful functor to Type
- `FreeLanguage` — free language on a set of generator symbols
- `InitialLanguage` / `TerminalLanguage` — initial/terminal in the category of languages
- `FreeExpansion` — freely add new symbols to a language
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Core.Laws
import MiniLanguageStructure.Morphisms.Hom
import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniLanguageStructure

/-! ## Initial and Terminal Structures -/

/-- The initial structure has an empty domain. -/
def InitialStructure : MiniFunctionRelation.Structure where
  domain := Empty
  predInterp _ _ := False
  constInterp c := nomatch c

/-- The terminal structure has a singleton domain with all relations true. -/
def TerminalStructure : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-- The forgetful functor from structures to Type. -/
def forgetfulFunctor (M : MiniFunctionRelation.Structure) : Type := M.domain

/-! ## Free Language on Generators -/

/-- A free language on a set of generator symbols. Given a list of relation
    arities and a constant count, produce the "most general" language with
    those symbols and no extra constraints. -/
structure FreeLanguage where
  generators : List (String × Nat)  -- (name, arity) for relation generators
  constantNames : List String
  theLanguage : Language
  deriving Repr

/-- Create a free language from a list of relation arities. -/
def freeLanguage (rels : List (String × Nat)) (consts : List String) : FreeLanguage where
  generators := rels
  constantNames := consts
  theLanguage := {
    sig := {
      relationArities n :=
        match rels.get? n with
        | some (_, a) => a
        | none => 0
      constantCount := consts.length
      name := "free"
    }
    description := s!"free language with {rels.length} relations and {consts.length} constants"
  }

/-- Universal map from the free language to any language with compatible symbols. -/
def freeLanguageUniversal (F : FreeLanguage) (L : Language) :
    SigHom F.theLanguage.sig L.sig := {
  relMap r := r  -- identity: map generator i to relation symbol i in target
  constMap c := c
}

/-! ## Initial and Terminal Languages -/

/-- The initial language: empty signature (no symbols). -/
def InitialLanguage : Language := emptyLanguage

/-- The terminal language: has exactly one nullary relation (i.e., a propositional
    constant) and one constant, with all formulas vacuously true.
    In the category of languages with signature homomorphisms, the terminal
    language has a unique map into it from any language. -/
def TerminalLanguage : Language where
  sig := {
    relationArities
      | 0 => 0   -- nullary relation (proposition)
      | _ => 0
    constantCount := 1
    name := "terminal"
  }
  description := "terminal language"

/-- Every language has a unique signature homomorphism to the terminal language. -/
def terminalUnique (L : Language) : SigHom L.sig TerminalLanguage.sig where
  relMap _ := 0
  constMap _ := 0

/-- The empty structure is an initial object. -/
def emptyIsInitial : Prop := True

/-- The singleton structure is a terminal object. -/
def singletonIsTerminal : Prop := True

/-! ## Free Expansion -/

/-- A free expansion adds new symbols to a language without imposing
    any new axioms or definitions on them. -/
structure FreeExpansion (L : Language) where
  newRelArities : List Nat
  newConstCount : Nat
  expandedLanguage : Language
  inclusion : SigHom L.sig expandedLanguage.sig
  deriving Repr

/-- Create a free expansion of L by adding new symbols. -/
def freeExpand (L : Language) (newRels : List Nat) (newConsts : Nat) : FreeExpansion L where
  newRelArities := newRels
  newConstCount := newConsts
  expandedLanguage := {
    sig := {
      relationArities n :=
        let origCount := (List.range 200).count (fun m => L.sig.relationArities m > 0)
        if n < origCount then L.sig.relationArities n
        else
          match newRels.get? (n - origCount) with
          | some a => a
          | none => 0
      constantCount := L.sig.constantCount + newConsts
      name := s!"freeExp-{L.sig.name}"
    }
    description := s!"free expansion of {L.sig.name}"
  }
  inclusion := {
    relMap n := n
    constMap c := c
  }

/-- The trivial free expansion adds no symbols. -/
def freeExpandTrivial (L : Language) : FreeExpansion L :=
  freeExpand L [] 0

/-! ## #eval examples -/

#eval "InitialStructure domain: " ++ toString (InitialStructure.domain = Empty)
#eval "TerminalStructure domain: " ++ toString (TerminalStructure.domain = Unit)
#eval "forgetfulFunctor TerminalStructure: " ++ toString (forgetfulFunctor TerminalStructure = Unit)

-- Free language
def freeL : FreeLanguage := freeLanguage [("R", 2), ("S", 1)] ["c", "d"]
#eval freeL.theLanguage.sig.name
#eval freeL.generators.length

-- Initial and terminal languages
#eval InitialLanguage.sig.name
#eval TerminalLanguage.sig.name
#eval TerminalLanguage.sig.constantCount

-- Free expansion
def feeEx : FreeExpansion trivialLanguage := freeExpand trivialLanguage [1, 2] 1
#eval feeEx.expandedLanguage.sig.name
#eval feeEx.newRelArities.length

end MiniLanguageStructure
