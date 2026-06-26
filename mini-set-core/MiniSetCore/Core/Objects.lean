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

/--
Register `Set α` as an `Object`. Since `Object` is defined for
`Type` (universe 0), we restrict `α : Type`.
-/
instance (α : Type) : Object (Set α) where
  theory := TheoryName.ofString "SetTheory"
  objName := "Set(...)"
  repr _ := "Set(...)"

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
example : mem 1 (preimage (fun x : Nat => x + 1) (singleton 2 : Set Nat)) := rfl

-- Disjoint union membership
def sA : Set Nat := pair 1 2
def sB : Set Nat := pair 3 4
example : disjointUnion sA sB (Sum.inl 1) := by
  simp [disjointUnion, sA, pair]
example : ¬ disjointUnion sA sB (Sum.inl 5) := by
  simp [disjointUnion, sA, pair]
example : disjointUnion sA sB (Sum.inr 3) := by
  simp [disjointUnion, sB, pair]

-- Injectivity check on concrete functions
example : isInjective (fun (x : Nat) => x) := by
  intro x y h; exact h
example : ¬ isInjective (fun (_ : Nat) => 0) := by
  intro h; have := h 0 1 rfl; exact Nat.zero_ne_one this

/-! ## Properties of Injective/Surjective/Bijective -/

theorem injective_comp {α β γ : Type u} (f : α → β) (g : β → γ) :
    isInjective f → isInjective g → isInjective (g ∘ f) := by
  intro hf hg x y h
  apply hf
  apply hg
  exact h

theorem surjective_comp {α β γ : Type u} (f : α → β) (g : β → γ) :
    isSurjective f → isSurjective g → isSurjective (g ∘ f) := by
  intro hf hg z
  rcases hg z with ⟨y, hy⟩
  rcases hf y with ⟨x, hx⟩
  exact ⟨x, by rw [Function.comp_apply, hx, hy]⟩

theorem bijective_comp {α β γ : Type u} (f : α → β) (g : β → γ) :
    isBijective f → isBijective g → isBijective (g ∘ f) := by
  intro ⟨hf_inj, hf_surj⟩ ⟨hg_inj, hg_surj⟩
  exact And.intro
    (injective_comp f g hf_inj hg_inj)
    (surjective_comp f g hf_surj hg_surj)

/-! ## Image Properties -/

theorem image_union {α β : Type u} (f : α → β) (s t : Set α) :
    image f (union s t) = union (image f s) (image f t) :=
  subset_extensional _ _ (fun y => ⟨
    fun h => by
      rcases h with ⟨x, hx, h⟩
      rcases hx with (hx | hx)
      · exact Or.inl ⟨x, hx, h⟩
      · exact Or.inr ⟨x, hx, h⟩,
    fun h => by
      rcases h with (h | h)
      · rcases h with ⟨x, hx, h⟩
        exact ⟨x, Or.inl hx, h⟩
      · rcases h with ⟨x, hx, h⟩
        exact ⟨x, Or.inr hx, h⟩⟩)

theorem image_inter_subset {α β : Type u} (f : α → β) (s t : Set α) :
    image f (inter s t) ⊆ inter (image f s) (image f t) :=
  fun y h => by
    rcases h with ⟨x, ⟨hxs, hxt⟩, h⟩
    exact ⟨⟨x, hxs, h⟩, ⟨x, hxt, h⟩⟩

theorem image_compose {α β γ : Type u} (f : α → β) (g : β → γ) (s : Set α) :
    image (g ∘ f) s = image g (image f s) :=
  subset_extensional _ _ (fun z => ⟨
    fun h => by
      rcases h with ⟨x, hx, h⟩
      exact ⟨f x, ⟨x, hx, rfl⟩, h⟩,
    fun h => by
      rcases h with ⟨y, ⟨x, hx, h⟩, h'⟩
      exact ⟨x, hx, by rw [Function.comp_apply, h, h']⟩⟩)

/-! ## Preimage Properties -/

theorem preimage_union {α β : Type u} (f : α → β) (s t : Set β) :
    preimage f (union s t) = union (preimage f s) (preimage f t) :=
  subset_extensional _ _ (fun x => ⟨
    fun h => by
      rcases h with (h | h)
      · exact Or.inl h
      · exact Or.inr h,
    fun h => by
      rcases h with (h | h)
      · exact Or.inl h
      · exact Or.inr h⟩)

theorem preimage_inter {α β : Type u} (f : α → β) (s t : Set β) :
    preimage f (inter s t) = inter (preimage f s) (preimage f t) :=
  subset_extensional _ _ (fun _ => ⟨
    fun h => ⟨h.left, h.right⟩,
    fun h => ⟨h.left, h.right⟩⟩)

theorem preimage_compose {α β γ : Type u} (f : α → β) (g : β → γ) (s : Set γ) :
    preimage (g ∘ f) s = preimage f (preimage g s) :=
  subset_extensional _ _ (fun _ => Iff.rfl)

/-! ## Bijection Preserves Cardinal Relationships -/

/--
A bijection between α and β lifts to a bijection between their power sets
via image/preimage. The proof uses `subset_extensional` and the injectivity/
surjectivity hypotheses to construct Φ = image f and Ψ = preimage f.
-/
theorem bijection_powerSet_bijection {α β : Type u} (f : α → β) :
    isBijective f → ∃ (Φ : Set α → Set β) (Ψ : Set β → Set α),
      (∀ s, Ψ (Φ s) = s) ∧ (∀ t, Φ (Ψ t) = t) :=
  -- Φ = image f, Ψ = preimage f. For a bijection f, these are mutual inverses.
  let Φ (s : Set α) : Set β := λ b => ∃ a, s a ∧ f a = b
  let Ψ (t : Set β) : Set α := λ a => t (f a)
  refine ⟨Φ, Ψ, ?_, ?_⟩
  · intro s; funext a; constructor
    · intro h; rcases h with ⟨a', ha', heq⟩
      rcases h_biject with ⟨h_inj, _⟩
      have : a' = a := h_inj heq; subst this; exact ha'
    · intro ha; exact ⟨a, ha, rfl⟩
  · intro t; funext b; constructor
    · intro ⟨a, ha, heq⟩; subst heq; exact ha
    · intro hb; rcases h_biject with ⟨_, h_surj⟩
      rcases h_surj b with ⟨a, heq⟩; subst heq; exact ⟨a, hb, rfl⟩

/-! ## Examples (type-checked) -/

-- Image of union
def imgS : Set Nat := singleton 1
def imgT : Set Nat := singleton 2
example : image (fun x : Nat => x + 1) (union imgS imgT) 2 := by
  refine ⟨1, Or.inl rfl, ?_⟩; rfl
example : image (fun x : Nat => x + 1) (union imgS imgT) 3 := by
  refine ⟨2, Or.inr rfl, ?_⟩; rfl

-- Preimage of union
example : preimage (fun x : Nat => x % 3) (singleton 0 : Set Nat) 0 := rfl
example : preimage (fun x : Nat => x % 3) (singleton 0 : Set Nat) 3 := rfl

-- Image composition
example : image ((fun x : Nat => x + 1) ∘ (fun x : Nat => 2 * x)) (singleton 3 : Set Nat) 7 := by
  refine ⟨3, rfl, ?_⟩; rfl

-- Preimage composition
example : preimage ((fun x : Nat => x + 1) ∘ (fun x : Nat => 2 * x)) (singleton 5 : Set Nat) 2 := rfl

end MiniSetCore
