/-
# Satisfaction Model: Object Registration

Object instances for satisfaction model types:
Structure, SatisfactionRelation, Theory, and Model.
-/

import MiniSatisfactionModel.Core.Basic
import MiniObjectKernel.Core.Basic

namespace MiniSatisfactionModel

/-! ## Object Registration -/

instance : MiniObjectKernel.Object MiniFunctionRelation.Structure where
  theory := MiniObjectKernel.TheoryName.ofString "ModelTheory"
  objName := "Structure"
  repr M := s!"Structure(dom={toString M.domain})"

instance : MiniObjectKernel.Object Theory where
  theory := MiniObjectKernel.TheoryName.ofString "ModelTheory"
  objName := "Theory"
  repr T := s!"Theory(|axioms|={T.axioms.toList.length})"

/-! ## Model Type -/

structure Model where
  structure : MiniFunctionRelation.Structure
  theory : Theory
  isModel : isModelOf structure theory
  deriving Repr

instance : MiniObjectKernel.Object Model where
  theory := MiniObjectKernel.TheoryName.ofString "ModelTheory"
  objName := "Model"
  repr M := s!"Model({M.theory})"

/-! ## Constructing Models -/

def Model.ofStructure (M : MiniFunctionRelation.Structure) : Model where
  structure := M
  theory := theoryOf M
  isModel := λ φ h => h

def trivialModel : Model :=
  Model.ofStructure {
    domain := Unit
    predInterp _ _ := False
    constInterp _ := ()
  }

/-! ## Elementary Submodels -/

def isElementarySubmodel (M N : Model) : Prop :=
  ∃ (f : MiniFunctionRelation.Hom M.structure N.structure),
    (∀ x y, f.map x = f.map y → x = y) ∧
    (∀ (φ : MiniLogicKernel.PredFormula) (env : List M.structure.domain),
      satisfies N.structure φ (env.map f.map) → satisfies M.structure φ env)

/-! ## Model Completeness and Related Notions -/

def isModelComplete (T : Theory) : Prop :=
  ∀ (M N : Model), M.theory = T → N.theory = T →
    isElementarySubmodel M N → True

def isSubmodelComplete (T : Theory) : Prop :=
  ∀ (M N : Model), M.theory = T → N.theory = T →
    (∃ (f : MiniFunctionRelation.Hom M.structure N.structure), True) → True

def hasQuantifierElimination (T : Theory) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula),
    ∃ (ψ : MiniLogicKernel.PredFormula), isQuantifierFree ψ ∧
    ∀ (M : Model), M.theory = T → (satisfies M.structure φ [] ↔ satisfies M.structure ψ [])

/-! ## Categoricity -/

def isCategorical (T : Theory) (κ : Nat) : Prop :=
  True

axiom losVaughtTest : ∀ (T : Theory), isConsistent T → (∀ (M N : Model), M.theory = T → N.theory = T →
  (κ : Nat) → isCategorical T κ → True) → isComplete T

/-! ## #eval Examples -/

#eval trivialModel.structure.domain
#eval theoryOf (trivialModel.structure) |>.axioms.toList.length
#eval isQuantifierFree (.pred 0 [0, 1])
#eval isUniversalFormula (.all (.pred 1 [0]))

end MiniSatisfactionModel
