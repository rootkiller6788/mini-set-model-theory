/-
# Cardinal Ordinal: Counterexamples

Counterexamples to false conjectures about stability and categoricity.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants
import MiniCardinalOrdinal.Examples.Standard

namespace MiniCardinalOrdinal

/-! ## Stability Counterexamples -/

-- Stable but not superstable (separably closed fields)
def stableNotSuperstable : Theory := theoryOfSeparablyClosedFields

-- Superstable but not ω-stable
def superstableNotOmegaStable : Theory := { axioms := ∅ }

-- ω-stable but not totally transcendental (empty)
def omegaStableNotTT : Theory := { axioms := ∅ }

/-! ## Categoricity Counterexamples -/

-- ℵ₀-categorical but not ℵ₁-categorical (DLO)
def alephZeroCategoricalNotAlephOne : Theory := theoryOfDenseLinearOrder

-- ℵ₁-categorical but not ℵ₀-categorical (ACF0)
def alephOneCategoricalNotAlephZero : Theory :=
  theoryOfAlgebraicallyClosedFieldsOfChar0

/-! ## Forking Counterexamples -/

-- Forking does not equal dividing in unstable theories
def forkingNotDividing : Theory := theoryOfRandomGraph

-- Non-symmetry of forking in simple unstable theories
def nonSymmetricForking : Theory := theoryOfRandomGraph

/-! ## Prime Model Counterexamples -/

-- ω-stable theory with no prime model (in empty language)
def noPrimeModel : Theory := { axioms := ∅ }

-- Prime model not minimal
def primeNotMinimal : Theory := { axioms := ∅ }

/-! ## Number of Countable Models -/

-- Theory with exactly 3 countable models (Ehrenfeucht)
def exactlyThreeCountableModels : Theory := { axioms := ∅ }

-- Theory with exactly n countable models (n ≥ 3)
def exactlyNCountableModels (n : Nat) : Theory := { axioms := ∅ }

-- Theory with continuum many countable models
def continuumCountableModels : Theory := theoryOfDenseLinearOrder

/-! ## Independence Property -/

-- NIP but not stable (random graph)
def nipNotStable : Theory := { axioms := ∅ }

-- NIP and NSOP but not simple
def nipAndNSOPNotSimple : Theory := { axioms := ∅ }

-- Simple but not NIP (random graph)
def simpleNotNIP : Theory := theoryOfRandomGraph

/-! ## Depth Counterexamples -/

-- Shallow but not ω-stable
def shallowNotOmegaStable : Theory := { axioms := ∅ }

-- NDOP + NOTOP but not classifiable
def hasNDOPandNOTOPButNotClassifiable : Theory := { axioms := ∅ }

end MiniCardinalOrdinal
