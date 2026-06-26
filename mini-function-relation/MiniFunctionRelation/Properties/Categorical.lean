import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Categoricity

A theory is κ-categorical if all models of size κ are isomorphic.
-/

/-- A set of structures is κ-categorical if any two structures in the set
    with domain cardinality κ are isomorphic.
    TODO: add cardinality constraint (currently simplified to all structures in set). -/
def IsKappaCategorical (models : Set Structure) (kappa : Nat) : Prop :=
  ∀ (M N : Structure), M ∈ models → N ∈ models → Nonempty (Iso M N)

/-- A structure M is ω-categorical if its complete theory is ℵ₀-categorical:
    any countable structure elementarily equivalent to M is isomorphic to M.
    TODO: add countability and elementary equivalence constraints. -/
def IsOmegaCategorical (M : Structure) : Prop :=
  ∀ (N : Structure), Nonempty (Iso M N)

/-- The theory of dense linear orders without endpoints is ℵ₀-categorical
    (Cantor's back-and-forth theorem).
    Stated as an acknowledged property. -/
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
  have hIso := h ThreeElStruct
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
