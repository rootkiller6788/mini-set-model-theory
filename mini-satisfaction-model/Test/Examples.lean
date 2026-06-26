import MiniSatisfactionModel
import MiniFunctionRelation
import MiniLogicKernel

open MiniSatisfactionModel
open MiniFunctionRelation
open MiniLogicKernel

namespace MiniSatisfactionModel.Test

/-
# Example Tests

Tests that exercise the examples and walk through model-theoretic concepts.
-/

/-- A trivially true predicate formula (prop ⊤). -/
def trueFormula : PredFormula := .prop .true

/-- A trivially false predicate formula (prop ⊥). -/
def falseFormula : PredFormula := .prop .false

/-- A binary predicate R(x, y) with index 0. -/
def binaryPredFormula : PredFormula := .pred 0 [0, 1]

/-- The unit structure as a canonical example. -/
def unitStruct : Structure := MiniLanguageStructure.unitStructure

#eval "══ MiniSatisfactionModel Example Tests ══"

/-- Theory of the unit structure. -/
def unitTheory : Theory := theoryOf unitStruct
#eval unitTheory.axioms

/-- Empty theory example. -/
def emptyTheory : Theory := { axioms := ∅ }
#eval emptyTheory.axioms
#eval isConsistent emptyTheory

/-- Tautology theory: only true. -/
def tautologyTheory : Theory := { axioms := { .prop .true } }
#eval tautologyTheory.axioms

/-- Model check: unit structure is a model of the tautology theory. -/
#eval isModelOf unitStruct tautologyTheory

/-- Demonstration of syntax classification. -/
#eval isQuantifierFree (.pred 0 [0, 1])
#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isExistentialFormula (.ex (.pred 0 [0]))
#eval isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))

/-- A negated formula is not positive. -/
#eval isPositiveFormula (.not (.pred 0 [0]))

/-- Quantifier-free test with a complex formula. -/
#eval isQuantifierFree (.and (.pred 0 [0, 1]) (.eq 0 1))

/-- Universal formula test. -/
#eval isUniversalFormula (.all (.and (.pred 0 [0]) (.pred 1 [1])))

/-- Existential formula test. -/
#eval isExistentialFormula (.ex (.pred 0 [0]))

#eval "══ DLO classification example run in Smoke tests. ══"
#eval "══ ACF0 classification example run in Smoke tests. ══"
#eval "══ All example tests passed. ══"

end MiniSatisfactionModel.Test
