/-
# MiniSetCore: Quotients

Quotient sets via equivalence relations, partition into
equivalence classes, and the set of equivalence classes.
-/

import MiniObjectKernel.Core.Basic
import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects

namespace MiniSetCore

open MiniObjectKernel

/-! ## Equivalence Relation on a Set -/

structure EquivRel (α : Type u) (s : Set α) where
  rel : α → α → Prop
  refl  : ∀ x, s x → rel x x
  symm  : ∀ x y, rel x y → rel y x
  trans : ∀ x y z, rel x y → rel y z → rel x z

/-! ## Equivalence Class -/

def equivClass {α : Type u} {s : Set α} (R : EquivRel α s) (a : α) : Set α :=
  fun x => R.rel a x ∧ s x

/-! ## Quotient Set (Set of Equivalence Classes) -/

def quotientSet {α : Type u} {s : Set α} (R : EquivRel α s) : Set (Set α) :=
  fun t => ∃ a, s a ∧ t = equivClass R a

/-! ## Partition of a Set -/

structure Partition (α : Type u) (s : Set α) where
  blocks : Set (Set α)
  nonempty : ∀ t, blocks t → ∃ x, t x
  disjoint : ∀ t₁ t₂, blocks t₁ → blocks t₂ → t₁ ≠ t₂ → inter t₁ t₂ = emptySet α
  cover    : ∀ x, s x → ∃ t, blocks t ∧ t x

/-! ## From Equivalence Relation to Partition -/

def equivRelToPartition {α : Type u} {s : Set α} (R : EquivRel α s) : Partition α s where
  blocks := quotientSet R
  nonempty := by
    intro t ht
    rcases ht with ⟨a, ha, h⟩
    exact ⟨a, by rw [h]; exact ⟨R.refl a ha, ha⟩⟩
  disjoint := by
    intro t₁ t₂ ht₁ ht₂ hne
    rcases ht₁ with ⟨a₁, ha₁, h₁⟩
    rcases ht₂ with ⟨a₂, ha₂, h₂⟩
    apply subset_extensional
    intro x; apply Iff.intro
    · intro hx; rcases hx with ⟨hx₁, hx₂⟩
      rw [h₁, h₂] at hx₁ hx₂
      rcases hx₁ with ⟨hrel₁, hxs₁⟩
      rcases hx₂ with ⟨hrel₂, hxs₂⟩
      have heq : equivClass R a₁ = equivClass R a₂ := by
        apply subset_extensional
        intro y; apply Iff.intro
        · intro ⟨hry, hsy⟩; exact ⟨R.trans y a₁ a₂ (R.symm a₁ y hry) hrel₁, hsy⟩
        · intro ⟨hry, hsy⟩; exact ⟨R.trans y a₂ a₁ (R.symm a₂ y hry) hrel₂, hsy⟩
      exact (hne (h₁.trans heq.symm.trans h₂.symm)).elim
    · intro h; exfalso; exact h
  cover := by
    intro x hx
    refine ⟨equivClass R x, ?_, ⟨R.refl x hx, hx⟩⟩
    exact ⟨x, hx, rfl⟩

/-! ## Canonical Projection -/

def quotientProjection {α : Type u} {s : Set α} (R : EquivRel α s) (x : α) (h : s x) : Set α :=
  equivClass R x

theorem quotientProjection_surj {α : Type u} {s : Set α} (R : EquivRel α s) :
    ∀ t, quotientSet R t → ∃ x, s x ∧ quotientProjection R x (by
      rcases t with ⟨a, ha, h⟩
      -- We need to know x satisfies h
      exact ha) = t := by
  intro t ht
  rcases ht with ⟨a, ha, h⟩
  exact ⟨a, ha, h⟩

/-! ## Universal Property of Quotient -/

def quotientLift {α β : Type u} {s : Set α} (R : EquivRel α s) (t : Set β)
    (f : α → β) (hf : ∀ x y, s x → s y → R.rel x y → f x = f y) : Set α → Set β :=
  fun u => image f (inter u s)

/-! ## #eval Examples -/

-- An equivalence relation: equality mod 2 on a finite set
def mod2Equiv : EquivRel Nat (fun n => n < 6) where
  rel x y := x % 2 = y % 2
  refl x _ := rfl
  symm x y h := h.symm
  trans x y z h₁ h₂ := h₁.trans h₂

-- Equivalence class of 1
#eval equivClass mod2Equiv 1 1
#eval equivClass mod2Equiv 1 3
#eval equivClass mod2Equiv 1 2

-- Quotient set membership
#eval quotientSet mod2Equiv (fun n => n = 1 ∨ n = 3 ∨ n = 5)

-- Projection example
def smallSet : Set Nat := fun n => n < 6
#eval quotientProjection mod2Equiv 3 (by decide) 5

-- Partition construction
#check equivRelToPartition mod2Equiv

end MiniSetCore
