# MiniCardinalOrdinal Architecture

## Package Structure

```
mini-cardinal-ordinal/
  MiniCardinalOrdinal.lean          # Root aggregator
  Main.lean                         # Entry point
  lakefile.lean                     # Lake build configuration
  lean-toolchain                    # leanprover/lean4:v4.7.0

  MiniCardinalOrdinal/
    Core/
      Basic.lean                    # StabilityClass, Theory, MorleyRank
      Objects.lean                  # Cardinal, Ordinal types and arithmetic
      Laws.lean                     # Cardinal arithmetic laws, GCH, cofinality
    Morphisms/
      Hom.lean                      # Elementary embeddings
      Iso.lean                      # Structure isomorphisms
      Equivalence.lean             # Elementary equivalence, EF games
    Constructions/
      Substructure.lean             # Elementary substructures
      Product.lean                  # Products and ultraproducts
      Quotient.lean                 # Quotients and interpretations
      Expansion.lean                # Expansions by constants/Morleyisation
    Properties/
      Invariants.lean               # Stability invariants, Morley rank
      ClassificationData.lean       # Forking, orthogonality, depth
      Preservation.lean             # Preservation theorems
    Theorems/
      Basic.lean                    # Löwenheim-Skolem, compactness
      Stability.lean                # Stability spectrum
      Categoricity.lean             # Morley categoricity
      Main.lean                     # Shelah's main gap
    Examples/
      Standard.lean                 # Standard examples
      Counterexamples.lean          # Counterexamples
    Bridges/
      ToFunctionRelation.lean       # Bridge to MiniFunctionRelation
      ToLogicKernel.lean            # Bridge to MiniLogicKernel
      ToCardinalArithmetic.lean     # Bridge to cardinal arithmetic
      ToOrderTheory.lean            # Bridge to order theory

  Test/
    Smoke.lean                      # Quick smoke tests
    Examples.lean                   # Example tests
    Regression.lean                 # Regression tests

  Benchmark/
    CoreCoverage.lean               # Internal coverage tracking
    CambridgePartIII.lean           # Cambridge Part III syllabus
    Harvard.lean                    # Harvard Math 251/252
    MIT.lean                        # MIT 18.514
    OxfordPartC.lean                # Oxford C3.3
    Princeton.lean                  # Princeton classification theory

  docs/
    architecture.md                 # This file
    coverage.md                     # Coverage report
    dependency.md                   # Dependency map

  scripts/
    check.sh                        # Linux/macOS build script
    check.ps1                       # Windows build script

  Computation/
    notebooks/.gitkeep
    python/.gitkeep
    sage/.gitkeep
```

## Dependencies

- `mini-function-relation` (for `MiniFunctionRelation.Structure`)
- `mini-logic-kernel` (for `MiniLogicKernel.PredFormula`)

## Namespace

All code lives under `MiniCardinalOrdinal`.
