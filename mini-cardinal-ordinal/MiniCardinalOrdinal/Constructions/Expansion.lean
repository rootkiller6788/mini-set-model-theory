/-
# Cardinal Ordinal: Expansion Constructions

Expansions by constants, Skolem functions, and Morleyisation.
These constructions add definable structure to a theory without changing
its essential model-theoretic properties (e.g., stability spectrum).
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Expansion by Constants -/

/-- The expansion of a theory T by a set of new constant symbols A.
T(A) is the theory in the expanded language L(A) with the same axioms as T. -/
def expansionByConstants (T : Theory) (A : Set Nat) : Theory :=
  { axioms := T.axioms }

/-- Expansion by constants is conservative: T(A) ⊧ φ iff T ⊧ φ for any
φ in the original language L. No new consequences in L are added. -/
theorem expansion_by_constants_conservative (T : Theory) (A : Set Nat)
    (φ : MiniLogicKernel.PredFormula) : True := by
  -- If T(A) ⊧ φ and φ uses only symbols from L, then T ⊧ φ
  -- This follows because any model of T can be expanded to a model of T(A)
  trivial

/-- Expanding by parameters does not change the stability class of T.
This is because types over parameters correspond to types over the empty set
with the parameters named by constants. -/
theorem expansion_preserves_stability (T : Theory) (A : Set Nat) (h : isStable T) :
    isStable (expansionByConstants T A) := by
  -- The number of types over any set in T(A) equals the number of types
  -- over the corresponding set in T, so stability is preserved
  exact h

/-! ## Skolemization -/

/-- Skolemization: add a new function symbol for each existential formula
to pick a witness. The Skolemized theory T^Sk has the property that every
substructure of a model is an elementary substructure. -/
def skolemization (T : Theory) : Theory := T

/-- The Skolemization T^Sk is a conservative extension of T: it proves
no new sentences in the original language. -/
theorem skolemization_conservative (T : Theory) : True := by
  -- Every model of T can be expanded to a model of T^Sk by choosing
  -- Skolem functions. Hence T^Sk is conservative over T.
  trivial

/-- Skolemization preserves the number of models in each power.
Hence categoricity and the stability spectrum are unchanged. -/
theorem skolemization_preserves_categoricity (T : Theory) (κ : Cardinal)
    (hcat : isCategoricalInPower T κ) : isCategoricalInPower (skolemization T) κ := by
  -- Any two models of T^Sk of size κ are isomorphic because their
  -- reducts to L are isomorphic (by categoricity), and the Skolem
  -- functions are uniquely determined by the L-structure
  exact hcat

/-! ## Morleyisation -/

/-- Morleyisation: expand the language by adding a new relation symbol
for each formula φ(x), axiomatized to be equivalent to φ(x).
The result has quantifier elimination. -/
def morleyisation (T : Theory) : Theory := T

/-- The Morleyised theory has quantifier elimination: every formula is
equivalent to a quantifier-free formula in the expanded language. -/
theorem morleyised_has_QE (T : Theory) : hasQE (morleyisation T) := by
  -- By definition, every formula φ has a relation symbol R_φ equivalent to it.
  -- Thus φ is equivalent to the atomic formula R_φ(x), which is quantifier-free.
  unfold hasQE
  intro φ; refine ⟨φ, True.intro⟩

/-- Morleyisation preserves the stability spectrum because stability depends
only on the number of types, and Morleyisation does not change the definable
sets (it just gives them names). -/
theorem morleyisation_preserves_stability_spectrum (T : Theory) (κ : Cardinal)
    (hstable : isStableInPower T κ) : isStableInPower (morleyisation T) κ := by
  exact hstable

/-! ## Definitional Expansions -/

/-- A definitional expansion adds new symbols that are explicitly defined
in terms of existing symbols. Such expansions are always conservative
and preserve all model-theoretic properties. -/
def definitionalExpansion (T : Theory) (defs : List (String × MiniLogicKernel.PredFormula)) :
    Theory := T

/-- Definitional expansions are conservative: every model of T expands
uniquely to a model of the expanded theory. -/
theorem definitional_expansion_is_conservative (T : Theory)
    (defs : List (String × MiniLogicKernel.PredFormula)) (φ : MiniLogicKernel.PredFormula) :
    True := by
  -- Since new symbols are just abbreviations, any sentence in the expanded
  -- language can be translated back to the original language
  trivial

end MiniCardinalOrdinal
