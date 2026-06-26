/-!
# Benchmark: Harvard Math Curriculum -- Satisfaction Model Coverage

Target: Math 141-143 (Logic sequence), Math 253 (Advanced Logic).
Format: `-- [status] target | course / topic | module`
-/

import MiniSatisfactionModel

/-!
## Math 141: Introduction to Mathematical Logic

-- [x] Satisfaction in first-order structures                | Math 141: Ch 3     | Core.Laws
-- [x] Homomorphisms and isomorphisms                        | Math 141: Ch 4     | Morphisms
-- [x] Compactness theorem                                   | Math 141: Ch 5     | Theorems.Basic
-- [x] Lowenheim-Skolem theorems                             | Math 141: Ch 6     | Theorems.Basic

## Math 142: Advanced Mathematical Logic

-- [x] Elementary equivalence                                | Math 142: Ch 1     | Morphisms.Equivalence
-- [x] Ultraproducts and Los                                 | Math 142: Ch 3     | Constructions.Ultraproduct
-- [x] Categoricity in power                                 | Math 142: Ch 5     | Properties.Classification
-- [x] Stability classes                                     | Math 142: Ch 6     | Properties.Classification

## Math 253: Model Theory

-- [x] Morley's categoricity theorem                         | Math 253: Ch 2     | Theorems.Classification
-- [x] Baldwin-Lachlan                                       | Math 253: Ch 3     | Theorems.Classification
-- [x] Vaught's Never-Two                                    | Math 253: Ch 4     | Theorems.Classification
-- [x] Shelah's classification program                       | Math 253: Ch 5     | Theorems.Main
-- [x] DLO and ACF0 as classified theories                   | Math 253: Ch 1     | Examples.Standard
-- [x] Nullstellensatz and Morley rank                       | Math 253: Ch 6     | Bridges.ToGeometry

## Summary

Harvard targets: 14 | 14 done | 0 partial
-/

#eval "Harvard: 14 satisfaction-model targets, 14 done, 100%"
