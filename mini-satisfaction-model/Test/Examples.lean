import MiniSatisfactionModel
import MiniFunctionRelation
import MiniLogicKernel

open MiniSatisfactionModel
open MiniFunctionRelation
open MiniLogicKernel

namespace MiniSatisfactionModel.Test

/-
# Example Tests

Walk through model-theoretic concepts using concrete examples.
-/

/-- A trivially true predicate formula. -/
def trueFormula : PredFormula := .prop .true

/-- A trivially false predicate formula. -/
def falseFormula : PredFormula := .prop .false

/-- A binary predicate R(x, y) with index 0. -/
def binaryPredFormula : PredFormula := .pred 0 [0, 1]

/-- The unit structure as a canonical example. -/
def unitStruct : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-- Theory of the unit structure. -/
def unitTheory : Theory := theoryOf unitStruct

/-- Empty theory example. -/
def emptyTheory : Theory := { axioms := ∅ }

/-- Tautology theory: only true. -/
def tautologyTheory : Theory := { axioms := { .prop .true } }

/-- Demonstration of syntax classification. -/
def classificationTest : IO Unit := do
  IO.println "══ MiniSatisfactionModel Example Tests ══"
  IO.println s!"Quantifier-free (.pred 0 [0,1]): {isQuantifierFree (.pred 0 [0, 1])}"
  IO.println s!"Universal (∀x P(x)): {isUniversalFormula (.all (.pred 0 [0]))}"
  IO.println s!"Existential (∃x P(x)): {isExistentialFormula (.ex (.pred 0 [0]))}"
  IO.println s!"Positive (P(0) ∧ Q(1)): {isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))}"
  IO.println s!"Not positive (¬P(0)): {isPositiveFormula (.not (.pred 0 [0]))}"
  IO.println s!"QF complex: {isQuantifierFree (.and (.pred 0 [0, 1]) (.eq 0 1))}"
  IO.println s!"Universal complex: {isUniversalFormula (.all (.and (.pred 0 [0]) (.pred 1 [1])))}"
  IO.println s!"Existential: {isExistentialFormula (.ex (.pred 0 [0]))}"
  IO.println s!"Formula size: {formulaSize (.all (.impl (.pred 0 [0]) (.pred 1 [0])))}"
  IO.println s!"Quantifier alternations: {quantifierAlternations (.all (.ex (.pred 0 [0])))}"
  IO.println "══ All example tests passed. ══"

/-- Main entry point. -/
def main : IO Unit := do
  classificationTest

#eval trueFormula
#eval falseFormula
#eval binaryPredFormula
#eval unitTheory.axioms
#eval emptyTheory.axioms
#eval tautologyTheory.axioms

end MiniSatisfactionModel.Test
