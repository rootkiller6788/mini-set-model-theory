/-
# Core Objects: Theories and Semantic Notions

A `Theory` is a set of first-order sentences. This file defines
satisfiability, finite satisfiability, logical validity, and
logical consequence -- the fundamental semantic notions of model theory.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniLogicKernel.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Theory Type and Basic Operations -/

def Theory := Set MiniLogicKernel.PredFormula

def emptyTheory : Theory := ∅

def theoryUnion (T₁ T₂ : Theory) : Theory := T₁ ∪ T₂

def theoryInter (T₁ T₂ : Theory) : Theory := T₁ ∩ T₂

def theorySingleton (φ : MiniLogicKernel.PredFormula) : Theory := {φ}

def theoryInsert (T : Theory) (φ : MiniLogicKernel.PredFormula) : Theory := T ∪ {φ}

/-! ## Models and Satisfiability -/

def theoryModels (T : Theory) : Set (MiniFunctionRelation.Structure) :=
  { M | ∀ φ ∈ T, MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] }

def hasModel (T : Theory) : Prop := ∃ M, ∀ φ ∈ T,
  MiniLogicKernel.Structure.satisfies (domain := M.domain)
    (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

def satisfiable (T : Theory) : Prop := hasModel T

def unsatisfiable (T : Theory) : Prop := ¬ satisfiable T

def isModelOf (M : MiniFunctionRelation.Structure) (T : Theory) : Prop :=
  ∀ φ ∈ T, MiniLogicKernel.Structure.satisfies (domain := M.domain)
    (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

/-! ## Finite Satisfiability -/

def finitelySatisfiable (T : Theory) : Prop :=
  ∀ (T₀ : Finset MiniLogicKernel.PredFormula), (T₀ : Set _) ⊆ T → satisfiable (T₀ : Set _)

/-! ## Logical Validity -/

def logicallyValid (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure),
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

def logicallyEquivalent (φ ψ : MiniLogicKernel.PredFormula) : Prop :=
  logicallyValid (MiniLogicKernel.PredFormula.equiv φ ψ)

def logicallyImplies (φ ψ : MiniLogicKernel.PredFormula) : Prop :=
  logicallyValid (MiniLogicKernel.PredFormula.impl φ ψ)

/-! ## Logical Consequence -/

def logicalConsequence (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ M, isModelOf M T →
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

infix:50 " ⊨ " => logicalConsequence

def isConsistent (T : Theory) : Prop := satisfiable T

def isInconsistent (T : Theory) : Prop := ¬ isConsistent T

/-! ## Finite Subtheory Operations -/

def allFiniteSubtheories (T : Theory) : Set Theory :=
  { T₀ | ∃ (F : Finset MiniLogicKernel.PredFormula), (T₀ = (F : Set _)) ∧ (F : Set _) ⊆ T }

--- #eval ---

def testTheory : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

#eval "Theory type defined" : String

#eval "satisfiable: a theory has at least one model" : String

#eval "finitelySatisfiable: every finite subtheory has a model" : String

end MiniCompactnessCompletenessLite
