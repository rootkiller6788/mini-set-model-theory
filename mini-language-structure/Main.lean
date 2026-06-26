import MiniLanguageStructure

open MiniLanguageStructure

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniLanguageStructure v0.1.0"
  IO.println "  Substructures, Products, Quotients, Universal Constructions"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  SymbolKind: relation(arity) or constant"
  IO.println s!"  Symbol: index + kind descriptor"
  IO.println s!"  FormulaShape: atomic, negation, conjunction, universal, existential, etc."
  IO.println s!"  cardinality: signature size computation"
  IO.println s!"  unitStructure / natStructure: canonical example structures"
  IO.println s!"  Substructures, product structures, quotient structures, universal constructions"
  IO.println ""
  IO.println "  Depends on: mini-function-relation, mini-order-equivalence"
  IO.println "  Tests: Test/Smoke.lean, Test/Examples.lean, Test/Regression.lean"
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
