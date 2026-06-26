# MiniLanguageStructure User Guide

## Building a Submodel

```lean
import MiniLanguageStructure

open MiniLanguageStructure

-- Define a structure
def myStruct : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp p args :=
    if p = 0 then args = [0, 1] else False
  constInterp _ := 0

-- Define a substructure (even numbers)
def evenSub : Substructure myStruct where
  carrier n := n % 2 = 0
  closedConst _ := by decide
  closedPred p args h := by
    simp [myStruct] at h
    -- verify args are even
    sorry
```

## Building a Product

```lean
def A : MiniFunctionRelation.Structure := ...
def B : MiniFunctionRelation.Structure := ...

def AxB := productStructure A B
def pi1 := productFst A B
def pi2 := productSnd A B
```

## Building a Quotient

```lean
def cong : Congruence M where
  rel a b := ... -- equivalence condition
  equiv := ...
  predCompat := ...

def Mquot := quotientStructure M cong
def proj := quotientProjection M cong
```

## Testing

Run smoke tests:

```bash
lake env lean --run Test/Smoke.lean
```

Run regression tests:

```bash
lake env lean --run Test/Regression.lean
```
