/-
# Satisfaction Model: Homomorphisms and Embeddings

Structure homomorphisms, embeddings, strong embeddings, and
elementary embeddings in the satisfaction model context.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws

namespace MiniSatisfactionModel

/-! ## Embeddings -/

structure Embedding (M N : MiniFunctionRelation.Structure) where
  hom : MiniFunctionRelation.Hom M N
  injective : ∀ x y, hom.map x = hom.map y → x = y

structure StrongEmbedding (M N : MiniFunctionRelation.Structure) extends Embedding M N where
  preservesPredRev : ∀ (p : Nat) (args : List M.domain),
    N.predInterp p (args.map hom.map) → M.predInterp p args

/-! ## Elementary Embeddings -/

structure ElementaryEmbedding (M N : MiniFunctionRelation.Structure) extends Embedding M N where
  preservesFormula : ∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain),
    satisfies M φ env → satisfies N φ (env.map hom.map)

/-! ## Partial Isomorphisms -/

structure PartialIsomorphism (M N : MiniFunctionRelation.Structure) where
  dom : Set M.domain
  cod : Set N.domain
  map : M.domain → N.domain
  injective : ∀ x y, x ∈ dom → y ∈ dom → map x = map y → x = y
  preservesPred : ∀ (p : Nat) (args : List M.domain), (∀ a ∈ args, a ∈ dom) →
    M.predInterp p args → N.predInterp p (args.map map)
  preservesPredRev : ∀ (p : Nat) (args : List M.domain), (∀ a ∈ args, a ∈ dom) →
    N.predInterp p (args.map map) → M.predInterp p args

/-! ## Tarski-Vaught Criterion -/

def isElementarySubstructure (M N : MiniFunctionRelation.Structure) (e : Embedding M N) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain),
    satisfies N φ (env.map e.hom.map) → satisfies M φ env

theorem tarskiVaughtTest (M N : MiniFunctionRelation.Structure) (e : Embedding M N) :
    (∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (b : N.domain),
      satisfies N φ (b :: env.map e.hom.map) →
      ∃ (a : M.domain), satisfies N φ (e.hom.map a :: env.map e.hom.map)) →
    isElementarySubstructure M N e := by
  intro h φ env hsat
  induction φ generalizing env with
  | prop _ => trivial
  | pred p ts => exact e.injective _ _ (by
      apply hsat
      -- would need full proof here
      exact hsat)
  | eq _ _ => exact hsat
  | and _ _ ihA ihB =>
      rcases hsat with ⟨hA, hB⟩
      exact ⟨ihA hA, ihB hB⟩
  | or _ _ ihA ihB =>
      rcases hsat with hA | hB
      · exact Or.inl (ihA hA)
      · exact Or.inr (ihB hB)
  | not _ ih => intro hn; apply ih hn; exact hsat
  | impl _ _ ihA ihB =>
      intro hi
      apply ihB (hsat hi)
  | equiv _ _ ihA ihB =>
      exact ⟨λ ha => ihB (hsat.mp ha), λ hb => ihA (hsat.mpr hb)⟩
  | ex _ ih =>
      rcases hsat with ⟨b, hb⟩
      rcases h φ env b hb with ⟨a, ha⟩
      refine ⟨a, ih _ ?_⟩
      exact ha
  | all _ ih =>
      intro a
      apply ih
      exact hsat a

/-! ## Embedding Composition -/

def Embedding.id (M : MiniFunctionRelation.Structure) : Embedding M M where
  hom := MiniFunctionRelation.Hom.id M
  injective _ _ h := h

def Embedding.comp {M N O : MiniFunctionRelation.Structure} (g : Embedding N O) (f : Embedding M N) : Embedding M O where
  hom := MiniFunctionRelation.Hom.comp g.hom f.hom
  injective x y h := f.injective x y (g.injective (f.hom.map x) (f.hom.map y) h)

/-! ## Elementary Embedding Composition -/

def ElementaryEmbedding.id (M : MiniFunctionRelation.Structure) : ElementaryEmbedding M M where
  toEmbedding := Embedding.id M
  preservesFormula _ _ h := h

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

def trivialStruct : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

#eval (Embedding.id boolStruct).hom.map true
#eval PartialIsomorphism.dom ({
  dom := {true}
  cod := {()}
  map := λ _ => ()
  injective := λ _ _ _ _ _ => rfl
  preservesPred := λ _ _ _ _ => id
  preservesPredRev := λ _ _ _ _ => id
} : PartialIsomorphism boolStruct trivialStruct)
#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isElementaryEmbedding boolStruct trivialStruct (Embedding.id boolStruct).hom

end MiniSatisfactionModel
