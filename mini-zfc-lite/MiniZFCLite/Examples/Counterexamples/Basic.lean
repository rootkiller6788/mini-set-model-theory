/-
# MiniZFCLite: Examples — Counterexamples

Non-standard models, ill-founded models, ω-inconsistent models,
and other pathological ZFC model examples.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Non-Standard Models from Compactness -/

/-- The compactness theorem produces non-standard models of ZFC -/
structure CompactnessNonStandard where
  description : String
  construction : String
  properties : List String
  deriving Repr

/-- A non-standard model with a non-standard natural number -/
def nonStandardNaturalModel : CompactnessNonStandard :=
  { description := "A model of ZFC with a non-standard natural number c"
    construction := "Add constant c and axioms {c > n | n∈ω}. Every finite subset
      is satisfied by interpreting c as a large enough natural number.
      By compactness, the whole theory has a model."
    properties := [
      "Contains a 'natural number' larger than all standard n∈ω",
      "Not well-founded: the 'natural numbers' are not isomorphic to ω",
      "The model is not an ω-model"
    ] }

/-- A model with descending ∈-chains (ill-founded) -/
def illFoundedCompactnessModel : CompactnessNonStandard :=
  { description := "An ill-founded model of ZFC with a descending ∈-chain"
    construction := "Add constants c₀,c₁,c₂,... and axioms {c_{n+1} ∈ c_n | n<ω}.
      Every finite subset is satisfiable in V. By compactness, there is a model."
    properties := [
      "Contains x₀∋x₁∋x₂∋... (infinite descending ∈-chain)",
      "Violates the Foundation axiom's semantic consequence",
      "ZFC + Foundation cannot exclude such models (by compactness!)"
    ] }

/-! ## ω-Inconsistent Models -/

/-- An ω-inconsistent model: satisfies φ(n) for all standard n but also ∃x¬φ(x) -/
structure OmegaInconsistentModel where
  description : String
  formula : String
  explanation : String
  deriving Repr

/-- ZFC + {c > n | n∈ω} + "c is finite" is ω-inconsistent -/
def omegaInconsistentZfc : OmegaInconsistentModel :=
  { description := "ω-inconsistent extension of ZFC"
    formula := "φ(x) ≡ 'x is a natural number less than c'"
    explanation := "The model thinks c is a finite natural number,
      but c is larger than all standard n. The model satisfies
      φ(0), φ(1), ... but also ∃x¬φ(x) (namely c itself)" }

/-- An ω-inconsistent but syntactically consistent theory -/
def noStandardModelExtension : OmegaInconsistentModel :=
  { description := "A consistent extension of ZFC with NO standard model"
    formula := "Add constant c with 'c is a natural number' and c > 0, c > 1, ..."
    explanation := "Consistent by compactness, but any model must have
      non-standard natural numbers (no standard model exists)" }

/-! ## Models Where AC Fails -/

/-- A model of ZF + ¬AC (by symmetric submodel of forcing extension) -/
structure NoChoiceModel where
  description : String
  construction : String
  properties : List String
  deriving Repr

/-- The basic Cohen model: ZF + ¬AC -/
def cohenBasicModel : NoChoiceModel :=
  { description := "The basic Cohen model (symmetric submodel)"
    construction := "Add ω many Cohen reals via finite support product,
      then take the symmetric submodel under the group of all
      permutations of ω with finite support"
    properties := [
      "ZF holds",
      "AC fails (there is no choice function for the set of added reals)",
      "The reals cannot be well-ordered",
      "Dependent Choice (DC) also fails"
    ] }

/-- Feferman-Levy model: ω₁ is a countable union of countable sets -/
def fefermanLevyModel : NoChoiceModel :=
  { description := "Feferman-Levy model"
    construction := "Collapse each ℵ_n to ℵ₀ via Levy collapse,
      take symmetric submodel"
    properties := [
      "ZF holds",
      "ω₁ is singular (countable cofinality)",
      "ω₁ is a countable union of countable sets",
      "ACω (countable choice) fails"
    ] }

/-! ## Models Where CH Fails Badly -/

/-- Models of ZFC where 2^{ℵ₀} is very large -/
structure CHFailureModel where
  name : String
  continuumValue : String
  construction : String
  deriving Repr

/-- ZFC + 2^{ℵ₀} = ℵ₂ (the simplest ¬CH) -/
def continuumAleph2 : CHFailureModel :=
  { name := "ZFC + 2^{ℵ₀} = ℵ₂"
    continuumValue := "ℵ₂"
    construction := "Add ℵ₂ Cohen reals with finite support (Cohen forcing)" }

/-- ZFC + 2^{ℵ₀} = ℵ_{ω+1} (Easton's theorem) -/
def continuumAlephOmegaPlus : CHFailureModel :=
  { name := "ZFC + 2^{ℵ₀} = ℵ_{ω+1}"
    continuumValue := "ℵ_{ω+1}"
    construction := "Easton forcing: add ℵ_{ω+1} Cohen reals" }

/-- Easton's Theorem: the continuum can be almost any uncountable cardinal -/
structure EastonTheorem where
  statement : String
  restriction : String
  deriving Repr

/-- Easton's theorem on the continuum function -/
def eastonsTheorem : EastonTheorem :=
  { statement := "For regular cardinals κ, 2^κ can be made arbitrarily large
    subject to Konig's theorem: cf(2^κ) > κ"
    restriction := "Cannot violate Konig: cf(2^{ℵ₀}) > ℵ₀, so 2^{ℵ₀} ≠ ℵ_ω" }

/-! ## Models with Pathological Properties -/

/-- A model of ZFC where every set of reals is Lebesgue measurable
(Shelah: needs inaccessible) -/
structure PathologicalModel where
  name : String
  property : String
  consistency : String
  deriving Repr

/-- Solovay model: ZF + DC + "all sets of reals are Lebesgue measurable" -/
def solovayModel : PathologicalModel :=
  { name := "Solovay model"
    property := "ZF + DC + all sets of reals are Lebesgue measurable +
      all sets of reals have the Baire property"
    consistency := "Con(ZFC + ∃inaccessible) → Con(ZF + DC + LM + BP)" }

/-- A model where the reals are a countable union of countable sets -/
def realsCountableUnion : PathologicalModel :=
  { name := "Feferman-Levy model (variant)"
    property := "R is a countable union of countable sets"
    consistency := "Consistent with ZF (without AC)" }

#eval nonStandardNaturalModel.properties
#eval illFoundedCompactnessModel.description
#eval omegaInconsistentZfc.explanation
#eval cohenBasicModel.properties
#eval continuumAleph2.continuumValue
#eval solovayModel.name

end MiniZFCLite
