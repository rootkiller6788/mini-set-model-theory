import MiniFunctionRelation

open MiniFunctionRelation

namespace MiniFunctionRelation.Test

/-
# Regression Tests

Tests to catch regressions in the Structure / Hom / Iso API.
-/

-- Basic Structure construction
def RegStruct1 : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args = [0]
    | _ => args.isEmpty
  constInterp c := c * 2

-- Hom identity composition
def idHom := Hom.id RegStruct1

theorem id_comp_eq_id : Hom.comp idHom idHom = idHom :=
  Hom.id_comp idHom

-- Iso identity
def idIso := Iso.id RegStruct1

theorem iso_id_comp_map (x : RegStruct1.domain) :
    (Iso.comp idIso idIso).toHom.map x = x := rfl

-- Multiple composition
def ThreeCompose : Hom RegStruct1 RegStruct1 :=
  Hom.comp idHom (Hom.comp idHom idHom)

theorem three_compose_id : ThreeCompose = idHom := by
  calc
    ThreeCompose = Hom.comp idHom (Hom.comp idHom idHom) := rfl
    _ = Hom.comp idHom idHom := by rw [Hom.id_comp idHom]
    _ = idHom := Hom.id_comp idHom

-- Test with boolean domain
def BoolStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [b] => b = true
    | _, _ => False
  constInterp _ := false

def BoolIso : Iso BoolStruct BoolStruct where
  toHom := { map := λ b => !b, preservesPred := by
    intro p args h; simp [BoolStruct] at h ⊢; cases p; simp [h]
    , preservesConst := by intro c; rfl }
  invHom := { map := λ b => !b, preservesPred := by
    intro p args h; simp [BoolStruct] at h ⊢; cases p; simp [h]
    , preservesConst := by intro c; rfl }
  leftInv x := by simp
  rightInv y := by simp

theorem iso_involutive (x : Bool) :
    (Iso.comp BoolIso BoolIso).toHom.map x = x := by
  simp [Iso.comp, Iso.id, Hom.comp, Hom.id, BoolIso]

-- Test QuotientStructure construction
def RegQuotStruct : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => True
  constInterp _ := 0

def regQuotProj : Hom RegQuotStruct (QuotientStructure RegQuotStruct (@Eq Nat)) :=
  QuotientStructure.proj RegQuotStruct (@Eq Nat)

-- Test Product construction
def RegStruct2 : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := false

def regProd := ProductStruct.mk' RegStruct1 RegStruct2

#eval "Regression tests pass"
#eval (Hom.id RegStruct1).map 42
#eval BoolIso.toHom.map true
#eval BoolIso.toHom.map false
#eval (regProd.toProd).constInterp 0

end MiniFunctionRelation.Test
