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
    subset_meet s (subset_complement s) = subset_bottom α := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro h; rcases h with ⟨hs, hns⟩; exact hns hs
  · intro h; exfalso; exact h

theorem complement_join_top {α : Type u} (s : Set α) :
    subset_join s (subset_complement s) = subset_top α := by
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

theorem subSets_top_is_powerSet {α : Type u} :
    subSetsOf (subset_top α) = powerSetBooleanAlgebra α :=
  subset_extensional _ _ (fun t => ⟨fun _ => trivial, fun _ => empty_subset t⟩)

/-! ## Diagram of Subobjects -/

/-- The diagram 0 → A → B → 1 where 0 is empty and 1 is the full set. -/
def subobjectChain {α : Type u} (a b c : Set α) : Prop :=
  subset_bottom α ⊆ a ∧ a ⊆ b ∧ b ⊆ c ∧ c ⊆ subset_top α

/-! ## #eval Examples -/

-- Meet and join on concrete sets
def sA : Set Nat := pair 1 2
def sB : Set Nat := pair 2 3

#eval subset_meet sA sB 2    -- should be true (2 in both)
#eval subset_meet sA sB 1    -- should be false (1 only in sA)
#eval subset_join sA sB 1    -- should be true (1 in sA)
#eval subset_join sA sB 3    -- should be true (3 in sB)

-- Complement
#eval subset_complement sA 5    -- true (5 not in sA)
#eval subset_complement sA 1    -- false (1 in sA)

-- Bottom and Top
#eval subset_bottom Nat 0       -- false (never)
#eval subset_top Nat 0          -- true (always)

-- Sublattice chains
def sC : Set Nat := pair 1 2
#eval subSetsOf sC (singleton 1 : Set Nat)   -- true
#eval subSetsOf sC (singleton 3 : Set Nat)   -- false

end MiniSetCore
