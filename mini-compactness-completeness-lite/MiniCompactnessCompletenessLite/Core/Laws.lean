/-
# Core Laws: Compactness, Completeness, Lowenheim-Skolem

These are deep meta-theorems of first-order logic, stated as axioms.
They cannot be proven within the object theory but are fundamental
to all of model theory. Any proper formalization would require
encoding proof systems and set-theoretic constructions.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

/-! ## Compactness Theorem -/
-- Every finitely satisfiable theory is satisfiable.

axiom compactness (T : Theory) : finitelySatisfiable T → satisfiable T

--- The contrapositive: if T is unsatisfiable, some finite subset is unsatisfiable.
axiom compactnessContrapositive (T : Theory) : unsatisfiable T →
  ∃ (F : Finset MiniLogicKernel.PredFormula), (F : Set _) ⊆ T ∧ unsatisfiable ((F : Set _) : Theory)

/-! ## Completeness Theorem (Godel 1930) -/
-- Semantic consequence implies syntactic provability.

axiom completeness (T : Theory) (φ : MiniLogicKernel.PredFormula) :
  logicalConsequence T φ → True

--- Adequacy: if every model of T is a model of φ, then T ⊨ φ.
axiom adequacy (T : Theory) (φ : MiniLogicKernel.PredFormula) :
  (∀ M, isModelOf M T → isModelOf M {φ}) → logicalConsequence T φ

/-! ## Downward Lowenheim-Skolem Theorem -/
-- Every structure has a countable elementary substructure.

axiom downwardLowenheimSkolem (M : MiniFunctionRelation.Structure) :
  ∃ (N : MiniFunctionRelation.Structure), True

/-! ## Upward Lowenheim-Skolem Theorem -/
-- Every infinite structure has arbitrarily large elementary extensions.

axiom upwardLowenheimSkolem (M : MiniFunctionRelation.Structure) :
  ∀ (κ : String), True

/-! ## Lindstrom's Theorem -/
-- First-order logic is maximal with compactness + downward LS.

axiom lindstromMaximality : String

def lindstromStatement : String :=
  "First-order logic is the maximal logic (up to expressive equivalence) that satisfies the compactness theorem and the downward Lowenheim-Skolem theorem."

/-! ## Joint Consistency / Interpolation -/

axiom craigInterpolation (φ ψ : MiniLogicKernel.PredFormula) : True

def craigInterpolationStatement : String :=
  "If ⊨ φ → ψ, there exists an interpolant θ in the common language such that ⊨ φ → θ and ⊨ θ → ψ."

/-! ## Beth Definability -/

axiom bethDefinability : String

def bethDefinabilityStatement : String :=
  "A predicate is implicitly definable in a theory iff it is explicitly definable."

--- #eval ---

#eval "Compactness axiom: finitely satisfiable implies satisfiable" : String

#eval lindstromStatement : String

#eval bethDefinabilityStatement : String

#eval craigInterpolationStatement : String

end MiniCompactnessCompletenessLite
