import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Finite Structures

Concrete examples of finite structures: graphs as structures, finite
linear orders, and the two-element Boolean algebra.
-/

-- 1. A graph as a structure: domain = vertices, pred binary edge relation
def GraphStruct (V : Type) (defaultVertex : V) (E : V → V → Prop) : Structure where
  domain := V
  predInterp p args := match p, args with
    | 0, [u, v] => E u v
    | _, _ => False
  constInterp _ := defaultVertex

-- Convenient version for nonempty types
def GraphStruct' [Nonempty V] (V : Type) (E : V → V → Prop) : Structure :=
  GraphStruct V (Classical.choice (by infer_instance)) E

-- 2. Complete graph on n elements
def CompleteGraph (n : Nat) : Structure where
  domain := Fin n
  predInterp p args := match p, args with
    | 0, [u, v] => u ≠ v
    | _, _ => False
  constInterp _ := 0

-- Graph homomorphism preserves edges
def GraphHom {V1 V2 : Type} {v1 : V1} {v2 : V2} {E1 : V1 → V1 → Prop} {E2 : V2 → V2 → Prop}
    (f : V1 → V2) (h : ∀ u v, E1 u v → E2 (f u) (f v)) :
    Hom (GraphStruct V1 v1 E1) (GraphStruct V2 v2 E2) where
  map := f
  preservesPred p args hpred := by
    dsimp [GraphStruct]
    cases p
    · cases args
      · trivial
      · rename_i a as
        cases as
        · trivial
        · rename_i b bs
          cases bs
          · exact h a b hpred
          · trivial
    · trivial
  preservesConst _ := rfl

-- 3. Finite linear order as structure
def LinOrderStruct (n : Nat) : Structure where
  domain := Fin n
  predInterp p args := match p, args with
    | 0, [u, v] => u.val ≤ v.val
    | _, _ => False
  constInterp _ := 0

-- Order-preserving map is a homomorphism
def OrderPreservingHom {n m : Nat} (f : Fin n → Fin m) (h : ∀ u v, u.val ≤ v.val → (f u).val ≤ (f v).val) :
    Hom (LinOrderStruct n) (LinOrderStruct m) where
  map := f
  preservesPred p args hpred := by
    dsimp [LinOrderStruct]
    cases p
    · cases args
      · trivial
      · rename_i a as
        cases as
        · trivial
        · rename_i b bs
          cases bs
          · exact h a b hpred
          · trivial
    · trivial
  preservesConst _ := rfl

-- 4. The two-element structure with a unary predicate
def TwoElementStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [b] => b = true
    | _, _ => False
  constInterp 0 := true
  constInterp _ := false

-- The swap map is an isomorphism of the symmetric two-element structure
def SwapIso : Iso TwoElementStruct TwoElementStruct where
  toHom := {
    map := λ b => !b
    preservesPred p args h := by
      dsimp [TwoElementStruct]
      cases p
      · cases args
        · trivial
        · rename_i a as
          cases as
          · simp at h ⊢
            rcases h with rfl
            rfl
          · trivial
      · trivial
    preservesConst c := by
      simp [TwoElementStruct]
      cases c <;> rfl
  }
  invHom := {
    map := λ b => !b
    preservesPred p args h := by
      dsimp [TwoElementStruct]
      cases p
      · cases args
        · trivial
        · rename_i a as
          cases as
          · simp at h ⊢
            rcases h with rfl
            rfl
          · trivial
      · trivial
    preservesConst c := by
      simp [TwoElementStruct]
      cases c <;> rfl
  }
  leftInv x := by simp
  rightInv y := by simp

-- eval examples
#eval (CompleteGraph 3).domain
#eval (LinOrderStruct 5).constInterp 0
#eval SwapIso.toHom.map true
#eval SwapIso.toHom.map false
#eval "All finite structure examples defined"

end MiniFunctionRelation
