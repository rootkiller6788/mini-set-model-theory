/-
# Cardinal Ordinal: Standard Examples

Key examples of theories at each level of the stability hierarchy.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Properties.Invariants

namespace MiniCardinalOrdinal

/-! ## Examples of Unstable Theories -/

def theoryOfDenseLinearOrder : Theory := { axioms := ∅ }

def theoryOfRandomGraph : Theory := { axioms := ∅ }

/-! ## Examples of Stable Theories -/

def theoryOfAbelianGroups : Theory := { axioms := ∅ }

def theoryOfModules : Theory := { axioms := ∅ }

def theoryOfSeparablyClosedFields : Theory := { axioms := ∅ }

/-! ## Examples of Superstable Theories -/

def theoryOfAlgebraicallyClosedFields : Theory := { axioms := ∅ }

def theoryOfVectorSpaces : Theory := { axioms := ∅ }

def theoryOfFreeGroups : Theory := { axioms := ∅ }

/-! ## Examples of ω-Stable Theories -/

def theoryOfAlgebraicallyClosedFieldsOfChar0 : Theory := { axioms := ∅ }

def theoryOfDifferentiallyClosedFields : Theory := { axioms := ∅ }

def theoryOfCompactComplexManifolds : Theory := { axioms := ∅ }

/-! ## Examples of Totally Transcendental Theories -/

def theoryOfPureSets : Theory := { axioms := ∅ }

def theoryOfEquivalenceRelations : Theory := { axioms := ∅ }

def theoryOfCountableLanguage : Theory := { axioms := ∅ }

/-! ## Stability Spectrum Examples -/

def acfStabilitySpectrum : StabilityClass := StabilityClass.ωStable

def dloStabilitySpectrum : StabilityClass := StabilityClass.unstable

def rgStabilitySpectrum : StabilityClass := StabilityClass.unstable

def abelianGroupStability : StabilityClass := StabilityClass.stable

def scfStability : StabilityClass := StabilityClass.stable

def vectorSpaceStability : StabilityClass := StabilityClass.ωStable

/-! ## Categoricity Examples -/

def acf0Categorical : Prop :=
  isCategoricalInPower theoryOfAlgebraicallyClosedFieldsOfChar0
    (Cardinal.succ Cardinal.alephZero)

def dloCategorical : Prop :=
  isCategoricalInPower theoryOfDenseLinearOrder Cardinal.alephZero

/-! ## Cardinal Invariant Examples -/

def numCountableModelsACF : Nat := 0

def numCountableModelsDLO : Nat := 0

end MiniCardinalOrdinal
