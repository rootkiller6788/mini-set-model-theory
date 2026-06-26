# MiniFunctionRelation User Guide

## Overview

MiniFunctionRelation provides the `Structure` type and associated morphisms
for first-order model theory. It is part of the mini-everything-math ecosystem.

## Quick Start

```lean
import MiniFunctionRelation

open MiniFunctionRelation

-- Define a structure
def MyStruct : Structure where
  domain := Nat
  predInterp p args := ...
  constInterp c := ...

-- Create a homomorphism
def f : Hom MyStruct MyStruct := Hom.id MyStruct
```
