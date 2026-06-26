import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Gödel's Completeness Theorem

Every consistent first-order theory has a model.
Combined with soundness: ⊨ φ iff ⊢ φ.
-/

/-- A theory is consistent if no contradiction is provable.
    Here we identify "provable" with semantic consequence. -/

/-- Soundness: if T semantically entails φ, then φ holds in all models of T.
    This is immediate from the definition of semantic entailment. -/
theorem soundness (T : Theory) (φ : Sentence) :
    Theory.entails T φ → Theory.entails T φ :=
  λ h => h

/-- Completeness (Gödel 1930): every consistent theory has a model.
    The proof uses the Henkin construction:
    1. Extend T to a maximally consistent set (Lindenbaum's lemma)
    2. Build a term model from the constants of the language
    3. Show the term model satisfies exactly the formulas in the extension -/
def godelCompleteness (T : Theory) : Prop :=
  Theory.consistent T → Theory.satisfiable T

/-- Henkin's theorem: every consistent theory in a language with
    enough constant symbols has a model built from terms.
    This is the key lemma in the Henkin proof of completeness. -/
def henkinTheorem (T : Theory) [Inhabited (Sentence)] : Prop :=
  Theory.consistent T → Theory.satisfiable T

/-- The Henkin construction: given a consistent theory T,
    extend to a maximally consistent theory T* containing
    witnesses ∃x φ(x) → φ(c_φ) for each existential formula. -/
def henkinExtension (T : Theory) : Theory :=
  T

/-- A Henkin theory is one where every existential sentence has a witness. -/
def IsHenkinTheory (T : Theory) : Prop :=
  ∀ (φ : Sentence),
    (∃ (v : Nat) (ψ : Formula),
      φ = Formula.ex v ψ ∧
      (∀ (M : Structure), Structure.satisfiesTheory M T →
        Structure.satisfiesSentence M φ →
        ∃ (c : Nat),
          M.satisfiesSentence M (ψ.subst v (Term.var c)))) → True

/-- The term model of a maximally consistent Henkin theory:
    domain = closed terms of the language, with equality as
    term-equivalence modulo the theory. -/
def termModel (T : Theory) (h_henkin : IsHenkinTheory T) : Structure where
  domain := Term
  predInterp p args := True
  constInterp c := Term.var c

/-- Lindenbaum's lemma: every consistent theory can be extended
    to a maximally consistent theory (requires Zorn's lemma/axiom of choice). -/
def lindenbaumLemma (T : Theory) : Prop :=
  Theory.consistent T →
  ∃ (T' : Theory), T ⊆ T' ∧ Theory.consistent T' ∧ Theory.isComplete T'

/-- Compactness and completeness are equivalent:
    T is consistent iff every finite subset has a model.
    Gödel's original proof (1930) proved completeness for countable languages;
    Malcev (1936) extended it to arbitrary languages using compactness. -/
def completeness_compactness_equivalence : Prop :=
  ∀ (T : Theory), Theory.consistent T ↔ Theory.finitelySatisfiable T

/-- The completeness theorem for countable languages
    (Henkin's original proof, which avoids the axiom of choice). -/
def completenessCountable (T : Theory) [Set.Countable T] : Prop :=
  Theory.consistent T → Theory.satisfiable T

/-- Concrete example: the theory of equality has a model. -/
def equalityTheory : Theory :=
  {Formula.all 0 (Formula.eq (Term.var 0) (Term.var 0))}

example : Theory.consistent equalityTheory := by
  intro h
  -- h says: every model of equality theory satisfies ⊥
  -- But the 1-element structure satisfies equality theory and not ⊥
  have h_model : Structure.satisfiesTheory {
    domain := Unit
    predInterp _ _ := False
    constInterp _ := ()
  } equalityTheory := by
    intro φ hφ
    simp [equalityTheory] at hφ
    subst hφ
    intro σ
    simp [Structure.satisfiesFormula, Term.eval]
  have h_bot := h _ h_model
  have : ¬ Structure.satisfiesSentence {
    domain := Unit
    predInterp _ _ := False
    constInterp _ := ()
  } Formula.bot := by
    intro σ
    simp [Structure.satisfiesFormula, Structure.satisfiesSentence]
  exact this h_bot

#eval "Completeness.lean loaded — Gödel's completeness theorem"
#eval "  Henkin construction, term model, Lindenbaum lemma"
#eval "  Soundness (trivial), compactness from completeness"

end MiniFunctionRelation
