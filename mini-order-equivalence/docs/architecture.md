# mini-order-equivalence -- Architecture

## Overview

The order equivalence package defines the notion of elementary equivalence
between first-order structures, proves it is an equivalence relation, and
establishes connections to elementary substructures and the Tarski-Vaught
criterion.

## Dependency Graph

```
mini-order-equivalence
├── mini-function-relation (../)     — Structure type and homomorphisms
└── mini-logic-kernel (../../0. mini-math-kernel/) — PredFormula and satisfaction
```

## Module Map

```
MiniOrderEquivalence/
├── Core/
│   ├── Basic.lean              — ElementarilyEquivalent, theoryOf, ElementarySubstructure
│   ├── Objects.lean            — Object instances (stub)
│   └── Laws.lean               — Structural laws (stub)
├── Morphisms/
│   ├── Hom.lean                — Elementary embeddings (elemEquiv properties)
│   ├── Iso.lean                — Isomorphisms preserve elem. equiv. (stub)
│   └── Equivalence.lean        — Reflexivity, symmetry, transitivity of elem. equiv.
├── Constructions/
│   ├── Submodel.lean           — Elementary submodels (stub)
│   ├── Product.lean            — Products of structures (stub)
│   ├── Quotient.lean           — Quotient structures (stub)
│   └── Expansion.lean          — Expansions by definitions (stub)
├── Properties/
│   ├── Elementary.lean         — Elementary properties (stub)
│   ├── Categorical.lean        — Categoricity (stub)
│   └── Homogeneous.lean        — Homogeneous structures (stub)
├── Theorems/
│   ├── Compactness.lean        — Compactness theorem (stub)
│   ├── LowenheimSkolem.lean    — Lowenheim-Skolem theorems (stub)
│   ├── Isomorphism.lean        — Isomorphism theorems (stub)
│   └── Completeness.lean       — Completeness theorem (stub)
├── Examples/
│   ├── FiniteStructures.lean   — Finite structures (stub)
│   └── DenseLinearOrder.lean   — Dense linear orders (stub)
└── Bridges/
    ├── ToLanguage.lean          — Bridge to language theory (stub)
    ├── ToSatisfaction.lean      — Bridge to satisfaction (stub)
    ├── ToCardinal.lean          — Bridge to cardinal arithmetic (stub)
    └── ToOrder.lean             — Bridge to order theory (stub)
```
