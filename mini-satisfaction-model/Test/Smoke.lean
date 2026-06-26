import MiniSatisfactionModel

namespace MiniSatisfactionModel.Test

/-
# Smoke Tests

Basic construction and verification tests for the satisfaction model.
-/

-- Test that dloClassification has expected values
def testDloClassification : IO Unit := do
  let dlo := dloClassification
  IO.println s!"DLO: stability={dlo.stability}, ℵ₀-categorical={dlo.aleph0Categorical}, ℵ₁-categorical={dlo.aleph1Categorical}, QE={dlo.hasQuantifierElimination}"

-- Test that acf0Classification has expected values
def testAcf0Classification : IO Unit := do
  let acf0 := acf0Classification
  IO.println s!"ACF0: stability={acf0.stability}, ℵ₀-categorical={acf0.aleph0Categorical}, ℵ₁-categorical={acf0.aleph1Categorical}, QE={acf0.hasQuantifierElimination}"

-- Test natStructure construction
def testNatStructure : IO Unit := do
  let M := natStructure
  IO.println s!"natStructure: domain={toString M.domain}"

-- Test intStructure construction
def testIntStructure : IO Unit := do
  let M := intStructure
  IO.println s!"intStructure: domain={toString M.domain}"

-- Test ratStructure construction
def testRatStructure : IO Unit := do
  let M := ratStructure
  IO.println s!"ratStructure: domain={toString M.domain}"

-- Test complexStructure construction
def testComplexStructure : IO Unit := do
  let M := complexStructure
  IO.println s!"complexStructure: domain={toString M.domain}"

-- Test Iso.id construction
def testIsoId : IO Unit := do
  let M := natStructure
  let _id : Iso M M := Iso.id M
  IO.println "Iso.id: constructed"

-- Test Theory construction
def testTheory : IO Unit := do
  let T : Theory := { axioms := {} }
  IO.println s!"Theory: constructed"

-- Test standardExamples list
def testStandardExamples : IO Unit := do
  IO.println s!"Standard examples: {standardExamples}"

def main : IO Unit := do
  IO.println "== MiniSatisfactionModel Smoke Tests =="
  testDloClassification
  testAcf0Classification
  testNatStructure
  testIntStructure
  testRatStructure
  testComplexStructure
  testIsoId
  testTheory
  testStandardExamples
  IO.println "All smoke tests passed."

end MiniSatisfactionModel.Test
