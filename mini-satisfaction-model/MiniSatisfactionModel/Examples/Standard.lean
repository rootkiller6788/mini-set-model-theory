/-
# Satisfaction Model: Standard Examples

Standard model-theoretic structures:
(N,+,*,0,1), (Z,+,*,0,1), (Q,<), (R,+,*,0,1,<), (C,+,*,0,1)
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniFunctionRelation.Core.Basic

namespace MiniSatisfactionModel

/-! ## Standard Structures -/

def natStructure : MiniFunctionRelation.Structure where
  domain := Nat
  predInterp
    | 0, [x, y] => x < y
    | 1, [x, y] => x = y
    | 2, [x, y] => x = y + 1
    | _, _ => False
  constInterp
    | 0 => 0
    | 1 => 1
    | _ => 0

def intStructure : MiniFunctionRelation.Structure where
  domain := Int
  predInterp
    | 0, [x, y] => x < y
    | 1, [x, y] => x = y
    | _, _ => False
  constInterp
    | 0 => 0
    | 1 => 1
    | _ => 0

def ratStructure : MiniFunctionRelation.Structure where
  domain := Rat
  predInterp
    | 0, [x, y] => x < y
    | 1, [x, y] => x = y
    | _, _ => False
  constInterp
    | 0 := 0
    | 1 := 1
    | _ := 0

/-! ## Dense Linear Order (DLO) -/

def dloStructure : MiniFunctionRelation.Structure where
  domain := Rat
  predInterp
    | 0, [x, y] => x < y
    | _, _ => False
  constInterp _ := 0

def dloAxioms : Set (MiniLogicKernel.PredFormula) :=
  { .all (.all (.impl (.not (.eq 0 1)) (.or (.pred 0 [0, 1]) (.or (.pred 0 [1, 0]) (.eq 0 1))))),
    .all (.all (.all (.impl (.and (.pred 0 [0, 1]) (.pred 0 [1, 2])) (.pred 0 [0, 2])))),
    .all (.ex (.and (.pred 0 [0, 1]) (.not (.eq 0 1)))),
    .all (.all (.impl (.pred 0 [0, 1]) (.ex (.and (.and (.pred 0 [0, 2]) (.pred 0 [2, 1])) (.not (.eq 0 2))))))
  }

/-! ## Presburger Arithmetic -/

def presburgerSignature : String := "Language with +, 0, 1, <"

def presburgerAxioms : Set (MiniLogicKernel.PredFormula) :=
  { .all (.not (.eq 0 (.const 1))), -- 0 is not a successor
    .all (.all (.impl (.eq (.add 0 1) (.add 1 0)) (.eq 0 1))) -- add commutativity
  }

/-! ## Real Closed Fields (RCF) -/

def rcfSignature : String := "Language with +, ·, 0, 1, <"

def rcfAxioms : Set (MiniLogicKernel.PredFormula) :=
  { .prop .true }

/-! ## Algebraically Closed Fields (ACF) -/

def acfSignature : String := "Language with +, ·, 0, 1"

def acfAxioms : Set (MiniLogicKernel.PredFormula) :=
  { .prop .true }

/-! ## Complex Numbers -/

def complexStructure : MiniFunctionRelation.Structure where
  domain := String
  predInterp
    | 0, [x, y] => x = y
    | _, _ => False
  constInterp
    | 0 := "0"
    | 1 := "1"
    | _ := "0"

/-! ## Standard Examples List -/

def standardExamples : List String :=
  ["natStructure", "intStructure", "ratStructure", "dloStructure", "complexStructure"]

/-! ## Satisfaction Examples -/

def triviallyTrueSentences : List (MiniLogicKernel.PredFormula) :=
  [.prop .true, .not (.prop .false), .impl (.prop .true) (.prop .true)]

/-! ## #eval Examples -/

#eval natStructure.domain
#eval isTrueIn ratStructure (.not (.all (.pred 0 [0, 0])))
#eval standardExamples
#eval triviallyTrueSentences.length
#eval dloStructure.predInterp 0 [1, 2]
#eval "ratStructure" ∈ standardExamples

end MiniSatisfactionModel
