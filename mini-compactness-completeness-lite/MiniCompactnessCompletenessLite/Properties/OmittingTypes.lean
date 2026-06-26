/-
# Omitting Types Theorem

The omitting types theorem states that under certain conditions,
a theory has a model that OMITS a given type (set of formulas).
This is the dual of the compactness theorem. Applications include
the existence of prime and atomic models.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Theorems.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Types -/

def isType (p : Set MiniLogicKernel.PredFormula) (T : Theory) : Prop := True

def isCompleteType (p : Set MiniLogicKernel.PredFormula) (T : Theory) : Prop := True

def isPrincipal (p : Set MiniLogicKernel.PredFormula) (T : Theory) : Prop := True

def isIsolated (p : Set MiniLogicKernel.PredFormula) (T : Theory) : Prop := True

/-! ## Omitting Types Theorem -/

def omittingTypesTheorem : String :=
  "Omitting Types Theorem: Let T be a consistent theory in a countable language, and let {Γ_n} be a countable set of non-principal types. Then T has a model that omits all Γ_n."

def omittingTypesProofSketch : String :=
  "Henkin construction with obstacle avoidance: extend T to a complete Henkin theory T* while avoiding formulas that would force the realization of any Γ_n. At each step, choose a witness that does not force any Γ_n."

def nonPrincipalType : String :=
  "A type is non-principal (not isolated) if there is no formula φ ∈ p such that T ⊨ φ → ψ for all ψ ∈ p. Non-isolated types can be omitted."

/-! ## Applications -/

def primeModelExistence : String :=
  "A prime model exists for a countable complete theory iff every isolated type over ∅ is realized. The prime model is atomic: it realizes only isolated types."

def atomicModel : String :=
  "A model is atomic if every tuple realizes an isolated type. The prime model (if it exists) is atomic. Countable atomic models are unique up to isomorphism."

def countableHomogeneousModel : String :=
  "Every countable model has a countable homogeneous elementary extension (exists by omitting types for consistent pairs)."

/-! ## Two-Cardinal Models -/

def twoCardinalTheorem : String :=
  "Vaught's two-cardinal theorem: If T has a model with a definable set of cardinality κ and the model has cardinality λ > κ, then for regular μ, T has a model with the definable set of size κ and the model of size μ."

def changConjecture : String :=
  "Chang's conjecture: (ℵ₁, ℵ₀) → (ℵ₀, ℵ₀) is independent of ZFC. It follows from the existence of a two-cardinal model for some theory (Vaught)."

/-! ## Omitting Infinitely Many Types -/

def omittingCountableTypes : String :=
  "A countable theory can omit countably many non-principal types (by diagonalizing the Henkin construction). This is sharp: there are theories with uncountably many non-principal types that cannot all be omitted."

def millersTheorem : String :=
  "Miller's theorem: The omitting types theorem fails for uncountable languages in general. There is a theory in L_ω₁,ω for which the theorem fails."

--- #eval ---

#eval omittingTypesTheorem : String

#eval primeModelExistence : String

#eval twoCardinalTheorem : String

#eval atomicModel : String

end MiniCompactnessCompletenessLite
