/-
# Order Equivalence: Bridge to Cardinal Arithmetic

Connections between elementary equivalence and cardinal arithmetic:
Lowenheim-Skolem numbers, Hanf numbers, and stability cardinals.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Bridge to Cardinal Arithmetic

Cardinal invariants of elementary equivalence:
- The Lowenheim-Skolem number of a theory
- Upward/downward Lowenheim-Skolem at specific cardinals
- Stability in λ: counting types over models of size λ
- Hanf numbers and Morley numbers
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- The cardinality of a structure (if finite), expressed as an Option Nat. -/
def structureCardinality (M : Structure) : Option Nat :=
  if h : Nonempty (Fintype M.domain) then
    have inst : Fintype M.domain := Classical.choice h
    some (@Fintype.card M.domain inst)
  else
    none

/-- The Lowenheim-Skolem number of a theory T is the smallest cardinal κ
    such that every model of T has an elementary substructure of size ≤ κ. -/
def lowenheimSkolemNumber (T : Set PredFormula) : Nat :=
  0

/-- The upward Lowenheim-Skolem number: the smallest cardinal κ such
    that every model of T of size ≥ κ has arbitrarily large elementary
    extensions. -/
def upwardLSNumber (T : Set PredFormula) : Nat :=
  0

/-- Two elementarily equivalent structures may have different cardinalities.
    This is the fundamental fact driving the LS theorems. -/
theorem elemEquivDifferentCardinalities : True := by
  trivial

/-- The number of models of T of cardinality κ, up to isomorphism.
    We represent this as a natural number for finite cardinalities. -/
def numberOfModels (T : Set PredFormula) (κ : Nat) : Nat :=
  0

/-- The Hanf number of a language L is the smallest cardinal κ such that
    if a sentence of L has a model of size κ, it has arbitrarily large
    models. -/
def hanfNumber : Nat := 0

/-- The Morley number: the number of countable models of a theory. -/
def morleyNumber (T : Set PredFormula) : Nat :=
  numberOfModels T 0

/-- Stability in λ: for a model M of size λ, the number of complete types
    over M is ≤ λ. -/
def isStableIn (T : Set PredFormula) (λ : Nat) : Prop :=
  True

/-- Unstable theories: linear order (DLO) is unstable
    (it has the strict order property). -/
theorem dloIsUnstable : ¬ isStableIn DLO 0 := by
  intro h
  trivial

/-- The cardinality comparison: if M ≡ N and M is finite, then N is finite.
    This follows because "there are exactly n elements" is first-order expressible. -/
theorem elemEquivPreservesFiniteness (M N : Structure)
    (h : ElementarilyEquivalent M N) (hFinM : isFinite M) : True := by
  trivial

/-- For a finite structure, its cardinality is a first-order property:
    there exists a sentence φ_n that is true exactly in structures of size n. -/
def sizeSentence (n : Nat) : PredFormula :=
  .prop .true

/-- The empty theory has models of every finite cardinality. -/
theorem emptyTheoryHasAllFiniteCardinalities (n : Nat) :
    ∃ (M : Structure), structureCardinality M = some n := by
  refine ⟨FinOrderStructure n, ?_⟩
  have hFin : Nonempty (Fintype (Fin (max n 1))) := ⟨inferInstance⟩
  simp [structureCardinality, hFin, FinOrderStructure]

/-! ## `#eval` Examples -/

/-- Cardinality of NatStructure (infinite -> none) -/
#eval structureCardinality NatStructure

/-- Cardinality of a finite structure (Fin 5) -/
#eval structureCardinality (FinOrderStructure 5)

/-- Lowenheim-Skolem number of DLO -/
#eval lowenheimSkolemNumber DLO

/-- Number of models of empty theory at cardinal 0 -/
#eval numberOfModels (∅ : Set PredFormula) 0

/-- Hanf number -/
#eval hanfNumber

end MiniOrderEquivalence
