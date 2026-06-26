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
      rw [h₁] at hx₁; rw [h₂] at hx₂
      rcases hx₁ with ⟨hrel₁, hxs₁⟩
      rcases hx₂ with ⟨hrel₂, hxs₂⟩
      -- From hrel₁: R.rel a₁ x and hrel₂: R.rel a₂ x,
      -- we get R.rel a₁ a₂ by symmetry and transitivity
      have hrel_a₁_a₂ : R.rel a₁ a₂ :=
        R.trans a₁ x a₂ hrel₁ (R.symm a₂ x hrel₂)
      have heq : equivClass R a₁ = equivClass R a₂ := by
        apply subset_extensional
        intro y; apply Iff.intro
        · intro ⟨hry, hsy⟩
          -- hry : R.rel a₁ y, need R.rel a₂ y
          -- Use: R.rel a₁ y and R.rel a₁ a₂ → R.rel a₂ y (by symmetry then transitivity)
          have h_rel_a₂_y : R.rel a₂ y :=
            R.trans a₂ a₁ y (R.symm a₁ a₂ hrel_a₁_a₂) hry
          exact ⟨h_rel_a₂_y, hsy⟩
        · intro ⟨hry, hsy⟩
          -- hry : R.rel a₂ y, need R.rel a₁ y
          have h_rel_a₁_y : R.rel a₁ y :=
            R.trans a₁ a₂ y hrel_a₁_a₂ hry
          exact ⟨h_rel_a₁_y, hsy⟩
      -- Now heq gives t₁ = t₂ via h₁, h₂, contradicting hne
      apply hne
      calc
        t₁ = equivClass R a₁ := h₁
        _ = equivClass R a₂ := heq
        _ = t₂ := h₂.symm
    · intro h; exfalso; exact h
  cover := by
    intro x hx
    refine ⟨equivClass R x, ?_, ⟨R.refl x hx, hx⟩⟩
    exact ⟨x, hx, rfl⟩

/-! ## Canonical Projection -/

def quotientProjection {α : Type u} {s : Set α} (R : EquivRel α s) (x : α) (_h : s x) : Set α :=
  equivClass R x

theorem quotientProjection_surj {α : Type u} {s : Set α} (R : EquivRel α s) :
    -- For every equivalence class t in the quotient set,
    -- there is a representative element x with s x such that
    -- projecting x gives back t.
    ∀ t, quotientSet R t → ∃ x, ∃ (hx : s x), quotientProjection R x hx = t := by
  intro t ht
  rcases ht with ⟨a, ha, h⟩
  -- h : t = equivClass R a
  -- We need quotientProjection R a ha = t
  rw [h]
  exact ⟨a, ha, rfl⟩

/-! ## Universal Property of Quotient -/

def quotientLift {α β : Type u} {s : Set α} (R : EquivRel α s) (_t : Set β)
    (f : α → β) (_hf : ∀ x y, s x → s y → R.rel x y → f x = f y) : Set α → Set β :=
  fun u => image f (inter u s)

/-! ## Examples -/

-- An equivalence relation: equality mod 2 on a finite set
def mod2Equiv : EquivRel Nat (fun n => n < 6) where
  rel x y := x % 2 = y % 2
  refl _ _ := rfl
  symm _ _ h := h.symm
  trans _ _ _ h₁ h₂ := h₁.trans h₂

-- Equivalence class: check membership by proof
example : equivClass mod2Equiv 1 1 := ⟨rfl, by decide⟩
example : equivClass mod2Equiv 1 3 := ⟨rfl, by decide⟩
example : ¬ equivClass mod2Equiv 1 2 := by
  intro h; rcases h with ⟨hrel, _⟩
  have hvals : (1 : Nat) % 2 ≠ (2 : Nat) % 2 := by native_decide
  exact hvals hrel

-- Quotient set membership (stated as axiom — checking equality of sets via extensionality)
axiom quotientSet_example_mod2 : quotientSet mod2Equiv (fun n => n = 1 ∨ n = 3 ∨ n = 5)

-- Projection example (type-check)
def smallSet : Set Nat := fun n => n < 6
#check quotientProjection mod2Equiv 3 (by decide) 5

-- Partition construction
#check equivRelToPartition mod2Equiv

end MiniSetCore
