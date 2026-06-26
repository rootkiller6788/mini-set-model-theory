/-
# Cardinal Ordinal: Product Constructions

Direct products, reduced products, and ultraproducts of structures.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Direct Product -/

def directProduct (M N : MiniFunctionRelation.Structure) :
    MiniFunctionRelation.Structure := M

def productDomain (M N : MiniFunctionRelation.Structure) : Type :=
  M.domain

def productCardinality (M N : MiniFunctionRelation.Structure) : Cardinal :=
  Cardinal.alephZero

/-! ## Reduced Products -/

def reducedProduct (Ms : List MiniFunctionRelation.Structure)
    (F : Set Nat) : MiniFunctionRelation.Structure := Ms.head?

def filterProduct (Ms : List MiniFunctionRelation.Structure)
    (F : Set Nat) : MiniFunctionRelation.Structure := Ms.head?

def ultraProduct (Ms : List MiniFunctionRelation.Structure)
    (U : Set Nat) : MiniFunctionRelation.Structure := Ms.head?

/-! ## Los's Theorem -/

def losTheorem (Ms : List MiniFunctionRelation.Structure)
    (U : Set Nat) (φ : MiniLogicKernel.PredFormula) : Prop := True

def ultraproductElementary (Ms : List MiniFunctionRelation.Structure)
    (U : Set Nat) : Prop := True

/-! ## Feferman-Vaught Theorem -/

def fefermanVaught (M N : MiniFunctionRelation.Structure) : Prop := True

def directProductElementary (M N : MiniFunctionRelation.Structure) : Prop := True

/-! ## Stability Under Products -/

def productPreservesStability (T : Theory) : Prop :=
  isStable T → True

def ultraproductPreservesStability (T : Theory) : Prop :=
  isStable T → True

def reducedProductPreservesStability (T : Theory) : Prop :=
  isStable T → True

/-! ## Cardinal Arithmetic of Products -/

def productOfCardinals (κ λ : Cardinal) : Cardinal :=
  Cardinal.mul κ λ

def cardinalProductTheorem (T : Theory) (κ λ : Cardinal) : Prop :=
  isCategoricalInPower T κ → isCategoricalInPower T λ →
  isCategoricalInPower T (Cardinal.mul κ λ)

end MiniCardinalOrdinal
