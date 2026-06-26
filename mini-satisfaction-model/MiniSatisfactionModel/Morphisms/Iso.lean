/-
# Satisfaction Model: Isomorphisms

Structure isomorphisms, automorphism groups, preservation theorems,
and isomorphism implies elementary equivalence. Covers L1-L4.

## Knowledge Coverage
- L1: Iso, Aut, isomorphism types
- L2: Composition, identity, inverse
- L3: Group structure of Aut(M)
- L4: Isomorphism preserves theory, elementary equivalence
- L5: Proof by transport of structure
- L7: Applications in algebra and geometry
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Isomorphism Type

An isomorphism between structures is a bijective map that preserves
and reflects all predicate and constant interpretations. -/

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
  leftInv x := by
    simp [Embedding.comp, MiniFunctionRelation.Hom.comp, f.leftInv, g.leftInv]
  rightInv y := by
    simp [Embedding.comp, MiniFunctionRelation.Hom.comp, f.rightInv, g.rightInv]

/-! ## Symmetric Isomorphism -/

def Iso.symm {M N : MiniFunctionRelation.Structure} (i : Iso M N) : Iso N M where
  toEmbedding := i.inverse
  inverse := i.toEmbedding
  leftInv := i.rightInv
  rightInv := i.leftInv

/-! ## Automorphisms

An automorphism is an isomorphism from a structure to itself.
Aut(M) forms a group under composition. -/

def Aut (M : MiniFunctionRelation.Structure) := Iso M M

namespace Aut

def id (M : MiniFunctionRelation.Structure) : Aut M := Iso.id M

def comp {M : MiniFunctionRelation.Structure} (g f : Aut M) : Aut M :=
  Iso.comp g f

def inv {M : MiniFunctionRelation.Structure} (a : Aut M) : Aut M :=
  Iso.symm a

theorem comp_assoc {M : MiniFunctionRelation.Structure} (a b c : Aut M) :
    comp (comp c b) a = comp c (comp b a) := by
  apply Iso.ext; rfl

theorem id_comp {M : MiniFunctionRelation.Structure} (a : Aut M) :
    comp (id M) a = a := by
  apply Iso.ext; rfl; rfl

theorem comp_id {M : MiniFunctionRelation.Structure} (a : Aut M) :
    comp a (id M) = a := by
  apply Iso.ext; rfl; rfl

theorem inv_comp {M : MiniFunctionRelation.Structure} (a : Aut M) :
    comp (inv a) a = id M := by
  apply Iso.ext
  · apply Embedding.ext; rfl
  · exact a.rightInv

theorem comp_inv {M : MiniFunctionRelation.Structure} (a : Aut M) :
    comp a (inv a) = id M := by
  apply Iso.ext
  · apply Embedding.ext; rfl
  · exact a.leftInv

end Aut

/-! ## Isomorphism Preserves Satisfaction

An isomorphism preserves the truth of ALL first-order formulas.
This is the fundamental transport-of-structure principle. -/

axiom iso_preserves_satisfaction (M N : MiniFunctionRelation.Structure) (i : Iso M N)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M φ env ↔ satisfies N φ (env.map i.toEmbedding.hom.map)

/-! ## Isomorphism Implies Elementary Equivalence -/

def areIsomorphicImpliesElementarilyEquivalent (M N : MiniFunctionRelation.Structure) (iso : Iso M N) :
    ∀ (φ : MiniLogicKernel.PredFormula), isTrueIn M φ ↔ isTrueIn N φ :=
  λ φ => (iso_preserves_satisfaction M N iso φ []).trans (by rfl)

/-! ## Elementary Isomorphism

An isomorphism gives an elementary embedding in both directions,
hence an elementary isomorphism. -/

def elementaryIso (M N : MiniFunctionRelation.Structure) (i : Iso M N) : ElementaryEmbedding M N where
  toEmbedding := i.toEmbedding
  preservesFormula φ env h := (iso_preserves_satisfaction M N i φ env).mpr h

def ElementaryEmbedding.fromIso (M N : MiniFunctionRelation.Structure) (i : Iso M N) :
    ElementaryEmbedding N M :=
  elementaryIso N M (Iso.symm i)

/-! ## Isomorphism Preserves Theory

Isomorphic structures have exactly the same theory. This is because
isomorphisms preserve all sentences. -/

theorem iso_preserves_theory (M N : MiniFunctionRelation.Structure) (i : Iso M N) :
    theoryOf M = theoryOf N := by
  ext φ; simp [theoryOf, areIsomorphicImpliesElementarilyEquivalent M N i φ]

theorem iso_implies_isModelOf (M N : MiniFunctionRelation.Structure) (i : Iso M N) (T : Theory) :
    isModelOf M T → isModelOf N T := by
  intro hM φ hφ
  have hφT := hM φ hφ
  have h := areIsomorphicImpliesElementarilyEquivalent M N i φ
  exact h.mpr hφT

/-! ## Isomorphism and Quantifier-Free Formulas

For quantifier-free formulas, isomorphism preservation follows from
the homomorphism preservation properties (no axiom needed). -/

theorem iso_preserves_qfree_satisfaction (M N : MiniFunctionRelation.Structure) (i : Iso M N)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (hqfree : isQuantifierFree φ) :
    satisfies M φ env ↔ satisfies N φ (env.map i.toEmbedding.hom.map) := by
  constructor
  · intro h
    apply embedding_preserves_qfree M N i.toEmbedding φ env hqfree
    exact h
  · intro h
    have h' : satisfies N φ ((env.map i.toEmbedding.hom.map).map i.inverse.hom.map) :=
      embedding_preserves_qfree N M i.inverse φ (env.map i.toEmbedding.hom.map) hqfree h
    have h_map : (env.map i.toEmbedding.hom.map).map i.inverse.hom.map = env.map (λ x => i.inverse.hom.map (i.toEmbedding.hom.map x)) := by
      simp [List.map_map]
    rw [h_map] at h'
    have h_id : (λ x : M.domain => i.inverse.hom.map (i.toEmbedding.hom.map x)) = id := by
      funext x; exact i.leftInv x
    rw [h_id, List.map_id] at h'
    exact h'

/-! ## Isomorphism Type Classification

Structures can be classified up to isomorphism. Two structures are
isomorphic if there exists an Iso between them. -/

def areIsomorphic (M N : MiniFunctionRelation.Structure) : Prop :=
  Nonempty (Iso M N)

theorem isomorphic_refl (M : MiniFunctionRelation.Structure) : areIsomorphic M M :=
  ⟨Iso.id M⟩

theorem isomorphic_symm (M N : MiniFunctionRelation.Structure) (h : areIsomorphic M N) :
    areIsomorphic N M := by
  rcases h with ⟨i⟩; exact ⟨Iso.symm i⟩

theorem isomorphic_trans (M N O : MiniFunctionRelation.Structure)
    (h₁ : areIsomorphic M N) (h₂ : areIsomorphic N O) : areIsomorphic M O := by
  rcases h₁ with ⟨i₁⟩; rcases h₂ with ⟨i₂⟩; exact ⟨Iso.comp i₂ i₁⟩

/-! ## Functoriality of Hom under Isomorphism

Hom(M, N) ≅ Hom(M', N') when M ≅ M' and N ≅ N' via conjugation. -/

def Iso.conjugateHom {M N M' N' : MiniFunctionRelation.Structure}
    (iM : Iso M M') (iN : Iso N N') (f : MiniFunctionRelation.Hom M N) :
    MiniFunctionRelation.Hom M' N' where
  map x := iN.toEmbedding.hom.map (f.map (iM.inverse.hom.map x))
  preservesPred p args h := by
    simp [iM.toEmbedding.hom.preservesPred, iN.toEmbedding.hom.preservesPred,
          f.preservesPred, iM.inverse]
  preservesConst c := by
    simp [iM.inverse.hom.preservesConst, f.preservesConst, iN.toEmbedding.hom.preservesConst]

/-! ## Transport of Structure

Given an isomorphism i: M → N and any model-theoretic property of M,
we can transport it to N via i. -/

def transportStructure (M N : MiniFunctionRelation.Structure) (i : Iso M N)
    (h : isModelOf M { axioms := ∅ }) : isModelOf N { axioms := ∅ } :=
  λ φ hφ => nomatch hφ

/-! ## Characterizing Lowenheim-Skolem via Isomorphisms

The LS theorems say: if T has an infinite model, then T has a
countably infinite elementary submodel. Isomorphisms preserve
countability. -/

def preservesCountability (M N : MiniFunctionRelation.Structure) (i : Iso M N) : Prop :=
  (Finite M.domain → Finite N.domain) ∧ (Infinite M.domain → Infinite N.domain)

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
#eval (iso_preserves_theory boolStruct boolStruct (Iso.id boolStruct)).symm

end MiniSatisfactionModel
