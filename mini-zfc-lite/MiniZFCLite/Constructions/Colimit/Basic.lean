/-
# MiniZFCLite: Constructions — Colimit

Submodels, transitive submodels, constructible sets (L), and
HOD (hereditarily ordinal definable) sets.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Submodels -/

/-- A submodel of a set-theoretic structure -/
structure Submodel where
  superModel : String
  subModel : String
  relation : String
  isElementary : Bool
  deriving Repr

/-- Vκ ≺_V V for inaccessible κ (elementary submodel) -/
def vKappaSubmodel (κ : String) : Submodel :=
  { superModel := "V"
    subModel := s!"V{κ}"
    relation := s!"V{κ} ⊆ V"
    isElementary := false }

/-- Elementary submodel from Lowenheim-Skolem -/
def lowenheimSkolemSubmodel : Submodel :=
  { superModel := "V"
    subModel := "M (countable elementary submodel)"
    relation := "M ≺ V"
    isElementary := true }

/-! ## Transitive Submodels -/

/-- A transitive submodel: x∈M and y∈x implies y∈M -/
structure TransitiveSubmodel where
  name : String
  parent : String
  transitivity : String
  properties : String
  deriving Repr

/-- Any Vα is transitive -/
def vAlphaTransitive (α : String) : TransitiveSubmodel :=
  { name := s!"V{α}"
    parent := "V"
    transitivity := "x∈Vα, y∈x → y∈Vα"
    properties := "All Vα are transitive" }

/-- L (constructible universe) is transitive -/
def lTransitive : TransitiveSubmodel :=
  { name := "L"
    parent := "V"
    transitivity := "L is a transitive class"
    properties := "L is the smallest transitive model of ZF containing all ordinals" }

/-! ## The Constructible Universe L -/

/-- The constructible hierarchy Lα -/
structure ConstructibleRank where
  ordinal : String
  definition : String
  derives Repr

/-- L0 = ∅ -/
def lZero : ConstructibleRank :=
  { ordinal := "0"
    definition := "L₀ = ∅" }

/-- L_{α+1} = Def(Lα) -/
def lSuccessor (α : String) : ConstructibleRank :=
  { ordinal := s!"{α}+1"
    definition := s!"L_{{α}+1} = Def(L{α})" }

/-- Lλ = ⋃_{α<λ} Lα for limit λ -/
def lLimit (λ : String) : ConstructibleRank :=
  { ordinal := λ
    definition := s!"Lλ = ⋃_{{α<λ}} Lα" }

/-- The constructible universe L = ⋃_{α∈Ord} Lα -/
structure ConstructibleUniverse where
  name : String
  axiom : String
  properties : List String
  deriving Repr

/-- L as a model of ZFC + V=L -/
def constructibleUniverseL : ConstructibleUniverse :=
  { name := "L"
    axiom := "V=L (Axiom of Constructibility)"
    properties := [
      "L ⊨ ZFC",
      "L ⊨ GCH",
      "L ⊨ ♦ (diamond principle)",
      "L is the minimal inner model of ZF"
    ] }

/-! ## HOD — Hereditarily Ordinal Definable Sets -/

/-- A set is ordinal definable if there is a formula φ and ordinals α₁...αₙ
such that x = {y : φ(y, α₁,...,αₙ)} -/
structure OrdinalDefinable where
  set : String
  definition : String
  deriving Repr

/-- Every constructible set is ordinal definable -/
def constructibleImpOD : OrdinalDefinable :=
  { set := "L ⊆ OD"
    definition := "Every x∈L is defined by the formula that constructs it" }

/-- HOD: x is hereditarily ordinal definable if x∈OD and every y∈TC({x}) is in OD -/
structure HereditarilyOD where
  name : String
  definition : String
  isModel : String
  deriving Repr

/-- HOD is a model of ZFC -/
def hodModel : HereditarilyOD :=
  { name := "HOD"
    definition := "HOD = {x : TC({x}) ⊆ OD}"
    isModel := "HOD ⊨ ZFC" }

/-- L ⊆ HOD ⊆ V -/
def lHodVChain : String := "L ⊆ HOD ⊆ V"

/-! ## Relative Constructibility -/

/-- L(A): the universe constructible from a set A -/
structure RelativeConstructible where
  fromSet : String
  name : String
  property : String
  deriving Repr

/-- L(R): constructible from reals -/
def lOfReals : RelativeConstructible :=
  { fromSet := "R"
    name := "L(R)"
    property := "L(R) ⊨ ZF + DC + 'all sets are Lebesgue measurable'" }

/-! ## Evaluations -/

#eval lZero.definition
#eval constructibleUniverseL.name
#eval constructibleUniverseL.properties
#eval hodModel.name
#eval lHodVChain
#eval lOfReals.name

end MiniZFCLite
