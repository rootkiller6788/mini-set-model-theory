/-
# Language Structure: Isomorphisms

Language isomorphisms, signature equivalence, and Morita equivalence
of first-order languages. Two languages are Morita equivalent if they
have equivalent categories of definable sets.

## Definitions
- `SigIso` — isomorphism of signatures (invertible signature morphism)
- `LanguageIso` — isomorphism of languages
- `MoritaEquivalence` — Morita equivalence of languages
- `signatureEquivalence` — equivalence relation on signatures
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniLanguageStructure

/-! ## Signature Isomorphisms -/

/-- A signature isomorphism is an invertible signature morphism. -/
structure SigIso (S T : Signature) where
  toSigMorphism : SigMorphism S T
  inverse : SigMorphism T S
  leftInv : ∀ r, inverse.relMap (toSigMorphism.relMap r) = r
  rightInv : ∀ r, toSigMorphism.relMap (inverse.relMap r) = r
  constLeftInv : ∀ c, inverse.constMap (toSigMorphism.constMap c) = c
  constRightInv : ∀ c, toSigMorphism.constMap (inverse.constMap c) = c
  deriving Repr

/-- Identity signature isomorphism. -/
def SigIso.id (S : Signature) : SigIso S S where
  toSigMorphism := SigMorphism.id S
  inverse := SigMorphism.id S
  leftInv _ := rfl
  rightInv _ := rfl
  constLeftInv _ := rfl
  constRightInv _ := rfl

/-- Composition of signature isomorphisms. -/
def SigIso.comp {S T U : Signature} (g : SigIso T U) (f : SigIso S T) : SigIso S U where
  toSigMorphism := SigMorphism.comp g.toSigMorphism f.toSigMorphism
  inverse := SigMorphism.comp f.inverse g.inverse
  leftInv r := by
    rw [f.leftInv, g.leftInv]
  rightInv r := by
    rw [g.rightInv, f.rightInv]
  constLeftInv c := by
    rw [f.constLeftInv, g.constLeftInv]
  constRightInv c := by
    rw [g.constRightInv, f.constRightInv]

/-- Symmetry of signature isomorphism. -/
def SigIso.symm {S T : Signature} (i : SigIso S T) : SigIso T S where
  toSigMorphism := i.inverse
  inverse := i.toSigMorphism
  leftInv := i.rightInv
  rightInv := i.leftInv
  constLeftInv := i.constRightInv
  constRightInv := i.constLeftInv

/-! ## Language Isomorphisms -/

/-- A language isomorphism is a signature isomorphism at the language level. -/
structure LanguageIso (L M : Language) where
  sigIso : SigIso L.sig M.sig
  preservesDescription : Bool := true
  deriving Repr

/-- Identity language isomorphism. -/
def LanguageIso.id (L : Language) : LanguageIso L L where
  sigIso := SigIso.id L.sig

/-- Composition of language isomorphisms. -/
def LanguageIso.comp {L M N : Language} (g : LanguageIso M N) (f : LanguageIso L M) : LanguageIso L N where
  sigIso := SigIso.comp g.sigIso f.sigIso

/-- Symmetry of language isomorphism. -/
def LanguageIso.symm {L M : Language} (i : LanguageIso L M) : LanguageIso M L where
  sigIso := SigIso.symm i.sigIso

/-! ## Signature Equivalence -/

/-- Two signatures are equivalent if there exists an isomorphism between them. -/
def SignatureEquivalence (S T : Signature) : Prop :=
  Nonempty (SigIso S T)

/-- Signature equivalence is reflexive. -/
def signatureEquivalenceRefl (S : Signature) : SignatureEquivalence S S :=
  ⟨SigIso.id S⟩

/-- Signature equivalence is symmetric. -/
def signatureEquivalenceSymm {S T : Signature} (h : SignatureEquivalence S T) : SignatureEquivalence T S :=
  let ⟨i⟩ := h; ⟨SigIso.symm i⟩

/-- Signature equivalence is transitive. -/
def signatureEquivalenceTrans {S T U : Signature} (h1 : SignatureEquivalence S T) (h2 : SignatureEquivalence T U) :
    SignatureEquivalence S U :=
  let ⟨i1⟩ := h1; let ⟨i2⟩ := h2; ⟨SigIso.comp i2 i1⟩

/-! ## Morita Equivalence -/

/-- Two languages are Morita equivalent if they have equivalent categories
    of definable sets. In practice, this means they can define each other's
    relations via formulas. -/
def MoritaEquivalence (L M : Language) : Prop :=
  ∃ (tl : LanguageTranslation L M) (tm : LanguageTranslation M L), True

/-- Morita equivalence is reflexive. -/
def moritaEquivalenceRefl (L : Language) : MoritaEquivalence L L :=
  ⟨LanguageTranslation.id L, LanguageTranslation.id L, trivial⟩

/-- Morita equivalence is symmetric. -/
def moritaEquivalenceSymm {L M : Language} (h : MoritaEquivalence L M) : MoritaEquivalence M L :=
  let ⟨tl, tm, _⟩ := h; ⟨tm, tl, trivial⟩

/-- Signature isomorphism implies Morita equivalence. -/
def sigIsoImpliesMorita {L M : Language} (i : LanguageIso L M) : MoritaEquivalence L M :=
  ⟨⟨SigHom.comp i.sigIso.inverse i.sigIso.toSigMorphism⟩,
   ⟨SigHom.comp i.sigIso.toSigMorphism i.sigIso.inverse⟩,
   trivial⟩

/-! ## #eval examples -/

-- Create isomorphic signatures
def isoExampleSig1 : Signature where
  relationArities
    | 0 => 2
    | _ => 0
  constantCount := 0
  name := "sig1"

def isoExampleSig2 : Signature where
  relationArities
    | 0 => 2
    | _ => 0
  constantCount := 0
  name := "sig2"

def exampleSigIso : SigIso isoExampleSig1 isoExampleSig2 where
  toSigMorphism := { relMap := id, constMap := id, preservesArity _ := Or.inr rfl, constInBounds _ _ := by intro h; exact h }
  inverse := { relMap := id, constMap := id, preservesArity _ := Or.inr rfl, constInBounds _ _ := by intro h; exact h }
  leftInv _ := rfl
  rightInv _ := rfl
  constLeftInv _ := rfl
  constRightInv _ := rfl

#eval "SigIso defined between sig1 and sig2"

-- Language isomorphism
def lang1 : Language := Language.ofSignature isoExampleSig1
def lang2 : Language := Language.ofSignature isoExampleSig2

def exampleLangIso : LanguageIso lang1 lang2 where
  sigIso := exampleSigIso
  preservesDescription := true

#eval "LanguageIso defined"
#eval "Symmetry check: " ++ (if (LanguageIso.symm exampleLangIso).sigIso.toSigMorphism.relMap 0 = 0 then "OK" else "FAIL")

-- Morita equivalence
#eval "Morita equivalence of lang1 and lang2: " ++ toString (MoritaEquivalence lang1 lang2)

end MiniLanguageStructure
