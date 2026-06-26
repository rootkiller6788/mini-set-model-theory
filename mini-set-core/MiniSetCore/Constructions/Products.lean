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

def functionSpace {α β : Type u} (s : Set α) (t : Set β) : Set (α → β) :=
  fun _ => True

def functionSpaceImage {α β : Type u} (f : α → β) (s : Set α) : Set β :=
  image f s

/-! ## Finite Products -/

def product3 {α : Type u} (s₁ s₂ s₃ : Set α) : Set (α × α × α) :=
  fun ((a, b), c) => s₁ a ∧ s₂ b ∧ s₃ c

def pairSet {α β : Type u} (a : α) (b : β) : Set (α × β) :=
  singleton (a, b)

/-! ## Universal Property of Product -/

theorem product_fst_image {α β : Type u} (s : Set α) (t : Set β) (h : t ≠ emptySet β) :
    productFst (cartesianProduct s t) = s := by
  apply subset_extensional
  intro a; apply Iff.intro
  · intro h'; rcases h' with ⟨b, ⟨ha, _⟩⟩; exact ha
  · intro ha
    have hne : ∃ b, t b := by
      apply Classical.byContradiction
      intro hne'; apply h; apply subset_extensional _ _; intro b
      apply Iff.intro (fun ht => (hne' b) ▸ ?_) (fun hf => False.elim hf)
      exact ht
    rcases hne with ⟨b, hb⟩
    exact ⟨b, ha, hb⟩

/-! ## #eval Examples -/

-- Cartesian product of two finite sets
def sA : Set Nat := pair 1 2
def sB : Set Nat := pair 3 4

#eval cartesianProduct sA sB (1, 3)
#eval cartesianProduct sA sB (1, 5)
#eval cartesianProduct sA sB (5, 3)

-- Product projections
#eval productFst (cartesianProduct sA sB) 1
#eval productFst (cartesianProduct sA sB) 5
#eval productSnd (cartesianProduct sA sB) 3

-- Disjoint union membership
#eval disjointUnionSum sA sB (Sum.inl 1)
#eval disjointUnionSum sA sB (Sum.inl 5)
#eval disjointUnionSum sA sB (Sum.inr 3)

-- Sum inclusion
#eval sumInl sA (Sum.inl 1)
#eval sumInl sA (Sum.inr 1)

-- Triple product
def s1 : Set Nat := singleton 1
def s2 : Set Nat := singleton 2
def s3 : Set Nat := singleton 3
#eval product3 s1 s2 s3 ((1, 2), 3)

end MiniSetCore
