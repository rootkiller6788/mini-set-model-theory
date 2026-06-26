import MiniOrderEquivalence

open MiniOrderEquivalence

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniOrderEquivalence v0.1.0"
  IO.println "  Elementary Equivalence of Structures"
  IO.println "═══════════════════════════════════════"
  IO.println s!"  Core: ElementarilyEquivalent, theoryOf, ElementarySubstructure"
  IO.println s!"  Morphisms: equiv relation (refl/symm/trans)"
  IO.println s!"  Constructions: Submodel, Product, Quotient, Expansion"
  IO.println s!"  Properties: Elementary, Categorical, Homogeneous"
  IO.println s!"  Theorems: Compactness, LowenheimSkolem, Isomorphism, Completeness"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."
