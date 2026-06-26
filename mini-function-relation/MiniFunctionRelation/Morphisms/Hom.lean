import MiniFunctionRelation.Core.Basic

namespace MiniFunctionRelation

structure Hom (M N : Structure) where
  map : M.domain → N.domain
  preservesPred : ∀ (p : Nat) (args : List M.domain), M.predInterp p args → N.predInterp p (args.map map)
  preservesConst : ∀ (c : Nat), map (M.constInterp c) = N.constInterp c

def Hom.id (M : Structure) : Hom M M where
  map x := x
  preservesPred _ _ h := h
  preservesConst _ := rfl

def Hom.comp {M N O : Structure} (g : Hom N O) (f : Hom M N) : Hom M O where
  map x := g.map (f.map x)
  preservesPred p args h := g.preservesPred p (args.map f.map) (f.preservesPred p args h)
  preservesConst c := by rw [f.preservesConst, g.preservesConst]

structure Embedding (M N : Structure) extends Hom M N where
  injective : ∀ x y, map x = map y → x = y

structure StrongEmbedding (M N : Structure) extends Embedding M N where
  preservesPredRev : ∀ (p : Nat) (args : List M.domain), N.predInterp p (args.map map) → M.predInterp p args

end MiniFunctionRelation
