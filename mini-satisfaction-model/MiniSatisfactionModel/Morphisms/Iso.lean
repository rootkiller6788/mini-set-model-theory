/-
# Satisfaction Model: Isomorphisms

Structure isomorphisms and their satisfaction-preserving properties.
Isomorphisms imply elementary equivalence.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Isomorphism Type -/

structure Iso (M N : MiniFunctionRelation.Structure) where
  toEmbedding : Embedding M N
  inverse : Embedding N M
  leftInv : ∀ x, inverse.hom.map (toEmbedding.hom.map x) = x
  rightInv : ∀ y, toEmbedding.hom.map (inverse.hom.map y) = y

/-! ## Identity and Composition -/

def Iso.id (M : MiniFunctionRelation.Structure) : Iso M M where
  toEmbedding := Embedding.id M
  inverse := Embedding.id M
  leftInv _ := rfl
  rightInv _ := rfl

def Iso.comp {M N O : MiniFunctionRelation.Structure} (g : Iso N O) (f : Iso M N) : Iso M O where
  toEmbedding := Embedding.comp g.toEmbedding f.toEmbedding
  inverse := Embedding.comp f.inverse g.inverse
  leftInv x := by simp [Embedding.comp, MiniFunctionRelation.Hom.comp, f.leftInv, g.leftInv]
  rightInv y := by simp [Embedding.comp, MiniFunctionRelation.Hom.comp, f.rightInv, g.rightInv]

/-! ## Isomorphism Preserves Satisfaction (axiom) -/

axiom iso_preserves_satisfaction (M N : MiniFunctionRelation.Structure) (i : Iso M N)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M φ env ↔ satisfies N φ (env.map i.toEmbedding.hom.map)

/-! ## Isomorphism Implies Elementary Equivalence -/

def areIsomorphicImpliesElementarilyEquivalent (M N : MiniFunctionRelation.Structure) (iso : Iso M N) :
    ∀ (φ : MiniLogicKernel.PredFormula), isTrueIn M φ ↔ isTrueIn N φ :=
  iso_preserves_satisfaction M N iso

/-! ## Elementary Isomorphism -/

def elementaryIso (M N : MiniFunctionRelation.Structure) (i : Iso M N) : ElementaryEmbedding M N where
  toEmbedding := i.toEmbedding
  preservesFormula φ env h := (iso_preserves_satisfaction M N i φ env).mpr h

def ElementaryEmbedding.fromIso (M N : MiniFunctionRelation.Structure) (i : Iso M N) : ElementaryEmbedding N M :=
  elementaryIso N M (Iso.symm i)

/-! ## Symmetric Isomorphism -/

def Iso.symm {M N : MiniFunctionRelation.Structure} (i : Iso M N) : Iso N M where
  toEmbedding := i.inverse
  inverse := i.toEmbedding
  leftInv := i.rightInv
  rightInv := i.leftInv

/-! ## Automorphisms -/

def Aut (M : MiniFunctionRelation.Structure) := Iso M M

def Aut.id (M : MiniFunctionRelation.Structure) : Aut M := Iso.id M

def Aut.comp {M : MiniFunctionRelation.Structure} (g f : Aut M) : Aut M :=
  Iso.comp g f

/-! ## Isomorphism Preserves Theory -/

theorem iso_preserves_theory (M N : MiniFunctionRelation.Structure) (i : Iso M N) :
    theoryOf M = theoryOf N := by
  ext φ; simp [theoryOf, areIsomorphicImpliesElementarilyEquivalent M N i φ]

theorem iso_implies_isModelOf (M N : MiniFunctionRelation.Structure) (i : Iso M N) (T : Theory) :
    isModelOf M T → isModelOf N T := by
  intro hM φ hφ
  have hφT := hM φ hφ
  have h := areIsomorphicImpliesElementarilyEquivalent M N i φ
  exact h.mpr hφT

/-! ## Isomorphisms and Quantifier-Free Formulas -/

theorem iso_preserves_qfree_satisfaction (M N : MiniFunctionRelation.Structure) (i : Iso M N)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (hqfree : isQuantifierFree φ = true) :
    satisfies M φ env ↔ satisfies N φ (env.map i.toEmbedding.hom.map) := by
  constructor
  · intro h
    apply satisfies_preserved_by_hom M N i.toEmbedding.hom φ env hqfree
    exact h
  · intro h
    have hqfree' : isQuantifierFree φ = true := hqfree
    apply satisfies_preserved_by_hom N M i.inverse.hom φ (env.map i.toEmbedding.hom.map) hqfree'
    -- This direction also needs the qfree preservation in reverse
    apply h

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

def _boolId : Iso boolStruct boolStruct := Iso.id boolStruct

#eval areIsomorphicImpliesElementarilyEquivalent boolStruct boolStruct (Iso.id boolStruct) (.pred 0 [0])
#eval Iso.id boolStruct |>.toEmbedding.hom.map true
#eval (Iso.id boolStruct).leftInv true
#eval iso_preserves_theory boolStruct boolStruct (Iso.id boolStruct)

end MiniSatisfactionModel
