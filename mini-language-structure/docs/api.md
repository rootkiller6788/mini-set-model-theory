# MiniLanguageStructure API Reference

## Core Types (via MiniFunctionRelation)

- `MiniFunctionRelation.Structure` — first-order structure (domain, predicates, constants)
- `MiniFunctionRelation.Hom` — homomorphism between structures

## Constructions

### Substructure

```lean
structure Substructure (M : MiniFunctionRelation.Structure) where
  carrier : Set M.domain
  closedConst : ∀ (c : Nat), carrier (M.constInterp c)
  closedPred : ∀ (p : Nat) (args : List M.domain), M.predInterp p args → args.all carrier
```

- `Substructure.toStructure` — convert to a `Structure` (subtype domain)
- `Substructure.inclusion` — inclusion homomorphism into the parent structure
- `TarskiVaughtCriterion` — the Tarski-Vaught test for elementary substructures

### Congruence

```lean
structure Congruence (M : MiniFunctionRelation.Structure) where
  rel : M.domain → M.domain → Prop
  equiv : Equivalence rel
  predCompat : ∀ (p : Nat) (args1 args2 : List M.domain),
    args1.zip args2 |>.all (fun (a,b) => rel a b) →
    (M.predInterp p args1 ↔ M.predInterp p args2)
```

- `quotientStructure` — structure on the quotient
- `quotientProjection` — natural projection homomorphism

### Products

- `productStructure M N` — Cartesian product of two structures
- `productFst M N` — projection onto first factor
- `productSnd M N` — projection onto second factor
- `productUniversal M N P f g` — universal mediating map

### Universal Constructions

- `InitialStructure` — empty domain, all predicates false
- `TerminalStructure` — unit domain, all predicates true
- `forgetfulFunctor M` — returns the domain type of M

## Algebraic Bridge

- `AlgebraicStructure` — carrier type, operations, name
- `Variety` — signature and equations
- `birkhoffHSP` — Birkhoff's HSP theorem statement
- `groupSignature := [2, 1, 0]`
- `ringSignature := [2, 2, 1, 0, 0]`
