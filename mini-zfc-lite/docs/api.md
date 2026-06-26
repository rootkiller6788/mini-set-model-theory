# API Reference — MiniZFCLite

## Core.Basic

### `memPred`

```lean
def memPred (x y : Nat) : PredFormula
```
The membership predicate `x ∈ y`, encoded as `pred 0 [x, y]`.

### ZFC Axioms

Each axiom is defined as a `PredFormula`:

| Function | Axiom |
|----------|-------|
| `zfcExtensionality` | `∀x∀y(∀z(z∈x ↔ z∈y) → x=y)` |
| `zfcEmptySet` | `∃x∀y(¬(y∈x))` |
| `zfcPairing` | `∀x∀y∃z∀w(w∈z ↔ w=x ∨ w=y)` |
| `zfcUnion` | `∀x∃y∀z(z∈y ↔ ∃w(z∈w ∧ w∈x))` |
| `zfcPowerSet` | `∀x∃y∀z(z∈y ↔ ∀w(w∈z → w∈x))` |
| `zfcSeparation` | `∀x∃y∀z(z∈y ↔ z∈x ∧ φ(z))` |
| `zfcInfinity` | `∃x(∅∈x ∧ ∀y(y∈x → y∪{y}∈x))` |
| `zfcChoice` | `∀x(∀y(y∈x → y≠∅) → ∃f(Function(f) ∧ dom(f)=x ∧ ∀z(z∈x → f(z)∈z)))` |

### `zfcAxiomList`

```lean
def zfcAxiomList : List (String × PredFormula)
```
Named list of all 8 ZFC axioms.

## Core.Objects

### `zfcPropAxioms`

```lean
def zfcPropAxioms : List MiniAxiomKernel.Axiom
```
Maps each ZFC axiom to a `MiniAxiomKernel.Axiom`.

### `zfcAxiomSet`

```lean
def zfcAxiomSet : MiniAxiomKernel.AxiomSet
```
Collection of all 8 ZFC axioms.

### `zfcSystem`

```lean
def zfcSystem : MiniAxiomKernel.AxiomSystem
```
The ZFC axiom system with name, version, and description.

## Core.Laws

Stub — placeholder for ZFC-specific laws and properties.
