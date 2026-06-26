import MiniCardinalOrdinal

namespace MiniCardinalOrdinal

def main : IO Unit := do
  IO.println "═══════════════════════════════════════"
  IO.println "  MiniCardinalOrdinal v0.1.0"
  IO.println "  Cardinal Invariants and Stability Theory"
  IO.println "═══════════════════════════════════════"
  IO.println ""
  IO.println "  Core:        StabilityClass, Theory, Cardinal, Ordinal, Laws"
  IO.println "  Morphisms:   ElementaryEmbedding, StructureIso, BackForthSystem"
  IO.println "  Constructions: Substructures, Products, Quotients, Expansions"
  IO.println "  Properties:  Invariants, ClassificationData, Preservation"
  IO.println "  Theorems:    Basic, Stability, Categoricity, Main (Shelah's Gap)"
  IO.println "  Examples:    Standard, Counterexamples"
  IO.println "  Bridges:     ToFunctionRelation, ToLogicKernel, ToCardinalArithmetic, ToOrderTheory"
  IO.println ""
  IO.println "  Run `lake env lean --run Test/Smoke.lean` for tests."

end MiniCardinalOrdinal
