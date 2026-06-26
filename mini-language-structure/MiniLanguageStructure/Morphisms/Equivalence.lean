/-
# Language Structure: Equivalences

Definitional equivalence of languages, bi-interpretability, and
mutual interpretability of first-order theories.

## Definitions
- `Interpretation` — one language interpreted in another
- `MutualInterpretation` — two languages mutually interpret each other
- `BiInterpretability` — mutual interpretation with definable isomorphisms
- `DefinitionalEquivalence` — strongest form of language equivalence
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Morphisms.Hom

namespace MiniLanguageStructure

/-! ## Interpretations -/

/-- A language L is interpretable in language M if there is a translation
    from L to M. This is the fundamental notion of relative interpretability. -/
structure Interpretation (L M : Language) where
  translation : LanguageTranslation L M
  domainFormula : String := ""  -- placeholder: formula defining the domain
  deriving Repr

/-- Identity interpretation. -/
def Interpretation.id (L : Language) : Interpretation L L where
  translation := LanguageTranslation.id L

/-- Composition of interpretations. -/
def Interpretation.comp {L M N : Language} (g : Interpretation M N) (f : Interpretation L M) :
    Interpretation L N where
  translation := LanguageTranslation.comp g.translation f.translation

/-! ## Mutual Interpretation -/

/-- Two languages are mutually interpretable if each is interpretable in the other. -/
structure MutualInterpretation (L M : Language) where
  toM : Interpretation L M
  toL : Interpretation M L
  deriving Repr

/-- Mutual interpretation is reflexive. -/
def mutualInterpretationRefl (L : Language) : MutualInterpretation L L where
  toM := Interpretation.id L
  toL := Interpretation.id L

/-- Mutual interpretation is symmetric. -/
def mutualInterpretationSymm {L M : Language} (h : MutualInterpretation L M) : MutualInterpretation M L where
  toM := h.toL
  toL := h.toM

/-! ## Bi-Interpretability -/

/-- Two languages are bi-interpretable if they are mutually interpretable
    and the compositions of the interpretations are definably isomorphic
    to the identity interpretations. -/
structure BiInterpretation (L M : Language) extends MutualInterpretation L M where
  toLtoMIsDefinableIso : String := ""  -- placeholder: compositition L->M->L is definably isomorphic to id_L
  toMtoLIsDefinableIso : String := ""
  deriving Repr

/-- Bi-interpretability is reflexive. -/
def biInterpretationRefl (L : Language) : BiInterpretation L L where
  toM := Interpretation.id L
  toL := Interpretation.id L

/-! ## Definitional Equivalence -/

/-- Two languages are definitionally equivalent if they have the same
    definable sets. This is the strongest notion of equivalence: the
    languages are essentially the same, just with different primitive symbols. -/
structure DefinitionalEquivalence (L M : Language) where
  interpretationLM : Interpretation L M
  interpretationML : Interpretation M L
  isInverseLM : String := ""   -- placeholder: composition = id (up to definable isomorphism)
  isInverseML : String := ""
  deriving Repr

/-- Definitional equivalence implies bi-interpretability. -/
def definitionalToBiInterpretation {L M : Language} (h : DefinitionalEquivalence L M) :
    BiInterpretation L M where
  toM := h.interpretationLM
  toL := h.interpretationML

/-- Definitional equivalence is reflexive. -/
def definitionalEquivalenceRefl (L : Language) : DefinitionalEquivalence L L where
  interpretationLM := Interpretation.id L
  interpretationML := Interpretation.id L

/-- Definitional equivalence is symmetric. -/
def definitionalEquivalenceSymm {L M : Language} (h : DefinitionalEquivalence L M) :
    DefinitionalEquivalence M L where
  interpretationLM := h.interpretationML
  interpretationML := h.interpretationLM

/-! ## Definable Expansion -/

/-- A language M is a definitional expansion of L if M extends L by
    adding new relation symbols, each defined by an L-formula. This is
    the key construction behind definitional equivalence. -/
structure DefinitionalExpansion (L M : Language) where
  base : LanguageTranslation L M
  newRelations : List (Nat × String)  -- (arity, definition formula) for each new symbol
  definingFormulas : List String := []
  deriving Repr

/-- Every language is a definitional expansion of itself. -/
def definitionalExpansionRefl (L : Language) : DefinitionalExpansion L L where
  base := LanguageTranslation.id L
  newRelations := []

/-! ## #eval examples -/

-- Build two simple languages
def lanA : Language := Language.ofSignature emptySignature
def lanB : Language := Language.ofSignature trivialSignature

-- Interpretation
def interpAB : Interpretation lanA lanB where
  translation := LanguageTranslation.id lanA
  domainFormula := "x = x"

#eval "Interpretation A->B defined"

-- Mutual interpretation
def mutualAB : MutualInterpretation lanA lanB where
  toM := interpAB
  toL := Interpretation.id lanA

#eval "MutualInterpretation defined"

-- Bi-interpretation
def biAB : BiInterpretation lanA lanB where
  toM := interpAB
  toL := Interpretation.id lanA

#eval "BiInterpretation defined"

-- Definitional equivalence
def defEqAA : DefinitionalEquivalence lanA lanA := definitionalEquivalenceRefl lanA
#eval "DefinitionalEquivalence defined (reflexive)"

end MiniLanguageStructure
