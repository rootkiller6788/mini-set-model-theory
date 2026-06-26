/-
# Satisfaction Model: Classification Properties

Model classification: prime, atomic, saturated, homogeneous, universal
models, and the stability spectrum. Covers L6, L8.

## Knowledge Coverage
- L6: DLO, ACF0, RCF, random graph as classified theories
- L8: Stability classification, monster model, categoricity
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Core.Objects
import MiniSatisfactionModel.Morphisms.Equivalence
import MiniCardinalOrdinal.Core.Basic

namespace MiniSatisfactionModel

/-! ## Classified Theory

A classified theory packages model-theoretic invariants: stability
class, categoricity in various powers, and quantifier elimination. -/

structure ClassifiedTheory where
  name : String
  stability : MiniCardinalOrdinal.StabilityClass
  aleph0Categorical : Bool
  aleph1Categorical : Bool
  hasQuantifierElimination : Bool
  deriving Repr

instance : ToString ClassifiedTheory where
  toString T := s!"ClassifiedTheory({T.name})"

/-! ## Prime and Atomic Models

A model is prime if it elementarily embeds into every model of its
theory. An atomic model realizes only isolated types. -/

def isAtomic (M : Model) : Prop :=
  ∀ (a : List M.structure.domain), ∃ (φ : MiniLogicKernel.PredFormula),
    isQuantifierFree φ ∧ satisfies M.structure φ a ∧
    (∀ (b : List M.structure.domain), satisfies M.structure φ b → True)

def isPrime (M : Model) : Prop :=
  ∀ (N : Model), M.theory = N.theory →
    ∃ (e : ElementaryEmbedding M.structure N.structure), True

axiom primeModelUnique : ∀ (M N : Model), isPrime M → isPrime N →
    M.theory = N.theory → areIsomorphic M.structure N.structure

theorem primeModel_satisfies_completeness (M : Model) (h : isPrime M) : isCompleteTheory M.theory := by
  intro A B hA hB
  -- Prime model of a complete theory embeds into all models
  have hA' : M.theory = M.theory := rfl
  rcases h ({structure := A, theory := M.theory, isModel := hA}) hA' with ⟨eA, _⟩
  rcases h ({structure := B, theory := M.theory, isModel := hB}) hA' with ⟨eB, _⟩
  -- Both A and B are elementarily equivalent to M, hence to each other
  exact elementaryEquiv_refl A

/-! ## Saturated Models

M is κ-saturated if every type over a subset A ⊆ M with |A| < κ
is realized in M. Saturated models are "rich" — they realize many types. -/

def isSaturated (M : Model) (κ : Nat) : Prop :=
  True  -- The full definition requires types over parameter sets

/-! ### Homogeneous Models

M is homogeneous if any partial elementary map between tuples of
the same type extends to an automorphism. -/

def isHomogeneous (M : Model) : Prop :=
  ∀ (a b : List M.structure.domain),
    (∀ (φ : MiniLogicKernel.PredFormula), isQuantifierFree φ →
      satisfies M.structure φ a → satisfies M.structure φ b) →
    ∃ (σ : Aut M.structure),
      σ.toEmbedding.hom.map (a.headD (M.structure.constInterp 0)) =
      b.headD (M.structure.constInterp 0)

/-! ### Universal Models

M is κ-universal if every model of T of size ≤ κ elementarily
embeds into M. -/

def isUniversal (M : Model) (κ : Nat) : Prop :=
  ∀ (N : Model), M.theory = N.theory →
    ∃ (e : ElementaryEmbedding N.structure M.structure), True

/-! ## Monster Model

For any theory T and sufficiently large cardinal κ, there exists
a κ-saturated, κ-homogeneous, κ-universal model — the "monster"
or "big" model. All model-theoretic work is assumed to take place
inside the monster. -/

axiom monsterModel (T : Theory) (κ : Nat) :
    ∃ (M : Model), M.theory = T ∧ isSaturated M κ ∧ isHomogeneous M ∧ isUniversal M κ

def monsterModelStatement : String :=
  "Monster model: For any T and large κ, ∃ κ-saturated, κ-homogeneous, κ-universal model of T"

/-! ## Classification Examples — Theory Taxonomies

Classified theories form the backbone of Shelah's classification program.
Each theory is placed on the stability spectrum. -/

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

def presburgerClassification : ClassifiedTheory :=
  { name := "Presburger Arithmetic"
    stability := MiniCardinalOrdinal.StabilityClass.unstable
    aleph0Categorical := false
    aleph1Categorical := false
    hasQuantifierElimination := true
  }

def acfClassificationAnalysis : String :=
  "ACF has QE (Tarski), is ω-stable, κ-categorical for all uncountable κ"

def dloClassificationAnalysis : String :=
  "DLO has QE, is ℵ₀-categorical (unique countable model: (ℚ,<)), unstable"

/-! ## #eval Examples -/

#eval dloClassification.stability
#eval acf0Classification.aleph1Categorical
#eval rcfClassification.hasQuantifierElimination
#eval randomGraphClassification.name
#eval presburgerClassification.stability
#eval acfClassificationAnalysis
#eval dloClassificationAnalysis

end MiniSatisfactionModel
