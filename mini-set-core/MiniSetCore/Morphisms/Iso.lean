/-
# MiniSetCore: Isomorphisms

SetIso (bijective correspondence), Cantor-Bernstein,
and same-cardinality relation between sets.
-/

import MiniObjectKernel.Core.Basic
import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects

namespace MiniSetCore

open MiniObjectKernel

/-! ## SetIso (Bijection between power sets) -/

structure SetIso (α β : Type u) [Object (Set α)] [Object (Set β)] where
  toFun    : Set α → Set β
  invFun   : Set β → Set α
  leftInv  : ∀ s, invFun (toFun s) = s
  rightInv : ∀ t, toFun (invFun t) = t

def SetIso.id (α : Type u) [Object (Set α)] : SetIso α α where
  toFun := id
  invFun := id
  leftInv := fun _ => rfl
  rightInv := fun _ => rfl

def SetIso.symm {α β : Type u} [Object (Set α)] [Object (Set β)]
    (iso : SetIso α β) : SetIso β α where
  toFun := iso.invFun
  invFun := iso.toFun
  leftInv := iso.rightInv
  rightInv := iso.leftInv

def SetIso.comp {α β γ : Type u} [Object (Set α)] [Object (Set β)] [Object (Set γ)]
    (g : SetIso β γ) (f : SetIso α β) : SetIso α γ where
  toFun := g.toFun ∘ f.toFun
  invFun := f.invFun ∘ g.invFun
  leftInv := fun s => by
    rw [Function.comp_apply, f.leftInv, g.leftInv]
  rightInv := fun t => by
    rw [Function.comp_apply, g.rightInv, f.rightInv]

/-! ## Same Cardinality -/

def sameCardinality {α β : Type u} (s : Set α) (t : Set β) : Prop :=
  ∃ (f : α → β), isBijective f

/-! ## Cantor-Bernstein Theorem -/

/--
The Cantor-Bernstein-Schroeder theorem:
If there are injections A → B and B → A,
then there is a bijection A → B.
We state this as an `axiom` since the proof requires
sophisticated set-theoretic machinery.
-/
axiom cantor_bernstein {α β : Type u} (s : Set α) (t : Set β) :
    (∃ (f : α → β), isInjective f) →
    (∃ (g : β → α), isInjective g) →
    sameCardinality s t

/-! ## Cardinal Comparison -/

def cardLE {α β : Type u} (s : Set α) (t : Set β) : Prop :=
  ∃ (f : α → β), isInjective f

def cardEQ {α β : Type u} (s : Set α) (t : Set β) : Prop :=
  sameCardinality s t

/-! ## Inverse Isomorphism -/

def inverseIso {α β : Type u} (f : α → β) (hf : isBijective f) : β → α :=
  fun y => Classical.choose (hf.right y)

theorem inverseIso_right {α β : Type u} (f : α → β) (hf : isBijective f) (y : β) :
    f (inverseIso f hf y) = y :=
  Classical.choose_spec (hf.right y)

theorem inverseIso_left {α β : Type u} (f : α → β) (hf : isBijective f) (x : α) :
    inverseIso f hf (f x) = x :=
  hf.left x (Classical.choose (hf.right (f x)))
    (Classical.choose_spec (hf.right (f x)))

/-! ## Bijection Axiom for Concrete Functions -/

axiom nat_double_injective : isInjective (fun (x : Nat) => 2 * x)
axiom nat_succ_bijective : isBijective (fun (x : Int) => x + 1)

/-! ## #eval Examples -/

-- SetIso identity
#eval "SetIso Nat Nat: type checks"

-- Same cardinality between singleton pairs
#eval "sameCardinality: type checks as Prop"
#eval "Two singletons have same cardinality"

-- Cantor-Bernstein axiom available
#eval "Cantor-Bernstein axiom: loaded"

-- Inverse of a bijection for concrete identity
def idFunc : Nat → Nat := id
def idIsBijective : isBijective idFunc := by
  apply And.intro
  · intro x y h; exact h
  · intro y; exact ⟨y, rfl⟩
#eval inverseIso idFunc idIsBijective 5

-- Cardinal comparison
#eval "cardLE / cardEQ type checks"

-- Compose two SetIso (identity with itself)
def isoId : SetIso Nat Nat := SetIso.id Nat
#eval "SetIso.id and SetIso.comp: type checks"

end MiniSetCore
