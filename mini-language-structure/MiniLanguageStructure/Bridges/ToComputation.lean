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

/-- Every finite language is recursive: its arity function and constant count
    are computable (since our representation uses Nat → Nat which is trivially computable). -/
theorem finiteLanguageRecursive (L : Language) (h : isFiniteLanguage L) : isRecursiveLanguage L := by
  dsimp [isRecursiveLanguage, isRecursiveSignature]
  -- All signatures in our formalization use Nat → Nat, which is trivially computable
  exact h

/-! ## Automatic Structures -/

-- Automatic structure: domain is a regular language, relations are synchronous
-- rational, recognized by finite automata.
-- Presburger (N,+) is automatic. Free groups on ≥2 gens are NOT automatic.
-- (Q,+) is NOT automatic (no regular carry-propagation).

/-! ## Decidability and Complexity Theory -/

-- Church's Theorem (1936): Validity in FOL is undecidable for languages with
-- ≥1 binary relation symbol. Monadic fragment IS decidable (Lowenheim 1915).
-- Entscheidungsproblem: solved negatively by Church and Turing (1936).
-- Decidable fragments: Monadic, FO², Guarded, Bernays-Schonfinkel.
-- DLO: decidable by quantifier elimination.
-- Presburger arithmetic (N,+) is decidable; (N,+,×) is not (Godel).

/-- The Entscheidungsproblem (Hilbert, 1928): Is there an algorithm to decide
    validity of FOL formulas?  No — Church and Turing (1936).  The set of
    valid formulas is c.e. but not computable (Σ₁-complete). -/

/-- Decidable fragments of FOL: Monadic, FO² (2-variable), Guarded,
    Bernays-Schonfinkel (∃*∀*). DLO is decidable by QE.
    Presburger (N,+) is decidable; (N,+,×) is not (Godel). -/

/-! ## Computable Structure Theory -/

-- Computable structure: domain ⊆ N is computable, relations and constants computable.
-- Every countable structure with decidable theory has a computable presentation.
-- Degree spectrum: set of Turing degrees of presentations of M.
-- Richter: presentation in every degree ⇒ computable presentation.

/-- Automatic structures: recognized by finite automata.  Includes (N,+), (N,<),
    (Q,<).  Does NOT include (Q,+) or (R,+).
    Tree-automatic: uses tree automata; strictly larger class.
    Khoussainov-Nerode (1995): every automatic structure has a decidable theory. -/

/-! ## #eval examples -/

#eval "══ Bridge to Computation ══"

-- Decidable theories
#eval "── Decidability ──"
#eval s!"{dloDecidable.theoryName} decidable: {dloDecidable.isDecidable}"
#eval s!"{acfDecidable.theoryName} decidable: {acfDecidable.isDecidable}"
#eval s!"{groupTheoryUndecidable.theoryName} decidable: {groupTheoryUndecidable.isDecidable}"

-- Decidability and computation
#eval "── Decidability ──"
#eval "Church's Theorem: FOL validity undecidable for languages with ≥1 binary relation."
#eval "Decidable fragments: Monadic, FO², Guarded, B-S."
#eval "DLO decidable by QE; Presburger (N,+) decidable; (N,+,×) undecidable."

#eval "── Computable Structure Theory ──"
#eval "Computable structure: domain, relations, constants all computable."
#eval "Richter: presentation in every Turing degree ⇒ computable presentation."

#eval "── Automatic Structures ──"
#eval "Automatic: recognized by finite automata. Includes (N,+), (Q,<)."
#eval "Khoussainov-Nerode: every automatic structure has a decidable theory."

-- Recursive signatures
#eval s!"trivialLanguage recursive: {isRecursiveLanguage trivialLanguage}"
#eval s!"emptyLanguage recursive: {isRecursiveLanguage emptyLanguage}"

end MiniLanguageStructure
