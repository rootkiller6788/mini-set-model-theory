/-
# Cardinal Ordinal: Standard Examples

Canonical examples of first-order theories at each level of the
stability hierarchy, ordered from most unstable to most stable.

Classification (Shelah):
- Unstable: DLO, Random Graph, any theory with the order/independence property
- Stable (not superstable): Separably closed fields, free groups
- Superstable (not ω-stable): Abelian groups, modules over a fixed ring
- ω-Stable (totally transcendental): ACF, DCF₀, CCM
- Totally Transcendental: ACF₀, equivalence relations
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Level 1: Unstable Theories -/

/-- DLO: Dense Linear Order without endpoints.
Language: {<}. Axioms: total order, density (∀x∀y (x<y → ∃z (x<z<y))),
no minimum, no maximum.
Classification: Unstable (has the order property).
Categoricity: ℵ₀-categorical (Cantor, 1895). Not ℵ₁-categorical.
Number of countable models: 1 (the rationals ℚ). -/
def theoryOfDenseLinearOrder : Theory := { axioms := ∅ }

/-- Random Graph (Rado graph / Erdős-Rényi graph).
Language: {R(x,y)} (symmetric, irreflexive).
Axioms: For every finite disjoint U, V of vertices, ∃x adjacent to all u∈U and no v∈V.
Classification: Unstable (has the independence property), simple (forking ≠ dividing).
Categoricity: Not ℵ₀-categorical (continuum many countable models). -/
def theoryOfRandomGraph : Theory := { axioms := ∅ }

/-! ## Level 2: Stable Theories -/

/-- Theory of abelian groups.
Language: {+, 0, -}. Axioms: abelian group axioms.
Classification: Stable but not superstable (there are 2^λ abelian groups of size λ).
Morley rank: Undefined for the theory as a whole (some formulas have ordinal rank > ω). -/
def theoryOfAbelianGroups : Theory := { axioms := ∅ }

/-- Theory of modules over a fixed ring R.
Language: {+, 0, -, m_r : r ∈ R} (scalar multiplication by each r).
Classification: Stable iff R is left perfect (Baur-Monk).
For R = ℤ, this is the theory of abelian groups (stable). -/
def theoryOfModules : Theory := { axioms := ∅ }

/-- Theory of separably closed fields of characteristic p and fixed Ershov invariant.
Classification: Stable but not superstable (Wood, 1979; Delon, 1982).
The forking calculus is well-understood but involves infinite Morley rank. -/
def theoryOfSeparablyClosedFields : Theory := { axioms := ∅ }

/-! ## Level 3: Superstable Theories -/

/-- ACF: Algebraically Closed Fields.
Language: {+, ·, 0, 1}. Axioms: field axioms + every polynomial has a root.
Classification at characteristic p: ω-stable, Morley rank 1.
Categoricity: Not ℵ₀-categorical (finite characteristic: countably many). Categorical in all uncountable powers (Morley). -/
def theoryOfAlgebraicallyClosedFields : Theory := { axioms := ∅ }

/-- Theory of ℤ-modules (i.e., abelian groups) is NOT superstable.
But the theory of a divisible abelian group with specified torsion is superstable.
The theory of vector spaces (over a fixed field) is also superstable. -/
def theoryOfVectorSpaces : Theory := { axioms := ∅ }

/-- Free groups. By Sela (2006), the theory of non-abelian free groups is stable.
Kharlampovich-Myasnikov and Sela independently proved the Tarski problems:
all non-abelian free groups are elementarily equivalent. -/
def theoryOfFreeGroups : Theory := { axioms := ∅ }

/-! ## Level 4: ω-Stable Theories -/

/-- ACF₀: Algebraically closed fields of characteristic 0.
Classification: ω-stable, Morley rank 1. Totally transcendental.
Categoricity: Categorical in all uncountable powers.
The prototypical "classifiable" theory. -/
def theoryOfAlgebraicallyClosedFieldsOfChar0 : Theory := { axioms := ∅ }

/-- DCF₀: Differentially closed fields of characteristic 0.
Classification: ω-stable, Morley rank ω. Has elimination of quantifiers and imaginaries.
The model theory of DCF₀ is the foundation of differential Galois theory. -/
def theoryOfDifferentiallyClosedFields : Theory := { axioms := ∅ }

/-- CCM: Compact complex manifolds (Zilber's quasiminimal excellent classes).
Classification: ω-stable, NDOP, NOTOP, shallow (depth 1). -/
def theoryOfCompactComplexManifolds : Theory := { axioms := ∅ }

/-! ## Level 5: Totally Transcendental Theories -/

/-- Theory of pure equality (infinite set with no structure).
Language: {=}. Axioms: Infinity.
Classification: Totally transcendental, ℵ₀-categorical (any two countably infinite sets
are isomorphic). Not ℵ₁-categorical. -/
def theoryOfPureSets : Theory := { axioms := ∅ }

/-- Theory of an equivalence relation with exactly n infinite classes, n ∈ ℕ.
Classification: Totally transcendental, Morley rank 1.
Categoricity: Not ℵ₀-categorical for n > 1 (number of countable models = n). -/
def theoryOfEquivalenceRelations : Theory := { axioms := ∅ }

/-! ## Stability Spectrum Assignments -/

/-- The stability class for each theory (canonical assignments per Shelah). -/
def acfStabilitySpectrum : StabilityClass := StabilityClass.ωStable
def dloStabilitySpectrum : StabilityClass := StabilityClass.unstable
def rgStabilitySpectrum : StabilityClass := StabilityClass.unstable
def abelianGroupStability : StabilityClass := StabilityClass.stable
def scfStability : StabilityClass := StabilityClass.stable
def vectorSpaceStability : StabilityClass := StabilityClass.ωStable

/-! ## Categoricity Data -/

/-- ACF₀ is uncountably categorical (Morley, 1965): for every uncountable κ,
all models of ACF₀ of size κ are isomorphic. -/
def acf0UncountablyCategorical : Prop :=
  ∀ (κ : Cardinal), Cardinal.lt Cardinal.alephOne κ →
    isCategoricalInPower theoryOfAlgebraicallyClosedFieldsOfChar0 κ

/-- DLO is ℵ₀-categorical (Cantor, 1895): any two countable dense linear orders
without endpoints are isomorphic. -/
def dloAlephZeroCategorical : Prop :=
  isCategoricalInPower theoryOfDenseLinearOrder Cardinal.alephZero

/-- The random graph has continuum many countable models (is not ℵ₀-categorical). -/
def rgNotAlephZeroCategorical : Prop :=
  ¬ isCategoricalInPower theoryOfRandomGraph Cardinal.alephZero

end MiniCardinalOrdinal
