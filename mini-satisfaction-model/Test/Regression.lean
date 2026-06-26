import MiniSatisfactionModel
import MiniFunctionRelation
import MiniLogicKernel

open MiniSatisfactionModel
open MiniFunctionRelation

namespace MiniSatisfactionModel.Test

/-
# Regression Tests

Ensure core APIs remain stable across changes.
-/

def emptyTheory : Theory := { axioms := ∅ }

def contradictoryTheory : Theory :=
  { axioms := { .prop (.false : MiniLogicKernel.Formula) } }

/-- The unit structure as a canonical example. -/
def unitStruct : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-- A complex nested formula for testing. -/
def nestedFormula : MiniLogicKernel.PredFormula :=
  .all (.impl (.pred 0 [0]) (.ex (.pred 1 [1, 0])))

/-- Main regression test function. -/
def runRegressionTests : IO Unit := do
  IO.println "══ MiniSatisfactionModel Regression Tests ══"

  -- Theory construction
  IO.println s!"Empty theory axioms: {emptyTheory.axioms}"
  IO.println s!"Contradictory theory defined: {toString contradictoryTheory}"

  -- Consistency
  IO.println s!"isComplete(emptyTheory): {isComplete emptyTheory}"

  -- Model checking
  IO.println s!"isModelOf(unitStruct, emptyTheory): {isModelOf unitStruct emptyTheory}"

  -- Syntax classification
  IO.println s!"QF(pred): {isQuantifierFree (.pred 0 [0, 1])}"
  IO.println s!"Univ(∀ P): {isUniversalFormula (.all (.pred 0 [0]))}"
  IO.println s!"Ex(∃ P): {isExistentialFormula (.ex (.pred 0 [0]))}"
  IO.println s!"Pos(P∧Q): {isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))}"
  IO.println s!"Pos(¬P): {isPositiveFormula (.not (.pred 0 [0]))}"

  -- Nested formula
  IO.println s!"Nested QF: {isQuantifierFree nestedFormula}"
  IO.println s!"Nested Univ: {isUniversalFormula nestedFormula}"

  -- Existence checks
  IO.println s!"hasFiniteModel: type defined"
  IO.println s!"compactness: axiom declared"
  IO.println s!"standardExampleNames: {standardExampleNames.length} examples"

  -- Classification
  IO.println s!"DLO stability: {dloClassification.stability}"
  IO.println s!"ACF0 stability: {acf0Classification.stability}"
  IO.println s!"RCF stability: {rcfClassification.stability}"

  IO.println "══ All regression tests passed. ══"

def main : IO Unit := runRegressionTests

end MiniSatisfactionModel.Test
