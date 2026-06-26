# Mini Set & Model Theory

A collection of **from-scratch, zero-dependency Lean 4 implementations** of university-level set theory, model theory, and mathematical logic. Each sub-package maps to MIT (and other top-tier university) courses, building the foundations of formal set and model theory from first principles using the Lean 4 proof assistant.

## Sub-Packages

| Sub-Package | Topics | Key Courses |
|-------------|--------|-------------|
| [mini-set-core](mini-set-core/) | Set theory, membership, operations, finite sets | MIT 18.510, Princeton MAT 560 |
| [mini-function-relation](mini-function-relation/) | Structures, homomorphisms, embeddings | MIT 18.515, Berkeley Math 225B |
| [mini-language-structure](mini-language-structure/) | Formal languages, signatures, structures | MIT 18.510, Stanford Math 160 |
| [mini-satisfaction-model](mini-satisfaction-model/) | Tarski semantics, satisfaction, elementary equivalence | MIT 18.515, Berkeley Math 229A |
| [mini-zfc-lite](mini-zfc-lite/) | ZFC axioms, ordinal/cardinal construction | MIT 18.510, Princeton MAT 560 |
| [mini-compactness-completeness-lite](mini-compactness-completeness-lite/) | Compactness theorem, completeness theorem, ultraproducts | MIT 18.515, Oxford Part C |
| [mini-order-equivalence](mini-order-equivalence/) | Partial orders, equivalence relations, order types | MIT 18.510, Cambridge Part III |
| [mini-cardinal-ordinal](mini-cardinal-ordinal/) | Cardinal arithmetic, ordinal arithmetic, transfinite induction | MIT 18.510, Berkeley Math 225A |

## Design Philosophy

- **Zero external dependencies** -- pure Lean 4, only kernel imports
- **Self-contained sub-packages** -- each has its own `lakefile.lean`, Core/, Morphisms/, Constructions/, Properties/, Theorems/
- **Theory-to-code mapping** -- every module includes inline `#eval` examples and theorem statements
- **Classical logic foundation** -- uses the kernel's classical natural deduction; key results (compactness) require excluded middle

## Building

Each sub-package is standalone. Build with Lake:

```bash
cd mini-set-core
lake build
lake env lean --run Test/Smoke.lean
```

Requires **Lean 4** and **Lake**.

## Project Structure

```
1. mini-set-model-theory/
├── mini-set-core/                       # Set theory, membership, finite sets
├── mini-function-relation/              # Homomorphisms, embeddings
├── mini-language-structure/             # Formal languages, signatures, structures
├── mini-satisfaction-model/             # Tarski semantics, elementary equivalence
├── mini-zfc-lite/                       # ZFC axioms, ordinal/cardinal construction
├── mini-compactness-completeness-lite/  # Compactness, completeness, ultraproducts
├── mini-order-equivalence/              # Partial orders, equivalence relations
├── mini-cardinal-ordinal/               # Cardinal/ordinal arithmetic, transfinite induction
└── lakefile.lean
```

## License

MIT
