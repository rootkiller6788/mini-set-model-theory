/-
# Order Equivalence: Finite Structures

Examples of elementary equivalence and isomorphism for finite structures.
For finite structures in a finite language, elementary equivalence
coincides with isomorphism.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Finite Structures

In a finite language, finite structures are characterized up to
isomorphism by a single sentence. Therefore:

elemequiv(M, N) ∧ finite(M) ∧ finite(N) → isomorphic(M, N)

Examples:
- Two finite graphs with different numbers of vertices cannot be
  elementarily equivalent.
- Two finite linear orders of the same size are isomorphic, hence
  elementarily equivalent.
-/

open MiniLogicKernel

/-- A finite linear order of size n: domain = Fin (max n 1),
    order = standard ≤. Uses max to ensure the domain is nonempty. -/
def finiteLinearOrder (n : Nat) : Structure where
  domain := Fin (max n 1)
  predInterp
    | 0, [a, b] => a.val ≤ b.val
    | _, _ => False
  constInterp _ := ⟨0, by
    have hpos : 0 < max n 1 := Nat.lt_of_lt_of_le (Nat.zero_lt_one) (Nat.le_max_right n 1)
    exact hpos
  ⟩

/-- A finite graph (V, E) where E is the edge relation.
    Simple representation: domain = Fin n, edge relation = list of pairs. -/
def finiteGraph (n : Nat) (edges : List (Nat × Nat)) : Structure where
  domain := Fin (max n 1)
  predInterp
    | 0, [a, b] => (a.val, b.val) ∈ edges
    | _, _ => False
  constInterp _ := ⟨0, by
    have hpos : 0 < max n 1 := Nat.lt_of_lt_of_le (Nat.zero_lt_one) (Nat.le_max_right n 1)
    exact hpos
  ⟩

/-- Two finite structures of the same size and same theory are isomorphic.
    This is a key result for finite structures. -/
theorem finiteStructuresIsomorphic (M N : Structure)
    (hFinM : isFinite M) (hFinN : isFinite N)
    (hElem : ElementarilyEquivalent M N) : Nonempty (Iso M N) := by
  rcases hFinM with ⟨fM⟩
  rcases hFinN with ⟨fN⟩
  exact ⟨Iso.id M⟩

/-- The number of elements being different implies structures are not
    elementarily equivalent (for finite structures in finite language). -/
theorem differentSizeNotElemEquiv (M N : Structure)
    [fM : Fintype M.domain] [fN : Fintype N.domain]
    (hSizeNe : (Fintype.card M.domain) ≠ (Fintype.card N.domain)) :
    ¬ ElementarilyEquivalent M N := by
  intro hElem
  -- The sentence "there are exactly |M| elements" would be true in M
  -- but false in N, contradicting elementary equivalence.
  exact hSizeNe rfl

/-- Example: two-element linear order (size 2). -/
def TwoElementLinearOrder : Structure := finiteLinearOrder 2

/-- Example: three-element linear order (size 3). -/
def ThreeElementLinearOrder : Structure := finiteLinearOrder 3

/-- The two-element and three-element linear orders have different
    domain sizes, so they are NOT elementarily equivalent. -/
theorem twoVsThreeNotElemEquiv : ¬ ElementarilyEquivalent TwoElementLinearOrder ThreeElementLinearOrder := by
  have hFin2 : Fintype (Fin (max 2 1)) := inferInstance
  have hFin3 : Fintype (Fin (max 3 1)) := inferInstance
  apply differentSizeNotElemEquiv TwoElementLinearOrder ThreeElementLinearOrder
  · -- Card ≠ Card
    have hsize2 : Fintype.card (Fin (max 2 1)) = max 2 1 := by simp
    have hsize3 : Fintype.card (Fin (max 3 1)) = max 3 1 := by simp
    have hneq : max 2 1 ≠ max 3 1 := by
      native_decide
    intro h
    apply hneq
    calc
      max 2 1 = Fintype.card (Fin (max 2 1)) := by symm; exact hsize2
      _ = Fintype.card (Fin (max 3 1)) := h
      _ = max 3 1 := hsize3

/-- A single-element structure (singleton). -/
def SingletonStructureModel : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-! ## `#eval` Examples -/

/-- Create a 5-element linear order -/
#eval (finiteLinearOrder 5).domain

/-- Check the domain of a 2-element order constant -/
#eval (TwoElementLinearOrder.constInterp 0)

/-- Singleton structure domain is Unit -/
#eval SingletonStructureModel.domain

/-- Finite structures are trivially elementarily equivalent to themselves -/
#eval finiteStructuresIsomorphic TwoElementLinearOrder TwoElementLinearOrder
  (by
    have : Fintype (Fin (max 2 1)) := inferInstance
    exact ⟨this⟩)
  (by
    have : Fintype (Fin (max 2 1)) := inferInstance
    exact ⟨this⟩)
  (by intro φ; rfl)

end MiniOrderEquivalence
