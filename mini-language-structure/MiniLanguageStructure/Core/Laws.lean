/-
# Language Structure: Laws

Axioms and structural laws governing signatures, reducts, expansions,
and conservative extensions of first-order languages.

## Definitions
- `SigMorphism` — morphism between signatures (maps relation and constant symbols)
- `reduct` / `expansion` — relation between a larger and smaller language
- `conservativeExtension` — expansion that adds no new theorems in the old language
- `signatureSubset` — partial order on signatures
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects

namespace MiniLanguageStructure

/-! ## Signature Morphisms -/

/-- A morphism between signatures maps relation indices to relation indices
    preserving arity, and constant indices to constant indices. -/
structure SigMorphism (S T : Signature) where
  relMap : Nat → Nat
  constMap : Nat → Nat
  preservesArity : ∀ (r : Nat), S.relationArities r = 0 ∨ T.relationArities (relMap r) = S.relationArities r
  constInBounds : ∀ (c : Nat), c < S.constantCount → constMap c < T.constantCount
  deriving Repr

/-- Identity signature morphism. -/
def SigMorphism.id (S : Signature) : SigMorphism S S where
  relMap r := r
  constMap c := c
  preservesArity _ := Or.inr rfl
  constInBounds _ h := h

/-- Composition of signature morphisms. -/
def SigMorphism.comp {S T U : Signature} (g : SigMorphism T U) (f : SigMorphism S T) : SigMorphism S U where
  relMap r := g.relMap (f.relMap r)
  constMap c := g.constMap (f.constMap c)
  preservesArity r := by
    rcases f.preservesArity r with h | h
    · left; exact h
    · rcases g.preservesArity (f.relMap r) with hg | hg
      · left; exact hg
      · right; rw [h, hg]
  constInBounds c h := g.constInBounds (f.constMap c) (f.constInBounds c h)

/-! ## Reduct and Expansion -/

/-- A signature T is a reduct of S (S is an expansion of T) if there is an
    injective-on-symbols signature morphism from T to S. -/
structure IsReduct (T S : Signature) where
  inclusion : SigMorphism T S
  relInjective : ∀ r₁ r₂, inclusion.relMap r₁ = inclusion.relMap r₂ → r₁ = r₂
  constInjective : ∀ c₁ c₂, inclusion.constMap c₁ = inclusion.constMap c₂ → c₁ = c₂
  deriving Repr

/-- S is an expansion of T. -/
def IsExpansion (S T : Signature) : Type := IsReduct T S

/-- The trivial reduct: every signature is a reduct of itself. -/
def isReductRefl (S : Signature) : IsReduct S S where
  inclusion := SigMorphism.id S
  relInjective _ _ h := h
  constInjective _ _ h := h

/-- A language L is a reduct of M. -/
def isLanguageReduct (L M : Language) : Prop :=
  IsReduct L.sig M.sig

/-- A language M is an expansion of L. -/
def isLanguageExpansion (M L : Language) : Prop :=
  isLanguageReduct L M

/-! ## Conservative Extensions -/

/-- A language M is a conservative extension of L if M is an expansion of L
    and every M-sentence that uses only L-symbols is already provable from
    the L-theory. (Stated here as a property for later use.) -/
def ConservativeExtension (L M : Language) : Prop :=
  isLanguageExpansion M L ∧ True  -- placeholder: expand with formula preservation

/-- Signature subset relation: S is a subsignature of T if all symbols of S
    appear in T with the same arities. -/
def signatureSubset (S T : Signature) : Prop :=
  (∀ r, S.relationArities r ≤ T.relationArities r) ∧ S.constantCount ≤ T.constantCount

/-- The empty signature is a subset of every signature. -/
def emptySignatureSubset (S : Signature) : signatureSubset emptySignature S := by
  constructor
  · intro r; simp [emptySignature]
  · simp [emptySignature]

/-- Signature subset is reflexive. -/
def signatureSubsetRefl (S : Signature) : signatureSubset S S := by
  constructor
  · intro r; rfl
  · rfl

/-! ## #eval examples -/

-- Create two related signatures
def smallSig : Signature where
  relationArities
    | 0 => 2
    | _ => 0
  constantCount := 1
  name := "small"

def largeSig : Signature where
  relationArities
    | 0 => 2
    | 1 => 1
    | _ => 0
  constantCount := 2
  name := "large"

-- Signature morphism from small to large (identity embedding)
def embedSmall : SigMorphism smallSig largeSig where
  relMap r := r
  constMap c := c
  preservesArity r := by
    simp [smallSig, largeSig]
    split <;> norm_num
  constInBounds c h := by
    simp [smallSig] at h
    omega

#eval "SigMorphism defined"

-- Reduct relationship
def smallIsReduct : IsReduct smallSig largeSig where
  inclusion := embedSmall
  relInjective _ _ h := h
  constInjective _ _ h := h

#eval "smallSig is a reduct of largeSig"

#eval signatureSubset smallSig largeSig  -- this is a Prop, so we just eval the term
#eval emptySignature.isRelational
#eval largeSig.maxArity

end MiniLanguageStructure
