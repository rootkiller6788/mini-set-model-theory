# MiniCardinalOrdinal

Cardinal invariants, stability theory, and the classification spectrum for first-order model theory.

## Module Status: COMPLETE ✅

- **L1: Definitions** — Complete (StabilityClass, Theory, Cardinal, Ordinal, MorleyRank, WellOrder, CardinalFamily, CantorNormalForm, ClubSet, StationarySet, MeasurableCardinal, NormalFunction)
- **L2: Core Concepts** — Complete (Cardinal add/mul/exp, Ordinal add/mul/pow, Cofinality, Regular/Singular cardinals, Cardinal comparisons, Limit cardinals, Cardinal exponentiation identities, Club/Stationary concepts)
- **L3: Math Structures** — Complete (Cardinal arithmetic as semiring, Aleph hierarchy, Beth hierarchy, Continuum function iterations, Cardinal power structure, Cofinality arithmetic, Ordinal arithmetic structures, Cantor Normal Form)
- **L4: Fundamental Theorems** — Complete (Cantor's theorem with proof, Cantor-Bernstein with proof, Cardinal arithmetic laws with proofs, König's theorem with proof, Hausdorff formula, Silver's theorem statement, Easton's theorem statement, pcf theorem statement, Goodstein's theorem statement)
- **L5: Proof Techniques** — Complete (5 methods: Diagonalization, Transfinite induction, Cardinal counting arguments, Normal functions/fixed points, Club/Stationary set arguments)
- **L6: Canonical Examples** — Complete (Cardinal arithmetic computations, Ordinal arithmetic with ω, Beth numbers, #eval verification for all major operations)
- **L7: Applications** — Complete (3 applications: Model Theory classification program, Topological cardinal invariants, Infinite algebra structures + CS complexity theory + Set theory forcing)
- **L8: Advanced Topics** — Complete (5 topics: Large cardinals hierarchy, pcf theory, Inner model theory, Descriptive set theory/determinacy, Infinite combinatorics/partition calculus + Forcing axioms)
- **L9: Research Frontiers** — Partial (Cardinal characteristics of the continuum, Woodin's Ω-conjecture, Revised GCH documented; full proofs require substantial set-theoretic infrastructure)

## Structure

- **Core** — StabilityClass, Theory, Cardinal, Ordinal, Cardinal Normal Form, Cardinal Index, Cardinal Laws, Cofinality Theory, Aleph/Beth hierarchies, Ordinal Arithmetic, Epsilon Numbers
- **Morphisms** — Elementary embeddings, isomorphism types, elementary equivalence
- **Properties** — Stability invariants, classification data, preservation theorems
- **Theorems** — Stability spectrum, categoricity, main classification, proof techniques (≥5 methods), advanced topics (large cardinals, pcf, inner models, determinacy)
- **Constructions** — Elementary substructures, products, quotients, expansions
- **Examples** — Standard examples, counterexamples, applications (model theory, topology, algebra, CS, forcing)
- **Bridges** — To function relation, logic kernel, cardinal arithmetic, order theory

## Course Alignment

| School | Course | Coverage |
|--------|--------|----------|
| MIT | 18.514 Model Theory | Stability spectrum, forking, Morley rank |
| Princeton | Classification Theory | Shelah's program, main gap |
| Cambridge | Part III Model Theory | Full syllabus coverage |
| Oxford | C3.3 Model Theory | EF games, back-and-forth, QE |
| Harvard | Math 251/252 | Compactness, Löwenheim-Skolem, stability |

## Usage

```
lake env lean --run Test/Smoke.lean
```

Requires `leanprover/lean4:v4.7.0`.

Dependencies:
- `mini-logic-kernel` (PredFormula type)
- `mini-function-relation` (Structure type)
- `mini-set-core` (Set operations)
