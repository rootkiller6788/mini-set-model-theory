# MiniSetCore

The set theory sub-package of mini-everything-math.

Defines `Set α := α → Prop`, finite sets (`FinSet`), set operations,
and bridges to algebra, topology, geometry, and computation.

## Structure

- `Core/` -- Set type, membership, FinSet, Object instance, Laws
- `Morphisms/` -- SetFunction, SetIso, CardinalEquivalence
- `Constructions/` -- Cartesian product, Subobjects, Quotients, Universal
- `Properties/` -- Invariants, Preservation, ClassificationData
- `Theorems/` -- Basic, UniversalProperties, Classification, Main
- `Examples/` -- Standard, Counterexamples
- `Bridges/` -- ToAlgebra, ToTopology, ToGeometry, ToComputation

## Dependencies

- `mini-object-kernel` -- Object typeclass interface

## Usage

```bash
lake build
lake env lean --run Main.lean
```
