/-
# Cardinal Ordinal: Isomorphism Types

Structure isomorphisms and cardinal-based classification.
-/

import MiniCardinalOrdinal.Core.Basic

namespace MiniCardinalOrdinal

/-! ## Structure Isomorphism -/

structure StructureIso (M N : MiniFunctionRelation.Structure) where
  forward : M.domain → N.domain
  backward : N.domain → M.domain
  leftInv : Prop
  rightInv : Prop
  deriving Inhabited

/-! ## Isomorphism Properties -/

def isomorphicStructures (M N : MiniFunctionRelation.Structure) : Prop := True

def isAutomorphism (M : MiniFunctionRelation.Structure)
    (f : StructureIso M M) : Prop := True

def automorphismGroup (M : MiniFunctionRelation.Structure) : Type :=
  StructureIso M M

/-! ## Cardinality Under Isomorphism -/

def isoCardinalPreserving (M N : MiniFunctionRelation.Structure)
    (f : StructureIso M N) : Prop := True

def typesOver (M N : MiniFunctionRelation.Structure) : Nat := 0

def numNonIsomorphicModels (T : Theory) (κ : Cardinal) : Nat := 0

def isCategoricalInPower (T : Theory) (κ : Cardinal) : Prop :=
  numNonIsomorphicModels T κ = 1

/-! ## Vaught's Test for Completeness -/

def vaughtTest (T : Theory) (κ : Cardinal) : Prop :=
  isCategoricalInPower T κ → isComplete T

end MiniCardinalOrdinal
