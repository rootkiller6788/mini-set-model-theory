/-
# Benchmark: Basic Theorem Statements
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def benchBasic : List String :=
  [compactnessStatement, compactnessCountable, completenessTheorem,
   downwardLS, upwardLS, lindstromsTheorem]

def benchCoreObjects : List String :=
  ["Theory type", "satisfiable", "finitelySatisfiable",
   "logicallyValid", "logicalConsequence"]

def benchHenkin : List String :=
  [henkinConstruction, modelExistenceTheorem, soundnessTheorem,
   adequacyTheorem, compactnessFromCompleteness]

#eval benchBasic : List String
#eval benchCoreObjects : List String
#eval benchHenkin : List String
