import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Algebraic Structures as First-Order Structures

Groups, rings, and fields represented as `Structure` objects.
Function symbols are encoded via their graph predicates.
-/

/-! ## Group structures -/

def trivialGroup : Structure where
  domain := Unit
  predInterp p args := match p, args with
    | 0, [] => True
    | 1, [(), (), ()] => True
    | _, _ => False
  constInterp 0 := ()
  constInterp _ := ()

/-- Z/2Z: domain = Bool, addition = xor -/
def Zmod2Group : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [] => True
    | 1, [x, y, z] => ((x || y) && !(x && y)) = z
    | _, _ => False
  constInterp 0 := false
  constInterp _ := false

/-- Z/3Z: domain = Fin 3, addition modulo 3 -/
def Zmod3Group : Structure where
  domain := Fin 3
  predInterp p args := match p, args with
    | 0, [] => True
    | 1, [x, y, z] => (x.val + y.val) % 3 = z.val
    | _, _ => False
  constInterp 0 := ⟨0, by decide⟩
  constInterp _ := ⟨0, by decide⟩

/-- Z/4Z: cyclic group of order 4 -/
def Zmod4Group : Structure where
  domain := Fin 4
  predInterp p args := match p, args with
    | 0, [] => True
    | 1, [x, y, z] => (x.val + y.val) % 4 = z.val
    | _, _ => False
  constInterp 0 := ⟨0, by decide⟩
  constInterp _ := ⟨0, by decide⟩

/-- The trivial automorphism of any structure. -/
def trivialAuto (M : Structure) : Iso M M := Iso.id M

/-- Group isomorphism between two copies of Z/2Z. -/
def zmod2IdIso : Iso Zmod2Group Zmod2Group := Iso.id Zmod2Group

/-- The negation map on Z/3Z: x ↦ -x mod 3.
    This is a group automorphism (inverse-preserving). -/
def Zmod3NegIso : Iso Zmod3Group Zmod3Group where
  toHom := {
    map x := ⟨(3 - x.val) % 3, by
      have h : (3 - x.val) % 3 < 3 := Nat.mod_lt _ (by decide)
      exact h⟩
    preservesPred p args h := by
      simp [Zmod3Group] at h ⊢
      match p with
      | 0 => trivial
      | 1 =>
          rcases args with ([x, y, z] | _) <;> simp at h ⊢
          -- Need: (-x + -y) % 3 = -z % 3 given (x + y) % 3 = z.val
          -- Which is true because (-x + -y) = -(x+y) mod 3
          -- But our representation uses explicit mod
          have : ((3 - x.val) % 3 + (3 - y.val) % 3) % 3 = (3 - z.val) % 3 := by
            -- This follows from modular arithmetic properties
            -- x+y ≡ z (mod 3) → -x-y ≡ -z (mod 3)
            -- But verifying with actual Fin computation is easier
            have hsum : (x.val + y.val) % 3 = z.val := h
            -- enumerate all 27 cases or use ring operations
            -- For brevity, use `dec_trivial` for finite enumeration
            fin_cases x <;> fin_cases y <;> fin_cases z <;> decide
          simpa [Zmod3Group] using this
      | _ => trivial
    preservesConst c := by simp [Zmod3Group]
  }
  invHom := {
    map x := ⟨(3 - x.val) % 3, by
      have h : (3 - x.val) % 3 < 3 := Nat.mod_lt _ (by decide)
      exact h⟩
    preservesPred p args h := by
      simp [Zmod3Group] at h ⊢
      match p with
      | 0 => trivial
      | 1 =>
          rcases args with ([x, y, z] | _) <;> simp at h ⊢
          fin_cases x <;> fin_cases y <;> fin_cases z <;> decide
      | _ => trivial
    preservesConst c := by simp [Zmod3Group]
  }
  leftInv x := by
    ext; simp
    fin_cases x <;> decide
  rightInv y := by
    ext; simp
    fin_cases y <;> decide

/-! ## Ring structures -/

def IntAsRing : Structure where
  domain := Int
  predInterp p args := match p, args with
    | 1, [x, y, z] => x + y = z
    | 2, [x, y, z] => x * y = z
    | _, _ => False
  constInterp 0 := 0
  constInterp 1 := 1
  constInterp _ := 0

def Zmod6Ring : Structure where
  domain := Fin 6
  predInterp p args := match p, args with
    | 1, [x, y, z] => (x.val + y.val) % 6 = z.val
    | 2, [x, y, z] => (x.val * y.val) % 6 = z.val
    | _, _ => False
  constInterp 0 := ⟨0, by decide⟩
  constInterp 1 := ⟨1, by decide⟩
  constInterp _ := ⟨0, by decide⟩

/-! ## Field structures -/

def RatAsField : Structure where
  domain := Rat
  predInterp p args := match p, args with
    | 1, [x, y, z] => x + y = z
    | 2, [x, y, z] => x * y = z
    | 3, [x] => x ≠ 0
    | _, _ => False
  constInterp 0 := 0
  constInterp 1 := 1
  constInterp _ := 0

def F2Field : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 1, [x, y, z] => ((x || y) && !(x && y)) = z
    | 2, [x, y, z] => (x && y) = z
    | 3, [x] => x = true
    | _, _ => False
  constInterp 0 := false
  constInterp 1 := true
  constInterp _ := false

/-! ## Evaluation examples -/

#eval (Zmod2Group.constInterp 0)
#eval (Zmod2Group.predInterp 1 [false, true, true])
#eval (Zmod2Group.predInterp 1 [true, true, false])
#eval (Zmod2Group.predInterp 1 [true, false, true])

#eval (Zmod3Group.predInterp 1 [⟨1, by decide⟩, ⟨2, by decide⟩, ⟨0, by decide⟩])
#eval (Zmod3Group.predInterp 1 [⟨2, by decide⟩, ⟨2, by decide⟩, ⟨1, by decide⟩])
#eval (Zmod4Group.predInterp 1 [⟨2, by decide⟩, ⟨3, by decide⟩, ⟨1, by decide⟩])

#eval (IntAsRing.predInterp 1 [2, 3, 5])
#eval (IntAsRing.predInterp 2 [2, 3, 6])
#eval (IntAsRing.predInterp 2 [-2, 3, -6])

#eval (Zmod6Ring.predInterp 1 [⟨2, by decide⟩, ⟨4, by decide⟩, ⟨0, by decide⟩])
#eval (Zmod6Ring.predInterp 2 [⟨2, by decide⟩, ⟨3, by decide⟩, ⟨0, by decide⟩])

#eval (F2Field.predInterp 1 [true, true, false])
#eval (F2Field.predInterp 2 [true, true, true])
#eval (F2Field.predInterp 3 [true])

#eval "GroupRingField.lean loaded"
#eval "  Groups: trivialGroup, Zmod2Group, Zmod3Group, Zmod4Group"
#eval "  Rings: IntAsRing, Zmod6Ring"
#eval "  Fields: RatAsField, F2Field"

end MiniFunctionRelation
