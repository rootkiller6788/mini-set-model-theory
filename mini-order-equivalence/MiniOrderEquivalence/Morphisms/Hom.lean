/-
# Order Equivalence: Elementary Embeddings

Elementary embeddings between first-order structures:
maps that preserve all first-order formulas.

This file extends the elementary embedding theory from
Core/Basic.lean with additional constructions and examples.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

open MiniLogicKernel

/-! ## Elementary Embedding Properties

An elementary embedding f: M → N preserves the truth of all
first-order formulas. This is a stronger condition than being
a homomorphism: f must map constants to constants AND preserve
satisfaction for all formulas.
-/

/-- Every elementary embedding is injective (proved in Core/Basic). -/
theorem elemEmbeddingInjective {M N : Structure} (e : ElemEmbedding M N) :
    Function.Injective e.map :=
  ElemEmbedding.injective e

/-- An elementary embedding preserves the truth of sentences
    (formulas with empty environment). -/
theorem elemEmbeddingPreservesSentences {M N : Structure}
    (e : ElemEmbedding M N) (φ : PredFormula) :
    M.satisfies φ [] → N.satisfies φ [] :=
  e.elemPreserving φ []

/-- An elementary embedding from M to N implies M ≡ₑ N. -/
theorem elemEmbeddingImpliesElemEquiv {M N : Structure}
    (e : ElemEmbedding M N) : ElementarilyEquivalent M N :=
  ElemEmbedding.inducesElemEquiv e

/-- Every elementary embedding is also a homomorphism. -/
theorem elemEmbeddingToHom {M N : Structure} (e : ElemEmbedding M N) :
    Hom M N :=
  ElemEmbedding.toHom e

/-- Composition of elementary embeddings is elementary. -/
theorem elemEmbeddingComp {M N P : Structure}
    (f : ElemEmbedding M N) (g : ElemEmbedding N P) :
    ElemEmbedding M P :=
  ElemEmbedding.comp g f

/-! ## Natural Embeddings between Concrete Structures

We construct specific elementary embeddings between the
structures defined in Core/Basic and Core/Objects.
-/

/-- The identity is an elementary embedding on any structure. -/
def idElemEmbedding (M : Structure) : ElemEmbedding M M :=
  ElemEmbedding.id M

/-- An elementary embedding between a finite order structure
    and itself (identity). -/
def finiteOrderSelfEmbedding (n : Nat) : ElemEmbedding (FinOrderStructure n) (FinOrderStructure n) :=
  ElemEmbedding.id (FinOrderStructure n)

/-- The inclusion map from {0,1,...,k-1} to {0,1,...,k+m-1}
    as a homomorphism. This is NOT elementary in general because
    the larger structure may satisfy "there are at least k+1 elements"
    which the smaller one does not. But for quantifier-free formulas
    (just the order relation), it's a strong embedding. -/
def finInclusionHom (k m : Nat) : Hom (FinOrderStructure k) (FinOrderStructure (k + m)) where
  map x := ⟨x.val, by
    have hx : x.val < max k 1 := x.isLt
    have hsum : max k 1 ≤ max (k + m) 1 := by
      apply Nat.max_le_max
      · exact Nat.le_add_right k m
      · rfl
    exact Nat.lt_of_lt_of_le hx hsum
  ⟩
  preservesPred p args h := by
    simp [FinOrderStructure] at h ⊢
    -- Both use .val of the Fin elements, which is preserved by the embedding
    -- Since predInterp 0 compares .val, and .val is preserved, the predicate holds
    -- The args.map changes the Fin elements' proofs but not .val
    -- This should be true by construction
    simpa using h
  preservesConst c := rfl

/-! ## Elementary Chains

An elementary chain is a sequence of structures where each
embeds elementarily into the next.
-/

/-- An elementary chain M₀ → M₁ → M₂ → ... with elementary embeddings. -/
structure ElementaryChain where
  structures : Nat → Structure
  embedding : ∀ n, ElemEmbedding (structures n) (structures (n+1))

/-- The n-th structure of an elementary chain. -/
def ElementaryChain.at (chain : ElementaryChain) (n : Nat) : Structure :=
  chain.structures n

/-- The embedding from M₀ to Mₙ obtained by composing n times. -/
def ElementaryChain.embeddingTo (chain : ElementaryChain) (n : Nat) :
    ElemEmbedding (chain.at 0) (chain.at n) := by
  induction n with
  | zero => exact ElemEmbedding.id (chain.at 0)
  | succ n ih =>
    -- ih: M₀ → Mₙ, chain.embedding n: Mₙ → Mₙ₊₁
    -- Compose them
    exact ElemEmbedding.comp (chain.embedding n) ih

/-! ## Elementary Equivalence and Embeddings

Elementary embeddings characterize elementary equivalence
for countable structures (Cantor's theorem generalizes this).
-/

/-- If there is an elementary embedding M → N and an elementary
    embedding N → M, then M ≡ₑ N. (This is trivial: each alone
    already implies elementary equivalence.) -/
theorem backAndForthImpliesElemEquiv {M N : Structure}
    (eMN : ElemEmbedding M N) (eNM : ElemEmbedding N M) :
    ElementarilyEquivalent M N :=
  ElemEmbedding.inducesElemEquiv eMN

/-- The existence of an elementary embedding M → N implies that
    the theory of M is contained in the theory of N. -/
theorem theorySubsetViaEmbedding {M N : Structure}
    (e : ElemEmbedding M N) : ∀ φ, theoryOf M φ → theoryOf N φ := by
  intro φ hφ
  have hM : M.satisfies φ [] := hφ
  exact e.elemPreserving φ [] hM

/-! ## `#eval` Verification -/

/-- Test identity elementary embedding. -/
#eval (idElemEmbedding NatStructure).map 42

/-- Finite order self-embedding preserves identity. -/
#eval (finiteOrderSelfEmbedding 5).map ⟨0, by
  have : 0 < max 5 1 := Nat.lt_of_lt_of_le (Nat.zero_lt_one) (Nat.le_max_right 5 1)
  exact this⟩

/-- Inclusion homomorphism from Fin 2 to Fin 5. -/
#eval (finInclusionHom 2 3).map ⟨0, by
  have : 0 < max 2 1 := Nat.lt_of_lt_of_le (Nat.zero_lt_one) (Nat.le_max_right 2 1)
  exact this⟩

/-- Elementary embedding composition: id ∘ id = id. -/
#eval (elemEmbeddingComp (idElemEmbedding NatStructure) (idElemEmbedding NatStructure)).map 7

/-- The theory subset property: if φ is true in M and M embeds into N,
    then φ is true in N for sentences. -/
#eval theorySubsetViaEmbedding (idElemEmbedding NatStructure) (.prop .true) (by simp [theoryOf, Structure.satisfies])

end MiniOrderEquivalence
