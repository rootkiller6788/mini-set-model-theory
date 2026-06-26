/-
# MiniZFCLite: Properties — Structural

Absoluteness: Δ₀ formulas, Δ₁ formulas, and absoluteness
for transitive models of set theory.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Formula Classification -/

/-- Classification of formulas by quantifier complexity -/
inductive FormulaClass where
  | delta0   -- bounded quantifiers only
  | sigma1   -- ∃...Δ₀
  | pi1      -- ∀...Δ₀
  | delta1   -- both Σ₁ and Π₁
  | sigma_n (n : Nat)  -- Σ_n
  | pi_n (n : Nat)     -- Π_n
  deriving Repr, BEq

/-! ## Δ₀ Formulas -/

/-- Δ₀ (Σ₀ = Π₀) formulas: all quantifiers are bounded (∀x∈y or ∃x∈y) -/
structure Delta0Formula where
  description : String
  examples : List String
  properties : List String
  deriving Repr

/-- Definition of Δ₀ formulas -/
def deltaZeroDefinition : Delta0Formula :=
  { description := "Δ₀ formulas: all quantifiers are bounded (∀x∈y, ∃x∈y)"
    examples := [
      "x = y (Δ₀ via extensionality)",
      "x ⊆ y",
      "x is an ordered pair",
      "x is a function",
      "x is an ordinal",
      "x is a natural number"
    ]
    properties := [
      "Δ₀ formulas are absolute for transitive models",
      "Every Δ₀ property is preserved upward and downward"
    ] }

/-! ## Absoluteness for Transitive Models -/

/-- A property is absolute for transitive models if it holds in V
iff it holds in any transitive M containing the parameters -/
structure AbsolutenessResult where
  formulaClass : String
  modelClass : String
  holdsIn : String
  deriving Repr

/-- Δ₀ absoluteness for transitive models -/
def deltaZeroAbsoluteness : AbsolutenessResult :=
  { formulaClass := "Δ₀"
    modelClass := "transitive models"
    holdsIn := "M ⊨ φ(x̄) ↔ V ⊨ φ(x̄) for M transitive, x̄∈M" }

/-- Σ₁ formulas are upward absolute for transitive models -/
def sigmaOneUpwardAbsolute : AbsolutenessResult :=
  { formulaClass := "Σ₁"
    modelClass := "transitive models"
    holdsIn := "Upward absolute: M ⊨ φ → V ⊨ φ" }

/-- Π₁ formulas are downward absolute for transitive models -/
def piOneDownwardAbsolute : AbsolutenessResult :=
  { formulaClass := "Π₁"
    modelClass := "transitive models"
    holdsIn := "Downward absolute: V ⊨ φ → M ⊨ φ" }

/-- Δ₁ formulas are absolute for transitive models -/
def deltaOneAbsoluteness : AbsolutenessResult :=
  { formulaClass := "Δ₁"
    modelClass := "transitive models"
    holdsIn := "M ⊨ φ(x̄) ↔ V ⊨ φ(x̄) for M transitive, x̄∈M" }

/-! ## Shoenfield Absoluteness -/

/-- Σ₂¹ formulas are absolute between transitive models of ZF+DC -/
structure ShoenfieldAbsoluteness where
  formulaClass : String
  modelClass : String
  theorem : String
  deriving Repr

/-- Shoenfield's absoluteness theorem -/
def shoenfieldTheorem : ShoenfieldAbsoluteness :=
  { formulaClass := "Σ₂¹"
    modelClass := "transitive models of ZF + DC containing ω₁"
    theorem := "Any Σ₂¹ sentence true in V is also true in L" }

/-- Corollary: Σ₂¹ properties do not depend on large cardinals -/
def shoenfieldCorollary : String :=
  "If a Σ₂¹ sentence is consistent with ZFC, it's consistent with ZFC + V=L"

/-! ## Absolute Concepts -/

/-- Common set-theoretic concepts and their absolute status -/
structure AbsoluteConcept where
  concept : String
  formulaClass : String
  isAbsolute : Bool
  deriving Repr

/-- Being an ordinal is Δ₀ -/
def ordinalIsAbsolute : AbsoluteConcept :=
  { concept := "x is an ordinal"
    formulaClass := "Δ₀"
    isAbsolute := true }

/-- Being a cardinal is Π₁ -/
def cardinalIsPi1 : AbsoluteConcept :=
  { concept := "x is a cardinal"
    formulaClass := "Π₁"
    isAbsolute := true }

/-- The power set operation is not absolute -/
def powerSetNotAbsolute : AbsoluteConcept :=
  { concept := "y = P(x)"
    formulaClass := "Π₁"
    isAbsolute := false }

/-- Countability is not absolute -/
def countableNotAbsolute : AbsoluteConcept :=
  { concept := "x is countable"
    formulaClass := "Σ₁"
    isAbsolute := false }

/-! ## Absolute Operations -/

/-- Set-theoretic operations and their absoluteness -/
structure AbsoluteOperation where
  operation : String
  isAbsolute : Bool
  notes : String
  deriving Repr

/-- Ordered pair is absolute (Kuratowski) -/
def pairAbsolute : AbsoluteOperation :=
  { operation := "⟨x,y⟩", isAbsolute := true
    notes := "Kuratowski pair: {{x},{x,y}} is Δ₀" }

/-- Union is absolute -/
def unionAbsolute : AbsoluteOperation :=
  { operation := "⋃x", isAbsolute := true, notes := "Δ₀ definable" }

/-- Cartesian product is absolute -/
def productAbsolute : AbsoluteOperation :=
  { operation := "A×B", isAbsolute := true, notes := "Δ₀ from pairs and union" }

/-- The set of all functions is absolute -/
def functionSetAbsolute : AbsoluteOperation :=
  { operation := "B^A", isAbsolute := true, notes := "Δ₀ definable" }

/-! ## Absoluteness Hierarchy -/

/-- The absoluteness pyramid: Δ₀ ⊂ Δ₁ ⊂ ... ⊂ full ZF -/
def absolutenessHierarchy : List AbsoluteConcept := [
  ordinalIsAbsolute,
  cardinalIsPi1,
  powerSetNotAbsolute,
  countableNotAbsolute
]

/-! ## Evaluations -/

#eval deltaZeroAbsoluteness.holdsIn
#eval sigmaOneUpwardAbsolute.holdsIn
#eval shoenfieldTheorem.theorem
#eval ordinalIsAbsolute.isAbsolute
#eval powerSetNotAbsolute.isAbsolute
#eval absolutenessHierarchy.length

end MiniZFCLite
