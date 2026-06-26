/-
# Benchmark: Topology Bridge Evaluations
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def benchTopology : List String :=
  [typeSpaceIsStone, ryllNardzewski]

def benchTypeSpaces : List String :=
  [typeSpace "DLO" 0, typeSpace "DLO" 1, typeSpace "DLO" 2,
   typeSpace "ACF0" 0, typeSpace "ACF0" 1]

def benchOpenSets : List String :=
  [basicOpenSet "⊤", basicOpenSet "⊥", basicOpenSet "x = y"]

def benchStoneDuality : List String :=
  [stoneDualityStatement, booleanAlgebraToStoneSpace, clopenSets, ultrafilterDefinition]

def benchTypes : List String :=
  [nType, completeType, isolatedType, cantorBendixsonRank, forkingTopology]

#eval benchTopology
#eval benchTypeSpaces
#eval benchOpenSets
#eval benchStoneDuality
#eval benchTypes
