/-
# MiniSetCore: Laws

Set-theoretic laws and identities governing union, intersection,
subset relations, and finite set operations.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects

namespace MiniSetCore

/-! ## Extensionality -/

theorem subset_extensional {α : Type u} (s t : Set α) :
    (∀ x, s x ↔ t x) → s = t :=
  fun h => funext (fun x => propext (h x))

theorem subset_antisymm {α : Type u} (s t : Set α) :
    s ⊆ t → t ⊆ s → s = t :=
  fun h₁ h₂ => subset_extensional s t
    (fun x => ⟨h₁ x, h₂ x⟩)

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

/-! ## De Morgan's Laws -/

theorem deMorgan_union {α : Type u} (s t : Set α) :
    diff (union s t) = inter (diff s) (diff t) := by
  funext x; apply propext; apply Iff.intro
  · intro h; rcases h with ⟨h, hn⟩
    refine ⟨?_, ?_⟩
    · intro hs'; apply hn; apply Or.inl; exact hs'
    · intro ht'; apply hn; apply Or.inr; exact ht'
  · intro h; rcases h with ⟨h₁, h₂⟩
    refine ⟨?_, ?_⟩
    · intro hst; rcases hst with hs | ht
      · exact h₁ hs
      · exact h₂ ht
    · intro hst; rcases hst with hs | ht
      · exact h₁ hs
      · exact h₂ ht

theorem deMorgan_inter {α : Type u} (s t : Set α) :
    diff (inter s t) = union (diff s) (diff t) := by
  funext x; apply propext; apply Iff.intro
  · intro h; rcases h with ⟨h, hn⟩
    by_cases hs : s x
    · apply Or.inr; exact ⟨hs, fun ht => hn ⟨hs, ht⟩⟩
    · apply Or.inl; exact ⟨hs, fun ht => hn ⟨hs, ht⟩⟩
  · intro h; rcases h with (h | h)
    · rcases h with ⟨hn, hx⟩
      refine ⟨fun h => hn h.left, ?_⟩
      intro h; apply hn; exact h.left
    · rcases h with ⟨hn, hx⟩
      refine ⟨fun h => hx h.right, ?_⟩
      intro h; apply hx; exact h.right

/-! ## #eval Examples -/

-- Verify union commutes on concrete sets
def s1 : Set Nat := singleton 10
def s2 : Set Nat := singleton 20
#eval mem 10 (union s1 s2)
#eval mem 10 (union s2 s1)
#eval mem 20 (union s1 s2)

-- Subset antisymmetry example
#eval subset (singleton 5 : Set Nat) (pair 5 6)
#eval subset (pair 5 6 : Set Nat) (singleton 5)

-- Empty subset of any set
#eval empty_subset (singleton 42 : Set Nat)

-- De Morgan check: element not in union means not in both
def testSet : Set Nat := fun n => n < 3
#eval diff (pair 1 2) (singleton 1 : Set Nat) 2
#eval diff (pair 1 2) (singleton 1 : Set Nat) 1

end MiniSetCore
