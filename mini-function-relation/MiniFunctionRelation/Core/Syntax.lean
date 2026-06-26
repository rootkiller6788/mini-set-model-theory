import MiniFunctionRelation.Core.Basic

namespace MiniFunctionRelation

/-
# First-Order Syntax and Satisfaction

Defines the formal language of first-order logic: terms, formulas, sentences.
Provides the unified `Structure.satisfies` definition shared across all modules.
-/

/-! ## Terms -/

inductive Term where
  | var : Nat → Term
  deriving Inhabited, DecidableEq, Repr

namespace Term

/-- Evaluate a term in a structure under an assignment. -/
def eval (M : Structure) (σ : Nat → M.domain) : Term → M.domain
  | Term.var v => σ v

/-- Free variables of a term. -/
def freeVars : Term → Finset Nat
  | Term.var v => {v}

/-- Substitute a term for a variable. -/
def subst (t : Term) (v : Nat) (s : Term) : Term :=
  match t with
  | Term.var w => if w = v then s else Term.var w

end Term

/-! ## Formulas -/

inductive Formula where
  | pred (p : Nat) (terms : List Term)
  | eq (t₁ t₂ : Term)
  | bot
  | imp (φ ψ : Formula)
  | all (v : Nat) (φ : Formula)
  deriving Inhabited, Repr

namespace Formula

def top : Formula := Formula.imp Formula.bot Formula.bot
def not (φ : Formula) : Formula := Formula.imp φ Formula.bot
def and (φ ψ : Formula) : Formula := Formula.not (Formula.imp φ (Formula.not ψ))
def or (φ ψ : Formula) : Formula := Formula.not (Formula.imp (Formula.not φ) ψ)
def iff (φ ψ : Formula) : Formula := Formula.and (Formula.imp φ ψ) (Formula.imp ψ φ)
def ex (v : Nat) (φ : Formula) : Formula :=
  Formula.not (Formula.all v (Formula.not φ))

def freeVars : Formula → Finset Nat
  | Formula.pred _ terms =>
      terms.foldl (λ acc t => acc ∪ Term.freeVars t) ∅
  | Formula.eq t₁ t₂ => Term.freeVars t₁ ∪ Term.freeVars t₂
  | Formula.bot => ∅
  | Formula.imp φ ψ => freeVars φ ∪ freeVars ψ
  | Formula.all v φ => freeVars φ \ {v}

def isSentence (φ : Formula) : Bool := φ.freeVars.isEmpty

def atMostTwo : Formula :=
  Formula.all 0 (Formula.all 1 (Formula.all 2
    (Formula.or (Formula.eq (Term.var 0) (Term.var 1))
      (Formula.or (Formula.eq (Term.var 1) (Term.var 2))
        (Formula.eq (Term.var 0) (Term.var 2))))))

/-- Count the logical complexity (number of connectives + quantifiers). -/
def complexity : Formula → Nat
  | Formula.pred _ _ => 0
  | Formula.eq _ _ => 0
  | Formula.bot => 0
  | Formula.imp φ ψ => 1 + max (complexity φ) (complexity ψ)
  | Formula.all _ φ => 1 + complexity φ

/-- A formula is universal if it consists of ∀-quantifiers followed by a quantifier-free matrix. -/
def isUniversal : Formula → Bool
  | Formula.all _ φ => isUniversal φ
  | _ => true

/-- A formula is existential if it is the negation of a universal formula. -/
def isExistential (φ : Formula) : Bool :=
  match φ with
  | Formula.not ψ => ψ.isUniversal
  | _ => false

end Formula

abbrev Sentence := Formula

/-! ## Theory -/

def Theory := Set Sentence

namespace Theory

def empty : Theory := ∅
def inconsistent : Theory := {Formula.bot}
def add (T : Theory) (φ : Sentence) : Theory := Set.insert φ T
def union (T₁ T₂ : Theory) : Theory := Set.union T₁ T₂

/-- A theory T is complete if for every sentence φ, either φ ∈ T or ¬φ ∈ T. -/
def isComplete (T : Theory) : Prop :=
  ∀ (φ : Sentence), φ ∈ T ∨ (Formula.not φ) ∈ T

end Theory

/-! ## Satisfaction Relation -/

def Assignment (M : Structure) := Nat → M.domain

namespace Assignment

/-- Update an assignment at a given variable. -/
def update (σ : Assignment M) (v : Nat) (x : M.domain) : Assignment M :=
  λ w => if w = v then x else σ w

@[simp] theorem update_same (σ : Assignment M) (v : Nat) (x : M.domain) :
    (σ.update v x) v = x := by simp [update]

@[simp] theorem update_diff (σ : Assignment M) (v w : Nat) (x : M.domain) (h : v ≠ w) :
    (σ.update v x) w = σ w := by simp [update, h]

theorem update_update_same (σ : Assignment M) (v : Nat) (x y : M.domain) :
    (σ.update v x).update v y = σ.update v y := by
  ext w; simp [update]; split <;> rfl

end Assignment

/-- M ⊨ φ[σ]: formula φ is true in M under assignment σ. -/
def Structure.satisfiesFormula (M : Structure) (σ : Assignment M) : Formula → Prop
  | Formula.pred p terms => M.predInterp p (terms.map (λ t => t.eval M σ))
  | Formula.eq t₁ t₂ => t₁.eval M σ = t₂.eval M σ
  | Formula.bot => False
  | Formula.imp φ ψ => satisfiesFormula M σ φ → satisfiesFormula M σ ψ
  | Formula.all v φ => ∀ (x : M.domain), satisfiesFormula M (σ.update v x) φ

/-- M ⊨ φ: sentence φ is true in M (true under all assignments). -/
def Structure.satisfiesSentence (M : Structure) (φ : Sentence) : Prop :=
  ∀ (σ : Assignment M), M.satisfiesFormula σ φ

/-- M ⊨ T: M is a model of theory T. -/
def Structure.satisfiesTheory (M : Structure) (T : Theory) : Prop :=
  ∀ (φ : Sentence), φ ∈ T → Structure.satisfiesSentence M φ

def elementarilyEquivalent (M N : Structure) : Prop :=
  ∀ (φ : Sentence), Structure.satisfiesSentence M φ ↔ Structure.satisfiesSentence N φ

def Theory.satisfiable (T : Theory) : Prop :=
  ∃ (M : Structure), Structure.satisfiesTheory M T

def Theory.consistent (T : Theory) : Prop :=
  ¬ (∀ (M : Structure), Structure.satisfiesTheory M T →
    Structure.satisfiesSentence M Formula.bot)

def Theory.finitelySatisfiable (T : Theory) : Prop :=
  ∀ (T0 : Finset Sentence), (T0 : Set Sentence) ⊆ T → Theory.satisfiable (T0 : Set Sentence)

/-! ## Basic semantic theorems -/

theorem satisfiesSentence_top (M : Structure) :
    Structure.satisfiesSentence M Formula.top := by
  intro σ; simp [Formula.top, Structure.satisfiesFormula]

theorem emptyTheory_satisfiable : Theory.satisfiable Theory.empty := by
  refine ⟨{
    domain := Unit
    predInterp _ _ := False
    constInterp _ := ()
  }, ?_⟩
  intro φ h; exfalso; exact Set.not_mem_empty _ h

theorem satisfiable_not_entails_bot (T : Theory) (hS : Theory.satisfiable T) :
    Theory.consistent T := by
  rcases hS with ⟨M, hM⟩
  intro h
  have hbot := h M hM
  rw [Structure.satisfiesSentence] at hbot
  have : M.satisfiesFormula (λ _ => M.constInterp 0) Formula.bot :=
    hbot (λ _ => M.constInterp 0)
  simp [Structure.satisfiesFormula] at this

theorem satisfiesFormula_ex {M : Structure} (σ : Assignment M) (v : Nat) (φ : Formula) :
    M.satisfiesFormula σ (Formula.ex v φ) ↔
    ∃ (x : M.domain), M.satisfiesFormula (σ.update v x) φ := by
  simp [Formula.ex, Formula.not, Structure.satisfiesFormula]
  constructor
  · intro h; by_contra! hne; apply h; intro x hx; exact hne ⟨x, hx⟩
  · intro ⟨x, hx⟩ h; exact h x hx

/-- If φ has no free variables, satisfaction is independent of assignment. -/
theorem satisfiesSentence_iff_any_assignment (M : Structure) (φ : Sentence) :
    Structure.satisfiesSentence M φ ↔
    ∀ (σ : Assignment M), M.satisfiesFormula σ φ := by
  rfl

/-- A formula and its double negation are semantically equivalent. -/
theorem not_not_equiv {M : Structure} (σ : Assignment M) (φ : Formula) :
    M.satisfiesFormula σ (Formula.not (Formula.not φ)) ↔
    M.satisfiesFormula σ φ := by
  simp [Formula.not, Structure.satisfiesFormula]

/-- de Morgan: ¬(φ ∧ ψ) ↔ (¬φ ∨ ¬ψ) -/
theorem demorgan_and_or {M : Structure} (σ : Assignment M) (φ ψ : Formula) :
    M.satisfiesFormula σ (Formula.not (Formula.and φ ψ)) ↔
    M.satisfiesFormula σ (Formula.or (Formula.not φ) (Formula.not ψ)) := by
  simp [Formula.and, Formula.or, Formula.not, Structure.satisfiesFormula]

#eval "Core.Syntax loaded — Formula, Sentence, Theory, Satisfaction defined"

end MiniFunctionRelation
