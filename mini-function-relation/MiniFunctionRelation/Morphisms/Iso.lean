import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Core.Laws

namespace MiniFunctionRelation

/-
# Structure Isomorphism

An `Iso M N` is an isomorphism of structures: two homomorphisms f: M→N
and g: N→M that are inverses of each other. Both directions preserve predicates
and constants.
-/

structure Iso (M N : Structure) where
  toHom : Hom M N
  invHom : Hom N M
  leftInv : ∀ x, invHom.map (toHom.map x) = x
  rightInv : ∀ y, toHom.map (invHom.map y) = y

namespace Iso

def id (M : Structure) : Iso M M where
  toHom := Hom.id M
  invHom := Hom.id M
  leftInv _ := rfl
  rightInv _ := rfl

def comp {M N O : Structure} (g : Iso N O) (f : Iso M N) : Iso M O where
  toHom := Hom.comp g.toHom f.toHom
  invHom := Hom.comp f.invHom g.invHom
  leftInv x := by
    dsimp
    rw [f.leftInv, g.leftInv]
  rightInv y := by
    dsimp
    rw [g.rightInv, f.rightInv]

def symm {M N : Structure} (i : Iso M N) : Iso N M where
  toHom := i.invHom
  invHom := i.toHom
  leftInv := i.rightInv
  rightInv := i.leftInv

def refl (M : Structure) : Iso M M := id M

theorem symm_involutive {M N : Structure} (i : Iso M N) : symm (symm i) = i := rfl

-- Categorical laws at the map level (avoids needing Iso.ext)
theorem comp_id_map {M N : Structure} (f : Iso M N) (x : M.domain) :
    (comp f (id M)).toHom.map x = f.toHom.map x := rfl

theorem id_comp_map {M N : Structure} (f : Iso M N) (x : M.domain) :
    (comp (id N) f).toHom.map x = f.toHom.map x := rfl

theorem comp_assoc_map {M N O P : Structure} (h : Iso O P) (g : Iso N O) (f : Iso M N) (x : M.domain) :
    (comp (comp h g) f).toHom.map x = (comp h (comp g f)).toHom.map x := rfl

theorem toHom_id {M : Structure} : (id M).toHom = Hom.id M := rfl

theorem toHom_comp {M N O : Structure} (g : Iso N O) (f : Iso M N) :
    (comp g f).toHom = Hom.comp g.toHom f.toHom := rfl

theorem invHom_id {M : Structure} : (id M).invHom = Hom.id M := rfl

theorem invHom_symm {M N : Structure} (i : Iso M N) : (symm i).invHom = i.toHom := rfl

theorem invHom_comp {M N O : Structure} (g : Iso N O) (f : Iso M N) :
    (comp g f).invHom = Hom.comp f.invHom g.invHom := rfl

-- Iso implies injectivity of the forward map
theorem toHom_injective {M N : Structure} (i : Iso M N) : Function.Injective i.toHom.map := by
  intro x y h
  calc
    x = i.invHom.map (i.toHom.map x) := by rw [i.leftInv]
    _ = i.invHom.map (i.toHom.map y) := by rw [h]
    _ = y := by rw [i.leftInv]

-- Iso implies surjectivity of the forward map
theorem toHom_surjective {M N : Structure} (i : Iso M N) : Function.Surjective i.toHom.map := by
  intro y
  refine ⟨i.invHom.map y, ?_⟩
  rw [i.rightInv]

theorem toHom_bijective {M N : Structure} (i : Iso M N) : Function.Bijective i.toHom.map :=
  ⟨toHom_injective i, toHom_surjective i⟩

end Iso

-- concrete test structures
def TrivStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def TwoStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [] => True
    | _ => False
  constInterp _ := false

def swapIso : Iso TwoStruct TwoStruct where
  toHom := {
    map := λ b => !b
    preservesPred p args h := by
      simp [TwoStruct] at h ⊢
      cases p; case _ => trivial
    preservesConst c := by simp [TwoStruct]
  }
  invHom := {
    map := λ b => !b
    preservesPred p args h := by
      simp [TwoStruct] at h ⊢
      cases p; case _ => trivial
    preservesConst c := by simp [TwoStruct]
  }
  leftInv x := by simp
  rightInv y := by simp

-- eval examples
#eval (Iso.id TrivStruct).toHom.map ()
#eval (Iso.symm swapIso).toHom.map true
#eval (Iso.symm swapIso).toHom.map false
#eval (Iso.comp swapIso swapIso).toHom.map true
#eval (Iso.comp (Iso.symm swapIso) swapIso).toHom.map true

end MiniFunctionRelation
