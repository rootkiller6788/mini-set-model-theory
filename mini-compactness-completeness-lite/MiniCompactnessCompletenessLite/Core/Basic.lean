/-
# Compactness Completeness Lite: Core Basic

Compactness, Completeness, Lowenheim-Skolem, Shelah Main Gap,
and the classification program.

This module imports the core dependencies and defines the
basic types and infrastructure needed by all other modules.

## Dependencies
- `MiniFunctionRelation.Core.Basic`: Structure type and related definitions
- `MiniLogicKernel.Core.Objects`: PredFormula type with satisfaction relation
- `MiniCardinalOrdinal.Core.Basic`: Stability classes and cardinality concepts
- `MiniSatisfactionModel.Properties.Classification`: Pre-built classification data
-/

import MiniFunctionRelation.Core.Basic
import MiniLogicKernel.Core.Objects
import MiniCardinalOrdinal.Core.Basic
import MiniSatisfactionModel.Properties.Classification

namespace MiniCompactnessCompletenessLite

/-! ## Re-exported definitions for convenience -/

abbrev Structure := MiniFunctionRelation.Structure
abbrev PredFormula := MiniLogicKernel.PredFormula
abbrev Formula := MiniLogicKernel.Formula
abbrev StabilityClass := MiniCardinalOrdinal.StabilityClass
abbrev ClassifiedTheory := MiniSatisfactionModel.ClassifiedTheory

/-! ## Core Module Metadata -/

def moduleName : String := "MiniCompactnessCompletenessLite"

def moduleVersion : String := "1.0.0"

def moduleDescription : String :=
  "Formalization of compactness, completeness, Lowenheim-Skolem theorems, and the Shelah classification program for first-order model theory."

def moduleAuthors : List String := ["Model Theory group"]

def moduleKeywords : List String :=
  ["model theory", "compactness", "completeness", "Lowenheim-Skolem", "stability", "classification", "Shelah", "Morley", "Baldwin-Lachlan"]

/-! ## Quick Reference: Key Concepts -/

def coreConcepts : List String := [
  "Theory (Set of sentences)",
  "Model (Structure satisfying a theory)",
  "Satisfiability (∃ model)",
  "Finite satisfiability (every finite subset satisfiable)",
  "Compactness (finitely satisfiable ⟹ satisfiable)",
  "Completeness (semantic conseq. ⟹ syntactic provability)",
  "Downward LS (countable elementary substructures)",
  "Upward LS (arbitrarily large elementary extensions)",
  "Stability classification (stable, superstable, ω-stable)",
  "Categoricity (all models of a given size are isomorphic)"
]

def coreTheorems : List String := [
  "Compactness Theorem (Godel 1930, Malcev 1936)",
  "Completeness Theorem (Godel 1930)",
  "Downward Lowenheim-Skolem Theorem",
  "Upward Lowenheim-Skolem Theorem",
  "Lindstrom's Theorem (FOL maximality)",
  "Craig Interpolation Theorem",
  "Beth Definability Theorem",
  "Los-Tarski Preservation Theorem",
  "Morley's Categoricity Theorem (1965)",
  "Baldwin-Lachlan Theorem (1971)",
  "Shelah's Main Gap Theorem (1985)",
  "Zilber's Trichotomy Conjecture"
]

def classificationSpectrum : List String := [
  "unstable (maximal number of models)",
  "stable (bounded number of types)",
  "superstable (stable + no infinite forking chains)",
  "ω-stable (countable type spaces over countable sets)",
  "totally transcendental (finite Morley rank everywhere)"
]

/-! ## Quick Structure Reference -/

def structureFields : List String := [
  "domain : Type — the underlying set",
  "predInterp : Nat → List domain → Prop — predicate interpretation",
  "constInterp : Nat → domain — constant interpretation"
]

def theoryOperations : List String := [
  "emptyTheory — ∅ (the empty theory, satisfiable by everything)",
  "theoryUnion — T₁ ∪ T₂",
  "theoryInter — T₁ ∩ T₂",
  "theorySingleton φ — {φ}",
  "theoryInsert T φ — T ∪ {φ}",
  "theoryRemove T φ — T \\ {φ}"
]

--- #eval ---

#eval moduleName : String
#eval moduleVersion : String
#eval coreConcepts.length : Nat
#eval coreTheorems.length : Nat
#eval classificationSpectrum : List String

end MiniCompactnessCompletenessLite
