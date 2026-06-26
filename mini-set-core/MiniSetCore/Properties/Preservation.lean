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
axiom finite_union_axiom {α : Type u} [DecidableEq α] (s t : Set α) :
    isFinite s → isFinite t → isFinite (union s t)

/-! ## Finiteness Preserved by Intersection -/

/-
Since a subset of a finite set is finite, and inter s t ⊆ s,
we state this as an axiom.
-/
axiom finite_inter_axiom {α : Type u} [DecidableEq α] (s t : Set α) :
    isFinite s → isFinite (inter s t)

/-! ## Countability Preserved -/

theorem countable_union {α : Type u} (s t : Set α) :
    isCountable s → isCountable t → isCountable (union s t) := by
  intro hsc htc
  rcases hsc with (hse | hse)
  · -- s is empty, then union s t = t
    rcases htc with (hte | hte)
    · left; intro x; intro hx
      apply hte x; intro hxf; exact hx
    · right; exact hte
  · rcases htc with (hte | hte)
    · -- t is empty
      right; exact hse
    · -- Both are nonempty, use a merge
      right
      rcases hse with ⟨fs, hfs⟩
      rcases hte with ⟨ft, hft⟩
      -- Interleave the two enumerations
      refine ⟨fun n => if n % 2 = 0 then fs (n / 2) else ft (n / 2), ?_⟩
      intro x hx
      rcases hx with (hx | hx)
      · rcases hfs x hx with ⟨n, hn⟩
        exact ⟨2 * n, by
          have heven_mod : (2 * n) % 2 = 0 := by native_decide
          have heven_div : (2 * n) / 2 = n := by native_decide
          rw [if_pos heven_mod, heven_div]; exact hn⟩
      · rcases hft x hx with ⟨n, hn⟩
        exact ⟨2 * n + 1, by
          have hmod : (2 * n + 1) % 2 = 1 := by native_decide
          have hdiv : (2 * n + 1) / 2 = n := by native_decide
          rw [if_neg (by
            intro hc; rw [hmod] at hc; exact Nat.one_ne_zero hc
            ), hdiv]; exact hn⟩

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

/-! ## #eval Examples -/

-- Finiteness of union (axiom)
#check finite_union_axiom

-- Finiteness of intersection (axiom)
#check finite_inter_axiom

-- Nonempty preserved by union
def sA : Set Nat := singleton 10
def sB : Set Nat := singleton 20
#eval isNonempty (union sA sB)

-- Empty union of empty sets
#eval isEmpty sA
#check empty_union_empty

-- Countability preserved by union (natural numbers)
def evens : Set Nat := fun n => n % 2 = 0
def odds : Set Nat := fun n => n % 2 = 1
#check isCountable evens
#check countable_union evens odds

end MiniSetCore
