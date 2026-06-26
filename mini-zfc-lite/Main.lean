/-
# Main — MiniZFCLite

Entry point that prints ZFC package information.
-/

import MiniZFCLite

open MiniZFCLite

def main : IO Unit := do
  IO.println "══ mini-zfc-lite ══"
  IO.println "Zermelo-Fraenkel Set Theory with Choice (ZFC) — Lite Edition."
  IO.println ""
  IO.println "8 ZFC Axioms:"
  for (name, _) in zfcAxiomList do
    IO.println s!"  - {name}"
  IO.println ""
  IO.println s!"AxiomSet: {zfcAxiomSet}"
  IO.println s!"AxiomSystem: {zfcSystem}"
  IO.println ""
  IO.println "Modules:"
  IO.println "  Core:    Basic, Objects, Laws"
  IO.println "  Morphisms:  Functorial, Natural, Adjoint"
  IO.println "  Constructions: Product, Coproduct, Limit, Colimit"
  IO.println "  Properties:   Universal, Structural, Computational"
  IO.println "  Theorems:     Fundamental, Structural, Classification, Representation"
  IO.println "  Examples:     Standard, Counterexamples"
  IO.println "  Bridges:      ToLogic, ToAlgebra, ToGeometry, ToTopology"
  IO.println ""
  IO.println "══ End of mini-zfc-lite info ══"
