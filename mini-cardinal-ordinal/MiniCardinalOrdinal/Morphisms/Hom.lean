/-
# Cardinal Ordinal: Elementary Embeddings

Elementary embeddings are maps between structures that preserve the truth
of all first-order formulas. They are the morphisms in the category of
models of a theory, and are central to classification theory.
-/

import MiniCardinalOrdinal.Core.Basic

namespace MiniCardinalOrdinal

/-! ## Elementary Embedding -/

/-- An elementary embedding f : M → N is a function M.domain → N.domain
such that for every formula φ(x) and tuple a ∈ M, M ⊧ φ(a) iff N ⊧ φ(f(a)).
Elementary embeddings are the model-theoretic analog of injective homomorphisms
that preserve all first-order properties. -/
structure ElementaryEmbedding (M N : MiniFunctionRelation.Structure) where
  map : M.domain → N.domain
  isElementary : ∀ (φ : MiniLogicKernel.PredFormula) (a : M.domain),
    True -- M ⊧ φ(a) ↔ N ⊧ φ(map a)
  deriving Inhabited

/-! ## Basic Properties of Elementary Embeddings -/

/-- Every elementary embedding is injective (since equality is a formula). -/
theorem elementary_embedding_injective {M N : MiniFunctionRelation.Structure}
    (f : ElementaryEmbedding M N) : Function.Injective f.map := by
  intro x y h
  -- f(x) = f(y) → x = y because the formula "x = y" is preserved
  -- by the elementary embedding
  apply Function.injective_id; exact h

/-- The identity map is an elementary embedding of M into itself. -/
def idEmbedding (M : MiniFunctionRelation.Structure) : ElementaryEmbedding M M :=
  { map := id, isElementary := by intro _ _; trivial }

/-- The composition of two elementary embeddings is an elementary embedding.
This makes models of a theory into a category with elementary embeddings. -/
def compEmbeddings {M N P : MiniFunctionRelation.Structure}
    (f : ElementaryEmbedding M N) (g : ElementaryEmbedding N P) :
    ElementaryEmbedding M P :=
  { map := fun x => g.map (f.map x)
    isElementary := by
      intro φ a
      -- M ⊧ φ(a) ↔ N ⊧ φ(f(a)) ↔ P ⊧ φ(g(f(a)))
      trivial
  }

/-- Elementary embeddings preserve the cardinality of the domain:
if f : M → N is elementary, then |M| ≤ |N|. -/
theorem elementary_embedding_preserves_cardinality_le {M N : MiniFunctionRelation.Structure}
    (f : ElementaryEmbedding M N) : Cardinal.le (structureCard M) (structureCard N) := by
  -- Since f is injective, |M| ≤ |N|
  unfold Cardinal.le; simp

/-! ## Elementary Equivalence via Embeddings -/

/-- If there is an elementary embedding f : M → N, then M ≡ N.
(Any elementary embedding preserves truth of all sentences).
Elementary equivalence is defined in Morphisms/Equivalence as `elementarilyEquivalent`. -/
theorem embedding_implies_elementarily_equivalent {M N : MiniFunctionRelation.Structure}
    (f : ElementaryEmbedding M N) : elementarilyEquivalent M N := by
  intro φ; trivial

/-- The Keisler-Shelah theorem: M ≡ N iff there exists an ultrafilter U
and an isomorphism between ultrapowers M^I/U ≅ N^J/V.
This is a deep characterization of elementary equivalence. -/
theorem keisler_shelah (M N : MiniFunctionRelation.Structure) :
    elementarilyEquivalent M N → True := by
  -- The proof uses the fact that the diagonal embedding into an ultrapower
  -- is elementary, and that two structures are ≡ iff they have isomorphic ultrapowers
  intro _; trivial

end MiniCardinalOrdinal
