/-
# MiniZFCLite: Theorems — Classification

Classifying ZFC models: countable transitive models, uncountable
models, Boolean-valued models, and model-theoretic invariants.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Classification by Cardinality -/

/-- Categoricity fails for ZFC (unlike second-order ZFC) -/
structure CardinalityClassification where
  cardinality : String
  existence : String
  description : String
  deriving Repr

/-- If ZFC is consistent, it has a countable model (Lowenheim-Skolem) -/
def countableModel : CardinalityClassification :=
  { cardinality := "ℵ₀ (countable)"
    existence := "Exists by downward Lowenheim-Skolem if ZFC has any model"
    description := "Either transitive or non-transitive; Mostowski collapse if well-founded" }

/-- ZFC also has models of every infinite cardinality (upward Lowenheim-Skolem) -/
def upwardLS (κ : String) : CardinalityClassification :=
  { cardinality := κ
    existence := s!"Exists by upward Lowenheim-Skolem from any model"
    description := "ZFC has no bound on model cardinality" }

/-- Proper class models: V, L, HOD -/
def properClassModels : CardinalityClassification :=
  { cardinality := "Proper class"
    existence := "V, L, HOD, V[G]"
    description := "The natural models of ZFC are proper classes" }

/-! ## Classification by Transitivity -/

/-- Transitive vs non-transitive ZFC models -/
structure TransitivityClassification where
  isTransitive : Bool
  description : String
  examples : List String
  deriving Repr

/-- Transitive models -/
def transitiveModels : TransitivityClassification :=
  { isTransitive := true
    description := "x∈M and y∈x imply y∈M; ∈ is real membership"
    examples := ["Vκ (inaccessible κ)", "Lλ (limit λ)",
      "Countable transitive models", "Hκ (regular κ)"] }

/-- Non-transitive models exist by compactness -/
def nonTransitiveModels : TransitivityClassification :=
  { isTransitive := false
    description := "∈ interpreted as some relation, not true membership"
    examples := ["Boolean-valued models V^𝔹",
      "Ultrapowers V^κ/U (non-principal U)",
      "Models from compactness"] }

/-! ## Classification by Well-Foundedness -/

/-- The well-foundedness dichotomy for ZFC models -/
structure WellFoundedClassification where
  isWellFounded : Bool
  description : String
  properties : String
  deriving Repr

/-- Well-founded models of ZFC -/
def wellFoundedModels : WellFoundedClassification :=
  { isWellFounded := true
    description := "No infinite descending ∈-chain"
    properties := "Isomorphic to a transitive model via Mostowski collapse" }

/-- Ill-founded models: compactness produces them -/
def illFoundedModels : WellFoundedClassification :=
  { isWellFounded := false
    description := "Contains an infinite descending ∈-chain"
    properties := "Not isomorphic to any transitive model; exist by compactness" }

/-! ## Boolean-Valued Models -/

/-- Boolean-valued models as a unifying framework -/
structure BooleanValuedClassification where
  algebra : String
  completeness : String
  models : String
  deriving Repr

/-- The Boolean-valued universe V^𝔹 for any complete Boolean algebra 𝔹 -/
def booleanValuedClassification : BooleanValuedClassification :=
  { algebra := "𝔹 (complete Boolean algebra)"
    completeness := "Requires 𝔹 to be complete for quantifiers"
    models := "V^𝔹 ⊨ ZFC (Boolean-valued); gives ZFC models via ultrafilters" }

/-- The 2-valued algebra gives standard model theory -/
def twoValuedModel : BooleanValuedClassification :=
  { algebra := "2 = {0,1}"
    completeness := "2 is complete"
    models := "V² ≅ V (standard 2-valued models)" }

/-! ## Model Completeness Results -/

/-- Complete theories extending ZFC (by forcing or inner models) -/
structure ZfcExtension where
  name : String
  axiom : String
  consistency : String
  deriving Repr

/-- ZFC + V=L is a natural completion -/
def zfcPlusVL : ZfcExtension :=
  { name := "ZFC + V=L"
    axiom := "V=L"
    consistency := "Consistent relative to ZFC (Godel 1938)" }

/-- ZFC + GCH -/
def zfcPlusGCH : ZfcExtension :=
  { name := "ZFC + GCH"
    axiom := "GCH (2^{ℵα} = ℵ_{α+1})"
    consistency := "Consistent relative to ZFC (Godel 1938, via L)" }

/-- ZFC + ¬CH -/
def zfcPlusNotCH : ZfcExtension :=
  { name := "ZFC + ¬CH"
    axiom := "¬CH"
    consistency := "Consistent relative to ZFC (Cohen 1963, via forcing)" }

/-- ZFC + MA + ¬CH (Martin's Axiom) -/
def zfcPlusMA : ZfcExtension :=
  { name := "ZFC + MA + ¬CH"
    axiom := "Martin's Axiom"
    consistency := "Consistent relative to ZFC (Solovay-Tenenbaum 1971)" }

/-- ZFC + PFA (Proper Forcing Axiom) -/
def zfcPlusPFA : ZfcExtension :=
  { name := "ZFC + PFA"
    axiom := "Proper Forcing Axiom"
    consistency := "Consistent relative to ZFC + supercompact cardinal" }

/-! ## The Model Zoo -/

/-- Common ZFC model types -/
def modelZoo : List String := [
  "V: The full cumulative hierarchy (intended model)",
  "L: Godel's constructible universe (minimal inner model)",
  "V^𝔹: Boolean-valued models (for independence proofs)",
  "M[G]: Forcing extensions (for independence proofs)",
  "HOD: Hereditarily ordinal definable sets",
  "Vκ: Natural models (strongly inaccessible κ)",
  "Hκ: Sets of hereditary size < κ",
  "Countable transitive models (from Lowenheim-Skolem)"
]

/-! ## Evaluations -/

#eval countableModel.existence
#eval transitiveModels.examples
#eval wellFoundedModels.properties
#eval zfcPlusVL.consistency
#eval zfcPlusNotCH.name
#eval modelZoo.length

end MiniZFCLite
