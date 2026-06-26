# mini-order-equivalence -- Implementation Coverage

## Core — 4/4 implemented

- [x] `ElementarilyEquivalent` — def, Prop between two Structures
- [x] `theoryOf` — Set of formulas true in a structure
- [x] `ElementarySubstructure` — binary Prop
- [x] `isoImpliesElemEquiv` — isomorphism → elem equiv

## Morphisms — 3/3 implemented

- [x] `ElemEmbedding` — structure with map and elemEquiv evidence
- [x] `isoImpliesElemEquiv` (Iso) — bridges Iso to ElementaryEquivalence
- [x] `elemEquivRefl` / `elemEquivSymm` / `elemEquivTrans`

## Constructions — 0/4, stubs

- [ ] `Submodel` — elementary submodels
- [ ] `Product` — product structures
- [ ] `Quotient` — quotient structures
- [ ] `Expansion` — expansions by definitions

## Properties — 0/3, stubs

- [ ] `Elementary` — elementary properties
- [ ] `Categorical` — categoricity
- [ ] `Homogeneous` — homogeneous structures

## Theorems — 0/4, stubs

- [ ] `Compactness` — compactness theorem
- [ ] `LowenheimSkolem` — Lowenheim-Skolem
- [ ] `Isomorphism` — isomorphism theorems
- [ ] `Completeness` — completeness theorem

## Examples — 0/2, stubs

- [ ] `FiniteStructures` — finite structures
- [ ] `DenseLinearOrder` — dense linear orders

## Bridges — 0/4, stubs

- [ ] `ToLanguage` — bridge to language theory
- [ ] `ToSatisfaction` — bridge to satisfaction
- [ ] `ToCardinal` — bridge to cardinal arithmetic
- [ ] `ToOrder` — bridge to order theory

## Summary

| Category       | Files | Done | Stubs | %      |
|----------------|-------|------|-------|--------|
| Core           | 3     | 3    | 0     | 100%   |
| Morphisms      | 3     | 3    | 0     | 100%   |
| Constructions  | 4     | 0    | 4     | 0%     |
| Properties     | 3     | 0    | 3     | 0%     |
| Theorems       | 4     | 0    | 4     | 0%     |
| Examples       | 2     | 0    | 2     | 0%     |
| Bridges        | 4     | 0    | 4     | 0%     |
| **Total**      | **23**| **6** | **17**| **26%** |
