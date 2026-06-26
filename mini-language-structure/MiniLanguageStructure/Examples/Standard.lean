/-
# Language Structure: Standard Examples

Standard first-order languages: groups, rings, fields, orders, graphs,
and other common algebraic/logical structures.

## Languages
- `groupLanguage` — language of groups (binary operation, identity, inverse)
- `ringLanguage` — language of rings (+, *, 0, 1)
- `fieldLanguage` — language of fields (+, *, 0, 1)
- `orderLanguage` — language of partial/total orders (binary relation)
- `graphLanguage` — language of graphs (one binary edge relation)
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Properties.Invariants
import MiniLanguageStructure.Properties.ClassificationData

namespace MiniLanguageStructure

/-! ## Group Language -/

/-- The language of groups: one binary relation (interpreted as the graph
    of multiplication) and one constant (identity). Note: in actual model
    theory, group language has a binary function symbol; here we represent
    functions as relations with functionality axioms. -/
def groupSignature : Signature where
  relationArities
    | 0 => 3   -- ternary: mult(x,y,z) means x*y = z
    | _ => 0
  constantCount := 1  -- identity e
  name := "group"

/-- Group language. -/
def groupLanguage : Language := Language.ofSignature groupSignature

/-- The standard group axioms (as strings; formalization left to future work). -/
def groupAxioms : List String := [
  "associativity",
  "identity",
  "inverses"
]

/-- Group language is algebraic (has constants, and binary functions need
    relations; this is neither purely relational nor purely algebraic). -/
#eval classifyLanguage groupLanguage

/-! ## Ring Language -/

/-- The language of rings: two binary operation relations and two constants. -/
def ringSignature : Signature where
  relationArities
    | 0 => 3   -- add(x,y,z) = x+y
    | 1 => 3   -- mul(x,y,z) = x*y
    | _ => 0
  constantCount := 2  -- 0, 1
  name := "ring"

/-- Ring language. -/
def ringLanguage : Language := Language.ofSignature ringSignature

/-- Ring axioms. -/
def ringAxioms : List String := [
  "additive abelian group",
  "multiplicative monoid",
  "distributivity"
]

#eval classifyLanguage ringLanguage

/-! ## Field Language -/

/-- The language of fields: extends ring language with multiplicative inverse
    (but inverse is naturally partial; handled in the theory, not the language). -/
def fieldSignature : Signature := ringSignature
def fieldSignature' : Signature := { ringSignature with name := "field" }

/-- Field language. -/
def fieldLanguage : Language := Language.ofSignature fieldSignature'

/-- Field axioms (extending ring axioms). -/
def fieldAxioms : List String := ringAxioms ++ [
  "multiplicative inverses for nonzero elements",
  "0 ≠ 1"
]

#eval classifyLanguage fieldLanguage

/-! ## Order Language -/

/-- The language of partial orders: one binary relation (≤). -/
def orderSignature : Signature where
  relationArities
    | 0 => 2   -- ≤(x,y)
    | _ => 0
  constantCount := 0
  name := "order"

/-- Order language. -/
def orderLanguage : Language := Language.ofSignature orderSignature

/-- Order axioms. -/
def orderAxioms : List String := [
  "reflexivity",
  "antisymmetry",
  "transitivity"
]

/-- Total order adds comparability. -/
def totalOrderAxioms : List String := orderAxioms ++ ["totality"]

/-- Order language is relational. -/
#eval isRelationalLanguage orderLanguage

/-! ## Graph Language -/

/-- The language of graphs: one binary relation (edge). -/
def graphSignature : Signature where
  relationArities
    | 0 => 2   -- edge(x,y)
    | _ => 0
  constantCount := 0
  name := "graph"

/-- Graph language. -/
def graphLanguage : Language := Language.ofSignature graphSignature

/-- Graph axioms (simple undirected graph). -/
def graphAxioms : List String := [
  "irreflexive",
  "symmetric"
]

/-- Directed graph has no symmetry requirement. -/
def directedGraphAxioms : List String := ["irreflexive"]

#eval classifyLanguage graphLanguage

/-! ## #eval examples -/

-- Print language names and classify
def langs : List Language := [groupLanguage, ringLanguage, fieldLanguage, orderLanguage, graphLanguage]
def langInfo : List (String × Nat × Nat) :=
  langs.map fun L =>
    (L.sig.name,
     cardinalityOfSignature L.sig,
     aritySup L.sig)

#eval "══ Standard Languages ══"
#eval groupLanguage.sig.name ++ " : " ++ toString (cardinalityOfSignature groupLanguage.sig) ++ " symbols"
#eval ringLanguage.sig.name ++ " : " ++ toString (cardinalityOfSignature ringLanguage.sig) ++ " symbols"
#eval orderLanguage.sig.name ++ " : " ++ toString (cardinalityOfSignature orderLanguage.sig) ++ " symbols"
#eval graphLanguage.sig.name ++ " : " ++ toString (cardinalityOfSignature graphLanguage.sig) ++ " symbols"

end MiniLanguageStructure
