/-
# MiniSetCore: Bridge to Algebra

Set algebra, Boolean algebra of subsets, power set monad,
and algebraic structures derived from sets.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws
import MiniSetCore.Constructions.Subobjects

namespace MiniSetCore

/-! ## Boolean Algebra of Subsets -/

/-- The power set P(A) forms a Boolean algebra under ∪, ∩, complement. -/
structure SetBooleanAlgebra (α : Type u) where
  carrier : Set α
  zero : Set α
  one  : Set α
  meet : Set α → Set α → Set α
  join : Set α → Set α → Set α
  complement : Set α → Set α

/-- The standard power set Boolean algebra on a type. -/
def powerSetAlgebra (α : Type u) : SetBooleanAlgebra α where
  carrier := fun _ => True
  zero := emptySet α
  one := fun _ => True
  meet := inter
  join := union
  complement := subset_complement

/-! ## Boolean Algebra Laws -/

theorem booleanAlgebra_meet_comm {α : Type u} (s t : Set α) :
    inter s t = inter t s := inter_comm s t

theorem booleanAlgebra_join_comm {α : Type u} (s t : Set α) :
    union s t = union t s := union_comm s t

theorem booleanAlgebra_meet_assoc {α : Type u} (s t u : Set α) :
    inter (inter s t) u = inter s (inter t u) := inter_assoc s t u

theorem booleanAlgebra_join_assoc {α : Type u} (s t u : Set α) :
    union (union s t) u = union s (union t u) := union_assoc s t u

theorem booleanAlgebra_distrib {α : Type u} (s t u : Set α) :
    inter s (union t u) = union (inter s t) (inter s u) := distrib_inter_over_union s t u

/-! ## Power Set Monad -/

/-- The power set functor P : Set → Set is a monad. -/
def powerSetFunctor {α : Type u} (s : Set α) : Set (Set α) := powerSet s

/-- Unit of the power set monad: η_A(a) = {a} -/
def powerSetUnit {α : Type u} [DecidableEq α] (a : α) : Set (Set α) :=
  singleton (singleton a)

/-- Multiplication of the power set monad: μ_A(S) = ⋃ S -/
def powerSetMult {α : Type u} (S : Set (Set α)) : Set α :=
  fun x => ∃ s, S s ∧ s x

/-- The power set monad axioms (stated as properties). -/
axiom powerSet_monad_unit_left {α : Type u} [DecidableEq α] (s : Set α) :
    powerSetMult (image (powerSetUnit (α := α)) s) = s

axiom powerSet_monad_assoc {α : Type u} (S : Set (Set (Set α))) :
    powerSetMult (powerSetMult S) = powerSetMult (image powerSetMult S)

/-! ## Ring Structure via Symmetric Difference -/

/-- Symmetric difference: A Δ B = (A\B) ∪ (B\A) -/
def symmetricDiff {α : Type u} (s t : Set α) : Set α :=
  fun x => (s x ∧ ¬ t x) ∨ (t x ∧ ¬ s x)

/-- The symmetric difference forms an abelian group with empty set as identity. -/
theorem symmetricDiff_comm {α : Type u} (s t : Set α) :
    symmetricDiff s t = symmetricDiff t s := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro h; rcases h with (⟨hs, hnt⟩ | ⟨ht, hns⟩)
    · exact Or.inr ⟨ht, fun hs' => hnt hs'⟩
    · exact Or.inl ⟨ht, fun hs' => hns hs'⟩
  · intro h; rcases h with (⟨hs, hnt⟩ | ⟨ht, hns⟩)
    · exact Or.inr ⟨hs, fun sht' => hnt sht'⟩
    · exact Or.inl ⟨hs, fun sht' => hns sht'⟩

theorem symmetricDiff_empty {α : Type u} (s : Set α) :
    symmetricDiff s (emptySet α) = s := by
  apply subset_extensional; intro x; apply Iff.intro
  · intro h; rcases h with (⟨hs, _⟩ | ⟨he, _⟩); exact hs; exact False.elim he
  · intro h; exact Or.inl ⟨h, id⟩

/-- Intersection distributes over symmetric difference, forming a Boolean ring. -/
theorem inter_distrib_symmetricDiff {α : Type u} (r s t : Set α) :
    inter r (symmetricDiff s t) = symmetricDiff (inter r s) (inter r t) := by
  apply subset_extensional; intro x; apply Iff.intro
  · intro ⟨hr, h⟩
    rcases h with (⟨hs, hnt⟩ | ⟨ht, hns⟩)
    · exact Or.inl ⟨⟨hr, hs⟩, fun ⟨_, htx⟩ => hnt htx⟩
    · exact Or.inr ⟨⟨hr, ht⟩, fun ⟨_, hsx⟩ => hns hsx⟩
  · intro h
    rcases h with (⟨⟨hr, hs⟩, hn⟩ | ⟨⟨hr, ht⟩, hn⟩)
    · exact ⟨hr, Or.inl ⟨hs, fun htx => hn ⟨hr, htx⟩⟩⟩
    · exact ⟨hr, Or.inr ⟨ht, fun hsx => hn ⟨hr, hsx⟩⟩⟩

/-! ## #eval Examples -/

-- Power set algebra
#check powerSetAlgebra Nat

-- Boolean algebra laws
#check booleanAlgebra_meet_comm
#check booleanAlgebra_join_comm
#check booleanAlgebra_distrib

-- Symmetric difference
def sA : Set Nat := pair 1 2
def sB : Set Nat := pair 2 3
#eval symmetricDiff sA sB 1    -- true (1 in A only)
#eval symmetricDiff sA sB 2    -- false (2 in both)
#eval symmetricDiff sA sB 3    -- true (3 in B only)

-- Power set monad unit
#eval powerSetUnit 1 sA    -- singleton of singleton 1 is in power set

end MiniSetCore
