/-
# Benchmark: MiniLanguageStructure Core Coverage

Tracks every definition/theorem with implementation status.
Format: `-- [x] target | file:line`

Status: [x] done  [~] partial  [ ] planned
-/

/-!
## Core — 3 targets

-- [x] Basic namespace stub              | Core/Basic.lean
-- [~] Objects stub                        | Core/Objects.lean
-- [~] Laws stub                           | Core/Laws.lean

## Morphisms — 3 stubs

-- [~] Hom stub                            | Morphisms/Hom.lean
-- [~] Iso stub                            | Morphisms/Iso.lean
-- [~] Equivalence stub                    | Morphisms/Equivalence.lean

## Constructions — 12 targets

-- [x] Substructure structure              | Constructions/Subobjects.lean
-- [x] Substructure.toStructure            | Constructions/Subobjects.lean
-- [x] Substructure.inclusion              | Constructions/Subobjects.lean
-- [x] TarskiVaughtCriterion               | Constructions/Subobjects.lean
-- [x] Congruence structure                | Constructions/Quotients.lean
-- [x] quotientStructure                   | Constructions/Quotients.lean
-- [x] quotientProjection                  | Constructions/Quotients.lean
-- [x] productStructure                    | Constructions/Products.lean
-- [x] productFst                          | Constructions/Products.lean
-- [x] productSnd                          | Constructions/Products.lean
-- [x] productUniversal                    | Constructions/Products.lean
-- [x] InitialStructure                    | Constructions/Universal.lean
-- [x] TerminalStructure                   | Constructions/Universal.lean
-- [x] forgetfulFunctor                    | Constructions/Universal.lean

## Properties — 3 stubs

-- [~] Invariants stub                     | Properties/Invariants.lean
-- [~] Preservation stub                   | Properties/Preservation.lean
-- [~] Elementary stub                     | Properties/Elementary.lean

## Theorems — 6 targets

-- [x] productIsCategoricalProduct         | Theorems/UniversalProperties.lean
-- [x] singletonIsTerminal                 | Theorems/UniversalProperties.lean
-- [x] emptyIsInitial                      | Theorems/UniversalProperties.lean
-- [~] Basic stub                          | Theorems/Basic.lean
-- [~] Compactness stub                    | Theorems/Compactness.lean
-- [~] LowenheimSkolem stub                | Theorems/LowenheimSkolem.lean

## Examples — 2 stubs

-- [~] FiniteStructures stub               | Examples/FiniteStructures.lean
-- [~] DenseLinearOrder stub               | Examples/DenseLinearOrder.lean

## Bridges — 6 targets

-- [x] AlgebraicStructure                  | Bridges/ToAlgebra.lean
-- [x] Variety                             | Bridges/ToAlgebra.lean
-- [x] birkhoffHSP                         | Bridges/ToAlgebra.lean
-- [x] groupSignature                      | Bridges/ToAlgebra.lean
-- [x] ringSignature                       | Bridges/ToAlgebra.lean
-- [~] ToTopology stub                     | Bridges/ToTopology.lean
-- [~] ToGeometry stub                     | Bridges/ToGeometry.lean
-- [~] ToComputation stub                  | Bridges/ToComputation.lean

## Summary

Total: 33 targets
Done: 18
Stub: 15
Coverage: 55% (core constructions done, properties/theorems stubbed)
-/

#eval "CoreCoverage: 33 targets, 18 done, 15 stubs"
