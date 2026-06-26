/-
# Satisfaction Model: Standard Examples

Standard model-theoretic structures: DLO, ACF, RCF, Presburger
arithmetic, random graph, and theories. Covers L6, L7.

## Knowledge Coverage
- L6: Concrete structures with #eval verification
- L7: Applications to algebra (ACF), order theory (DLO)
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Core.Objects
import MiniFunctionRelation.Core.Basic

namespace MiniSatisfactionModel

/-! ## Standard Structures -/

def natStructure : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp
    | 0, [x, y] => x < y
    | 1, [x, y] => x = y
    | _, _ => False
  constInterp
    | 0 => 0
    | 1 => 1
    | _ => 0

def intStructure : MiniFunctionRelation.Structure where
  domain := Int
  predInterp
    | 0, [x, y] => x < y
    | 1, [x, y] => x = y
    | _, _ => False
  constInterp
    | 0 => 0
    | 1 => 1
    | _ => 0

def ratStructure : MiniFunctionRelation.Structure where
  domain := Rat
  predInterp
    | 0, [x, y] => x < y
    | 1, [x, y] => x = y
    | _, _ => False
  constInterp
    | 0 := 0
    | 1 := 1
    | _ := 0

/-! ## Dense Linear Order Without Endpoints (DLO) -/

def dloStructure : MiniFunctionRelation.Structure where
  domain := Rat
  predInterp
    | 0, [x, y] => x < y
    | _, _ => False
  constInterp _ := 0

/-! DLO axioms:
1. Transitivity: x < y ∧ y < z → x < z
2. Irreflexivity: ¬(x < x)
3. Linearity: x < y ∨ y < x ∨ x = y
4. Density: x < y → ∃z (x < z ∧ z < y)
5. No endpoints: ∀x∃y (x < y) ∧ ∀x∃y (y < x) -/

def dloAxioms : Set (MiniLogicKernel.PredFormula) :=
  { .all (.all (.all (.impl (.and (.pred 0 [0, 1]) (.pred 0 [1, 2])) (.pred 0 [0, 2])))),
    .all (.not (.pred 0 [0, 0])),
    .all (.all (.or (.pred 0 [0, 1]) (.or (.pred 0 [1, 0]) (.eq 0 1)))),
    .all (.all (.impl (.pred 0 [0, 1]) (.ex (.and (.pred 0 [0, 2]) (.pred 0 [2, 1]))))),
    .all (.ex (.pred 0 [0, 1])),
    .all (.ex (.pred 0 [1, 0]))
  }

/-! Properties of DLO:
- ℵ₀-categorical (unique countable model: (ℚ, <))
- Unstable (has the strict order property)
- Has quantifier elimination
- Model-complete
- Fraïssé limit of finite linear orders -/

def dloTheoryProperties : List String :=
  ["ℵ₀-categorical: unique countable model (ℚ,<)",
   "Unstable: has the strict order property",
   "QE: every formula equivalent to quantifier-free formula in {<}",
   "Model-complete: every embedding between models is elementary",
   "Fraïssé limit of finite linear orders"]

/-! ## Presburger Arithmetic -/

def presburgerSignature : String := "Language: <+, 0, 1, <⟩"

/-! Presburger arithmetic is the theory of (ℕ, +, 0, 1, <).
It is:
- Decidable (Presburger, 1929)
- Has QE in the expanded language with modular predicates
- NOT ℵ₀-categorical
- Stable -/

def presburgerProperties : List String :=
  ["Decidable (Presburger 1929)",
   "Has QE in expanded language with ≡_n predicates",
   "Stable theory",
   "Not ℵ₀-categorical"]

/-! ## Real Closed Fields (RCF) -/

def rcfSignature : String := "Language: <+, ·, 0, 1, <⟩"

/-! RCF is the theory of real closed fields. Axioms:
1. Field axioms
2. Ordered field axioms
3. Every positive element has a square root
4. Every odd-degree polynomial has a root

Properties:
- Complete, decidable (Tarski 1951)
- Has QE
- o-minimal (important for real algebraic geometry)
- NOT ℵ₀-categorical, NOT ℵ₁-categorical -/

def rcfProperties : List String :=
  ["Complete and decidable (Tarski 1951)",
   "Has QE in the language of ordered rings",
   "o-minimal: definable sets are finite unions of intervals",
   "Not categorical in any power"]

/-! ## Algebraically Closed Fields (ACF) -/

def acfSignature : String := "Language: <+, ·, 0, 1⟩"

def acfAxioms : Set (MiniLogicKernel.PredFormula) :=
  { .prop (.true : MiniLogicKernel.Formula) }  -- Placeholder; real axioms are field axioms + algebraic closure

/-! ACF_p classification:
- ℵ₁-categorical (Steinitz: ACF of char p is determined by transcendence degree)
- ω-stable, has QE (Tarski)
- Morley rank = Krull dimension
- Model companion of fields -/

def acfProperties (p : Nat) : List String :=
  if p = 0 then
    ["ℵ₁-categorical", "ω-stable", "Has QE (Tarski)",
     "Morley rank = transcendence degree",
     "Model companion of fields (char 0)"]
  else
    ["ℵ₁-categorical in char " ++ toString p,
     "ω-stable", "Has QE (Tarski)",
     "Morley rank = transcendence degree",
     "Model companion of fields (char " ++ toString p ++ ")"]

/-! ## Random Graph -/

def randomGraphSignature : String := "Language: <E> (binary edge relation)"

/-! The random graph (Rado graph) is the Fraïssé limit of finite graphs.
Properties:
- ℵ₀-categorical
- Unstable (has the independence property)
- Simple (decidable)
- Universal: contains every countable graph as induced subgraph -/

def randomGraphProperties : List String :=
  ["ℵ₀-categorical: unique countable random graph",
   "Unstable: has the independence property (IP)",
   "Decidable theory",
   "Universal: contains every finite/countable graph",
   "Homogeneous: any isomorphism between finite subgraphs extends to automorphism",
   "Simple theory (lowest complexity among unstable theories)"]

/-! ## Standard Examples List -/

def standardStructures : List (String × MiniFunctionRelation.Structure) :=
  [("natStructure", natStructure),
   ("intStructure", intStructure),
   ("ratStructure", ratStructure),
   ("dloStructure", dloStructure)]

def standardExampleNames : List String :=
  ["natStructure", "intStructure", "ratStructure", "dloStructure"]

/-! ## Satisfaction Verification -/

def triviallyTrueSentences : List (MiniLogicKernel.PredFormula) :=
  [.prop (.true : MiniLogicKernel.Formula),
   .not (.prop (.false : MiniLogicKernel.Formula)),
   .impl (.prop (.true : MiniLogicKernel.Formula)) (.prop (.true : MiniLogicKernel.Formula))]

def triviallyFalseSentences : List (MiniLogicKernel.PredFormula) :=
  [.prop (.false : MiniLogicKernel.Formula),
   .not (.prop (.true : MiniLogicKernel.Formula))]

/-! ## Theory Examples -/

def dloTheory : Theory where
  axioms := dloAxioms

def emptyTheoryExample : Theory :=
  { axioms := ∅ }

def tautologyTheoryExample : Theory :=
  { axioms := { .prop (.true : MiniLogicKernel.Formula) } }

/-! ## #eval Examples -/

#eval natStructure.domain
#eval isTrueIn dloStructure (.not (.all (.pred 0 [0, 0])))
#eval standardExampleNames
#eval triviallyTrueSentences.length
#eval triviallyFalseSentences.length
#eval dloStructure.predInterp 0 [1, 2]
#eval dloStructure.predInterp 0 [2, 1]
#eval "ratStructure" ∈ standardExampleNames
#eval dloTheoryProperties
#eval presburgerProperties
#eval rcfProperties
#eval acfProperties 0
#eval randomGraphProperties

end MiniSatisfactionModel
