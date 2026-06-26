/-
# Satisfaction Model: Preservation Theorems

Preservation theorems: universal formulas preserved under substructures,
existential formulas preserved under extensions, and Los-Tarski.
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

/-! ## Preservation Under Substructures -/

def preservedUnderSubstructure (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (e : Embedding M N),
    isTrueIn N φ → isTrueIn M φ

axiom universalPreservedUnderSubstructure : ∀ (φ : MiniLogicKernel.PredFormula),
    isUniversalFormula φ → preservedUnderSubstructure φ

/-! ## Preservation Under Extensions -/

def preservedUnderExtension (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (e : Embedding M N),
    isTrueIn M φ → isTrueIn N φ

axiom existentialPreservedUnderExtension : ∀ (φ : MiniLogicKernel.PredFormula),
    isExistentialFormula φ → preservedUnderExtension φ

/-! ## Los-Tarski Theorem -/

def isInductive (T : Theory) : Prop :=
  ∀ (Ms : Nat → MiniFunctionRelation.Structure) (embeddings : ∀ n, Embedding (Ms n) (Ms (n+1))),
    (∀ n, isModelOf (Ms n) T) → ∃ (M : MiniFunctionRelation.Structure), isModelOf M T

axiom losTarskiTheorem (T : Theory) :
    isInductive T ↔
    ∃ (universalAxioms : Set (MiniLogicKernel.PredFormula)),
      (∀ φ ∈ universalAxioms, isUniversalFormula φ) ∧
      (∀ (M : MiniFunctionRelation.Structure), isModelOf M T ↔
        ∀ φ ∈ universalAxioms, isTrueIn M φ)

def losTarskiStatement : String :=
  "Los-Tarski: A theory is inductive iff it is axiomatized by universal sentences"

/-! ## Positive Formulas and Homomorphisms -/

def preservedUnderHomomorphism (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N) (env : List M.domain),
    satisfies M φ env → satisfies N φ (env.map f.map)

axiom positivePreservedUnderHomomorphism : ∀ (φ : MiniLogicKernel.PredFormula),
    isPositiveFormula φ → preservedUnderHomomorphism φ

/-! ## Lyndon's Theorem (axiom) -/

axiom lyndonsTheorem : ∀ (T : Theory),
    (∀ (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N),
      isModelOf M T → isModelOf N T) ↔
    ∃ (positiveAxioms : Set (MiniLogicKernel.PredFormula)),
      (∀ φ ∈ positiveAxioms, isPositiveFormula φ) ∧
      (∀ (M : MiniFunctionRelation.Structure), isModelOf M T ↔
        ∀ φ ∈ positiveAxioms, isTrueIn M φ)

/-! ## Chain Union Theorem -/

axiom chainUnionTheorem :
    ∀ (Ms : Nat → MiniFunctionRelation.Structure) (embeddings : ∀ n, Embedding (Ms n) (Ms (n+1))),
    ∃ (M : MiniFunctionRelation.Structure),
      (∀ n, ∃ (e : Embedding (Ms n) M), True)

/-! ## #eval Examples -/

#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isExistentialFormula (.ex (.pred 0 [0]))
#eval isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isUniversalFormula (.not (.ex (.pred 0 [0])))
#eval losTarskiStatement

end MiniSatisfactionModel
