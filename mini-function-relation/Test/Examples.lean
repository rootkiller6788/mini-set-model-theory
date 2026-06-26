import MiniFunctionRelation

open MiniFunctionRelation

namespace MiniFunctionRelation.Test

/-
# Example Tests

Tests that run the examples provided in the Examples directory.
-/

-- Test graph structure construction
def TestGraph : Structure := GraphStruct Nat 0 (λ x y => x < y)

-- Test complete graph
def K3 : Structure := CompleteGraph 3

-- Test linear order
def L5 : Structure := LinOrderStruct 5

-- Test two-element structure
def T2 : Structure := TwoElementStruct

-- Verify hom constructions
def graphIdHom : Hom TestGraph TestGraph := Hom.id TestGraph

def K3toK3Hom : Hom K3 K3 := Hom.id K3

-- Verify isomorphism constructions
def swapIso' : Iso T2 T2 := SwapIso

-- Verifying that composition works
def doubleSwap : Hom T2 T2 := Hom.comp swapIso'.toHom swapIso'.toHom

-- Verifying inverse
def symmSwap : Iso T2 T2 := Iso.symm swapIso'

-- Test the DLO example
def RatDLO_test : Structure := RatDLO

-- eval examples
#eval (Hom.id TestGraph).map 42
#eval (K3.predInterp 0 [0,1]) -- should be true (different vertices)
#eval (K3.predInterp 0 [0,0]) -- should be false (same vertex)
#eval (L5.predInterp 0 [2, 4])
#eval (swapIso'.toHom.map true)
#eval (symmSwap.toHom.map true)

end MiniFunctionRelation.Test
