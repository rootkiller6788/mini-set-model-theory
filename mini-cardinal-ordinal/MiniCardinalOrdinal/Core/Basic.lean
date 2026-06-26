/-
# Cardinal Ordinal: Stability and Classification

Cardinal invariants, categoricity, stability classes, and the classification spectrum.
-/

import MiniFunctionRelation.Core.Basic

namespace MiniCardinalOrdinal

inductive StabilityClass where
  | unstable
  | stable
  | superstable
  | ωStable
  | totallyTranscendental
  deriving BEq, Repr, Inhabited

instance : ToString StabilityClass where
  toString
    | .unstable => "unstable"
    | .stable => "stable"
    | .superstable => "superstable"
    | .ωStable => "ω-stable"
    | .totallyTranscendental => "totally transcendental"

def cardOf (M : MiniFunctionRelation.Structure) : String :=
  s!"|{toString M.domain}|"

def isFiniteStructure (M : MiniFunctionRelation.Structure) : Prop := True
def isCountableStructure (M : MiniFunctionRelation.Structure) : Prop := True

structure Theory where
  axioms : Set MiniLogicKernel.PredFormula

def isComplete (T : Theory) : Prop := True
def isModelOf (M : MiniFunctionRelation.Structure) (T : Theory) : Prop := True

def κCategorical (T : Theory) (κ : Nat) : Prop := True

structure MorleyRank where
  value : Nat
  deriving Repr

end MiniCardinalOrdinal
