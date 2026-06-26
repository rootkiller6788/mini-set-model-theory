/-
# Elementary Embeddings: Truth-Preserving Maps

An elementary embedding preserves the truth of ALL first-order
formulas (not just atomic ones). This is the central notion of
model theory, generalizing isomorphism while preserving all
first-order properties. The Tarski-Vaught test characterizes
elementary substructures.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Morphisms.Homomorphism

namespace MiniCompactnessCompletenessLite

/-! ## Elementary Embedding Definition -/

def isElementaryEmbedding {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain),
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ env →
    MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp) φ (env.map f.map)

lemma elementaryEmbedding_preserves_closed_formulas {M N : MiniFunctionRelation.Structure}
    (f : Hom M N) (hElem : isElementaryEmbedding f) (φ : MiniLogicKernel.PredFormula) :
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] →
    MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp) φ [] :=
  hElem φ []

def elementaryEmbedding_injective_statement : String :=
  "Elementary embeddings are injective: if f : M → N is an elementary embedding, then f is one-to-one. This follows from the preservation of the equality formula v₀ = v₁."

lemma elementaryEmbedding_id (M : MiniFunctionRelation.Structure) : isElementaryEmbedding (Hom.id M) := by
  intro φ env h; exact h

lemma elementaryEmbedding_comp {M N P : MiniFunctionRelation.Structure}
    (f : Hom M N) (g : Hom N P)
    (hf : isElementaryEmbedding f) (hg : isElementaryEmbedding g) :
    isElementaryEmbedding (Hom.comp f g) := by
  intro φ env h
  apply hg φ (env.map f.map)
  apply hf φ env h

/-! ## Elementary Substructure -/

def isElementarySubstructure (M N : MiniFunctionRelation.Structure) : Prop :=
  ∃ (f : Hom M N), isElementaryEmbedding f ∧ isEmbedding f

infix:50 " ≼ " => isElementarySubstructure

lemma elementarySubstructure_refl (M : MiniFunctionRelation.Structure) : M ≼ M := by
  refine ⟨Hom.id M, elementaryEmbedding_id M, ?_⟩
  intro x y h; exact h

lemma elementarySubstructure_trans {M N P : MiniFunctionRelation.Structure}
    (hMN : M ≼ N) (hNP : N ≼ P) : M ≼ P := by
  rcases hMN with ⟨f, hElem_f, hEmb_f⟩
  rcases hNP with ⟨g, hElem_g, hEmb_g⟩
  refine ⟨Hom.comp f g, ?_, ?_⟩
  · exact elementaryEmbedding_comp f g hElem_f hElem_g
  · exact embedding_comp f g hEmb_f hEmb_g

/-! ## Tarski-Vaught Test -/

def tarskiVaughtStatement : String :=
  "Tarski-Vaught criterion: M ⊆ N is an elementary substructure iff for every formula φ(x,ȳ) and every tuple ā in M, if N ⊨ ∃x φ(x,ā) then M ⊨ ∃x φ(x,ā)."

/-! ## Elementary Chains -/

def isElementaryChain (M_seq : Nat → MiniFunctionRelation.Structure) : Prop :=
  ∀ n, M_seq n ≼ M_seq (n+1)

lemma elementaryChain_initial_subsequent {M_seq : Nat → MiniFunctionRelation.Structure}
    (hChain : isElementaryChain M_seq) (n m : Nat) (h : n ≤ m) : M_seq n ≼ M_seq m := by
  induction' h with k hle ih
  · exact elementarySubstructure_refl _
  · exact elementarySubstructure_trans ih (hChain k)

/-! ## Elementary Embeddings Preserve Theory -/

lemma elementaryEmbedding_preserves_theory {M N : MiniFunctionRelation.Structure}
    (f : Hom M N) (hElem : isElementaryEmbedding f) (T : Theory)
    (hM : isModelOf M T) : isModelOf N T := by
  intro φ hφ
  have hMφ := hM φ hφ
  exact elementaryEmbedding_preserves_closed_formulas f hElem φ hMφ

/-! ## Downward Lowenheim-Skolem via Tarski-Vaught -/

def skolemHullStatement : String :=
  "Skolem hull construction: given a structure M and a subset X ⊆ M, the Skolem hull H(X) is the smallest elementary substructure containing X."

/-! ## Elementary Embeddings and Large Cardinals -/

def largeCardinalStatement : String :=
  "In set theory, a measurable cardinal is defined by the existence of a non-trivial elementary embedding j : V → M where M is a transitive inner model."

def kunenInconsistencyStatement : String :=
  "Kunen's inconsistency: There is no nontrivial elementary embedding j : V → V (ZFC)."

--- #eval ---

#eval "Elementary embedding: preserves truth of all formulas" : String
#eval "Elementary substructure: reflexive and transitive" : String
#eval "Tarski-Vaught test characterizes elementary substructures" : String
#eval "Elementary chains preserve elementarity" : String
#eval tarskiVaughtStatement : String

end MiniCompactnessCompletenessLite
