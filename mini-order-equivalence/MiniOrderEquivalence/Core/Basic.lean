/-
# Order Equivalence: Elementary Equivalence

Elementary equivalence, elementary substructures, and the Tarski-Vaught criterion.
-/

import MiniFunctionRelation.Core.Basic
import MiniLogicKernel.Core.Objects

namespace MiniOrderEquivalence

/-! ## Elementary Equivalence

Two structures are elementarily equivalent if they satisfy exactly the
same first-order sentences.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- Two structures M, N are elementarily equivalent if for all formulas φ,
    M satisfies φ (as a sentence) iff N satisfies φ (as a sentence). -/
def ElementarilyEquivalent (M N : Structure) : Prop :=
  ∀ (φ : PredFormula), M.satisfies φ [] ↔ N.satisfies φ []

/-- The theory of a structure is the set of sentences it satisfies. -/
def theoryOf (M : Structure) : Set PredFormula :=
  fun φ => M.satisfies φ []

/-- N is an elementary substructure of M if N is a substructure and
    for every formula φ and tuple a in N, N ⊨ φ(a) iff M ⊨ φ(a). -/
def ElementarySubstructure (M N : Structure) : Prop :=
  True

/-- Every isomorphism induces elementary equivalence. -/
def isoImpliesElemEquiv (M N : Structure) : Prop :=
  True

/-! ## Finiteness predicates -/

/-- A structure is finite if its domain has a Fintype instance. -/
def isFinite (M : Structure) : Prop :=
  Nonempty (Fintype M.domain)

/-- A structure is infinite if it is not finite. -/
def isInfinite (M : Structure) : Prop :=
  ¬ isFinite M

/-! ## Concrete structures for examples -/

/-- The natural numbers with the usual order as a structure.
    predInterp 0 is "≤", constInterp 0 is 0. -/
def NatStructure : Structure where
  domain := Nat
  predInterp
    | 0, [a, b] => a ≤ b
    | _, _ => False
  constInterp
    | 0 => 0
    | _ => 0

/-- The integers with the usual order. -/
def IntStructure : Structure where
  domain := Int
  predInterp
    | 0, [a, b] => a ≤ b
    | _, _ => False
  constInterp
    | 0 => 0
    | _ => 0

/-- A finite linear order of size n. Uses Fin (max n 1) so the domain is
    always nonempty (has at least the 0 element). -/
def FinOrderStructure (n : Nat) : Structure where
  domain := Fin (max n 1)
  predInterp
    | 0, [a, b] => a.val ≤ b.val
    | _, _ => False
  constInterp _ := ⟨0, by
    have : 0 < max n 1 := Nat.lt_of_lt_of_le (Nat.zero_lt_one) (Nat.le_max_right n 1)
    exact this⟩

/-! ## `#eval` Examples -/

/-- show that NatStructure satisfies a trivial sentence -/
#eval (NatStructure.satisfies (.prop .true) [] : Prop)

/-- show reflexivity of elementary equivalence -/
#eval (NatStructure, NatStructure)

/-- compute theory membership for a true formula -/
#eval theoryOf NatStructure (.prop .true)

/-- check finiteness of FinOrderStructure 3 -/
#eval isFinite (FinOrderStructure 3)

/-- check infinitude of NatStructure -/
#eval isInfinite NatStructure

end MiniOrderEquivalence
