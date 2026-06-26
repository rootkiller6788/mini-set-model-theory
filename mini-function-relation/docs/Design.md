# MiniFunctionRelation Design Notes

## Architecture

- **Core/Basic.lean** — `Structure` type definition
- **Core/Objects.lean** — bridges to MiniObjectKernel
- **Core/Laws.lean** — structural laws (identity, associativity)
- **Morphisms/** — `Hom`, `Embedding`, `StrongEmbedding`, `Iso`, `Equivalence`
- **Constructions/** — `Submodel`, `Product`, `Quotient`, `Expansion`
- **Properties/** — `Elementary`, `Categorical`, `Homogeneous`
- **Theorems/** — `Compactness`, `LowenheimSkolem`, `Isomorphism`, `Completeness`
- **Bridges/** — connections to other mini-packages

## Design Principles

- Representation-independent: `Structure.domain` is an arbitrary `Type`
- Morphisms form a category with `Hom.id` and `Hom.comp`
- `Iso` provides a groupoid structure with `symm`
