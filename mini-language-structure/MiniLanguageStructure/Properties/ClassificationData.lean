/-
# Language Structure: Classification Data

Classification of first-order languages by structural properties:
finite, countable, relational, algebraic, functional, propositional.

## Definitions
- `LanguageClass` — classification enum for languages
- `classifyLanguage` — classify a language by its signature properties
- `finiteLanguageData` — data for finite languages
- `relationalLanguageData` — data for relational languages
- `algebraicLanguageData` — data for algebraic (constant-only) languages
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Properties.Invariants

namespace MiniLanguageStructure

/-! ## Language Classification -/

/-- The classification enum for first-order languages. -/
inductive LanguageClass
  | finiteRelational
  | finiteAlgebraic
  | finiteGeneral
  | countableRelational
  | countableAlgebraic
  | countableGeneral
  | functional
  | propositional
  | empty
  deriving Repr, Inhabited

/-- Classify a language based on its signature properties. -/
def classifyLanguage (L : Language) : LanguageClass :=
  if cardinalityOfSignature L.sig = 0 then
    LanguageClass.empty
  else if isPropositional L.sig then
    LanguageClass.propositional
  else if isFunctionalLanguage L then
    LanguageClass.functional
  else if isAlgebraicLanguage L then
    if isFiniteLanguage L then LanguageClass.finiteAlgebraic
    else LanguageClass.countableAlgebraic
  else if isRelationalLanguage L then
    if isFiniteLanguage L then LanguageClass.finiteRelational
    else LanguageClass.countableRelational
  else
    if isFiniteLanguage L then LanguageClass.finiteGeneral
    else LanguageClass.countableGeneral

/-! ## Finite Language Data -/

/-- A finite language is completely described by a finite list of relation
    arities and a finite number of constants. -/
structure FiniteLanguageData where
  relationArities : List (Nat × Nat)   -- (index, arity) pairs for relations
  constantCount : Nat
  name : String
  deriving Repr

/-- Extract finite data from a language (best-effort: limits to first 200 symbols). -/
def finiteLanguageData (L : Language) : FiniteLanguageData where
  relationArities :=
    (List.range 200).filterMap fun n =>
      let a := L.sig.relationArities n
      if a > 0 then some (n, a) else none
  constantCount := L.sig.constantCount
  name := L.sig.name

/-- Number of relation symbols in a finite language. -/
def FiniteLanguageData.numRelations (d : FiniteLanguageData) : Nat :=
  d.relationArities.length

/-- Sum of all arities in a finite language. -/
def FiniteLanguageData.sumArities (d : FiniteLanguageData) : Nat :=
  d.relationArities.foldl (fun acc (_, a) => acc + a) 0

/-- Total symbol count. -/
def FiniteLanguageData.totalSymbols (d : FiniteLanguageData) : Nat :=
  d.numRelations + d.constantCount

/-! ## Relational Language Data -/

/-- A purely relational language has only relation symbols. -/
structure RelationalLanguageData where
  relationArities : List (Nat × Nat)
  name : String
  deriving Repr

/-- Extract relational data from a relational language. -/
def relationalLanguageData (L : Language) : RelationalLanguageData where
  relationArities := (finiteLanguageData L).relationArities
  name := L.sig.name

/-! ## Algebraic Language Data -/

/-- A purely algebraic language has only constant symbols. -/
structure AlgebraicLanguageData where
  constantCount : Nat
  name : String
  deriving Repr

/-- Extract algebraic data. -/
def algebraicLanguageData (L : Language) : AlgebraicLanguageData where
  constantCount := L.sig.constantCount
  name := L.sig.name

/-! ## Functional Language Data -/

/-- A functional language has only unary relations (predicates). -/
structure FunctionalLanguageData where
  predicateCount : Nat
  name : String
  deriving Repr

/-- Extract functional data. -/
def functionalLanguageData (L : Language) : FunctionalLanguageData where
  predicateCount := (List.range 200).count (fun n => L.sig.relationArities n > 0)
  name := L.sig.name

/-! ## Language Classification Hierarchy -/

/-- The language classification hierarchy establishes a natural
    complexity ordering on first-order languages:
    Empty ⊂ Propositional ⊂ Unary ⊂ Monadic ⊂ Relational ⊂ Finite ⊂ Countable ⊂ All -/
def languageClassificationHierarchy : List (String × LanguageClass) := [
  ("Empty", LanguageClass.empty),
  ("Propositional", LanguageClass.propositional),
  ("Finite Relational", LanguageClass.finiteRelational),
  ("Finite Algebraic", LanguageClass.finiteAlgebraic),
  ("Finite General", LanguageClass.finiteGeneral),
  ("Countable Relational", LanguageClass.countableRelational),
  ("Countable General", LanguageClass.countableGeneral),
  ("Functional", LanguageClass.functional)
]

/-- The language class determines decidability:
    - Empty/Propositional: Trivially decidable
    - Monadic (unary): Decidable (Lowenheim 1915)
    - Finite Relational with binary: Often undecidable
    - Finite General: Usually undecidable -/
def decidabilityByClass : List (LanguageClass × String) := [
  (LanguageClass.empty, "Trivially decidable"),
  (LanguageClass.propositional, "Decidable (propositional logic)"),
  (LanguageClass.finiteRelational, "Decidable for monadic, undecidable for binary+"),
  (LanguageClass.finiteAlgebraic, "Decidable (only equality of constants)"),
  (LanguageClass.functional, "Decidable for unary predicates only"),
  (LanguageClass.finiteGeneral, "Typically undecidable")
]

/-! ## Shelah's Classification Program -/

/-- Shelah's classification program divides first-order theories into
    stability classes, each with distinct structural properties. -/
inductive StabilityClass
  | omegaStable
  | superstable
  | stable
  | simple
  | NIP
  | wild
  deriving Repr

/-- Example: ACF (algebraically closed fields) is ω-stable. -/
def acf_is_omegaStable : StabilityClass := StabilityClass.omegaStable

/-- Example: The random graph is simple but not stable. -/
def randomGraph_is_simple : StabilityClass := StabilityClass.simple

/-- Example: (N, +, ×) is wild (full arithmetic complexity). -/
def arithmetic_is_wild : StabilityClass := StabilityClass.wild

/-! ## #eval examples -/

#eval "══ Language Classification ══"

-- Classification hierarchy
#eval "── Classification Hierarchy ──"
#eval languageClassificationHierarchy

-- Classify standard languages
#eval s!"Empty language: {classifyLanguage emptyLanguage}"
#eval s!"Trivial language: {classifyLanguage trivialLanguage}"

-- Group signature (1 binary relation, 1 constant): finite general
def groupSigC : Signature where
  relationArities | 0 => 2 | _ => 0
  constantCount := 1
  name := "group"
def groupLangC : Language := Language.ofSignature groupSigC
#eval s!"Group language: {classifyLanguage groupLangC}"

-- Finite language data
def fldGroup := finiteLanguageData groupLangC
#eval s!"Group: {fldGroup.numRelations} relations, {fldGroup.sumArities} total arity, {fldGroup.totalSymbols} symbols"

-- Relational language: graph signature (one binary relation)
def graphSig : Signature where
  relationArities | 0 => 2 | _ => 0
  constantCount := 0
  name := "graph"
def graphLang : Language := Language.ofSignature graphSig
#eval s!"Graph language: {classifyLanguage graphLang}"

-- Algebraic language: just constants
def pointSig : Signature where
  relationArities _ := 0
  constantCount := 3
  name := "points"
def pointLang : Language := Language.ofSignature pointSig
#eval s!"Point language: {classifyLanguage pointLang}"

-- Decidability by class
#eval "── Decidability by Language Class ──"
#eval decidabilityByClass

-- Shelah classification
#eval "── Shelah's Classification Program ──"
#eval acf_is_omegaStable
#eval randomGraph_is_simple
#eval arithmetic_is_wild

end MiniLanguageStructure
