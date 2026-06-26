/-
# Order Equivalence: Elementary Embeddings

Elementary embeddings between first-order structures:
maps that preserve all first-order formulas.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Elementary Embeddings

An elementary embedding is a map between structures that preserves
the truth of all first-order formulas.

Properties:
- Elementary embeddings imply elementary equivalence of the image
- Composition of elementary embeddings is an elementary embedding
- The inclusion of an elementary substructure is an elementary embedding
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- An elementary embedding from M to N is a map that preserves all formulas. -/
structure ElemEmbedding (M N : Structure) where
  map : M.domain → N.domain
  elemPreserving : ∀ (φ : PredFormula) (env : List M.domain),
    M.satisfies φ env → N.satisfies φ (env.map map)

/-- Identity elementary embedding. -/
def ElemEmbedding.id (M : Structure) : ElemEmbedding M M where
  map x := x
  elemPreserving φ env hM := hM

/-- Composition of elementary embeddings. -/
def ElemEmbedding.comp {M N O : Structure}
    (g : ElemEmbedding N O) (f : ElemEmbedding M N) : ElemEmbedding M O where
  map x := g.map (f.map x)
  elemPreserving φ env hM :=
    g.elemPreserving φ (env.map f.map) (f.elemPreserving φ env hM)

/-- Every elementary embedding is a homomorphism. -/
def ElemEmbedding.toHom (M N : Structure) (e : ElemEmbedding M N) :
    MiniFunctionRelation.Hom M N where
  map := e.map
  preservesPred p args h :=
    e.elemPreserving (.pred p (args.mapIdx fun i _ => i)) args h
  preservesConst c := rfl

/-- An elementary embedding preserves the truth of quantifier-free formulas
    in both directions (it reflects them from the image back). -/
def ElemEmbedding.reflects (e : ElemEmbedding M N) : Prop :=
  ∀ (φ : PredFormula) (env : List M.domain),
    N.satisfies φ (env.map e.map) → M.satisfies φ env

/-! ## Concrete orders for examples -/

/-- The natural numbers with their usual order. -/
def NatOrder : Structure := NatStructure

/-- The integers with their usual order. -/
def IntOrder : Structure := IntStructure

/-- The embedding from Nat to Int via the natural inclusion. -/
def NatEmbedInt : ElemEmbedding NatOrder IntOrder where
  map n := (n : Int)
  elemPreserving _ _ h := h

/-- A constant embedding (maps everything to a fixed element). -/
def ConstEmbedding (M N : Structure) (c : N.domain) : ElemEmbedding M N where
  map _ := c
  elemPreserving _ _ _ := trivial

/-- A self-embedding that is an automorphism candidate (identity on Nat). -/
def NatIdentityEmbedding : ElemEmbedding NatOrder NatOrder := ElemEmbedding.id NatOrder

/-- A finite order on `Fin n`. -/
def FinOrder (n : Nat) : Structure := FinOrderStructure n

/-- The inclusion Fin k → Fin (k+m). -/
def FinEmbedding (k m : Nat) : ElemEmbedding (FinOrder k) (FinOrder (k + m)) where
  map x := ⟨x.val, by
    have h : x.val < k := x.isLt
    have h' : k ≤ k + m := Nat.le_add_right k m
    exact Nat.lt_of_lt_of_le h h'
  ⟩
  elemPreserving _ _ h := h

/-! ## `#eval` Examples -/

/-- Identity embedding on NatOrder preserves 42 -/
#eval (ElemEmbedding.id NatOrder).map 42

/-- Nat-to-Int embedding maps 5 to (5 : Int) -/
#eval NatEmbedInt.map 5

/-- Compose identity with NatEmbedInt -/
#eval (ElemEmbedding.comp (ElemEmbedding.id IntOrder) NatEmbedInt).map 3

/-- Check that const embedding maps anything to 0 -/
#eval (ConstEmbedding NatOrder NatOrder 0).map 42

end MiniOrderEquivalence
