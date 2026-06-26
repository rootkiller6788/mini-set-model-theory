/-
# Benchmark: MiniSetCore Core Coverage

Tracks every definition/theorem with implementation status.
Format: `-- [x] target | file:line`

Status: [x] done  [~] partial  [ ] planned
-/

/-!
## Core — 12 targets

-- [x] Set type definition                      | Core/Basic.lean
-- [x] mem function                              | Core/Basic.lean
-- [x] Membership instance                       | Core/Basic.lean
-- [x] emptySet                                  | Core/Basic.lean
-- [x] singleton                                 | Core/Basic.lean
-- [x] pair                                      | Core/Basic.lean
-- [x] union                                     | Core/Basic.lean
-- [x] inter                                     | Core/Basic.lean
-- [x] powerSet                                  | Core/Basic.lean
-- [x] diff                                      | Core/Basic.lean
-- [x] subset / HasSubset instance               | Core/Basic.lean
-- [x] isRelation / isFunction                   | Core/Basic.lean
-- [x] FinSet inductive type                     | Core/Basic.lean
-- [x] FinSet.toSet                              | Core/Basic.lean
-- [x] FinSet.mem                                | Core/Basic.lean
-- [x] FinSet.size                               | Core/Basic.lean
-- [x] exampleFinSet                             | Core/Basic.lean
-- [x] Object instance for Set                   | Core/Objects.lean
-- [x] Element structure                         | Core/Objects.lean
-- [x] Relation / Function abbreviations         | Core/Objects.lean
-- [x] OrderedPair structure                     | Core/Objects.lean
-- [x] registerSetTheory                         | Core/Objects.lean
-- [~] Core.Laws stub                            | Core/Laws.lean

## Morphisms — 3 targets

-- [x] SetFunction structure                     | Morphisms/Hom.lean
-- [x] SetFunction.id                            | Morphisms/Hom.lean
-- [x] SetFunction.comp                          | Morphisms/Hom.lean
-- [x] SetIso structure                          | Morphisms/Iso.lean
-- [x] CardinalEquivalence structure             | Morphisms/Equivalence.lean

## Constructions — 4 targets

-- [x] cartesianProduct                          | Constructions/Products.lean
-- [~] Universal stub                            | Constructions/Universal.lean
-- [~] Subobjects stub                           | Constructions/Subobjects.lean
-- [~] Quotients stub                            | Constructions/Quotients.lean

## Properties — 3 stubs

-- [~] Invariants stub                           | Properties/Invariants.lean
-- [~] Preservation stub                         | Properties/Preservation.lean
-- [~] ClassificationData stub                   | Properties/ClassificationData.lean

## Theorems — 4 stubs

-- [~] Basic stub                                | Theorems/Basic.lean
-- [~] UniversalProperties stub                  | Theorems/UniversalProperties.lean
-- [~] Classification stub                       | Theorems/Classification.lean
-- [~] Main stub                                 | Theorems/Main.lean

## Examples — 2 targets

-- [x] natSet / evenSet / primeSet               | Examples/Standard.lean
-- [~] Counterexamples stub                      | Examples/Counterexamples.lean

## Bridges — 4 stubs

-- [~] ToAlgebra stub                            | Bridges/ToAlgebra.lean
-- [~] ToTopology stub                           | Bridges/ToTopology.lean
-- [~] ToGeometry stub                           | Bridges/ToGeometry.lean
-- [~] ToComputation stub                        | Bridges/ToComputation.lean

## Summary

Total: 32 targets
Done: 19
Stub: 13
Coverage: 59% (core done, expansions stubbed)
-/

#eval "CoreCoverage: 32 targets, 19 done, 13 stubs"
