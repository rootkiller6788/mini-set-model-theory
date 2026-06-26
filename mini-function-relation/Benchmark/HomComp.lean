import MiniFunctionRelation

namespace MiniFunctionRelation.Bench

/-
# Benchmark: Homomorphism Composition
-/

def BStructA : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => True
  constInterp _ := 0

def BStructB : Structure where
  domain := Int
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => True
  constInterp _ := 0

def f_hom : Hom BStructA BStructB where
  map x := x
  preservesPred p args h := by
    simp [BStructA, BStructB] at h ⊢
    exact h
  preservesConst c := by simp [BStructA, BStructB]

def g_hom : Hom BStructB BStructA where
  map x := x.toNat
  preservesPred p args h := by
    simp [BStructA, BStructB] at h ⊢
    exact h
  preservesConst c := by simp [BStructA, BStructB]

def comp_fg : Hom BStructA BStructA := Hom.comp g_hom f_hom
def comp_gf : Hom BStructB BStructB := Hom.comp f_hom g_hom

-- eval examples
#eval "Hom composition benchmark"
#eval f_hom.map 42
#eval g_hom.map 42
#eval comp_fg.map 7
#eval comp_gf.map (-3)
#eval (Hom.comp (Hom.id BStructA) f_hom).map 42

end MiniFunctionRelation.Bench
