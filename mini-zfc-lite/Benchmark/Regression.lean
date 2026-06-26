/-
# Regression Benchmark — MiniZFCLite

Run: `lake env lean --run Benchmark/Regression.lean`
-/

import MiniZFCLite

open MiniZFCLite

#eval "══ MINI-ZFC-LITE REGRESSION BENCHMARK ══"

/-! ## Verify all 8 axioms are present after any refactoring -/
def axiomNames : List String := zfcAxiomList.map (·.1)

def expectedNames : List String := [
  "zfc-extensionality", "zfc-empty", "zfc-pairing", "zfc-union",
  "zfc-power-set", "zfc-separation", "zfc-infinity", "zfc-choice"
]

#eval axiomNames == expectedNames
#eval zfcAxiomSet.size == 8
#eval zfcSystem.name == "ZFC"
#eval zfcSystem.version == "0.1.0"

#eval "══ REGRESSION BENCHMARK COMPLETE ══"
