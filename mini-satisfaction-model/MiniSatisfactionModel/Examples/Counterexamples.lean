/-
# Satisfaction Model: Counterexamples

Counterexamples in model theory: non-standard models, Ehrenfeucht
theories, Vaught's Never-Two, failure of compactness for SO logic,
and theories with specific numbers of models. Covers L6.

## Knowledge Coverage
- L6: Counterexamples illustrating boundaries of theorems
- L7: Applications: non-standard analysis, model-theoretic pathology
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Properties.Classification

namespace MiniSatisfactionModel

/-! ## Finite Structures -/

def finiteStructureExample : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

def finiteTheoryExample : Theory where
  axioms := { .prop (.true : MiniLogicKernel.Formula),
              .not (.prop (.false : MiniLogicKernel.Formula)) }

/-! ## Theories With Specific Numbers of Countable Models -/

def theoriesWithNModels (n : Nat) : List String :=
  match n with
  | 1 => ["DLO (dense linear orders)",
          "Random graph (Rado graph)",
          "ACF0 (alg. closed fields of char 0 — only in uncountable powers)",
          "Vector spaces over ℚ (fixed dimension)"]
  | 2 => ["Vaught: No theory has exactly 2 countable models!",
          "ACFp has continuum many models in ℵ₀"]
  | 3 => ["Ehrenfeucht example: theory with exactly 3 countable models",
          "Construction uses a dense linear order with 3 color classes"]
  | 4 => ["Ehrenfeucht generalizations: exactly n models for any n ≠ 2"]
  | _ => ["Classification program provides examples for many n"]

/-! ## Vaught's Never-Two -/

def vaughtNeverTwo : String :=
  "Vaught's Never-Two: A complete theory in a countable language cannot have exactly 2 countable models"

def vaughtNeverTwoProofIdea : String :=
  "Proof idea: If there are 2 models, both must be isolated in the Polish space S(T). But then they're isomorphic."

/-! ## Incomplete Theory -/

def incompleteTheoryExample : Theory where
  axioms := {}

theorem incompleteTheory_isIncomplete : ¬ isComplete incompleteTheoryExample := by
  unfold isComplete incompleteTheoryExample
  simp
  intro h
  have hP := h (.prop (.true : MiniLogicKernel.Formula))
  simp at hP

/-! ## Non-Standard Models of Arithmetic

By compactness, Peano Arithmetic has non-standard models containing
"infinite" natural numbers. These are essential for non-standard analysis. -/

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

def nonstandardModelExists : String :=
  "Compactness: Add constant c with axioms n < c for all n ∈ ℕ. Every finite subset is satisfiable → non-standard model."

/-! ## Non-Archimedean Ordered Fields

Ordered fields can contain "infinitesimal" and "infinite" elements.
Non-archimedean fields are models of the theory of ordered fields
that are NOT isomorphic to a subfield of ℝ. -/

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

/-! ## Failure of Compactness for Second-Order Logic -/

def secondOrderFailureExample : String :=
  "SO logic: The class of finite structures is axiomatized by an SO sentence, but the class of infinite structures is not compact."

def secondOrderCompactnessFailure : String :=
  "Counterexample: Φ = {∃x₁...xₙ (all distinct) | n ∈ ℕ} ∪ {∀x∃y (x < y)}. Every finite subset is satisfiable but Φ is not."

/-! ## Total Order without DLO Property -/

def discreteOrderStructure : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp
    | 0, [x, y] => x < y
    | _, _ => False
  constInterp _ := 0

def discreteVsDenseCounterexample : String :=
  "(ℕ, <) is a discrete order; (ℚ, <) is dense. Both are linear orders but not elementarily equivalent (ℕ has a least element, ℚ does not)."

/-! ## Abelian Groups with Different Model-Theoretic Properties -/

def torsionGroupExample : String :=
  "Torsion abelian groups: QE in Presburger language, but not stable (has the independence property via cyclic order)"

def divisibleGroupExample : String :=
  "Divisible abelian groups: ω-stable, every model is determined by the ranks of its p-primary components"

/-! ## Fields with Wild Model Theory -/

def differentiallyClosedFieldExample : String :=
  "DCF0 (differentially closed fields of char 0): ω-stable, Morley rank = Lascar rank = differential transcendence degree"

def pseudoAlgebraicallyClosedFieldExample : String :=
  "PAC fields: Simple theories, not stable. Model companion is the theory of perfect PAC fields"

/-! ## #eval Examples -/

#eval (finiteStructureExample.domain = Bool)
#eval theoriesWithNModels 1
#eval theoriesWithNModels 3
#eval vaughtNeverTwo
#eval vaughtNeverTwoProofIdea
#eval incompleteTheory_isIncomplete
#eval nonstandardModelExists
#eval secondOrderCompactnessFailure
#eval discreteVsDenseCounterexample
#eval torsionGroupExample
#eval divisibleGroupExample
#eval differentiallyClosedFieldExample
#eval pseudoAlgebraicallyClosedFieldExample

end MiniSatisfactionModel
