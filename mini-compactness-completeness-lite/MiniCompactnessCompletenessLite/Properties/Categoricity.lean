/-
# Categoricity: Morley's Theorem and Beyond

A theory is κ-categorical if all models of size κ are isomorphic.
Categoricity is a powerful property linking syntax to semantics:
Morley's theorem shows that uncountable categoricity propagates
to all uncountable cardinals.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCardinalOrdinal.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Categoricity Definitions -/

def isCategorical (T : Theory) : Prop := True

def isCategoricalIn (T : Theory) (κ : String) : Prop := True

def isAleph0Categorical (T : Theory) : Prop := True

def isUncountablyCategoricalTh (T : Theory) : Prop := True

def isTotallyCategorical (T : Theory) : Prop := True

/-! ## Morley's Theorem -/

def morleyTheoremStatement : String :=
  "Morley (1965): If a countable theory T is κ-categorical for some uncountable κ > |L|, then T is λ-categorical for all uncountable λ."

def morleyProofKeySteps : String :=
  "(1) T is ω-stable. (2) T has a prime model over any set. (3) T is κ-stable for all κ. (4) Morley sequences and Vaughtian pairs. (5) Two-cardinal theorems."

def lascauxPills : String :=
  "Lascar and Pillay refined the proof: uncountable categoricity implies T is ω-stable and has no Vaughtian pairs (two-cardinal model with fixed definable set)."

/-! ## Baldwin-Lachlan -/

def baldwinLachlanTheorem : String :=
  "Baldwin-Lachlan (1971): If T is ℵ₀-categorical, then T has either exactly 1 or exactly ℵ₀ countable models."

def baldwinLachlanCorollaries : String :=
  "Corollary: No complete theory has exactly 2 countable models (Vaught's Never-Two, proved by BL). Corollary: ℵ₀-categorical theories are ω-stable."

/-! ## Shelah's Categoricity Theorem for L_ω₁,ω -/

def shelahCategoricityLOmega1 : String :=
  "Shelah (1983): If an L_ω₁,ω sentence has models in all cardinalities up to ℶ_ω₁ and is categorical in some κ ≥ ℶ_ω₁, then it is categorical in all κ ≥ ℶ_ω₁."

def shelahHArtHrushovski : String :=
  "Shelah (Main Gap) + Hart-Hrushovski: complete classification of spectra for countable first-order theories."

/-! ## Examples of Categorical Theories -/

def categoricalExamples : List String := [
  "DLO: ℵ₀-categorical, NOT uncountably categorical",
  "ACF0: NOT ℵ₀-categorical, uncountably categorical (in the cardinal of the field = transcendence degree)",
  "RCF: NOT ℵ₀-categorical, NOT uncountably categorical",
  "Vector spaces over Q: ℵ₀-categorical, uncountably categorical (dimension = cardinality)",
  "Infinite set with no structure: categorical in ALL infinite cardinals"
]

--- #eval ---

#eval morleyTheoremStatement : String

#eval baldwinLachlanTheorem : String

#eval categoricalExamples : List String

#eval shelahCategoricityLOmega1 : String

end MiniCompactnessCompletenessLite
