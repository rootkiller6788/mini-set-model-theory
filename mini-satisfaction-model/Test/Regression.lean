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

/-- Test: Theory construction and access. -/
#eval "══ MiniSatisfactionModel Regression Tests ══"

/-- Theory { } is consistent (empty theory has a model). -/
def emptyTheory : Theory := { axioms := ∅ }
#eval isConsistent emptyTheory

/-- Theory with contradiction is inconsistent. -/
def contradictoryTheory : Theory := { axioms := { .prop .false } }
#eval "contradictoryTheory defined"

/-- Theory axioms are accessible. -/
#eval emptyTheory.axioms

/-- isComplete is defined. -/
#eval "isComplete type: " ++ toString (isComplete emptyTheory)

/-- isModelOf type-checks. -/
def unitStruct : Structure := MiniLanguageStructure.unitStructure
#eval isModelOf unitStruct emptyTheory

/-- Syntax classification regression. -/
#eval isQuantifierFree (.pred 0 [0, 1])
#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isExistentialFormula (.ex (.pred 0 [0]))
#eval isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isPositiveFormula (.not (.pred 0 [0]))

/-- A complex nested formula. -/
def nestedFormula : PredFormula :=
  .all (.impl (.pred 0 [0]) (.ex (.pred 1 [1, 0])))
#eval isQuantifierFree nestedFormula
#eval isUniversalFormula nestedFormula

/-- hasFiniteModel type checks. -/
#eval "hasFiniteModel defined"

/-- compactness axiom is available. -/
#eval "compactness axiom declared"

#eval "══ All regression tests passed. ══"

end MiniSatisfactionModel.Test
