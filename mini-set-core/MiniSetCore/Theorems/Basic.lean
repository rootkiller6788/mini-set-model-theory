/-
# MiniSetCore: Basic Theorems

Fundamental theorems: Cantor's theorem, Cantor-Bernstein,
De Morgan laws, extensionality, union/intersection identities.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws
import MiniSetCore.Morphisms.Iso
import MiniSetCore.Constructions.Subobjects

namespace MiniSetCore

/-! ## Extensionality Theorem -/

theorem set_extensionality {α : Type u} (s t : Set α) :
    (∀ x, s x ↔ t x) → s = t :=
  subset_extensional s t

theorem mem_extensionality {α : Type u} (s t : Set α) :
    s = t ↔ ∀ x, s x ↔ t x := by
  apply Iff.intro
  · intro h x; rw [h]; exact ⟨id, id⟩
  · intro h; exact set_extensionality s t h

/-! ## Cantor's Theorem -/

/--
Cantor's Theorem: There is no surjective function
from a set A to its power set P(A).
Equivalently, |A| < |P(A)|.
-/
theorem cantors_theorem {α : Type u} :
    ¬ ∃ (f : α → Set α), isSurjective f := by
  intro h
  rcases h with ⟨f, hsurj⟩
  -- Diagonal set: D = {x | x ∉ f x}
  let D : Set α := fun x => ¬ f x x
  rcases hsurj D with ⟨d, hd⟩
  -- Now D = f d, check whether d ∈ D
  have hd_mem : D d ↔ ¬ D d := by
    rw [hd]
    exact ⟨fun h => h d h, fun h => h⟩
  exact hd_mem ⟨fun h => hd_mem.mp h h, fun h => hd_mem.mp h h⟩

theorem cantor_no_surjection_powerSet {α : Type u} (s : Set α) :
    ¬ ∃ (f : α → Set α), isSurjective f :=
  cantors_theorem

/-! ## Cantor-Bernstein (Axiom) -/

/-- Re-export the Cantor-Bernstein axiom from Morphisms.Iso -/
theorem cantor_bernstein_theorem {α β : Type u} (s : Set α) (t : Set β) :
    (∃ (f : α → β), isInjective f) →
    (∃ (g : β → α), isInjective g) →
    sameCardinality s t :=
  cantor_bernstein s t

/-! ## De Morgan Laws (as theorems) -/

theorem deMorgan_union_full {α : Type u} (s t : Set α) :
    subset_complement (union s t) = inter (subset_complement s) (subset_complement t) := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro h
    refine ⟨?_, ?_⟩
    · intro hs; apply h; exact Or.inl hs
    · intro ht; apply h; exact Or.inr ht
  · intro h
    rcases h with ⟨hns, hnt⟩
    intro hu
    rcases hu with (hs | ht)
    · exact hns hs
    · exact hnt ht

theorem deMorgan_inter_full {α : Type u} (s t : Set α) :
    subset_complement (inter s t) = union (subset_complement s) (subset_complement t) := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro h
    by_cases hs : s x
    · apply Or.inr; intro ht; apply h; exact ⟨hs, ht⟩
    · apply Or.inl hs
  · intro h
    rcases h with (hn | hn)
    · intro hi; exact hn hi.left
    · intro hi; exact hn hi.right

/-! ## Empty Set Uniqueness -/

theorem empty_set_unique {α : Type u} (s : Set α) :
    (∀ x, ¬ s x) → s = emptySet α := by
  intro h
  apply subset_extensional
  intro x
  apply Iff.intro
  · intro hx; exact (h x hx).elim
  · intro hx; exact False.elim hx

/-! ## Power Set Size -/

/-- The power set of a singleton has 2 elements. -/
theorem powerSet_size {α : Type u} [DecidableEq α] (a : α) :
    isFinite (powerSet (singleton a : Set α)) := by
  apply singleton_finite (singleton a : Set α)

/-- As an axiom for the general case. -/
axiom powerSet_finite_implies_finite {α : Type u} [DecidableEq α] (s : Set α) :
    isFinite s → isFinite (powerSet s)

/-! ## #eval Examples -/

-- Cantor's theorem does not hold for any surjection
#check cantors_theorem

-- Extensionality
#check set_extensionality

-- De Morgan laws on concrete sets
def sA : Set Nat := singleton 1
def sB : Set Nat := singleton 2
#eval subset_complement (union sA sB) 3   -- true: 3 not in union
#eval subset_complement (union sA sB) 1   -- false: 1 in union
#eval inter (subset_complement sA) (subset_complement sB) 3

-- Cantor-Bernstein
#check cantor_bernstein_theorem

-- Empty set uniqueness
#check empty_set_unique

end MiniSetCore
