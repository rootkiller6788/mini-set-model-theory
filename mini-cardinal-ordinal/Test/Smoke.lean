/-
# Smoke Tests — MiniCardinalOrdinal

Run: `lake env lean --run Test/Smoke.lean`
-/

import MiniCardinalOrdinal

open MiniCardinalOrdinal

#eval "══ MINI-CARDINAL-ORDINAL SMOKE TESTS ══"

/-! ## Core.Basic: StabilityClass -/
#eval StabilityClass.unstable
#eval StabilityClass.stable
#eval StabilityClass.superstable
#eval StabilityClass.ωStable
#eval StabilityClass.totallyTranscendental

/-! ## StabilityClass ToString -/
#eval toString StabilityClass.unstable
#eval toString StabilityClass.stable
#eval toString StabilityClass.superstable
#eval toString StabilityClass.ωStable
#eval toString StabilityClass.totallyTranscendental

/-! ## Core.Basic: Theory and MorleyRank -/
#eval { axioms := (∅ : Set MiniLogicKernel.PredFormula) : Theory }
#eval { value := 3 : MorleyRank }

/-! ## Core.Objects: Cardinal -/
#eval Cardinal.alephZero
#eval Cardinal.alephOne
#eval toString Cardinal.alephZero
#eval Cardinal.succ Cardinal.alephZero
#eval Cardinal.add Cardinal.alephZero Cardinal.alephOne
#eval Cardinal.mul Cardinal.alephOne Cardinal.alephOne

/-! ## Core.Objects: Cardinal comparisons -/
#eval Cardinal.eq Cardinal.alephZero Cardinal.alephZero
#eval Cardinal.le Cardinal.alephZero Cardinal.alephOne
#eval Cardinal.lt Cardinal.alephZero Cardinal.alephOne

/-! ## Core.Objects: Ordinal -/
#eval (Ordinal.zero : Ordinal)
#eval Ordinal.omega

/-! ## Core.Laws: Cofinality -/
#eval cofinality Cardinal.alephZero
#eval cofinality Cardinal.alephOne
#eval isSingular Cardinal.alephZero
#eval isSingular Cardinal.alephOne

/-! ## Properties.Invariants: Stability in Power -/
#eval stabilityInPower ({ axioms := ∅ : Theory }) 0
#eval morleyRank ({ axioms := ∅ : Theory })

/-! ## Properties.ClassificationData -/
#eval getClassificationData ({ axioms := ∅ : Theory })

/-! ## Theorems.Main: ClassificationResult -/
#eval classify ({ axioms := ∅ : Theory })

/-! ## Morphisms: EFGameResult -/
#eval EFGameResult.playerTwoWins

#eval "══ ALL MINI-CARDINAL-ORDINAL SMOKE TESTS PASSED ══"
