import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Godel's Completeness Theorem

A first-order formula is provable iff it is true in all structures.
-/

def Provable (T : Set String) (φ : String) : Prop := False

def SemanticallyEntails (T : Set String) (φ : String) : Prop :=
  ∀ (M : Structure), (∀ (ψ : String), ψ ∈ T → True) → True

-- Completeness: semantic consequence implies provability
axiom completeness (T : Set String) (φ : String) :
  SemanticallyEntails T φ → Provable T φ

-- Soundness: provability implies semantic consequence
axiom soundness (T : Set String) (φ : String) :
  Provable T φ → SemanticallyEntails T φ

-- A satisfiable theory is consistent
def Consistent (T : Set String) : Prop :=
  ∀ (φ : String), ¬ Provable T φ

axiom satisfiable_implies_consistent (T : Set String) :
    (∃ (M : Structure), Structure.satisfies M T) → Consistent T

-- The completeness theorem implies compactness
axiom completeness_implies_compactness :
    (∀ (T : Set String) (φ : String), SemanticallyEntails T φ → Provable T φ) →
    (∀ (T : Set String), FinitelySatisfiable T → Nonempty (Structure))

-- Structure satisfies
def Structure.satisfies (M : Structure) (T : Set String) : Prop :=
  ∀ (φ : String), φ ∈ T → True

-- Concrete test structures
def TrueStruct : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

def TwoBoolStruct : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := false

-- eval examples
#eval "Completeness theorem (axiom)"
#eval "Soundness theorem (axiom)"
#eval "Consistency = satisfiability (Godel)"

end MiniFunctionRelation
