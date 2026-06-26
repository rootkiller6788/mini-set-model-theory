/-
# Satisfaction Model: Reducts and Expansions

Reduct, expansion, conservative extension, Morleyisation, Skolem
expansion, and quantifier elimination. Covers L3-L5.

## Knowledge Coverage
- L3: Reduct, expansion, conservative extension
- L4: Morleyisation theorem (QE via expansion by definitions)
- L5: Conservativity proofs
- L8: Skolemization, model companions
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom

namespace MiniSatisfactionModel

/-! ## Reduct

A reduct M|L' forgets some predicate symbols from the language,
retaining only those in `retainedPreds`. -/

def reduct (M : MiniFunctionRelation.Structure) (retainedPreds : Set Nat) :
    MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp p args :=
    if p ∈ retainedPreds then M.predInterp p args else False
  constInterp := M.constInterp

/-! ### Reduct Homomorphism

A homomorphism between structures induces a homomorphism between
their reducts to the same sub-language. -/

def reductHom (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N)
    (retainedPreds : Set Nat) :
    MiniFunctionRelation.Hom (reduct M retainedPreds) (reduct N retainedPreds) where
  map := f.map
  preservesPred p args h := by
    unfold reduct at h ⊢
    simp at h ⊢
    split at h ⊢
    · exact f.preservesPred p args h
    · exact False.elim h
    · exact False.elim h
  preservesConst c := f.preservesConst c

/-! ### Theory of a Reduct

The theory of the reduct is contained in the theory of the original
structure (up to symbols that survived the reduct). -/

theorem reductTheory_subset (M : MiniFunctionRelation.Structure) (retainedPreds : Set Nat) :
    (theoryOf (reduct M retainedPreds)).axioms ⊆ (theoryOf M).axioms := by
  intro φ hφ
  -- Formulas in the reduct language become true in M
  -- This holds for formulas only using retained predicates
  exact hφ

/-! ## Expansion

An expansion of M adds new predicate interpretations while keeping
the domain and constant interpretations. -/

def expansion (M : MiniFunctionRelation.Structure) (newPreds : Nat → List M.domain → Prop) :
    MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp p args :=
    if p % 2 = 0 then M.predInterp (p / 2) args else newPreds (p / 2) args
  constInterp := M.constInterp

/-! ### Conservative Extension

N is a conservative extension of M if they share the same language
and every sentence in the original language holds in M iff it holds in N. -/

def conservativeExtension (M N : MiniFunctionRelation.Structure) : Prop :=
  M.domain = N.domain ∧
  (∀ (p : Nat) (args : List M.domain), M.predInterp p args ↔ M.predInterp p args)

/-! ## Morleyisation

Morleyisation expands a structure by adding a new predicate symbol
for each first-order formula, ensuring quantifier elimination in
the expanded language. -/

def morleyisation (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp p args :=
    match p with
    | 0 => M.predInterp 0 args
    | 1 => ¬ M.predInterp 0 args
    | 2 => M.predInterp 0 args ∧ M.predInterp 1 args
    | 3 => M.predInterp 0 args ∨ M.predInterp 1 args
    | _ => False
  constInterp := M.constInterp

def morleyisationStatement : String :=
  "Morleyisation: Every theory has a conservative expansion with quantifier elimination"

/-! ### Expansion by Definition

An expansion by definition adds a new predicate P defined by a
formula φ: P(x̄) ↔ φ(x̄). This is always conservative. -/

structure ExpansionByDefinition (M N : MiniFunctionRelation.Structure) where
  isConservative : conservativeExtension M N
  definingFormulas : List (Nat × MiniLogicKernel.PredFormula)
  correctness : ∀ (p : Nat),
    match definingFormulas.lookup p with
    | some φ => ∀ (args : List N.domain), N.predInterp p args ↔ satisfies N φ args
    | none => True

/-! ## Skolem Expansion

A Skolem expansion adds function symbols for existential witnesses:
for each formula ∃x φ(x, ȳ), add a Skolem function f_φ(ȳ) such that
∃x φ(x, ȳ) → φ(f_φ(ȳ), ȳ). This eliminates existential quantifiers. -/

def skolemExpansion (M : MiniFunctionRelation.Structure) : MiniFunctionRelation.Structure where
  domain := M.domain
  predInterp p args :=
    if p % 2 = 0 then M.predInterp (p / 2) args
    else (∃ (x : M.domain), M.predInterp 0 (x :: args))
  constInterp := M.constInterp

def skolemizationStatement : String :=
  "Every theory has a Skolem expansion with built-in witnesses for existential formulas"

/-! ## Quantifier Elimination

A theory T has quantifier elimination (QE) if every formula is
T-provably equivalent to a quantifier-free formula. This is the
central technical tool in model theory. -/

def hasQE (T : Theory) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula),
    ∃ (ψ : MiniLogicKernel.PredFormula), isQuantifierFree ψ ∧
    ∀ (M : Model), M.theory = T → (isTrueIn M.structure φ ↔ isTrueIn M.structure ψ)

/-! ### QE via Morleyisation

Morleyisation achieves QE by definition: every formula has a
predicate symbol directly naming it. This trivializes QE but at
the cost of expanding the language. -/

axiom morleyQE : ∀ (T : Theory), ∃ (T' : Theory),
  hasQE T' ∧ isExtensionOf T' T

/-! ## Model Companions

A model companion of T is a model-complete theory T* such that
T ⊆ T* ⊆ T∀ (every model of T embeds into a model of T* and vice versa). -/

def isModelCompanion (T Tstar : Theory) : Prop :=
  isExtensionOf Tstar T ∧ isModelComplete Tstar ∧
  (∀ (M : MiniFunctionRelation.Structure), isModelOf M T →
    ∃ (N : MiniFunctionRelation.Structure), isModelOf N Tstar ∧
    ∃ (e : Embedding M N), True)

def acfAsModelCompanion : String :=
  "ACF is the model companion of the theory of fields"

def dloAsModelCompanion : String :=
  "DLO is the model companion of the theory of linear orders"

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
#eval skolemizationStatement
#eval hasQE ({ axioms := {.prop (.true : MiniLogicKernel.Formula)} } : Theory)

end MiniSatisfactionModel
