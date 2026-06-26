import MiniSatisfactionModel

open MiniSatisfactionModel

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniSatisfactionModel v0.1.0"
  IO.println "  Satisfaction Relation, Formula Preservation, Classification Theory"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  satisfies M φ env: Tarski's satisfaction relation"
  IO.println s!"  Theory: set of axioms with consistency, completeness"
  IO.println s!"  theoryOf: extract theory from a structure"
  IO.println s!"  isModelOf: M is a model of T"
  IO.println s!"  isConsistent / isComplete: theory classification properties"
  IO.println s!"  isElementaryEmbedding: preserves satisfaction of all formulas"
  IO.println s!"  Syntax classification: universal, existential, positive, quantifier-free"
  IO.println s!"  compactness (axiom): finite consistency ⇒ full consistency"
  IO.println ""
  IO.println "  Depends on: mini-function-relation, mini-logic-kernel, mini-cardinal-ordinal"
  IO.println "  Tests: Test/Smoke.lean, Test/Examples.lean, Test/Regression.lean"
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
