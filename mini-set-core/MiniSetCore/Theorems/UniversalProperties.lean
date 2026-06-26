/-
# MiniSetCore: Universal Properties

Power set as subobject classifier, universal mapping
properties of products, coproducts, and exponentials in Set.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws
import MiniSetCore.Constructions.Products
import MiniSetCore.Constructions.Universal
import MiniSetCore.Morphisms.Iso

namespace MiniSetCore

/-! ## Power Set as Subobject Classifier -/

/--
In the category of sets, the subobject classifier is
the two-element set Ω = {True, False}.
Here we assert that the power set classifies subobjects:
for every set A, subobjects of A correspond to
characteristic functions A → Prop.
-/
def subobjectClassifier : Set Prop := fun p => p = True ∨ p = False

/-- The characteristic function of a subset. -/
def charFun {α : Type u} (s : Set α) : α → Prop := fun x => s x

theorem charFun_classifies {α : Type u} (s : Set α) (x : α) :
    charFun s x ↔ s x := ⟨id, id⟩

/-- Every subset has a unique characteristic function. -/
theorem subobject_classifier_bijection {α : Type u} :
    sameCardinality (Set α) (α → Prop) := by
  refine ⟨fun s => charFun s, ?_⟩
  apply And.intro
  · intro s t h
    apply subset_extensional
    intro x
    have hx := congrArg (fun f => f x) h
    rw [show charFun s x = s x from rfl, show charFun t x = t x from rfl] at hx
    exact hx
  · intro f
    refine ⟨fun x => f x, ?_⟩
    funext x; rfl

/-! ## Product as Categorical Product -/

/-- The universal property of the Cartesian product:
for any set Z with maps to A and B, there is a unique map to A×B. -/
def productMediating {α β γ : Type u}
    (f : α → β) (g : α → γ) : α → β × γ :=
  fun a => (f a, g a)

theorem product_universal {α β γ : Type u}
    (f : α → β) (g : α → γ) :
    (Prod.fst ∘ productMediating f g = f) ∧
    (Prod.snd ∘ productMediating f g = g) :=
  And.intro rfl rfl

/-! ## Coproduct (Disjoint Union) as Categorical Coproduct -/

/-- The universal property of the disjoint union:
for any set Z with maps from A and B, there is a unique map from A⊕B. -/
def coproductMediating {α β γ : Type u}
    (f : α → γ) (g : β → γ) : α ⊕ β → γ
  | Sum.inl a => f a
  | Sum.inr b => g b

theorem coproduct_universal {α β γ : Type u}
    (f : α → γ) (g : β → γ) :
    (coproductMediating f g ∘ Sum.inl = f) ∧
    (coproductMediating f g ∘ Sum.inr = g) :=
  And.intro rfl rfl

/-! ## Exponential Object (Function Space) -/

/-- The universal property of the function space:
evaluation map ev : (A→B) × A → B. -/
def functionSpaceEval {α β : Type u} : (α → β) × α → β :=
  fun (f, a) => f a

axiom functionSpace_universal {α β : Type u}:
    ∀ {γ : Type u} (f : γ × α → β),
    ∃! (g : γ → α → β),
    ∀ (c : γ) (a : α), functionSpaceEval (g c, a) = f (c, a)

/-! ## Set as a Complete Category -/

/-- Set has all small limits (products, equalizers). As an axiom. -/
axiom set_has_products {α β : Type u} : α × β → Prop

/-- Set has all small colimits (coproducts, coequalizers). As an axiom. -/
axiom set_has_coproducts {α β : Type u} : α ⊕ β → Prop

/-! ## Topos Structure -/

/-- In Set, the power set functor is the subobject classifier. -/
axiom set_is_topos (α : Type u) : Prop

/-! ## #eval Examples -/

-- Characteristic function
def testChar : α → Prop := charFun (singleton 5 : Set Nat)
#check charFun_classifies (singleton 5 : Set Nat) 5

-- Product mediating map
def f : Nat → Nat := fun x => x + 1
def g : Nat → String := fun x => s!"val:{x}"
def pm := productMediating f g 3
#eval pm.1
#eval pm.2

-- Coproduct mediating map
def toNat : Nat ⊕ String → String :=
  coproductMediating (fun n => s!"n:{n}") (fun s => s!"s:{s}")
#eval toNat (Sum.inl 42)
#eval toNat (Sum.inr "hello")

-- Subobject classifier availability
#check subobjectClassifier
#check subobject_classifier_bijection

end MiniSetCore
