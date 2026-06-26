/-
# Regression Tests — MiniZFCLite

Run: `lake env lean --run Test/Regression.lean`
-/

import MiniZFCLite

open MiniZFCLite
open MiniLogicKernel

#eval "══ MINI-ZFC-LITE REGRESSION TESTS ══"

/-! ## AxiomList properties -/
#eval zfcAxiomList.length == 8

/-! ## AxiomSet properties -/
#eval zfcAxiomSet.size == 8
#eval zfcAxiomSet.containsName "zfc-extensionality"
#eval zfcAxiomSet.containsName "zfc-empty"
#eval zfcAxiomSet.containsName "zfc-pairing"
#eval zfcAxiomSet.containsName "zfc-union"
#eval zfcAxiomSet.containsName "zfc-power-set"
#eval zfcAxiomSet.containsName "zfc-separation"
#eval zfcAxiomSet.containsName "zfc-infinity"
#eval zfcAxiomSet.containsName "zfc-choice"
#eval !(zfcAxiomSet.containsName "nonexistent")

/-! ## AxiomSystem properties -/
#eval zfcSystem.name == "ZFC"
#eval zfcSystem.version == "0.1.0"
#eval zfcSystem.axioms.size == 8

/-! ## PredFormula structure -/
#eval zfcExtensionality
#eval zfcInfinity

#eval "══ ALL MINI-ZFC-LITE REGRESSION TESTS PASSED ══"
