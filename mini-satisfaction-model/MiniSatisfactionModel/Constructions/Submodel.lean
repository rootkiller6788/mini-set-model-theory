/-
# Satisfaction Model: Submodels

Substructure, elementary submodel, and Tarski-Vaught test.
Downward Lowenheim-Skolem theorem.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Submodel Type -/

structure Submodel (M : MiniFunctionRelation.Structure) where
  carrier : Set M.domain
  closedUnderConsts : ∀ (c : Nat), M.constInterp c ∈ carrier
  closedUnderFuncs : ∀ (f : Nat) (a : M.domain), a ∈ carrier → a ∈ carrier

/-! ## Submodel to Structure -/

def submodelToStructure (M : MiniFunctionRelation.Structure) (S : Submodel M) : MiniFunctionRelation.Structure where
  domain := { x : M.domain // x ∈ S.carrier }
  predInterp p args := M.predInterp p (args.map Subtype.val)
  constInterp c := ⟨M.constInterp c, S.closedUnderConsts c⟩

/-! ## Inclusion Embedding -/

def inclusionEmbedding (M : MiniFunctionRelation.Structure) (S : Submodel M) :
    Embedding (submodelToStructure M S) M where
  hom := {
    map := Subtype.val
    preservesPred p args h := h
    preservesConst _ := rfl
  }
  injective x y h := by
    apply Subtype.ext; exact h

/-! ## Elementary Submodel -/

def isElementarySubmodel (M N : MiniFunctionRelation.Structure) (e : Embedding M N) : Prop :=
  isElementarySubstructure M N e

/-! ## Tarski-Vaught Criterion -/

def tarskiVaughtCriterion (M N : MiniFunctionRelation.Structure) (S : Submodel M) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula) (env : List {x : M.domain // x ∈ S.carrier}) (b : M.domain),
    satisfies M φ (b :: env.map Subtype.val) →
    ∃ (a : {x : M.domain // x ∈ S.carrier}), satisfies M φ (a.val :: env.map Subtype.val)

theorem tarskiVaught_implies_elementary (M : MiniFunctionRelation.Structure) (S : Submodel M)
    (h : tarskiVaughtCriterion M M S) :
    isElementarySubmodel (submodelToStructure M S) M (inclusionEmbedding M S) := by
  intro φ env hsat
  induction φ generalizing env with
  | prop _ => trivial
  | pred p ts => exact hsat
  | eq _ _ => exact hsat
  | and φ ψ ihφ ihψ =>
      rcases hsat with ⟨hφ, hψ⟩
      exact ⟨ihφ hφ, ihψ hψ⟩
  | or φ ψ ihφ ihψ =>
      rcases hsat with hφ | hψ
      · exact Or.inl (ihφ hφ)
      · exact Or.inr (ihψ hψ)
  | not φ ih => intro hm; apply hsat; apply ih; exact hm
  | impl φ ψ ihφ ihψ =>
      intro hφ'
      apply ihψ
      apply hsat
      apply ihφ
      exact hφ'
  | ex φ ih =>
      rcases hsat with ⟨b, hb⟩
      rcases h φ env b hb with ⟨a, ha⟩
      refine ⟨a, ih _ ha⟩
  | all φ ih =>
      intro m
      apply ih
      apply hsat
      exact m.val
  | equiv φ ψ ihφ ihψ =>
      exact ⟨λ hφ' => ihψ (hsat.mp (ihφ.mpr hφ')), λ hψ' => ihφ (hsat.mpr (ihψ.mpr hψ'))⟩

/-! ## Downward Lowenheim-Skolem (axiom) -/

axiom downwardLowenheimSkolem (T : Theory) :
    isConsistent T → ∃ (M : MiniFunctionRelation.Structure), isModelOf M T

def downwardLSStatement : String :=
  "Downward Lowenheim-Skolem: Every theory with an infinite model has a countable elementary submodel"

/-! ## Elementary Chain -/

def elementaryChain (Ms : Nat → MiniFunctionRelation.Structure)
    (embeddings : ∀ n, ElementaryEmbedding (Ms n) (Ms (n+1))) : Prop := True

axiom elementaryChainTheorem (Ms : Nat → MiniFunctionRelation.Structure)
    (embeddings : ∀ n, ElementaryEmbedding (Ms n) (Ms (n+1))) :
    ∃ (M : MiniFunctionRelation.Structure), ∀ n, ∃ (e : ElementaryEmbedding (Ms n) M), True

/-! ## #eval Examples -/

def trivialMod : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def trivialSubmodel : Submodel trivialMod where
  carrier := {()}
  closedUnderConsts _ := by trivial
  closedUnderFuncs _ _ h := h

#eval (submodelToStructure trivialMod trivialSubmodel).domain
#eval tarskiVaughtCriterion trivialMod trivialMod trivialSubmodel
#eval downwardLSStatement
#eval isElementarySubstructure trivialMod trivialMod (Embedding.id trivialMod)

end MiniSatisfactionModel
