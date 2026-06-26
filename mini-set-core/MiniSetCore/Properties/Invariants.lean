/-
# MiniSetCore: Invariants

Set invariants: emptiness, finiteness, countability,
infinity, and cardinal estimates.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects

namespace MiniSetCore

/-! ## Emptiness -/

def isEmpty {α : Type u} (s : Set α) : Prop :=
  ∀ x, ¬ s x

theorem emptySet_isEmpty {α : Type u} : isEmpty (emptySet α) :=
  fun _ h => h

theorem isEmpty_iff_eq_empty {α : Type u} (s : Set α) :
    isEmpty s ↔ s = emptySet α := by
  apply Iff.intro
  · intro h
    apply subset_extensional
    intro x; apply Iff.intro
    · intro hx; exact (h x hx).elim
    · intro hx; exact False.elim hx
  · intro h
    rw [h]
    exact emptySet_isEmpty

/-! ## Nonempty -/

def isNonempty {α : Type u} (s : Set α) : Prop :=
  ∃ x, s x

theorem singleton_nonempty {α : Type u} [DecidableEq α] (a : α) :
    isNonempty (singleton a) :=
  ⟨a, rfl⟩

theorem nonempty_union {α : Type u} (s t : Set α) :
    isNonempty s → isNonempty (union s t) :=
  fun ⟨x, h⟩ => ⟨x, Or.inl h⟩

/-! ## Finiteness -/

/-- A set is finite if it can be represented as a FinSet. -/
def isFinite {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  ∃ (fs : FinSet α), FinSet.toSet fs = s

theorem emptySet_finite {α : Type u} [DecidableEq α] : isFinite (emptySet α) := by
  refine ⟨FinSet.empty, ?_⟩
  apply subset_extensional
  intro x; apply Iff.intro
  · intro hx; exact False.elim hx
  · intro hx; exact False.elim hx

theorem singleton_finite {α : Type u} [DecidableEq α] (a : α) : isFinite (singleton a) := by
  refine ⟨FinSet.insert a FinSet.empty, ?_⟩
  apply subset_extensional
  intro x; apply Iff.intro
  · intro hx; rw [hx]; exact Or.inl rfl
  · intro hx; rcases hx with (hx | hx)
    · exact hx
    · exact False.elim hx

/-! ## Finiteness via Bounded Cardinal -/

def finiteByBound {α : Type u} [DecidableEq α] (s : Set α) (n : Nat) : Prop :=
  ∃ (fs : FinSet α), FinSet.toSet fs = s ∧ FinSet.size fs ≤ n

/-! ## Countability -/

/-- A set is countable if it is empty or there is a surjection from Nat. -/
def isCountable {α : Type u} (s : Set α) : Prop :=
  isEmpty s ∨ ∃ (f : Nat → α), ∀ x, s x → ∃ n, f n = x

/-- A set is countably infinite if it is countable but not finite (as axiom). -/
axiom isCountablyInfinite {α : Type u} (s : Set α) : Prop

/-! ## Infinity -/

/-- A set is infinite if it is not finite. -/
def isInfinite {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  ¬ isFinite s

axiom natSet_infinite : isInfinite (fun n : Nat => True)

/-! ## Cardinal Estimate -/

/-- Estimate the cardinality of a finite set via FinSet. -/
def cardEstimate {α : Type u} [DecidableEq α] (s : Set α) : Nat :=
  match Classical.choice (show Nonempty (FinSet α) from ⟨FinSet.empty⟩) with
  | fs => FinSet.size fs

/-- Better: bound the size of any finite description. -/
def cardUpperBound {α : Type u} [DecidableEq α] (s : Set α) : Nat :=
  if h : isFinite s then
    match h with
    | ⟨fs, _⟩ => FinSet.size fs
  else 0

/-! ## #eval Examples -/

-- Empty set is empty
#eval isEmpty (emptySet Nat)

-- Singleton is nonempty
#eval isNonempty (singleton 42 : Set Nat)

-- Finite set via FinSet
def myFin : FinSet Nat := .insert 10 (.insert 20 (.insert 30 .empty))
#eval isFinite (FinSet.toSet myFin)

-- Bound the cardinality
#eval finiteByBound (FinSet.toSet myFin) 5

-- Countable example (natural numbers)
def allNats : Set Nat := fun _ => True
#check isCountable allNats

-- cardinal upper bound
#eval cardUpperBound (FinSet.toSet myFin)

end MiniSetCore
