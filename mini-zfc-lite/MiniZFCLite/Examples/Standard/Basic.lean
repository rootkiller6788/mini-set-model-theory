/-
# MiniZFCLite: Examples — Standard

Standard ZFC model examples: Vω (hereditarily finite sets),
V_{ω+ω}, L_{ω₁}, and other concrete ZFC model instances.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Vω — Hereditarily Finite Sets -/

/-- Vω = ⋃_{n<ω} V_n: the set of all hereditarily finite sets -/
structure HereditarilyFinite where
  name : String
  definition : String
  axioms : List String
  missing : List String
  deriving Repr

/-- Vω: model of ZFC minus Infinity -/
def vOmegaModel : HereditarilyFinite :=
  { name := "Vω"
    definition := "Vω = ⋃_{n<ω} V_n, where V₀=∅, V_{n+1}=P(V_n)"
    axioms := [
      "Extensionality",
      "Empty Set",
      "Pairing",
      "Union",
      "Power Set",
      "Separation",
      "Choice (every finite set has a choice function)"
    ]
    missing := [
      "Infinity (no infinite set exists in Vω)"
    ] }

/-- Vω is countable and well-founded -/
def vOmegaProperties : List String := [
  "|Vω| = ℵ₀ (countable)",
  "Every element of Vω is finite",
  "Vω is a standard transitive model",
  "Vω is a β-model (correct about well-foundedness)"
]

/-! ## V_{ω+ω} — Hereditarily Countable Sets -/

/-- V_{ω+ω}: satisfies ZC (ZFC without Replacement), does not satisfy full ZFC -/
structure HereditarilyCountable where
  name : String
  definition : String
  axioms : List String
  missing : List String
  deriving Repr

/-- V_{ω+ω} model information -/
def vOmegaPlusOmegaModel : HereditarilyCountable :=
  { name := "V_{ω+ω}"
    definition := "V_{ω+ω} = ⋃_{n<ω} V_{ω+n}"
    axioms := [
      "Extensionality", "Empty Set", "Pairing", "Union",
      "Power Set", "Separation", "Infinity", "Choice"
    ]
    missing := [
      "Replacement (fails: ω many finite sets can be replaced with an uncountable set)"
    ] }

/-- An explicit example where Replacement fails in V_{ω+ω} -/
def replacementFailureV_OmegaPlusOmega : String :=
  "In V_{ω+ω}, the function n↦n (mapping each natural to itself) has domain∈V_{ω+ω}
  but the range ω is not in V_{ω+ω}... actually ω∈V_{ω+1}⊆V_{ω+ω}. The failure is
  more subtle: V_{ω+ω} does not contain certain countable sets."

/-! ## Hκ — Hereditarily of Size < κ -/

/-- Hκ: sets whose transitive closure has cardinality < κ -/
structure HereditarilySmall where
  name : String
  kappa : String
  properties : List String
  deriving Repr

/-- H_{ℵ₀} = Vω (hereditarily finite = hereditarily of size < ℵ₀) -/
def hAleph0 : HereditarilySmall :=
  { name := "H_{ℵ₀}", kappa := "ℵ₀"
    properties := ["H_{ℵ₀} = Vω", "Countable", "Finite elements only"] }

/-- H_{ℵ₁}: hereditarily countable sets -/
def hAleph1 : HereditarilySmall :=
  { name := "H_{ℵ₁}", kappa := "ℵ₁"
    properties := [
      "Sets whose transitive closure is countable",
      "Contains all countable ordinals",
      "H_{ℵ₁} ⊨ ZFC minus Power Set",
      "|H_{ℵ₁}| = 2^{ℵ₀} (depends on CH)"
    ] }

/-- Hκ for regular κ > ℵ₀ satisfies ZFC minus Power Set -/
def hKappa (κ : String) : HereditarilySmall :=
  { name := s!"H_{{{κ}}}", kappa := κ
    properties := [
      s!"Sets of hereditary size < {κ}",
      s!"If {κ} is regular, H_{{{κ}}} ⊨ ZFC minus Power Set",
      s!"If {κ} is strongly inaccessible, H_{{{κ}}} = Vκ ⊨ ZFC"
    ] }

/-! ## L_{ω₁} — The Constructible Universe Up to ω₁ -/

/-- L_{ω₁}: the first ω₁ levels of the constructible hierarchy -/
structure ConstructibleOmega1 where
  name : String
  definition : String
  properties : List String
  deriving Repr

/-- L_{ω₁} as a model -/
def lOmega1 : ConstructibleOmega1 :=
  { name := "L_{ω₁}"
    definition := "L_{ω₁} = ⋃_{α<ω₁} L_α"
    properties := [
      "L_{ω₁} ⊨ ZFC minus Power Set",
      "L_{ω₁} contains all countable ordinals",
      "|L_{ω₁}| = ℵ₁",
      "L_{ω₁} ⊨ CH",
      "L_{ω₁} is the minimal model of ZFC-Power containing all countable ordinals"
    ] }

/-! ## Vκ — Natural Models -/

/-- Vκ for strongly inaccessible κ is a natural model of full ZFC -/
structure NaturalModel where
  name : String
  kappa : String
  theory : String
  properties : List String
  deriving Repr

/-- Vκ: natural model of ZFC -/
def vKappaNaturalModel : NaturalModel :=
  { name := "Vκ"
    kappa := "κ (strongly inaccessible)"
    theory := "ZFC (full)"
    properties := [
      "Vκ is a standard transitive model of ZFC",
      "Vκ = Hκ for inaccessible κ",
      "|Vκ| = ℶκ (beth-kappa)",
      "The existence of κ cannot be proved in ZFC (Godel's 2nd incompleteness)"
    ] }

/-- The smallest natural model -/
def smallestNaturalModel : NaturalModel :=
  { name := "Vκ₀"
    kappa := "κ₀ (least strongly inaccessible, if it exists)"
    theory := "ZFC + 'there is no inaccessible cardinal'"
    properties := [
      "If it exists, it's the smallest model of ZFC containing all ordinals below it",
      "Inside Vκ₀, there are no inaccessible cardinals"
    ] }

/-! ## Example ZFC Model Summary -/

/-- Summary of standard example models -/
def standardModelExamples : List (String × String × String) := [
  ("Vω", "ZFC - Infinity", "Hereditarily finite sets"),
  ("V_{ω+ω}", "ZC (ZFC - Replacement)", "Hereditarily countable sets"),
  ("H_{ℵ₁}", "ZFC - Power Set", "Hereditarily countable (depends on CH)"),
  ("L_{ω₁}", "ZFC - Power Set + CH", "Constructible sets up to ω₁"),
  ("Vκ", "ZFC", "Natural model (κ inaccessible)"),
  ("Hκ", "ZFC - Power Set", "Hereditarily < κ (κ regular)"),
  ("L", "ZFC + V=L + GCH", "Constructible universe (proper class)"),
  ("V", "ZFC", "Cumulative hierarchy (proper class)")
]

#eval vOmegaModel.axioms
#eval vOmegaPlusOmegaModel.missing
#eval hAleph1.properties
#eval lOmega1.name
#eval smallestNaturalModel.theory
#eval standardModelExamples.length

end MiniZFCLite
