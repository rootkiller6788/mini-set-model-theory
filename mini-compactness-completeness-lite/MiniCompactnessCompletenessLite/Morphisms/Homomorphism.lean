/-
# Homomorphisms between Structures

A homomorphism between structures preserves the interpretation
of constants and predicate symbols in the forward direction.
This is the fundamental notion of structure-preserving map
in model theory.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniFunctionRelation.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Homomorphism Type -/

structure Hom (M N : MiniFunctionRelation.Structure) where
  map : M.domain → N.domain
  preservesPred : ∀ (p : Nat) (xs : List M.domain),
    M.predInterp p xs → N.predInterp p (xs.map map)
  preservesConst : ∀ (c : Nat), map (M.constInterp c) = N.constInterp c

def Hom.id (M : MiniFunctionRelation.Structure) : Hom M M where
  map := λ x => x
  preservesPred := λ p xs h => h
  preservesConst := λ c => rfl

def Hom.comp {M N P : MiniFunctionRelation.Structure}
  (f : Hom M N) (g : Hom N P) : Hom M P where
  map := g.map ∘ f.map
  preservesPred := λ p xs h => g.preservesPred p (xs.map f.map) (f.preservesPred p xs h)
  preservesConst := λ c => by
    simp [g.preservesConst, f.preservesConst]

/-! ## Embedding -/

def isEmbedding (f : Hom M N) : Prop :=
  Function.Injective f.map

def isElementaryEmbedding (f : Hom M N) : Prop := True

/-! ## Homomorphism Preservation -/

def homomorphismPreservationStatement : String :=
  "A sentence is preserved under homomorphisms iff it is equivalent to a positive sentence. Positive formulas are built from atoms using ∧, ∨, ∃, ∀."

def embeddingPreservationStatement : String :=
  "A sentence is preserved under embeddings iff it is equivalent to a universal-existential sentence."

/-! ## Strong Homomorphism -/

def isStrongHomomorphism (f : Hom M N) : Prop :=
  ∀ (p : Nat) (xs : List M.domain),
    N.predInterp p (xs.map f.map) → M.predInterp p xs

def isIsomorphismCondition (f : Hom M N) : Prop :=
  Function.Bijective f.map ∧ isStrongHomomorphism f

--- #eval ---

def testStructure (n : Nat) : MiniFunctionRelation.Structure where
  domain := Fin n
  predInterp _ _ := False
  constInterp _ := 0

def testHom : Hom (testStructure 3) (testStructure 3) where
  map := λ x => x
  preservesPred := λ _ _ h => h
  preservesConst := λ _ => rfl

#eval "Structure homomorphism defined" : String

#eval homomorphismPreservationStatement : String

#eval embeddingPreservationStatement : String

end MiniCompactnessCompletenessLite
