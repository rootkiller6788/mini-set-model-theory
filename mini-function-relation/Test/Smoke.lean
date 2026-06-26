import MiniFunctionRelation

namespace MiniFunctionRelation.Test

/-
# Smoke Tests

Basic construction and composition tests for Structure, Hom, and Iso.
-/

-- A trivial one-element structure with one unary predicate that holds for the empty list
def TrivialStructure : Structure where
  domain := Unit
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := ()

-- Identity homomorphism on the trivial structure
def trivialHom : Hom TrivialStructure TrivialStructure :=
  Hom.id TrivialStructure

-- Identity isomorphism on the trivial structure
def trivialIso : Iso TrivialStructure TrivialStructure :=
  Iso.id TrivialStructure

-- Composition of identity with itself
def trivialHomComp : Hom TrivialStructure TrivialStructure :=
  Hom.comp trivialHom trivialHom

def trivialIsoComp : Iso TrivialStructure TrivialStructure :=
  Iso.comp trivialIso trivialIso

-- A two-element structure
inductive TwoElem | a | b

def TwoStructure : Structure where
  domain := TwoElem
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => False
  constInterp c := match c with
    | 0 => TwoElem.a
    | _ => TwoElem.b

-- A homomorphism from the trivial structure to the two-element structure
def trivialToTwo : Hom TrivialStructure TwoStructure where
  map _ := TwoElem.a
  preservesPred p args h := by
    simp [TrivialStructure, TwoStructure] at h ⊢
    cases p; case _ => trivial
  preservesConst _ := rfl

end MiniFunctionRelation.Test
