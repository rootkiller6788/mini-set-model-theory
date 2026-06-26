/-
# MiniSetCore: Set Morphisms (Hom)

SetFunction and SetHom — functions between sets,
structure-preserving maps, and isomorphisms.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws

namespace MiniSetCore

/-! ## SetFunction -/

structure SetFunction (α β : Type u) where
  mapping : α → β
  domain : Set α

/-! ## Identity and Composition -/

def SetFunction.id (α : Type u) : SetFunction α α where
  mapping := λ a => a
  domain := emptySet α

def SetFunction.comp {α β γ : Type u}
    (g : SetFunction β γ) (f : SetFunction α β) : SetFunction α γ where
  mapping := g.mapping ∘ f.mapping
  domain := f.domain

def SetFunction.restrict {α β : Type u} (f : SetFunction α β) (s : Set α) : SetFunction α β where
  mapping := f.mapping
  domain := s

/-! ## Structure-Preserving Maps (SetHom) -/

structure SetHom (α β : Type u) where
  map : Set α → Set β
  preserves_empty : map (emptySet α) = emptySet β
  preserves_union : ∀ s t, map (union s t) = union (map s) (map t)

def SetHom.id (α : Type u) : SetHom α α where
  map s := s
  preserves_empty := rfl
  preserves_union := fun _ _ => rfl

def SetHom.comp {α β γ : Type u} (g : SetHom β γ) (f : SetHom α β) : SetHom α γ where
  map := g.map ∘ f.map
  preserves_empty := by
    simp [f.preserves_empty, g.preserves_empty, Function.comp_apply]
  preserves_union := fun s t => by
    simp [f.preserves_union, g.preserves_union, Function.comp_apply]

/-! ## Monic and Epic Maps -/

def SetFunction.isMonic {α β : Type u} (f : SetFunction α β) : Prop :=
  isInjective f.mapping

def SetFunction.isEpic {α β : Type u} (f : SetFunction α β) : Prop :=
  isSurjective f.mapping

/-! ## Isomorphism Condition for Sets -/

def areIsomorphic {α β : Type u} (s : Set α) (t : Set β) : Prop :=
  ∃ (f : α → β) (g : β → α),
    (isInjective f) ∧ (isSurjective f) ∧
    (∀ x, s x → t (f x)) ∧
    (∀ y, t y → s (g y))

/-! ## Image via SetFunction -/

def SetFunction.image {α β : Type u} (f : SetFunction α β) (s : Set α) : Set β :=
  fun y => ∃ x, s x ∧ inter s f.domain x ∧ f.mapping x = y

/-! ## #eval Examples -/

def addOne (x : Nat) : Nat := x + 1
def sfAdd : SetFunction Nat Nat where
  mapping := addOne
  domain := fun n => n < 10

#eval sfAdd.mapping 5
#eval sfAdd.mapping 42

-- Identity composition
def sfId := SetFunction.id Nat
#eval sfId.mapping 99

-- Composition
def sfComp := SetFunction.comp sfAdd sfAdd
#eval sfComp.mapping 5

-- SetHom construction: identity on subsets
def identityHom : SetHom Nat Nat where
  map s := s
  preserves_empty := rfl
  preserves_union := fun _ _ => rfl

-- SetHom: constant-empty map (sends every set to emptySet)
def constEmptyHom : SetHom Nat Nat where
  map _ := emptySet Nat
  preserves_empty := rfl
  preserves_union := by
    intro s t; apply subset_extensional
    intro x; simp [union, emptySet]

#check identityHom.map (singleton 1 : Set Nat) 1

end MiniSetCore
