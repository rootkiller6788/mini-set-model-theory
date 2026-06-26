/-
# Step-by-Step Examples — MiniLanguageStructure

Building structures, substructures, products, and quotients.
-/

import MiniLanguageStructure

open MiniLanguageStructure

#eval "══ BUILDING FIRST-ORDER STRUCTURES ══"

/-! ### Step 1: Define a simple structure (a graph with 2 vertices) -/

inductive TwoVertex : Type
  | a | b
  deriving Repr

def twoVertexGraph : MiniFunctionRelation.Structure where
  domain := TwoVertex
  predInterp p args :=
    if p = 0 then
      -- edge relation: a ~~ b
      args = [TwoVertex.a, TwoVertex.b]
    else False
  constInterp _ := TwoVertex.a

#eval "Two-vertex graph structure defined"

/-! ### Step 2: Define a substructure (single vertex) -/

def singleVertexSub : Substructure twoVertexGraph where
  carrier
    | TwoVertex.a => True
    | TwoVertex.b => False
  closedConst _ := trivial
  closedPred _ _ h := by
    -- No edge inside the substructure, so this is vacuously true
    simp [twoVertexGraph] at h

#eval "Single-vertex substructure defined"

/-! ### Step 3: Build a product structure -/

def prodGraph : MiniFunctionRelation.Structure :=
  productStructure twoVertexGraph twoVertexGraph

#eval "Product graph defined (4 vertices)"

/-! ### Step 4: Construct algebraic structure -/

def trivialGroup : AlgebraicStructure where
  carrier := Unit
  operations := [fun _ () => (), fun _ () => ()]
  name := "TrivialGroup"

#eval trivialGroup.name

#eval "══ STRUCTURE BUILDING COMPLETE ══"
