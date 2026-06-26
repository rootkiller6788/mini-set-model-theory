import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Direct Product

The direct product of a family of structures: domain is the Cartesian product
and interpretations are defined componentwise.
-/

structure ProductStruct (M N : Structure) where
  toProd : Structure
  projL : Hom toProd M
  projR : Hom toProd N

def ProductStruct.mk' (M N : Structure) : ProductStruct M N where
  toProd := {
    domain := M.domain × N.domain
    predInterp p args :=
      M.predInterp p (args.map Prod.fst) ∧ N.predInterp p (args.map Prod.snd)
    constInterp c := (M.constInterp c, N.constInterp c)
  }
  projL := {
    map := Prod.fst
    preservesPred := by
      intro p args h
      rcases h with ⟨hM, _⟩
      exact hM
    preservesConst := by intro c; rfl
  }
  projR := {
    map := Prod.snd
    preservesPred := by
      intro p args h
      rcases h with ⟨_, hN⟩
      exact hN
    preservesConst := by intro c; rfl
  }

def ProductStruct.projLHom {M N : Structure} (P : ProductStruct M N) : Hom P.toProd M := P.projL
def ProductStruct.projRHom {M N : Structure} (P : ProductStruct M N) : Hom P.toProd N := P.projR

-- Universal property of the product: given two homs f: K→M, g: K→N, there is a unique h: K→M×N
def ProductStruct.universal {M N K : Structure} (P : ProductStruct M N)
    (f : Hom K M) (g : Hom K N) : Hom K P.toProd where
  map x := (f.map x, g.map x)
  preservesPred p args h := by
    constructor
    · apply f.preservesPred p args h
    · apply g.preservesPred p args h
  preservesConst c := by
    simp
    constructor
    · exact f.preservesConst c
    · exact g.preservesConst c

theorem ProductStruct.universal_projL {M N K : Structure} (P : ProductStruct M N)
    (f : Hom K M) (g : Hom K N) (x : K.domain) :
    P.projL.map ((ProductStruct.universal P f g).map x) = f.map x := rfl

theorem ProductStruct.universal_projR {M N K : Structure} (P : ProductStruct M N)
    (f : Hom K M) (g : Hom K N) (x : K.domain) :
    P.projR.map ((ProductStruct.universal P f g).map x) = g.map x := rfl

-- Direct product of multiple structures
def naryProduct (Ms : List Structure) : Structure where
  domain := (List.rec (γ := λ _ => Type) Unit (λ M _ IH => M.domain × IH) Ms)
  predInterp p args :=
    match Ms with
    | [] => True
    | M :: Ms' => M.predInterp p (args.map (λ t => (t : M.domain × ((ProductStruct.mk' M (naryProduct Ms')).toProd).domain)).1)
    -- simplified for the finite case
  constInterp c :=
    match Ms with
    | [] => ()
    | M :: Ms' => (M.constInterp c, (naryProduct Ms').constInterp c)

-- Test with concrete structures
def StructA : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => False
  constInterp c := c

def StructB : Structure where
  domain := Bool
  predInterp p args := match p with
    | 0 => args = [true]
    | _ => False
  constInterp _ := false

def ProdAB := ProductStruct.mk' StructA StructB

#eval ((ProductStruct.mk' StructA StructB).toProd).constInterp 0
#eval (ProdAB.projL.map ((42, true) : ProdAB.toProd.domain))
#eval (ProdAB.projR.map ((42, true) : ProdAB.toProd.domain))

end MiniFunctionRelation
