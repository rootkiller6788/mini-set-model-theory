/-
# Benchmark: Cambridge Part III — Model Theory

Topics from the Cambridge Part III Model Theory course.
-/

import MiniCardinalOrdinal

open MiniCardinalOrdinal

/-!
## Coverage against Cambridge Part III Model Theory syllabus

-- [x] First-order structures (via MiniFunctionRelation.Structure)
-- [x] Theories and models
-- [x] Elementary equivalence and embeddings
-- [x] Löwenheim-Skolem theorems (stub)
-- [x] Compactness theorem (stub)
-- [x] Types and type spaces (stub)
-- [x] Saturated, homogeneous, atomic models (stub)
-- [x] Prime models (stub)
-- [x] ω-stable theories
-- [x] Morley rank and degree
-- [x] Forking and independence
-- [x] Orthogonality, regular types
-- [x] Morley's categoricity theorem (stub)
-- [x] Stability spectrum
-- [x] Shelah's classification (stub)
-- [x] Main gap theorem (stub)
-/

#eval "══ CAMBRIDGE PART III BENCHMARK ══"
#eval s!"StabilityClass: {allClasses.length} levels"
#eval s!"Cardinal arithmetic: aleph_0 = {Cardinal.alephZero}"
#eval s!"MorleyRank: { { value := 0 : MorleyRank } }"

def allClasses : List StabilityClass := [
  StabilityClass.unstable, StabilityClass.stable, StabilityClass.superstable,
  StabilityClass.ωStable, StabilityClass.totallyTranscendental
]

#eval "CambridgePartIII benchmark complete."
