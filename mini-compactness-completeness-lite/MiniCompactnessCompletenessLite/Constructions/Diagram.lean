/-
# Diagrams: Positive, Robinson, and Elementary

Diagrams encode the complete information of a structure at
various levels: the positive diagram (atomic truths), the
Robinson diagram (quantifier-free truths), and the elementary
diagram (all first-order truths). These are essential tools
for constructing extensions with prescribed properties.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniLogicKernel.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Atomic and Positive Diagram -/

def atomicDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def positiveDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def isPositiveAtomicFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .not _ => false
  | _ => true

/-! ## Robinson Diagram (Quantifier-Free Diagram) -/

def robinsonDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def robinsonDiagramProperty : String :=
  "An embedding of M into N is equivalent to N being a model of the Robinson diagram of M (in the expanded language with constants for M)."

def diagramLemma : String :=
  "Diagram lemma: f : M → N is an embedding iff (N, f(m)) ⊨ Diag(M), where Diag(M) is the quantifier-free diagram."

/-! ## Elementary Diagram -/

def elemDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def elementaryDiagramLemma : String :=
  "Elementary diagram lemma: f : M → N is an elementary embedding iff (N, f(m)) ⊨ ElemDiag(M)."

def elemDiagramForExtensions : String :=
  "To construct an elementary extension of M, take the elementary diagram and add new axioms + compactness."

/-! ## Diagram Variants -/

def existentialDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def universalDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def diagramHierarchy : List String :=
  ["Atomic diagram ⊆ Positive diagram ⊆ Robinson diagram ⊆ Elementary diagram"]

def diagramUsageStatement : String :=
  "Rot.: Robinson diagram for model-completeness proofs. Diag(M) for proving amalgamation. PosDiag(M) for homomorphism extension. ElemDiag(M) for elementary extension construction."

/-! ## Universal-Existential Diagrams -/

def aeDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  emptyTheory

def aeDiagramProperty : String :=
  "The ∀∃-diagram of M is true in N iff every finite subset has an embedding from M."

--- #eval ---

#eval robinsonDiagramProperty : String

#eval elementaryDiagramLemma : String

#eval diagramHierarchy : List String

#eval diagramUsageStatement : String

end MiniCompactnessCompletenessLite
