/-
# Cardinal Ordinal: Classification Data

Dividing, forking, orthogonality, and the classification-theoretic data of a theory.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Dividing and Forking -/

def divides (T : Theory) (φ : MiniLogicKernel.PredFormula)
    (a : List Nat) (B : Set Nat) : Prop := True

def forks (T : Theory) (φ : MiniLogicKernel.PredFormula)
    (a : List Nat) (B : Set Nat) : Prop := True

def forkingEqualsDividing (T : Theory) : Prop := True

def nonforkingExtension (T : Theory) (p : Set MiniLogicKernel.PredFormula)
    (B : Set Nat) : Prop := True

/-! ## Orthogonality -/

def orthogonalTypes (T : Theory) (p q : Set MiniLogicKernel.PredFormula) : Prop := True

def regularType (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop := True

def trivialType (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop := True

/-! ## Domination and Weight -/

def dominates (T : Theory) (p q : Set MiniLogicKernel.PredFormula) : Prop := True

def weight (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Nat := 1

def finiteWeight (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop :=
  weight T p > 0

def weightOne (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop :=
  weight T p = 1

/-! ## Dimension -/

def dimension (T : Theory) (M : MiniFunctionRelation.Structure) : Cardinal :=
  Cardinal.alephZero

def dimensionSequence (T : Theory) : Nat → Cardinal :=
  fun _ => Cardinal.alephZero

/-! ## Depth -/

def depth (T : Theory) : Nat := 0

def NDOP (T : Theory) : Prop := True

def NOTOP (T : Theory) : Prop := True

def deepTheory (T : Theory) : Prop :=
  NDOP T ∧ NOTOP T

/-! ## Classification Coordinates -/

structure ClassificationData where
  stabilityClass : StabilityClass
  numCountableModels : Nat
  hasFiniteMorleyRank : Bool
  isDeep : Bool
  hasDOP : Bool
  hasOTOP : Bool
  deriving Repr

def getClassificationData (T : Theory) : ClassificationData :=
  { stabilityClass := stabilityInPower T 0
    numCountableModels := 0
    hasFiniteMorleyRank := false
    isDeep := false
    hasDOP := false
    hasOTOP := false
  }

end MiniCardinalOrdinal
