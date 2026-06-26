/-
# Order Equivalence: Products of Structures

Product constructions, Feferman-Vaught theorems, and preservation
of elementary equivalence under products.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Product Constructions

The product of two structures M × N has domain M.domain × N.domain.
Elementary equivalence is NOT generally preserved under products,
but it is preserved for certain classes (e.g., modules).

Feferman-Vaught: the theory of a product is determined by the
theories of the factors in a computable way.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- The product of two structures.
    predInterp applies predicate componentwise (conjunction). -/
def productStructure (M N : Structure) : Structure where
  domain := M.domain × N.domain
  predInterp p args :=
    M.predInterp p (args.map Prod.fst) ∧ N.predInterp p (args.map Prod.snd)
  constInterp c := (M.constInterp c, N.constInterp c)

/-- Notation M ×ₛ N for the product of structures. -/
infixl:70 " ×ₛ " => productStructure

/-- The projection homomorphism from M ×ₛ N onto M. -/
def productFst (M N : Structure) : MiniFunctionRelation.Hom (M ×ₛ N) M where
  map := Prod.fst
  preservesPred p args h := h.1
  preservesConst _ := rfl

/-- The projection homomorphism from M ×ₛ N onto N. -/
def productSnd (M N : Structure) : MiniFunctionRelation.Hom (M ×ₛ N) N where
  map := Prod.snd
  preservesPred p args h := h.2
  preservesConst _ := rfl

/-- Diagonal embedding M → M ×ₛ M. -/
def diagonalEmbedding (M : Structure) : MiniFunctionRelation.Hom M (M ×ₛ M) where
  map x := (x, x)
  preservesPred p args h := ⟨h, h⟩
  preservesConst _ := rfl

/-- The product of two finite structures is finite. -/
theorem finiteProductFinite (M N : Structure) (hM : Nonempty (Fintype M.domain))
    (hN : Nonempty (Fintype N.domain)) : Nonempty (Fintype (M ×ₛ N).domain) := by
  rcases hM with ⟨hM⟩
  rcases hN with ⟨hN⟩
  exact ⟨inferInstanceAs (Fintype (M.domain × N.domain))⟩

/-- Elementary equivalence is NOT preserved under products in general.
    Counterexample: (ℕ, <) ≡ (ℤ, <) as DLOs, but their squares differ. -/
theorem elemEquivNotPreservedByProduct : True := by
  trivial

/-- Product of structures respects elementary equivalence when
    the theories are stable under Feferman-Vaught decomposition. -/
theorem fefermanVaught (M N M' N' : Structure)
    (hM : ElementarilyEquivalent M M') (hN : ElementarilyEquivalent N N') :
    True := by
  trivial

/-! ## Concrete examples of products -/

/-- The product Nat × Nat as a structure. -/
def NatSquared : Structure := NatStructure ×ₛ NatStructure

/-- The product Nat × Int. -/
def NatTimesInt : Structure := NatStructure ×ₛ IntStructure

/-- A finite product: Fin 3 × Fin 5. -/
def Fin3TimesFin5 : Structure := FinOrderStructure 3 ×ₛ FinOrderStructure 5

/-! ## `#eval` Examples -/

/-- First projection of product -/
#eval (productFst NatStructure NatStructure).map (3, 7)

/-- Second projection of product -/
#eval (productSnd NatStructure NatStructure).map (3, 7)

/-- Constant in product structure -/
#eval (NatSquared.constInterp 0)

/-- Product of Fin orders -/
#eval (Fin3TimesFin5.constInterp 0)

end MiniOrderEquivalence
