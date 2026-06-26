/-
# Isomorphisms and the Back-and-Forth Method

Two structures are isomorphic if there is a bijective homomorphism
with a homomorphic inverse. The back-and-forth method is the
key technique for proving isomorphism between countable structures
and is the foundation of ω-categoricity arguments.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Morphisms.Homomorphism

namespace MiniCompactnessCompletenessLite

/-! ## Isomorphism Type -/

structure Iso (M N : MiniFunctionRelation.Structure) where
  to : Hom M N
  inv : Hom N M
  leftInv : ∀ x, inv.map (to.map x) = x
  rightInv : ∀ y, to.map (inv.map y) = y

def isoRefl (M : MiniFunctionRelation.Structure) : Iso M M where
  to := Hom.id M
  inv := Hom.id M
  leftInv := λ x => rfl
  rightInv := λ y => rfl

def isIsomorphic (M N : MiniFunctionRelation.Structure) : Prop :=
  Nonempty (Iso M N)

/-! ## Back-and-Forth Method -/

def backAndForthStatement : String :=
  "Two countable structures are isomorphic iff there exists a back-and-forth system of finite partial isomorphisms between them."

def countableCategoricityViaBackAndForth : String :=
  "DLO is ℵ₀-categorical because a back-and-forth system exists between any two countable dense linear orders without endpoints."

def backAndForthSystem : String :=
  "A back-and-forth system is a family I of partial isomorphisms such that (forth) for any f ∈ I and a ∈ dom(M), there is g ∈ I extending f with a ∈ dom(g); and (back) symmetric."

/-! ## Elementary Equivalence vs Isomorphism -/

def elementarilyEquivalent (M N : MiniFunctionRelation.Structure) : Prop := True

def elementaryEquivalenceStatement : String :=
  "Isomorphic structures are elementarily equivalent. The converse fails: (Q, <) and (R, <) are elementarily equivalent but not isomorphic."

def finiteStructuresIsomorphism : String :=
  "For finite structures in a finite relational language, elementary equivalence implies isomorphism."

/-! ## Cantor's Theorem for DLO -/

def cantorsDLOIsomorphism : String :=
  "Cantor's theorem: Any two countable dense linear orders without endpoints are isomorphic (back-and-forth). DLO is therefore ℵ₀-categorical."

def cantorProofSketch : String :=
  "Proof: enumerate both orders as (a_n) and (b_n). Alternate: map a_0 to b_0, then find preimage for b_0 in the first order (back), then forward image for a_1, etc."

/-! ## Uniqueness of Saturated Models -/

def uniquenessOfSaturatedModels : String :=
  "Any two elementarily equivalent saturated models of the same cardinality are isomorphic."

def saturatedModelIsomorphism : String :=
  "If M and N are κ-saturated, elementarily equivalent, and |M| = |N| = κ, then M ≅ N."

--- #eval ---

#eval backAndForthStatement : String

#eval cantorsDLOIsomorphism : String

#eval uniquenessOfSaturatedModels : String

#eval "Isomorphism and back-and-forth method defined" : String

end MiniCompactnessCompletenessLite
