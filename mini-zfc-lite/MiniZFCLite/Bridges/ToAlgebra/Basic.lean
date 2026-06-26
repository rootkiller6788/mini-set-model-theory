/-
# MiniZFCLite: Bridges — ToAlgebra

Boolean algebra of sets, complete Boolean algebras for forcing,
and algebraic structures arising from ZFC.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Boolean Algebra of Sets -/

/-- The Boolean algebra (P(X), ∪, ∩, ∁, ∅, X) is a complete Boolean algebra -/
structure SetBooleanAlgebra where
  name : String
  operations : String
  properties : List String
  deriving Repr

/-- The power set Boolean algebra -/
def powerSetBooleanAlgebra : SetBooleanAlgebra :=
  { name := "P(X) as a Boolean algebra"
    operations := "∪ (join), ∩ (meet), ∁ (complement), ∅ (bot), X (top)"
    properties := [
      "Complete Boolean algebra (arbitrary joins and meets exist)",
      "Atomic: every element is above an atom (singleton)",
      "Satisfies all Boolean algebra axioms (ZFC provides powerset and union)"
    ] }

/-! ## Complete Boolean Algebras -/

/-- Complete Boolean algebras are essential for Boolean-valued models -/
structure CompleteBooleanAlgebra where
  name : String
  definition : String
  completeness : String
  examples : List String
  deriving Repr

/-- Definition and examples of complete Boolean algebras -/
def completeBoolAlg : CompleteBooleanAlgebra :=
  { name := "Complete Boolean Algebra (cBA)"
    definition := "A Boolean algebra where every subset has a supremum"
    completeness := "Needed for interpreting ∀ and ∃ in Boolean-valued models"
    examples := [
      "P(X) — power set algebra (any X)",
      "RO(X) — regular open sets of a topological space X",
      "B(ℙ) — regular open algebra of a forcing poset ℙ",
      "Meas(X)/Null — measure algebra (Borel sets modulo null sets)"
    ] }

/-- The regular open algebra of a partial order -/
structure RegularOpenAlgebra where
  poset : String
  construction : String
  properties : List String
  deriving Repr

/-- RO(ℙ) = complete Boolean algebra of regular open sets of ℙ -/
def regularOpenAlgebra : RegularOpenAlgebra :=
  { poset := "ℙ (separative partial order)"
    construction := "RO(ℙ) = {U ⊆ ℙ regular open}, ordered by inclusion.
      U is regular open if U = int(cl(U)) in the order topology"
    properties := [
      "RO(ℙ) is a complete Boolean algebra",
      "ℙ densely embeds into RO(ℙ) \\ {0}",
      "Forcing with ℙ is equivalent to Boolean-valued model with RO(ℙ)"
    ] }

/-! ## Measure Algebras and Random Forcing -/

/-- The measure algebra for random forcing -/
structure MeasureAlgebra where
  space : String
  construction : String
  isCompleteBoolean : Bool
  deriving Repr

/-- Borel(2^ω)/Null: the random algebra -/
def randomAlgebra : MeasureAlgebra :=
  { space := "2^ω (Cantor space)"
    construction := "Borel(2^ω) / Null = Borel sets modulo Lebesgue null sets"
    isCompleteBoolean := true }

/-- The measure algebra is CCC (countable chain condition) -/
def measureAlgebraCCC : String :=
  "Borel(2^ω)/Null is CCC: every antichain is countable;
  this ensures random forcing preserves cardinals"

/-! ## Heyting Algebras from ZFC -/

/-- Open sets form a Heyting algebra (model of intuitionistic logic) -/
structure HeytingAlgebra where
  name : String
  definition : String
  differsFromBoolean : String
  deriving Repr

/-- Heyting algebra of open sets -/
def openSetHeytingAlgebra : HeytingAlgebra :=
  { name := "O(X): Heyting algebra of open sets"
    definition := "The open sets of a topological space X, with implication
      U⇒V = int((X\\U)∪V), the interior of the complement of U union V"
    differsFromBoolean := "¬¬U ≠ U in general (double negation doesn't collapse)" }

/-- Forcing over a Heyting algebra gives a Kripke model -/
def forcingAsKripke : String :=
  "Forcing with a poset ℙ: the poset forms a Kripke frame for intuitionistic logic;
  forcing \\|\\- is the Kripke semantics for intuitionistic logic"

/-! ## Boolean-Valued Models and Algebra -/

/-- The algebra of truth values in V^𝔹 -/
structure TruthValueAlgebra where
  booleanAlgebra : String
  truthValues : String
  algebraOfClasses : String
  deriving Repr

/-- Truth values form a complete Boolean algebra -/
def truthValues : TruthValueAlgebra :=
  { booleanAlgebra := "𝔹 (complete)"
    truthValues := "For each sentence φ, ⟦φ⟧ ∈ 𝔹"
    algebraOfClasses := "The 'set' of truth values is a proper class Boolean algebra" }

/-! ## Lindenbaum Algebra -/

/-- The Lindenbaum algebra of ZFC: sentences modulo equivalence -/
structure LindenbaumAlgebra where
  theory : String
  construction : String
  properties : List String
  deriving Repr

/-- Lindenbaum algebra ZFC/≡ -/
def zfcLindenbaum : LindenbaumAlgebra :=
  { theory := "ZFC"
    construction := "Equivalence classes of sentences under ZFC-provable equivalence:
      φ∼ψ iff ZFC⊢φ↔ψ; operations: ∧, ∨, →, ¬ are well-defined on classes"
    properties := [
      "Boolean algebra (classical logic)",
      "Atomless: no sentence is atomic (for any φ, can split stronger/weaker)",
      "Every consistent extension T⊇ZFC corresponds to a filter on the algebra",
      "Complete extensions correspond to ultrafilters"
    ] }

/-! ## Evaluations -/

#eval powerSetBooleanAlgebra.properties
#eval completeBoolAlg.examples
#eval randomAlgebra.isCompleteBoolean
#eval openSetHeytingAlgebra.differsFromBoolean
#eval zfcLindenbaum.properties
#eval measureAlgebraCCC

end MiniZFCLite
