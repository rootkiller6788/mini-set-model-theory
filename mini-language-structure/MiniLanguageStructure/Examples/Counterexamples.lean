/-
# Language Structure: Counterexamples

Non-definable relations, essential undecidability examples, and
limitations of first-order definability in various languages.

## Examples
- `nonDefinableWellOrder` — well-ordering is not first-order definable
- `nonDefinableFiniteness` — finiteness is not first-order definable
- `essentialUndecidabilityExample` — examples of essentially undecidable theories
- `nonAxiomatizableClass` — class of finite groups is not first-order axiomatizable
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Properties.Invariants
import MiniLanguageStructure.Examples.Standard

namespace MiniLanguageStructure

/-! ## Non-Definable Relations -/

/-- The well-ordering property is not first-order definable in the
    language of orders. No set of first-order sentences can express
    "every nonempty subset has a least element." -/
def nonDefinableWellOrder : String :=
  "Well-ordering (every nonempty subset has a least element) is not first-order definable in {≤}. Proof: compactness + arbitrarily large finite linear orders that are well-ordered, but their ultraproduct contains a non-well-ordered component."

/-- Finiteness is not first-order definable. There is no set of first-order
    sentences that is true exactly of finite structures. -/
def nonDefinableFiniteness : String :=
  "Finiteness is not first-order definable. If it were, compactness would yield an infinite model of the axioms of finiteness — contradiction."

/-- Connectedness of graphs is not first-order definable. -/
def nonDefinableConnectedness : String :=
  "Graph connectedness is not first-order definable in the language of graphs. Proof: take two disjoint infinite complete graphs; they are elementarily equivalent to a single connected graph."

/-- Torsion in groups is not first-order definable. -/
def nonDefinableTorsion : String :=
  "The class of torsion groups is not first-order axiomatizable. Ultraproducts of finite cyclic groups of increasing order contain elements of infinite order."

/-! ## Essential Undecidability -/

/-- Robinson arithmetic Q is essentially undecidable: every consistent
    extension of Q (in the same language) is undecidable. -/
def robinsonArithmetic : String :=
  "Robinson's Q: a finitely axiomatizable, essentially undecidable theory in the language of arithmetic."

/-- An essentially undecidable theory: the theory of groups is NOT essentially
    undecidable (it has decidable extensions like abelian groups). But the
    theory of graphs IS undecidable but not essentially so. -/
def groupTheoryNotEssentiallyUndecidable : String :=
  "The theory of groups has a decidable extension (e.g., theory of abelian groups is decidable). Thus group theory is undecidable but not essentially undecidable."

/-- The class of finite groups is not first-order axiomatizable
    (by compactness: if it were, an ultraproduct of finite groups of
    unbounded size would be an infinite group satisfying the axioms). -/
def finiteGroupsNotAxiomatizable : String :=
  "The class of finite groups is not elementary (not first-order axiomatizable). Proof via compactness / ultraproducts."

/-- Tarski's undefinability theorem: truth (in the standard model of arithmetic)
    cannot be defined by a first-order formula in the language of arithmetic. -/
def tarskiUndefinability : String :=
  "Truth in the standard model N is not definable by any first-order formula in the language of arithmetic."

/-! ## Language Limitations -/

/-- In a purely relational language, there is no way to force the domain
    to be infinite without using infinitely many sentences. -/
def infinityInRelationalLanguage : String :=
  "In a finite relational language, 'the domain is infinite' requires infinitely many axioms (one for each n: 'there are at least n elements')."

/-- The Lowenheim-Skolem theorem implies no first-order theory with infinite
    models is categorical in all infinite powers. -/
def nonCategoricalInfinite : String :=
  "No theory with an infinite model can be categorical in all infinite cardinalities (by upward LS)."

/-- A language with only unary predicates is very weak: it cannot express
    transitivity, connectedness, or any binary relation. -/
def weaknessOfUnaryLanguage : String :=
  "A language with only unary predicates cannot define any binary relation. Its definable sets are Boolean combinations of the unary predicates."

/-! ## #eval examples -/

#eval "══ Counterexamples ══"

-- Non-definability
#eval nonDefinableWellOrder
#eval nonDefinableFiniteness
#eval nonDefinableConnectedness

-- Essential undecidability
#eval robinsonArithmetic
#eval groupTheoryNotEssentiallyUndecidable
#eval finiteGroupsNotAxiomatizable

-- Language limitations
#eval weaknessOfUnaryLanguage

end MiniLanguageStructure
