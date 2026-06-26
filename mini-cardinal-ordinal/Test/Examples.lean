/-
# Example Tests — MiniCardinalOrdinal

Run: `lake env lean --run Test/Examples.lean`
-/

import MiniCardinalOrdinal

open MiniCardinalOrdinal

#eval "══ MINI-CARDINAL-ORDINAL EXAMPLE TESTS ══"

/-! ## Stability Spectrum Examples -/
#eval acfStabilitySpectrum
#eval dloStabilitySpectrum
#eval rgStabilitySpectrum
#eval abelianGroupStability
#eval scfStability
#eval vectorSpaceStability

/-! ## Theory Examples -/
#eval theoryOfDenseLinearOrder
#eval theoryOfRandomGraph
#eval theoryOfAlgebraicallyClosedFields

/-! ## Counterexample Theories -/
#eval stableNotSuperstable
#eval alephZeroCategoricalNotAlephOne
#eval alephOneCategoricalNotAlephZero

#eval "══ ALL MINI-CARDINAL-ORDINAL EXAMPLE TESTS PASSED ══"
