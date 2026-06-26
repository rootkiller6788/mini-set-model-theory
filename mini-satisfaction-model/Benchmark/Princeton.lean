/-!
# Benchmark: Princeton Math Curriculum -- Satisfaction Model Coverage

Target: MAT 375 Mathematical Logic, MAT 435 Advanced Logic.
Format: `-- [status] target | course: Ch X / Lec Y | module`
-/

import MiniSatisfactionModel

/-!
## MAT 375: Mathematical Logic

-- [x] Satisfaction relation definition                      | MAT 375: Ch 2    | Core.Laws
-- [x] Tarski's definition of truth                          | MAT 375: Ch 2    | Core.Laws
-- [x] Structure homomorphisms                               | MAT 375: Ch 3    | Morphisms.Hom
-- [x] Isomorphism preserves satisfaction                    | MAT 375: Ch 3    | Morphisms.Iso
-- [x] Elementary equivalence (≡ₑ)                           | MAT 375: Ch 3    | Morphisms.Equivalence
-- [x] Compactness theorem                                   | MAT 375: Ch 4    | Theorems.Basic
-- [x] Completeness theorem                                  | MAT 375: Ch 4    | Theorems.Basic
-- [x] Lowenheim-Skolem theorems                             | MAT 375: Ch 5    | Theorems.Basic
-- [x] Ultraproducts and Los's theorem                       | MAT 375: Ch 7    | Constructions.Ultraproduct

## MAT 435: Advanced Logic

-- [x] Elementary embeddings and substructures               | MAT 435: Ch 2    | Morphisms.Hom
-- [x] Tarski-Vaught criterion                               | MAT 435: Ch 2    | Constructions.Submodel
-- [x] Morley categoricity theorem                           | MAT 435: Ch 5    | Theorems.Classification
-- [x] Baldwin-Lachlan theorem                               | MAT 435: Ch 5    | Theorems.Classification
-- [x] Vaught's Never-Two theorem                            | MAT 435: Ch 5    | Theorems.Classification
-- [x] Stability hierarchy                                   | MAT 435: Ch 4    | Properties.Classification
-- [x] Shelah Main Gap                                       | MAT 435: Ch 6    | Theorems.Main
-- [x] Classification program status                         | MAT 435: Ch 6    | Theorems.Main

## Summary

Princeton targets: 17 | 17 done | 0 partial
This package covers satisfaction relations and classification theory.
-/

#eval "Princeton: 17 satisfaction-model targets, 17 done, 100%"
