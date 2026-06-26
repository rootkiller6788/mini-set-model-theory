# MiniCardinalOrdinal Dependency Map

## External Dependencies

```
MiniCardinalOrdinal
  ├── MiniFunctionRelation.Core.Basic   (Structure type)
  └── MiniLogicKernel                   (PredFormula, Formula types)
```

## Internal Dependency Graph

```
Core.Basic ──────────────────────────────────────────────────────────────┐
  ├── imported by: Core.Objects, Core.Laws, Properties.*, Theorems.*,    │
  │                Examples.*, Bridges.*, Constructions.*, Morphisms.*   │
  └── imports: MiniFunctionRelation.Core.Basic                            │
                                                                          │
Core.Objects ─────────────────────────────────────────────────────────────┤
  ├── imported by: Core.Laws, Properties.Invariants, Theorems.*,         │
  │                Examples.*, Bridges.*                                 │
  └── imports: Core.Basic                                                │
                                                                          │
Core.Laws ────────────────────────────────────────────────────────────────┤
  ├── imported by: Bridges.ToCardinalArithmetic                          │
  └── imports: Core.Objects                                              │
                                                                          │
Morphisms/    imports: Core.Basic                                        │
Properties/   imports: Core.Basic, Core.Objects                          │
Constructions/ imports: Core.Basic, Core.Objects, Morphisms.Hom          │
Theorems/     imports: Core.*, Properties.*, Morphisms.*                 │
Examples/     imports: Core.*, Properties.*                              │
Bridges/      imports: Core.*, Properties.*, Morphisms.*, Core.Laws      │
```

## Build Order

1. Core.Basic (no internal deps)
2. Core.Objects (depends on Core.Basic)
3. Core.Laws (depends on Core.Objects)
4. Morphisms.* (depend on Core.Basic)
5. Properties.* (depend on Core.*, some on Morphisms.*)
6. Constructions.* (depend on Core.*, Morphisms.*)
7. Theorems.* (depend on most above)
8. Examples.* (depend on Core.*, Properties.*)
9. Bridges.* (depend on Core.*, Properties.*, Morphisms.*)
10. MiniCardinalOrdinal.lean (imports all above)
