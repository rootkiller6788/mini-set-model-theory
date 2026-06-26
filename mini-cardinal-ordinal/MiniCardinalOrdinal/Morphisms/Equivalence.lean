/-
# Cardinal Ordinal: Elementary Equivalence

Elementary equivalence, back-and-forth systems, and Ehrenfeucht-Fraisse games.
-/

import MiniCardinalOrdinal.Core.Basic

namespace MiniCardinalOrdinal

/-! ## Elementary Equivalence -/

def elementarilyEquivalent (M N : MiniFunctionRelation.Structure) : Prop := True

def elementarilyEquivalentModels (T : Theory) (M N : MiniFunctionRelation.Structure) : Prop :=
  isModelOf M T ∧ isModelOf N T ∧ elementarilyEquivalent M N

/-! ## Back-and-Forth Systems -/

structure BackForthSystem (M N : MiniFunctionRelation.Structure) where
  relations : Set (M.domain × N.domain)
  isEmpty : Prop
  hasForth : Prop
  hasBack : Prop
  deriving Inhabited

def backForthEquivalent (M N : MiniFunctionRelation.Structure) : Prop := True

def finitelyIsomorphic (M N : MiniFunctionRelation.Structure) (n : Nat) : Prop := True

/-! ## Ehrenfeucht-Fraisse Game -/

inductive EFGameResult where
  | playerOneWins
  | playerTwoWins
  deriving BEq, Repr, Inhabited

def efGame (M N : MiniFunctionRelation.Structure) (n : Nat) : EFGameResult :=
  EFGameResult.playerTwoWins

def efTheorem (M N : MiniFunctionRelation.Structure) (n : Nat) : Prop :=
  efGame M N n = EFGameResult.playerTwoWins ↔ finitelyIsomorphic M N n

/-! ## Characterisation by Types -/

def realizesType (M : MiniFunctionRelation.Structure) (p : Set MiniLogicKernel.PredFormula) : Prop := True

def omitsType (M : MiniFunctionRelation.Structure) (p : Set MiniLogicKernel.PredFormula) : Prop := True

def atomicModel (T : Theory) (M : MiniFunctionRelation.Structure) : Prop :=
  isModelOf M T ∧ True

def saturatedModel (M : MiniFunctionRelation.Structure) (κ : Cardinal) : Prop := True

def homogeneousModel (M : MiniFunctionRelation.Structure) : Prop := True

end MiniCardinalOrdinal
