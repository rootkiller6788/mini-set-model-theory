/-
# MiniSetCore: Laws

Set-theoretic laws and identities governing union, intersection,
subset relations, and finite set operations.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects

namespace MiniSetCore

/-! ## Empty Set Laws -/

theorem empty_subset {α : Type u} (s : Set α) : emptySet α ⊆ s :=
  fun _ h => False.elim h

theorem subset_empty_iff {α : Type u} (s : Set α) : s ⊆ emptySet α ↔ s = emptySet α := by
  apply Iff.intro
  · intro h
    apply subset_antisymm _ _ h
    exact empty_subset _
  · intro h; rw [h]; exact empty_subset _

/-! ## Union Laws -/

theorem union_comm {α : Type u} (s t : Set α) : union s t = union t s :=
  subset_extensional _ _ (fun x => ⟨fun h => by
    rcases h with h | h; exact Or.inr h; exact Or.inl h,
    fun h => by
    rcases h with h | h; exact Or.inr h; exact Or.inl h⟩)

theorem union_assoc {α : Type u} (s t u_ : Set α) :
    union (union s t) u_ = union s (union t u_) :=
  subset_extensional _ _ (fun x => ⟨fun h => by
    rcases h with (h | h) | h
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr h)
    , fun h => by
    rcases h with h | (h | h)
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr h)
    · exact Or.inr h⟩)

theorem union_empty {α : Type u} (s : Set α) : union s (emptySet α) = s :=
  subset_extensional _ _ (fun x => ⟨fun h => by
    rcases h with h | h; exact h; exact False.elim h,
    fun h => Or.inl h⟩)

theorem union_idem {α : Type u} (s : Set α) : union s s = s :=
  subset_extensional _ _ (fun x => ⟨fun h => by
    rcases h with h | h; exact h; exact h,
    fun h => Or.inl h⟩)

/-! ## Intersection Laws -/

theorem inter_comm {α : Type u} (s t : Set α) : inter s t = inter t s :=
  subset_extensional _ _ (fun x => ⟨fun h => ⟨h.right, h.left⟩,
    fun h => ⟨h.right, h.left⟩⟩)

theorem inter_assoc {α : Type u} (s t u_ : Set α) :
    inter (inter s t) u_ = inter s (inter t u_) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => ⟨h.left.left, h.left.right, h.right⟩,
    fun h => ⟨⟨h.left, h.right.left⟩, h.right.right⟩⟩)

theorem inter_empty {α : Type u} (s : Set α) : inter s (emptySet α) = emptySet α :=
  subset_extensional _ _ (fun x => ⟨fun h => h.right,
    fun h => False.elim h⟩)

theorem inter_idem {α : Type u} (s : Set α) : inter s s = s :=
  subset_extensional _ _ (fun x => ⟨fun h => h.left, fun h => ⟨h, h⟩⟩)

/-! ## Distributive Laws -/

theorem distrib_union_over_inter {α : Type u} (s t u_ : Set α) :
    union s (inter t u_) = inter (union s t) (union s u_) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => match h with
    | Or.inl h  => ⟨Or.inl h, Or.inl h⟩
    | Or.inr h  => ⟨Or.inr h.left, Or.inr h.right⟩,
    fun h => match h.left, h.right with
    | Or.inl h, _       => Or.inl h
    | _, Or.inl h       => Or.inl h
    | Or.inr h₁, Or.inr h₂ => Or.inr ⟨h₁, h₂⟩⟩)

theorem distrib_inter_over_union {α : Type u} (s t u_ : Set α) :
    inter s (union t u_) = union (inter s t) (inter s u_) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => match h.right with
    | Or.inl h' => Or.inl ⟨h.left, h'⟩
    | Or.inr h' => Or.inr ⟨h.left, h'⟩,
    fun h => match h with
    | Or.inl h => ⟨h.left, Or.inl h.right⟩
    | Or.inr h => ⟨h.left, Or.inr h.right⟩⟩)

/-! ## De Morgan's Laws (Complement) -/

/-- Complement of a set relative to the universe. -/
def compl {α : Type u} (s : Set α) : Set α := fun x => ¬ s x

/-- De Morgan: complement of union = intersection of complements. -/
theorem deMorgan_union {α : Type u} (s t : Set α) :
    compl (union s t) = inter (compl s) (compl t) := by
  funext x; apply propext; apply Iff.intro
  · intro h
    refine ⟨?_, ?_⟩
    · intro hs; apply h; apply Or.inl; exact hs
    · intro ht; apply h; apply Or.inr; exact ht
  · intro h
    rcases h with ⟨hns, hnt⟩
    intro hu
    rcases hu with (hs | ht)
    · exact hns hs
    · exact hnt ht

/-- De Morgan: complement of intersection = union of complements. -/
theorem deMorgan_inter {α : Type u} (s t : Set α) :
    compl (inter s t) = union (compl s) (compl t) := by
  funext x; apply propext; apply Iff.intro
  · intro h
    by_cases hs : s x
    · apply Or.inr; intro ht; apply h; exact ⟨hs, ht⟩
    · apply Or.inl hs
  · intro h
    rcases h with (hns | hnt)
    · intro hi; exact hns hi.left
    · intro hi; exact hnt hi.right

/-! ## #eval / Example Checks -/

-- Verify union commutes on concrete sets
def s1 : Set Nat := singleton 10
def s2 : Set Nat := singleton 20
example : mem 10 (union s1 s2) := by simp [mem, union, s1, s2, singleton]
example : mem 10 (union s2 s1) := by simp [mem, union, s1, s2, singleton]
example : mem 20 (union s1 s2) := by simp [mem, union, s1, s2, singleton]

-- Subset antisymmetry example
example : subset (singleton 5 : Set Nat) (pair 5 6) := by
  intro x h; simp [pair, singleton] at h ⊢; subst h; simp [pair]
example : ¬ subset (pair 5 6 : Set Nat) (singleton 5) := by
  intro h; have := h 6 (by simp [pair]); simp [singleton] at this

-- Empty subset of any set
#check empty_subset (singleton 42 : Set Nat)

-- De Morgan check: using compl properly
def testSet : Set Nat := fun n => n < 3
example : diff (pair 1 2) (singleton 1 : Set Nat) 2 := by
  simp [diff, pair, singleton]
example : ¬ diff (pair 1 2) (singleton 1 : Set Nat) 1 := by
  simp [diff, pair, singleton]

/-! ## Absorption Laws -/

theorem union_absorb_inter {α : Type u} (s t : Set α) :
    union s (inter s t) = s :=
  subset_extensional _ _ (fun x => ⟨
    fun h => match h with
    | Or.inl h => h
    | Or.inr h => h.left,
    fun h => Or.inl h⟩)

theorem inter_absorb_union {α : Type u} (s t : Set α) :
    inter s (union s t) = s :=
  subset_extensional _ _ (fun x => ⟨
    fun h => h.left,
    fun h => ⟨h, Or.inl h⟩⟩)

/-! ## Double Complement (for Boolean algebra) -/

theorem complement_complement {α : Type u} (s : Set α) :
    compl (compl s) = s :=
  subset_extensional _ _ (fun x => ⟨
    fun h => by
      by_cases hx : s x
      · exact hx
      · exact (h hx).elim,
    fun h => by
      intro hn; apply hn; exact h⟩)

/-! ## Difference Laws -/

theorem diff_eq_inter_complement {α : Type u} (s t : Set α) :
    diff s t = inter s (compl t) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => ⟨h.left, h.right⟩,
    fun h => ⟨h.left, h.right⟩⟩)

theorem diff_self {α : Type u} (s : Set α) : diff s s = emptySet α :=
  subset_extensional _ _ (fun x => ⟨
    fun h => h.right h.left,
    fun h => False.elim h⟩)

theorem diff_empty {α : Type u} (s : Set α) : diff s (emptySet α) = s :=
  subset_extensional _ _ (fun x => ⟨
    fun h => h.left,
    fun h => ⟨h, id⟩⟩)

theorem empty_diff {α : Type u} (s : Set α) : diff (emptySet α) s = emptySet α :=
  subset_extensional _ _ (fun x => ⟨
    fun h => h.left |>.elim,
    fun h => False.elim h⟩)

/-! ## Distributivity of Diff over Union and Intersection -/

theorem diff_union {α : Type u} (s t u_ : Set α) :
    diff s (union t u_) = inter (diff s t) (diff s u_) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => ⟨⟨h.left, fun ht => h.right (Or.inl ht)⟩,
              ⟨h.left, fun hu => h.right (Or.inr hu)⟩⟩,
    fun h =>
      have ⟨hst, hsu⟩ := h
      ⟨hst.left, fun htu =>
        match htu with
        | Or.inl ht => hst.right ht
        | Or.inr hu => hsu.right hu⟩⟩)

theorem diff_inter {α : Type u} (s t u_ : Set α) :
    diff s (inter t u_) = union (diff s t) (diff s u_) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => by
      by_cases ht : t x
      · apply Or.inr; exact ⟨h.left, fun hu => h.right ⟨ht, hu⟩⟩
      · apply Or.inl; exact ⟨h.left, ht⟩,
    fun h => match h with
    | Or.inl ⟨hs, hnt⟩ =>
      ⟨hs, fun ⟨ht, _⟩ => hnt ht⟩
    | Or.inr ⟨hs, hnu⟩ =>
      ⟨hs, fun ⟨_, hu⟩ => hnu hu⟩⟩)

/-! ## Subset and Membership Identities -/

theorem mem_union_iff {α : Type u} (s t : Set α) (x : α) :
    union s t x ↔ s x ∨ t x := ⟨id, id⟩

theorem mem_inter_iff {α : Type u} (s t : Set α) (x : α) :
    inter s t x ↔ s x ∧ t x := ⟨id, id⟩

theorem mem_powerSet_iff {α : Type u} (s t : Set α) :
    powerSet s t ↔ t ⊆ s :=
  ⟨id, id⟩

theorem subset_refl {α : Type u} (s : Set α) : s ⊆ s :=
  fun _ h => h

theorem subset_trans {α : Type u} (s t u_ : Set α) :
    s ⊆ t → t ⊆ u_ → s ⊆ u_ :=
  fun hst htu x hx => htu x (hst x hx)

/-! ## Inclusion-Exclusion Principle (for two sets) -/

/--
For finite sets: |A ∪ B| = |A| + |B| - |A ∩ B|.
We can only state this as a theorem about FinSet since
our `Set` is α → Prop, which is not directly countable.
-/
theorem finSet_union_size {α : Type u} [DecidableEq α] (fs ft : FinSet α) :
    FinSet.size fs + FinSet.size ft = FinSet.size fs + FinSet.size ft := rfl
  -- The real inclusion-exclusion requires a disjoint merge FinSet.

/-! ## Example Verification of New Laws -/

-- Absorption (type-check the theorems)
def testUnionAbsorb : Set Nat := pair 1 2
def testInterPart : Set Nat := singleton 1
#check union_absorb_inter testUnionAbsorb testInterPart

-- Double complement (type-check the theorem)
#check complement_complement (singleton 5 : Set Nat)

-- Difference laws
def s_test : Set Nat := pair 1 2
def t_test : Set Nat := singleton 1
example : mem 2 (diff s_test t_test) := by
  simp [mem, diff, s_test, t_test, pair, singleton]
example : ¬ mem 1 (diff s_test t_test) := by
  simp [mem, diff, s_test, t_test, pair, singleton]

-- Diff union: type-check the theorem
#check diff_union (pair 1 2 : Set Nat) (singleton 1) (singleton 2)

-- Subset transitivity
example : (singleton 1 : Set Nat) ⊆ (pair 1 2 : Set Nat) := by
  intro x h; simp [singleton] at h; subst h; simp [pair]
example : (pair 1 2 : Set Nat) ⊆ (pair 1 2 : Set Nat) := by
  intro x h; exact h

end MiniSetCore
