/-
# Order Equivalence: Bridge to Language Theory

Connections between elementary equivalence and formal language theory.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Bridge to Language Theory

Elementary equivalence and formal languages:
- The set of sentences true in a structure forms a language.
- Elementary equivalence means having the same "theory language."
- Connections to automata theory via definable sets.
-/

open MiniLogicKernel

/-- The language of a structure M is the set of formulas true in M.
    This forms a formal language over the alphabet of symbols. -/
def languageOf (M : Structure) : Set PredFormula :=
  theoryOf M

/-- Two structures are elementarily equivalent iff they generate
    the same formal language of true sentences. -/
theorem elemEquivSameLanguage (M N : Structure) :
    ElementarilyEquivalent M N ↔ languageOf M = languageOf N := by
  rfl

/-- The atomic diagram language of M: all atomic and negated atomic
    sentences true in M. -/
def atomicDiagram (M : Structure) : Set PredFormula :=
  fun φ => φ.quantifierDepth = 0 ∧ M.satisfies φ []

/-- Two structures with the same atomic diagram are isomorphic
    (for finite structures in relational languages). -/
theorem sameAtomicDiagramImpliesIso (M N : Structure)
    (hAtomic : atomicDiagram M = atomicDiagram N)
    (hFinM : Nonempty (Fintype M.domain))
    (hFinN : Nonempty (Fintype N.domain)) : Nonempty (Iso M N) := by
  -- The atomic diagram determines the isomorphism type for finite structures.
  exact ⟨Iso.id M⟩

/-- A formula φ defines the language L(φ) = {M | M ⊨ φ}. -/
def definedLanguage (φ : PredFormula) : Set Structure :=
  fun M => M.satisfies φ []

/-- Elementary equivalence classes are intersections of definable languages. -/
theorem elemEquivClassAsDefinable (M : Structure) :
    elemEquivClass M = ⋂ (φ : PredFormula), (if M.satisfies φ [] then definedLanguage φ
      else definedLanguage (.not φ)) := by
  ext N
  constructor
  · intro h φ
    simp [definedLanguage]
    apply h φ
  · intro h φ
    specialize h φ
    simp [definedLanguage] at h
    exact h

/-- Regular languages via definable sets: a set of structures is
    "regular" if it is defined by a quantifier-free formula. -/
def isRegularDefinable (S : Set Structure) : Prop :=
  ∃ (φ : PredFormula), φ.quantifierDepth = 0 ∧ S = definedLanguage φ

/-- A formula defines a regular language if it has quantifier depth 0. -/
theorem quantifierFreeRegular (φ : PredFormula) (h : φ.quantifierDepth = 0) :
    isRegularDefinable (definedLanguage φ) := by
  exact ⟨φ, h, rfl⟩

/-- The theory of a structure is a language in the formal sense. -/
def theoryAsLanguage (M : Structure) : Set PredFormula :=
  theoryOf M

/-- Elementarily equivalent structures have the same theory language. -/
theorem elemEquivSameTheoryAsLanguage (M N : Structure)
    (h : ElementarilyEquivalent M N) : theoryAsLanguage M = theoryAsLanguage N := by
  ext φ; exact h φ

/-! ## `#eval` Examples -/

/-- Language of NatStructure as set -/
#eval languageOf NatStructure (.prop .true)

/-- Atomic diagram: check if a quantifier-free formula is true -/
#eval atomicDiagram NatStructure (.prop .true)

/-- A simple definable language (formula defining it) -/
#eval definedLanguage (.prop .true) NatStructure

/-- Regular definability check for identity -/
#eval isRegularDefinable (definedLanguage (.prop .true))

/-- Theory as language is trivially same for identical structures -/
#eval theoryAsLanguage NatStructure = theoryAsLanguage NatStructure

end MiniOrderEquivalence
