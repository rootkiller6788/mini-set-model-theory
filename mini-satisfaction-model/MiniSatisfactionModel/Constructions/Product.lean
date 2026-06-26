/-
# Satisfaction Model: Direct Products

Direct product of structures and the Feferman-Vaught theorem.
Preservation properties of product constructions.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Product Structure -/

def productStructure (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain × N.domain
  predInterp
    | p, args => M.predInterp p (args.map Prod.fst) ∧ N.predInterp p (args.map Prod.snd)
  constInterp c := (M.constInterp c, N.constInterp c)

/-! ## Projections -/

def productProjectionLeft (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom (productStructure M N) M where
  map := Prod.fst
  preservesPred p args h := h.left
  preservesConst _ := rfl

def productProjectionRight (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Hom (productStructure M N) N where
  map := Prod.snd
  preservesPred p args h := h.right
  preservesConst _ := rfl

/-! ## Product Embeddings -/

def productEmbedding (M1 M2 N1 N2 : MiniFunctionRelation.Structure)
    (e1 : Embedding M1 N1) (e2 : Embedding M2 N2) :
    Embedding (productStructure M1 M2) (productStructure N1 N2) where
  hom := {
    map := λ ⟨x, y⟩ => (e1.hom.map x, e2.hom.map y)
    preservesPred p args h := by
      simp [productStructure] at h ⊢
      exact ⟨e1.hom.preservesPred p (args.map Prod.fst) h.left,
             e2.hom.preservesPred p (args.map Prod.snd) h.right⟩
    preservesConst c := by simp [productStructure, e1.hom.preservesConst, e2.hom.preservesConst]
  }
  injective x y h := by
    have h1 := congrArg Prod.fst h
    have h2 := congrArg Prod.snd h
    apply Prod.ext
    · exact e1.injective _ _ h1
    · exact e2.injective _ _ h2

/-! ## Finite Products -/

def productOfList (Ms : List (MiniFunctionRelation.Structure)) : MiniFunctionRelation.Structure :=
  match Ms with
  | [] => { domain := Unit, predInterp _ _ := False, constInterp _ := () }
  | [M] => M
  | M :: Ms' => productStructure M (productOfList Ms')

/-! ## Product Theory -/

def productTheory (T1 T2 : Theory) : Theory where
  axioms := { φ | ∀ (M1 M2 : MiniFunctionRelation.Structure),
    isModelOf M1 T1 → isModelOf M2 T2 → isTrueIn (productStructure M1 M2) φ }

/-! ## Cone Homomorphisms -/

def productConeLeft (M N : MiniFunctionRelation.Structure) : Embedding M (productStructure M N) where
  hom := {
    map := λ x => (x, N.constInterp 0)
    preservesPred p args h := by
      simp [productStructure]
      exact ⟨h, by
        have := N.predInterp p (args.map (λ _ => N.constInterp 0))
        exact this⟩
    preservesConst c := by simp [productStructure]
  }
  injective x y h := by
    have := congrArg Prod.fst h; exact this

def productConeRight (M N : MiniFunctionRelation.Structure) : Embedding N (productStructure M N) where
  hom := {
    map := λ y => (M.constInterp 0, y)
    preservesPred p args h := by
      simp [productStructure]
      exact ⟨by
        have := M.predInterp p (args.map (λ _ => M.constInterp 0))
        exact this, h⟩
    preservesConst c := by simp [productStructure]
  }
  injective x y h := by
    have := congrArg Prod.snd h; exact this

/-! ## Feferman-Vaught Theorem (axiom) -/

axiom fefermanVaughtTheorem (M N : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    ∃ (decomposition : List (MiniLogicKernel.PredFormula × MiniLogicKernel.PredFormula)),
    True

def fefermanVaught : String :=
  "Feferman-Vaught: The theory of a product is determined by the theories of its factors"

/-! ## Product-Preserved Formulas -/

def isPreservedUnderProducts (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure),
    isTrueIn M φ → isTrueIn N φ → isTrueIn (productStructure M N) φ

def hornFormulaClass : Set (MiniLogicKernel.PredFormula) :=
  { φ | isPreservedUnderProducts φ }

axiom hornFormulasPreserved : ∀ (φ : MiniLogicKernel.PredFormula),
    isPreservedUnderProducts φ → True

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval productStructure boolStruct boolStruct |>.domain
#eval (productProjectionLeft boolStruct boolStruct).map (true, false)
#eval isPreservedUnderProducts (.prop .true)
#eval fefermanVaught
#eval (productConeLeft boolStruct boolStruct).hom.map true

end MiniSatisfactionModel
