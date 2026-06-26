/-
# MiniOrderEquivalence

Elementary equivalence of first-order structures: definition, equivalence
relation properties, substructures, and structural invariants.

## Sub-packages
- `Core`         — ElementaryEquivalence, theoryOf, ElementarySubstructure
- `Morphisms`    — Hom, Iso, Equivalence (elemEquiv reflexivity/symmetry/transitivity)
- `Constructions` — Submodel, Product, Quotient, Expansion
- `Properties`   — Elementary, Categorical, Homogeneous
- `Theorems`     — Compactness, LowenheimSkolem, Isomorphism, Completeness
- `Examples`     — FiniteStructures, DenseLinearOrder
- `Bridges`      — ToLanguage, ToSatisfaction, ToCardinal, ToOrder
-/

import MiniOrderEquivalence.Core.Basic
import MiniOrderEquivalence.Core.Objects
import MiniOrderEquivalence.Core.Laws
import MiniOrderEquivalence.Morphisms.Hom
import MiniOrderEquivalence.Morphisms.Iso
import MiniOrderEquivalence.Morphisms.Equivalence
import MiniOrderEquivalence.Constructions.Submodel
import MiniOrderEquivalence.Constructions.Product
import MiniOrderEquivalence.Constructions.Quotient
import MiniOrderEquivalence.Constructions.Expansion
import MiniOrderEquivalence.Properties.Elementary
import MiniOrderEquivalence.Properties.Categorical
import MiniOrderEquivalence.Properties.Homogeneous
import MiniOrderEquivalence.Theorems.Compactness
import MiniOrderEquivalence.Theorems.LowenheimSkolem
import MiniOrderEquivalence.Theorems.Isomorphism
import MiniOrderEquivalence.Theorems.Completeness
import MiniOrderEquivalence.Examples.FiniteStructures
import MiniOrderEquivalence.Examples.DenseLinearOrder
import MiniOrderEquivalence.Bridges.ToLanguage
import MiniOrderEquivalence.Bridges.ToSatisfaction
import MiniOrderEquivalence.Bridges.ToCardinal
import MiniOrderEquivalence.Bridges.ToOrder
