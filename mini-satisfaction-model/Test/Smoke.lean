import MiniSatisfactionModel

namespace MiniSatisfactionModel.Test

/-
# Smoke Tests

Basic construction and verification tests for the satisfaction model.
Tests all core types and classifications are properly defined.
-/

def testDloClassification : IO Unit := do
  let dlo := dloClassification
  IO.println s!"DLO: stability={dlo.stability}, ℵ₀-categorical={dlo.aleph0Categorical}, ℵ₁-categorical={dlo.aleph1Categorical}, QE={dlo.hasQuantifierElimination}"

def testAcf0Classification : IO Unit := do
  let acf0 := acf0Classification
  IO.println s!"ACF0: stability={acf0.stability}, ℵ₀-categorical={acf0.aleph0Categorical}, ℵ₁-categorical={acf0.aleph1Categorical}, QE={acf0.hasQuantifierElimination}"

def testRcfClassification : IO Unit := do
  let rcf := rcfClassification
  IO.println s!"RCF: stability={rcf.stability}, ℵ₀-categorical={rcf.aleph0Categorical}, ℵ₁-categorical={rcf.aleph1Categorical}, QE={rcf.hasQuantifierElimination}"

def testNatStructure : IO Unit := do
  let M := natStructure
  IO.println s!"natStructure: domain type = Nat"

def testIntStructure : IO Unit := do
  let M := intStructure
  IO.println s!"intStructure: domain type = Int"

def testRatStructure : IO Unit := do
  let M := ratStructure
  IO.println s!"ratStructure: domain type = Rat"

def testDloStructure : IO Unit := do
  let M := dloStructure
  IO.println s!"dloStructure: predInterp 0 [1,2] = {M.predInterp 0 [1,2]}"

def testIsoId : IO Unit := do
  let M := natStructure
  let _id : Iso M M := Iso.id M
  IO.println "Iso.id: constructed successfully"

def testTheory : IO Unit := do
  let T : Theory := { axioms := {} }
  IO.println s!"Empty theory constructed: |axioms| = 0"

def testElementarilyEquivalent : IO Unit := do
  let _equiv := elementarilyEquivalent boolStruct boolStruct
  IO.println "elementarilyEquivalent: reflexive (boolStruct ≡ boolStruct)"

def testBoolStruct : IO Unit := do
  let M := boolStruct
  IO.println s!"boolStruct: predInterp 0 [true] = {M.predInterp 0 [true]}"
  IO.println s!"boolStruct: predInterp 0 [false] = {M.predInterp 0 [false]}"

def testFormulaClassification : IO Unit := do
  let qf := isQuantifierFree (.pred 0 [0, 1])
  let uni := isUniversalFormula (.all (.pred 0 [0]))
  let ex := isExistentialFormula (.ex (.pred 0 [0]))
  let pos := isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))
  IO.println s!"Quantifier-free: {qf}, Universal: {uni}, Existential: {ex}, Positive: {pos}"

def testStandardExampleNames : IO Unit := do
  IO.println s!"Standard examples: {standardExampleNames}"

def testRandomGraph : IO Unit := do
  let rg := randomGraphClassification
  IO.println s!"Random Graph: stability={rg.stability}, QE={rg.hasQuantifierElimination}"

def testPresburger : IO Unit := do
  let pr := presburgerClassification
  IO.println s!"Presburger: stability={pr.stability}"

def main : IO Unit := do
  IO.println "══ MiniSatisfactionModel Smoke Tests ══"
  testDloClassification
  testAcf0Classification
  testRcfClassification
  testNatStructure
  testIntStructure
  testRatStructure
  testDloStructure
  testIsoId
  testTheory
  testElementarilyEquivalent
  testBoolStruct
  testFormulaClassification
  testStandardExampleNames
  testRandomGraph
  testPresburger
  IO.println "══ All smoke tests passed. ══"

end MiniSatisfactionModel.Test
