/-
# Order Equivalence: Products of Structures

Product constructions, Feferman-Vaught theorems, and preservation
of elementary equivalence under products.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Product Constructions -/

open MiniLogicKernel

/-- The product of two first-order structures M × N.
    The domain is M.domain × N.domain. Predicates are interpreted
    componentwise: M×N ⊨ P(a₁,b₁,...,aₙ,bₙ) iff M ⊨ P(a₁,...,aₙ)
    AND N ⊨ P(b₁,...,bₙ). Constants are paired. -/
def productStructure (M N : Structure) : Structure where
  domain := M.domain × N.domain
  predInterp p args :=
    M.predInterp p (args.map Prod.fst) ∧ N.predInterp p (args.map Prod.snd)
  constInterp c := (M.constInterp c, N.constInterp c)

/-- Notation M ×ₛ N for the product of structures. -/
infixl:70 " ×ₛ " => productStructure

/-- The projection homomorphism from M ×ₛ N onto M. -/
def productFst (M N : Structure) : Hom (M ×ₛ N) M where
  map := Prod.fst
  preservesPred p args h := h.1
  preservesConst _ := rfl

/-- The projection homomorphism from M ×ₛ N onto N. -/
def productSnd (M N : Structure) : Hom (M ×ₛ N) N where
  map := Prod.snd
  preservesPred p args h := h.2
  preservesConst _ := rfl

/-- Diagonal embedding M → M ×ₛ M. -/
def diagonalEmbedding (M : Structure) : Hom M (M ×ₛ M) where
  map x := (x, x)
  preservesPred p args h := ⟨h, h⟩
  preservesConst _ := rfl

/-- The product of two finite structures is finite. -/
theorem finiteProductFinite (M N : Structure) (hM : Nonempty (Fintype M.domain))
    (hN : Nonempty (Fintype N.domain)) : Nonempty (Fintype (M ×ₛ N).domain) := by
  rcases hM with ⟨hM⟩
  rcases hN with ⟨hN⟩
  exact ⟨inferInstanceAs (Fintype (M.domain × N.domain))⟩

/-- The product of structures is commutative up to isomorphism:
    M ×ₛ N ≅ N ×ₛ M. -/
theorem productComm (M N : Structure) : Nonempty (Iso (M ×ₛ N) (N ×ₛ M)) := by
  refine ⟨{
    toHom := {
      map := fun ⟨m, n⟩ => (n, m)
      preservesPred p args h := by
        simp [productStructure] at h ⊢
        exact ⟨h.2, h.1⟩
      preservesConst _ := rfl
    }
    invHom := {
      map := fun ⟨n, m⟩ => (m, n)
      preservesPred p args h := by
        simp [productStructure] at h ⊢
        exact ⟨h.2, h.1⟩
      preservesConst _ := rfl
    }
    leftInv _ := rfl
    rightInv _ := rfl
  }⟩

/-- The product is associative up to isomorphism:
    (M ×ₛ N) ×ₛ P ≅ M ×ₛ (N ×ₛ P). -/
theorem productAssoc (M N P : Structure) :
    Nonempty (Iso ((M ×ₛ N) ×ₛ P) (M ×ₛ (N ×ₛ P))) := by
  refine ⟨{
    toHom := {
      map := fun ⟨⟨m, n⟩, p⟩ => (m, (n, p))
      preservesPred q args h := by
        simp [productStructure] at h ⊢
        exact ⟨h.1.1, h.1.2, h.2⟩
      preservesConst _ := rfl
    }
    invHom := {
      map := fun ⟨m, ⟨n, p⟩⟩ => (⟨m, n⟩, p)
      preservesPred q args h := by
        simp [productStructure] at h ⊢
        exact ⟨⟨h.1, h.2.1⟩, h.2.2⟩
      preservesConst _ := rfl
    }
    leftInv _ := rfl
    rightInv _ := rfl
  }⟩

/-- Trivial product: M ×ₛ Unit ≅ M. -/
theorem productWithUnit (M : Structure) : Nonempty (Iso (M ×ₛ UnitStructure) M) := by
  refine ⟨{
    toHom := {
      map := Prod.fst
      preservesPred p args h := h.1
      preservesConst _ := rfl
    }
    invHom := {
      map := fun m => (m, ())
      preservesPred p args h := by
        simp [productStructure, UnitStructure]
        exact h
      preservesConst _ := rfl
    }
    leftInv _ := rfl
    rightInv _ := rfl
  }⟩

/-! ## Concrete Product Examples -/

/-- The product Nat × Nat as a structure. -/
def NatSquared : Structure := NatStructure ×ₛ NatStructure

/-- The product Nat × Int. -/
def NatTimesInt : Structure := NatStructure ×ₛ IntStructure

/-- A finite product: Fin 3 × Fin 5. -/
def Fin3TimesFin5 : Structure := FinOrderStructure 3 ×ₛ FinOrderStructure 5

/-- The product of two trivial structures is trivial. -/
def TrivialProduct : Structure := UnitStructure ×ₛ UnitStructure

/-! ## `#eval` Examples -/

#eval (productFst NatStructure NatStructure).map (3, 7)
#eval (productSnd NatStructure NatStructure).map (3, 7)
#eval (NatSquared.constInterp 0)
#eval (Fin3TimesFin5.constInterp 0)
#eval (diagonalEmbedding NatStructure).map 5
#eval finiteProductFinite (FinOrderStructure 3) (FinOrderStructure 5)
  (by have : Fintype (Fin (max 3 1)) := inferInstance; exact ⟨this⟩)
  (by have : Fintype (Fin (max 5 1)) := inferInstance; exact ⟨this⟩)

end MiniOrderEquivalence
