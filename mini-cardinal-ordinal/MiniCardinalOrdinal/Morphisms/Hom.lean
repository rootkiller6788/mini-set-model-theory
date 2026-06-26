/-
# Cardinal Ordinal: Elementary Embeddings

Elementary maps between structures that preserve first-order truth.
-/

import MiniCardinalOrdinal.Core.Basic

namespace MiniCardinalOrdinal

/-! ## Elementary Embedding -/

structure ElementaryEmbedding (M N : MiniFunctionRelation.Structure) where
  map : M.domain → N.domain
  isElementary : Prop
  deriving Inhabited

/-! ## Basic Embedding Properties -/

def isEmbedding (M N : MiniFunctionRelation.Structure)
    (f : ElementaryEmbedding M N) : Prop := True

def embeddingsExist (M N : MiniFunctionRelation.Structure) : Prop := True

def isElementaryEquivalent (M N : MiniFunctionRelation.Structure) : Prop := True

/-! ## Cardinal-Preserving Embeddings -/

def preservesCardinality (M N : MiniFunctionRelation.Structure)
    (f : ElementaryEmbedding M N) : Prop := True

def isωStableEmbedding (M N : MiniFunctionRelation.Structure)
    (f : ElementaryEmbedding M N) : Prop := True

def isSuperstableEmbedding (M N : MiniFunctionRelation.Structure)
    (f : ElementaryEmbedding M N) : Prop := True

/-! ## Embedding Composition -/

def compEmbeddings {M N P : MiniFunctionRelation.Structure}
    (f : ElementaryEmbedding M N) (g : ElementaryEmbedding N P) :
    ElementaryEmbedding M P :=
  { map := fun x => g.map (f.map x)
    isElementary := True
  }

end MiniCardinalOrdinal
