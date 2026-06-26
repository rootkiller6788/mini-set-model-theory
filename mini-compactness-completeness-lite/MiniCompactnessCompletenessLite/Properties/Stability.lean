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

def isStableTheory (T : Theory) : Prop := True

def isStableInκ (T : Theory) (κ : String) : Prop := True

/-! ## Order Property -/

def hasOrderProperty (T : Theory) : Prop := True

def orderPropertyStatement : String :=
  "A theory is unstable iff it has the order property: there exists a formula φ(x̄, ȳ) and sequences (ā_i), (b̄_j) such that ⊨ φ(ā_i, b̄_j) iff i < j."

def independenceProperty : String :=
  "A formula has the independence property (IP) if there are sequences (ā_i) and (b̄_S) for S ⊆ I such that φ(ā_i, b̄_S) holds iff i ∈ S."

def strictOrderProperty : String :=
  "A formula has the strict order property (SOP) if it defines a partial order with arbitrarily long finite chains."

def treeProperty : String :=
  "The tree property (TP) characterizes simplicity. A theory is simple if no formula has the tree property. Simple theories generalize stable theories."

/-! ## Forking Independence -/

def forkingIndependence (T : Theory) (a b C : String) : Prop := True

def forkingStatement : String :=
  "In a stable theory, forking independence satisfies: (1) Invariance, (2) Symmetry: a ⊧_C b ↔ b ⊧_C a, (3) Transitivity, (4) Local character, (5) Extension: every type over A has a non-forking extension to any B ⊇ A."

def canonicalBases : String :=
  "In stable theories, every stationary type has a canonical base (the smallest set over which it is defined and does not fork)."

/-! ## Stability Hierarchy -/

def stabilityHierarchyDesc : String :=
  "Stability hierarchy: ω-stable ⊂ superstable ⊂ stable. Totally transcendental = ω-stable for countable theories. Stable theories have ≤ |A|^ℵ₀ types over A."

def ωStableProperty : String :=
  "T is ω-stable if S₁(A) is countable for all countable A. Equivalent to: Morley rank is well-defined on all formulas."

def superstableProperty : String :=
  "Superstable: T is stable and no formula has the order property with forking chains. Equivalently: S(A) ≤ |A|^ℵ₀ fails for κ = ℵ₀."

--- #eval ---

#eval orderPropertyStatement : String

#eval forkingStatement : String

#eval stabilityHierarchyDesc : String

#eval ωStableProperty : String

end MiniCompactnessCompletenessLite
