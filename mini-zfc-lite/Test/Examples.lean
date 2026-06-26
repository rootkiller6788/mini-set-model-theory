/-
# Example Tests — MiniZFCLite

Run: `lake env lean --run Test/Examples.lean`
-/

import MiniZFCLite

open MiniZFCLite
open MiniLogicKernel

#eval "══ MINI-ZFC-LITE EXAMPLES ══"

/-! ## ZFC Axiom Inspection -/
#eval zfcExtensionality
#eval zfcEmptySet
#eval zfcPairing
#eval zfcUnion
#eval zfcPowerSet
#eval zfcSeparation
#eval zfcInfinity
#eval zfcChoice

/-! ## AxiomList -/
#eval zfcAxiomList.map (·.1)

/-! ## AxiomSet -/
#eval zfcAxiomSet.size
#eval zfcAxiomSet.containsName "zfc-extensionality"
#eval zfcAxiomSet.containsName "zfc-choice"

#eval "══ ALL MINI-ZFC-LITE EXAMPLE TESTS PASSED ══"
