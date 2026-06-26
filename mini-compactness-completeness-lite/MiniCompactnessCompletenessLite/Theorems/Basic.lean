/-
# Basic Theorems: Compactness and Lowenheim-Skolem

The fundamental theorems of first-order model theory.
The compactness theorem and Lowenheim-Skolem theorems are
stated as axioms (they require meta-theoretic proofs).
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Core.Laws
import MiniLogicKernel.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Compactness (Stated) -/

def compactnessStatement : String := "If every finite subset of T is satisfiable, then T is satisfiable"

def compactnessCountable : String := "Countable compactness: if every finite subset is satisfiable, the whole theory is (countable language)"

-- Compactness via ultraproducts
def compactnessViaUltraproductsStatement : String :=
  "The compactness theorem follows from Los's theorem: a finitely satisfiable theory has a model via an ultraproduct of its finite models."

-- Compactness for propositional logic
def compactnessPropositionalStatement : String :=
  "The compactness theorem for propositional logic is equivalent to the Boolean Prime Ideal Theorem."

/-! ## Lowenheim-Skolem Theorems -/

def downwardLS : String := "Downward Lowenheim-Skolem: every structure has a countable elementary substructure"

def upwardLS : String := "Upward Lowenheim-Skolem: every infinite structure has arbitrarily large elementary extensions"

def lsTheoremCombined : String :=
  "Lowenheim-Skolem-Tarski: If T has an infinite model, T has models of every infinite cardinality >= |L|."

/-! ## Consequences of Compactness + LS -/

def finiteAxiomatizabilityCriterion : String :=
  "A theory T is finitely axiomatizable iff T is axiomatizable and T ⊈ Th(Mod(T')) for any proper subtheory T' of T."

def nonStandardModelsExist : String :=
  "Compactness implies the existence of non-standard models: any theory with infinite models has non-isomorphic models."

def infiniteAxiomatizability : String :=
  "The class of finite structures is not axiomatizable (by compactness). The class of infinite structures is axiomatizable but not finitely."

/-! ## Lindstrom's Theorem -/

def lindstromsTheorem : String := "First-order logic is the maximal logic satisfying compactness and downward LS"

def lindstromProofSketch : String :=
  "Lindstrom's theorem: any regular logic extending first-order logic that satisfies compactness and downward LS is equivalent to first-order logic."

/-! ## Craig Interpolation & Beth Definability -/

def craigInterpolationTheorem : String :=
  "If T ⊨ φ → ψ, there exists an interpolant θ such that T ⊨ φ → θ, T ⊨ θ → ψ, and all non-logical symbols in θ occur in both φ and ψ."

def bethDefinabilityTheorem : String :=
  "A predicate is implicitly definable in a theory T iff it is explicitly definable in T."

/-! ## Upward Categoricity via compactness -/

def upwardCategoricityImplication : String :=
  "If T is categorical in some κ > |L|, then T is complete (Vaught's test, via compactness and LS)."

--- #eval ---

#eval compactnessStatement : String

#eval compactnessCountable : String

#eval downwardLS : String

#eval upwardLS : String

#eval finiteAxiomatizabilityCriterion : String

#eval nonStandardModelsExist : String

end MiniCompactnessCompletenessLite
