/-
# Satisfaction Model: Universal Properties

Universal properties of model-theoretic constructions:
products, coproducts, initial/terminal structures, and saturation.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Constructions.Product
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Terminal Structure (Singleton) -/

def singletonStructure : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

theorem singletonIsTerminal (M : MiniFunctionRelation.Structure) :
    Nonempty (MiniFunctionRelation.Hom M singletonStructure) := by
  refine ⟨{
    map := λ _ => ()
    preservesPred p args h := by simp [singletonStructure]
    preservesConst _ := rfl
  }⟩

/-! ## Initial Structure (Empty) -/

def emptyStructure : MiniFunctionRelation.Structure where
  domain := Empty
  predInterp _ _ := False
  constInterp c := Empty.rec _ c

theorem emptyIsInitial (M : MiniFunctionRelation.Structure) [Nonempty M.domain] :
    Nonempty (MiniFunctionRelation.Hom emptyStructure M) := by
  refine ⟨{
    map := λ e => Empty.rec _ e
    preservesPred p args h := by
      exfalso
      -- args is empty since domain is Empty
      exact h
    preservesConst c := Empty.rec _ c
  }⟩

/-! ## Product Universal Property -/

theorem productUniversalProperty (M N O : MiniFunctionRelation.Structure)
    (f : MiniFunctionRelation.Hom O M) (g : MiniFunctionRelation.Hom O N) :
    Nonempty (MiniFunctionRelation.Hom O (productStructure M N)) := by
  refine ⟨{
    map := λ x => (f.map x, g.map x)
    preservesPred p args h := by
      simp [productStructure]
      exact ⟨f.preservesPred p args h, g.preservesPred p args h⟩
    preservesConst c := by
      simp [productStructure, f.preservesConst, g.preservesConst]
  }⟩

/-! ## Saturation as a Universal Property -/

def isUniversalDomain (M : Model) : Prop :=
  ∀ (N : Model), M.theory = N.theory → ∃ (e : Embedding N.structure M.structure), True

axiom saturatedModelsAreUniversal : ∀ (M : Model) (κ : Nat),
    isSaturated M κ → isUniversalDomain M

/-! ## Homogeneous Models -/

def isHomogeneousUniversal (M : Model) : Prop :=
  isHomogeneous M ∧ isUniversalDomain M

axiom uniqueCountableHomogeneousUniversal : ∀ (T : Theory),
    isCompleteTheory T → ∃! (M : Model) (upToIso : Iso M.structure M.structure),
      M.theory = T ∧ isHomogeneousUniversal M

/-! ## Amalgamation Property -/

def hasAmalgamation (T : Theory) : Prop :=
  ∀ (M0 M1 M2 : Model), M0.theory = T → M1.theory = T → M2.theory = T →
    (∃ (e1 : Embedding M0.structure M1.structure), True) →
    (∃ (e2 : Embedding M0.structure M2.structure), True) →
    ∃ (M3 : Model) (f1 : Embedding M1.structure M3.structure) (f2 : Embedding M2.structure M3.structure),
      True

/-! ## Joint Embedding Property -/

def hasJointEmbedding (T : Theory) : Prop :=
  ∀ (M1 M2 : Model), M1.theory = T → M2.theory = T →
    ∃ (M3 : Model) (f1 : Embedding M1.structure M3.structure) (f2 : Embedding M2.structure M3.structure),
      True

/-! ## #eval Examples -/

#eval singletonStructure.domain
#eval productUniversalProperty singletonStructure singletonStructure singletonStructure
    (singletonIsTerminal singletonStructure).some
    (singletonIsTerminal singletonStructure).some
#eval isUniversalDomain trivialModel
#eval hasJointEmbedding (theoryOf singletonStructure)

end MiniSatisfactionModel
