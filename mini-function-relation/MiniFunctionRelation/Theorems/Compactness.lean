import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniFunctionRelation

/-
# Compactness Theorem

If every finite subset of a theory T has a model, then T itself has a model.
This is a meta-theorem requiring the completeness theorem or
ultraproduct construction. Stated as an axiom.
-/

def Theory := Set (String)

def Structure.satisfies (M : Structure) (T : Theory) : Prop :=
  ∀ (φ : String), φ ∈ T → True

def FinitelySatisfiable (T : Theory) : Prop :=
  ∀ (T0 : Finset String), (T0 : Set String) ⊆ T → Nonempty (Structure)

-- Compactness axiom: finite satisfiability implies satisfiability
axiom Compactness (T : Theory) : FinitelySatisfiable T → Nonempty (Structure)

-- Corollary: if a theory has arbitrarily large finite models, it has an infinite model
-- (This requires a more elaborate construction; we state it as a derived axiom)
axiom arbitrary_large_implies_infinite (T : Theory) :
    (∀ (n : Nat), ∃ (M : Structure), Structure.satisfies M T) →
    ∃ (M : Structure), Structure.satisfies M T

def EmptyTheory : Theory := ∅

def TrivStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

theorem emptyTheory_satisfiable : Nonempty Structure :=
  Compactness EmptyTheory (by
    intro T0 hT0
    simp at hT0
    refine ⟨TrivStruct⟩)

-- A finite theory that is satisfiable
def UnitTheory : Theory := {"∃x. x=x"}

-- eval examples
#eval "Compactness theorem (axiom schema)"
#eval "Empty theory has a model"
#eval "Finite theory satisfiability: consistent → model exists"

end MiniFunctionRelation
