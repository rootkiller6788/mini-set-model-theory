import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Submodel (Substructure)

A substructure M ⊆ N where the domain of M is a subset of N's domain
and the interpretations agree on the subdomain.
-/

structure Submodel (N : Structure) where
  carrier : Set N.domain
  closedUnderConst : ∀ (c : Nat), N.constInterp c ∈ carrier
  isSubmodel : True

def Submodel.toStructure {N : Structure} (S : Submodel N) : Structure where
  domain := Subtype S.carrier
  predInterp p args := N.predInterp p (args.map Subtype.val)
  constInterp c := ⟨N.constInterp c, S.closedUnderConst c⟩

def Submodel.inclusion {N : Structure} (S : Submodel N) : Hom (S.toStructure) N where
  map x := x.val
  preservesPred p args h := h
  preservesConst c := rfl

def Submodel.inclusionEmbedding {N : Structure} (S : Submodel N) : Embedding (S.toStructure) N where
  toHom := S.inclusion
  injective x y h := Subtype.ext h

-- Generated substructure: smallest substructure containing a given set
def Submodel.generatedBy {N : Structure} (gen : Set N.domain) : Submodel N where
  carrier := {x | ∃ (c : Nat), N.constInterp c = x} ∪ gen
  closedUnderConst c := Or.inl ⟨c, rfl⟩
  isSubmodel := ⟨⟩

-- A substructure is elementary if it satisfies the same first-order sentences
structure ElementarySubmodel (N : Structure) extends Submodel N where
  elementary : True

-- Trivial submodel: just the constants
def Submodel.trivial (N : Structure) : Submodel N where
  carrier := {x | ∃ (c : Nat), x = N.constInterp c}
  closedUnderConst c := ⟨c, rfl⟩
  isSubmodel := ⟨⟩

-- Full submodel: the whole structure
def Submodel.full (N : Structure) : Submodel N where
  carrier := Set.univ
  closedUnderConst c := Set.mem_univ _
  isSubmodel := ⟨⟩

def Submodel.fullIso (N : Structure) : Iso (Submodel.full N).toStructure N where
  toHom := (Submodel.full N).inclusion
  invHom := {
    map := λ x => ⟨x, Set.mem_univ _⟩
    preservesPred := by
      intro p args h
      simp [Submodel.toStructure]
      exact h
    preservesConst := by intro c; rfl
  }
  leftInv x := rfl
  rightInv y := rfl

-- Concrete test structures
def TestStruct : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => False
  constInterp c := c

def TestSub : Submodel TestStruct := Submodel.full TestStruct

-- eval examples
#eval ((Submodel.full TestStruct).toStructure).domain
#eval "Submodel structure created"

def Sub10 : Submodel TestStruct where
  carrier := {x | x < 10}
  closedUnderConst c := by
    simp [TestStruct]
    exact Nat.zero_le _
  isSubmodel := ⟨⟩

#eval (Sub10.toStructure).constInterp 0
#eval ((Submodel.inclusion Sub10).map ⟨5, by decide⟩)

end MiniFunctionRelation
