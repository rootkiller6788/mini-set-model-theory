/-
# Regression Tests -- MiniSetCore

Regression tests ensuring no breaking changes.
-/

import MiniSetCore

open MiniSetCore

/-! ## Basic Definitions Exist -/

-- Verify Set type is usable
#check Set Nat
#check emptySet Nat
#check singleton (1 : Nat)
#check pair (1 : Nat) (2 : Nat)
#check union (emptySet Nat) (emptySet Nat)
#check inter (emptySet Nat) (emptySet Nat)
#check powerSet (emptySet Nat)

-- Verify FinSet
#check FinSet Nat
#check FinSet.empty (α := Nat)
#check FinSet.insert (1 : Nat) FinSet.empty
#check FinSet.toSet
#check FinSet.mem
#check FinSet.size

-- Verify Element
#check Element Nat

-- Verify Relation and Function
#check Relation Nat
#check Function Nat Nat

-- Verify SetFunction
#check SetFunction Nat Nat
#check SetFunction.id Nat

-- Verify CardinalEquivalence
#check CardinalEquivalence Nat Nat

-- Verify cartesianProduct
#check cartesianProduct (emptySet Nat) (emptySet Nat)

-- Verify example sets
#check evenSet
#check primeSet

/-! ## All regression checks passed -/

#eval "Regression checks complete."
