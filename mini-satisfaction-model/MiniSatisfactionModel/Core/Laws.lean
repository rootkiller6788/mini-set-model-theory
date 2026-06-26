/-
# Satisfaction Model: Satisfaction Laws

Tarski's definition of truth, satisfaction relation, and
fundamental model-theoretic laws.
-/

import MiniSatisfactionModel.Core.Basic

namespace MiniSatisfactionModel

/-! ## Satisfaction Laws for Connectives -/

theorem satisfies_conj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.and φ ψ) env ↔ (satisfies M φ env ∧ satisfies M ψ env) := by
  unfold satisfies; rfl

theorem satisfies_disj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.or φ ψ) env ↔ (satisfies M φ env ∨ satisfies M ψ env) := by
  unfold satisfies; rfl

theorem satisfies_impl (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.impl φ ψ) env ↔ (satisfies M φ env → satisfies M ψ env) := by
  unfold satisfies; rfl

theorem satisfies_neg (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.not φ) env ↔ ¬ satisfies M φ env := by
  unfold satisfies; rfl

theorem satisfies_equiv (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.equiv φ ψ) env ↔ (satisfies M φ env ↔ satisfies M ψ env) := by
  unfold satisfies; rfl

/-! ## Satisfaction Laws for Quantifiers -/

theorem satisfies_all (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.all φ) env ↔ (∀ x : M.domain, satisfies M φ (x :: env)) := by
  unfold satisfies; rfl

theorem satisfies_ex (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.ex φ) env ↔ (∃ x : M.domain, satisfies M φ (x :: env)) := by
  unfold satisfies; rfl

theorem satisfies_eq (M : MiniFunctionRelation.Structure) (t1 t2 : Nat) (env : List M.domain) :
    satisfies M (.eq t1 t2) env ↔ True := by
  unfold satisfies; rfl

/-! ## Truth in a Structure (Tarski's Definition) -/

def isTrueIn (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) : Prop :=
  satisfies M φ []

def isFalseIn (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) : Prop :=
  ¬ isTrueIn M φ

theorem isTrueIn_conj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.and φ ψ) ↔ (isTrueIn M φ ∧ isTrueIn M ψ) := by
  unfold isTrueIn; apply satisfies_conj

theorem isTrueIn_disj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.or φ ψ) ↔ (isTrueIn M φ ∨ isTrueIn M ψ) := by
  unfold isTrueIn; apply satisfies_disj

theorem isTrueIn_all (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.all φ) ↔ (∀ x : M.domain, satisfies M φ [x]) := by
  unfold isTrueIn; simp [satisfies_all]

theorem isTrueIn_ex (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.ex φ) ↔ (∃ x : M.domain, satisfies M φ [x]) := by
  unfold isTrueIn; simp [satisfies_ex]

/-! ## Semantic Consequence -/

def entails (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure), isModelOf M T → isTrueIn M φ

notation:40 T:40 " ⊨ " φ:41 => entails T φ

/-! ## Theory Closure -/

def consequencesOf (T : Theory) : Theory where
  axioms := { φ | T ⊨ φ }

def isDeductivelyClosed (T : Theory) : Prop :=
  T.axioms = (consequencesOf T).axioms

/-! ## Satisfaction under Homomorphism (Quantifier-Free) -/

theorem satisfies_preserved_by_hom (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (hqfree : isQuantifierFree φ = true) :
    satisfies M φ env → satisfies N φ (env.map f.map) := by
  intro h
  unfold satisfies at h
  unfold satisfies
  induction φ with
  | prop _ => exact h
  | pred p ts =>
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      simp [h, f.preservesPred]
  | eq t1 t2 =>
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      simp [f.preservesConst, h]
  | not A ih =>
      have hqfreeA : isQuantifierFree A = true := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      intro hn; apply h; exact ih hqfreeA hn
  | and A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A = true ∧ isQuantifierFree B = true := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      rcases h with ⟨hA, hB⟩
      exact ⟨ihA hqfreeAB.left hA, ihB hqfreeAB.right hB⟩
  | or A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A = true ∧ isQuantifierFree B = true := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      rcases h with hA | hB
      · exact Or.inl (ihA hqfreeAB.left hA)
      · exact Or.inr (ihB hqfreeAB.right hB)
  | impl A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A = true ∧ isQuantifierFree B = true := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      intro hA
      apply ihB hqfreeAB.right
      apply h
      exact ihA hqfreeAB.left hA
  | equiv A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A = true ∧ isQuantifierFree B = true := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      exact ⟨λ hA => ihB hqfreeAB.right (h.mp (ihA hqfreeAB.left hA)),
             λ hB => ihA hqfreeAB.left (h.mpr (ihB hqfreeAB.right hB))⟩
  | all P =>
      simp [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] at hqfree
  | ex P =>
      simp [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] at hqfree

/-! ## #eval Examples -/

def simpleStructure : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval isTrueIn simpleStructure (.pred 0 [0])
#eval isQuantifierFree (.pred 0 [0])
#eval isDeductivelyClosed ({ axioms := {.prop .true} } : Theory)
#eval isQuantifierFree (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isTrueIn simpleStructure (.not (.pred 0 [false]))

end MiniSatisfactionModel
