import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniFunctionRelation

/-
# Structural Laws

Homs form a category: identity, associativity of composition,
and functoriality constraints for Embedding / StrongEmbedding.
-/

@[ext]
theorem Hom.ext {M N : Structure} {f g : Hom M N} (h : ∀ x, f.map x = g.map x) : f = g := by
  cases f; cases g; congr
  · funext x; exact h x
  · apply Subsingleton.elim
  · apply Subsingleton.elim

theorem Hom.id_comp {M N : Structure} (f : Hom M N) : Hom.comp (Hom.id N) f = f := by
  apply Hom.ext; intro x; rfl

theorem Hom.comp_id {M N : Structure} (f : Hom M N) : Hom.comp f (Hom.id M) = f := by
  apply Hom.ext; intro x; rfl

theorem Hom.comp_assoc {M N O P : Structure} (h : Hom O P) (g : Hom N O) (f : Hom M N) :
    Hom.comp (Hom.comp h g) f = Hom.comp h (Hom.comp g f) := by
  apply Hom.ext; intro x; rfl

theorem Hom.map_id {M : Structure} (x : M.domain) : (Hom.id M).map x = x := rfl

theorem Hom.map_comp {M N O : Structure} (g : Hom N O) (f : Hom M N) (x : M.domain) :
    (Hom.comp g f).map x = g.map (f.map x) := rfl

theorem Embedding.injective_is {M N : Structure} (e : Embedding M N) (x y : M.domain)
    (h : e.map x = e.map y) : x = y :=
  e.injective x y h

theorem Embedding.toHom_injective {M N : Structure} (e : Embedding M N) :
    Function.Injective (e.toHom.map) :=
  e.injective

theorem Embedding.map_inj {M N : Structure} (e : Embedding M N) {x y : M.domain}
    (h : e.map x = e.map y) : x = y :=
  e.injective x y h

theorem StrongEmbedding.reflectsPred {M N : Structure} (se : StrongEmbedding M N) (p : Nat)
    (args : List M.domain) (h : N.predInterp p (args.map se.map)) : M.predInterp p args :=
  se.preservesPredRev p args h

theorem StrongEmbedding.preserves_and_reflects {M N : Structure} (se : StrongEmbedding M N)
    (p : Nat) (args : List M.domain) : M.predInterp p args ↔ N.predInterp p (args.map se.map) := by
  constructor
  · apply se.preservesPred p args
  · apply se.preservesPredRev p args

-- concrete test structures
def trivStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def boolStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [true] => True
    | _, _ => False
  constInterp _ := false

def boolSwapHom : Hom boolStruct boolStruct where
  map b := !b
  preservesPred p args h := by
    simp [boolStruct] at h ⊢
    cases p; cases args; simp at h; cases h; decide
  preservesConst _ := rfl

def boolEmb : Embedding boolStruct boolStruct where
  toHom := Hom.id boolStruct
  injective x y h := h

theorem comp_law_test : Hom.comp (Hom.id boolStruct) (Hom.id boolStruct) = Hom.id boolStruct :=
  Hom.id_comp (Hom.id boolStruct)

-- eval examples
#eval "Laws: id_comp, comp_id, comp_assoc"

#eval (Hom.id boolStruct).map true
#eval (Hom.id boolStruct).map false
#eval (Hom.comp (Hom.id boolStruct) (Hom.id boolStruct)).map true
#eval boolSwapHom.map true
#eval boolSwapHom.map false
#eval (Hom.comp boolSwapHom boolSwapHom).map true

end MiniFunctionRelation
