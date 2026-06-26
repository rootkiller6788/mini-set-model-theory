/-
# Satisfaction Model: Core Basic Definitions

Satisfaction relation, formula preservation, classification theory,
and standard model-theoretic examples.
-/

import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniLogicKernel.Core.Objects
import MiniCardinalOrdinal.Core.Basic

namespace MiniSatisfactionModel

/-! ## Satisfaction Relation -/

def satisfies (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) : Prop :=
  MiniLogicKernel.Structure.satisfies {
    domain := M.domain
    predInterp := M.predInterp
    constInterp := M.constInterp
  } φ env

/-! ## Theory of a Structure -/

structure Theory where
  axioms : Set (MiniLogicKernel.PredFormula)
  deriving Repr, Inhabited

def theoryOf (M : MiniFunctionRelation.Structure) : Theory where
  axioms := { φ | satisfies M φ [] }

def isModelOf (M : MiniFunctionRelation.Structure) (T : Theory) : Prop :=
  ∀ φ ∈ T.axioms, satisfies M φ []

def isConsistent (T : Theory) : Prop :=
  ∃ (M : MiniFunctionRelation.Structure), isModelOf M T

def isComplete (T : Theory) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula), φ ∈ T.axioms ∨ MiniLogicKernel.PredFormula.not φ ∈ T.axioms

/-! ## Elementary Maps -/

def isElementaryEmbedding (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain),
    satisfies M φ env → satisfies N φ (env.map f.map)

/-! ## Syntax Classification -/

def isUniversalFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .all _ => true
  | .not (.ex _) => true
  | _ => false

def isExistentialFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .ex _ => true
  | .not (.all _) => true
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

/-! ## Quantifier-Free Formulas -/

def isQuantifierFree (φ : MiniLogicKernel.PredFormula) : Bool :=
  MiniLogicKernel.PredFormula.quantifierDepth φ = 0

/-! ## Model Existence -/

axiom compactness (T : Theory) : (∀ (T₀ : Theory), T₀.axioms ⊆ T.axioms → Finite T₀.axioms → isConsistent T₀) → isConsistent T

def hasFiniteModel (T : Theory) : Prop :=
  ∃ (M : MiniFunctionRelation.Structure) (_ : Finite M.domain), isModelOf M T

/-! ## #eval Examples -/

def emptyTheory : Theory := { axioms := ∅ }

def tautologyTheory : Theory :=
  { axioms := { .prop .true } }

#eval emptyTheory.axioms
#eval isQuantifierFree (.pred 0 [0, 1])
#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isExistentialFormula (.ex (.pred 0 [0]))
#eval isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))

end MiniSatisfactionModel
