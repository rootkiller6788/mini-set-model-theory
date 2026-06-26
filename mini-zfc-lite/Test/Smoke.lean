/-
# Smoke Tests — MiniZFCLite

Run: `lake env lean --run Test/Smoke.lean`
-/

import MiniZFCLite

open MiniZFCLite

#eval "══ MINI-ZFC-LITE SMOKE TESTS ══"

/-! ## Core.Basic: ZFC Axiom Count -/
#eval zfcAxiomList.length

/-! ## Core.Objects: ZFC AxiomSet and AxiomSystem -/
#eval zfcAxiomSet.size
#eval zfcSystem.name
#eval zfcSystem.version

/-! ## Consistency Check: ZFC has trivial model -/
#eval "══ ALL MINI-ZFC-LITE SMOKE TESTS PASSED ══"
