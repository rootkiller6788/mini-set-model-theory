# mini-order-equivalence -- Dependencies

## Immediate Dependencies

| Package | Path | Used For |
|---------|------|----------|
| `mini-function-relation` | `../mini-function-relation` | `Structure` type, `Hom`, `Iso` |
| `mini-logic-kernel` | `../../0. mini-math-kernel/mini-logic-kernel` | `PredFormula`, `Formula` |

## Dependency Graph (partial ecosystem)

```
mini-order-equivalence
├── mini-function-relation
│   ├── mini-object-kernel
│   └── mini-formula-kernel  (if applicable)
└── mini-logic-kernel
    └── (self-contained, no deps)
```

## Internal Dependencies

```
Core.Basic
├── Morphisms.Hom        (ElemEmbedding uses Structure, ElementarilyEquivalent)
├── Morphisms.Iso        (isoImpliesElemEquiv uses Iso from MFR)
├── Morphisms.Equivalence (elemEquivRefl/Symm/Trans)
├── Constructions.*      (all stubs import Core.Basic)
├── Properties.*         (all stubs import Core.Basic)
├── Theorems.*           (all stubs import Core.Basic)
├── Examples.*           (all stubs import Core.Basic)
└── Bridges.*            (all stubs import Core.Basic)
```

## Cross-Package Bridges

- `Bridges/ToLanguage` — connects to formal language theory
- `Bridges/ToSatisfaction` — connects to satisfaction relation
- `Bridges/ToCardinal` — connects to cardinal arithmetic
- `Bridges/ToOrder` — connects to order theory
