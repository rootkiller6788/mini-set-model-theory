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
  subset_extensional _ _ (fun x => ⟨
    fun h => ⟨h.left, h.right⟩,
    fun h => ⟨h.left, h.right⟩⟩)

theorem preimage_compose {α β γ : Type u} (f : α → β) (g : β → γ) (s : Set γ) :
    preimage (g ∘ f) s = preimage f (preimage g s) :=
  subset_extensional _ _ (fun x => rfl)

/-! ## Bijection Preserves Cardinal Relationships -/

/-- A bijection between α and β induces an isomorphism of their power sets. -/
theorem bijection_induces_powerSet_iso {α β : Type u} (f : α → β) :
    isBijective f → sameCardinality (fun _ : Set α => True) (fun _ : Set β => True) := by
  intro ⟨hf_inj, hf_surj⟩
  let Φ : Set α → Set β := image f
  let Ψ : Set β → Set α := preimage f
  -- We claim Ψ ∘ Φ = id on Set α
  have hleft : ∀ (s : Set α), Ψ (Φ s) = s := by
    intro s
    apply subset_extensional
    intro x; apply Iff.intro
    · intro hx; rcases hx with ⟨y, ⟨z, hz, h⟩, h'⟩
      rw [h] at h'; apply hf_inj at h'; rw [← h']; exact hz
    · intro hx
      exact ⟨f x, ⟨x, hx, rfl⟩, rfl⟩
  have hright : ∀ (t : Set β), Φ (Ψ t) = t := by
    intro t
    apply subset_extensional
    intro y; apply Iff.intro
    · intro h; rcases h with ⟨x, hx, h⟩
      rw [h]; exact hx
    · intro hy
      rcases hf_surj y with ⟨x, hx⟩
      exact ⟨x, by rw [hx] at hy; exact hy, hx⟩
  -- Now construct the bijection on power sets
  refine ⟨Φ, ?_⟩
  apply And.intro
  · intro s t h
    calc
      s = Ψ (Φ s) := by rw [hleft s]
      _ = Ψ (Φ t) := by rw [h]
      _ = t := by rw [hleft t]
  · intro t
    exact ⟨Ψ t, hright t⟩

/-! ## #eval Verification -/

-- Image of union
def imgS : Set Nat := singleton 1
def imgT : Set Nat := singleton 2
#eval image (fun x : Nat => x + 1) (union imgS imgT) 2
#eval image (fun x : Nat => x + 1) (union imgS imgT) 3

-- Preimage of union
#eval preimage (fun x : Nat => x % 3) (singleton 0 : Set Nat) 0
#eval preimage (fun x : Nat => x % 3) (singleton 0 : Set Nat) 3

-- Image composition
#eval image ((fun x : Nat => x + 1) ∘ (fun x : Nat => 2 * x)) (singleton 3 : Set Nat) 7

-- Preimage composition
#eval preimage ((fun x : Nat => x + 1) ∘ (fun x : Nat => 2 * x)) (singleton 5 : Set Nat) 2

end MiniSetCore
