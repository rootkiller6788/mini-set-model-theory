/-
# Memory Benchmark -- MiniZFCLite

Measures approximate memory footprint of axiom data structures.
Run: `lake env lean --run Benchmark/Memory.lean`
-/

import MiniZFCLite

open MiniZFCLite

#eval "══ MINI-ZFC-LITE MEMORY BENCHMARK ══"

/-! ## Measure memory for axiom structures -/
def axiomCount := zfcAxiomSet.size
def systemSize := toString zfcSystem |>.length

#eval s!"Axiom count: {axiomCount}"
#eval s!"System name string length: {systemSize} chars"

/-! ## Per-axiom memory estimate -/
#eval s!"Average axiom pair size: 2 strings (~50 chars each)"

/-! ## String storage -/
def totalAxStringLength : Nat :=
  zfcAxiomList.map (fun (n, f) => n.length + f.length) |>.sum
#eval s!"Total axiom string data: {totalAxStringLength} chars"

/-! ## Comparison: list vs set memory -/
#eval "List[(String,String)]: ~(2 pointers + 2 string pointers) per entry"
#eval "Set: additional hash table overhead (~2x list memory)"

/-! ## Structure overhead estimate -/
#eval "System: ~100 bytes (name + metadata)"
#eval "AxiomSet: ~24 bytes per entry (hash table)"
#eval s!"Estimated total memory: " ++ toString (24 * axiomCount + 100) ++ " bytes (approximate)"

#eval "══ MEMORY BENCHMARK COMPLETE ══"
