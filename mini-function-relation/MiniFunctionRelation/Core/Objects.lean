import MiniFunctionRelation.Core.Basic
import MiniObjectKernel.Core.Basic

namespace MiniFunctionRelation

/--
Register `Structure` as an `Object` in the MiniObjectKernel typeclass.
This allows all model-theoretic structures to participate in the
unified object framework (dependency graphs, serialization, etc.).
-/
instance (S : Structure) : Object Structure where
  theory := TheoryName.ofString "ModelTheory.FirstOrder"
  objName := "Structure"
  repr _ := "M"

/--
Register `Iso` as an `Object` for isomorphism data.
-/
instance (M N : Structure) : Object (Iso M N) where
  theory := TheoryName.ofString "ModelTheory.FirstOrder"
  objName := "StructureIso"
  repr _ := s!"Iso({repr M}, {repr N})"

/--
Register `SubStructure` as an `Object`.
-/
instance (M : Structure) : Object (SubStructure M) where
  theory := TheoryName.ofString "ModelTheory.FirstOrder"
  objName := "SubStructure"
  repr _ := s!"Sub({repr M})"

#eval "Objects.lean: Structure, Iso, SubStructure registered as Object instances"
#eval "Theory: ModelTheory.FirstOrder"

end MiniFunctionRelation
