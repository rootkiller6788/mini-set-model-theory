/-
# Benchmark: Classification Theorems
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def benchClassification : List String :=
  [morleyCategoricity, baldwinLachlan, vaughtsNeverTwo]

def benchClassifiableExample : ClassifiableTheory :=
  ClassifiableTheory.mk "DLO" true "1"

def benchStabilitySpectrum : List String :=
  classificationHierarchy

def benchClassificationData : List ClassificationData :=
  [dloClassificationData, acf0ClassificationData, acfpClassificationData]

def benchMainGap : String := shelahMainGap

def benchStatus : String := classificationProgramStatus

#eval benchClassification : List String
#eval benchClassifiableExample : ClassifiableTheory
#eval benchStabilitySpectrum : List String
#eval benchClassificationData : List ClassificationData
#eval benchMainGap : String
#eval benchStatus : String
