/-
# Benchmark: MiniCardinalOrdinal Core Coverage

Tracks every definition/theorem with implementation status.
Format: `-- [x] target | file:line`

Status: [x] done  [~] partial  [ ] planned
-/

/-!
## Core — targets

-- [x] StabilityClass inductive                     | Core/Basic.lean
-- [x] StabilityClass ToString instance              | Core/Basic.lean
-- [x] cardOf                                       | Core/Basic.lean
-- [x] isFiniteStructure                            | Core/Basic.lean
-- [x] isCountableStructure                         | Core/Basic.lean
-- [x] Theory structure                             | Core/Basic.lean
-- [x] isComplete                                   | Core/Basic.lean
-- [x] isModelOf                                    | Core/Basic.lean
-- [x] κCategorical                                 | Core/Basic.lean
-- [x] MorleyRank structure                         | Core/Basic.lean
-- [x] Cardinal structure                           | Core/Objects.lean
-- [x] Cardinal.alephZero/alephOne                  | Core/Objects.lean
-- [x] Cardinal arithmetic (add, mul, exp, succ)    | Core/Objects.lean
-- [x] Cardinal comparisons (eq, le, lt)            | Core/Objects.lean
-- [x] Ordinal inductive                            | Core/Objects.lean
-- [x] Ordinal arithmetic (add, mul)                | Core/Objects.lean
-- [x] Ordinal.omega                                | Core/Objects.lean
-- [x] isRegularCardinal, isStrongLimit             | Core/Objects.lean
-- [x] continuumFunction                            | Core/Objects.lean
-- [x] stabilitySpectrum                            | Core/Objects.lean
-- [x] cantorTheorem                                | Core/Laws.lean
-- [x] cantorBernstein                              | Core/Laws.lean
-- [x] Card arithmetic laws (comm, assoc, dist)     | Core/Laws.lean
-- [x] konigTheorem                                 | Core/Laws.lean
-- [x] hausdorffFormula                             | Core/Laws.lean
-- [x] GCH                                          | Core/Laws.lean
-- [x] cofinality, isSingular                       | Core/Laws.lean
-- [x] stabilityTransfer                            | Core/Laws.lean

## Morphisms — ElementaryEmbedding etc

-- [~] ElementaryEmbedding structure                | Morphisms/Hom.lean
-- [~] StructureIso structure                       | Morphisms/Iso.lean
-- [~] BackForthSystem structure                    | Morphisms/Equivalence.lean

## Properties — Cardinal invariants

-- [x] stabilityInPower                             | Properties/Invariants.lean
-- [x] morleyRank                                   | Properties/Invariants.lean
-- [~] forkingEqualsDividing                        | Properties/ClassificationData.lean
-- [~] weight, depth, NDOP, NOTOP                   | Properties/ClassificationData.lean

## Theorems — stability and categoricity

-- [~] stabilitySpectrumTheorem                     | Theorems/Stability.lean
-- [~] morleyCategoricityTheorem                    | Theorems/Categoricity.lean
-- [~] mainGapTheoremComplete                       | Theorems/Main.lean

## Summary

Total: many targets
Core implemented fully (Basic, Objects, Laws)
Expansions stubbed with Prop-level declarations
Coverage: ~60% (core done, expansions stubbed)
-/

#eval "CoreCoverage: core fully implemented, expansions stubbed"
