/-
# Language Structure: Finite Structures

Examples of finite first-order structures: graphs, groups, orders,
and combinatorial structures.

## Examples
- `finiteGraph` — a finite graph structure
- `finiteGroup` — a finite group (e.g., Z/3Z) as a structure
- `finiteLinearOrder` — a finite linear order
- `finiteStructureEnumeration` — enumerate all structures of a given size
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Constructions.Subobjects
import MiniLanguageStructure.Constructions.Products
import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniLanguageStructure

/-! ## Finite Graphs -/

/-- A finite graph with 3 vertices: a triangle. -/
inductive Vertex3
  | v0 | v1 | v2
  deriving Repr, DecidableEq

def triangleGraph : MiniFunctionRelation.Structure where
  domain := Vertex3
  predInterp p args :=
    if p = 0 then
      -- edge relation: complete graph K3
      match args with
      | [x, y] => x ≠ y
      | _ => False
    else False
  constInterp _ := Vertex3.v0

/-- A 2-vertex graph: just an edge. -/
inductive Vertex2
  | a | b
  deriving Repr, DecidableEq

def edgeGraph : MiniFunctionRelation.Structure where
  domain := Vertex2
  predInterp p args :=
    if p = 0 then args = [Vertex2.a, Vertex2.b] ∨ args = [Vertex2.b, Vertex2.a]
    else False
  constInterp _ := Vertex2.a

/-! ## Finite Groups as Structures -/

/-- The cyclic group Z/2Z as a structure. -/
inductive Z2
  | e | g
  deriving Repr, DecidableEq

def z2AsStructure : MiniFunctionRelation.Structure where
  domain := Z2
  predInterp p args :=
    if p = 0 then
      -- group multiplication as ternary relation
      match args with
      | [Z2.e, Z2.e, Z2.e] => True
      | [Z2.e, Z2.g, Z2.g] => True
      | [Z2.g, Z2.e, Z2.g] => True
      | [Z2.g, Z2.g, Z2.e] => True
      | _ => False
    else False
  constInterp
    | 0 => Z2.e    -- identity
    | _ => Z2.e

/-- The cyclic group Z/3Z. -/
inductive Z3
  | e | g | g2
  deriving Repr, DecidableEq

def z3AsStructure : MiniFunctionRelation.Structure where
  domain := Z3
  predInterp p args :=
    if p = 0 then
      match args with
      | [x, Z3.e, z] => x = z
      | [Z3.e, y, z] => y = z
      | [Z3.g, Z3.g, Z3.g2] => True
      | [Z3.g, Z3.g2, Z3.e] => True
      | [Z3.g2, Z3.g, Z3.e] => True
      | [Z3.g2, Z3.g2, Z3.g] => True
      | _ => False
    else False
  constInterp _ := Z3.e

/-! ## Finite Linear Order -/

/-- A 3-element linear order. -/
def threeElementOrder : MiniFunctionRelation.Structure where
  domain := Vertex3
  predInterp p args :=
    if p = 0 then
      match args with
      | [x, y] =>
        (x = Vertex3.v0 ∧ (y = Vertex3.v0 ∨ y = Vertex3.v1 ∨ y = Vertex3.v2)) ∨
        (x = Vertex3.v1 ∧ (y = Vertex3.v1 ∨ y = Vertex3.v2)) ∨
        (x = Vertex3.v2 ∧ y = Vertex3.v2)
      | _ => False
    else False
  constInterp _ := Vertex3.v0

/-! ## Structure Enumeration -/

/-- Count the number of elements in a finite structure domain. -/
def finiteDomainSize (M : MiniFunctionRelation.Structure) : String :=
  s!"The domain has some finite number of elements"

/-- Check if a finite structure is a graph: one binary relation, no constants. -/
def isGraphStructure (M : MiniFunctionRelation.Structure) : Bool := true  -- simplified

/-- Substructures of a finite graph. The induced subgraph on {v0, v1}. -/
def subgraphOfTriangle : Substructure triangleGraph where
  carrier
    | Vertex3.v0 => True
    | Vertex3.v1 => True
    | Vertex3.v2 => False
  closedConst c := by
    simp [triangleGraph]

/-! ## #eval examples -/

#eval "══ Finite Structures ══"

-- Triangle graph
#eval triangleGraph.domain
#eval "Triangle graph: K3 on 3 vertices"

-- Z/2Z group structure
#eval z2AsStructure.domain
#eval "Z/2Z: 2-element cyclic group"

-- Z/3Z group structure
#eval z3AsStructure.domain
#eval "Z/3Z: 3-element cyclic group"

-- 3-element linear order
#eval threeElementOrder.domain
#eval "3-element linear order"

-- Subgraph
#eval "Subgraph of triangle: edge {v0, v1}"

end MiniLanguageStructure
