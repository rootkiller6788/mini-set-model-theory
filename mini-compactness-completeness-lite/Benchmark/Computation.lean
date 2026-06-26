/-
# Benchmark: Computation Bridge Evaluations
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def benchDecidable : List Bool :=
  (List.map isDecidable ["DLO", "ACF0", "RCF", "Presburger", "PA", "ZFC"])

def benchDecidableTheories : String :=
  String.intercalate ", " decidableTheories

def benchUndecidableTheories : String :=
  String.intercalate ", " undecidableTheories

def benchPresburger : List String :=
  [presburgerArithmeticStatement, presburgerQE, skolemArithmetic]

def benchRCF : List String :=
  [rcfDecidability, cylindricalAlgebraicDecomposition]

def benchFMP : List String :=
  [finiteModelProperty, trakhtenbrotTheorem]

def benchAutomata : List String :=
  [buechiTheorem, rabinTreeTheorem, msoDecidability]

#eval benchDecidable
#eval benchDecidableTheories
#eval benchUndecidableTheories
#eval benchPresburger
#eval benchRCF
#eval benchFMP
