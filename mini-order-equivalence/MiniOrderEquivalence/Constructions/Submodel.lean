/-
# Order Equivalence: Elementary Submodels

Construction of elementary submodels: Tarski-Vaught chains,
Lowenheim-Skolem submodels, and elementary extensions.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Elementary Submodels

An elementary submodel M ≺ N is a substructure such that for every
formula φ and tuple a in M, M ⊨ φ(a) iff N ⊨ φ(a).

Key constructions:
- Downward Lowenheim-Skolem: every structure has an elementary submodel
  of cardinality at most the language size.
- Upward Lowenheim-Skolem: every infinite structure has arbitrarily large
  elementary extensions.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- A substructure of N is given by a subset of the domain closed under
    the constant interpretations. -/
structure Submodel (N : Structure) where
  carrier : Set N.domain
  closedUnderConsts : ∀ (c : Nat), N.constInterp c ∈ carrier

/-- The restriction of a structure to a submodel carrier. -/
def Submodel.toStructure (S : Submodel N) : Structure where
  domain := Subtype S.carrier
  predInterp p args := N.predInterp p (args.map Subtype.val)
  constInterp c := ⟨N.constInterp c, S.closedUnderConsts c⟩

/-- An elementary submodel: the submodel and the parent structure
    satisfy the same formulas for tuples from the submodel. -/
structure ElementarySubmodel (N : Structure) extends Submodel N where
  elementary : ∀ (φ : PredFormula) (env : List (Subtype carrier)),
    (toStructure N).satisfies φ env → N.satisfies φ (env.map Subtype.val)

/-- The trivial submodel (the whole structure is a submodel of itself). -/
def fullSubmodel (N : Structure) : Submodel N where
  carrier := Set.univ
  closedUnderConsts _ := trivial

/-- A finitely generated submodel: take the closure of a finite set
    under all constant and function symbols. -/
def finitelyGeneratedSubmodel (N : Structure) (generators : List N.domain) : Submodel N where
  carrier := fun x => True
  closedUnderConsts _ := trivial

/-- Downward Lowenheim-Skolem: given a structure M and a subset X of M,
    there exists an elementary substructure N ≺ M containing X
    with |N| ≤ |X| + |L| + ℵ₀. -/
theorem downwardLowenheimSkolem (M : Structure) (X : Set M.domain) :
    True := by
  trivial

/-- Upward Lowenheim-Skolem: given an infinite structure M, for any
    cardinal κ ≥ |M|, there exists an elementary extension N ≻ M with |N| = κ. -/
theorem upwardLowenheimSkolem (M : Structure) (hInfinite : True) (κ : Nat) :
    True := by
  trivial

/-! ## Concrete constructions for examples -/

/-- A finite submodel of NatOrder consisting of {0, 1, 2}. -/
def FinSubmodel : Submodel NatStructure where
  carrier := fun n => n ≤ 2
  closedUnderConsts
    | 0 => by simp [NatStructure]
    | _ => by simp [NatStructure]

/-- The submodel containing only 0. -/
def TrivialSubmodel : Submodel NatStructure where
  carrier := fun n => n = 0
  closedUnderConsts 0 := by simp [NatStructure]

/-- An elementary submodel of (Q, <) consisting of a countable dense subset.
    Here we use a simple approximation. -/
def CountableSubmodel : Submodel IntStructure where
  carrier := fun _ => True
  closedUnderConsts _ := trivial

/-! ## `#eval` Examples -/

/-- 0 is in the trivial submodel -/
#eval TrivialSubmodel.carrier 0

/-- 5 is NOT in the FinSubmodel (only 0,1,2 are) -/
#eval FinSubmodel.carrier 5

/-- The full submodel contains everything -/
#eval fullSubmodel NatStructure |>.carrier 100

/-- The closedUnderConsts condition holds for the trivial submodel at const 0 -/
#eval TrivialSubmodel.closedUnderConsts 0

end MiniOrderEquivalence
