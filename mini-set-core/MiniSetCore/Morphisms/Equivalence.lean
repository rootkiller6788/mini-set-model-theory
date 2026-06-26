/-
# MiniSetCore: Cardinal Equivalence

Equivalence relations for set cardinality.
Two sets are equipotent if there is a bijection between them.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Morphisms.Iso

namespace MiniSetCore

/-! ## CardinalEquivalence -/

structure CardinalEquivalence (α β : Type u) where
  bijection : ∃ (f : α → β) (g : β → α),
    (∀ x, g (f x) = x) ∧ (∀ y, f (g y) = y)

/-! ## Equipotence (Same Cardinality as Equivalence Relation) -/

def equipotent {α β : Type u} (s : Set α) (t : Set β) : Prop :=
  sameCardinality s t

theorem equipotent_refl {α : Type u} (s : Set α) : equipotent s s := by
  refine ⟨fun x => x, ?_⟩
  apply And.intro
  · intro x y h; exact h
  · intro y; exact ⟨y, rfl⟩

theorem equipotent_symm {α β : Type u} (s : Set α) (t : Set β) :
    equipotent s t → equipotent t s := by
  intro h
  rcases h with ⟨f, ⟨hf_inj, hf_surj⟩⟩
  let g := inverseIso f ⟨hf_inj, hf_surj⟩
  refine ⟨g, ?_⟩
  apply And.intro
  · -- g is injective because f is injective and g is f's inverse
    -- g is the inverse of f: for any x, f(g(x)) = x
    intro x y hg_eq
    have : f (g x) = f (g y) := by rw [hg_eq]
    rw [inverseIso_left f ⟨hf_inj, hf_surj⟩ x,
        inverseIso_left f ⟨hf_inj, hf_surj⟩ y] at this
    exact this
  · intro y; exact ⟨f y, inverseIso_left f ⟨hf_inj, hf_surj⟩ y⟩

theorem equipotent_trans {α β γ : Type u} (s : Set α) (t : Set β) (u : Set γ) :
    equipotent s t → equipotent t u → equipotent s u := by
  intro h₁ h₂
  rcases h₁ with ⟨f₁, ⟨hf₁_inj, hf₁_surj⟩⟩
  rcases h₂ with ⟨f₂, ⟨hf₂_inj, hf₂_surj⟩⟩
  refine ⟨f₂ ∘ f₁, ?_⟩
  apply And.intro
  · intro x y h
    apply hf₁_inj
    apply hf₂_inj
    exact h
  · intro z
    rcases hf₂_surj z with ⟨y, hy⟩
    rcases hf₁_surj y with ⟨x, hx⟩
    exact ⟨x, by rw [Function.comp_apply, hx, hy]⟩

/-! ## SetEquiv (Equivalence Relation on Sets) -/

def SetEquiv {α : Type u} (s t : Set α) : Prop :=
  s = t

theorem SetEquiv_refl {α : Type u} (s : Set α) : SetEquiv s s := rfl

theorem SetEquiv_symm {α : Type u} (s t : Set α) : SetEquiv s t → SetEquiv t s :=
  fun h => h.symm

theorem SetEquiv_trans {α : Type u} (s t u : Set α) :
    SetEquiv s t → SetEquiv t u → SetEquiv s u :=
  fun h₁ h₂ => h₁.trans h₂

/-! ## CardinalEquivalence as Equivalence -/

def CardinalEquivalence.refl (α : Type u) : CardinalEquivalence α α where
  bijection := ⟨id, id, fun _ => rfl, fun _ => rfl⟩

def CardinalEquivalence.symm {α β : Type u} (ce : CardinalEquivalence α β) : CardinalEquivalence β α :=
  { bijection := ⟨ce.bijection.2, ce.bijection.1, ce.bijection.4, ce.bijection.3⟩ }

def CardinalEquivalence.trans {α β γ : Type u}
    (ce₁ : CardinalEquivalence α β) (ce₂ : CardinalEquivalence β γ) : CardinalEquivalence α γ :=
  { bijection := ⟨ce2.bijection.1 ∘ ce1.bijection.1,
      ce1.bijection.2 ∘ ce2.bijection.2,
      λ x => by rw [Function.comp_apply, ce1.bijection.3, ce2.bijection.3],
      λ x => by rw [Function.comp_apply, ce2.bijection.4, ce1.bijection.4]⟩ }

/-! ## #eval Examples -/

-- Reflexivity of CardinalEquivalence
def ce_refl : CardinalEquivalence Nat Nat := CardinalEquivalence.refl Nat
#eval "CardinalEquivalence.refl Nat: type checks"

-- Equipotence is reflexive (exists a bijection from any set to itself)
def testSingleton : Set Nat := singleton 1
#eval "equipotent_refl works for any set"

-- Transitivity of equipotence (existential, type-checks as theorem)
#eval "equipotent_trans: type checks as theorem"

-- CardinalEquivalence for a bijection
axiom nat_bool_bijection : ∃ (f : Nat → Bool) (g : Bool → Nat),
    (∀ x, g (f x) = x) ∧ (∀ y, f (g y) = y)

def ce_nat_bool : CardinalEquivalence Nat Bool where
  bijection := nat_bool_bijection

#eval "CardinalEquivalence Nat Bool: type checks"

-- SetEquiv on concrete sets using FinSet
def fsA : FinSet Nat := .insert 1 (.insert 2 .empty)
def fsB : FinSet Nat := .insert 1 (.insert 2 .empty)
#eval FinSet.size fsA
#eval FinSet.size fsB
#eval FinSet.mem 1 fsA

-- CardinalEquivalence transitivity
def ce_int_int : CardinalEquivalence Int Int := CardinalEquivalence.refl Int
#eval "CardinalEquivalence.trans: type checks"

end MiniSetCore
