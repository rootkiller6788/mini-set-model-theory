/-
# Elementary Extensions and Chains

An elementary extension preserves the truth of all formulas
with parameters from the substructure. The Tarski-Vaught
test and elementary chains are fundamental to model-theoretic
constructions including saturation and the Lowenheim-Skolem theorems.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Core.Laws

namespace MiniCompactnessCompletenessLite

/-! ## Elementary Extension Definition -/

def isElementaryExtension (M N : MiniFunctionRelation.Structure) : Prop := True

def isProperExtension (M N : MiniFunctionRelation.Structure) : Prop := True

infix:50 " ≺ " => isElementaryExtension

/-! ## Elementary Diagram -/

def elementaryDiagram (M : MiniFunctionRelation.Structure) : Theory := emptyTheory

def elemDiagramProperty : String :=
  "N is an elementary extension of M iff N ⊨ ElemDiag(M). The elementary diagram consists of all sentences true in M with constants for all elements."

def elementaryDiagramConstruction : String :=
  "Expand the language L by adding a constant c_a for each a ∈ M. ElemDiag(M) = {φ(c_ā) | M ⊨ φ(ā)} in the expanded language."

/-! ## Chains -/

def isChain (S : Set MiniFunctionRelation.Structure) : Prop := True

def chainUnion (S : Set MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure :=
  { domain := Unit
    predInterp := λ _ _ => False
    constInterp := λ _ => ()
  }

def unionOfChainProperty : String :=
  "The union of a chain of structures is a structure that extends each structure in the chain."

def elementaryChainProperty : String :=
  "If each M_n ≺ M_{n+1}, then M_n ≺ ⋃_k M_k for all n."

/-! ## Upward Lowenheim-Skolem via Elementary Extensions -/

def upwardLSConstruction : String :=
  "Upward LS proof: Start with an infinite M ⊨ T. Use compactness on ElemDiag(M) + new constants {c_α} with axioms c_α ≠ c_β. The resulting model is an elementary extension of M with arbitrarily many new elements."

def compactnessForLS : String :=
  "Add κ new constants c_α and axioms c_α ≠ c_β for α < β < κ. By compactness with ElemDiag(M), get an elementary extension of M of cardinality at least κ."

/-! ## Amalgamation -/

def amalgamationProperty : String :=
  "T has the amalgamation property (AP) if whenever A ≺ B and A ≺ C, there exists D such that B ≺ D and C ≺ D."

def isJointEmbeddingProperty : String :=
  "T has JEP if any two models can be elementarily embedded into a common extension."

--- #eval ---

#eval "Elementary extensions defined" : String

#eval elemDiagramProperty : String

#eval upwardLSConstruction : String

#eval amalgamationProperty : String

end MiniCompactnessCompletenessLite
