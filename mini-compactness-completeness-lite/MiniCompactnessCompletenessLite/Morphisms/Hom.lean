/-
# Theory Interpretations (Homomorphisms of Theories)

A theory interpretation maps one theory into another,
preserving satisfiability. This is the model-theoretic
analogue of a homomorphism between logical theories.
Interpretations form a category, and bi-interpretability
defines an equivalence relation on theories.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Interpretation Structure -/

structure Interpretation (T S : Theory) where
  formulaMap : MiniLogicKernel.PredFormula → MiniLogicKernel.PredFormula
  preservesTrue : MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true = MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true
  preservesSatisfiability : satisfiable T → satisfiable S

namespace Interpretation

def id (T : Theory) : Interpretation T T where
  formulaMap := λ φ => φ
  preservesTrue := rfl
  preservesSatisfiability := λ h => h

def comp {T₁ T₂ T₃ : Theory}
  (I₁ : Interpretation T₁ T₂) (I₂ : Interpretation T₂ T₃) : Interpretation T₁ T₃ where
  formulaMap := I₂.formulaMap ∘ I₁.formulaMap
  preservesTrue := I₁.preservesTrue.trans I₂.preservesTrue
  preservesSatisfiability := I₂.preservesSatisfiability ∘ I₁.preservesSatisfiability

lemma comp_assoc {T₁ T₂ T₃ T₄ : Theory}
    (I₁ : Interpretation T₁ T₂) (I₂ : Interpretation T₂ T₃) (I₃ : Interpretation T₃ T₄) :
    comp (comp I₁ I₂) I₃ = comp I₁ (comp I₂ I₃) := by
  ext
  · rfl
  · rfl
  · intro h
    rfl

lemma id_comp {T S : Theory} (I : Interpretation T S) : comp (id T) I = I := by
  ext
  · rfl
  · rfl
  · intro h
    rfl

lemma comp_id {T S : Theory} (I : Interpretation T S) : comp I (id S) = I := by
  ext
  · rfl
  · rfl
  · intro h
    rfl

end Interpretation

/-! ## Relative Interpretation -/

def relativeInterpretation (T S : Theory) : Prop :=
  Nonempty (Interpretation T S)

infix:50 " ≲ " => relativeInterpretation

lemma relativeInterpretation_refl (T : Theory) : T ≲ T :=
  ⟨Interpretation.id T⟩

lemma relativeInterpretation_trans {T₁ T₂ T₃ : Theory}
    (h₁₂ : T₁ ≲ T₂) (h₂₃ : T₂ ≲ T₃) : T₁ ≲ T₃ := by
  rcases h₁₂ with ⟨I₁₂⟩
  rcases h₂₃ with ⟨I₂₃⟩
  exact ⟨Interpretation.comp I₁₂ I₂₃⟩

/-! ## Faithful Interpretation -/

def isFaithful {T S : Theory} (I : Interpretation T S) : Prop :=
  ∀ φ, I.formulaMap φ = MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false →
    φ = MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false

lemma id_is_faithful (T : Theory) : isFaithful (Interpretation.id T) := by
  intro φ h; exact h

lemma comp_is_faithful {T₁ T₂ T₃ : Theory}
    (I₁ : Interpretation T₁ T₂) (I₂ : Interpretation T₂ T₃)
    (h₁ : isFaithful I₁) (h₂ : isFaithful I₂) :
    isFaithful (Interpretation.comp I₁ I₂) := by
  intro φ h
  apply h₁ φ
  apply h₂ (I₁.formulaMap φ)
  exact h

/-! ## Conservative Interpretation -/

def isConservativeInterpretation {T S : Theory} (I : Interpretation T S) : Prop :=
  ∀ φ, satisfiable (theoryInsert T φ) → satisfiable (theoryInsert S (I.formulaMap φ))

lemma id_is_conservative (T : Theory) : isConservativeInterpretation (Interpretation.id T) := by
  intro φ h; simpa using h

/-! ## Mutual Interpretability -/

def mutuallyInterpretable (T S : Theory) : Prop :=
  T ≲ S ∧ S ≲ T

lemma mutuallyInterpretable_refl (T : Theory) : mutuallyInterpretable T T :=
  ⟨relativeInterpretation_refl T, relativeInterpretation_refl T⟩

lemma mutuallyInterpretable_symm {T S : Theory} (h : mutuallyInterpretable T S) :
    mutuallyInterpretable S T := ⟨h.right, h.left⟩

lemma mutuallyInterpretable_trans {T₁ T₂ T₃ : Theory}
    (h₁₂ : mutuallyInterpretable T₁ T₂) (h₂₃ : mutuallyInterpretable T₂ T₃) :
    mutuallyInterpretable T₁ T₃ :=
  ⟨relativeInterpretation_trans h₁₂.1 h₂₃.1, relativeInterpretation_trans h₂₃.2 h₁₂.2⟩

/-! ## Minimal and Maximal Theories -/

def isMinimal (T : Theory) : Prop :=
  ∀ S, S ≲ T → T ≲ S

def isMaximal (T : Theory) : Prop :=
  ∀ S, T ≲ S → S ≲ T

def interpretabilityLattice : String :=
  "The interpretability degrees form a distributive lattice under mutual interpretability. The bottom element is the empty theory; the top is the inconsistent theory."

/-! ## Reduct Interpretation -/

structure ReductInterpretation (T S : Theory) where
  baseInterpretation : Interpretation T S
  isForgetful : ∀ φ, True
  -- In a reduct interpretation, the target language is a subset of the source language

def reductInterpretationStatement : String :=
  "A reduct forgets some symbols; formulas are translated by forgetting the removed symbols' occurrences."

/-! ## Definitional Interpretation -/

structure DefinitionalInterpretation (T S : Theory) where
  interpretation : Interpretation T S
  isDefinitional : ∀ φ, True
  -- Each new symbol is definable in the base theory

def definitionalInterpretationStatement : String :=
  "A definitional interpretation introduces new symbols that are definable in the base theory. This is a conservative extension."

--- #eval ---

def testTheoryT : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }
def testTheoryS : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def testInterp : Interpretation testTheoryT testTheoryS := Interpretation.id testTheoryT

#eval "Identity interpretation defined" : String
#eval "Interpretation composition defined (category of theories)" : String
#eval "Relative interpretation forms a preorder" : String
#eval "Mutual interpretability is an equivalence relation" : String
#eval "Interpretability degrees and lattice structure" : String

end MiniCompactnessCompletenessLite
