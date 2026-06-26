# mini-zfc-lite

Zermelo-Fraenkel Set Theory with Choice (ZFC) — Lite Edition.

A standalone mini-package providing the 8 ZFC axioms as `PredFormula` values
and an `AxiomSystem` for use with the Mini Math Kernel framework.

## Axioms

| # | Axiom | Description |
|---|-------|-------------|
| 1 | Extensionality | Sets with the same elements are equal |
| 2 | Empty Set | There exists an empty set |
| 3 | Pairing | For any two sets, there is a set containing both |
| 4 | Union | The union of any set exists |
| 5 | Power Set | The power set of any set exists |
| 6 | Separation | Subsets defined by a property exist |
| 7 | Infinity | There exists an infinite set |
| 8 | Choice | The axiom of choice |

## Usage

```lean
import MiniZFCLite

open MiniZFCLite

#eval zfcAxiomList.length  -- 8
#eval zfcSystem.name       -- "ZFC"
```

## Dependencies

- `mini-logic-kernel` — propositional and predicate logic
- `mini-axiom-kernel` — axiom management
