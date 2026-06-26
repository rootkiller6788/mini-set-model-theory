/-
# MiniZFCLite: Theorems — Structural

V as the initial ZFC model, L as the minimal inner model,
and structural theorems about the set-theoretic universe.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## V as the Maximal Universe -/

/-- V is the maximal (universal) model of ZFC (assuming Foundation) -/
structure VAsUniverse where
  description : String
  universality : String
  foundation : String
  deriving Repr

/-- V = ⋃_{α∈Ord} Vα, the intended model of set theory -/
def vDefinition : VAsUniverse :=
  { description := "V = ⋃_{α∈Ord} Vα (cumulative hierarchy)"
    universality := "V is the universe of all sets (assuming Foundation)"
    foundation := "Foundation axiom ensures every set appears at some Vα" }

/-- All sets are in V (by Foundation) -/
def allSetsInV : String :=
  "ZF ⊢ ∀x∃α, x ∈ Vα (equivalent to the Foundation axiom)"

/-! ## L as the Minimal Inner Model -/

/-- L = ⋃_{α∈Ord} Lα is the minimal inner model of ZF -/
structure LAsMinimalModel where
  definition : String
  minimality : String
  properties : List String
  deriving Repr

/-- L is the minimal inner model -/
def lMinimalModel : LAsMinimalModel :=
  { definition := "L = ⋃_{α∈Ord} Lα, where L₀=∅, L_{α+1}=Def(Lα), Lλ=⋃_{α<λ}Lα"
    minimality := "If W is any inner model of ZF, then L ⊆ W"
    properties := [
      "L ⊨ ZFC",
      "L ⊨ GCH",
      "L ⊨ V=L",
      "L is absolute (the definition of L does not depend on the outer model)"
    ] }

/-! ## Inner Model Program -/

/-- The inner model program: build canonical inner models with
large cardinals -/
structure InnerModelProgram where
  description : String
  l : String
  lOfMice : String
  coreModels : String
  deriving Repr

/-- Summary of the inner model program -/
def innerModelProgram : InnerModelProgram :=
  { description := "Construct canonical inner models for large cardinal axioms"
    l := "L: minimal model, for ZFC"
    lOfMice := "L[μ]: for measurable cardinals (Kunen, Silver, Mitchell)"
    coreModels := "K: the core model (Dodd-Jensen, Mitchell-Steel)" }

/-! ## V = L and Its Consequences -/

/-- The Axiom of Constructibility: V = L -/
structure AxiomOfConstructibility where
  statement : String
  status : String
  consequences : List String
  deriving Repr

/-- V = L is independent of ZFC -/
def vEqualsL : AxiomOfConstructibility :=
  { statement := "V = L (Every set is constructible)"
    status := "Independent of ZFC (Godel 1938: consistent; Cohen 1963: ¬(V=L) is consistent)"
    consequences := [
      "Implies AC",
      "Implies GCH",
      "Implies ♦ (diamond principle)",
      "Implies there is a Δ₂¹ well-ordering of the reals"
    ] }

/-! ## The Core Model K -/

/-- The core model K: the "ultimate" canonical inner model -/
structure CoreModel where
  name : String
  definition : String
  properties : List String
  deriving Repr

/-- The Dodd-Jensen core model -/
def coreModelK : CoreModel :=
  { name := "K (Dodd-Jensen Core Model)"
    definition := "K = the smallest inner model closed under sharps (in some sense)"
    properties := [
      "K ⊨ ZFC + GCH",
      "If there is no inner model with a measurable, K is Σ₃-correct",
      "K is defined via the theory of mice"
    ] }

/-! ## Structural Relations Between Inner Models -/

/-- Relationships: L ⊆ L[0^#] ⊆ L[μ] ⊆ ... ⊆ K ⊆ V -/
structure InnerModelChain where
  models : List String
  relation : String
  deriving Repr

/-- The chain of canonical inner models -/
def canonicalInnerModelChain : InnerModelChain :=
  { models := ["L", "L[0^#]", "L[μ]", "K", "V"]
    relation := "L ⊆ L[0^#] ⊆ L[μ] ⊆ ... ⊆ K ⊆ V" }

/-- The large cardinal hierarchy is reflected in inner models -/
def largeCardinalInnerModels : List (String × String) := [
  ("Inaccessible", "Vκ ⊨ ZFC"),
  ("Measurable", "L[U] with U a normal measure"),
  ("Strong", "L[E] with E a strong extender sequence"),
  ("Woodin", "M_{ω} (the least Woodin mouse)"),
  ("Superstrong", "M_n^# (minimal mouse with n Woodin cardinals)")
]

/-! ## The Set-Theoretic Multiverse -/

/-- The multiverse view: there are many equally valid universes of sets -/
structure SetTheoreticMultiverse where
  description : String
  models : String
  relations : String
  deriving Repr

/-- The generic multiverse (Woodin) -/
def genericMultiverse : SetTheoreticMultiverse :=
  { description := "Models reachable via forcing and inner models"
    models := "All forcing extensions and ground models"
    relations := "M ≡ N if they are forcing-equivalent" }

/-! ## Evaluations -/

#eval lMinimalModel.minimality
#eval vEqualsL.consequences
#eval canonicalInnerModelChain.models
#eval largeCardinalInnerModels.length
#eval coreModelK.name
#eval genericMultiverse.description

end MiniZFCLite
