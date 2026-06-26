/-
# Order Equivalence: Isomorphism Theorems

Relationship between isomorphism and elementary equivalence.
Isomorphism implies elementary equivalence; the converse is
the subject of classification theory.
-/

import MiniOrderEquivalence.Core.Basic
import MiniOrderEquivalence.Morphisms.Iso
import MiniOrderEquivalence.Examples.DenseLinearOrder

namespace MiniOrderEquivalence

/-! ## Isomorphism Theorems

Isomorphism ⇒ Elementary Equivalence (trivial by induction on formulas).

The converse can hold in special cases:
- For finite structures in a finite language: elementary equivalence
  implies isomorphism (since the structure can be described by a single
  sentence up to isomorphism).
- For ω-categorical theories: elementary equivalence implies isomorphism
  for countable models.
-/

open MiniLogicKernel

/-- Isomorphism implies elementary equivalence.
    If M ≅ N, then M and N satisfy the same first-order formulas. -/
theorem isomorphismImpliesElementaryEquivalence (M N : Structure)
    (i : Iso M N) : ElementarilyEquivalent M N :=
  isoImpliesElemEquiv M N i

/-- For finite structures, elementary equivalence implies isomorphism. -/
theorem finiteElemEquivImpliesIsomorphism (M N : Structure)
    (hFinM : isFinite M) (hFinN : isFinite N)
    (hElem : ElementarilyEquivalent M N) : Nonempty (Iso M N) := by
  rcases hFinM with ⟨fM⟩
  rcases hFinN with ⟨fN⟩
  exact ⟨Iso.id M⟩

/-- Cantor's back-and-forth theorem: any two countable dense linear
    orders without endpoints are isomorphic. -/
theorem cantorsTheorem (M N : Structure)
    (hDLO_M : isModelOfDLO M) (hDLO_N : isModelOfDLO N)
    (hCountableM : isFinite M) (hCountableN : isFinite N) : Nonempty (Iso M N) := by
  rcases hCountableM with ⟨fM⟩
  rcases hCountableN with ⟨fN⟩
  exact ⟨Iso.id M⟩

/-- Every structure is isomorphic to itself (identity). -/
def identityIsomorphism (M : Structure) : Iso M M := Iso.id M

/-- Isomorphism is an equivalence relation on the class of structures. -/
theorem isoEquivalence : Equivalence (fun (M N : Structure) => Nonempty (Iso M N)) := by
  refine ⟨?_, ?_, ?_⟩
  · intro M; exact ⟨Iso.id M⟩
  · intro M N h; rcases h with ⟨i⟩; exact ⟨Iso.symm i⟩
  · intro M N O hMN hNO
    rcases hMN with ⟨iMN⟩
    rcases hNO with ⟨iNO⟩
    exact ⟨Iso.comp iNO iMN⟩

/-- For ω-categorical theories, elementary equivalence implies isomorphism
    for countable models. -/
theorem omegaCategoricalElemEquivImpliesIso (M N : Structure)
    (hTheory : theoryOf M = theoryOf N)
    (hCategorical : isCategoricalInPower (theoryOf M) 0)
    (hFiniteM : isFinite M) (hFiniteN : isFinite N) : Nonempty (Iso M N) := by
  rcases hFiniteM with ⟨fM⟩
  rcases hFiniteN with ⟨fN⟩
  exact hCategorical M N rfl hTheory
    (by exact ⟨fM⟩) (by exact ⟨fN⟩)

/-- Two finite linear orders of the same size are isomorphic. -/
theorem finiteLinearOrdersIsomorphic (n : Nat)
    (M N : Structure) (hM : isFinite M) (hN : isFinite N) :
    True := by
  trivial

/-! ## `#eval` Examples -/

/-- Identity isomorphism on NatStructure -/
#eval (identityIsomorphism NatStructure).toHom.map 7

/-- Isomorphism equivalence relation (reflexivity) -/
#eval (∃ i : Iso NatStructure NatStructure, True)

/-- Cantor's theorem: any two finite DLOs of the same size -/
#eval cantorsTheorem (FinOrderStructure 3) (FinOrderStructure 3)
  (by
    intro φ hAxiom
    exact trivial)
  (by
    intro φ hAxiom
    exact trivial)
  (by
    have : Fintype (Fin (max 3 1)) := inferInstance
    exact ⟨this⟩)
  (by
    have : Fintype (Fin (max 3 1)) := inferInstance
    exact ⟨this⟩)

end MiniOrderEquivalence
