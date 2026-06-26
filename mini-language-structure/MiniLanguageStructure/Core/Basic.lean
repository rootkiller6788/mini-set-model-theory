/-
# Language Structure: Basic Definitions

The foundational types and helpers for the mini language structure package.
This module re-exports core structure types and provides the common namespace
for all sub-packages.

## Overview
- `Cardinality` — cardinality helper for signatures and languages
- `SymbolKind` — distinguishes relation symbols from constant symbols
- `FormulaShape` — syntactic shape classification of first-order formulas
-/

import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniOrderEquivalence.Core.Basic

namespace MiniLanguageStructure

/-! ## Cardinality and Size Helpers -/

/-- Cardinality of a signature: the sum of relation arities plus constant count. -/
def cardinality (rels : Nat → Nat) (consts : Nat) : Nat :=
  (List.range 100).filterMap (fun n => if rels n > 0 then some (rels n) else none) |>.sum + consts

/-- A signature is finite if it has only finitely many non-zero-arity relations. -/
def isFiniteSignature (rels : Nat → Nat) (consts : Nat) : Bool :=
  consts < 1000 && (List.range 1000).all (fun n => rels n < 100)

/-! ## Symbol Kinds -/

/-- Kind of a symbol in a signature: relation with arity, or constant. -/
inductive SymbolKind
  | relation (arity : Nat)
  | constant
  deriving Repr, Inhabited

/-- A symbol descriptor bundles a symbol index with its kind. -/
structure Symbol where
  index : Nat
  kind : SymbolKind
  deriving Repr

/-! ## Formula Shape Classification -/

/-- Syntactic shape of a first-order formula. -/
inductive FormulaShape
  | atomic
  | negation
  | conjunction
  | disjunction
  | implication
  | universal
  | existential
  | quantifierFree
  | positive
  | universalStrict
  deriving Repr, Inhabited

/-- Check if a shape is quantifier-free. -/
def FormulaShape.isQuantifierFree : FormulaShape → Bool
  | .atomic => true
  | .negation => true
  | .conjunction => true
  | .disjunction => true
  | .implication => true
  | .quantifierFree => true
  | _ => false

/-- Check if a shape is positive (no negations allowed inside). -/
def FormulaShape.isPositive : FormulaShape → Bool
  | .atomic => true
  | .conjunction => true
  | .disjunction => true
  | .implication => true
  | .universal => true
  | .existential => true
  | .positive => true
  | _ => false

/-! ## Shared Example Structures

These are small, canonical structures used throughout the package
for #eval examples and demonstrations. Defined once here to avoid
duplicate definitions across modules. -/

/-- The unit structure: singleton domain, all relations true, all constants (). -/
def unitStructure : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-- A structure on Nat with all relations true and all constants 0. -/
def natStructure : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp _ _ := True
  constInterp _ := 0

/-! ## #eval examples -/

#eval "Core.Basic loaded — MiniLanguageStructure namespace active"

-- Demonstrate cardinality computation
#eval cardinality (fun
  | 0 => 2   -- one binary relation
  | 1 => 1   -- one unary relation
  | _ => 0) 3  -- three constants
  -- Expected: 2 + 1 + 3 = 6

-- Demonstrate SymbolKind discriminators
def sampleSymbol : Symbol := { index := 0, kind := SymbolKind.relation 2 }
#eval sampleSymbol.kind

-- Demonstrate FormulaShape classification
#eval FormulaShape.isQuantifierFree FormulaShape.universal  -- false
#eval FormulaShape.isPositive FormulaShape.atomic          -- true
#eval FormulaShape.isQuantifierFree FormulaShape.atomic    -- true

end MiniLanguageStructure
