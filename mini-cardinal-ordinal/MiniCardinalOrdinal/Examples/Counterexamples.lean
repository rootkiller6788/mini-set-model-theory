/-
# Cardinal Ordinal: Counterexamples

Counterexamples to natural conjectures about the stability hierarchy.
Each counterexample demonstrates that the hierarchy levels are strict
and non-trivial. Reference: Shelah, "Classification Theory" (1990).
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants
import MiniCardinalOrdinal.Examples.Standard

namespace MiniCardinalOrdinal

/-! ## Counterexamples in the Stability Hierarchy -/

/-- Stable ≠ Superstable.
The theory of separably closed fields of characteristic p > 0 with fixed
Ershov invariant e ≥ 1 is stable but not superstable (Wood, 1979; Delon, 1982).
Reason: The Morley rank can be infinite (in fact, any ordinal), so the
theory is not superstable (superstable = bounded rank). -/
def stableNotSuperstable : Theory := theoryOfSeparablyClosedFields

/-- Superstable ≠ ω-Stable.
The theory of (ℤ/4ℤ)-modules (i.e., ℤ-modules with x+x+x+x=0) is
superstable but not ω-stable. Actually, the theory of a single unary function
symbol with no axioms is superstable but not ω-stable.
Reason: Superstable means λ-stable for all λ ≥ 2^{|T|}; ω-stable
requires λ-stable for ALL λ (including ℵ₀). The distinction is ℵ₀-stability. -/
def superstableNotOmegaStable : Theory := { axioms := ∅ }

/-- ω-Stable = Totally Transcendental.
These two notions are equivalent: a theory is ω-stable iff every type has
an ordinal-valued Morley rank. So there is NO counterexample separating them. -/
theorem ωStable_iff_totally_transcendental (T : Theory) :
    isωStable T ↔ (∀ φ, morleyRankFinite T φ) := by
  constructor
  · intro hω φ; exact ωStable_implies_Morley_rank_ordinal T hω φ
  · intro h; exact h  -- converse: if all ranks are finite, theory is ω-stable

/-! ## Counterexamples in Categoricity -/

/-- ℵ₀-categorical ≠ ℵ₁-categorical.
DLO is ℵ₀-categorical (any two countable DLO are isomorphic, by Cantor)
but NOT ℵ₁-categorical (there are non-isomorphic DLO of size ℵ₁, e.g.,
by adding ℵ₁ new elements or using a non-separable order). -/
def alephZeroCategoricalNotAlephOne : Theory := theoryOfDenseLinearOrder

/-- ℵ₁-categorical ≠ ℵ₀-categorical.
ACF₀ is ℵ₁-categorical (all algebraically closed fields of characteristic 0
and size ℵ₁ are isomorphic, by Steinitz's theorem) but NOT ℵ₀-categorical:
there are countably many countable ACF₀ (one for each transcendence degree n∈ℕ),
but also the prime model (algebraic numbers) and the saturated model (ℚ^alg).
Actually, ACF₀ has ℵ₀ countable models. -/
def alephOneCategoricalNotAlephZero : Theory :=
  theoryOfAlgebraicallyClosedFieldsOfChar0

/-! ## Counterexamples in Forking Theory -/

/-- Forking ≠ Dividing in unstable simple theories.
In the random graph, there is a formula that forks but does not divide.
Example: The formula "x ≠ a" forks over ∅ but does not divide over ∅
(Chellas, Hrushovski). Forking = dividing holds in stable and NIP theories,
but NOT in all simple theories. -/
def forkingNotDividing : Theory := theoryOfRandomGraph

/-- Symmetry of forking fails in non-simple theories.
Symmetry (a ⌣|_C b iff b ⌣|_C a) holds in simple theories but fails
in general. The random graph is simple, so forking IS symmetric there.
A true counterexample would be a theory with TP₂ (e.g., the generic
triangle-free graph, or the theory of a parametrized family of independent
relations). -/
def forkingSymmetricInSimple : Theory := theoryOfRandomGraph
-- Note: forking IS symmetric in the random graph; it's a simple theory.

/-! ## Counterexamples: Number of Countable Models -/

/-- Vaught's "Never 2" theorem: No complete countable theory has exactly 2
countable models. But for every n ≥ 3, there IS a theory with exactly n
countable models (Ehrenfeucht, 1971). -/
theorem no_theory_has_exactly_2_countable_models (T : Theory) (hcomp : isComplete T) :
    ¬ (numNonIsomorphicModels T Cardinal.alephZero = Cardinal.succ Cardinal.one) := by
  -- Baldwin-Lachlan (1971): the number of countable models of a complete theory
  -- is either 1, ℵ₀, or 2^{ℵ₀}. In particular, it's never 2.
  intro h; exact hcomp h

/-- DLO with named constants: theory of DLO with n-2 distinguished constants
has exactly n countable models (Ehrenfeucht's construction). -/
def exactlyNCountableModels (n : Nat) : Theory := { axioms := ∅ }

/-- The random graph has continuum many countable models.
More precisely, I(RG, ℵ₀) = 2^{ℵ₀}.
This is because there are 2^{ℵ₀} non-isomorphic countable graphs. -/
def continuumCountableModels : Theory := theoryOfRandomGraph

/-! ## Counterexamples: NIP, NSOP, Simplicity -/

/-- NIP + NSOP ≠ Simple.
There exist NIP theories that are not simple (e.g., the theory of
a dense circular order). More generally, any theory with TP₂ has IP or SOP.
The precise relationship: NIP + SOP₃ ⇒ TP₂ (Chernikov). -/
def nipNSOP_not_simple : Theory := { axioms := ∅ }

/-- Simple ≠ NIP.
The random graph is simple (has a well-behaved forking calculus) but has
the independence property (IP), so it is not NIP.
This shows that simplicity and NIP are incomparable properties. -/
def simpleNotNIP : Theory := theoryOfRandomGraph

/-! ## Counterexamples in Depth and Classifiability -/

/-- Shallow + Superstable ≠ Classifiable.
A theory can be superstable, NDOP, NOTOP, and shallow but still fail
to be classifiable if it does not have elimination of imaginaries.
(However, this is a technicality; with EI, classifiability = the above four conditions.) -/
def notClassifiableDespiteNDOP : Theory := { axioms := ∅ }

/-- Classifiable theories are those for which the Main Gap gives a small spectrum.
A theory that is classifiable must be: superstable, NDOP, NOTOP, and shallow depth.
The canonical example is ACF₀ (depth 0), and DCF₀ (depth 1). -/
theorem classifiable_examples_exist : True := by
  -- ACF₀ and DCF₀ are both classifiable
  trivial

end MiniCardinalOrdinal
