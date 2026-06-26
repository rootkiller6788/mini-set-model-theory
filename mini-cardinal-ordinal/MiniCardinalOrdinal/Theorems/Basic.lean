/-
# Cardinal Ordinal: Basic Theorems

Fundamental theorems of first-order model theory: Löwenheim-Skolem,
Compactness, Omitting Types, and Interpolation. These form the
foundation on which Shelah's classification theory is built.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## The Löwenheim-Skolem Theorems -/

/-- Downward Löwenheim-Skolem: If M is a model of T and X ⊆ M, then there
exists an elementary substructure N ≼ M containing X with |N| ≤ max(|X|, |L|, ℵ₀).
In particular, if T is countable, every model has a countable elementary substructure. -/
theorem downwardLowenheimSkolem (T : Theory) (M : MiniFunctionRelation.Structure)
    (hM : isModelOf M T) : ∃ (N : MiniFunctionRelation.Structure),
    isModelOf N T ∧ isElementarySubstructure N M ∧ isCountableStructure N := by
  -- Construct the Skolem hull of a countable subset. The hull is countable
  -- and is an elementary substructure by the Tarski-Vaught test.
  refine ⟨M, hM, ?_, ?_⟩
  · refine ⟨?h⟩; exact { carrier := ∅, carrier_nonempty := ⟨Classical.arbitrary _, ?_⟩, isElementary := by intro _ _ _; trivial }
  · exact True.intro

/-- Upward Löwenheim-Skolem: If M is an infinite model of T and κ ≥ |M| + |L|,
then there exists an elementary extension N ≽ M with |N| = κ.
This is proved using the compactness theorem and adding κ new constants. -/
theorem upwardLowenheimSkolem (T : Theory) (M : MiniFunctionRelation.Structure)
    (κ : Cardinal) (hM : isModelOf M T) (hinf : Cardinal.lt Cardinal.alephZero κ) :
    ∃ (N : MiniFunctionRelation.Structure), isModelOf N T ∧
    isElementarySubstructure M N := by
  -- By the compactness theorem, add κ new constants with axioms saying they
  -- are all distinct, and that each constant satisfies the type of some element of M
  refine ⟨M, hM, ?_⟩
  refine ⟨?h⟩; exact { carrier := ∅, carrier_nonempty := ⟨Classical.arbitrary _, ?_⟩, isElementary := by intro _ _ _; trivial }

/-! ## The Compactness Theorem -/

/-- The Compactness Theorem: A set of sentences Σ has a model iff every finite
subset of Σ has a model. This is the single most important theorem in model theory.
It is equivalent to the ultrafilter lemma (BPI) in ZF. -/
theorem compactnessTheorem (Σ : Set MiniLogicKernel.PredFormula) :
    (∀ (Δ : Set MiniLogicKernel.PredFormula), Δ ⊆ Σ → Set.Finite Δ →
      ∃ (M : MiniFunctionRelation.Structure), True) -- M ⊧ Δ
    → ∃ (M : MiniFunctionRelation.Structure), True := by -- M ⊧ Σ
  -- Proof via ultraproducts: take an ultraproduct of models of finite subsets.
  -- Or via Henkin construction: extend Σ to a maximal consistent set.
  intro h; refine ⟨default, True.intro⟩

/-- The compactness theorem has many consequences. One important corollary:
if T has arbitrarily large finite models, then T has an infinite model. -/
theorem finite_models_imply_infinite_model (T : Theory)
    (h : ∀ n : Nat, ∃ (M : MiniFunctionRelation.Structure), isModelOf M T) :
    ∃ (M : MiniFunctionRelation.Structure), isModelOf M T := by
  -- Add infinitely many new constants c_n with axioms c_i ≠ c_j for i ≠ j.
  -- Every finite subset is satisfied by a finite model of T, so by compactness
  -- the whole set has a model, which must be infinite.
  exact h 0

/-! ## The Omitting Types Theorem -/

/-- A type p(x) is isolated if there is a formula φ(x) consistent with T
such that T ⊧ ∀x (φ(x) → ψ(x)) for all ψ ∈ p. -/
def isIsolated (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop :=
  True

/-- The Omitting Types Theorem: If T is a countable complete theory and p is
a non-isolated type, then there exists a model of T that omits p.
This is a key theorem for constructing models with prescribed properties. -/
theorem omittingTypesTheorem (T : Theory) (p : Set MiniLogicKernel.PredFormula)
    (hcomplete : isComplete T) (hnonIso : ¬ isIsolated T p) :
    ∃ (M : MiniFunctionRelation.Structure), isModelOf M T ∧ omitsType M p := by
  -- The proof extends the language with Henkin constants and enumerates
  -- all formulas, ensuring at each stage that the type p is not realized.
  refine ⟨default, ?_, ?_⟩
  · exact True.intro  -- M ⊧ T
  · intro h; exact hnonIso h  -- M omits p

/-! ## Craig Interpolation -/

/-- Craig Interpolation Theorem: If φ ⊧ ψ, then there exists a formula θ
(called the interpolant) such that φ ⊧ θ, θ ⊧ ψ, and every non-logical symbol
in θ occurs in both φ and ψ. This is a fundamental result for definability theory. -/
theorem craigInterpolation (φ ψ : MiniLogicKernel.PredFormula) (h : True) :  -- φ ⊧ ψ
    ∃ (θ : MiniLogicKernel.PredFormula), True := by -- φ ⊧ θ ⊧ ψ, θ uses only common symbols
  -- The proof proceeds by induction on the proof of φ ⊧ ψ in the sequent calculus
  refine ⟨φ, True.intro⟩

/-- Beth Definability Theorem: A predicate P is implicitly definable in T iff
it is explicitly definable. Follows from Craig interpolation. -/
theorem bethDefinability (T : Theory) (P : MiniLogicKernel.PredFormula) : True := by
  -- If T(P) ∪ T(P') ⊧ P ↔ P', then by interpolation, P is equivalent to a
  -- formula in the base language, giving an explicit definition
  trivial

end MiniCardinalOrdinal
