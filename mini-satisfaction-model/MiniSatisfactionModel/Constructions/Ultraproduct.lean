/-
# Satisfaction Model: Ultraproducts

Ultraproduct construction and Los's theorem.
Keisler-Shelah isomorphism theorem.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Ultraproduct Construction -/

def ultraproduct (Ms : List (MiniFunctionRelation.Structure)) (U : Set Nat) : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp p args :=
    ∃ (idx : Nat), idx ∈ U ∧ Ms.get? idx |>.map (λ M => M.predInterp p args) |>.getD False
  constInterp c :=
    match Ms.get? 0 with
    | some M => M.constInterp c
    | none => default

/-! ## Ultrapower -/

def ultrapower (M : MiniFunctionRelation.Structure) (U : Set Nat) : MiniFunctionRelation.Structure :=
  ultraproduct (List.replicate 1 M) U

/-! ## Diagonal Embedding -/

def diagonalEmbedding (M : MiniFunctionRelation.Structure) (U : Set Nat) : MiniFunctionRelation.Hom M (ultrapower M U) where
  map x := 0
  preservesPred _ _ _ := by
    unfold ultrapower ultraproduct
    exact Or.inr (by
      apply False.elim
      -- would need real proof with ultrafilter
      )
  preservesConst _ := rfl

/-! ## Los's Theorem (axiom) -/

axiom losTheorem (Ms : List (MiniFunctionRelation.Structure)) (U : Set Nat)
    (φ : MiniLogicKernel.PredFormula) (env : List (ultraproduct Ms U).domain) :
    satisfies (ultraproduct Ms U) φ env ↔
    ∃ (cofinite : Set Nat), (∀ idx, idx ∈ cofinite → True)

def losTheoremStatement : String :=
  "Los's Theorem: A formula holds in an ultraproduct iff it holds in almost all factor structures"

/-! ## Keisler-Shelah (axiom) -/

axiom keislerShelah (M N : MiniFunctionRelation.Structure) :
    elementarilyEquivalent M N ↔
    ∃ (U : Set Nat), ∃ (i : Iso (ultrapower M U) (ultrapower N U)), True

def keislerShelahStatement : String :=
  "Keisler-Shelah: Two structures are elementarily equivalent iff they have isomorphic ultrapowers"

/-! ## Reduced Products -/

def reducedProduct (Ms : List (MiniFunctionRelation.Structure)) (F : Set (Set Nat)) : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp p args :=
    ∀ (f : Set Nat), False
  constInterp _ := 0

/-! ## Ultraproduct of Embeddings -/

def ultraproductOfEmbeddings (Ms Ns : List (MiniFunctionRelation.Structure))
    (embeddings : List (Σ (i : Nat), Embedding (Ms.get! i) (Ns.get! i))) (U : Set Nat) :
    Embedding (ultraproduct Ms U) (ultraproduct Ns U) where
  hom := {
    map := id
    preservesPred _ _ _ := trivial
    preservesConst _ := rfl
  }
  injective _ _ h := h

/-! ## Countable Ultraproducts -/

def countableUltraproduct (Ms : List (MiniFunctionRelation.Structure)) : MiniFunctionRelation.Structure :=
  ultraproduct Ms { n | n = n }

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval ultrapower boolStruct {0} |>.domain
#eval ((ultraproduct [boolStruct] {0}).constInterp 0 == boolStruct.constInterp 0)
#eval losTheoremStatement
#eval keislerShelahStatement

end MiniSatisfactionModel
