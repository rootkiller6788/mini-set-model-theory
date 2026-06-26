import MiniFunctionRelation

open MiniFunctionRelation

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniFunctionRelation v0.1.0"
  IO.println "  Structure Homomorphisms for Model Theory"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Structure: domain, predicate interpretation, constant interpretation"
  IO.println s!"  Structure.card: cardinality helper"
  IO.println s!"  Hom: structure-preserving maps between first-order structures"
  IO.println s!"  Object instance: registered via MiniObjectKernel"
  IO.println ""
  IO.println "  Depends on: mini-object-kernel"
  IO.println "  Tests: Test/Smoke.lean, Test/Examples.lean, Test/Regression.lean"
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
