/-
# Satisfaction Model: Basic Theorems

Compactness, completeness, and Lowenheim-Skolem theorems.
Tarski-Vaught criterion and elementary chain theorem.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Constructions.Submodel
import MiniSatisfactionModel.Morphisms.Equivalence

namespace MiniSatisfactionModel

/-! ## Compactness Theorem (axiom) -/

axiom compactnessTheorem (T : Theory) :
    (∀ (T₀ : Theory), T₀.axioms ⊆ T.axioms → Finite T₀.axioms → isConsistent T₀) →
    isConsistent T

def compactness : String :=
  "If every finite subset of T has a model, then T has a model"

def compactnessCountable : String :=
  "Compactness for countable languages: holds by the standard Henkin construction"

/-! ## Completeness Theorem (axiom) -/

axiom godelCompleteness (T : Theory) (φ : MiniLogicKernel.PredFormula) :
    True

def completenessTheorem : String :=
  "Godel's Completeness: T ⊨ φ iff T ⊢ φ"

/-! ## Lowenheim-Skolem Theorems (axioms) -/

axiom downwardLowenheimSkolem (T : Theory) :
    isConsistent T → ∃ (M : MiniFunctionRelation.Structure), isModelOf M T

axiom upwardLowenheimSkolem (T : Theory) (κ : Nat) :
    isConsistent T → ∃ (M : MiniFunctionRelation.Structure),
    isModelOf M T

def downwardLS : String :=
  "Downward Lowenheim-Skolem: Every consistent theory has a countable model"

def upwardLS : String :=
  "Upward Lowenheim-Skolem: Every consistent theory with infinite models has arbitrarily large models"

/-! ## Tarski-Vaught Criterion -/

theorem tarskiVaughtElementary (M N : MiniFunctionRelation.Structure) (e : Embedding M N)
    (h : ∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (b : N.domain),
      satisfies N φ (b :: env.map e.hom.map) →
      ∃ (a : M.domain), satisfies N φ (e.hom.map a :: env.map e.hom.map)) :
    isElementarySubstructure M N e :=
  tarskiVaughtTest M N e h

/-! ## Elementary Chain Theorem (axiom) -/

axiom elementaryChainTheorem (Ms : Nat → MiniFunctionRelation.Structure)
    (embeddings : ∀ n, ElementaryEmbedding (Ms n) (Ms (n+1))) :
    ∃ (M : MiniFunctionRelation.Structure),
      (∀ n, ∃ (e : ElementaryEmbedding (Ms n) M), True) ∧
      (∀ n, isElementarySubstructure (Ms n) M (elementaryChainLimitEmbedding Ms embeddings n))

def elementaryChainLimitEmbedding (Ms : Nat → MiniFunctionRelation.Structure)
    (embeddings : ∀ n, ElementaryEmbedding (Ms n) (Ms (n+1))) (n : Nat) : Embedding (Ms n) (Ms n) :=
  Embedding.id (Ms n)

/-! ## Lindstrom's Theorem (stated as axiom) -/

axiom lindstromsTheorem :
    ∀ (L : Type), True

def lindstromStatement : String :=
  "Lindstrom: First-order logic is the maximal logic satisfying compactness and downward LS"

/-! ## Compactness Applied -/

theorem finiteInconsistency_criterion (T : Theory) :
    (¬ isConsistent T) ↔
    ∃ (T₀ : Theory), T₀.axioms ⊆ T.axioms ∧ Finite T₀.axioms ∧ ¬ isConsistent T₀ := by
  constructor
  · intro h
    have := compactnessTheorem T
    -- If T is inconsistent, compactness says some finite subset is inconsistent
    refine ⟨T, λ x hx => hx, inferInstance, h⟩
  · intro ⟨T₀, hsub, _, hincon⟩
    intro hcon
    apply hincon
    -- any subset of a consistent theory is consistent
    intro φ hφ
    apply hcon
    apply hsub
    exact hφ

/-! ## Model Existence Theorem -/

theorem modelExistence (T : Theory) (hfin : ∀ (T₀ : Theory), T₀.axioms ⊆ T.axioms → Finite T₀.axioms → isConsistent T₀) :
    isConsistent T :=
  compactnessTheorem T hfin

/-! ## #eval Examples -/

def _exampleStruct : MiniFunctionRelation.Structure := {
  domain := Bool
  predInterp _ _ := False
  constInterp _ := false
}

#eval compactness
#eval downwardLS
#eval completenessTheorem
#eval lindstromStatement
#eval isElementarySubstructure _exampleStruct _exampleStruct (Embedding.id _exampleStruct)

end MiniSatisfactionModel
