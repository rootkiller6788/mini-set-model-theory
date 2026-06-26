/-
# MiniZFCLite: Properties — Computational

Model classification: standard, non-standard, well-founded,
ill-founded, ω-models, and computational properties of ZFC models.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Model Type Classification -/

/-- The type of a ZFC model -/
inductive ModelType where
  | standardTransitive
  | standardNonTransitive
  | nonStandardWellFounded
  | nonStandardIllFounded
  deriving Repr, BEq

instance : ToString ModelType where
  toString
    | .standardTransitive => "Standard transitive"
    | .standardNonTransitive => "Standard non-transitive"
    | .nonStandardWellFounded => "Non-standard well-founded"
    | .nonStandardIllFounded => "Non-standard ill-founded"

/-! ## Standard Models -/

/-- A standard model: ∈ is the real membership relation -/
structure StandardModel where
  name : String
  isTransitive : Bool
  description : String
  deriving Repr

/-- Vω is standard transitive -/
def vOmegaStandard : StandardModel :=
  { name := "Vω", isTransitive := true
    description := "Hereditarily finite sets; standard transitive model" }

/-- Vκ for inaccessible κ is standard transitive -/
def vKappaStandard (κ : String) : StandardModel :=
  { name := s!"V{κ}", isTransitive := true
    description := s!"Standard transitive model with height {κ}" }

/-- A countable transitive model from Lowenheim-Skolem -/
def countableTransitiveModel : StandardModel :=
  { name := "M (c.t.m.)", isTransitive := true
    description := "Countable transitive model of ZFC (exists if ZFC + 'exists inaccessible')" }

/-! ## Non-Standard Models -/

/-- A non-standard model where ∈ is interpreted differently from real ∈ -/
structure NonStandardModel where
  name : String
  membershipInterpretation : String
  hasNonStandardNaturals : Bool
  deriving Repr

/-- Boolean-valued models are non-standard -/
def booleanValuedNonStandard : NonStandardModel :=
  { name := "V^𝔹"
    membershipInterpretation := "Boolean-valued membership ⟦x∈y⟧"
    hasNonStandardNaturals := false }

/-- An ultrapower of V by a non-principal ultrafilter gives a non-standard model -/
def ultrapowerNonStandard : NonStandardModel :=
  { name := "V^ω/U"
    membershipInterpretation := "Equivalence classes modulo ultrafilter U"
    hasNonStandardNaturals := true }

/-! ## Well-Founded Models -/

/-- A model is well-founded if ∈ has no infinite descending chains -/
structure WellFoundedModel where
  name : String
  isWellFounded : Bool
  collapseResult : String
  deriving Repr

/-- Vα is well-founded -/
def vAlphaWellFounded (α : String) : WellFoundedModel :=
  { name := s!"V{α}", isWellFounded := true
    collapseResult := "Isomorphic to itself via identity" }

/-- Mostowski collapse of a well-founded model gives a transitive model -/
def wellFoundedCollapseModel : WellFoundedModel :=
  { name := "M (well-founded)", isWellFounded := true
    collapseResult := "M ≅ N where N is transitive" }

/-! ## Ill-Founded Models -/

/-- An ill-founded model contains a descending ∈-chain -/
structure IllFoundedModel where
  name : String
  descendingChain : String
  existsBy : String
  deriving Repr

/-- Compactness gives ill-founded models -/
def compactnessIllFounded : IllFoundedModel :=
  { name := "Compactness model"
    descendingChain := "x₀ ∋ x₁ ∋ x₂ ∋ ..."
    existsBy := "Add constants c₀,c₁,... with c₀∋c₁∋...; every finite subset is satisfiable" }

/-- An ω-inconsistent model is ill-founded -/
def omegaInconsistentModel : IllFoundedModel :=
  { name := "ω-inconsistent model"
    descendingChain := "Natural numbers are not standard"
    existsBy := "Compactness with φ(cᵢ)='cᵢ is the i-th natural number'" }

/-! ## ω-Models -/

/-- An ω-model has standard natural numbers -/
structure OmegaModel where
  name : String
  hasStandardOmega : Bool
  properties : String
  deriving Repr

/-- All transitive models are ω-models -/
def transitiveOmegaModel : OmegaModel :=
  { name := "Any transitive model"
    hasStandardOmega := true
    properties := "ω is absolute for transitive models" }

/-- Vω is an ω-model -/
def vOmegaOmegaModel : OmegaModel :=
  { name := "Vω"
    hasStandardOmega := true
    properties := "Standard finite natural numbers" }

/-- Boolean-valued models may not be ω-models -/
def booleanNotOmegaModel : OmegaModel :=
  { name := "V^𝔹 (Boolean-valued)"
    hasStandardOmega := false
    properties := "ω is interpreted via Boolean values" }

/-! ## β-Models -/

/-- A β-model is a model correct about well-foundedness: "x is well-founded" is absolute -/
structure BetaModel where
  name : String
  isBetaModel : Bool
  description : String
  deriving Repr

/-- Every Vα is a β-model iff α is a limit ordinal -/
def vAlphaBetaModel (α : String) : BetaModel :=
  { name := s!"V{α}", isBetaModel := true
    description := "Correct about well-foundedness of relations" }

/-! ## Model Classification Summary -/

/-- Complete classification of a ZFC model -/
structure ModelClassification where
  name : String
  modelType : ModelType
  isOmegaModel : Bool
  isBetaModel : Bool
  height : String
  cardinality : String
  deriving Repr

/-- Classification of Vω -/
def vOmegaClassification : ModelClassification :=
  { name := "Vω"
    modelType := .standardTransitive
    isOmegaModel := true
    isBetaModel := true
    height := "ω"
    cardinality := "ℵ₀" }

/-- Classification of L -/
def lClassification : ModelClassification :=
  { name := "L"
    modelType := .standardTransitive
    isOmegaModel := true
    isBetaModel := true
    height := "Ord"
    cardinality := "Proper class" }

#eval vOmegaStandard.isTransitive
#eval wellFoundedCollapseModel.collapseResult
#eval compactnessIllFounded.existsBy
#eval vOmegaClassification.modelType
#eval lClassification.height
#eval omegaInconsistentModel.name

end MiniZFCLite
