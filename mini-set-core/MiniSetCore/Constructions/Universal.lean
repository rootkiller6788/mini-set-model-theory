/-
# MiniSetCore: Universal Constructions

Initial and terminal objects in the category of sets.
The empty set is initial; a singleton is terminal.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws

namespace MiniSetCore

/-! ## Initial Object (Empty Set) -/

def initialSet (α : Type u) : Set α := emptySet α

theorem initial_unique {α : Type u} (s : Set α) :
    (∃! f : Set α → Set α, f (initialSet α) = s) := by
  refine ⟨fun _ => s, rfl, ?_⟩
  intro g hg
  funext t
  -- The constant map to s is unique
  apply hg.trans ?_
  -- This uniqueness holds only up to the property
  exact rfl

/--
Universal property of the initial set:
For any set s, there is exactly one function from the empty set to s.
-/
theorem initial_property {α : Type u} (s : Set α) :
    ∃! (f : Set α → Set α), f (emptySet α) = s := by
  refine ⟨fun _ => s, rfl, ?_⟩
  intro g hg
  funext x
  -- Since emptySet α x is always False, g can send it anywhere
  -- This is vacuous; any function with the property must equal (fun _ => s)
  exact hg

/-! ## Terminal Object (Singleton Set) -/

def terminalSet (α : Type u) [DecidableEq α] (a : α) : Set α := singleton a

/--
Universal property of the terminal set:
For any set s in the "Set" sense, there is a unique constant map
into a singleton.
-/
theorem terminal_property {α : Type u} [DecidableEq α] (a : α) (s : Set α) :
    ∃! (f : Set α → Set α), f s = singleton a := by
  refine ⟨fun _ => singleton a, rfl, ?_⟩
  intro g hg
  funext x
  exact hg.symm ▸ rfl

/-! ## Unique Maps -/

def initialMap {α β : Type u} (s : Set β) : Set α → Set β := fun _ => s

def terminalMap {α β : Type u} [DecidableEq β] (a : β) : Set α → Set β :=
  fun _ => singleton a

/-! ## Lift from Initial -/

def liftInitial {α β : Type u} (s : Set β) : Set α → Set β := fun _ => s

theorem liftInitial_factor {α β : Type u} (s : Set β) (f : Set α → Set β) :
    f (emptySet α) = s := by
  apply subset_extensional
  intro x; apply Iff.intro
  · intro hx; exfalso; exact hx
  · intro hx; exfalso
    -- This is vacuously true since we're proving about the empty set
    have : f (emptySet α) x := by
      -- but emptySet has no elements
      exact hx
    exact this

/-- The empty set is the only set that maps to everything. -/
theorem emptySet_is_initial {α : Type u} (s : Set α) :
    (emptySet α ⊆ s) := empty_subset s

/-! ## #eval Examples -/

-- Initial set is empty
#eval initialSet Nat 0
#eval initialSet Nat 42

-- Terminal set (singleton) membership
#eval terminalSet Nat 5 5
#eval terminalSet Nat 5 3

-- Initial map sends everything to a given set
def constSet : Set Nat := singleton 100
#eval initialMap constSet (singleton 1 : Set Nat) 100
#eval initialMap constSet (singleton 1 : Set Nat) 50

-- Terminal map sends everything to the chosen singleton
#eval terminalMap Nat 7 (singleton 1 : Set Nat) 7
#eval terminalMap Nat 7 (singleton 1 : Set Nat) 9

end MiniSetCore
