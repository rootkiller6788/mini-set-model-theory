/-
# Counterexamples in Model Theory

Examples illustrating the boundaries of model-theoretic phenomena:
non-axiomatizable classes, incomplete but consistent theories,
and failures of preservation theorems.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniFunctionRelation.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Finite Structures -/

def finiteStructure (n : Nat) : MiniFunctionRelation.Structure where
  domain := Fin n
  predInterp _ _ := False
  constInterp _ := 0

/-! ## Non-axiomatizable Classes -/

def nonAxiomatizableClasses : List String := [
  "Well-orders (not first-order axiomatizable by compactness)",
  "Finite structures (by compactness, if T has arbitrarily large finite models, T has an infinite model)",
  "Connected graphs (not first-order axiomatizable: Δ-elementary but not Σ-elementary)",
  "Torsion groups (not finitely axiomatizable, but recursively axiomatizable)"
]

def nonAxiomatizableStatement : String :=
  "The class of finite sets is not first-order axiomatizable. Proof: suppose T axiomatizes it. Then T has arbitrarily large finite models, so by compactness T has an infinite model -- contradiction."

def nonAxiomatizableConnectedGraph : String :=
  "The class of connected graphs is not first-order axiomatizable. For each n, there is a graph G_n that looks connected within distance n but is actually disconnected."

/-! ## Theories with Exactly N Models -/

def theoriesWithNModels : List (String × Nat) := [
  ("DLO", 1),
  ("ACF0", 0),
  ("RCF", 0),
  ("Algebraic bounded Z-groups", 2),
  ("Ehrenfeucht theories", 3)
]

def ehrenfeuchtExample : String :=
  "Ehrenfeucht constructed a theory with exactly 3 countable models (Dense linear order with a distinguished dense-codense subset)."

def peretyatkinExample : String :=
  "Peretyatkin showed that for any n ≥ 3, there exists a theory with exactly n countable models."

/-! ## Incomplete but Consistent Theories -/

def incompleteTheoryExample : String := "The theory of groups is incomplete (not all groups are elementarily equivalent)"

def counterexamplesSummary : String :=
  "Counterexamples: finite structures, non-standard models, incomplete theories, non-axiomatizable classes."

def incompleteTheories : List String := [
  "Theory of groups (incomplete: ∃ groups elementarily inequivalent)",
  "Theory of rings (incomplete)",
  "Theory of fields of characteristic 0 (incomplete modulo ACF0)",
  "Theory of graphs (incomplete)",
  "Empty theory in a language with one binary relation"
]

/-! ## Failures of ℵ₀-Categoricity -/

def nonAleph0CategoricalTheories : List String :=
  ["RCF (uncountably many countable models)",
   "ACF0 (ℵ₀ countable models, classified by transcendence degree)",
   "Peano Arithmetic (2^ℵ₀ countable models)",
   "ZFC (2^ℵ₀ countable models if consistent)"]

/-! ## Non-Standard Models -/

def nonStandardModels : String :=
  "By compactness, any theory with infinite models has non-standard (non-isomorphic) models. E.g., non-standard models of arithmetic have 'infinite' natural numbers."

def nonStandardAnalysisConnection : String :=
  "Non-standard analysis (Robinson) uses non-standard models of R (hyperreals) to develop analysis with infinitesimals."

--- #eval ---

#eval finiteStructure 3 : MiniFunctionRelation.Structure

#eval theoriesWithNModels : List (String × Nat)

#eval incompleteTheoryExample : String

#eval counterexamplesSummary : String

#eval nonAxiomatizableClasses : List String

end MiniCompactnessCompletenessLite
