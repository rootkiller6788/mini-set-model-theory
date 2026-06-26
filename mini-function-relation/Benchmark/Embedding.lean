import MiniFunctionRelation

namespace MiniFunctionRelation.Bench

/-
# Benchmark: Embedding Construction
-/

def EmbStruct1 : Structure where
  domain := Fin 5
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def EmbStruct2 : Structure where
  domain := Fin 10
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def emb_12 : Embedding EmbStruct1 EmbStruct2 where
  map x := x
  preservesPred p args h := by
    simp [EmbStruct1, EmbStruct2] at h ⊢
    exact h
  preservesConst c := by simp [EmbStruct1, EmbStruct2]
  injective x y h := by
    have := Fin.ext_iff.mp h
    apply Fin.ext
    exact this

-- A strong embedding (predicate-reflecting) is an iso for pure sets
def strong_emb : StrongEmbedding EmbStruct1 EmbStruct1 where
  toHom := Hom.id EmbStruct1
  injective x y h := h
  preservesPredRev p args h := h

-- eval examples
#eval "Embedding benchmark"
#eval emb_12.map 2
#eval emb_12.map 3
#eval strong_emb.map 0
#eval "Strong embedding preserves and reflects predicates"

end MiniFunctionRelation.Bench
