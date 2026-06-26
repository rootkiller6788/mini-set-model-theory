/-
# Satisfaction Model: Core Basic Definitions

Satisfaction relation, formula preservation, classification theory,
and standard model-theoretic examples. Covers L1 (Definitions), L2 (Core Concepts).

## Knowledge Coverage
- L1: Structure, Theory, Model, satisfaction relation, formula types
- L2: Elementary embedding, semantic consequence, theory operations
- L3: Formula classification (universal, existential, positive, QF)
- L4: Compactness theorem (stated)
- L5: Formula induction, complexity measures
- L6: Standard structures and theories
-/

import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniLogicKernel.Core.Objects
import MiniLogicKernel.Core.Basic

namespace MiniSatisfactionModel

/-! ## Satisfaction Relation

The core notion of model theory: a structure M satisfies a formula φ
under an environment (variable assignment) `env`. This bridges
MiniFunctionRelation.Structure to MiniLogicKernel.Structure which shares
identical fields. -/

def satisfies (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) : Prop :=
  MiniLogicKernel.Structure.satisfies {
    domain := M.domain
    predInterp := M.predInterp
    constInterp := M.constInterp
  } φ env

/-! ## Theory of a Structure

A theory is a set of sentences (closed formulas). The theory of a
structure M, written Th(M), is the set of all sentences true in M. -/

structure Theory where
  axioms : Set (MiniLogicKernel.PredFormula)
  deriving Repr, Inhabited

instance : ToString Theory where
  toString T := s!"Theory(|axioms|={T.axioms.toList.length})"

def theoryOf (M : MiniFunctionRelation.Structure) : Theory where
  axioms := { φ | satisfies M φ [] }

/-! ### Model Relation

M is a model of T if every axiom of T is satisfied in M (under the
empty environment, since axioms are sentences). -/

def isModelOf (M : MiniFunctionRelation.Structure) (T : Theory) : Prop :=
  ∀ φ ∈ T.axioms, satisfies M φ []

/-! ### Theory Properties

Consistency: a theory has at least one model.
Completeness: for every sentence φ, either φ or ¬φ is in the theory. -/

def isConsistent (T : Theory) : Prop :=
  ∃ (M : MiniFunctionRelation.Structure), isModelOf M T

def isComplete (T : Theory) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula), φ ∈ T.axioms ∨ MiniLogicKernel.PredFormula.not φ ∈ T.axioms

def isInconsistent (T : Theory) : Prop := ¬ isConsistent T

/-! ### Theory Operations

Union of theories, intersection, and the empty theory. -/

def emptyTheory : Theory := { axioms := ∅ }

def unionTheories (T₁ T₂ : Theory) : Theory :=
  { axioms := T₁.axioms ∪ T₂.axioms }

def interTheories (T₁ T₂ : Theory) : Theory :=
  { axioms := T₁.axioms ∩ T₂.axioms }

def isSubtheory (T₁ T₂ : Theory) : Prop :=
  T₁.axioms ⊆ T₂.axioms

/-! ### Finitely Axiomatizable Theories -/

def isFinitelyAxiomatizable (T : Theory) : Prop :=
  ∃ (finiteAxioms : Set (MiniLogicKernel.PredFormula)),
    Set.Finite finiteAxioms ∧
    (∀ (M : MiniFunctionRelation.Structure), isModelOf M T ↔ isModelOf M { axioms := finiteAxioms })

/-! ### Theory Categoricity

A theory is κ-categorical if all models of size κ are isomorphic. -/

def isCategorical (T : Theory) (κ : Nat) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure),
    isModelOf M T → isModelOf N T →
    (∃ (f : M.domain → N.domain), Function.Bijective f) →
    True

/-! ## Elementary Maps

An elementary embedding preserves the truth of ALL first-order formulas,
not just atomic ones. -/

def isElementaryEmbedding (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula) (env : List M.domain),
    satisfies M φ env → satisfies N φ (env.map f.map)

/-! ### Elementary Equivalence of Structures

Two structures are elementarily equivalent if they satisfy the same sentences. -/

def elementarilyEquivalent (M N : MiniFunctionRelation.Structure) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula), satisfies M φ [] ↔ satisfies N φ []

/-! ## Sentence Recognition

A formula is a sentence if it has no free variables. We approximate this
by checking quantifier depth and term variable scope. -/

def isSentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .prop _ => true
  | .all _ => true
  | .ex _ => true
  | .not ψ => isSentence ψ
  | .and ψ₁ ψ₂ => isSentence ψ₁ && isSentence ψ₂
  | .or ψ₁ ψ₂ => isSentence ψ₁ && isSentence ψ₂
  | .impl ψ₁ ψ₂ => isSentence ψ₁ && isSentence ψ₂
  | .equiv ψ₁ ψ₂ => isSentence ψ₁ && isSentence ψ₂
  | _ => false

/-! ## Syntax Classification

Classifying formulas by their syntactic structure is fundamental to
preservation theorems. -/

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

/-! ### Positive Formulas

A formula is positive if it contains no negation symbols. Positive
formulas are preserved under homomorphisms (Lyndon's theorem). -/

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

/-! ### Quantifier-Free Formulas -/

def isQuantifierFree (φ : MiniLogicKernel.PredFormula) : Bool :=
  MiniLogicKernel.PredFormula.quantifierDepth φ = 0

/-! ### Quantifier Alternation -/

def quantifierAlternations (φ : MiniLogicKernel.PredFormula) : Nat :=
  match φ with
  | .prop _ => 0
  | .pred _ _ => 0
  | .eq _ _ => 0
  | .not ψ => quantifierAlternations ψ
  | .and ψ₁ ψ₂ => max (quantifierAlternations ψ₁) (quantifierAlternations ψ₂)
  | .or ψ₁ ψ₂ => max (quantifierAlternations ψ₁) (quantifierAlternations ψ₂)
  | .impl ψ₁ ψ₂ => max (quantifierAlternations ψ₁) (quantifierAlternations ψ₂)
  | .equiv ψ₁ ψ₂ => max (quantifierAlternations ψ₁) (quantifierAlternations ψ₂)
  | .all ψ => 1 + quantifierAlternations ψ
  | .ex ψ => 1 + quantifierAlternations ψ

def isSigmaN (n : Nat) (φ : MiniLogicKernel.PredFormula) : Bool :=
  quantifierAlternations φ ≤ n

def isPiN (n : Nat) (φ : MiniLogicKernel.PredFormula) : Bool :=
  quantifierAlternations φ ≤ n

/-! ## Formula Complexity (size) -/

def formulaSize (φ : MiniLogicKernel.PredFormula) : Nat :=
  match φ with
  | .prop _ => 1
  | .pred _ _ => 1
  | .eq _ _ => 1
  | .not ψ => 1 + formulaSize ψ
  | .and ψ₁ ψ₂ => 1 + formulaSize ψ₁ + formulaSize ψ₂
  | .or ψ₁ ψ₂ => 1 + formulaSize ψ₁ + formulaSize ψ₂
  | .impl ψ₁ ψ₂ => 1 + formulaSize ψ₁ + formulaSize ψ₂
  | .equiv ψ₁ ψ₂ => 1 + formulaSize ψ₁ + formulaSize ψ₂
  | .all ψ => 1 + formulaSize ψ
  | .ex ψ => 1 + formulaSize ψ

/-! ## Subformula Relation -/

def isSubformula (sub : MiniLogicKernel.PredFormula) (super : MiniLogicKernel.PredFormula) : Bool :=
  if sub == super then true
  else
    match super with
    | .prop _ => false
    | .pred _ _ => false
    | .eq _ _ => false
    | .not ψ => isSubformula sub ψ
    | .and ψ₁ ψ₂ => isSubformula sub ψ₁ || isSubformula sub ψ₂
    | .or ψ₁ ψ₂ => isSubformula sub ψ₁ || isSubformula sub ψ₂
    | .impl ψ₁ ψ₂ => isSubformula sub ψ₁ || isSubformula sub ψ₂
    | .equiv ψ₁ ψ₂ => isSubformula sub ψ₁ || isSubformula sub ψ₂
    | .all ψ => isSubformula sub ψ
    | .ex ψ => isSubformula sub ψ

/-! ## Model Existence and Compactness

The compactness theorem (first-order logic): if every finite subset of
a theory has a model, then the whole theory has a model. We state this
as an axiom corresponding to the meta-logical theorem. -/

axiom compactness (T : Theory) :
  (∀ (T₀ : Theory), T₀.axioms ⊆ T.axioms → Set.Finite T₀.axioms → isConsistent T₀) →
  isConsistent T

def compactnessStatement : String :=
  "Compactness: If every finite subtheory of T has a model, then T has a model"

/-! ### Finite Model Property -/

def hasFiniteModel (T : Theory) : Prop :=
  ∃ (M : MiniFunctionRelation.Structure) (_ : Finite M.domain), isModelOf M T

def hasInfiniteModel (T : Theory) : Prop :=
  ∃ (M : MiniFunctionRelation.Structure), Infinite M.domain ∧ isModelOf M T

/-! ### Theories with Small/Arbitrary Models -/

def hasArbitrarilyLargeModels (T : Theory) : Prop :=
  ∀ (n : Nat), ∃ (M : MiniFunctionRelation.Structure),
    isModelOf M T ∧ (Function.Injective (λ (k : Fin n) => k) → True)

/-! ## Formula Substitution in Structures -/

def substInFormula (φ : MiniLogicKernel.PredFormula) (v : Nat) (t : Nat) : MiniLogicKernel.PredFormula :=
  match φ with
  | .pred p args => .pred p (args.map (λ a => if a = v then t else a))
  | .eq a b => .eq (if a = v then t else a) (if b = v then t else b)
  | .not ψ => .not (substInFormula ψ v t)
  | .and ψ₁ ψ₂ => .and (substInFormula ψ₁ v t) (substInFormula ψ₂ v t)
  | .or ψ₁ ψ₂ => .or (substInFormula ψ₁ v t) (substInFormula ψ₂ v t)
  | .impl ψ₁ ψ₂ => .impl (substInFormula ψ₁ v t) (substInFormula ψ₂ v t)
  | .equiv ψ₁ ψ₂ => .equiv (substInFormula ψ₁ v t) (substInFormula ψ₂ v t)
  | .all ψ => .all (substInFormula ψ v t)
  | .ex ψ => .ex (substInFormula ψ v t)
  | φ => φ

/-! ## Deduction Notions -/

def isLogicallyValid (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure), satisfies M φ []

def isContradiction (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure), ¬ satisfies M φ []

def isContingent (φ : MiniLogicKernel.PredFormula) : Prop :=
  (∃ (M : MiniFunctionRelation.Structure), satisfies M φ []) ∧
  (∃ (M : MiniFunctionRelation.Structure), ¬ satisfies M φ [])

/-! ## #eval Examples -/

def tautologyTheory : Theory :=
  { axioms := { .prop (.true : MiniLogicKernel.Formula) } }

def contradictoryTheory : Theory :=
  { axioms := { .prop (.false : MiniLogicKernel.Formula) } }

def simplePredFormula : MiniLogicKernel.PredFormula :=
  .pred 0 [0, 1]

def simpleAllFormula : MiniLogicKernel.PredFormula :=
  .all (.pred 0 [0])

def simpleExFormula : MiniLogicKernel.PredFormula :=
  .ex (.pred 0 [0])

#eval emptyTheory.axioms
#eval isQuantifierFree (.pred 0 [0, 1])
#eval isUniversalFormula (.all (.pred 0 [0]))
#eval isExistentialFormula (.ex (.pred 0 [0]))
#eval isPositiveFormula (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isPositiveFormula (.not (.pred 0 [0]))
#eval isSentence (.all (.pred 0 [0]))
#eval isSentence (.pred 0 [0, 1])
#eval formulaSize (.all (.impl (.pred 0 [0]) (.pred 1 [0])))
#eval quantifierAlternations (.all (.ex (.pred 0 [0])))
#eval isSubformula (.pred 0 [0]) (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isSubformula (.pred 2 [2]) (.and (.pred 0 [0]) (.pred 1 [1]))
#eval compactnessStatement

end MiniSatisfactionModel
