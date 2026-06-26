/-
# MiniZFCLite: Properties — Universal

Model invariants: height, width, cardinality, and standardness.
These are properties preserved across equivalent ZFC models.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Model Height -/

/-- The height of a model is its ordinal height (supremum of ordinals) -/
structure ModelHeight where
  model : String
  ordinalHeight : String
  description : String
  deriving Repr

/-- Vω has height ω -/
def vOmegaHeight : ModelHeight :=
  { model := "Vω"
    ordinalHeight := "ω"
    description := "Contains only finite ordinals" }

/-- Vκ for inaccessible κ has height κ -/
def vKappaHeight (κ : String) : ModelHeight :=
  { model := s!"V{κ}"
    ordinalHeight := κ
    description := s!"(strongly inaccessible {κ})" }

/-- L has height Ord (the class of all ordinals) -/
def lHeight : ModelHeight :=
  { model := "L"
    ordinalHeight := "Ord"
    description := "L contains all ordinals" }

/-! ## Model Width -/

/-- The width of a model is how many subsets of ordinals it contains -/
structure ModelWidth where
  model : String
  description : String
  isNarrow : Bool
  deriving Repr

/-- L is "narrow" (minimal): contains only constructible sets -/
def lWidth : ModelWidth :=
  { model := "L", description := "Minimal: only definable subsets", isNarrow := true }

/-- V is "wide": contains all sets -/
def vWidth : ModelWidth :=
  { model := "V", description := "Maximal: all subsets exist", isNarrow := false }

/-- A forcing extension is wider than the ground model -/
def forcingWidth : ModelWidth :=
  { model := "M[G]", description := "Wider than M: contains new subsets", isNarrow := false }

/-! ## Cardinality -/

/-- The cardinality of a model's domain -/
structure ModelCardinality where
  model : String
  cardinality : String
  isCountable : Bool
  deriving Repr

/-- Vω is countable -/
def vOmegaCardinality : ModelCardinality :=
  { model := "Vω", cardinality := "ℵ₀", isCountable := true }

/-- By Lowenheim-Skolem, ZFC has a countable model -/
def countableZfcModel : ModelCardinality :=
  { model := "M ⊨ ZFC (countable)", cardinality := "ℵ₀", isCountable := true }

/-- Vκ for inaccessible κ is uncountable -/
def vKappaCardinality (κ : String) : ModelCardinality :=
  { model := s!"V{κ}", cardinality := s!"ℶ_{κ}", isCountable := false }

/-! ## Standardness -/

/-- A model is standard if its ∈ relation is the real ∈ -/
structure Standardness where
  model : String
  isStandard : Bool
  membershipType : String
  deriving Repr

/-- Vα is a standard model (membership is real ∈) -/
def vAlphaStandard (α : String) : Standardness :=
  { model := s!"V{α}", isStandard := true, membershipType := "Real ∈" }

/-- The countable model from Lowenheim-Skolem may be non-standard -/
def countableModelStandard : Standardness :=
  { model := "Countable ZFC model", isStandard := true
    membershipType := "Real ∈ (if transitive)" }

/-- A Boolean-valued model is not standard -/
def booleanModelNonStandard : Standardness :=
  { model := "V^𝔹", isStandard := false, membershipType := "Boolean-valued ∈" }

/-! ## Well-Foundedness -/

/-- Well-founded vs ill-founded models -/
structure WellFoundedness where
  model : String
  isWellFounded : Bool
  description : String
  deriving Repr

/-- Vα is well-founded (real ∈ is well-founded) -/
def vAlphaWellFounded (α : String) : WellFoundedness :=
  { model := s!"V{α}", isWellFounded := true
    description := "Membership is real ∈, which is well-founded by Foundation axiom" }

/-- Ill-founded models exist by Compactness -/
def illFoundedModel : WellFoundedness :=
  { model := "Non-standard ZFC model", isWellFounded := false
    description := "Contains a descending ∈-chain" }

/-! ## Summary Structure -/

/-- Combined invariants for a ZFC model -/
structure ModelInvariants where
  name : String
  height : String
  width : String
  cardinality : String
  isStandard : Bool
  isWellFounded : Bool
  deriving Repr

/-- Invariants for Vω -/
def vOmegaInvariants : ModelInvariants :=
  { name := "Vω"
    height := "ω"
    width := "Full (finite subsets)"
    cardinality := "ℵ₀"
    isStandard := true
    isWellFounded := true }

#eval vOmegaHeight.ordinalHeight
#eval lWidth.isNarrow
#eval vOmegaCardinality.isCountable
#eval vAlphaStandard "ω+ω" |>.isStandard
#eval illFoundedModel.description
#eval vOmegaInvariants

end MiniZFCLite
