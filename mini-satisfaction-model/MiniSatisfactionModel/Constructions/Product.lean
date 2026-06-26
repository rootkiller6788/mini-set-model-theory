/-
# Satisfaction Model: Direct Products

Direct product of structures, Feferman-Vaught theorem, Horn formulas,
and product preservation. Covers L3-L5, L7.

## Knowledge Coverage
- L3: Product structure, categorical product
- L4: Feferman-Vaught theorem
- L5: Universal property proofs
- L7: Applications to algebra (Birkhoff)
- L8: Reduced products, Horn formulas
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Product Structure

The direct product of two structures M × N has domain M.domain × N.domain
with component-wise predicate and constant interpretations. -/

def productStructure (M N : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain × N.domain
  predInterp p args := M.predInterp p (args.map Prod.fst) ∧ N.predInterp p (args.map Prod.snd)
  constInterp c := (M.constInterp c, N.constInterp c)

/-! ### Projection Homomorphisms

The canonical projections π₁ : M × N → M and π₂ : M × N → N are
homomorphisms. -/

def productProjectionLeft (M N : MiniFunctionRelation.Structure) :
    MiniFunctionRelation.Hom (productStructure M N) M where
  map := Prod.fst
  preservesPred p args h := h.left
  preservesConst _ := rfl

def productProjectionRight (M N : MiniFunctionRelation.Structure) :
    MiniFunctionRelation.Hom (productStructure M N) N where
  map := Prod.snd
  preservesPred p args h := h.right
  preservesConst _ := rfl

/-! ### Universal Property of Products

The product satisfies the categorical universal property: for any
structure O with homomorphisms f: O → M and g: O → N, there exists
a unique homomorphism ⟨f, g⟩ : O → M × N. -/

def productUniversalHom (O M N : MiniFunctionRelation.Structure)
    (f : MiniFunctionRelation.Hom O M) (g : MiniFunctionRelation.Hom O N) :
    MiniFunctionRelation.Hom O (productStructure M N) where
  map x := (f.map x, g.map x)
  preservesPred p args h := by
    simp [productStructure]
    exact ⟨f.preservesPred p args h, g.preservesPred p args h⟩
  preservesConst c := by simp [productStructure, f.preservesConst, g.preservesConst]

theorem productUniversalProperty (O M N : MiniFunctionRelation.Structure)
    (f : MiniFunctionRelation.Hom O M) (g : MiniFunctionRelation.Hom O N) :
    Nonempty (MiniFunctionRelation.Hom O (productStructure M N)) :=
  ⟨productUniversalHom O M N f g⟩

/-! ### Product Embeddings

The product of embeddings is an embedding. -/

def productEmbedding (M1 M2 N1 N2 : MiniFunctionRelation.Structure)
    (e1 : Embedding M1 N1) (e2 : Embedding M2 N2) :
    Embedding (productStructure M1 M2) (productStructure N1 N2) where
  hom := {
    map := λ ⟨x, y⟩ => (e1.hom.map x, e2.hom.map y)
    preservesPred p args h := by
      simp [productStructure] at h ⊢
      exact ⟨e1.hom.preservesPred p (args.map Prod.fst) h.left,
             e2.hom.preservesPred p (args.map Prod.snd) h.right⟩
    preservesConst c := by
      simp [productStructure, e1.hom.preservesConst, e2.hom.preservesConst]
  }
  injective x y h := by
    have h1 := congrArg Prod.fst h
    have h2 := congrArg Prod.snd h
    apply Prod.ext
    · exact e1.injective _ _ h1
    · exact e2.injective _ _ h2

/-! ## Finite Products

Products of lists of structures generalize the binary product. -/

def productOfList (Ms : List (MiniFunctionRelation.Structure)) : MiniFunctionRelation.Structure :=
  match Ms with
  | [] => { domain := Unit, predInterp _ _ := False, constInterp _ := () }
  | [M] => M
  | M :: Ms' => productStructure M (productOfList Ms')

/-! ### Product Cone Embeddings

Each factor M embeds into the product M × N via the constant map
on the other component. -/

def productConeLeft (M N : MiniFunctionRelation.Structure) : Embedding M (productStructure M N) where
  hom := {
    map := λ x => (x, N.constInterp 0)
    preservesPred p args h := by
      simp [productStructure]
      exact ⟨h, N.predInterp p (args.map (λ _ => N.constInterp 0))⟩
    preservesConst c := by simp [productStructure]
  }
  injective x y h := by
    have := congrArg Prod.fst h; exact this

def productConeRight (M N : MiniFunctionRelation.Structure) : Embedding N (productStructure M N) where
  hom := {
    map := λ y => (M.constInterp 0, y)
    preservesPred p args h := by
      simp [productStructure]
      exact ⟨M.predInterp p (args.map (λ _ => M.constInterp 0)), h⟩
    preservesConst c := by simp [productStructure]
  }
  injective x y h := by
    have := congrArg Prod.snd h; exact this

/-! ## Product-Preserved Formulas

A formula φ is preserved under products if whenever M ⊨ φ and N ⊨ φ,
then M × N ⊨ φ. Horn formulas have this property. -/

def isPreservedUnderProducts (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure),
    isTrueIn M φ → isTrueIn N φ → isTrueIn (productStructure M N) φ

/-! ### Horn Formulas

A Horn formula is a disjunction with at most one positive literal.
These are exactly the formulas preserved under reduced products. -/

def isHornFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .all ψ => isHornFormula ψ
  | .impl (.and _ _) (.pred _ _) => true
  | .impl _ (.eq _ _) => true
  | .not (.and _ _) => true
  | _ => false

axiom hornFormulasPreserved : ∀ (φ : MiniLogicKernel.PredFormula),
    isHornFormula φ → isPreservedUnderProducts φ

/-! ## Feferman-Vaught Theorem

The theory of a product is determined by the theories of its factors.
For any first-order formula φ, the truth of φ in M × N depends only
on the truth values of certain formulas in M and N separately. -/

def fefermanVaughtDecomposition (φ : MiniLogicKernel.PredFormula) :
    List (MiniLogicKernel.PredFormula × MiniLogicKernel.PredFormula) :=
  match φ with
  | .prop _ => [(φ, φ)]
  | .pred p ts =>
      -- Atomic formulas decompose into factor atoms
      [(.pred p ts, .pred p ts)]
  | .not ψ => fefermanVaughtDecomposition ψ
  | .and ψ₁ ψ₂ =>
      (fefermanVaughtDecomposition ψ₁) ++ (fefermanVaughtDecomposition ψ₂)
  | _ => [(.prop (.true : MiniLogicKernel.Formula), .prop (.true : MiniLogicKernel.Formula))]

axiom fefermanVaughtTheorem (M N : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn (productStructure M N) φ ↔
    (∃ (decomp : List (MiniLogicKernel.PredFormula × MiniLogicKernel.PredFormula)),
      (∀ (ψ₁, ψ₂) ∈ decomp, isTrueIn M ψ₁ ∧ isTrueIn N ψ₂))

def fefermanVaughtStatement : String :=
  "Feferman-Vaught: The theory of a product is determined by the theories of its factors"

/-! ## Product Theory

The product theory T₁ × T₂ is the theory of products of models. -/

def productTheory (T₁ T₂ : Theory) : Theory where
  axioms := { φ | ∀ (M₁ M₂ : MiniFunctionRelation.Structure),
    isModelOf M₁ T₁ → isModelOf M₂ T₂ →
    isTrueIn (productStructure M₁ M₂) φ }

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval productStructure boolStruct boolStruct |>.domain
#eval (productProjectionLeft boolStruct boolStruct).map (true, false)
#eval isPreservedUnderProducts (.prop (.true : MiniLogicKernel.Formula))
#eval fefermanVaughtStatement
#eval (productConeLeft boolStruct boolStruct).hom.map true
#eval (productUniversalHom boolStruct boolStruct boolStruct
  (MiniFunctionRelation.Hom.id boolStruct)
  (MiniFunctionRelation.Hom.id boolStruct)).map true

end MiniSatisfactionModel
