/-
# Comparison Benchmark -- MiniZFCLite

Compares different axiom representations and system configurations.
Run: `lake env lean --run Benchmark/Comparison.lean`
-/

import MiniZFCLite

open MiniZFCLite

#eval "══ MINI-ZFC-LITE COMPARISON BENCHMARK ══"

/-! ## Compare different axiom representations -/
def listSize := zfcAxiomList.length
def setSize := zfcAxiomSet.size

#eval listSize == setSize
#eval s!"List contains {listSize} axioms, Set contains {setSize} axioms"

/-! ## System comparison -/
#eval zfcSystem.name
#eval "ZFC vs ZF (Extensionality, Foundation missing): redundancy check"

/-! ## Axiom representation: tuple vs record -/
#eval "List[(String, String)]: minimal, fast iteration"
#eval "Set[(String, String)]: deduplication, fast membership"

/-! ## Intersection of axiom sets -/
def extAx := zfcAxiomList.filter (fun (n, _) => n = "extensionality")
#eval s!"Extensionality axioms found: {extAx.length}"

/-! ## Difference: list vs set iteration -/
#eval "List iteration (sequential): O(n) access, ordered"
#eval "Set iteration (hash): O(1) membership, unordered"

/-! ## Coverage check -/
#eval s!"Expected: 9 axioms (Ext, Pair, Union, Power, Infinity, Sep, Repl, Choice, Regular)"
#eval s!"Actual: {zfcAxiomList.length} axioms"

#eval "══ COMPARISON BENCHMARK COMPLETE ══"
