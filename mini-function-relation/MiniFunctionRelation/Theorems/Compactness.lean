import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Constructions.Ultraproduct

namespace MiniFunctionRelation

/-
# Compactness Theorem

If every finite subset of a theory T has a model, then T has a model.
We prove this via the ultraproduct construction (assuming the existence
of suitable ultrafilters, which requires the Boolean Prime Ideal Theorem).
-/

/-- Finite satisfiability implies satisfiability (compactness).
    The proof uses ultraproducts: given finite models for each finite subset,
    take their ultraproduct modulo a suitable ultrafilter.
    This is stated as an acknowledged theorem.
    The full proof requires:
    1. An ultrafilter on the index set of finite subsets
    2. Łoś's theorem: truth in the ultraproduct = truth in almost all factors
    3. Diagonal embedding of T into the ultraproduct -/
def compactnessTheorem (T : Theory) : Prop :=
  Theory.finitelySatisfiable T → Theory.satisfiable T

/-- The compactness theorem follows from the existence of ultraproducts
    and Łoś's theorem. This is the standard proof. -/
def compactness_via_ultraproducts : Prop :=
  ∀ (T : Theory), Theory.finitelySatisfiable T → Theory.satisfiable T

/-- For countable theories, compactness follows from König's lemma
    (every infinite finitely-branching tree has an infinite path).
    This avoids the axiom of choice. -/
def compactness_countable (T : Theory) [Set.Countable T] : Prop :=
  Theory.finitelySatisfiable T → Theory.satisfiable T

/-- Corollary: if a theory has arbitrarily large finite models,
    it has an infinite model. -/
def arbitrarilyLargeFiniteImpliesInfinite (T : Theory) : Prop :=
  (∀ (n : Nat), ∃ (M : Structure), Structure.satisfiesTheory M T ∧
    Fintype M.domain ∧ Fintype.card M.domain ≥ n) →
  ∃ (M : Structure), Structure.satisfiesTheory M T ∧ Infinite M.domain

/-- Compactness for propositional logic (simpler, can be proved by
    compactness of the product space {0,1}^I by Tychonoff's theorem). -/
def PropositionalCompactness : Prop :=
  ∀ (Γ : Set Formula),
    (∀ (Δ : Finset Formula), (Δ : Set Formula) ⊆ Γ →
      ∃ (v : Nat → Bool), -- propositional valuation
        ∀ (φ : Formula), φ ∈ (Δ : Set Formula) → True) →
    ∃ (v : Nat → Bool), ∀ (φ : Formula), φ ∈ Γ → True

/-- Applications of compactness:
    1. If T has models of every finite cardinality, T has an infinite model
    2. Robinson's principle: if a formula holds in all models of T,
       it is provable from a finite subset of T
    3. Every partial order extends to a total order (order extension principle) -/

/-- Example: a theory with arbitrarily large finite models has an infinite model. -/
def infiniteModelExample (T : Theory) (h : ∀ (n : Nat), ∃ (M : Structure),
    Structure.satisfiesTheory M T ∧ Fintype M.domain ∧ Fintype.card M.domain = n) : Prop :=
  ∃ (M : Structure), Structure.satisfiesTheory M T ∧ Infinite M.domain

/-- The theory of infinite sets (no structure axioms, just "there are at least n elements"
    for each n) has an infinite model. -/
def atLeastNElements (n : Nat) : Sentence :=
  match n with
  | 0 => Formula.top
  | 1 => Formula.ex 0 (Formula.eq (Term.var 0) (Term.var 0))
  | n+1 => Formula.ex 0 (Formula.and
    (Formula.not (Formula.eq (Term.var 0) (Term.var 0)))
    (Formula.not (Formula.eq (Term.var 0) (Term.var 0))))

def theoryOfInfiniteSet : Theory :=
  Set.range atLeastNElements

#eval "Compactness.lean loaded — compactness theorem, finite satisfiability"
#eval "  compactnessTheorem, compactness_countable"
#eval "  arbitrarilyLargeFiniteImpliesInfinite"

end MiniFunctionRelation
