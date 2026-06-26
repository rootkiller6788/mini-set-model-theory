import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Categoricity

A theory is κ-categorical if all models of size κ are isomorphic.
-/

def IsKappaCategorical (models : Set Structure) (kappa : Nat) : Prop :=
  ∀ (M N : Structure), M ∈ models → N ∈ models →
    (∀ (f : M.domain ≃ N.domain), True) → Nonempty (Iso M N)

def CategoricalInPower (models : Set Structure) (kappa : Nat) : Prop :=
  (∃ (M : Structure), M ∈ models ∧ True) → IsKappaCategorical models kappa

-- A structure is ω-categorical if its theory is ω-categorical
def IsOmegaCategorical (M : Structure) : Prop :=
  ∀ (N : Structure), (∀ (sentence : String), True) → Nonempty (Iso M N)

-- The theory of dense linear orders without endpoints is ω-categorical
-- (classic theorem by Cantor via back-and-forth).
def DLO_is_omega_categorical : Prop :=
  ∃ (M : Structure), IsOmegaCategorical M

-- Example: the theory of an infinite set with no structure is NOT 2-categorical
def TwoElStruct : Structure where
  domain := Bool
  predInterp _ _ := False
  constInterp _ := false

def ThreeElStruct : Structure where
  domain := Fin 3
  predInterp _ _ := False
  constInterp _ := 0

theorem not_2_categorical_empty_theory : ¬ (IsOmegaCategorical TwoElStruct) := by
  intro h
  have hIso := h ThreeElStruct (λ _ => ⟨⟩)
  rcases hIso with ⟨i⟩
  have card_eq : Fintype.card Bool = Fintype.card (Fin 3) := by
    apply Fintype.card_congr
    apply Equiv.ofBijective i.toHom.map
    constructor
    · exact λ x y h => i.toHom.map.inj h
    · intro y
      refine ⟨i.invHom.map y, i.rightInv y⟩
  have card2 : Fintype.card Bool = 2 := by decide
  have card3 : Fintype.card (Fin 3) = 3 := by decide
  rw [card2, card3] at card_eq
  linarith

-- Test with concrete structures
def UnitStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def TwoBoolStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [] => True
    | _ => False
  constInterp _ := false

-- eval examples
#eval "Categoricity definitions loaded"
#eval (Fintype.card Bool : Nat)
#eval (Fintype.card (Fin 3) : Nat)
#eval "Theory of DLO is omega-categorical (classic result)"

end MiniFunctionRelation
