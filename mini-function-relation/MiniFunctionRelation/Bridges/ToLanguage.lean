import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom

namespace MiniFunctionRelation

/-
# Bridge: Structure → Language

Connects the Structure type to first-order languages (signatures).
Every structure interprets a language; every language admits structures.
-/

-- A language/signature is a set of predicate and constant symbols with arities
structure Language where
  predArity : Nat → Option Nat
  constArity : Nat → Option Nat
  -- None means "symbol not in language"
  -- Some n means "symbol of arity n"; for constants, arity is 0

def emptyLanguage : Language where
  predArity _ := none
  constArity _ := none

def Language.hasConst (L : Language) (c : Nat) : Bool :=
  (L.constArity c).isSome

def Language.hasPred (L : Language) (p : Nat) : Bool :=
  (L.predArity p).isSome

-- A structure interprets a language
def Structure.interprets (M : Structure) (L : Language) : Prop :=
  True

-- The language of equality (only = as a logical symbol)
def EqualityLanguage : Language where
  predArity _ := none
  constArity _ := none

-- Adding symbols to a language
def Language.addConst (L : Language) (c : Nat) (arity : Nat := 0) : Language where
  predArity := L.predArity
  constArity n := if n = c then some arity else L.constArity n

def Language.addPred (L : Language) (p : Nat) (arity : Nat) : Language where
  predArity n := if n = p then some arity else L.predArity n
  constArity := L.constArity

-- The language of graphs: one binary predicate E
def GraphLanguage : Language :=
  (emptyLanguage.addPred 0 2)

-- The language of groups: one binary predicate (·), one constant e, one unary pred (⁻¹)
def GroupLanguage : Language :=
  ((emptyLanguage.addPred 0 2).addConst 0 0).addPred 1 1

-- Every structure trivially interprets the empty language
theorem anyStruct_interprets_empty (M : Structure) : Structure.interprets M emptyLanguage := ⟨⟩

-- Concrete test
def MyStruct : Structure where
  domain := Nat
  predInterp p args := match p, args with
    | 0, [x, y] => x = y
    | _, _ => False
  constInterp _ := 0

#eval "Language definitions created"
#eval Language.hasConst GraphLanguage 0
#eval Language.hasPred GraphLanguage 0

end MiniFunctionRelation
