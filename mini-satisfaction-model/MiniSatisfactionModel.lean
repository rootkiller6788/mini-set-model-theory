/-
# MiniSatisfactionModel

The satisfaction model sub-package -- satisfaction relation, formula preservation,
classification theory, and standard model-theoretic structures.

## Sub-packages
- `Core`          -- Basic definitions, Object registration, Laws
- `Morphisms`     -- Embedding, Iso, ElementarilyEquivalent
- `Constructions` -- Submodel, Product, Ultraproduct, Reduct
- `Properties`    -- Preservation, Classification, ClassificationData
- `Theorems`      -- Basic, UniversalProperties, Classification, Main
- `Examples`      -- Standard, Counterexamples
- `Bridges`       -- ToAlgebra, ToTopology, ToGeometry, ToComputation
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Objects
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom
import MiniSatisfactionModel.Morphisms.Iso
import MiniSatisfactionModel.Morphisms.Equivalence
import MiniSatisfactionModel.Constructions.Submodel
import MiniSatisfactionModel.Constructions.Product
import MiniSatisfactionModel.Constructions.Ultraproduct
import MiniSatisfactionModel.Constructions.Reduct
import MiniSatisfactionModel.Properties.Preservation
import MiniSatisfactionModel.Properties.Classification
import MiniSatisfactionModel.Properties.ClassificationData
import MiniSatisfactionModel.Theorems.Basic
import MiniSatisfactionModel.Theorems.UniversalProperties
import MiniSatisfactionModel.Theorems.Classification
import MiniSatisfactionModel.Theorems.Main
import MiniSatisfactionModel.Examples.Standard
import MiniSatisfactionModel.Examples.Counterexamples
import MiniSatisfactionModel.Bridges.ToAlgebra
import MiniSatisfactionModel.Bridges.ToTopology
import MiniSatisfactionModel.Bridges.ToGeometry
import MiniSatisfactionModel.Bridges.ToComputation
