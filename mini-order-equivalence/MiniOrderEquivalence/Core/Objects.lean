/-
# Order Equivalence: Objects

Object instances for elementary equivalence structures.
-/

import MiniOrderEquivalence.Core.Basic
import MiniFunctionRelation.Core.Basic

namespace MiniOrderEquivalence

/-! ## Object Instances

Object-level instances and registrations for structures under
elementary equivalence.
-/

open MiniFunctionRelation

/-- A structure with a binary order relation.
    predInterp 0 is the order relation (≤). -/
def OrderStructure (α : Type) (r : α → α → Prop) : Structure where
  domain := α
  predInterp
    | 0, [x, y] => r x y
    | _, _ => False
  constInterp _ := Classical.choice (by
    have : Nonempty α := by
      refine ⟨Classical.choice ?_⟩
      exact inferInstance
    exact this)

/-- The strict order (<) derived from a non-strict order (≤). -/
def strictFromNonStrict {α : Type} (r : α → α → Prop) (x y : α) : Prop :=
  r x y ∧ ¬ r y x

/-- The non-strict order (≤) derived from a strict order (<). -/
def nonStrictFromStrict {α : Type} (r : α → α → Prop) (x y : α) : Prop :=
  r x y ∨ x = y

/-- An equivalence relation structure.
    predInterp 0 is the equivalence relation. -/
def EquivStructure (α : Type) (r : α → α → Prop) : Structure where
  domain := α
  predInterp
    | 0, [x, y] => r x y
    | _, _ => False
  constInterp _ := Classical.choice (inferInstance : Nonempty α)

/-- The trivial structure on a type (no relations). -/
def TrivialStructure (α : Type) : Structure where
  domain := α
  predInterp _ _ := True
  constInterp _ := Classical.choice (inferInstance : Nonempty α)

/-- A structure with one constant symbol c₀ = 0. -/
def SingletonStructure : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-! ## `#eval` Examples -/

/-- Create an order structure on Nat with ≤ -/
#eval (OrderStructure Nat (· ≤ ·)).domain

/-- Verify strict order from ≤ on specific values -/
#eval strictFromNonStrict (· ≤ · : Nat → Nat → Prop) 3 5

/-- Create an equivalence structure on Nat with equality -/
#eval (EquivStructure Nat (· = ·)).domain

/-- Trivial structure on Unit -/
#eval (TrivialStructure Unit).domain

end MiniOrderEquivalence
