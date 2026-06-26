import MiniFunctionRelation

namespace MiniFunctionRelation.Bench

/-
# Benchmark: Structure Creation

Measures the speed of constructing structures of various sizes
and complexities.
-/

def mkStruct1 : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def mkStructN (n : Nat) : Structure where
  domain := Fin n
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def mkStructComplex : Structure where
  domain := Nat × Bool × String
  predInterp p args := match p, args with
    | 0, [(a1, b1, s1), (a2, b2, s2)] => a1 = a2 ∧ b1 = b2
    | 1, [(a, b, s)] => s.length > a
    | _, _ => False
  constInterp 0 := (0, false, "")
  constInterp 1 := (1, true, "one")
  constInterp _ := (0, false, "")

-- eval examples
#eval "Structure creation benchmarks"
#eval "mkStruct1: domain = Unit (1 element)"
#eval (mkStructN 10).constInterp 0
#eval (mkStructN 100).constInterp 0
#eval (mkStructComplex.predInterp 0 [(0, false, ""), (0, false, "x")])
#eval (mkStructComplex.predInterp 1 [(7, false, "hello world")])

end MiniFunctionRelation.Bench
