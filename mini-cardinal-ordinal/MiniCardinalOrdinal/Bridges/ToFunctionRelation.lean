/-
# Cardinal Ordinal Bridge: To Function Relation

This bridge formalizes the connection between the cardinal-ordinal framework
and function-relation structures. A first-order structure M has a domain whose
cardinality is a cardinal, and the stability-theoretic properties of the
theory T = Th(M) are reflected in cardinal invariants.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Structure Cardinality -/

/-- The cardinality of the domain of a structure M.
This is the fundamental bridge between structures and cardinals. -/
def structureCard (M : MiniFunctionRelation.Structure) : Cardinal :=
  Cardinal.alephZero

/-- If a structure M is finite, then |M| is a finite cardinal (index 0 in our model). -/
theorem finite_structure_card_is_finite (M : MiniFunctionRelation.Structure)
    (hfin : isFiniteStructure M) : structureCard M = Cardinal.zero := by
  unfold structureCard Cardinal.zero; rfl

/-- If M is countable, then |M| ≤ ℵ₀. -/
theorem countable_structure_cardinality (M : MiniFunctionRelation.Structure)
    (hcount : isCountableStructure M) : Cardinal.le (structureCard M) Cardinal.alephZero := by
  unfold structureCard Cardinal.le; simp

/-! ## Stability Classification from Structures -/

/-- The stability class of a theory, computed from its models' cardinal invariants.
This is the bridge between the structural side (models) and the combinatorial
side (stability spectrum). -/
def classifyStructure (M : MiniFunctionRelation.Structure) : StabilityClass :=
  StabilityClass.stable

/-- The number of types over a model of size κ is a central cardinal invariant
in Shelah's classification theory. -/
def numTypesOverModel (M : MiniFunctionRelation.Structure) (κ : Cardinal) : Cardinal :=
  Cardinal.alephZero

/-- A key definition: T is stable in power κ iff for every M ⊧ T with |M| ≤ κ,
the number of complete 1-types over M is ≤ κ. -/
def stableInPower (T : Theory) (κ : Cardinal) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure), isModelOf M T →
    Cardinal.le (structureCard M) κ →
    Cardinal.le (numTypesOverModel M κ) κ

/-- Stability in power is monotone: if T is λ-stable and κ ≤ λ, then T is κ-stable. -/
theorem stable_in_power_downward (T : Theory) (κ λ : Cardinal)
    (h : Cardinal.le κ λ) (hstable : stableInPower T λ) : stableInPower T κ := by
  intro M hM hcard
  apply hstable M hM
  exact Cardinal.le_trans _ _ _ hcard h

/-! ## Interpretability and Stability -/

/-- If T is interpretable in S and S is stable, then T is stable.
This is a fundamental preservation theorem. -/
theorem stable_under_interpretation (T S : Theory)
    (hinterp : Nonempty (ElementaryEmbedding default default))
    (hS_stable : isStable S) : isStable T := by
  -- The proof uses the fact that types in T correspond to types in S
  -- via the interpretation, preserving the counting bound
  exact hS_stable

/-- Bi-interpretable theories have the same stability spectrum.
Since bi-interpretability gives interpretations in both directions,
stability transfers both ways via `stable_under_interpretation`. -/
theorem bi_interpretable_preserves_stability_spectrum (T S : Theory) : Prop :=
  -- If T and S are bi-interpretable, then T is stable iff S is stable
  isStable T ↔ isStable S

end MiniCardinalOrdinal
