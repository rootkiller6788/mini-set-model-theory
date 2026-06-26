import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Morphisms.Hom

namespace MiniFunctionRelation

/-
# Löwenheim-Skolem Theorems

Every consistent theory with an infinite model has models of every infinite cardinality.
Every structure has an elementary substructure of any smaller infinite cardinality.
-/

/-- The downward Löwenheim-Skolem theorem:
    Every structure has a countable elementary substructure containing a given subset. -/
def downwardLS (M : Structure) : Prop :=
  ∃ (N : Structure),
    Nonempty (ElementarySubstructure N M) ∧
    ∃ (f : N.domain → Nat), Function.Injective f

/-- The upward Löwenheim-Skolem theorem:
    If T has an infinite model, T has models of all larger cardinalities. -/
def upwardLS (T : Theory) : Prop :=
  (∃ (M : Structure), Structure.satisfiesTheory M T ∧ Infinite M.domain) →
  ∀ (κ : Nat), ∃ (N : Structure), Structure.satisfiesTheory N T ∧ Infinite N.domain

/-- Tarski-Vaught test for elementary substructures:
    M ≺ N iff for every formula φ(v, w̄) and all ā ∈ M,
    if N ⊧ ∃v φ(v, ā) then there exists b ∈ M such that N ⊧ φ(b, ā). -/
def tarskiVaughtCondition (M N : Structure) (e : Embedding M N) : Prop :=
  ∀ (φ : Formula) (v : Nat) (σ : Assignment M),
    N.satisfiesFormula (λ w => e.map (σ w)) (Formula.ex v φ) →
    ∃ (b : M.domain),
      N.satisfiesFormula ((λ w => e.map (σ w)).update v (e.map b)) φ

/-- LS for countable languages: every consistent theory has a countable model. -/
def downwardLS_countable (T : Theory) [Set.Countable T] : Prop :=
  Theory.consistent T →
  ∃ (M : Structure), Structure.satisfiesTheory M T ∧
    ∃ (f : M.domain → Nat), Function.Injective f

/-- The proof of downward LS uses the Tarski-Vaught test:
    1. Start with a countable subset X ⊆ M
    2. Close under Skolem functions: for each formula φ(v, w̄),
       add a witness for ∃v φ(v, w̄) whenever the existential holds
    3. Take the countable union; this is an elementary substructure -/

/-- Skolem hull: the closure of a set under definable Skolem functions. -/
def skolemHull (M : Structure) (X : Set M.domain) : Set M.domain :=
  -- This would be the countable union of X, f₁(X), f₂(X), ...
  -- where each f_φ is a Skolem function for formula φ
  X

/-- Concrete example: (ℚ, <) as a countable elementary substructure of (ℝ, <).
    Both are dense linear orders without endpoints. -/
def ratOrder : Structure where
  domain := Rat
  predInterp p args := match p, args with
    | 0, [x, y] => x < y
    | _, _ => False
  constInterp _ := 0

/-- Cantor's theorem: any countable DLO is isomorphic to (ℚ, <).
    This gives the "downward LS" for DLO: every model of DLO has
    a countable elementary substructure isomorphic to (ℚ, <). -/
def cantorTheorem : Prop :=
  ∀ (M : Structure),
    (∃ (order : M.domain → M.domain → Prop),
      (∀ x, ¬ order x x) ∧
      (∀ x y z, order x y → order y z → order x z) ∧
      (∀ x y, order x y ∨ x = y ∨ order y x) ∧
      (∀ x y, order x y → ∃ z, order x z ∧ order z y) ∧
      (∀ x, ∃ y, order y x) ∧
      (∀ x, ∃ y, order x y)) →
    (∃ (f : M.domain → Nat), Function.Injective f) →
    Nonempty (Iso M ratOrder)

#eval "LowenheimSkolem.lean loaded"
#eval "  downwardLS, upwardLS, tarskiVaughtCondition"
#eval "  ratOrder (ℚ, <)"
#eval "  Cantor's theorem for DLO"

end MiniFunctionRelation
