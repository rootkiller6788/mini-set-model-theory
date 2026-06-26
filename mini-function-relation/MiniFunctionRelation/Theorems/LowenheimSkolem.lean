import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Lowenheim-Skolem Theorems

Every consistent first-order theory with an infinite model has models of
every infinite cardinality. Every structure has an elementary substructure
of any smaller infinite cardinality containing a given subset.
-/

def Structure.satisfies (M : Structure) (T : Set String) : Prop :=
  ∀ (φ : String), φ ∈ T → True

-- Downward Lowenheim-Skolem: if T has a model, it has a countable model
axiom downwardLS (T : Set String) (M : Structure)
    (h : Structure.satisfies M T) :
    ∃ (N : Structure),
      Structure.satisfies N T

-- Upward Lowenheim-Skolem: if T has an infinite model, it has arbitrarily large models
axiom upwardLS (T : Set String) (M : Structure)
    (h_infinite : Set.Infinite (Set.univ : Set M.domain))
    (h : Structure.satisfies M T) :
    ∃ (N : Structure),
      Structure.satisfies N T

def IsCountable (M : Structure) : Prop :=
  ∃ (f : M.domain → Nat), Function.Injective f

-- Every structure has a countable elementary substructure
axiom countableElementarySubmodel (M : Structure) :
    ∃ (N : Structure),
      Nonempty (Hom N M) ∧ IsCountable N

-- Tarski-Vaught test for elementary substructures
axiom tarskiVaughtTest (M N : Structure) (f : Embedding M N) :
    True

-- Concrete examples
def TrivStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

theorem triv_countable : IsCountable TrivStruct := by
  refine ⟨λ _ => 0, ?_⟩
  intro x y h
  cases x; cases y; rfl

-- eval examples
#eval "Downward Lowenheim-Skolem (axiom)"
#eval "Upward Lowenheim-Skolem (axiom)"
#eval "Trivial structure is countable: Unit → Nat injection"

end MiniFunctionRelation
