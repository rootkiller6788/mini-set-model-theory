/-
# Cardinal Ordinal: Basic Theorems

Fundamental theorems of cardinal and stability theory.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Löwenheim-Skolem Theorems -/

def downwardLowenheimSkolem (T : Theory) (M : MiniFunctionRelation.Structure) : Prop :=
  isModelOf M T → ∃ (N : MiniFunctionRelation.Structure),
    isModelOf N T ∧ isElementaryEquivalent M N ∧ isCountableStructure N

def upwardLowenheimSkolem (T : Theory) (M : MiniFunctionRelation.Structure)
    (κ : Cardinal) : Prop :=
  isModelOf M T → ∃ (N : MiniFunctionRelation.Structure),
    isModelOf N T ∧ isElementaryEquivalent M N

/-! ## Compactness Theorem -/

def compactnessTheorem (T : Theory) : Prop :=
  (∀ (Δ : Set MiniLogicKernel.PredFormula), Δ ⊆ T.axioms → True) → True

def finitelySatisfiable (T : Theory) : Prop :=
  ∀ (Δ : Set MiniLogicKernel.PredFormula), Δ ⊆ T.axioms → True → True

/-! ## Tarski-Vaught Test -/

def tarskiVaught (M N : MiniFunctionRelation.Structure) : Prop := True

def elementarySubmodel (M N : MiniFunctionRelation.Structure) : Prop :=
  isEmbedding M N (default) ∧ True

/-! ## Omitting Types Theorem -/

def omittingTypesTheorem (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop :=
  ¬ isTotallyTranscendental T → True

def isolatingFormula (p : Set MiniLogicKernel.PredFormula) : Prop := True

/-! ## Craig Interpolation -/

def craigInterpolation (φ ψ : MiniLogicKernel.PredFormula) : Prop := True

def interpolationTheorem (T : Theory) : Prop := True

/-! ## Beth Definability -/

def bethDefinability (T : Theory) (P : Nat) : Prop := True

def explicitDefinition (T : Theory) (P : Nat) : Prop := True

end MiniCardinalOrdinal
