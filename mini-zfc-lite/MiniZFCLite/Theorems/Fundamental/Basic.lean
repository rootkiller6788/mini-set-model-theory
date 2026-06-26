/-
# MiniZFCLite: Theorems — Fundamental

Reflection theorem, Mostowski collapse theorem, transfinite
recursion, and fundamental results for ZFC models.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## The Reflection Theorem -/

/-- The Reflection Theorem: for any formula, V reflects it at arbitrarily
high ranks. This is a theorem schema (one per formula), not a single theorem. -/
structure ReflectionTheorem where
  statement : String
  schema : String
  consequence : String
  deriving Repr

/-- Reflection theorem (schema) -/
def reflectionTheoremStatement : ReflectionTheorem :=
  { statement := "For any formula φ(v₁,...,vₙ) in the language of set theory,
    ZF proves: ∀α∃β>α such that Vβ reflects φ"
    schema := "One statement per formula φ (infinite axiom schema)"
    consequence := "ZFC is not finitely axiomatizable" }

/-- Σ_n reflection -/
def sigmaNReflection (n : Nat) : ReflectionTheorem :=
  { statement := s!"For any Σ_{n} formula φ, there are arbitrarily large β with Vβ≺_{Σ_{n}}V"
    schema := "Holds for each n in ZF"
    consequence := s!"V is a Σ_{n}-elementary limit of its ranks" }

/-! ## Mostowski Collapse Theorem -/

/-- Every well-founded extensional structure is isomorphic to a unique
transitive set (or class) via the Mostowski collapse. -/
structure MostowskiCollapseTheorem where
  hypothesis : String
  conclusion : String
  uniqueness : String
  deriving Repr

/-- Mostowski collapse theorem -/
def mostowskiCollapseTheorem : MostowskiCollapseTheorem :=
  { hypothesis := "(M, E) is well-founded and extensional"
    conclusion := "π: M → N is an isomorphism onto a transitive set/class N"
    uniqueness := "N is uniquely determined; π(x) = {π(y) : y E x}" }

/-- Application: every well-founded model of ZFC is isomorphic to a transitive model -/
def wellFoundedZfcCollapse : String :=
  "Any well-founded model of ZFC is isomorphic to a unique transitive model (its Mostowski collapse)"

/-- Application: set-like well-founded extensional relations -/
def setLikeCollapse : String :=
  "If E is set-like (predessors of each point form a set), the collapse is an isomorphism"

/-! ## Transfinite Recursion -/

/-- Transfinite recursion theorem: definitions by recursion on ordinals
are justified in ZF(C). -/
structure TransfiniteRecursionTheorem where
  statement : String
  onOrdinals : String
  onWellFounded : String
  deriving Repr

/-- The transfinite recursion theorem schema -/
def transfiniteRecursion : TransfiniteRecursionTheorem :=
  { statement := "If G: V → V is a class function, there is a unique F: Ord → V
    such that F(α) = G(F↾α) for all ordinals α"
    onOrdinals := "Defines functions by recursion on the ordinals"
    onWellFounded := "Generalizes to recursion on any well-founded relation" }

/-- Applications of transfinite recursion -/
def transfiniteRecursionApplications : List String := [
  "Definition of Vα (cumulative hierarchy)",
  "Definition of Lα (constructible hierarchy)",
  "Definition of rank(x)",
  "Definition of the von Neumann ordinals",
  "Definition of Hκ (sets of hereditary size < κ)"
]

/-! ## The Recursion Theorem (Set-Theoretic) -/

/-- Recursion on ∈ (epsilon-recursion): define F(x) in terms of F(y) for y∈x -/
structure EpsilonRecursionTheorem where
  statement : String
  justification : String
  consequence : String
  deriving Repr

/-- Epsilon-recursion theorem -/
def epsilonRecursion : EpsilonRecursionTheorem :=
  { statement := "For any G: V → V, there is a unique F: V → V
    with F(x) = G(F↾x) for all x"
    justification := "Follows from Foundation + Replacement"
    consequence := "Definition by ∈-recursion is legitimate in ZFC" }

/-! ## Fundamental Theorem Summary -/

/-- Key fundamental theorems of ZFC model theory -/
structure FundamentalTheorem where
  name : String
  statement : String
  applications : List String
  deriving Repr

/-- Collection of fundamental theorems -/
def fundamentalTheorems : List FundamentalTheorem := [
  { name := "Reflection Theorem"
    statement := "V can be approximated by its rank initial segments"
    applications := ["ZFC is not finitely axiomatizable", "Absoluteness results"] },
  { name := "Mostowski Collapse"
    statement := "Well-founded extensional structures ≅ transitive sets"
    applications := ["Every countable transitive model of ZFC exists if consistent",
      "Inner model theory"] },
  { name := "Transfinite Recursion"
    statement := "Definitions by recursion on ordinals are valid"
    applications := ["Cumulative hierarchy", "Constructible hierarchy"] }
]

/-! ## Evaluations -/

#eval reflectionTheoremStatement.consequence
#eval mostowskiCollapseTheorem.conclusion
#eval transfiniteRecursion.onOrdinals
#eval transfiniteRecursionApplications.length
#eval epsilonRecursion.justification
#eval fundamentalTheorems.length

end MiniZFCLite
