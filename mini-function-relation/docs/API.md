# MiniFunctionRelation API

## Core

- `Structure` — a first-order structure (domain, predicate interpretation, constant interpretation)
- `Structure.card` — cardinality as a string

## Morphisms

- `Hom M N` — homomorphism between structures (preserves predicates and constants)
- `Hom.id` — identity homomorphism
- `Hom.comp` — composition of homomorphisms
- `Embedding M N` — injective homomorphism (extends `Hom`)
- `StrongEmbedding M N` — embedding that also reflects predicates (extends `Embedding`)
- `Iso M N` — isomorphism with inverse (extends `Hom`)
- `Iso.id`, `Iso.comp`, `Iso.symm` — standard isomorphism operations
