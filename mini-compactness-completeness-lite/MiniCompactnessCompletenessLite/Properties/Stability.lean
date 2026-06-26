/-
# Stability Theory

Stability theory studies the number of types a theory admits.
A stable theory has few types (bounded by the size of the
parameter set). Key concepts: forking independence, stable
theories, superstability, and the order property.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCardinalOrdinal.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Stability Definition -/

def isStableTheory (T : Theory) : Prop :=
  -- A theory is stable if it does not have the order property
  -- Proper definition requires counting types, which needs type space infrastructure
  ¬ (hasOrderProperty T)

def isStableInκ (T : Theory) (κ : String) : Prop :=
  isStableTheory T

/-! ## Order Property -/

-- T has the order property if there exists a formula φ(x̄,ȳ) such that in some model of T,
-- there are infinite sequences (aᵢ), (bⱼ) with φ(aᵢ,bⱼ) iff i < j.
-- Proper formalization requires infinite sequences and ordinal-indexed families.
-- TODO: Formalize with infinite sequence infrastructure.
axiom hasOrderProperty_axiom (T : Theory) : Prop

def hasOrderProperty (T : Theory) : Prop :=
  hasOrderProperty_axiom T

def orderPropertyStatement : String :=
  "A theory is unstable iff it has the order property: there exists a formula φ(x̄, ȳ) and sequences (ā_i), (b̄_j) such that ⊨ φ(ā_i, b̄_j) iff i < j."

def independenceProperty : String :=
  "A formula has the independence property (IP) if there are sequences (ā_i) and (b̄_S) for S ⊆ I such that φ(ā_i, b̄_S) holds iff i ∈ S."

def strictOrderProperty : String :=
  "A formula has the strict order property (SOP) if it defines a partial order with arbitrarily long finite chains."

def treeProperty : String :=
  "The tree property (TP) characterizes simplicity. A theory is simple if no formula has the tree property. Simple theories generalize stable theories."

/-! ## Forking Independence -/

def forkingIndependenceStatement : String :=
  "Forking independence a ⊧_C b: In a stable theory, this relation satisfies: (1) Invariance, (2) Symmetry, (3) Transitivity, (4) Local character, (5) Extension."

def canonicalBases : String :=
  "In stable theories, every stationary type has a canonical base (the smallest set over which it is defined and does not fork)."

/-! ## Stability Hierarchy -/

def stabilityHierarchyDesc : String :=
  "Stability hierarchy: ω-stable ⊂ superstable ⊂ stable. Totally transcendental = ω-stable for countable theories. Stable theories have ≤ |A|^ℵ₀ types over A."

def ωStableProperty : String :=
  "T is ω-stable if S₁(A) is countable for all countable A. Equivalent to: Morley rank is well-defined on all formulas."

def superstableProperty : String :=
  "Superstable: T is stable and no formula has the order property with forking chains. Equivalently: S(A) ≤ |A|^ℵ₀ fails for κ = ℵ₀."

/-! ## Simple Theories -/

-- T has the tree property if some formula has the k-tree property for all k.
-- TODO: Formalize with combinatorial tree infrastructure.
axiom hasTreeProperty_axiom (T : Theory) : Prop

def hasTreeProperty (T : Theory) : Prop :=
  hasTreeProperty_axiom T

def isSimpleTheory (T : Theory) : Prop :=
  ¬ hasTreeProperty T

/-! ## NIP and NSOP Theories -/

-- A formula φ(x;y) has the independence property in T if...
-- TODO: Formalize with indiscernible sequence infrastructure.
axiom hasIndependencePropertyFormula_axiom (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop

def hasIndependencePropertyFormula (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  hasIndependencePropertyFormula_axiom T φ

def isNIPTheory (T : Theory) : Prop :=
  ¬ ∃ (φ : MiniLogicKernel.PredFormula), hasIndependencePropertyFormula T φ

-- A formula has the strict order property in T if...
axiom hasStrictOrderPropertyFormula_axiom (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop

def hasStrictOrderPropertyFormula (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  hasStrictOrderPropertyFormula_axiom T φ

def isNSOPTheory (T : Theory) : Prop :=
  ¬ ∃ (φ : MiniLogicKernel.PredFormula), hasStrictOrderPropertyFormula T φ

--- #eval ---

#eval orderPropertyStatement : String
#eval forkingIndependenceStatement : String
#eval stabilityHierarchyDesc : String
#eval ωStableProperty : String
#eval "Simple theories and NIP/NSOP classification" : String

end MiniCompactnessCompletenessLite
