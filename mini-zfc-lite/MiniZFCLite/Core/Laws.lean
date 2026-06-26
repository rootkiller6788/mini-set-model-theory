/-
# ZFC Lite: Laws

ZFC-specific laws and properties:
- Consistency results for ZFC subsystems
- Independence of CH
- Model-theoretic properties
-/

import MiniZFCLite.Core.Basic
import MiniZFCLite.Core.Objects

namespace MiniZFCLite

/-! ## Subsystem Definitions -/

/-- ZF without Choice -/
def zfAxiomList : List (String × PredFormula) :=
  zfcAxiomList.filter fun (name, _) => name != "zfc-choice"

/-- Zermelo set theory (no Replacement) -/
def zermeloAxiomList : List (String × PredFormula) :=
  zfcAxiomList.filter fun (name, _) =>
    name != "zfc-separation" && name != "zfc-choice"

/-- Finite set theory: ZFC minus Infinity -/
def finiteSetTheoryAxiomList : List (String × PredFormula) :=
  zfcAxiomList.filter fun (name, _) => name != "zfc-infinity"

/-- ZFC^-: ZFC without Power Set -/
def zfcMinusPowerSetList : List (String × PredFormula) :=
  zfcAxiomList.filter fun (name, _) => name != "zfc-power-set"

/-! ## Subsystem Counts -/

#eval zfAxiomList.length
#eval zermeloAxiomList.length
#eval finiteSetTheoryAxiomList.length
#eval zfcMinusPowerSetList.length

/-! ## Axiom Name Utilities -/

/-- Get all axiom names from a list -/
def axiomNames (l : List (String × PredFormula)) : List String :=
  l.map (·.1)

/-- Check if an axiom is in a list by name -/
def containsAxiom (l : List (String × PredFormula)) (name : String) : Bool :=
  l.any fun (n, _) => n == name

#eval axiomNames zfcAxiomList
#eval containsAxiom zfcAxiomList "zfc-extensionality"
#eval containsAxiom finiteSetTheoryAxiomList "zfc-infinity"

/-! ## Independence Metadata -/

/-- Known independence results for ZFC -/
inductive IndependenceResult where
  | independentOf (statement axiomSystem : String)
  | consistentWith (statement axiomSystem : String)
  | provableIn (statement axiomSystem : String)
  deriving Repr, BEq

/-- Key independence metadata -/
def continuumHypothesisIndependence : IndependenceResult :=
  .independentOf "CH" "ZFC"

def axiomOfChoiceIndependence : IndependenceResult :=
  .independentOf "AC" "ZF"

def axiomOfInfinityIndependence : IndependenceResult :=
  .independentOf "Infinity" "ZFC - Infinity"

/-- List of notable independence results -/
def notableIndependenceResults : List IndependenceResult := [
  continuumHypothesisIndependence,
  axiomOfChoiceIndependence,
  axiomOfInfinityIndependence
]

#eval notableIndependenceResults.length
#eval continuumHypothesisIndependence

/-! ## Consistency Strength -/

/-- Consistency strength comparison (simplified ordering) -/
inductive ConsistencyStrength where
  | weaker | equivalent | strictlyWeaker
  deriving Repr, BEq

/-- ZF minus Infinity is strictly weaker than ZF -/
def finitaryVsInfinitary : ConsistencyStrength := .strictlyWeaker

/-- ZF and ZFC are equiconsistent -/
def zfVsZfc : ConsistencyStrength := .equivalent

#eval finitaryVsInfinitary
#eval zfVsZfc

/-! ## Model-Theoretic Properties -/

/-- Compactness: if every finite subset has a model, the whole theory has one (for first-order ZFC) -/
structure CompactnessStatement where
  theory : String
  isCompact : Bool
  deriving Repr

def zfcCompactness : CompactnessStatement :=
  { theory := "ZFC", isCompact := true }

/-- Downward Lowenheim-Skolem: ZFC has countable models if it has any infinite model -/
structure LowenheimSkolemStatement where
  theory : String
  downward : Bool
  upward : Bool
  deriving Repr

def zfcLowenheimSkolem : LowenheimSkolemStatement :=
  { theory := "ZFC", downward := true, upward := true }

#eval zfcCompactness
#eval zfcLowenheimSkolem

/-! ## Formula Complexity Helpers -/

/-- Quantifier depth of a PredFormula -/
def quantifierDepth : PredFormula → Nat
  | .prop _ => 0
  | .pred _ _ => 0
  | .eq _ _ => 0
  | .not A => quantifierDepth A
  | .and A B => max (quantifierDepth A) (quantifierDepth B)
  | .or A B => max (quantifierDepth A) (quantifierDepth B)
  | .impl A B => max (quantifierDepth A) (quantifierDepth B)
  | .equiv A B => max (quantifierDepth A) (quantifierDepth B)
  | .all A => 1 + quantifierDepth A
  | .ex A => 1 + quantifierDepth A

/-- Measure quantifier depth of each ZFC axiom -/
def zfcAxiomDepths : List (String × Nat) :=
  zfcAxiomList.map fun (name, pf) => (name, quantifierDepth pf)

#eval zfcAxiomDepths

end MiniZFCLite
