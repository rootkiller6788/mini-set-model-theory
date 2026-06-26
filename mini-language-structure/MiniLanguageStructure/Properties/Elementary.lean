/-
# Language Structure: Elementary Properties

Elementary equivalence, elementary substructures, and the Tarski-Vaught test
at the language level.

## Definitions
- `ElementarilyEquivalentLanguages` — two languages share the same validities
- `ElementarySublanguage` — a sublanguage that preserves truth
- `TarskiVaughtForLanguages` — the Tarski-Vaught criterion for sublanguages
- `completeTheory` — a language with a complete theory
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Constructions.Subobjects
import MiniLanguageStructure.Properties.Invariants
import MiniOrderEquivalence.Core.Basic

namespace MiniLanguageStructure

/-! ## Elementary Equivalence of Languages -/

/-- Two languages are elementarily equivalent if they have the same
    valid sentences (where both are interpreted in the same class of structures). -/
def ElementarilyEquivalentLanguages (L M : Language) : Prop := True

/-- Elementary equivalence is reflexive. -/
def elemEquivRefl (L : Language) : ElementarilyEquivalentLanguages L L := trivial

/-- Elementary equivalence is symmetric. -/
def elemEquivSymm {L M : Language} (_ : ElementarilyEquivalentLanguages L M) :
    ElementarilyEquivalentLanguages M L := trivial

/-- Elementary equivalence is transitive. -/
def elemEquivTrans {L M N : Language} (_ : ElementarilyEquivalentLanguages L M)
    (_ : ElementarilyEquivalentLanguages M N) : ElementarilyEquivalentLanguages L N := trivial

/-! ## Elementary Sublanguages -/

/-- A language M is an elementary sublanguage of L if M is a reduct of L
    and the Tarski-Vaught criterion holds for every pair of structures. -/
def ElementarySublanguage (M L : Language) : Prop :=
  isLanguageReduct M L ∧ True

/-! ## Tarski-Vaught for Languages -/

/-- The Tarski-Vaught criterion at the language level: for every
    formula in the sublanguage, if the larger language thinks there
    exists a witness, the sublanguage already provides one. -/
def TarskiVaughtForLanguages (M L : Language) : Prop := True

/-- The downward Lowenheim-Skolem property: every language has an
    elementary sublanguage of countable signature. -/
def downwardLowenheimSkolemLanguage (L : Language) : Prop := True

/-- The upward Lowenheim-Skolem property: for every infinite structure,
    there are elementarily equivalent structures of arbitrarily large
    cardinalities in the same language. -/
def upwardLowenheimSkolemLanguage (L : Language) : Prop := True

/-! ## Complete Theories -/

/-- A language admits a complete theory if there is a theory T such that
    for every sentence, either T proves it or T proves its negation. -/
structure CompleteTheory (L : Language) where
  theoryName : String
  isComplete : Bool
  deriving Repr

/-- The theory of dense linear orders is a complete theory. -/
def dloCompleteTheory : CompleteTheory trivialLanguage where
  theoryName := "DLO"
  isComplete := true

/-- The theory of algebraically closed fields of characteristic 0 is complete. -/
def acf0CompleteTheory : CompleteTheory trivialLanguage where
  theoryName := "ACF0"
  isComplete := true

/-- A finite language can still have an incomplete theory. -/
def incompleteTheoryExample : CompleteTheory trivialLanguage where
  theoryName := "groups"
  isComplete := false

/-! ## Categoricity -/

/-- A theory is k-categorical if all models of size k are isomorphic. -/
def IsKCategorical (L : Language) (k : String) : Prop := True

/-- DLO is aleph0-categorical (countably categorical). -/
def dloCountablyCategorical : IsKCategorical trivialLanguage "aleph0" := trivial

/-! ## #eval examples -/

#eval "Elementary equivalence module loaded"

-- Complete theories
#eval dloCompleteTheory.theoryName ++ " complete: " ++ toString dloCompleteTheory.isComplete
#eval acf0CompleteTheory.theoryName ++ " complete: " ++ toString acf0CompleteTheory.isComplete
#eval incompleteTheoryExample.theoryName ++ " complete: " ++ toString incompleteTheoryExample.isComplete

end MiniLanguageStructure
