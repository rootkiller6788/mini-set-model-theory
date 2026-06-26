/-
# Language Structure: Dense Linear Orders

The theory of dense linear orders without endpoints (DLO) as a worked
example of a complete, countably categorical first-order theory.

## Concepts
- `dloLanguage` — the language of DLO (one binary relation)
- `dloAxioms` — the axioms of dense linear orders without endpoints
- `dloIsComplete` — DLO is a complete theory
- `dloCountablyCategorical` — DLO is aleph0-categorical
- `dloQuantifierElimination` — DLO has quantifier elimination
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Constructions.Subobjects
import MiniLanguageStructure.Properties.Invariants
import MiniLanguageStructure.Examples.Standard
import MiniFunctionRelation.Core.Basic

namespace MiniLanguageStructure

/-! ## DLO Language -/

/-- The language of DLO: one binary relation symbol (<). -/
def dloLanguage : Language := orderLanguage

/-- The DLO axioms in natural language. -/
def dloAxioms : List String := [
  "∀x ¬(x < x)",                     -- irreflexivity
  "∀x∀y∀z (x < y ∧ y < z → x < z)", -- transitivity
  "∀x∀y (x < y ∨ x = y ∨ y < x)",   -- totality
  "∀x∀y (x < y → ∃z (x < z ∧ z < y))", -- density
  "∀x∃y (y < x)",                    -- no left endpoint
  "∀x∃y (x < y)"                     -- no right endpoint
]

/-- DLO as a finite first-order theory. -/
def dloTheory : String := String.intercalate ", " dloAxioms

/-! ## Properties of DLO -/

/-- DLO is complete, ℵ₀-categorical, has quantifier elimination, and is decidable.
    The unique countable model (up to isomorphism) is (Q, <).

    Proof of ℵ₀-categoricity: the back-and-forth method constructs an isomorphism
    between any two countable DLO models by alternating extension of a finite
    partial isomorphism (forth: cover a domain element; back: cover a codomain element).
    Density of the order guarantees the extensions always exist. -/

-- theorem dloIsComplete : ... := ...
-- theorem dloCountablyCategorical : ... := ...
-- theorem dloHasQE : ... := ...

/-! ## #eval examples -/

#eval "══ Dense Linear Orders ══"

-- DLO axioms
#eval dloAxioms
#eval dloTheory

-- Properties
#eval "DLO: complete, ℵ₀-categorical, QE, decidable. Unique countable model: (Q, <)."
#eval "Proof of ℵ₀-categoricity: back-and-forth method."
#eval s!"DLO language: {dloLanguage.sig.name}"
#eval isRelationalLanguage dloLanguage   -- true (only a binary relation)
#eval classifyLanguage dloLanguage       -- finiteRelational

end MiniLanguageStructure
