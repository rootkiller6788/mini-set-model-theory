/-
# MiniZFCLite — ZFC Set Theory Lite

Root aggregator importing all modules of the mini-zfc-lite package.

## Sub-packages
- `Core`         — ZFC axioms as PredFormula, axiom set, axiom system
- `Morphisms`    — Functorial, Natural, Adjoint
- `Constructions` — Product, Coproduct, Limit, Colimit
- `Properties`   — Universal, Structural, Computational
- `Theorems`     — Fundamental, Structural, Classification, Representation
- `Examples`     — Standard, Counterexamples
- `Bridges`      — ToLogic, ToAlgebra, ToGeometry, ToTopology
-/

import MiniZFCLite.Core.Basic
import MiniZFCLite.Core.Objects
import MiniZFCLite.Core.Laws

import MiniZFCLite.Morphisms.Functorial.Basic
import MiniZFCLite.Morphisms.Natural.Basic
import MiniZFCLite.Morphisms.Adjoint.Basic

import MiniZFCLite.Constructions.Product.Basic
import MiniZFCLite.Constructions.Coproduct.Basic
import MiniZFCLite.Constructions.Limit.Basic
import MiniZFCLite.Constructions.Colimit.Basic

import MiniZFCLite.Properties.Universal.Basic
import MiniZFCLite.Properties.Structural.Basic
import MiniZFCLite.Properties.Computational.Basic

import MiniZFCLite.Theorems.Fundamental.Basic
import MiniZFCLite.Theorems.Structural.Basic
import MiniZFCLite.Theorems.Classification.Basic
import MiniZFCLite.Theorems.Representation.Basic

import MiniZFCLite.Examples.Standard.Basic
import MiniZFCLite.Examples.Counterexamples.Basic

import MiniZFCLite.Bridges.ToLogic.Basic
import MiniZFCLite.Bridges.ToAlgebra.Basic
import MiniZFCLite.Bridges.ToGeometry.Basic
import MiniZFCLite.Bridges.ToTopology.Basic
