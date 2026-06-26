/-
# Order Equivalence: Object Instances

Concrete first-order structures, order structures, equivalence
structures, and utility constructors for building structures.
L2-L3: Core concepts and math structures.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

open MiniLogicKernel

/-! ## Structure Constructors -/

/-- A structure with domain α and a single binary predicate r.
    predInterp 0 is the binary relation r. -/
def mkOrderStructure (α : Type) (r : α → α → Prop) (defaultElem : α) : Structure where
  domain := α
  predInterp
    | 0, [x, y] => r x y
    | _, _ => False
  constInterp _ := defaultElem

/-- A structure with a unary predicate p on domain α. -/
def mkUnaryPredicateStructure (α : Type) (p : α → Prop) (defaultElem : α) : Structure where
  domain := α
  predInterp
    | 0, [x] => p x
    | _, _ => False
  constInterp _ := defaultElem

/-- A structure with a binary equivalence relation. -/
def mkEquivalenceStructure (α : Type) [Nonempty α] (r : α → α → Prop) : Structure where
  domain := α
  predInterp
    | 0, [x, y] => r x y
    | _, _ => False
  constInterp _ := Classical.choice (by infer_instance)

/-! ## Derived Order Relations -/

/-- Strict order (<) from a non-strict order (≤). -/
def strictFromNonStrict {α : Type} (r : α → α → Prop) (x y : α) : Prop :=
  r x y ∧ ¬ r y x

/-- Non-strict order (≤) from a strict order (<). -/
def nonStrictFromStrict {α : Type} (r : α → α → Prop) (x y : α) : Prop :=
  r x y ∨ x = y

/-- The dual/converse of a binary relation. -/
def converseRelation {α : Type} (r : α → α → Prop) (x y : α) : Prop :=
  r y x

/-! ## Relation Properties -/

/-- Reflexivity: r x x for all x. -/
def isReflexive {α : Type} (r : α → α → Prop) : Prop := ∀ x, r x x

/-- Transitivity: r x y ∧ r y z → r x z. -/
def isTransitive {α : Type} (r : α → α → Prop) : Prop :=
  ∀ x y z, r x y → r y z → r x z

/-- Antisymmetry: r x y ∧ r y x → x = y. -/
def isAntisymmetric {α : Type} (r : α → α → Prop) : Prop :=
  ∀ x y, r x y → r y x → x = y

/-- Symmetry: r x y → r y x. -/
def isSymmetric {α : Type} (r : α → α → Prop) : Prop :=
  ∀ x y, r x y → r y x

/-- Totality: for all x, y, either r x y or r y x. -/
def isTotal {α : Type} (r : α → α → Prop) : Prop :=
  ∀ x y, r x y ∨ r y x

/-! ## Concrete Structure Catalogue -/

/-- Nat with the standard non-strict order ≤. -/
def NatOrderStructure : Structure :=
  mkOrderStructure Nat (· ≤ ·) 0

/-- Nat with the strict order <. -/
def NatStrictOrderStructure : Structure :=
  mkOrderStructure Nat (· < ·) 0

/-- Int with the standard order ≤. -/
def IntOrderStructure : Structure :=
  mkOrderStructure Int (· ≤ ·) 0

/-- Int with divisibility as a binary predicate (a | b). -/
def IntDivisibilityStructure : Structure where
  domain := Int
  predInterp
    | 0, [a, b] => a ∣ b
    | _, _ => False
  constInterp
    | 0 => 1
    | _ => 0

/-- A countable dense linear order (Nat × Nat with cross-multiplication). -/
def RationalOrderStructure : Structure := RatLikeOrder

/-- A structure with both equality (pred 0) and order (pred 1). -/
def DoublePredStructure (α : Type) [Nonempty α] (r : α → α → Prop) : Structure where
  domain := α
  predInterp
    | 0, [x, y] => x = y
    | 1, [x, y] => r x y
    | _, _ => False
  constInterp _ := Classical.choice (by infer_instance)

/-- A two-element structure distinguishing elements by predicate. -/
def TwoElementDistinguished : Structure where
  domain := Bool
  predInterp
    | 0, [true] => True
    | 0, [false] => False
    | _, _ => False
  constInterp _ := true

/-- Parity structure: predInterp 0 is "n is even". -/
def ParityStructure : Structure where
  domain := Nat
  predInterp
    | 0, [n] => n % 2 = 0
    | _, _ => False
  constInterp _ := 0

/-- Successor structure: predInterp 0 is "y = x+1". -/
def SuccessorStructure : Structure where
  domain := Nat
  predInterp
    | 0, [x, y] => y = x + 1
    | _, _ => False
  constInterp _ := 0

/-- The trivial structure on a type (all predicates true). -/
def trivialOn (α : Type) [Nonempty α] : Structure where
  domain := α
  predInterp _ _ := True
  constInterp _ := Classical.choice (by infer_instance)

/-- The trivial one-element (Unit) structure. -/
def UnitTrivialStructure : Structure := trivialOn Unit

/-! ## Structure Operations -/

/-- Relabel predicate indices by applying f. -/
def relabelPredicates (M : Structure) (f : Nat → Nat) : Structure where
  domain := M.domain
  predInterp p args := M.predInterp (f p) args
  constInterp := M.constInterp

/-- Relabel constant indices by applying f. -/
def relabelConstants (M : Structure) (f : Nat → Nat) : Structure where
  domain := M.domain
  predInterp := M.predInterp
  constInterp c := M.constInterp (f c)

/-- Keep only the first n predicate symbols (reduct). -/
def reduct (M : Structure) (n : Nat) : Structure where
  domain := M.domain
  predInterp p args :=
    if p < n then M.predInterp p args else False
  constInterp := M.constInterp

/-- Add a new predicate at position k. -/
def expandByPredicate (M : Structure) (k : Nat) (predFn : List M.domain → Prop) : Structure where
  domain := M.domain
  predInterp p args :=
    if p < k then M.predInterp p args
    else if p = k then predFn args
    else M.predInterp (p - 1) args
  constInterp := M.constInterp

/-- Add a new constant at position k with value val. -/
def expandByConstant (M : Structure) (k : Nat) (val : M.domain) : Structure where
  domain := M.domain
  predInterp := M.predInterp
  constInterp c :=
    if c < k then M.constInterp c
    else if c = k then val
    else M.constInterp (c - 1)

/-! ## Cardinality Utilities -/

/-- Cardinality as Option Nat: none = infinite, some n = n elements. -/
def cardinality (M : Structure) : Option Nat :=
  if h : Nonempty (Fintype M.domain) then
    let inst : Fintype M.domain := Classical.choice h
    some (@Fintype.card M.domain inst)
  else
    none

/-- A structure has exactly n elements. -/
def hasExactly (M : Structure) (n : Nat) : Prop :=
  ∃ (h : Fintype M.domain), @Fintype.card M.domain h = n

/-! ## `#eval` Verification -/

#eval (NatOrderStructure.satisfies (.prop .true) [] : Prop)
#eval strictFromNonStrict (· ≤ · : Nat → Nat → Prop) 3 5
#eval nonStrictFromStrict (· < · : Nat → Nat → Prop) 3 5
#eval converseRelation (· ≤ · : Nat → Nat → Prop) 5 3
#eval isReflexive (· ≤ · : Nat → Nat → Prop)
#eval isTransitive (· ≤ · : Nat → Nat → Prop)
#eval cardinality (FinOrderStructure 3)
#eval cardinality NatOrderStructure
#eval ParityStructure.predInterp 0 [4]
#eval ParityStructure.predInterp 0 [5]
#eval IntDivisibilityStructure.predInterp 0 [6, 12]
#eval TwoElementDistinguished.predInterp 0 [true]

end MiniOrderEquivalence

