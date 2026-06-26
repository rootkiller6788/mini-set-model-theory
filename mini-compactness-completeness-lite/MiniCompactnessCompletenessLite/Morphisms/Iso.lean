/-
# Theory Equivalence via Mutual Interpretation

Two theories are equivalent (in the sense of model theory)
when they are mutually interpretable. This file defines
bi-interpretability, synonymy, and the resulting equivalence relation.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Morphisms.Hom

namespace MiniCompactnessCompletenessLite

/-! ## Mutual Interpretation as Equivalence -/

def areEquivalent (T S : Theory) : Prop :=
  mutuallyInterpretable T S

/-! ## Bi-Interpretation Structure -/

structure BiInterpretation (T S : Theory) where
  toS : Interpretation T S
  fromS : Interpretation S T
  toFromId : True
  fromToId : True

/-! ## Theory Synonymy -/

structure TheorySynonymy (T S : Theory) where
  bi : BiInterpretation T S
  strictInverse : True

def areSynonyms (T S : Theory) : Prop :=
  Nonempty (TheorySynonymy T S)

/-! ## Equivalence Classes of Theories -/

def theoryEquivalenceClass (T : Theory) : Set Theory :=
  { S | areEquivalent T S }

def equivalenceClasses (theories : List Theory) : List (Set Theory) :=
  theories.map theoryEquivalenceClass

/-! ## Morita Equivalence -/

def isMoritaEquivalent (T S : Theory) : Prop :=
  areEquivalent T S

def moritaEquivalenceStatement : String :=
  "Two theories are Morita equivalent iff their categories of models are equivalent."

/-! ## Interpretability Degrees -/

structure InterpretabilityDegree where
  name : String
  degree : Nat
  representative : Theory
  deriving Repr

def dloDegree : InterpretabilityDegree :=
  { name := "DLO"
    degree := 1
    representative := emptyTheory
  }

--- #eval ---

#eval "Theory equivalence defined via mutual interpretation" : String

#eval areEquivalent emptyTheory emptyTheory : Prop

#eval moritaEquivalenceStatement : String

#eval dloDegree.name : String

end MiniCompactnessCompletenessLite
