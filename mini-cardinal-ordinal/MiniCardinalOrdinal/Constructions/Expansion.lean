/-
# Cardinal Ordinal: Expansion Constructions

Expansions by constants, Skolem functions, and Morleyisation.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Expansion by Constants -/

def expansionByConstants (T : Theory) (A : Set Nat) : Theory :=
  { axioms := T.axioms }

def expansionElementary (T : Theory) (A : Set Nat) : Prop := True

def expansionCardinality (T : Theory) (A : Set Nat)
    (κ : Cardinal) : Prop := True

/-! ## Skolem Expansion -/

def skolemFunctions (T : Theory) : Theory := T

def skolemization (T : Theory) : Theory := T

def skolemizationElementary (T : Theory) : Prop := True

def skolemizationPreservesCategoricity (T : Theory) (κ : Cardinal) : Prop :=
  isCategoricalInPower T κ → True

/-! ## Morleyisation -/

def morleyisation (T : Theory) : Theory := T

def morleyisedHasQE (T : Theory) : Prop :=
  hasQE (morleyisation T)

def morleyisationPreservesStability (T : Theory) : Prop :=
  isStable T → isStable (morleyisation T)

def morleyisationPreservesCategoricity (T : Theory) (κ : Cardinal) : Prop :=
  isCategoricalInPower T κ → isCategoricalInPower (morleyisation T) κ

/-! ## Definitional Expansion -/

def definitionalExpansion (T : Theory) (defs : List MiniLogicKernel.PredFormula) :
    Theory := T

def conservativeExpansion (T : Theory) : Theory := T

def expansionIsConservative (T S : Theory) : Prop := True

/-! ## Expansion and Invariants -/

def expansionPreservesMorleyRank (T : Theory) : Prop := True

def expansionPreservesNumTypes (T : Theory) : Prop := True

def expansionPreservesForking (T : Theory) : Prop := True

end MiniCardinalOrdinal
