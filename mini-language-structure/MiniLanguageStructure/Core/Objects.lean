/-
# Language Structure: Objects

Defines `Signature` and `Language` — the fundamental types for
first-order languages. A signature specifies relation symbols (with arities)
and constant symbols; a language wraps a signature with naming conventions.

## Definitions
- `Signature` — record of relation arities and constant count
- `Language` — a named signature with metadata
- `isRelational` / `isAlgebraic` — signature classification
- `arity` — query the arity of a relation symbol
- `emptySignature` / `trivialSignature` — canonical examples
-/

import MiniLanguageStructure.Core.Basic

namespace MiniLanguageStructure

/-! ## Signature Type -/

/-- A first-order signature: relation symbols indexed by Nat with arities,
    and a number of constant symbols. -/
structure Signature where
  relationArities : Nat → Nat
  constantCount : Nat
  name : String := ""
  deriving Repr

/-- Empty signature: no relations, no constants. -/
def emptySignature : Signature where
  relationArities _ := 0
  constantCount := 0
  name := "empty"

/-- Trivial signature: one unary relation and one constant. -/
def trivialSignature : Signature where
  relationArities
    | 0 => 1
    | _ => 0
  constantCount := 1
  name := "trivial"

/-! ## Language Type -/

/-- A language wraps a signature and adds interpretation metadata.
    In model theory, "language" and "signature" are often synonymous. -/
structure Language where
  sig : Signature
  description : String := ""
  deriving Repr

/-- Create a language from a signature. -/
def Language.ofSignature (sig : Signature) : Language :=
  { sig := sig, description := sig.name }

/-- The empty language (no symbols). -/
def emptyLanguage : Language := Language.ofSignature emptySignature

/-- The trivial language (one unary relation, one constant). -/
def trivialLanguage : Language := Language.ofSignature trivialSignature

/-! ## Signature Classification -/

/-- A signature is relational if it has no constant symbols. -/
def Signature.isRelational (sig : Signature) : Bool :=
  sig.constantCount = 0

/-- A signature is algebraic if it has only constant symbols (no relations). -/
def Signature.isAlgebraic (sig : Signature) : Bool :=
  (List.range 100).all (fun n => sig.relationArities n = 0)

/-- A signature is functional if all relations have arity 0 or 1 (predicates). -/
def Signature.isFunctional (sig : Signature) : Bool :=
  (List.range 100).all (fun n =>
    let a := sig.relationArities n
    a = 0 ∨ a = 1)

/-- Maximum arity in a signature, or 0 if none. -/
def Signature.maxArity (sig : Signature) : Nat :=
  (List.range 100).foldl (fun acc n => max acc (sig.relationArities n)) 0

/-! ## Arity Queries -/

/-- Arity of a relation symbol in a language. -/
def arity (L : Language) (relIdx : Nat) : Nat :=
  L.sig.relationArities relIdx

/-- Number of constants in a language. -/
def constantCount (L : Language) : Nat :=
  L.sig.constantCount

/-- Get the arity as a SymbolKind. -/
def Language.symbolKind (L : Language) (idx : Nat) : SymbolKind :=
  let a := L.sig.relationArities idx
  if a > 0 then SymbolKind.relation a else SymbolKind.constant

/-- Total number of symbols (relations with non-zero arity + constants). -/
def Language.totalSymbols (L : Language) : Nat :=
  let relCount := (List.range 100).count (fun n => L.sig.relationArities n > 0)
  relCount + L.sig.constantCount

/-! ## Language Classification Booleans -/

/-- Check if a language is relational. -/
def isRelational (L : Language) : Bool := L.sig.isRelational

/-- Check if a language is algebraic. -/
def isAlgebraic (L : Language) : Bool := L.sig.isAlgebraic

/-- Check if a language is functional. -/
def isFunctional (L : Language) : Bool := L.sig.isFunctional

/-! ## #eval examples -/

-- Group language: one binary relation (equality implied) and constants: identity, inverse map included via additional structure
def groupSig : Signature where
  relationArities
    | 0 => 2   -- binary operation (as relation)
    | _ => 0
  constantCount := 1  -- identity element
  name := "group"

#eval groupSig.constantCount
#eval groupSig.isRelational
#eval groupSig.isAlgebraic
#eval groupSig.maxArity

def groupLang : Language := Language.ofSignature groupSig
#eval arity groupLang 0     -- 2
#eval arity groupLang 1     -- 0 (no symbol at index 1)
#eval isRelational groupLang  -- false (has constant)
#eval isAlgebraic groupLang   -- false (has relation)
#eval totalSymbols groupLang  -- 2 (one relation + one constant)

end MiniLanguageStructure
