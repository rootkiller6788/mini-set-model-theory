# mini-satisfaction-model -- Architecture

## Overview

The satisfaction-model package defines the vocabulary and infrastructure for
the satisfaction relation, formula preservation, classification theory, and
standard model-theoretic structures. It builds on MiniFunctionRelation for
structures and homomorphisms, adding the satisfaction component.

## Dependency Graph

```
MiniObjectKernel (kernel)
    └── MiniLogicKernel (kernel)
            └── MiniFunctionRelation (domain)
                    └── MiniCardinalOrdinal (domain)
                            └── MiniSatisfactionModel (this package)
```

## Module Map

```
MiniSatisfactionModel/
├── Core/
│   ├── Basic.lean          -- Core imports, dependency aggregation
│   ├── Objects.lean        -- Object instances for Structure
│   └── Laws.lean           -- Satisfaction relation, Theory, Tarski laws
├── Morphisms/
│   ├── Hom.lean            -- Embedding, StrongEmbedding, ElementaryEmbedding
│   ├── Iso.lean            -- Isomorphism (id, comp)
│   └── Equivalence.lean    -- Elementary equivalence, elementary substructures
├── Constructions/
│   ├── Submodel.lean       -- Submodels, Tarski-Vaught criterion
│   ├── Product.lean        -- Direct products, Feferman-Vaught
│   ├── Ultraproduct.lean   -- Ultraproducts, Los's theorem
│   └── Reduct.lean         -- Reducts, expansions, Morleyisation
├── Properties/
│   ├── Preservation.lean   -- Existential/universal formula preservation
│   ├── Classification.lean -- ClassifiedTheory, DLO, ACF0
│   └── ClassificationData.lean -- Spectrum function
├── Theorems/
│   ├── Basic.lean          -- Compactness, completeness, LS theorems
│   ├── UniversalProperties.lean -- Universal property theorems
│   ├── Classification.lean -- Morley, Baldwin-Lachlan, stability hierarchy
│   └── Main.lean           -- Shelah Main Gap, classification program
├── Examples/
│   ├── Standard.lean       -- N, Z, Q (DLO), C (ACF0)
│   └── Counterexamples.lean -- Finite structures, Vaught, incomplete theories
└── Bridges/
    ├── ToAlgebra.lean      -- Birkhoff HSP, variety, group/ring signatures
    ├── ToTopology.lean     -- Stone spaces, Ryll-Nardzewski
    ├── ToGeometry.lean     -- Nullstellensatz, Morley rank = Krull dimension
    └── ToComputation.lean  -- Decidability, computable structures
```

## Design Principles

1. **Vocabulary-driven.** Major theorems are stated as axioms or string descriptions --
   this package defines what satisfaction models *are*, not how to prove everything.
2. **Kernel integration.** Every type integrates with ObjectKernel for theory registration.
3. **Classical logic.** Model theory requires excluded middle for key results (compactness).
4. **Bridges to other domains.** Explicit connection modules show how model theory interfaces with
   algebra (Birkhoff HSP), topology (Stone spaces), geometry (Nullstellensatz), and computation.
