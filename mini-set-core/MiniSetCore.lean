/-
# MiniSetCore

The set theory sub-package — defines `Set α := α → Prop`,
finite sets, set operations, and bridges to other theories.

## Sub-packages
- `Core`         — Set type, membership, FinSet, Object instance, Laws
- `Morphisms`    — SetFunction, SetIso, CardinalEquivalence
- `Constructions` — Cartesian product, Subobjects, Quotients, Universal
- `Properties`   — Invariants, Preservation, ClassificationData
- `Theorems`     — Basic, UniversalProperties, Classification, Main
- `Examples`     — Standard, Counterexamples
- `Bridges`      — ToAlgebra, ToTopology, ToGeometry, ToComputation
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws
import MiniSetCore.Morphisms.Hom
import MiniSetCore.Morphisms.Iso
import MiniSetCore.Morphisms.Equivalence
import MiniSetCore.Constructions.Products
import MiniSetCore.Constructions.Universal
import MiniSetCore.Constructions.Subobjects
import MiniSetCore.Constructions.Quotients
import MiniSetCore.Properties.Invariants
import MiniSetCore.Properties.Preservation
import MiniSetCore.Properties.ClassificationData
import MiniSetCore.Theorems.Basic
import MiniSetCore.Theorems.UniversalProperties
import MiniSetCore.Theorems.Classification
import MiniSetCore.Theorems.Main
import MiniSetCore.Examples.Standard
import MiniSetCore.Examples.Counterexamples
import MiniSetCore.Bridges.ToAlgebra
import MiniSetCore.Bridges.ToTopology
import MiniSetCore.Bridges.ToGeometry
import MiniSetCore.Bridges.ToComputation
