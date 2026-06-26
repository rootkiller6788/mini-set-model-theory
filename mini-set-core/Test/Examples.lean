/-
# Examples Tests -- MiniSetCore

Additional example-based tests.
-/

import MiniSetCore

open MiniSetCore

/-! ## Finite Set Construction -/

def myFinSet : FinSet Nat :=
  .insert 10 (.insert 20 (.insert 30 .empty))

#eval FinSet.size myFinSet
#eval FinSet.mem 20 myFinSet
#eval FinSet.mem 15 myFinSet

/-! ## Set Operations on FinSet.toSet -/

def mySet := FinSet.toSet myFinSet
#eval mem 10 mySet
#eval mem 30 mySet
#eval mem 40 mySet

/-! ## Nested Sets -/

def nested : Set (Set Nat) :=
  fun s => subset s (pair 1 2 : Set Nat)

#eval nested (singleton 1)
#eval nested (pair 1 2)

/-! ## Ordered Pair -/

def op : OrderedPair Nat String :=
  { fst := 1, snd := "hello" }

#eval op.fst
#eval op.snd
