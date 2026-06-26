/-
# ZFC Lite: Zermelo-Fraenkel Axioms with Choice

The 8 ZFC axioms expressed as PredFormula values and as an AxiomSystem.
-/

import MiniLogicKernel.Core.Basic
import MiniLogicKernel.Core.Objects
import MiniAxiomKernel.Core.Basic
import MiniAxiomKernel.Core.Laws

open MiniLogicKernel

namespace MiniZFCLite

def memPred (x y : Nat) : PredFormula := .pred 0 [x, y]

def zfcExtensionality : PredFormula :=
  .all (.all (.impl (.all (.all (.impl
    (.equiv (memPred 3 1) (memPred 3 0)) (.eq 0 1)
  )))))

def zfcEmptySet : PredFormula :=
  .ex (.all (.not (memPred 0 1)))

def zfcPairing : PredFormula :=
  .all (.all (.ex (.all (.equiv (memPred 0 2) (.or (.eq 0 2) (.eq 0 3))))))

def zfcUnion : PredFormula :=
  .all (.ex (.all (.equiv (memPred 0 1) (.ex (.and (memPred 0 2) (memPred 1 3))))))

def zfcPowerSet : PredFormula :=
  .all (.ex (.all (.equiv (memPred 0 1) (.all (.impl (memPred 2 0) (memPred 3 2))))))

def zfcSeparation : PredFormula :=
  .all (.ex (.all (.equiv (memPred 0 1) (.and (memPred 2 3) (.prop (.atom 0))))))

def zfcInfinity : PredFormula :=
  .ex (.and (.ex (.and (.all (.not (memPred 0 1))) (memPred 0 2)))
    (.all (.impl (memPred 0 3) (.ex (.and (memPred 0 4) (.all (.equiv (memPred 1 4)
      (.or (memPred 1 0) (.eq 1 0)))))))))

def zfcChoice : PredFormula :=
  .all (.ex (.all (.impl (.ex (memPred 0 1)) (.ex (.and (memPred 0 2)
    (.ex (.all (.equiv (memPred 1 3) (.and (memPred 1 0) (memPred 1 4))))))))))

def zfcAxiomList : List (String × PredFormula) := [
  ("zfc-extensionality", zfcExtensionality),
  ("zfc-empty", zfcEmptySet),
  ("zfc-pairing", zfcPairing),
  ("zfc-union", zfcUnion),
  ("zfc-power-set", zfcPowerSet),
  ("zfc-separation", zfcSeparation),
  ("zfc-infinity", zfcInfinity),
  ("zfc-choice", zfcChoice)
]

end MiniZFCLite
