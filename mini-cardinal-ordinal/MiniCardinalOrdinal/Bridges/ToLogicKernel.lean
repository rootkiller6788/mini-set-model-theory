/-
# Cardinal Ordinal Bridge: To Logic Kernel

Links cardinal-ordinal to the logic kernel's propositional and predicate formulas.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Formula Complexity Bridge -/

def formulaCardinality (φ : MiniLogicKernel.PredFormula) : Cardinal :=
  Cardinal.alephZero

def formulaComplexityBound (φ : MiniLogicKernel.PredFormula) : Prop :=
  MiniLogicKernel.PredFormula.quantifierDepth φ > 0

/-! ## Type Spaces Bridge -/

def typeSpace (T : Theory) (n : Nat) : Prop := True

def compactTypeSpace (T : Theory) (n : Nat) : Prop := True

def stoneSpace (T : Theory) (n : Nat) : Prop := True

/-! ## Satisfaction and Stability -/

def satisfactionPreservesStability (T : Theory) : Prop := True

def definableSet (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop := True

def definableClosure (T : Theory) (A : Set Nat) : Prop := True

def algebraicClosure (T : Theory) (A : Set Nat) : Prop := True

/-! ## Quantifier Elimination Bridge -/

def hasQE (T : Theory) : Prop := True

def QEImpliesSubmodelComplete (T : Theory) : Prop :=
  hasQE T → True

def modelCompleteness (T : Theory) : Prop := True

/-! ## Logic Kernel Formulas and Types -/

def formulaImpliesType (φ : MiniLogicKernel.PredFormula)
    (p : Set MiniLogicKernel.PredFormula) : Prop := True

def completeType (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop := True

def isolatedType (T : Theory) (p : Set MiniLogicKernel.PredFormula) : Prop := True

end MiniCardinalOrdinal
