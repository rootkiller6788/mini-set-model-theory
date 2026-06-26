/-
# MiniSetCore: Objects

Object instance for Set, plus Element, Relation, Function types,
and fundamental operations: image, preimage, injectivity, surjectivity.
-/

import MiniObjectKernel.Core.Basic
import MiniSetCore.Core.Basic

namespace MiniSetCore

open MiniObjectKernel

/-! ## Object Instance -/

instance {α : Type u} : Object (Set α) where
  theory := TheoryName.ofString "SetTheory"
  objName := s!"Set({typeName α})"
  repr _ := "Set(...)"
where
  typeName (β : Type u) : String := "?"

/-! ## Element Structure -/

structure Element (α : Type u) where
  carrier : Set α
  elem : α
  proof : mem elem carrier

/-! ## Relation and Function Abbreviations -/

abbrev Relation (α : Type u) := Set (α × α)

abbrev Function (α β : Type u) := Set (α × β)

/-! ## Ordered Pair -/

structure OrderedPair (α β : Type u) where
  fst : α
  snd : β

/-! ## Image and Preimage -/

def image {α β : Type u} (f : α → β) (s : Set α) : Set β :=
  fun y => ∃ x, s x ∧ f x = y

def preimage {α β : Type u} (f : α → β) (t : Set β) : Set α :=
  fun x => t (f x)

def inverseImage {α β : Type u} (f : α → β) (t : Set β) : Set α :=
  preimage f t

/-! ## Set Comprehension -/

def setComprehension {α : Type u} (P : α → Prop) : Set α := P

/-! ## Disjoint Union (via Sum type) -/

def disjointUnion {α β : Type u} (s : Set α) (t : Set β) : Set (α ⊕ β) :=
  fun x => match x with
  | Sum.inl a => s a
  | Sum.inr b => t b

/-! ## Injectivity, Surjectivity, Bijectivity -/

def isInjective {α β : Type u} (f : α → β) : Prop :=
  ∀ x y, f x = f y → x = y

def isSurjective {α β : Type u} (f : α → β) : Prop :=
  ∀ y, ∃ x, f x = y

def isBijective {α β : Type u} (f : α → β) : Prop :=
  isInjective f ∧ isSurjective f

/-! ## Theory Registration -/

def registerSetTheory : IO Unit := do
  IO.println "SetTheory registered as Object instance"

/-! ## #eval Examples -/

-- Ordered pair construction
def examplePair : OrderedPair Nat String := { fst := 42, snd := "hello" }
#eval examplePair.fst
#eval examplePair.snd

-- Image of a finite set via FinSet
def nums : FinSet Nat := .insert 1 (.insert 2 (.insert 3 .empty))
def double (n : Nat) : Nat := 2 * n
#eval FinSet.size nums

-- Preimage of a singleton
#eval mem 1 (preimage (fun x : Nat => x + 1) (singleton 2 : Set Nat))

-- Disjoint union membership
def sA : Set Nat := pair 1 2
def sB : Set Nat := pair 3 4
#eval mem (Sum.inl 1) (disjointUnion sA sB)
#eval mem (Sum.inl 5) (disjointUnion sA sB)
#eval mem (Sum.inr 3) (disjointUnion sA sB)

-- Injectivity check on concrete functions
#eval isInjective (fun (x : Nat) => x)      -- identity is injective
#eval isInjective (fun (_ : Nat) => 0)      -- constant is not

end MiniSetCore
