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

/-! ## Non-Definability Results in First-Order Logic -/

-- Well-ordering is NOT first-order definable in {≤}. (Compactness argument)
-- Finiteness is NOT first-order definable.
-- Graph connectedness is NOT first-order definable.
-- The class of torsion groups is NOT first-order axiomatizable.

/-! ## Essential Undecidability -/

-- Robinson's Q: finitely axiomatizable, essentially undecidable theory of
--   arithmetic.  Every consistent extension of Q is undecidable.
-- Group theory is undecidable but NOT essentially undecidable
--   (the theory of abelian groups is a decidable extension).
-- The class of finite groups is not an elementary class (compactness/ultraproducts).

/-! ## Tarski's Undefinability Theorem -/

-- Truth in the standard model (N, +, ×) is not definable by any first-order
--   formula in the language of arithmetic.

/-! ## Language Limitations -/

-- In a finite relational language, "the domain is infinite" requires infinitely
--   many axioms.  No FOL theory with infinite models is categorical in all
--   infinite cardinalities (by upward LS).  Unary-only languages cannot express
--   transitivity, connectedness, or any binary relation.

/-! ## #eval examples -/

#eval "══ Counterexamples ══"

#eval "── Non-definability ──"
#eval "Well-ordering, finiteness, graph connectedness are not FOL-definable."
#eval "Torsion groups are not elementary."

#eval "── Essential Undecidability ──"
#eval "Robinson Q is essentially undecidable. Group theory is undecidable but not essentially so."
#eval "Tarski: truth in (N,+,×) is not arithmetically definable."

#eval "── Language Limitations ──"
#eval "Unary languages: only Boolean combinations of predicates."

end MiniLanguageStructure
