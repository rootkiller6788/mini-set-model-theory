/-
# Cardinal Ordinal: Quotient Constructions

Quotients by definable equivalence relations and interpretations.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Definable Equivalence Relations -/

def definableEquivalenceRelation (T : Theory)
    (E : MiniLogicKernel.PredFormula) : Prop := True

def quotientStructure (M : MiniFunctionRelation.Structure)
    (E : Prop) : MiniFunctionRelation.Structure := M

def quotientMap (M : MiniFunctionRelation.Structure)
    (E : Prop) : ElementaryEmbedding M (quotientStructure M E) :=
  { map := fun x => x
    isElementary := True
  }

/-! ## Quotient and Cardinality -/

def quotientCardinality (M : MiniFunctionRelation.Structure)
    (E : Prop) (κ : Cardinal) : Prop := True

def quotientSmallerCardinal (M : MiniFunctionRelation.Structure)
    (E : Prop) : Prop := True

/-! ## Interpretations -/

def interpretability (T S : Theory) : Prop := True

def mutualInterpretability (T S : Theory) : Prop := True

def biInterpretability (T S : Theory) : Prop := True

/-! ## Stability Under Quotients -/

def stabilityUnderQuotient (T : Theory)
    (E : MiniLogicKernel.PredFormula) : Prop :=
  isStable T → True

def quotientPreservesMorleyRank (T : Theory)
    (E : MiniLogicKernel.PredFormula) : Prop := True

def quotientPreservesCategoricity (T : Theory)
    (E : MiniLogicKernel.PredFormula) (κ : Cardinal) : Prop :=
  isCategoricalInPower T κ → True

/-! ## Imaginary Elements -/

def imaginaryElements (T : Theory) : Prop := True

def hasEliminationOfImaginaries (T : Theory) : Prop := True

def eliminationOfImaginariesImpliesStable (T : Theory) : Prop := True

end MiniCardinalOrdinal
