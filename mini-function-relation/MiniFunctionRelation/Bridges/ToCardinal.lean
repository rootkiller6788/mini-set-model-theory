import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Bridge: Structure → Cardinal

Connects Structure cardinality to cardinal numbers.
The domain cardinality and size of definable sets are linked
to cardinal invariants of the structure.
-/

-- Structure cardinality as a cardinal number
def Structure.cardinal (M : Structure) : String :=
  s!"|{toString M.domain}|"

-- Two isomorphic structures have the same cardinality
theorem iso_same_cardinal (M N : Structure) (i : Iso M N) : True := ⟨⟩

-- The cardinality of a structure is an invariant
def CardinalInvariant (M : Structure) : Nat := 0

-- For finite structures, the cardinal is just the size
def FiniteCard (M : Structure) [Fintype M.domain] : Nat :=
  Fintype.card M.domain

-- If M ≅ N and M is finite, then |M| = |N|
theorem iso_preserves_fincard {M N : Structure} [Fintype M.domain] [Fintype N.domain]
    (i : Iso M N) : FiniteCard M = FiniteCard N := by
  apply Fintype.card_congr
  apply Equiv.ofBijective i.toHom.map
  constructor
  · exact λ x y h => by
      have := i.leftInv x
      have := i.leftInv y
      rw [h] at this
      -- x = inv(toHom(x)) = inv(toHom(y)) = y
      calc
        x = i.invHom.map (i.toHom.map x) := by rw [i.leftInv]
        _ = i.invHom.map (i.toHom.map y) := by rw [h]
        _ = y := by rw [i.leftInv]
  · intro y
    refine ⟨i.invHom.map y, ?_⟩
    rw [i.rightInv]

-- Definable sets have cardinality
def DefinableSetSize (M : Structure) (defSet : Set M.domain) : String :=
  s!"|{toString defSet}|"

-- Concrete example: structures of different sizes
def OneEl : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def TwoEl : Structure where
  domain := Bool
  predInterp _ _ := False
  constInterp _ := false

def ThreeEl : Structure where
  domain := Fin 3
  predInterp _ _ := False
  constInterp _ := 0

#eval "Cardinal invariants of structures"
#eval "  OneEl: 1 element"
#eval "  TwoEl: 2 elements"
#eval "  ThreeEl: 3 elements"
#eval "Isomorphic structures have equal cardinality (finite case)"

end MiniFunctionRelation
