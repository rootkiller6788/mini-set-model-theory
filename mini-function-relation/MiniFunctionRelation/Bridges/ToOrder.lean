import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso
import MiniFunctionRelation.Examples.FiniteStructures

namespace MiniFunctionRelation

/-
# Bridge: Structure → Order

Connects Structure to order theory. Many structures carry a natural
partial order; order-preserving homomorphisms are a special case.
-/

-- A structure carries a designated order predicate at index 0
-- The actual order axioms are captured by `IsPoset` below.

-- Order-preserving homomorphism
def IsOrderPreserving {M N : Structure} (f : Hom M N) : Prop :=
  ∀ x y, M.predInterp 0 [x, y] → N.predInterp 0 [f.map x, f.map y]

structure OrderHom (M N : Structure) extends Hom M N where
  orderPreserving : ∀ x y, M.predInterp 0 [x, y] → N.predInterp 0 [map x, map y]

def OrderHom.id (M : Structure) : OrderHom M M where
  toHom := Hom.id M
  orderPreserving x y h := h

def OrderHom.comp {M N O : Structure} (g : OrderHom N O) (f : OrderHom M N) : OrderHom M O where
  toHom := Hom.comp g.toHom f.toHom
  orderPreserving x y h := g.orderPreserving (f.map x) (f.map y) (f.orderPreserving x y h)

-- A structure is a poset if pred 0 is a partial order
def IsPoset (M : Structure) : Prop :=
  (∀ x, M.predInterp 0 [x, x]) ∧                                    -- reflexivity
  (∀ x y, M.predInterp 0 [x, y] → M.predInterp 0 [y, x] → x = y) ∧  -- antisymmetry
  (∀ x y z, M.predInterp 0 [x, y] → M.predInterp 0 [y, z] →
    M.predInterp 0 [x, z])                                           -- transitivity

-- The natural numbers as a poset
def NatPoset : Structure where
  domain := Nat
  predInterp p args := match p, args with
    | 0, [x, y] => x ≤ y
    | _, _ => False
  constInterp _ := 0

theorem natPoset_isPoset : IsPoset NatPoset := by
  refine ⟨?_, ?_, ?_⟩
  · intro x; exact Nat.le_refl x
  · intro x y h1 h2; exact Nat.le_antisymm h1 h2
  · intro x y z h1 h2; exact Nat.le_trans h1 h2

-- Order isomorphism
structure OrderIso (M N : Structure) extends Iso M N where
  orderPreserving : ∀ x y, M.predInterp 0 [x, y] ↔ N.predInterp 0 [toHom.map x, toHom.map y]

-- Concrete test: identity order hom on NatPoset
def idOrderHom : OrderHom NatPoset NatPoset := OrderHom.id NatPoset

-- Embedding of smaller poset into larger
def PosetEmbed {n m : Nat} (h : n ≤ m) (f : Fin n → Fin m) : Structure :=
  LinOrderStruct n

-- eval examples
#eval "Order bridge defined"
#eval "Natural poset: reflexive, antisymmetric, transitive"
#eval "Order-preserving homomorphisms"

end MiniFunctionRelation
