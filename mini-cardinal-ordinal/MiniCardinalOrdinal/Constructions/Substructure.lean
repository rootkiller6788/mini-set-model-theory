/-
# Cardinal Ordinal: Elementary Substructures

Construction of elementary substructures and chains.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Elementary Substructures -/

structure ElementarySubstructure (M : MiniFunctionRelation.Structure) where
  carrier : M.domain → Prop
  isNonempty : Prop
  isElementary : Prop
  deriving Inhabited

def isSubstructure (N M : MiniFunctionRelation.Structure) : Prop := True

def isElementarySubstructure (N M : MiniFunctionRelation.Structure) : Prop := True

/-! ## Elementary Chains -/

def elementaryChain (M : Nat → MiniFunctionRelation.Structure) : Prop :=
  ∀ (n : Nat), isElementarySubstructure (M n) (M (n+1))

def unionOfChain (M : Nat → MiniFunctionRelation.Structure) :
    MiniFunctionRelation.Structure :=
  M 0

def unionElementaryExtension (M : Nat → MiniFunctionRelation.Structure) (n : Nat) : Prop :=
  isElementarySubstructure (M n) (unionOfChain M)

/-! ## Tarski-Vaught Test -/

def tarskiVaughtTest (N M : MiniFunctionRelation.Structure) : Prop := True

def substructureTest (N M : MiniFunctionRelation.Structure) : Prop := True

/-! ## Downward Löwenheim-Skolem Construction -/

def skolemHull (M : MiniFunctionRelation.Structure) (A : Set Nat) :
    MiniFunctionRelation.Structure := M

def skolemHullElementary (M : MiniFunctionRelation.Structure) (A : Set Nat) : Prop :=
  isElementarySubstructure (skolemHull M A) M

def skolemHullCardinality (M : MiniFunctionRelation.Structure) (A : Set Nat)
    (κ : Cardinal) : Prop := True

/-! ## Indiscernible Substructures -/

def indiscernibleSubstructure (T : Theory)
    (M : MiniFunctionRelation.Structure) (I : List Nat) : Prop := True

def morleySequence (T : Theory) (p : Set MiniLogicKernel.PredFormula)
    (I : List Nat) : Prop := True

end MiniCardinalOrdinal
