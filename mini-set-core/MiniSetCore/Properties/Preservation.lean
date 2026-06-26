/-
# MiniSetCore: Preservation

Properties preserved under set operations:
finiteness, countability, and nonempty under union/intersection.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Properties.Invariants

namespace MiniSetCore

/-! ## Finiteness Preserved by Union -/

/-
The union of two FinSet-expressible sets is finite.
We state this as an axiom since building the merged FinSet
requires decidable equality and induction, which is
straightforward but verbose.
-/
/--
The union of two finite sets is finite. The proof merges the
two FinSet representations; deferred with `sorry`.
-/
theorem finite_union_axiom {α : Type u} [DecidableEq α] (s t : Set α) :
    isFinite s → isFinite t → isFinite (union s t) :=
  sorry

/-! ## Finiteness Preserved by Intersection -/

/--
The intersection of a finite set with any set is finite
(since a subset of a finite set is finite). Deferred with `sorry`.
-/
theorem finite_inter_axiom {α : Type u} [DecidableEq α] (s t : Set α) :
    isFinite s → isFinite (inter s t) :=
  sorry

/-! ## Countability Preserved -/

/--
A countable union of two countable sets is countable.
The proof interleaves the two enumerations. Deferred with `sorry`
due to the complexity of the constructive enumeration argument.
-/
theorem countable_union {α : Type u} (s t : Set α) :
    isCountable s → isCountable t → isCountable (union s t) :=
  sorry

/-! ## Nonempty Preserved -/

theorem nonempty_union_preserved {α : Type u} (s t : Set α) :
    isNonempty s ∨ isNonempty t → isNonempty (union s t) := by
  intro h
  rcases h with (⟨x, hx⟩ | ⟨x, hx⟩)
  · exact ⟨x, Or.inl hx⟩
  · exact ⟨x, Or.inr hx⟩

theorem nonempty_inter_preserved {α : Type u} (s t : Set α) :
    isNonempty s → isNonempty t → (∃ x, s x ∧ t x) → isNonempty (inter s t) := by
  intro _ _ ⟨x, hx⟩
  exact ⟨x, hx⟩

/-! ## Emptiness Preserved by Union of Empties -/

theorem empty_union_empty {α : Type u} (s t : Set α) :
    isEmpty s → isEmpty t → isEmpty (union s t) := by
  intro hs ht x hx
  rcases hx with (hx | hx)
  · exact hs x hx
  · exact ht x hx

/-! ## Examples -/

-- Finiteness of union/intersection (sorry)
#check finite_union_axiom
#check finite_inter_axiom

-- Nonempty preserved by union
def presA : Set Nat := singleton 10
def presB : Set Nat := singleton 20
#check isNonempty (union presA presB)
#check empty_union_empty

-- Countability (type-check)
def evens : Set Nat := fun n => n % 2 = 0
def odds : Set Nat := fun n => n % 2 = 1
#check isCountable evens

end MiniSetCore
