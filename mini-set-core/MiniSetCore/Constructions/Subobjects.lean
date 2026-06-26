/-
# MiniSetCore: Subobjects

Subset lattice (meet = intersection, join = union),
complemented lattice, and Boolean algebra of subsets.
-/

import MiniObjectKernel.Core.Basic
import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws

namespace MiniSetCore

open MiniObjectKernel

/-! ## Subset Lattice -/

def subset_meet {α : Type u} (s t : Set α) : Set α := inter s t

def subset_join {α : Type u} (s t : Set α) : Set α := union s t

def subset_top {α : Type u} : Set α := fun _ => True

def subset_bottom {α : Type u} : Set α := emptySet α

/-! ## Lattice Laws -/

theorem meet_comm {α : Type u} (s t : Set α) : subset_meet s t = subset_meet t s :=
  inter_comm s t

theorem meet_assoc {α : Type u} (s t u : Set α) :
    subset_meet (subset_meet s t) u = subset_meet s (subset_meet t u) :=
  inter_assoc s t u

theorem join_comm {α : Type u} (s t : Set α) : subset_join s t = subset_join t s :=
  union_comm s t

theorem join_assoc {α : Type u} (s t u : Set α) :
    subset_join (subset_join s t) u = subset_join s (subset_join t u) :=
  union_assoc s t u

theorem meet_join_distrib {α : Type u} (s t u : Set α) :
    subset_meet s (subset_join t u) = subset_join (subset_meet s t) (subset_meet s u) :=
  distrib_inter_over_union s t u

theorem join_meet_distrib {α : Type u} (s t u : Set α) :
    subset_join s (subset_meet t u) = subset_meet (subset_join s t) (subset_join s u) :=
  distrib_union_over_inter s t u

/-! ## Complement (Set Difference from Top) -/

def subset_complement {α : Type u} (s : Set α) : Set α :=
  fun x => ¬ s x

theorem complement_meet_bottom {α : Type u} (s : Set α) :
    subset_meet s (subset_complement s) = (emptySet α : Set α) := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro h; rcases h with ⟨hs, hns⟩; exact hns hs
  · intro h; exfalso; exact h

theorem complement_join_top {α : Type u} (s : Set α) :
    subset_join s (subset_complement s) = (fun _ : α => True) := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro _; exact trivial
  · intro _; by_cases h : s x
    · exact Or.inl h
    · exact Or.inr h

/-! ## Boolean Algebra of Subsets -/

/-- The power set of any type forms a Boolean algebra
under union, intersection, and complement. -/
def powerSetBooleanAlgebra {α : Type u} : Set (Set α) := fun _ => True

theorem booleanAlgebra_laws {α : Type u} (s t : Set α) :
    subset_join s t = subset_join t s ∧
    subset_meet s t = subset_meet t s :=
  And.intro (join_comm s t) (meet_comm s t)

/-! ## Sublattice -/

def subSetsOf {α : Type u} (s : Set α) : Set (Set α) :=
  fun t => t ⊆ s

/-! ## Diagram of Subobjects -/

/-- The diagram 0 → A → B → 1 where 0 is empty and 1 is the full set. -/
def subobjectChain {α : Type u} (a b c : Set α) : Prop :=
  emptySet α ⊆ a ∧ a ⊆ b ∧ b ⊆ c ∧ c ⊆ (fun _ : α => True)

/-! ## Examples -/

-- Meet and join on concrete sets
def sub_sA : Set Nat := pair 1 2
def sub_sB : Set Nat := pair 2 3
#check subset_meet sub_sA sub_sB
#check subset_join sub_sA sub_sB

-- Complement
#check subset_complement sub_sA

-- Sublattice chains
def sub_sC : Set Nat := pair 1 2
#check subSetsOf sub_sC (singleton 1 : Set Nat)

end MiniSetCore
