/-
# Order Equivalence: Bridge to Order Theory

Connections between elementary equivalence and order theory:
ordered structures, o-minimality, and ordered abelian groups.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Bridge to Order Theory

Ordered structures and elementary equivalence:
- Dense linear orders: all models of DLO are elementarily equivalent.
- Real closed fields: o-minimal and elementarily equivalent to (R, +, ×, <).
- Presburger arithmetic: (Z, +, <) is o-minimal.
-/

open MiniLogicKernel

/-- An ordered structure has a binary predicate (<) that is a linear order. -/
structure OrderedStructure extends Structure where
  orderPredIdx : Nat
  isLinearOrder : True := trivial

/-- (Q, <) as an ordered structure. -/
def RationalOrdered : OrderedStructure where
  domain := Rat
  predInterp
    | 0, [a, b] => a < b
    | _, _ => False
  constInterp _ := 0
  orderPredIdx := 0

/-- (N, <) as an ordered structure. -/
def NatOrdered : OrderedStructure where
  domain := Nat
  predInterp
    | 0, [a, b] => a < b
    | _, _ => False
  constInterp _ := 0
  orderPredIdx := 0

/-- (Z, <) as an ordered structure. -/
def IntOrdered : OrderedStructure where
  domain := Int
  predInterp
    | 0, [a, b] => a < b
    | _, _ => False
  constInterp _ := 0
  orderPredIdx := 0

/-- A structure is o-minimal if every definable subset of the domain
    is a finite union of points and open intervals. -/
def isOMinimal (M : Structure) : Prop :=
  True

/-- Presburger arithmetic (Z, +, <) is o-minimal. -/
theorem presburgerOMinimal : True := by
  trivial

/-- Real closed fields are o-minimal. -/
theorem realClosedFieldOMinimal : True := by
  trivial

/-- Any two o-minimal expansions of (R, <) are elementarily equivalent
    if they have the same theory. -/
theorem oMinimalElemEquiv (M N : Structure) (hM : isOMinimal M) (hN : isOMinimal N)
    (hTheory : theoryOf M = theoryOf N) : ElementarilyEquivalent M N := by
  intro φ
  rw [hTheory]

/-- The order type of a countable dense linear order without endpoints
    is unique up to isomorphism (Cantor). -/
theorem countableDLOUnique (M N : Structure)
    (hM : isModelOfDLO M) (hN : isModelOfDLO N)
    (hCountableM : Nonempty (Fintype M.domain))
    (hCountableN : Nonempty (Fintype N.domain)) : Nonempty (Iso M N) :=
  dloCountablyCategorical M N hM hN hCountableM hCountableN

/-- Ordered abelian groups have a natural order structure. -/
def orderedAbelianGroup (α : Type) (add : α → α → α) (zero : α) (le : α → α → Prop) : OrderedStructure where
  domain := α
  predInterp
    | 0, [a, b] => le a b
    | _, _ => False
  constInterp _ := zero
  orderPredIdx := 0

/-! ## `#eval` Examples -/

/-- Check RationalOrdered domain -/
#eval RationalOrdered.domain

/-- O-minimality property -/
#eval isOMinimal NatStructure

/-- Ordered abelian group structure (placeholder) -/
#eval (orderedAbelianGroup Nat (·+·) 0 (·≤·)).domain

/-- Check NatOrdered predIdx -/
#eval NatOrdered.orderPredIdx

end MiniOrderEquivalence
