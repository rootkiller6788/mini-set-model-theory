import MiniSetCore

open MiniSetCore

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniSetCore v0.1.0"
  IO.println "  Set Theory Sub-Package"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Set α := α → Prop"
  IO.println s!"  FinSet: finite set inductive type"
  IO.println s!"  Operations: union, inter, powerSet, diff"
  IO.println s!"  Object instance: SetTheory via Object typeclass"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
