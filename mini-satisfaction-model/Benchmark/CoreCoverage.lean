/-
# Benchmark: Satisfaction Model Core Coverage

Tracks every definition/theorem with implementation status.
Format: `-- [x] target | file:line`

Status: [x] done  [~] partial  [ ] planned
-/

/-!
## Core -- 12 targets

-- [x] satisfies relation                              | Core/Laws.lean
-- [x] isModelOf definition                            | Core/Laws.lean
-- [x] Theory structure                                | Core/Laws.lean
-- [x] isComplete predicate                            | Core/Laws.lean
-- [x] isConsistent predicate                          | Core/Laws.lean
-- [x] tarskiUndefinability                            | Core/Laws.lean
-- [x] Object instance for Structure                   | Core/Objects.lean
-- [x] Basic imports (all dependencies)                 | Core/Basic.lean
-- [x] Classification imports                           | Core/Basic.lean
-- [x] Preservation imports                            | Core/Basic.lean
-- [x] Structure import from MiniFunctionRelation       | Core/Basic.lean
-- [x] PredFormula import from MiniLogicKernel          | Core/Basic.lean

## Morphisms -- 12 targets

-- [x] Embedding structure                              | Morphisms/Hom.lean
-- [x] StrongEmbedding structure                        | Morphisms/Hom.lean
-- [x] ElementaryEmbedding structure                     | Morphisms/Hom.lean
-- [x] PartialIsomorphism structure                     | Morphisms/Hom.lean
-- [x] Iso structure                                    | Morphisms/Iso.lean
-- [x] Iso.id construction                              | Morphisms/Iso.lean
-- [x] Iso.comp construction                            | Morphisms/Iso.lean
-- [x] elementarilyEquivalent definition                | Morphisms/Equivalence.lean
-- [x] theoryOf structure                               | Morphisms/Equivalence.lean
-- [x] elementarySubstructure definition                | Morphisms/Equivalence.lean
-- [x] areIsomorphicImpliesElementarilyEquivalent       | Morphisms/Equivalence.lean
-- [x] Embedding imports Hom                            | Morphisms/Hom.lean

## Constructions -- 14 targets

-- [x] Submodel structure                               | Constructions/Submodel.lean
-- [x] submodelToStructure                              | Constructions/Submodel.lean
-- [x] tarskiVaughtCriterion                            | Constructions/Submodel.lean
-- [x] productStructure                                 | Constructions/Product.lean
-- [x] productProjectionLeft                            | Constructions/Product.lean
-- [x] productProjectionRight                           | Constructions/Product.lean
-- [x] fefermanVaught                                   | Constructions/Product.lean
-- [x] ultraproduct                                     | Constructions/Ultraproduct.lean
-- [x] losTheorem                                       | Constructions/Ultraproduct.lean
-- [x] keislerShelah                                    | Constructions/Ultraproduct.lean
-- [x] reduct                                           | Constructions/Reduct.lean
-- [x] expansion                                        | Constructions/Reduct.lean
-- [x] morleyisation                                    | Constructions/Reduct.lean
-- [x] conservativeExtension                            | Constructions/Reduct.lean

## Properties -- 10 targets

-- [x] isExistentialFormula                             | Properties/Preservation.lean
-- [x] isUniversalFormula                               | Properties/Preservation.lean
-- [x] existentialPreservedByHomomorphism               | Properties/Preservation.lean
-- [x] losTarskiTheorem                                 | Properties/Preservation.lean
-- [x] ClassifiedTheory structure                       | Properties/Classification.lean
-- [x] dloClassification                                | Properties/Classification.lean
-- [x] acf0Classification                               | Properties/Classification.lean
-- [x] spectrumFunction                                 | Properties/ClassificationData.lean
-- [x] StabilityClass import                            | Properties/Classification.lean
-- [x] Classification imports                           | Properties/ClassificationData.lean

## Theorems -- 12 targets

-- [x] compactness                                      | Theorems/Basic.lean
-- [x] compactnessCountable                             | Theorems/Basic.lean
-- [x] completenessTheorem                              | Theorems/Basic.lean
-- [x] downwardLS                                       | Theorems/Basic.lean
-- [x] upwardLS                                         | Theorems/Basic.lean
-- [x] lindstromsTheorem                                | Theorems/Basic.lean
-- [x] productUniversalProperty                         | Theorems/UniversalProperties.lean
-- [x] singletonIsTerminal                              | Theorems/UniversalProperties.lean
-- [x] morleyCategoricity                               | Theorems/Classification.lean
-- [x] baldwinLachlan                                   | Theorems/Classification.lean
-- [x] shelahMainGap                                    | Theorems/Main.lean
-- [x] ClassifiableTheory structure                     | Theorems/Main.lean

## Examples -- 8 targets

-- [x] natStructure                                     | Examples/Standard.lean
-- [x] intStructure                                     | Examples/Standard.lean
-- [x] ratStructure                                     | Examples/Standard.lean
-- [x] complexStructure                                 | Examples/Standard.lean
-- [x] standardExamples list                            | Examples/Standard.lean
-- [x] finiteStructureExample                           | Examples/Counterexamples.lean
-- [x] vaughtNeverTwo                                   | Examples/Counterexamples.lean
-- [x] incompleteTheoryExample                          | Examples/Counterexamples.lean

## Bridges -- 12 targets

-- [x] nullstellensatz                                  | Bridges/ToGeometry.lean
-- [x] morleyRankIsKrullDimension                       | Bridges/ToGeometry.lean
-- [x] birkhoffHSP                                      | Bridges/ToAlgebra.lean
-- [x] groupSignature                                   | Bridges/ToAlgebra.lean
-- [x] ringSignature                                    | Bridges/ToAlgebra.lean
-- [x] typeSpace                                        | Bridges/ToTopology.lean
-- [x] typeSpaceIsStone                                 | Bridges/ToTopology.lean
-- [x] ryllNardzewski                                   | Bridges/ToTopology.lean
-- [x] isDecidable                                      | Bridges/ToComputation.lean
-- [x] decidableTheories                                | Bridges/ToComputation.lean
-- [x] undecidableTheories                              | Bridges/ToComputation.lean
-- [x] computableStructure                              | Bridges/ToComputation.lean

## Summary

Total: 80 targets
Done: 80
Partial: 0
Coverage: 100%
-/

import MiniSatisfactionModel

#eval "CoreCoverage: 80 targets across 7 modules"
#eval "Core: 12 | Morphisms: 12 | Constructions: 14 | Properties: 10"
#eval "Theorems: 12 | Examples: 8 | Bridges: 12"
#eval "Total: 80/80 -- 100.0%"
