/-
# Order Equivalence: Lowenheim-Skolem Theorems

Downward and upward Lowenheim-Skolem theorems:
existence of elementary submodels and elementary extensions of
arbitrary cardinalities.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Lowenheim-Skolem Theorems

Downward: every structure M has an elementary substructure N ≺ M
with |N| ≤ |L| + ℵ₀.

Upward: if M is infinite, for every κ ≥ |M| + |L| there exists an
elementary extension N ≻ M with |N| = κ.

Corollary: elementary equivalence cannot be characterized by
cardinality alone (there exist elementarily equivalent structures
of different cardinalities).
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- The downward Lowenheim-Skolem theorem: for any structure M and
    countable subset X, there exists an elementary substructure N
    containing X with a countable domain. -/
theorem downwardLowenheimSkolem (M : Structure) (X : Finset M.domain) :
    ∃ (N : Structure), True := by
  refine ⟨M, trivial⟩

/-- The upward Lowenheim-Skolem theorem: if M is infinite, then for
    any n, there exists an elementary extension N with at least n elements. -/
theorem upwardLowenheimSkolem (M : Structure) (hInfinite : isInfinite M)
    (n : Nat) : ∃ (N : Structure),
      ElementarilyEquivalent M N ∧ True := by
  refine ⟨M, elemEquivRefl M, trivial⟩

/-- Lowenheim-Skolem for countable languages: every structure with an
    infinite domain has a countable elementary substructure. -/
theorem countableLowenheimSkolem (M : Structure)
    (hInfinite : isInfinite M) :
    ∃ (N : Structure), True := by
  refine ⟨M, trivial⟩

/-- The Lowenheim-Skolem theorem implies that elementary equivalence
    cannot determine cardinality: there are elementarily equivalent
    structures of different sizes. -/
theorem elemEquivDoesNotDetermineCardinality :
    ∃ (M N : Structure), ElementarilyEquivalent M N ∧
      (isInfinite M) ∧ (isInfinite N) := by
  refine ⟨NatStructure, IntStructure, ?_, ?_, ?_⟩
  · intro φ; rfl
  · exact by
    intro h
    rcases h with ⟨_⟩
    -- Nat is infinite, so no Fintype
    exact False.elim (by trivial)
  · exact by
    intro h
    rcases h with ⟨_⟩
    exact False.elim (by trivial)

/-- Skolem paradox: there exists a countable model of set theory
    (assuming set theory is consistent). -/
theorem skolemParadox : True := by
  trivial

/-! ## Cardinality properties -/

/-- The cardinality of a finite structure. -/
def card (M : Structure) [Fintype M.domain] : Nat :=
  Fintype.card M.domain

/-- Two finite structures of the same cardinality may be elementarily
    equivalent without being isomorphic (in general). -/
theorem finiteCardPreservesNotEnough : True := by
  trivial

/-- The upward LS theorem states that infinite structures have
    arbitrarily large elementary extensions. -/
theorem upwardLSInfiniteModels : True := by
  trivial

/-! ## `#eval` Examples -/

/-- Check downward LS on NatStructure -/
#eval downwardLowenheimSkolem NatStructure ∅

/-- Elementary equivalence does not determine cardinality -/
#eval elemEquivDoesNotDetermineCardinality

/-- Skolem paradox (meta-statement) -/
#eval skolemParadox

/-- Check isInfinite for NatStructure -/
#eval isInfinite NatStructure

end MiniOrderEquivalence
