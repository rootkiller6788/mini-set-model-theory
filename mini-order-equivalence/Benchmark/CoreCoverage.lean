/-
# Benchmark: MiniOrderEquivalence Core Coverage

Tracks every definition/theorem with implementation status.
Format: `-- [x] target | file:line`

Status: [x] done  [~] partial  [ ] planned
-/

/-!
## Core — 4 targets

-- [x] ElementarilyEquivalent                     | Core/Basic.lean
-- [x] theoryOf                                    | Core/Basic.lean
-- [x] ElementarySubstructure                      | Core/Basic.lean
-- [x] isoImpliesElemEquiv                         | Core/Basic.lean

## Morphisms — 3 targets

-- [x] ElemEmbedding (Hom)                         | Morphisms/Hom.lean
-- [~] Iso stubs (Iso)                             | Morphisms/Iso.lean
-- [x] elemEquivRefl / Symm / Trans                | Morphisms/Equivalence.lean

## Constructions — 4 stubs

-- [~] Submodel stub                               | Constructions/Submodel.lean
-- [~] Product stub                                | Constructions/Product.lean
-- [~] Quotient stub                               | Constructions/Quotient.lean
-- [~] Expansion stub                              | Constructions/Expansion.lean

## Properties — 3 stubs

-- [~] Elementary stub                             | Properties/Elementary.lean
-- [~] Categorical stub                            | Properties/Categorical.lean
-- [~] Homogeneous stub                            | Properties/Homogeneous.lean

## Theorems — 4 stubs

-- [~] Compactness stub                            | Theorems/Compactness.lean
-- [~] LowenheimSkolem stub                        | Theorems/LowenheimSkolem.lean
-- [~] Isomorphism stub                            | Theorems/Isomorphism.lean
-- [~] Completeness stub                           | Theorems/Completeness.lean

## Examples — 2 stubs

-- [~] FiniteStructures stub                       | Examples/FiniteStructures.lean
-- [~] DenseLinearOrder stub                       | Examples/DenseLinearOrder.lean

## Bridges — 4 stubs

-- [~] ToLanguage stub                             | Bridges/ToLanguage.lean
-- [~] ToSatisfaction stub                         | Bridges/ToSatisfaction.lean
-- [~] ToCardinal stub                             | Bridges/ToCardinal.lean
-- [~] ToOrder stub                                | Bridges/ToOrder.lean

## Summary

Total: 28 targets
Done: 8 (core + morphisms implemented)
Stub: 20
Coverage: 29% (core done, expansions stubbed)
-/

#eval "CoreCoverage: 28 targets, 8 done, 20 stubs"
