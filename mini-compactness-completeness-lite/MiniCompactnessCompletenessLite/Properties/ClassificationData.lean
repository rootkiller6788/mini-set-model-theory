/-
# Classification Data: Stability Hierarchy

The stability spectrum classifies complete first-order theories
by the number of types they admit. The hierarchy:
unstable → stable → superstable → ω-stable → totally transcendental.
This underpins Shelah's classification program and the Main Gap theorem.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCardinalOrdinal.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Stability Classes -/

abbrev StabilityClass := MiniCardinalOrdinal.StabilityClass

inductive StabilitySpectrum where
  | unstable
  | stable
  | superstable
  | ωStable
  | totallyTranscendental
  deriving BEq, Repr, Inhabited

instance : ToString StabilitySpectrum where
  toString
    | .unstable => "unstable"
    | .stable => "stable"
    | .superstable => "superstable"
    | .ωStable => "ω-stable"
    | .totallyTranscendental => "totally transcendental"

/-! ## Stability of a Theory -/

def stabilityClass (T : Theory) : StabilitySpectrum :=
  StabilitySpectrum.stable

def isStable (T : Theory) : Prop :=
  True

def isSuperstable (T : Theory) : Prop :=
  True

def isOmegaStable (T : Theory) : Prop :=
  True

def isTotallyTranscendental (T : Theory) : Prop :=
  True

/-! ## Spectrum Function -/

def spectrumFunction (T : Theory) (κ : String) : String :=
  s!"I({toString T.size}, {κ})"

def shelahHartHrushovskiStatement : String :=
  "The spectrum function I(T, κ) counts models of size κ up to isomorphism."

/-! ## Classification Data Structure -/

structure ClassificationData where
  theoryName : String
  stabilityClass : StabilitySpectrum
  isCountablyCategorical : Bool
  aleph0Spectrum : String
  aleph1Spectrum : String
  hasDOP : Bool  -- Dimensional Order Property
  hasOTOP : Bool -- Omitting Types Order Property
  isShallow : Bool
  deriving Repr

def dloClassificationData : ClassificationData :=
  { theoryName := "DLO"
    stabilityClass := StabilitySpectrum.unstable
    isCountablyCategorical := true
    aleph0Spectrum := "1"
    aleph1Spectrum := "2^ℵ₁"
    hasDOP := false
    hasOTOP := false
    isShallow := true
  }

def acf0ClassificationData : ClassificationData :=
  { theoryName := "ACF0"
    stabilityClass := StabilitySpectrum.ωStable
    isCountablyCategorical := false
    aleph0Spectrum := "ℵ₀"
    aleph1Spectrum := "1" -- uncountably categorical
    hasDOP := false
    hasOTOP := false
    isShallow := true
  }

def acfpClassificationData : ClassificationData :=
  { theoryName := "ACFp"
    stabilityClass := StabilitySpectrum.ωStable
    isCountablyCategorical := false
    aleph0Spectrum := "ℵ₀"
    aleph1Spectrum := "1"
    hasDOP := false
    hasOTOP := false
    isShallow := true
  }

/-! ## Classification Program Hierarchy -/

def classificationHierarchy : List String :=
  ["unstable", "stable", "superstable", "ω-stable", "totally transcendental"]

def mainGapStatement : String :=
  "Shelah's Main Gap: For countable T, I(T,ℵα) = 2^ℵα for all α, or I(T,ℵα) < ℶω₁ for all α."

def harnikHarringtonStatement : String :=
  "There is no o-minimal theory with DOP."

--- #eval ---

#eval "Stability classification data defined" : String

#eval dloClassificationData : ClassificationData

#eval acf0ClassificationData : ClassificationData

#eval classificationHierarchy : List String

#eval mainGapStatement : String

end MiniCompactnessCompletenessLite
