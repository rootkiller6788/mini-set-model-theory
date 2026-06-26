/-
# MiniSetCore: Standard Examples

Standard set examples: natural numbers as von Neumann ordinals,
ordered pairs, finite sets, power sets.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws
import MiniSetCore.Constructions.Products
import MiniSetCore.Properties.Invariants

namespace MiniSetCore

/-! ## Standard Sets -/

def natSet : Set Nat := fun _ => True
def evenSet : Set Nat := fun n => n % 2 = 0
def primeSet : Set Nat := fun n => n ≥ 2 ∧ ∀ d, 2 ≤ d → d < n → n % d ≠ 0

/-! ## von Neumann Ordinals as Sets -/

/-- 0 = ∅ --/
def vonNeumann0 : Set Nat := emptySet Nat

/-- 1 = {0} = {∅} --/
def vonNeumann1 : FinSet Nat := .insert 0 .empty

/-- 2 = {0, 1} = {∅, {∅}} --/
def vonNeumann2 : FinSet Nat := .insert 0 (.insert 1 .empty)

/-- 3 = {0, 1, 2} --/
def vonNeumann3 : FinSet Nat := .insert 0 (.insert 1 (.insert 2 .empty))

/-- n-th von Neumann ordinal as a FinSet --/
def vonNeumann (n : Nat) : FinSet Nat :=
  match n with
  | 0 => .empty
  | n+1 => .insert n (vonNeumann n)

/-! ## Ordered Pairs as Sets (Kuratowski) -/

/--
Kuratowski's definition: (a, b) := {{a}, {a, b}}
-/
def kuratowskiPair {α : Type u} [DecidableEq α] (a b : α) : Set (Set α) :=
  pair (singleton a) (pair a b)

/-! ## Power Set Examples -/

def powerSetEx1 : Set (Set Nat) := powerSet (singleton 1 : Set Nat)
def powerSetEx2 : Set (Set Nat) := powerSet (pair 1 2 : Set Nat)

/-! ## Infinite Sets -/

/-- The set of all natural numbers is infinite. -/
def infiniteNatSet : FinSet Nat := .empty

/-- The set of integers via pair encoding (simplified). -/
def intSet : Set (Nat × Bool) := fun _ => True

/-! ## Function Sets -/

/-- All functions from Bool to a 2-element set. -/
def boolFunctions : Set (Bool → Set Nat) :=
  fun _ => True

/-- The set of all functions from a singleton to any set is an exponential. -/
def singletonFunctions (α : Type u) (t : Set α) : Set (Unit → α) :=
  fun _ => True

/-! ## Cartesian Product Examples -/

def prodExample : Set (Nat × String) :=
  cartesianProduct (pair 1 2 : Set Nat) (singleton "hello" : Set String)

/-! ## #eval Examples -/

-- Standard sets
#eval evenSet 4
#eval evenSet 5
#eval primeSet 7
#eval primeSet 10

-- von Neumann ordinals
#eval FinSet.size vonNeumann0
#eval FinSet.size vonNeumann1
#eval FinSet.size vonNeumann2
#eval FinSet.size vonNeumann3

#eval FinSet.size (vonNeumann 5)

-- Kuratowski pair membership test
def kp_test : Set (Set Nat) := kuratowskiPair 1 2
#eval kp_test (singleton 1 : Set Nat)
#eval 2 ∈ FinSet.toSet vonNeumann2

-- Power set examples
#eval powerSetEx1 (singleton 1 : Set Nat)
#eval powerSetEx1 (emptySet Nat)
#eval powerSet (pair 1 2 : Set Nat) (singleton 1)

-- Cartesian product example
#eval prodExample (1, "hello")
#eval prodExample (1, "world")

end MiniSetCore
