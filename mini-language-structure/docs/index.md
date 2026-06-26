# MiniLanguageStructure Documentation

Structural operations on first-order structures: substructures, products,
quotients, and universal constructions.

## Overview

`MiniLanguageStructure` builds on `MiniFunctionRelation` to provide the
structural toolkit for first-order model theory. It adds:

- **Substructures** — submodels with inherited relations and constants
- **Congruences** — equivalence relations compatible with predicates
- **Quotient structures** — structures modulo a congruence
- **Products** — Cartesian product of structures with component-wise interpretation
- **Universal constructions** — initial and terminal structures, forgetful functor
- **Algebraic bridges** — varieties, signatures, and Birkhoff's HSP theorem

## Module Structure

| Directory       | Purpose                                              |
|-----------------|------------------------------------------------------|
| `Core/`         | Basic definitions, objects, and structural laws      |
| `Morphisms/`    | Homomorphisms, isomorphisms, elementary equivalence  |
| `Constructions/`| Subobjects, quotients, products, universal objects   |
| `Properties/`   | Invariants, preservation, elementary properties      |
| `Theorems/`     | Universal properties, compactness, Lowenheim-Skolem  |
| `Examples/`     | Finite structures, dense linear orders               |
| `Bridges/`      | Connections to algebra, topology, geometry, computation|

## Quick Start

```lean
import MiniLanguageStructure

open MiniLanguageStructure
```
