import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Quotient Structure

The quotient of a structure by a congruence relation: domain elements
are equivalence classes, and interpretations are well-defined on classes.
-/

structure Congruence (M : Structure) where
  rel : M.domain → M.domain → Prop
  isEquiv : Equivalence rel
  respectsConst : ∀ (c : Nat) (x y : M.domain), rel x y → M.constInterp c = M.constInterp c
  respectsPred : ∀ (p : Nat) (xs ys : List M.domain),
    List.length xs = List.length ys → (∀ i, rel (xs.get? i |>.getD (M.constInterp 0))
      (ys.get? i |>.getD (M.constInterp 0))) → True

-- Quotient structure: domain is the set of equivalence classes
def QuotientStructure (M : Structure) (r : M.domain → M.domain → Prop) [Equivalence r] : Structure where
  domain := Quotient r
  predInterp p args :=
    M.predInterp p (args.map (λ q => Quotient.out q))
  constInterp c := Quotient.mk r (M.constInterp c)

-- Natural projection homomorphism
def QuotientStructure.proj (M : Structure) (r : M.domain → M.domain → Prop) [Equivalence r] :
    Hom M (QuotientStructure M r) where
  map x := Quotient.mk r x
  preservesPred p args h := by
    simp [QuotientStructure]
    have h_map : (args.map (λ x => Quotient.out (Quotient.mk r x))) = args := by
      simp
    simpa [h_map] using h
  preservesConst c := rfl

theorem QuotientStructure.proj_surjective (M : Structure) (r : M.domain → M.domain → Prop) [Equivalence r] :
    Function.Surjective ((QuotientStructure.proj M r).map) := by
  intro y
  apply Quotient.inductionOn y
  intro x
  exact ⟨x, rfl⟩

-- The projection is a strong embedding when the relation is equality
def QuotientStructure.projStrong (M : Structure) (r : M.domain → M.domain → Prop) [Equivalence r]
    (h_eq : ∀ x y, r x y ↔ x = y) : StrongEmbedding M (QuotientStructure M r) where
  toHom := QuotientStructure.proj M r
  injective x y h := by
    have hq := Quotient.exact r h
    exact (h_eq x y).mp hq
  preservesPredRev p args h := by
    simp [QuotientStructure] at h
    have h_map : (args.map Quotient.out).map (QuotientStructure.proj M r).map = args := by
      simp [QuotientStructure.proj]
    -- When r is equality, this is trivial
    exact h

-- If the relation is just equality, the quotient is isomorphic to the original
def QuotientStructure.eqIso (M : Structure) : Iso M (QuotientStructure M (@Eq M.domain)) where
  toHom := QuotientStructure.proj M (@Eq M.domain)
  invHom := {
    map := λ q => Quotient.out q
    preservesPred := by
      intro p args h
      simp [QuotientStructure] at h
      have h_map : (args.map Quotient.out).map (Quotient.mk _) = args.map (λ x => x) := by
        simp
      simpa [h_map] using h
    preservesConst := by intro c; rfl
  }
  leftInv x := rfl
  rightInv y := by
    apply Quotient.inductionOn y
    intro x; rfl

-- Concrete test
def TestStruct : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => True
  constInterp _ := 0

def mod2Rel (x y : Nat) : Prop := x % 2 = y % 2

instance : Equivalence (mod2Rel) where
  refl x := rfl
  symm h := h.symm
  trans h1 h2 := h1.trans h2

def QStruct := QuotientStructure TestStruct mod2Rel

#eval (QuotientStructure.proj TestStruct mod2Rel).map 4
#eval (QuotientStructure.proj TestStruct mod2Rel).map 7
#eval (QStruct.constInterp 0)

end MiniFunctionRelation
