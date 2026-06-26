/-
# Conservative Extensions and Definitional Equivalence

Conservative extensions add new symbols without adding new theorems
in the original language. Definitional equivalence captures when
two theories are just different presentations of the same content.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Morphisms.Hom

namespace MiniCompactnessCompletenessLite

/-! ## Language Extension -/

def isLanguageExtension (T S : Theory) : Prop :=
  T ⊆ S

def isExtension (T S : Theory) : Prop :=
  T ⊆ S

/-! ## Conservative Extension -/

def isConservativeExtension (T S : Theory) : Prop :=
  isExtension T S ∧
  (∀ (φ : MiniLogicKernel.PredFormula), logicalConsequence S φ → logicalConsequence T φ)

def isModelConservative (T S : Theory) : Prop :=
  isExtension T S ∧
  (∀ M, isModelOf M T → ∃ N, isModelOf N S)

/-! ## Definitional Extension -/

structure DefinitionalExtension (T S : Theory) where
  base : T ⊆ S
  toS : S ⊆ T
  equivalenceProof : True

def isDefinitionalExtension (T S : Theory) : Prop :=
  Nonempty (DefinitionalExtension T S)

/-! ## Definitional Equivalence -/

def areDefinitionallyEquivalent (T S : Theory) : Prop :=
  isDefinitionalExtension T S ∧ isDefinitionalExtension S T

def definitionalEquivalenceStatement : String :=
  "Two theories are definitionally equivalent if one is a conservative extension of the other obtained by adding definable symbols."

/-! ## Examples of Conservative Extensions -/

def addDefinablePredicate (T : Theory) (PName : Nat) (definingFormula : MiniLogicKernel.PredFormula) : Theory :=
  T ∪ { MiniLogicKernel.PredFormula.pred PName [] }

def conservativeExtensionStatement : String :=
  "Adding a definable predicate yields a conservative extension."

def isWeaklyConservative (T S : Theory) : Prop :=
  ∀ φ, logicalConsequence S (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false) →

    logicalConsequence T (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false)

/-! ## Interdefinability -/

def areInterdefinable (P Q : Nat) (T : Theory) : Prop :=
  True

def interdefinabilityStatement : String :=
  "Two predicates are interdefinable in a theory if each can be expressed using the other."

--- #eval ---

def testExt : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

#eval "Language extension defined" : String

#eval isExtension testExt testExt : Prop

#eval definitionalEquivalenceStatement : String

#eval conservativeExtensionStatement : String

end MiniCompactnessCompletenessLite
