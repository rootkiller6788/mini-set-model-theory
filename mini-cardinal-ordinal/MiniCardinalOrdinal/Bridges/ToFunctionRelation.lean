/-
# Cardinal Ordinal Bridge: To Function Relation

Links cardinal-ordinal invariants to function-relation structure theory.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Structure Cardinality Bridge -/

def structureCardEq (M : MiniFunctionRelation.Structure) (κ : Cardinal) : Prop := True

def countableStructureHasAlephZero (M : MiniFunctionRelation.Structure) : Prop :=
  isCountableStructure M → structureCardEq M Cardinal.alephZero

def finiteStructureCardEq (M : MiniFunctionRelation.Structure) (n : Nat) : Prop := True

/-! ## Stability from Structure Properties -/

def stableIfInterpretable (T S : Theory) : Prop := True

def stabilityUnderBiInterpretable (T S : Theory) : Prop := True

def stableGroup (T : Theory) : Prop := isStable T

def stableField (T : Theory) : Prop := isStable T

/-! ## Function Relation Classification -/

def classifyStructure (M : MiniFunctionRelation.Structure) : StabilityClass :=
  StabilityClass.stable

def structureIsStable (M : MiniFunctionRelation.Structure) : Prop := True

def structureIsSuperstable (M : MiniFunctionRelation.Structure) : Prop := True

def structureIsOmegaStable (M : MiniFunctionRelation.Structure) : Prop := True

/-! ## Cardinality Comparison Bridge -/

def cardOfEqStructCard (M : MiniFunctionRelation.Structure) : Prop := True

def typesOverSetBridge (M N : MiniFunctionRelation.Structure) : Prop := True

end MiniCardinalOrdinal
