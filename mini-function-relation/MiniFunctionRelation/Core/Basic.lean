/-
# Function Relation: Structure Homomorphisms

Structure type and homomorphism framework for first-order structures.
-/

import MiniObjectKernel.Core.Basic

namespace MiniFunctionRelation

/--
A first-order structure \( \mathfrak{M} = (M, (R_i), (c_j)) \) where:
- `domain` is the underlying set M
- `predInterp n (a₁,...,a_{arity})` interprets each predicate symbol (by index)
- `constInterp n` interprets each constant symbol (by index)
-/
structure Structure where
  domain : Type
  predInterp : Nat → List domain → Prop
  constInterp : Nat → domain

/--
The cardinality (as a string) of the domain of a structure.
-/
def Structure.card (S : Structure) : String := s!"|{toString S.domain}|"

/--
Two structures are isomorphic if there exists a bijection
between domains that preserves all predicate and constant interpretations.
-/
structure Iso (M N : Structure) where
  map : M.domain → N.domain
  inv : N.domain → M.domain
  left_inv : ∀ x, inv (map x) = x
  right_inv : ∀ y, map (inv y) = y
  predPreserving : ∀ n (args : List M.domain), M.predInterp n args ↔ N.predInterp n (args.map map)
  constPreserving : ∀ n, map (M.constInterp n) = N.constInterp n

/--
A substructure A ≤ M is a subset of the domain closed under constants and
with induced predicate interpretations.
-/
structure SubStructure (M : Structure) where
  carrier : Set M.domain
  closedUnderConstants : ∀ n, M.constInterp n ∈ carrier
  nonempty : carrier.Nonempty

/--
The trivial one-element structure on `Unit`.
-/
def trivialStructure : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/--
An empty structure has no elements (domain = Empty).
-/
def emptyStructure : Structure where
  domain := Empty
  predInterp _ _ := False
  constInterp n := nomatch n

/--
Injective endomorphism from a structure to itself.
-/
def isEmbedding (M N : Structure) (f : M.domain → N.domain) : Prop :=
  ∀ n (args : List M.domain), M.predInterp n args ↔ N.predInterp n (args.map f)

/--
A surjective homomorphism from M onto N.
-/
def isSurjective (M N : Structure) (f : M.domain → N.domain) : Prop :=
  Function.Surjective f ∧ ∀ n, f (M.constInterp n) = N.constInterp n

#eval "Structure type defined: domain, predInterp, constInterp"
#eval s!"trivialStructure.card = {trivialStructure.card}"
#eval "Iso, SubStructure, isEmbedding, isSurjective defined"
#eval "Core.Basic loaded — MiniFunctionRelation namespace active"

end MiniFunctionRelation
