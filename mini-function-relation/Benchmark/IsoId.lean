import MiniFunctionRelation

namespace MiniFunctionRelation.Bench

/-
# Benchmark: Identity Isomorphism Construction
-/

def BIStruct : Structure where
  domain := Fin 10
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def biid : Iso BIStruct BIStruct := Iso.id BIStruct

def biidComp : Iso BIStruct BIStruct := Iso.comp biid biid

-- eval examples
#eval "Identity iso benchmark"
#eval biid.toHom.map 3
#eval biid.toHom.map 7
#eval biidComp.toHom.map 5
#eval (Iso.id BIStruct).toHom.map 0

end MiniFunctionRelation.Bench
