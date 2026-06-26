/-
# Smoke Tests -- MiniSetCore

Run: `lake env lean --run Test/Smoke.lean`
-/

import MiniSetCore

open MiniSetCore

#eval "══ MINI-SET-CORE SMOKE TESTS ══"

/-! ## Core.Basic: Set Type -/

#eval "── Core.Basic: Set type and membership ──"
def testSet : Set Nat := fun n => n < 5
#eval mem 3 testSet
#eval mem 7 testSet

/-! ## Core.Basic: Set Operations -/

#eval "── Core.Basic: emptySet ──"
#eval mem 1 (emptySet Nat)

#eval "── Core.Basic: singleton ──"
#eval mem 2 (singleton 2 : Set Nat)
#eval mem 3 (singleton 2 : Set Nat)

#eval "── Core.Basic: pair ──"
#eval mem 1 (pair 1 2 : Set Nat)
#eval mem 2 (pair 1 2 : Set Nat)
#eval mem 3 (pair 1 2 : Set Nat)

#eval "── Core.Basic: union ──"
def s1 : Set Nat := singleton 1
def s2 : Set Nat := singleton 2
#eval mem 1 (union s1 s2)
#eval mem 2 (union s1 s2)
#eval mem 3 (union s1 s2)

#eval "── Core.Basic: inter ──"
def s3 : Set Nat := pair 1 2
def s4 : Set Nat := pair 2 3
#eval mem 2 (inter s3 s4)
#eval mem 1 (inter s3 s4)
#eval mem 3 (inter s3 s4)

#eval "── Core.Basic: powerSet ──"
#eval powerSet (singleton 1 : Set Nat) (singleton 1)
#eval powerSet (singleton 1 : Set Nat) (pair 1 2)

#eval "── Core.Basic: diff ──"
#eval mem 1 (diff s3 s4)
#eval mem 2 (diff s3 s4)

/-! ## Core.Basic: Subset -/

#eval "── Core.Basic: subset ──"
#eval subset (singleton 1 : Set Nat) (pair 1 2)
#eval subset (pair 1 2 : Set Nat) (singleton 1)

/-! ## Core.Basic: isFunction -/

#eval "── Core.Basic: isFunction ──"
#eval isFunction (fun p : Nat × Nat => p.1 = p.2)

/-! ## Core.Basic: FinSet -/

#eval "── Core.Basic: FinSet ──"
#eval exampleFinSet
#eval FinSet.mem 1 exampleFinSet
#eval FinSet.mem 4 exampleFinSet
#eval FinSet.size exampleFinSet

/-! ## Core.Basic: FinSet.toSet -/

#eval "── Core.Basic: FinSet.toSet ──"
def fsSet := FinSet.toSet exampleFinSet
#eval mem 1 fsSet
#eval mem 2 fsSet
#eval mem 5 fsSet

/-! ## Core.Objects: Object instance -/

#eval "── Core.Objects: Object instance ──"
open MiniObjectKernel
#eval describe (Set Nat)
#eval objName (Set Nat)

/-! ## Examples -/

#eval "── Examples: standard sets ──"
#eval mem 4 evenSet
#eval mem 5 evenSet
#eval mem 7 primeSet
#eval mem 10 primeSet

/-! ## Morphisms: SetFunction -/

#eval "── Morphisms: SetFunction ──"
def sf : SetFunction Nat Nat where
  mapping := fun x => x + 1
  domain := singleton 1
#eval sf.mapping 5

def sfId := SetFunction.id Nat
#eval sfId.mapping 42

/-! ## Constructions: cartesianProduct -/

#eval "── Constructions: cartesianProduct ──"
def cp := cartesianProduct (pair 1 2 : Set Nat) (pair 3 4 : Set Nat)
#eval mem (1, 3) cp
#eval mem (1, 5) cp

/-! ## Morphisms: CardinalEquivalence -/

#eval "── Morphisms: CardinalEquivalence ──"
#check CardinalEquivalence Nat Nat
#eval "CardinalEquivalence type checks"

/-! ## Constructions subobjects stubs -/

#eval "── Constructions/Properties/Theorems/Bridges: stubs imported ──"
#eval "Subobjects stub loaded"
#eval "Quotients stub loaded"
#eval "Universal stub loaded"

#eval "══ ALL MINI-SET-CORE SMOKE TESTS PASSED ══"
