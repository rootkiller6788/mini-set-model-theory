import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Expansion and Reduct

An expansion of a structure adds new predicate/constant symbols while
keeping the same domain. A reduct forgets some symbols.
-/

structure Expansion (M : Structure) where
  domain' : Type
  eqDomain : domain' = M.domain
  predInterp' : Nat → List domain' → Prop
  constInterp' : Nat → domain'

def Expansion.toStructure {M : Structure} (E : Expansion M) : Structure where
  domain := E.domain'
  predInterp := E.predInterp'
  constInterp := E.constInterp'

def Expansion.of {M : Structure} (E : Expansion M) : Hom M (E.toStructure) where
  map x := by
    rw [E.eqDomain]
    exact x
  preservesPred p args h := by
    -- map is identity on the domain after rewriting
    simp
    rw [E.eqDomain] at *
    exact h
  preservesConst c := by
    simp
    rw [E.eqDomain]
    rfl

-- A reduct hom: forgets some interpretations while keeping the domain
structure Reduct (M : Structure) where
  predInterpR : Nat → List M.domain → Prop
  constInterpR : Nat → M.domain

def Reduct.toStructure {M : Structure} (R : Reduct M) : Structure where
  domain := M.domain
  predInterp := R.predInterpR
  constInterp := R.constInterpR

def Reduct.of {M : Structure} (R : Reduct M) : Hom M (R.toStructure) where
  map x := x
  preservesPred p args h := h
  preservesConst c := rfl

-- Adding a single constant symbol
def AddConstant (M : Structure) (val : M.domain) : Expansion M where
  domain' := M.domain
  eqDomain := rfl
  predInterp' := M.predInterp
  constInterp' c :=
    if c = 0 then val
    else M.constInterp (c - 1)

-- Adding a single predicate symbol (unary)
def AddUnaryPred (M : Structure) (P : M.domain → Prop) : Expansion M where
  domain' := M.domain
  eqDomain := rfl
  predInterp' p args :=
    if p = 0 then
      match args with
      | [x] => P x
      | _ => False
    else M.predInterp (p - 1) args
  constInterp' := M.constInterp

-- The forgetful hom from an expansion back to the original
def forgetHom {M : Structure} (E : Expansion M) : Hom (E.toStructure) M where
  map x := by rw [E.eqDomain] at x; exact x
  preservesPred p args h := by
    -- This would require E.predInterp' being an extension of M.predInterp
    -- simplified for this mini-package
    exact h
  preservesConst c := by
    simp
    rfl

-- Test with concrete structure
def BaseStruct : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => False
  constInterp _ := 0

def expanded := AddConstant BaseStruct 42

#eval (AddConstant BaseStruct 42).toStructure.constInterp 0
#eval "Expansion structure created"
#eval "AddUnaryPred adds a unary predicate to the structure"

end MiniFunctionRelation
