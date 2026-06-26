/-
# Benchmark: Main Theorem Evaluations
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def benchMainGap : String := shelahMainGap

def benchStatus : String := classificationProgramStatus

def benchClassifiable (t : ClassifiableTheory) : Bool :=
  t.classifiable

def benchCompletenessProof : List String :=
  [completenessProofSketch, henkinConstruction, soundnessAndCompleteness,
   modelExistenceTheorem, consistencyTest]

#eval benchMainGap
#eval benchStatus
#eval benchCompletenessProof
