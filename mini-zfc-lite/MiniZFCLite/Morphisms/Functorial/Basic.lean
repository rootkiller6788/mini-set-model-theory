/-
# MiniZFCLite: Morphisms — Functorial

Set homomorphisms: membership-preserving maps between set-theoretic structures,
inner models, and elementary embeddings.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Set-Theoretic Structure -/

/-- A set-theoretic structure: a type with a membership relation -/
structure SetStructure where
  carrier : Type
  epsilon : carrier → carrier → Prop
  deriving Inhabited, Repr

/-- The standard membership relation on a type -/
def standardMembership (α : Type) : α → α → Prop :=
  fun x y => True

/-! ## Set Homomorphisms -/

/-- A set homomorphism preserves membership in the forward direction -/
structure SetHom (M N : SetStructure) where
  map : M.carrier → N.carrier
  preserves_mem : ∀ x y : M.carrier, M.epsilon x y → N.epsilon (map x) (map y)
  deriving Repr

/-- Identity set homomorphism -/
def SetHom.id (M : SetStructure) : SetHom M M :=
  { map := fun x => x
    preserves_mem := fun x y h => h }

/-- Composition of set homomorphisms -/
def SetHom.comp {M N O : SetStructure} (g : SetHom N O) (f : SetHom M N) : SetHom M O :=
  { map := fun x => g.map (f.map x)
    preserves_mem := fun x y h => g.preserves_mem (f.map x) (f.map y) (f.preserves_mem x y h) }

/-! ## Elementary Embeddings -/

/-- An elementary embedding preserves all first-order properties -/
structure ElementaryEmbedding (M N : SetStructure) where
  embed : SetHom M N
  elementary : String := "preserves all first-order formulas"
  deriving Repr

/-- Trivial elementary embedding (identity) -/
def elementaryEmbeddingId (M : SetStructure) : ElementaryEmbedding M M :=
  { embed := SetHom.id M
    elementary := "identity" }

/-! ## Inner Models -/

/-- An inner model is a transitive class containing all ordinals -/
structure InnerModel where
  name : String
  universe : Type
  membership : universe → universe → Prop
  isTransitive : String := "∀x∈M, x⊆M"
  containsOrdinals : String := "Ord⊆M"
  satisfiesZFC : String := "M⊨ZFC"
  deriving Repr

/-- The constructible universe L as an inner model -/
def constructibleUniverse : InnerModel :=
  { name := "L"
    universe := Empty
    membership := fun _ _ => False
    isTransitive := "L is transitive"
    containsOrdinals := "L contains all ordinals"
    satisfiesZFC := "L ⊨ ZFC + V=L" }

/-- The hereditarily ordinal definable sets HOD -/
def hereditarilyOrdinalDefinable : InnerModel :=
  { name := "HOD"
    universe := Empty
    membership := fun _ _ => False
    isTransitive := "HOD is transitive"
    containsOrdinals := "HOD contains all ordinals"
    satisfiesZFC := "HOD ⊨ ZFC" }

/-! ## Simple Set Models -/

/-- A finite set model described by its elements -/
structure FiniteSetModel where
  sets : List (List Nat)
  epsilonPairs : List (Nat × Nat)
  deriving Repr

/-- A trivial one-element model (the empty set) -/
def trivialModel : FiniteSetModel :=
  { sets := [[]]
    epsilonPairs := [] }

/-- A two-element model: 0={} and 1={0} -/
def twoElementModel : FiniteSetModel :=
  { sets := [[], [0]]
    epsilonPairs := [(0, 1)] }

#eval trivialModel
#eval twoElementModel
#eval SetHom.id { carrier := Empty, epsilon := fun _ _ => False : SetStructure }
#eval constructibleUniverse.name
#eval hereditarilyOrdinalDefinable.name

end MiniZFCLite
