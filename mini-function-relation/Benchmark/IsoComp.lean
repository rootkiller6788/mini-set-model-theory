import MiniFunctionRelation

namespace MiniFunctionRelation.Bench

/-
# Benchmark: Isomorphism Composition
-/

def ICStructA : Structure where
  domain := Fin 10
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def ICStructB : Structure where
  domain := Fin 10
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def iso_ab : Iso ICStructA ICStructB where
  toHom := {
    map := λ x => x
    preservesPred p args h := by
      simp [ICStructA, ICStructB] at h ⊢
      exact h
    preservesConst c := by simp [ICStructA, ICStructB]
  }
  invHom := {
    map := λ x => x
    preservesPred p args h := by
      simp [ICStructA, ICStructB] at h ⊢
      exact h
    preservesConst c := by simp [ICStructA, ICStructB]
  }
  leftInv x := rfl
  rightInv y := rfl

def iso_ba : Iso ICStructB ICStructA := Iso.symm iso_ab

def comp_aba : Iso ICStructA ICStructA := Iso.comp iso_ba iso_ab
def comp_ab_ba : Iso ICStructB ICStructB := Iso.comp iso_ab iso_ba

-- eval examples
#eval "Iso composition benchmark"
#eval iso_ab.toHom.map 3
#eval iso_ba.toHom.map 3
#eval comp_aba.toHom.map 5
#eval comp_ab_ba.toHom.map 5
#eval (Iso.comp (Iso.id ICStructA) iso_ab).toHom.map 7

end MiniFunctionRelation.Bench
