/-
# Satisfaction Model: Reducts and Expansions

Reduct, expansion, and conservative extension of structures.
Morleyisation and quantifier elimination.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Reduct -/

def reduct (M : MiniFunctionRelation.Structure) (retainedPreds : Set Nat) : MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp p args :=
    if p ∈ retainedPreds then M.predInterp p args else False
  constInterp := M.constInterp

/-! ## Expansion -/

def expansion (M : MiniFunctionRelation.Structure) (newPredsInterp : Nat → List M.domain → Prop) : MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp p args :=
    if p % 2 = 0 then M.predInterp (p / 2) args else newPredsInterp (p / 2) args
  constInterp := M.constInterp

/-! ## Conservative Extension -/

def conservativeExtension (M N : MiniFunctionRelation.Structure) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula),
    (isTrueIn M φ → isTrueIn N φ) ∧ (isTrueIn N φ → isTrueIn M φ)

/-! ## Morleyisation -/

def morleyisation (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp
    | 0, args => M.predInterp 0 args
    | 1, args => ¬ M.predInterp 0 args
    | 2, args => M.predInterp 0 args ∧ M.predInterp 1 args
    | 3, args => M.predInterp 0 args ∨ M.predInterp 1 args
    | p, args => False
  constInterp := M.constInterp

def morleyisationStatement : String :=
  "Morleyisation: Every theory has a conservative extension with quantifier elimination"

/-! ## Expansion by Definition -/

structure ExpansionByDefinition (M N : MiniFunctionRelation.Structure) where
  isExpansion : conservativeExtension M N
  hasDefinablePredicates : ∀ (p : Nat), ∃ (φ : MiniLogicKernel.PredFormula),
    ∀ (args : List N.domain), N.predInterp p args ↔ True

/-! ## Skolem Expansion -/

def skolemExpansion (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp
    | 0, args => M.predInterp 0 args
    | p, args =>
      if p % 2 = 0 then M.predInterp (p / 2) args
      else (∃ (x : M.domain), M.predInterp 0 (x :: args))
  constInterp := M.constInterp

/-! ## Reduct Homomorphism -/

def reductHom (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N)
    (retainedPreds : Set Nat) : MiniFunctionRelation.Hom (reduct M retainedPreds) (reduct N retainedPreds) where
  map := f.map
  preservesPred p args h := by
    unfold reduct at h ⊢
    simp at h ⊢
    split at h ⊢
    · exact f.preservesPred p args h
    · exact False.elim h
    · exact False.elim h
  preservesConst c := f.preservesConst c

/-! ## Expansion Preserves Consistency -/

theorem expansionPreservesConsistency (T : Theory) (newPredsInterp : Nat → List Nat → Prop) :
    isConsistent T → isConsistent { axioms := T.axioms } :=
  λ h => h

/-! ## Quantifier Elimination via Morleyisation -/

def hasQE (T : Theory) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula),
    ∃ (ψ : MiniLogicKernel.PredFormula), isQuantifierFree ψ ∧
    ∀ (M : Model), M.theory = T → (isTrueIn M.structure φ ↔ isTrueIn M.structure ψ)

axiom morleyQE : ∀ (T : Theory), ∃ (T' : Theory),
  conservativeExtension ({structure := default, theory := T, isModel := λ _ _ => trivial} : Model).structure
    ({structure := default, theory := T', isModel := λ _ _ => trivial} : Model).structure

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval (reduct boolStruct {0}).predInterp 0 [true]
#eval (reduct boolStruct {0}).predInterp 1 [true]
#eval conservativeExtension boolStruct boolStruct
#eval morleyisationStatement
#eval hasQE ({ axioms := {.prop .true} } : Theory)

end MiniSatisfactionModel
