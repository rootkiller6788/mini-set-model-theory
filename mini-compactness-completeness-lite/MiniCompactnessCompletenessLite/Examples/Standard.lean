/-
# Standard Examples of Model Theory

Classic examples: Dense Linear Orders (DLO), Algebraically Closed Fields (ACF),
Real Closed Fields (RCF), and the Random Graph. These illustrate
completeness, ω-categoricity, quantifier elimination, and stability.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Core.Laws
import MiniLogicKernel.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Dense Linear Order Without Endpoints (DLO) -/

def dloLanguageFormula (rel : Nat) (x y : Nat) : MiniLogicKernel.PredFormula :=
  MiniLogicKernel.PredFormula.pred rel [x, y]

def dloProperties : List String :=
  ["Transitive", "Antisymmetric (total order)", "Dense",
   "No least element", "No greatest element"]

def dloAxioms : Theory :=
  { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def dloCompleteness : String :=
  "DLO is ℵ₀-categorical (back-and-forth), hence complete by Vaught's test."

def dloQE : String :=
  "DLO has quantifier elimination: every formula is equivalent to a Boolean combination of atomic formulas in the language {<}."

/-! ## Algebraically Closed Fields (ACF) -/

def acfAxioms : Theory :=
  { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def acfCompleteness : String :=
  "ACFp (p prime or 0) is complete. ACF is model-complete but not complete (characteristic not fixed)."

def acfQE : String :=
  "ACF has quantifier elimination in the language {+, ·, 0, 1}. This is Chevalley's theorem (Tarski)."

/-! ## Real Closed Fields (RCF) -/

def rcfAxioms : Theory :=
  { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def rcfProperties : List String :=
  ["Ordered field", "Every positive element has a square root",
   "Every odd-degree polynomial has a root"]

def rcfCompleteness : String :=
  "RCF is complete and decidable (Tarski-Seidenberg). Not ℵ₀-categorical (Archimedean vs non-Archimedean)."

/-! ## Random Graph (Rado Graph) -/

def randomGraphAxioms : List String :=
  ["Irreflexive and symmetric", "For any finite disjoint U,V, ∃ x adjacent to all u∈U and no v∈V"]

def radoGraphCompleteness : String :=
  "The theory of the random graph is ℵ₀-categorical, complete, with quantifier elimination. The unique countable model is the Rado graph."

def radoGraphStability : String :=
  "The random graph is simple unstable (has the independence property, IP)."

/-! ## Dense Linear Order with Left Endpoint -/

def dloWithEndpointProperties : String :=
  "Adding an endpoint to DLO yields a non-ℵ₀-categorical but still complete theory. The back-and-forth argument fails because the endpoint is a distinguished element."

--- #eval ---

#eval dloProperties : List String

#eval dloCompleteness : String

#eval acfQE : String

#eval rcfCompleteness : String

#eval radoGraphCompleteness : String

end MiniCompactnessCompletenessLite
