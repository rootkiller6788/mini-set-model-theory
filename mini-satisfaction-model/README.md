# mini-satisfaction-model

Satisfaction relation, formula preservation, classification theory,
and standard model-theoretic examples.

## Quick Start

```bash
cd "1. mini-set-model-theory/mini-satisfaction-model"

# Run the smoke tests
lake env lean --run Test/Smoke.lean

# Run step-by-step examples
lake env lean --run Test/Examples.lean

# Run regression checks
lake env lean --run Test/Regression.lean
```

## What it provides

| Module | Purpose | Files | #eval Tests |
|--------|---------|-------|-------------|
| **Core** | Satisfaction relation, Object registration, Tarski laws | 3 | -- |
| **Morphisms** | Embeddings, isomorphisms, elementary equivalence | 3 | -- |
| **Constructions** | Submodels, products, ultraproducts, reducts | 4 | -- |
| **Properties** | Preservation theorems, classification data | 3 | -- |
| **Theorems** | Compactness, LS, Morley, Shelah Main Gap | 4 | -- |
| **Examples** | Standard structures (N,Z,Q,C), counterexamples | 2 | -- |
| **Bridges** | To algebra, topology, geometry, computation | 4 | -- |

## Design principles

1. **Vocabulary-driven.** Major theorems are stated as axioms or string descriptions -- this
   package defines what satisfaction models *are*, not how to prove everything.
2. **Model-theoretic focus.** Builds on MiniFunctionRelation for structures and homomorphisms,
   adds satisfaction relation and classification theory.
3. **Bridges to other domains.** Explicit modules show how model theory connects to
   algebra (Birkhoff HSP), topology (Stone spaces), geometry (Nullstellensatz), and computation.
4. **Classical logic.** Model theory requires excluded middle for key results (compactness).

## Dependencies

- `mini-function-relation` -- Structure and homomorphism types
- `mini-cardinal-ordinal` -- Stability classes and cardinal invariants
- `mini-logic-kernel` -- Predicate formulas and quantifiers
- `mini-object-kernel` -- Object typeclass registration
