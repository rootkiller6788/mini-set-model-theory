/-
# Benchmark: Counterexample Evaluations
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def benchCounterexamples : String := counterexamplesSummary

def benchIncompleteTheory : String := incompleteTheoryExample

def benchTheoriesWithNModels : List (String × Nat) := theoriesWithNModels

def benchFiniteStructure : MiniFunctionRelation.Structure := finiteStructure 5

def benchNonAxiomatizable : List String := nonAxiomatizableClasses

def benchIncompleteList : List String := incompleteTheories

#eval benchCounterexamples
#eval benchIncompleteTheory
#eval benchTheoriesWithNModels
#eval benchFiniteStructure
#eval benchNonAxiomatizable
#eval benchIncompleteList
