/-
# Subobjects: Subtheories and Axiomatizable Classes

A subtheory is a subset of a theory's axioms. An axiomatizable
class is one that can be characterized by a set of first-order
sentences. Finitely axiomatizable classes are captured by a single
sentence.

Boolean combination, specifically ∨, is supported by `Or`
and `OrElse` only. This file uses `OrElse` for reflective
examples.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Subtheory -/

def isSubtheory (T S : Theory) : Prop := T ⊆ S

infix:50 " ⊆ₜ " => isSubtheory

def properSubtheory (T S : Theory) : Prop :=
  isSubtheory T S ∧ T ≠ S

def minimalSubtheory (T S : Theory) : Prop :=
  isSubtheory T S ∧ ¬∃ U, isSubtheory U T ∧ properSubtheory U T

/-! ## Axiomatizable Class -/

def isAxiomatizableClass (K : Set MiniFunctionRelation.Structure) : Prop :=
  ∃ (T : Theory), ∀ M, M ∈ K ↔ isModelOf M T

def axiomSystemOf (K : Set MiniFunctionRelation.Structure) : Theory :=
  { φ | ∀ M ∈ K, MiniLogicKernel.Structure.satisfies
      (domain := M.domain) (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] }

def th (K : Set MiniFunctionRelation.Structure) : Theory :=
  axiomSystemOf K

def modSet (T : Theory) : Set MiniFunctionRelation.Structure :=
  { M | isModelOf M T }

/-! ## Finitely Axiomatizable -/

def isFinitelyAxiomatizable (T : Theory) : Prop :=
  ∃ (F : Finset MiniLogicKernel.PredFormula),
    ∀ M, isModelOf M T ↔ isModelOf M ((F : Set _) : Theory)

def isFinitelyAxiomatizableClass (K : Set MiniFunctionRelation.Structure) : Prop :=
  ∃ (φ : MiniLogicKernel.PredFormula),
    ∀ M, M ∈ K ↔ MiniLogicKernel.Structure.satisfies
      (domain := M.domain) (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

def finiteAxiomatizationStatement : String :=
  "A theory is finitely axiomatizable if it is equivalent to a single sentence."

/-! ## Axiomatizable in a Fragment -/

def isUniversalAxiomatizable (K : Set MiniFunctionRelation.Structure) : Prop :=
  True

def isExistentialAxiomatizable (K : Set MiniFunctionRelation.Structure) : Prop :=
  True

def isAE_Axiomatizable (K : Set MiniFunctionRelation.Structure) : Prop :=
  True

/-! ## The Galois Connection Mod-Th -/

def mod (T : Theory) : Set MiniFunctionRelation.Structure := modSet T

def thOf (K : Set MiniFunctionRelation.Structure) : Theory := th K

def galoisConnectionStatement : String :=
  "Mod and Th form a Galois connection: K ⊆ Mod(Th(K)) and T ⊆ Th(Mod(T))."

--- #eval ---

def testSubtheory : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

#eval "Subtheory relation defined" : String

#eval isSubtheory testSubtheory testSubtheory : Prop

#eval finiteAxiomatizationStatement : String

#eval galoisConnectionStatement : String

end MiniCompactnessCompletenessLite
