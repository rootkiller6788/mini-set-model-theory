# mini-satisfaction-model -- Dependency Graph

## Internal Dependencies

```
Core/Basic.lean       (imports from external packages)
Core/Objects.lean     → Core/Basic + MiniObjectKernel
Core/Laws.lean        → Core/Basic

Morphisms/Hom.lean    → Core/Basic
Morphisms/Iso.lean    → Morphisms/Hom
Morphisms/Equivalence → Morphisms/Iso

Constructions/Submodel     → Morphisms/Hom
Constructions/Product      → Core/Basic
Constructions/Ultraproduct → Core/Basic
Constructions/Reduct       → Core/Basic

Properties/Preservation      → Core/Basic
Properties/Classification    → Core/Basic
Properties/ClassificationData → Properties/Classification

Theorems/Basic               → Core/Laws
Theorems/UniversalProperties → Core/Basic
Theorems/Classification      → Properties/Classification
Theorems/Main                → Theorems/Classification

Examples/Standard       → Core/Basic
Examples/Counterexamples → Core/Basic

Bridges/ToAlgebra       → Core/Basic
Bridges/ToTopology      → Core/Basic
Bridges/ToGeometry      → Properties/Classification
Bridges/ToComputation   → Core/Basic
```

## External Dependencies

- `mini-function-relation` -- Structure type and Hom definitions
- `mini-cardinal-ordinal` -- StabilityClass, Theory, cardinal types
- `mini-logic-kernel` -- PredFormula with quantifiers (ex, all)
- `mini-object-kernel` -- Object typeclass for theory registration
