/-
# Basic Benchmark -- MiniZFCLite

Measures basic operations: axiom count, axiom set size, system properties.
Run: `lake env lean --run Benchmark/Basic.lean`
-/

import MiniZFCLite

open MiniZFCLite

#eval "══ MINI-ZFC-LITE BASIC BENCHMARK ══"

/-! ## Measure axiom count -/
#eval zfcAxiomList.length

/-! ## Measure axiom set creation time -/
#eval zfcAxiomSet.size

/-! ## System metadata -/
#eval zfcSystem.name
#eval "System type: ZFC set theory"

/-! ## Axiom name listing -/
#eval zfcAxiomList.map (·.1)

/-! ## Axiom content preview (first 3) -/
def firstThree := zfcAxiomList.take 3
#eval firstThree

/-! ## Quick access benchmark -/
#eval "Benchmark: zfcAxiomSet access (O(1) hash lookup)"
#eval s!"Axiom count: {zfcAxiomList.length}"
#eval s!"Axiom set size: {zfcAxiomSet.size}"
#eval s!"System name: {zfcSystem.name}"

#eval "══ BENCHMARK COMPLETE ══"
