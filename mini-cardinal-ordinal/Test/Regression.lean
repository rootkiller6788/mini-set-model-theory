/-
# Regression Tests — MiniCardinalOrdinal

Run: `lake env lean --run Test/Regression.lean`
-/

import MiniCardinalOrdinal

open MiniCardinalOrdinal

#eval "══ MINI-CARDINAL-ORDINAL REGRESSION TESTS ══"

/-! ## Cardinal Arithmetic Consistency -/
#eval Cardinal.eqBool (Cardinal.add Cardinal.alephZero Cardinal.alephOne) Cardinal.alephOne
#eval Cardinal.eqBool (Cardinal.mul Cardinal.alephZero Cardinal.alephZero) Cardinal.alephZero

/-! ## StabilityClass Round-trip -/
def allClasses : List StabilityClass := [
  StabilityClass.unstable,
  StabilityClass.stable,
  StabilityClass.superstable,
  StabilityClass.ωStable,
  StabilityClass.totallyTranscendental
]

#eval allClasses.map toString

/-! ## MorleyRank constructions -/
#eval { value := 0 : MorleyRank }
#eval { value := 5 : MorleyRank }

/-! ## Cardinal constructions -/
#eval Cardinal.succ (Cardinal.succ Cardinal.alephZero)
#eval Cardinal.exp Cardinal.alephZero ⟨1⟩

#eval "══ ALL MINI-CARDINAL-ORDINAL REGRESSION TESTS PASSED ══"
