import MiniFunctionRelation

namespace MiniFunctionRelation.Bench

/-
# Benchmark: Identity Homomorphism Construction
-/

def BStruct : Structure where
  domain := Nat
  predInterp p args := match p with
    | 0 => args.isEmpty
    | _ => True
  constInterp _ := 0

def bid : Hom BStruct BStruct := Hom.id BStruct

def bidComp : Hom BStruct BStruct := Hom.comp bid bid

theorem bidComp_is_bid : bidComp = bid := Hom.id_comp bid

-- eval examples
#eval "Identity hom benchmark"
#eval bid.map 0
#eval bid.map 42
#eval bidComp.map 100
#eval (Hom.id BStruct).map 7

end MiniFunctionRelation.Bench
