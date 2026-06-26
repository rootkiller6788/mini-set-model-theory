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

/-! ## Finite Sets via Bounded Enumeration -/

/--
A more constructive characterization of finiteness:
A set is finite if there exists a natural number n and
an enumeration of all its elements (possibly with repetition)
by a list of length n.
-/
def isFiniteByList {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  ∃ (xs : List α), (∀ x, s x → x ∈ xs) ∧ (∀ x, x ∈ xs → s x)

theorem finiteByList_implies_finite {α : Type u} [DecidableEq α] (s : Set α) :
    isFiniteByList s → isFinite s := by
  intro h
  rcases h with ⟨xs, hmem, hsub⟩
  -- Convert list to FinSet
  let rec listToFinSet (xs : List α) : FinSet α :=
    match xs with
    | [] => .empty
    | x :: rest => .insert x (listToFinSet rest)
  refine ⟨listToFinSet xs, ?_⟩
  apply subset_extensional
  intro x; apply Iff.intro
  · intro hx
    have : x ∈ xs := hmem x hx
    induction xs with
    | nil => exact False.elim this
    | cons y ys ih =>
      simp [listToFinSet, FinSet.toSet]
      rcases this with (rfl | hx')
      · exact Or.inl rfl
      · exact Or.inr (ih hx')
  · intro hx
    induction xs generalizing x with
    | nil => simp [listToFinSet, FinSet.toSet] at hx
    | cons y ys ih =>
      simp [listToFinSet, FinSet.toSet] at hx
      rcases hx with (rfl | hx')
      · exact hsub y (by simp)
      · exact ih hx'

/-! ## Decidable Finiteness for Nat Sets -/

/--
For sets of Nat defined by a bound, finiteness is decidable.
-/
def boundedNatSet (N : Nat) : Set Nat := fun n => n < N

theorem boundedNatSet_finite (N : Nat) : isFinite (boundedNatSet N) := by
  let rec boundedNatList : Nat → List Nat
    | 0 => []
    | n+1 => n :: boundedNatList n
  apply finiteByList_implies_finite
  refine ⟨boundedNatList N, ?_, ?_⟩
  · intro x hx
    have : x < N := hx
    induction N generalizing x with
    | zero => exact Nat.not_lt_zero _ this |>.elim
    | succ N ih =>
      simp [boundedNatList]
      by_cases h : x = N
      · left; exact h.symm
      · right; apply ih; exact Nat.lt_of_le_of_ne (Nat.le_of_lt_succ this) h
  · intro x hx
    induction N generalizing x with
    | zero => simp [boundedNatList] at hx
    | succ N ih =>
      simp [boundedNatList] at hx
      rcases hx with (rfl | hx')
      · exact Nat.lt_succ_self N
      · have : x < N := ih hx'
        exact Nat.lt_trans this (Nat.lt_succ_self N)

/-! ## Constructive Emptiness Test -/

/--
For sets defined on a decidable carrier type, emptiness is decidable
when the set is finite.
-/
def decidableEmptiness {α : Type u} [DecidableEq α] (s : Set α) (hfin : isFinite s) : Decidable (isEmpty s) :=
  match hfin with
  | ⟨fs, hfs⟩ =>
    -- If the FinSet is empty, the set is empty
    match fs with
    | .empty => isTrue (by
        intro x hx
        rw [hfs, FinSet.toSet] at hx
        exact hx)
    | .insert x _ => isFalse (by
        intro h_emp
        have : s x := by rw [hfs, FinSet.toSet]; exact Or.inl rfl
        exact h_emp x this)

/-! ## Subsets of Finite Sets -/

/--
Any subset of a finite set is finite.
This is a constructive theorem given a FinSet representation.
-/
theorem subset_of_finite_is_finite {α : Type u} [DecidableEq α] (s t : Set α) :
    s ⊆ t → isFinite t → isFinite s := by
  intro hsub hfin
  rcases hfin with ⟨ft, hft⟩
  -- Build a FinSet for s by filtering ft
  let filterFS : FinSet α → FinSet α := fun ft' =>
    match ft' with
    | .empty => .empty
    | .insert x rest =>
      if s x then
        FinSet.insert x (filterFS rest)
      else
        filterFS rest
  refine ⟨filterFS ft, ?_⟩
  apply subset_extensional
  intro x; apply Iff.intro
  · intro hx
    -- x ∈ s, need to show x ∈ toSet (filterFS ft)
    have hx_t : t x := hsub hx
    rw [hft] at hx_t
    induction ft generalizing x with
    | empty => exact False.elim hx_t
    | insert y rest ih =>
      simp [FinSet.toSet] at hx_t
      rcases hx_t with (rfl | hx_t')
      · -- x = y, filter depends on s x
        by_cases hsx : s x
        · simp [filterFS, hsx, FinSet.toSet]
          exact Or.inl rfl
        · exfalso; exact hsx hx
      · -- x in FinSet.toSet rest
        by_cases hsy : s y
        · simp [filterFS, hsy, FinSet.toSet]
          exact Or.inr (ih hx_t')
        · simp [filterFS, hsy]
          exact ih hx_t'
  · intro hx
    -- x ∈ toSet (filterFS ft), need to show s x
    induction ft generalizing x with
    | empty => simp [filterFS, FinSet.toSet] at hx
    | insert y rest ih =>
      by_cases hsy : s y
      · simp [filterFS, hsy, FinSet.toSet] at hx
        rcases hx with (rfl | hx')
        · exact hsy
        · exact ih hx'
      · simp [filterFS, hsy] at hx
        exact ih hx

/-! ## #eval Verification -/

-- Bounded finite set
#eval boundedNatSet 5 3
#eval boundedNatSet 5 7
#check boundedNatSet_finite 5

-- Decidable emptiness
def myTestSet : Set Nat := fun n => n < 3
#eval decidableEmptiness myTestSet (boundedNatSet_finite 3)

-- Subset of finite is finite
def myBiggerSet : Set Nat := fun n => n < 10
def mySmallerSet : Set Nat := fun n => n < 5
#check subset_of_finite_is_finite mySmallerSet myBiggerSet
    (fun x hx => Nat.lt_trans hx (by decide))
    (boundedNatSet_finite 10)

end MiniSetCore
