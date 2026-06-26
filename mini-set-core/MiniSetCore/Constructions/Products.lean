/-
# MiniSetCore: Products

Cartesian product, disjoint union (Sum type),
and function space constructions for sets.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws

namespace MiniSetCore

/-! ## Cartesian Product -/

def cartesianProduct {α β : Type u} (s : Set α) (t : Set β) : Set (α × β) :=
  fun p => s p.1 ∧ t p.2

/-! ## Product Projections -/

def productFst {α β : Type u} (p : Set (α × β)) : Set α :=
  fun a => ∃ b, p (a, b)

def productSnd {α β : Type u} (p : Set (α × β)) : Set β :=
  fun b => ∃ a, p (a, b)

/-! ## Disjoint Union (via Sum type) -/

def disjointUnionSum {α β : Type u} (s : Set α) (t : Set β) : Set (α ⊕ β) :=
  disjointUnion s t

/-! ## Sum Inclusion Maps -/

def sumInl {α β : Type u} (s : Set α) : Set (α ⊕ β) :=
  fun x => match x with
  | Sum.inl a => s a
  | Sum.inr _ => False

def sumInr {α β : Type u} (t : Set β) : Set (α ⊕ β) :=
  fun x => match x with
  | Sum.inl _ => False
  | Sum.inr b => t b

/-! ## Function Space as Set -/

def functionSpace {α β : Type u} (_s : Set α) (_t : Set β) : Set (α → β) :=
  fun _ => True

def functionSpaceImage {α β : Type u} (f : α → β) (s : Set α) : Set β :=
  image f s

/-! ## Finite Products -/

def product3 {α : Type u} (s₁ s₂ s₃ : Set α) : Set (α × α × α) :=
  fun p => match p with | (a, b, c) => s₁ a ∧ s₂ b ∧ s₃ c

def pairSet {α β : Type u} [DecidableEq α] [DecidableEq β] (a : α) (b : β) : Set (α × β) :=
  fun p => p = (a, b)

/-! ## Universal Property of Product -/

theorem product_fst_image {α β : Type u} (s : Set α) (t : Set β) (_h : t ≠ emptySet β) :
    productFst (cartesianProduct s t) = s := by
  apply subset_extensional
  intro a; apply Iff.intro
  · intro h'; rcases h' with ⟨b, ⟨ha, _⟩⟩; exact ha
  · -- This direction requires t nonempty; deferred with sorry
    sorry

/-! ## Examples -/

-- Cartesian product of two finite sets
def prodA : Set Nat := pair 1 2
def prodB : Set Nat := pair 3 4
#check cartesianProduct prodA prodB
#check productFst (cartesianProduct prodA prodB)
#check disjointUnionSum prodA prodB (Sum.inl 1)
#check sumInl prodA (Sum.inl 1)

-- Triple product
def t1 : Set Nat := singleton 1
def t2 : Set Nat := singleton 2
def t3 : Set Nat := singleton 3
#check product3 t1 t2 t3 (1, (2, 3))

end MiniSetCore
