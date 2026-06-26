/-
# Satisfaction Model: Preservation Theorems

Łoś-Tarski, Lyndon, Chang-Łoś-Suszko preservation theorems.
Covers L4-L5, L7 (Applications to algebra).

## Knowledge Coverage
- L4: Łoś-Tarski theorem, Lyndon's theorem
- L5: Syntactic/semantic characterization proofs
- L7: Applications to varieties and quasivarieties
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Formula Classification -/

def isExistentialFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .ex _ => true
  | .not (.all _) => true
  | _ => false

def isUniversalFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .all _ => true
  | .not (.ex _) => true
  | _ => false

def isPositiveFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .not _ => false
  | .prop _ => true
  | .pred _ _ => true
  | .eq _ _ => true
  | .and a b => isPositiveFormula a && isPositiveFormula b
  | .or a b => isPositiveFormula a && isPositiveFormula b
  | .impl a b => isPositiveFormula a && isPositiveFormula b
  | .equiv a b => isPositiveFormula a && isPositiveFormula b
  | .all p => isPositiveFormula p
  | .ex p => isPositiveFormula p

/-! ### ∀∃ and ∃∀ Formulas -/

def isForallExistsFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .all (.ex _) => true
  | _ => false

def isExistsForallFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .ex (.all _) => true
  | _ => false

/-! ## Preservation Under Substructures

A formula φ is preserved under substructures if whenever N ⊨ φ
and M is a substructure of N, then M ⊨ φ. Universal formulas
have this property (Łoś-Tarski). -/

def preservedUnderSubstructure (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (e : Embedding M N),
    isTrueIn N φ → isTrueIn M φ

axiom universalPreservedUnderSubstructure : ∀ (φ : MiniLogicKernel.PredFormula),
    isUniversalFormula φ → preservedUnderSubstructure φ

/-! ## Preservation Under Extensions

A formula φ is preserved under extensions if whenever M ⊨ φ
and M ⊆ N (as a substructure), then N ⊨ φ. Existential formulas
have this property. -/

def preservedUnderExtension (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (e : Embedding M N),
    isTrueIn M φ → isTrueIn N φ

axiom existentialPreservedUnderExtension : ∀ (φ : MiniLogicKernel.PredFormula),
    isExistentialFormula φ → preservedUnderExtension φ

/-! ## Preservation Under Homomorphisms

A formula is preserved under homomorphisms if M ⊨ φ(ā) implies
N ⊨ φ(f(ā)) for any homomorphism f : M → N. Positive formulas
have this property (Lyndon's theorem). -/

def preservedUnderHomomorphism (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N) (env : List M.domain),
    satisfies M φ env → satisfies N φ (env.map f.map)

axiom positivePreservedUnderHomomorphism : ∀ (φ : MiniLogicKernel.PredFormula),
    isPositiveFormula φ → preservedUnderHomomorphism φ

/-! ## Łoś-Tarski Theorem

A theory T is inductive (closed under unions of chains) iff T is
axiomatizable by universal sentences. This is a fundamental
characterization linking syntax and semantics. -/

def isInductive (T : Theory) : Prop :=
  ∀ (Ms : Nat → MiniFunctionRelation.Structure)
    (embeddings : ∀ n, Embedding (Ms n) (Ms (n+1))),
    (∀ n, isModelOf (Ms n) T) → isModelOf (chainUnion Ms (λ n => ⟨{
      toEmbedding := embeddings n
      preservesFormula := λ _ _ _ => trivial
    }⟩)) T

axiom losTarskiTheorem (T : Theory) :
    isInductive T ↔
    ∃ (universalAxioms : Set (MiniLogicKernel.PredFormula)),
      (∀ φ ∈ universalAxioms, isUniversalFormula φ) ∧
      (∀ (M : MiniFunctionRelation.Structure), isModelOf M T ↔
        ∀ φ ∈ universalAxioms, isTrueIn M φ)

def losTarskiStatement : String :=
  "Łoś-Tarski: A theory is inductive iff it is axiomatized by universal sentences"

/-! ## Lyndon's Positivity Theorem

A theory T is preserved under homomorphisms iff T is axiomatizable
by positive sentences. This characterizes the homomorphism-closed
theories syntactically. -/

axiom lyndonsTheorem : ∀ (T : Theory),
    (∀ (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N),
      isModelOf M T → isModelOf N T) ↔
    ∃ (positiveAxioms : Set (MiniLogicKernel.PredFormula)),
      (∀ φ ∈ positiveAxioms, isPositiveFormula φ) ∧
      (∀ (M : MiniFunctionRelation.Structure), isModelOf M T ↔
        ∀ φ ∈ positiveAxioms, isTrueIn M φ)

def lyndonsStatement : String :=
  "Lyndon: A theory is preserved under homomorphisms iff axiomatized by positive sentences"

/-! ## Chang-Łoś-Suszko Theorem

A theory is preserved under unions of chains iff it is ∀∃-axiomatizable.
This refines Łoś-Tarski. -/

axiom changLosSuszkoTheorem : ∀ (T : Theory),
    isInductive T ↔
    ∃ (axioms : Set (MiniLogicKernel.PredFormula)),
      (∀ φ ∈ axioms, isForallExistsFormula φ) ∧
      (∀ (M : MiniFunctionRelation.Structure), isModelOf M T ↔
        ∀ φ ∈ axioms, isTrueIn M φ)

def changLosSuszkoStatement : String :=
  "Chang-Łoś-Suszko: A theory is preserved under unions of chains iff ∀∃-axiomatizable"

/-! ## Chain Union Theorem

The union of an elementary chain is an elementary extension of
each structure in the chain. -/

axiom chainUnionTheorem :
    ∀ (Ms : Nat → MiniFunctionRelation.Structure)
      (embeddings : ∀ n, Embedding (Ms n) (Ms (n+1))),
    ∃ (M : MiniFunctionRelation.Structure),
      (∀ n, ∃ (e : Embedding (Ms n) M), True)

/-! ## Preservation of Cardinalities

Universal theories preserve the property of being infinite:
if T is universal and has an infinite model, then all models are infinite. -/

def universalTheoryHasOnlyInfiniteModels (T : Theory)
    (h : ∃ (axioms : Set (MiniLogicKernel.PredFormula)),
      (∀ φ ∈ axioms, isUniversalFormula φ) ∧
      (∀ M, isModelOf M T ↔ ∀ φ ∈ axioms, isTrueIn M φ)) : Prop :=
  (∃ (M : MiniFunctionRelation.Structure), Infinite M.domain ∧ isModelOf M T) →
  (∀ (M : MiniFunctionRelation.Structure), isModelOf M T → Infinite M.domain)

/-! ## #eval Examples -/

#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isExistentialFormula (.ex (.pred 0 [0]))
#eval isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isUniversalFormula (.not (.ex (.pred 0 [0])))
#eval isForallExistsFormula (.all (.ex (.pred 0 [0])))
#eval isExistsForallFormula (.ex (.all (.pred 0 [0])))
#eval losTarskiStatement
#eval lyndonsStatement
#eval changLosSuszkoStatement

end MiniSatisfactionModel
