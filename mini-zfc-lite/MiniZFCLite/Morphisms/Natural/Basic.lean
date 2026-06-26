/-
# MiniZFCLite: Morphisms — Natural

Set isomorphisms: bijective membership-preserving maps,
Mostowski collapse, and transitive models.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Set-Theoretic Structures -/

structure SetStruct where
  carrier : Type
  epsilon : carrier → carrier → Prop
  deriving Inhabited, Repr

/-! ## Set Isomorphisms -/

/-- A set isomorphism is a bijection that preserves and reflects membership -/
structure SetIso (M N : SetStruct) where
  forward : M.carrier → N.carrier
  backward : N.carrier → M.carrier
  forward_preserves : ∀ x y : M.carrier, M.epsilon x y → N.epsilon (forward x) (forward y)
  backward_preserves : ∀ x y : N.carrier, N.epsilon x y → M.epsilon (backward x) (backward y)
  left_inv : ∀ x : M.carrier, backward (forward x) = x
  right_inv : ∀ y : N.carrier, forward (backward y) = y
  deriving Repr

/-- Identity isomorphism -/
def SetIso.id (M : SetStruct) : SetIso M M :=
  { forward := fun x => x
    backward := fun x => x
    forward_preserves := fun x y h => h
    backward_preserves := fun x y h => h
    left_inv := fun _ => rfl
    right_inv := fun _ => rfl }

/-- Inverse isomorphism -/
def SetIso.symm {M N : SetStruct} (i : SetIso M N) : SetIso N M :=
  { forward := i.backward
    backward := i.forward
    forward_preserves := i.backward_preserves
    backward_preserves := i.forward_preserves
    left_inv := i.right_inv
    right_inv := i.left_inv }

/-- Compose isomorphisms -/
def SetIso.trans {M N O : SetStruct} (i1 : SetIso M N) (i2 : SetIso N O) : SetIso M O :=
  { forward := fun x => i2.forward (i1.forward x)
    backward := fun x => i1.backward (i2.backward x)
    forward_preserves := fun x y h => i2.forward_preserves _ _ (i1.forward_preserves _ _ h)
    backward_preserves := fun x y h => i1.backward_preserves _ _ (i2.backward_preserves _ _ h)
    left_inv := fun x => by
      simp [i2.left_inv, i1.left_inv]
    right_inv := fun y => by
      simp [i1.right_inv, i2.right_inv] }

/-! ## Transitive Models -/

/-- A model is transitive if elements of sets in the model are also in the model -/
structure TransitiveModel where
  name : String
  isTransitive : String := "∀x∈M, x⊆M"
  deriving Repr

/-- Check if a collection is transitive (descriptive) -/
def transitivityProperty (name : String) : TransitiveModel :=
  { name := name, isTransitive := s!"{name} is transitive" }

/-! ## Mostowski Collapse -/

/-- The Mostowski collapse of a well-founded extensional structure -/
structure MostowskiCollapse (M : SetStruct) where
  wellFounded : String := "∈ is well-founded on M"
  extensional : String := "M satisfies extensionality"
  collapsingMap : String := "π: M → transitive collapse"
  isIsomorphism : String := "π is an isomorphism onto a transitive set"
  deriving Repr

/-- Mostowski's theorem statement (as a record) -/
def mostowskiTheorem : String :=
  "Every well-founded extensional structure is isomorphic to a unique transitive set via Mostowski collapse"

/-- Example: the collapse of a simple structure -/
def simpleMostowskiInfo : MostowskiCollapse
    { carrier := Unit, epsilon := fun _ _ => False : SetStruct } :=
  { wellFounded := "∈ is vacuously well-founded"
    extensional := "vacuously extensional"
    collapsingMap := "maps unique element to ∅"
    isIsomorphism := "trivially an isomorphism" }

/-! ## Automorphisms -/

/-- An automorphism of a set structure -/
def SetAut (M : SetStruct) := SetIso M M

/-- Identity automorphism -/
def SetAut.id (M : SetStruct) : SetAut M := SetIso.id M

/-! ## Examples and Evaluations -/

/-- A concrete structure on Nat -/
def natStruct : SetStruct :=
  { carrier := Nat
    epsilon := fun m n => m + 1 = n }

#eval "SetIso identity defined"
#eval SetIso.id natStruct |>.forward 0
#eval transitivityProperty "Vκ"
#eval mostowskiTheorem
#eval simpleMostowskiInfo.collapsingMap
#eval "Natural morphisms module loaded"

end MiniZFCLite
