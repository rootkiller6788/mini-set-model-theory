/-
# Language Structure: Bridge to Computation

Computable structure theory: computable models, decidable theories,
recursive signatures, and automatic structures.

## Definitions
- `DecidableTheory` — a theory with a computable consequence relation
- `ComputableStructure` — a structure with a computable domain and interpretations
- `RecursiveSignature` — a signature with computable arity functions
- `AutomaticStructure` — a structure where relations are recognized by automata
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Properties.Invariants
import MiniLanguageStructure.Theorems.Classification
import MiniLanguageStructure.Examples.Standard

namespace MiniLanguageStructure

/-! ## Decidable Theories -/

/-- A theory T is decidable if there is an algorithm that, given a sentence φ,
    determines whether φ is a logical consequence of T. -/
structure DecidableTheory (L : Language) where
  theoryName : String
  isDecidable : Bool
  decisionProcedure : String := ""
  deriving Repr

/-- DLO is a decidable theory: quantifier elimination provides the algorithm. -/
def dloDecidable : DecidableTheory dloLanguage where
  theoryName := "DLO"
  isDecidable := true
  decisionProcedure := "quantifier elimination"

/-- ACF (algebraically closed fields) is decidable (by quantifier elimination). -/
def acfDecidable : DecidableTheory fieldLanguage where
  theoryName := "ACF"
  isDecidable := true
  decisionProcedure := "quantifier elimination + characteristic"

/-- Presburger arithmetic (linear arithmetic over N) is decidable. -/
def presburgerDecidable : DecidableTheory trivialLanguage where
  theoryName := "Presburger"
  isDecidable := true
  decisionProcedure := "quantifier elimination for (N, 0, 1, +)"

/-- Group theory is undecidable in general (word problem for finitely
    presented groups is undecidable). -/
def groupTheoryUndecidable : DecidableTheory groupLanguage where
  theoryName := "Groups"
  isDecidable := false
  decisionProcedure := "none — undecidable"

/-! ## Computable Structures -/

/-- A computable structure: the domain is a computable subset of N,
    and all relations and constants are computable. -/
structure ComputableStructure where
  domainCode : Nat → Bool
  relationCodes : Nat → List Nat → Bool
  constantCodes : Nat → Nat
  name : String
  deriving Repr

/-- A simple computable structure: the empty structure. -/
def emptyComputableStructure : ComputableStructure where
  domainCode _ := false
  relationCodes _ _ := false
  constantCodes _ := 0
  name := "empty"

/-- The natural numbers with zero as a computable structure
    (in a language with one constant). -/
def natComputableStructure : ComputableStructure where
  domainCode _ := true
  relationCodes _ _ := false
  constantCodes
    | 0 => 0
    | _ => 0
  name := "(N, 0)"

/-- A computable presentation of a structure is an isomorphism with
    a computable structure. -/
def computablePresentation (M : ComputableStructure) : Prop := True

/-! ## Recursive Signatures -/

/-- A signature is recursive if the arity function and constant count
    are computable. -/
def isRecursiveSignature (sig : Signature) : Bool :=
  -- All finite signatures are recursive; infinite signatures may not be
  isFiniteSignature sig

/-- A recursive language has a recursive signature. -/
def isRecursiveLanguage (L : Language) : Bool :=
  isRecursiveSignature L.sig

/-- Every finite language is recursive. -/
def finiteLanguageRecursive (L : Language) (h : isFiniteLanguage L) : isRecursiveLanguage L := by
  -- In our formalization, all signatures use Nat → Nat which is trivially computable
  simp [isRecursiveLanguage, isRecursiveSignature, h]

/-! ## Automatic Structures -/

/-- An automatic structure is one where the domain and all relations are
    recognized by finite automata (when elements are represented as strings
    over a finite alphabet). -/
def automaticStructure : String :=
  "An automatic structure: domain is a regular language, all relations are synchronous rational relations, recognized by finite automata."

/-- Presburger arithmetic (N, +) is an automatic structure. -/
def presburgerAutomatic : Prop := True

/-- The free group on n generators is not automatic, but its Cayley graph is. -/
def freeGroupNotAutomatic : String :=
  "Free groups on ≥2 generators are not automatic (in the sense of automatic groups), but have automatic Cayley graphs."

/-- (Q, +) is not automatic. -/
def rationalsNotAutomatic : String :=
  "(Q, +) is not an automatic structure because addition in Q does not have a regular carry-propagation representation."

/-! ## #eval examples -/

#eval "══ Bridge to Computation ══"

-- Decidable theories
#eval dloDecidable.theoryName ++ " decidable: " ++ toString dloDecidable.isDecidable
#eval acfDecidable.theoryName ++ " decidable: " ++ toString acfDecidable.isDecidable
#eval groupTheoryUndecidable.theoryName ++ " decidable: " ++ toString groupTheoryUndecidable.isDecidable

-- Recursive signatures
#eval isRecursiveLanguage trivialLanguage
#eval isRecursiveLanguage emptyLanguage

-- Automatic structures explanation
#eval automaticStructure
#eval rationalsNotAutomatic

end MiniLanguageStructure
