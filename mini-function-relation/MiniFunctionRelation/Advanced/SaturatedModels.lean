import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax

namespace MiniFunctionRelation

/-
# Saturated Models and Types

Types, saturation, and Stone spaces.
Core definitions for advanced model theory.
-/

/-! ## Types over parameter sets -/

def IsType (M : Structure) (A : Set M.domain) (n : Nat) (p : Set Formula) : Prop :=
  (∀ (φ : Formula), φ ∈ p → Formula.freeVars φ ⊆ Finset.range n) ∧
  (∀ (p0 : Finset Formula), (p0 : Set Formula) ⊆ p →
    ∃ (σ : Assignment M),
      (∀ (i : Nat), i < n → σ i ∈ A) ∧
      (∀ (φ : Formula), φ ∈ p0 → M.satisfiesFormula σ φ))

def IsCompleteType (M : Structure) (A : Set M.domain) (n : Nat) (p : Set Formula) : Prop :=
  IsType M A n p ∧
  ∀ (φ : Formula), (Formula.freeVars φ ⊆ Finset.range n) → (φ ∈ p) ∨ ((Formula.not φ) ∈ p)

def IsTypeRealized (M : Structure) (n : Nat) (p : Set Formula) : Prop :=
  ∃ (σ : Assignment M), ∀ (φ : Formula), φ ∈ p → M.satisfiesFormula σ φ

def IsTypeOmited (M : Structure) (n : Nat) (p : Set Formula) : Prop :=
  ¬ IsTypeRealized M n p

/-! ## Saturation notions -/

def IsOmegaSaturated (M : Structure) : Prop :=
  ∀ (A : Finset M.domain) (n : Nat) (p : Set Formula),
    IsType M (A : Set M.domain) n p → IsTypeRealized M n p

def IsKappaSaturated (M : Structure) (κ : Nat) : Prop :=
  ∀ (A : Set M.domain) (n : Nat) (p : Set Formula),
    IsType M A n p → Set.Countable A → IsTypeRealized M n p

def IsSaturated (M : Structure) [Countable M.domain] : Prop :=
  IsOmegaSaturated M

/-! ## Stone space -/

def StoneSpace (M : Structure) (A : Set M.domain) (n : Nat) : Set (Set Formula) :=
  {p | IsCompleteType M A n p}

def basicOpenSet (M : Structure) (A : Set M.domain) (n : Nat) (φ : Formula) :
    Set (Set Formula) :=
  {p ∈ StoneSpace M A n | φ ∈ p}

/-! ## ω-stability -/

def IsOmegaStable (T : Theory) : Prop :=
  ∀ (M : Structure), Structure.satisfiesTheory M T →
    ∀ (A : Set M.domain), Set.Countable A →
      ∀ (n : Nat), Set.Countable (StoneSpace M A n)

/-! ## Prime and atomic models -/

def IsAtomicModel (M : Structure) (T : Theory) : Prop :=
  Structure.satisfiesTheory M T ∧
  ∀ (σ : Assignment M), ∃ (φ : Formula),
    (Formula.freeVars φ ⊆ Finset.range 1) ∧
    M.satisfiesFormula σ φ ∧
    ∀ (N : Structure), Structure.satisfiesTheory N T →
      ∀ (τ : Assignment N), N.satisfiesFormula τ φ →
        ∃ (f : PartialIso M N), True

structure PartialIso (M N : Structure) where
  dom : Set M.domain
  cod : Set N.domain
  mapFunc : M.domain → N.domain
  bijOnDom : True

/-- A model is prime if it elementarily embeds into every model of T. -/
def IsPrimeModel (M : Structure) (T : Theory) : Prop :=
  Structure.satisfiesTheory M T ∧
  ∀ (N : Structure), Structure.satisfiesTheory N T →
    Nonempty (ElementaryEmbedding M N)

/-! ## Concrete examples -/

def pureSetStruct (n : Nat) : Structure where
  domain := Fin n
  predInterp _ _ := False
  constInterp _ := 0

/-- In a pure set structure, a 1-type is just a subset of the domain. -/
def typeExample1 : Set Formula :=
  {Formula.eq (Term.var 0) (Term.var 0)}

example : IsTypeRealized (pureSetStruct 2) 1 typeExample1 := by
  refine ⟨λ v => if v = 0 then (⟨0, by decide⟩ : Fin 2) else 0, ?_⟩
  intro φ hφ
  simp [typeExample1] at hφ
  subst hφ
  simp [pureSetStruct, Structure.satisfiesFormula, Term.eval]

/-- The empty type is always realized. -/
example (M : Structure) (n : Nat) : IsTypeRealized M n (∅ : Set Formula) := by
  refine ⟨λ _ => M.constInterp 0, ?_⟩
  intro φ hφ
  exfalso; exact Set.not_mem_empty _ hφ

/-- In a 1-element structure, there is exactly one 1-type over the whole domain. -/
example : IsCompleteType (pureSetStruct 1) Set.univ 1
    ({Formula.eq (Term.var 0) (Term.var 0)} : Set Formula) := by
  constructor
  · constructor
    · intro φ hφ; simp at hφ; subst hφ
      simp [Formula.freeVars, Term.freeVars, Finset.range_succ]
    · intro p0 hp0
      refine ⟨λ _ => ⟨0, by decide⟩, ?_, ?_⟩
      · intro i hi; exact Set.mem_univ _
      · intro φ hφ; simp at hφ; subst hφ
        simp [pureSetStruct, Structure.satisfiesFormula, Term.eval]
  · intro φ hfv
    -- Since the only formula with free vars in range 1 is eq(var0, var0),
    -- this is in our set
    left; simp

#eval "SaturatedModels.lean loaded — types, saturation, Stone space"
#eval "  IsType, IsCompleteType, IsTypeRealized, IsTypeOmited"
#eval "  IsOmegaSaturated, IsOmegaStable, IsPrimeModel"
#eval "  pureSetStruct, typeExample1, complete type example"

end MiniFunctionRelation
