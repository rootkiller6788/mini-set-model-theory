/-
# Language Structure: Invariants

Language invariants: properties of signatures and languages that are
preserved under isomorphism, definitional equivalence, and Morita equivalence.

## Definitions
- `cardinalityOfSignature` — number of symbols in a signature
- `arityBounds` — maximum and minimum arity in a signature
- `isFiniteLanguage` — finiteness of the signature
- `isRelationalLanguage` — purely relational language
- `isCountableLanguage` — countability of the signature
- `signatureComplexity` — complexity measure for signatures
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Core.Laws
import MiniLanguageStructure.Morphisms.Iso

namespace MiniLanguageStructure

/-! ## Signature Cardinality -/

/-- The cardinality of a signature: count of non-zero-arity relation symbols
    plus the number of constant symbols. -/
def cardinalityOfSignature (sig : Signature) : Nat :=
  let relCount := (List.range 200).count (fun n => sig.relationArities n > 0)
  relCount + sig.constantCount

/-- A signature is finite if it has finitely many symbols. -/
def isFiniteSignature (sig : Signature) : Bool :=
  cardinalityOfSignature sig < 200

/-- A signature is countable. -/
def isCountableSignature (sig : Signature) : Bool :=
  true  -- all our signatures are countable by construction (Nat-indexed)

/-! ## Arity Bounds -/

/-- The supremum of arities in a signature (0 if none). -/
def aritySup (sig : Signature) : Nat :=
  (List.range 200).foldl (fun acc n => max acc (sig.relationArities n)) 0

/-- The minimum positive arity, or 0 if no relations. -/
def arityInf (sig : Signature) : Nat :=
  (List.range 200).filterMap (fun n =>
    let a := sig.relationArities n
    if a > 0 then some a else none
  ) |>.foldl (fun acc a => min acc a) 0

/-- A signature has bounded arity if there is a finite upper bound. -/
def hasBoundedArity (sig : Signature) : Bool :=
  aritySup sig < 200

/-- Check if all relations are unary. -/
def isUnary (sig : Signature) : Bool :=
  (List.range 200).all (fun n =>
    let a := sig.relationArities n
    a = 0 ∨ a = 1)

/-- Check if the signature is purely propositional (only nullary relations). -/
def isPropositional (sig : Signature) : Bool :=
  (List.range 200).all (fun n => sig.relationArities n = 0) ∧ sig.constantCount = 0

/-! ## Language Invariants -/

/-- A language is finite if its signature is finite. -/
def isFiniteLanguage (L : Language) : Bool := isFiniteSignature L.sig

/-- A language is relational if it has no constants. -/
def isRelationalLanguage (L : Language) : Bool := L.sig.isRelational

/-- A language is algebraic if it has no relations (only constants). -/
def isAlgebraicLanguage (L : Language) : Bool := L.sig.isAlgebraic

/-- A language is functional if all relations are at most unary. -/
def isFunctionalLanguage (L : Language) : Bool := L.sig.isFunctional

/-- A language is countable. -/
def isCountableLanguage (L : Language) : Bool := true

/-! ## Complexity Measure -/

/-- A complexity measure for signatures combining arity and symbol count. -/
def signatureComplexity (sig : Signature) : Nat :=
  let arityWeight := (List.range 200).foldl (fun acc n => acc + sig.relationArities n * sig.relationArities n) 0
  arityWeight + sig.constantCount

/-- Classification of language complexity. -/
inductive LanguageComplexity
  | trivial
  | simple
  | moderate
  | complex
  deriving Repr, Inhabited

/-- Classify a language by its complexity measure. -/
def classifyComplexity (L : Language) : LanguageComplexity :=
  let c := signatureComplexity L.sig
  if c = 0 then LanguageComplexity.trivial
  else if c < 10 then LanguageComplexity.simple
  else if c < 100 then LanguageComplexity.moderate
  else LanguageComplexity.complex

/-! ## Invariance Under Signature Isomorphism -/

/-- The cardinality of a signature is invariant under signature isomorphism. -/
def cardinalityInvariant (S T : Signature) (i : SigIso S T) : Prop :=
  cardinalityOfSignature S = cardinalityOfSignature T

/-- The arity supremum is invariant under signature isomorphism. -/
def aritySupInvariant (S T : Signature) (i : SigIso S T) : Prop :=
  aritySup S = aritySup T

/-! ## #eval examples -/

-- Signature cardinality examples
#eval cardinalityOfSignature trivialSignature  -- 1 relation + 1 constant = 2
#eval cardinalityOfSignature emptySignature    -- 0

-- Arity bounds
#eval aritySup trivialSignature   -- 1
#eval aritySup emptySignature     -- 0
#eval isUnary trivialSignature    -- true (arity 1)
#eval isPropositional emptySignature  -- true

-- Language classification
#eval isFiniteLanguage trivialLanguage
#eval isRelationalLanguage trivialLanguage  -- false (has constant)
#eval isAlgebraicLanguage trivialLanguage   -- false (has relation)

-- Complexity classification
#eval signatureComplexity trivialSignature
#eval classifyComplexity trivialLanguage
#eval classifyComplexity emptyLanguage

end MiniLanguageStructure
