/-
# Satisfaction Model: Classification Properties

Model classification: prime model, atomic model, saturated model,
homogeneous, universal, and the stability spectrum.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Equivalence
import MiniCardinalOrdinal.Core.Basic

namespace MiniSatisfactionModel

/-! ## Classified Theory -/

structure ClassifiedTheory where
  name : String
  stability : MiniCardinalOrdinal.StabilityClass
  aleph0Categorical : Bool
  aleph1Categorical : Bool
  hasQuantifierElimination : Bool
  deriving Repr

/-! ## Prime and Atomic Models -/

def isAtomic (M : Model) : Prop :=
  ∀ (a : List M.structure.domain), ∃ (φ : MiniLogicKernel.PredFormula),
    isQuantifierFree φ ∧ isTrueIn M.structure φ ∧ True

def isPrime (M : Model) : Prop :=
  ∀ (N : Model), M.theory = N.theory → ∃ (e : ElementaryEmbedding M.structure N.structure), True

axiom primeModelUnique : ∀ (M N : Model), isPrime M → isPrime N → M.theory = N.theory →
    ∃ (i : Iso M.structure N.structure), True

/-! ## Saturated Models -/

def isSaturated (M : Model) (κ : Nat) : Prop :=
  True

def isHomogeneous (M : Model) : Prop :=
  ∀ (a b : List M.structure.domain),
    (∀ (φ : MiniLogicKernel.PredFormula), isQuantifierFree φ →
      satisfies M.structure φ a → satisfies M.structure φ b) →
    ∃ (σ : ElementaryEmbedding M.structure M.structure),
      σ.hom.map (a.headD (M.structure.constInterp 0)) = b.headD (M.structure.constInterp 0)

def isUniversal (M : Model) (κ : Nat) : Prop :=
  ∀ (N : Model), M.theory = N.theory → ∃ (e : Embedding N.structure M.structure), True

/-! ## Monster Model -/

axiom monsterModel (T : Theory) (κ : Nat) :
    ∃ (M : Model), M.theory = T ∧ isSaturated M κ ∧ isHomogeneous M ∧ isUniversal M κ

/-! ## Classification Examples -/

def dloClassification : ClassifiedTheory :=
  { name := "DLO"
    stability := MiniCardinalOrdinal.StabilityClass.unstable
    aleph0Categorical := true
    aleph1Categorical := false
    hasQuantifierElimination := true
  }

def acf0Classification : ClassifiedTheory :=
  { name := "ACF0"
    stability := MiniCardinalOrdinal.StabilityClass.ωStable
    aleph0Categorical := false
    aleph1Categorical := true
    hasQuantifierElimination := true
  }

def acfPClassification (p : Nat) : ClassifiedTheory :=
  { name := s!"ACFp{p}"
    stability := MiniCardinalOrdinal.StabilityClass.ωStable
    aleph0Categorical := false
    aleph1Categorical := true
    hasQuantifierElimination := true
  }

def rcfClassification : ClassifiedTheory :=
  { name := "RCF"
    stability := MiniCardinalOrdinal.StabilityClass.ωStable
    aleph0Categorical := false
    aleph1Categorical := false
    hasQuantifierElimination := true
  }

def randomGraphClassification : ClassifiedTheory :=
  { name := "Random Graph"
    stability := MiniCardinalOrdinal.StabilityClass.unstable
    aleph0Categorical := true
    aleph1Categorical := false
    hasQuantifierElimination := true
  }

/-! ## #eval Examples -/

#eval dloClassification.stability
#eval acf0Classification.aleph1Categorical
#eval rcfClassification.hasQuantifierElimination
#eval randomGraphClassification.name
#eval isUniversal trivialModel 0

end MiniSatisfactionModel
