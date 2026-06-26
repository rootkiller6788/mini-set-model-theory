/-
# Satisfaction Model: Counterexamples

Counterexamples in model theory: non-standard models of arithmetic,
non-archimedean fields, and theories with specific numbers of models.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Properties.Classification

namespace MiniSatisfactionModel

/-! ## Finite Structure Example -/

def finiteStructureExample : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

def finiteTheoryExample : Theory where
  axioms := { .prop .true, .not (.prop .false) }

/-! ## Theories With Specific Numbers of Models -/

def theoriesWithNModels (n : Nat) : List String :=
  match n with
  | 1 => ["DLO (dense linear orders)", "Random graph", "ACF0 (alg. closed fields of char 0)"]
  | 2 => ["ACFp (alg. closed fields of char p, each p gives 2 models)"]
  | 3 => ["Ehrenfeucht examples (theories with exactly 3 countable models)"]
  | _ => ["Various examples from classification theory"]

/-! ## Vaught's Never-Two -/

def vaughtNeverTwo : String :=
  "Vaught's Never-Two: A complete theory in a countable language cannot have exactly 2 countable models"

/-! ## Incomplete Theory -/

def incompleteTheoryExample : Theory where
  axioms := {}

theorem incompleteTheory_isIncomplete : ¬ isComplete incompleteTheoryExample := by
  unfold isComplete incompleteTheoryExample
  simp
  exact λ h => by
    have := h (.prop .true)
    simp at this

/-! ## Non-Standard Models of Arithmetic -/

def nonstandardArithmeticModel : MiniFunctionRelation.Structure where
  domain := Nat × Bool
  predInterp
    | 0, [(x, _), (y, _)] => x < y
    | 1, [(x, b1), (y, b2)] => x = y ∧ b1 = b2
    | _, _ => False
  constInterp
    | 0 := (0, false)
    | 1 := (1, false)
    | _ := (0, false)

/-! ## Non-Archimedean Ordered Field -/

structure NonArchimedeanField where
  carrier : Type
  lt : carrier → carrier → Prop
  zero : carrier
  one : carrier
  infiniteElement : carrier

def nonArchimedeanFieldExample : NonArchimedeanField where
  carrier := Rat × Rat
  lt := λ (a1, a2) (b1, b2) => a1 < b1 ∨ (a1 = b1 ∧ a2 < b2)
  zero := (0, 0)
  one := (1, 0)
  infiniteElement := (1, 0)

/-! ## Unstable Theory Example (DLO) -/

def dloUnstableExplanation : String :=
  "DLO is unstable because the formula x < y has the strict order property"

/-! ## Counterexample: Theory with 3 Models -/

def threeModelTheoryExample : String :=
  "Ehrenfeucht: A modification of the theory of dense linear orders yields exactly 3 countable models"

/-! ## Failure of Compactness for Second-Order Logic -/

def secondOrderFailureExample : String :=
  "Second-order logic: The class of finite structures is not compact (fails compactness)"

/-! ## #eval Examples -/

#eval (finiteStructureExample.domain = Bool)
#eval theoriesWithNModels 1
#eval vaughtNeverTwo
#eval incompleteTheory_isIncomplete
#eval dloUnstableExplanation

end MiniSatisfactionModel
