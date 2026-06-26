/-
# MiniZFCLite: Constructions — Coproduct

Boolean-valued models, forcing posets, and generic filters.
The coproduct in the category of set models corresponds to
disjoint union with forcing as a key application.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Boolean-Valued Models -/

/-- A Boolean-valued model assigns truth values from a complete Boolean algebra
to set-theoretic statements -/
structure BooleanValuedModel where
  booleanAlgebra : String
  name : String
  truthValues : String
  properties : String
  deriving Repr

/-- The Boolean-valued universe V^𝔹 -/
def booleanValuedUniverse (alg : String) : BooleanValuedModel :=
  { booleanAlgebra := alg
    name := s!"V^({alg})"
    truthValues := s!"⟦φ⟧ ∈ {alg}"
    properties := s!"V^({alg}) ⊨ ZFC (Boolean-valued)" }

/-- Cohen forcing as a Boolean-valued model -/
def cohenBooleanModel : BooleanValuedModel :=
  booleanValuedUniverse "B(Cohen)"

/-- Random forcing as a Boolean-valued model -/
def randomBooleanModel : BooleanValuedModel :=
  booleanValuedUniverse "B(Random)"

/-! ## Forcing Posets -/

/-- A forcing poset (partial order for forcing) -/
structure ForcingPoset where
  name : String
  description : String
  hasMaximum : Bool
  isSeparative : Bool
  deriving Repr

/-- Cohen forcing: finite partial functions from ω to {0,1} -/
def cohenForcing : ForcingPoset :=
  { name := "Fn(ω, 2)"
    description := "Finite partial functions ω ⇀ {0,1}, ordered by reverse inclusion"
    hasMaximum := true
    isSeparative := true }

/-- Random forcing: Borel sets of positive measure -/
def randomForcing : ForcingPoset :=
  { name := "Borel(2^ω)/Null"
    description := "Borel subsets of Cantor space modulo null sets, ordered by inclusion"
    hasMaximum := true
    isSeparative := true }

/-- Sacks forcing: perfect trees -/
def sacksForcing : ForcingPoset :=
  { name := "Sacks"
    description := "Perfect subtrees of 2^{<ω}, ordered by inclusion"
    hasMaximum := true
    isSeparative := true }

/-- Collapsing poset: Levy collapse -/
def levyCollapse (κ λ : String) : ForcingPoset :=
  { name := s!"Coll({κ}, {λ})"
    description := s!"Collapsing {κ} to {λ}"
    hasMaximum := true
    isSeparative := true }

/-! ## Generic Filters -/

/-- A generic filter on a forcing poset -/
structure GenericFilter where
  poset : String
  isFilter : String
  isGeneric : String
  properties : String
  deriving Repr

/-- Definition of genericity: G meets every dense set in the ground model -/
def genericFilterDefinition : GenericFilter :=
  { poset := "ℙ"
    isFilter := "p,q∈G → ∃r∈G, r≤p,q; and p∈G, p≤q → q∈G"
    isGeneric := "For every dense D⊆ℙ in M, G∩D≠∅"
    properties := "determines M[G]" }

/-- A V-generic filter adds new sets -/
def vGenericFilter : GenericFilter :=
  { poset := "ℙ ∈ V"
    isFilter := "G ⊆ ℙ is a filter"
    isGeneric := "G meets all dense subsets of ℙ in V"
    properties := "V[G] ⊨ ZFC" }

/-! ## Forcing Relation -/

/-- The forcing relation p ⊩ φ (p forces φ) -/
structure ForcingRelation where
  poset : String
  condition : String
  formula : String
  semantics : String
  deriving Repr

/-- Cohen forcing a new real -/
def cohenForcingRelation : ForcingRelation :=
  { poset := "Fn(ω,2)"
    condition := "p ∈ Fn(ω,2)"
    formula := "ṙ is a new real"
    semantics := "p ⊩ 'ṙ is not in the ground model'" }

/-! ## Properties of Forcing -/

/-- Forcing preserves ZFC axioms -/
def forcingPreservesZFC : String :=
  "If M ⊨ ZFC, then M[G] ⊨ ZFC for any generic G"

/-- The forcing theorem: truth in extension = forced in ground -/
def forcingTheorem : String :=
  "M[G] ⊨ φ iff ∃p∈G, p ⊩ φ"

/-- Product forcing lemma -/
def productForcingLemma : String :=
  "ℙ×ℚ-generic = ℙ-generic × ℚ-generic over the intermediate model"

/-! ## Evaluations -/

#eval cohenBooleanModel.name
#eval cohenForcing.name
#eval sacksForcing.name
#eval genericFilterDefinition.isGeneric
#eval forcingPreservesZFC
#eval forcingTheorem

end MiniZFCLite
