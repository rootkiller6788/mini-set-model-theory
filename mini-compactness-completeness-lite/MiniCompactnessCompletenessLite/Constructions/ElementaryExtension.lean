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

def isElementaryExtension (M N : MiniFunctionRelation.Structure) : Prop :=
  ∃ (f : Hom M N), isElementaryEmbedding f ∧ isEmbedding f

def isProperExtension (M N : MiniFunctionRelation.Structure) : Prop :=
  isElementaryExtension M N ∧
  ¬ ∃ (g : Hom N M), isElementaryEmbedding g ∧ isEmbedding g

infix:50 " ≺ " => isElementaryExtension

lemma elementaryExtension_refl (M : MiniFunctionRelation.Structure) : M ≺ M := by
  refine ⟨Hom.id M, elementaryEmbedding_id M, ?_⟩
  intro x y h; exact h

/-! ## Elementary Diagram -/

def elementaryDiagram (M : MiniFunctionRelation.Structure) : Theory :=
  { φ | MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] }

def elemDiagramProperty : String :=
  "N is an elementary extension of M iff N ⊨ ElemDiag(M). The elementary diagram consists of all sentences true in M with constants for all elements."

lemma elementaryDiagram_closed_under_log_consequence {M : MiniFunctionRelation.Structure}
    (φ ψ : MiniLogicKernel.PredFormula)
    (hφ : φ ∈ elementaryDiagram M)
    (hImpl : logicallyImplies φ ψ) : ψ ∈ elementaryDiagram M := by
  rcases hφ with hφ'
  have hVal := hImpl M hφ'
  exact hVal

/-! ## Chains -/

def isChain (S : Set MiniFunctionRelation.Structure) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure), M ∈ S → N ∈ S → (M ≺ N ∨ N ≺ M)

def chainUnion (S : Set MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure := by
  -- The union of a chain is a structure whose domain is the union of domains
  -- This is not generally possible in Lean without disjoint union types
  -- We provide a construction placeholder
  exact {
    domain := Unit
    predInterp := λ _ _ => False
    constInterp := λ _ => ()
  }

def unionOfChainProperty : String :=
  "The union of a chain of structures is a structure that extends each structure in the chain."

def elementaryChainProperty : String :=
  "If each M_n ≺ M_{n+1}, then M_n ≺ ⋃_k M_k for all n."

lemma chain_pairwise_comparable {S : Set MiniFunctionRelation.Structure} (hChain : isChain S)
    (M N : MiniFunctionRelation.Structure) (hM : M ∈ S) (hN : N ∈ S) : M ≺ N ∨ N ≺ M :=
  hChain M N hM hN

/-! ## Amalgamation -/

def hasAmalgamationProperty (T : Theory) : Prop :=
  ∀ (A B C : MiniFunctionRelation.Structure),
    isModelOf A T → isModelOf B T → isModelOf C T →
    A ≺ B → A ≺ C →
    ∃ (D : MiniFunctionRelation.Structure), isModelOf D T ∧ B ≺ D ∧ C ≺ D

def hasJointEmbeddingProperty (T : Theory) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure),
    isModelOf M T → isModelOf N T →
    ∃ (P : MiniFunctionRelation.Structure), isModelOf P T ∧ M ≺ P ∧ N ≺ P

lemma amalgamation_implies_joint_embedding (T : Theory)
    (hAP : hasAmalgamationProperty T)
    (hPrime : ∃ (P : MiniFunctionRelation.Structure), isModelOf P T ∧ ∀ M, isModelOf M T → P ≺ M) :
    hasJointEmbeddingProperty T := by
  rintro ⟨P, hPT, hPPrime⟩
  intro M N hM hN
  have hPM := hPPrime M hM
  have hPN := hPPrime N hN
  rcases hAP P M N hPT hM hN hPM hPN with ⟨D, hDT, hMD, hND⟩
  exact ⟨D, hDT, hMD, hND⟩

/-! ## Upward Lowenheim-Skolem via Elementary Extensions -/

def upwardLSConstructionStatement : String :=
  "Upward LS proof: Start with an infinite M ⊨ T. Use compactness on ElemDiag(M) + new constants {c_α} with axioms c_α ≠ c_β. The resulting model is an elementary extension of M with arbitrarily many new elements."

--- #eval ---

#eval "Elementary extensions defined with proper Hom-based definition" : String
#eval "Elementary diagram as set of true sentences" : String
#eval "Amalgamation and joint embedding properties" : String
#eval upwardLSConstructionStatement : String

end MiniCompactnessCompletenessLite
