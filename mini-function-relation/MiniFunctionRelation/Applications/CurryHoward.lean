import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax

namespace MiniFunctionRelation

/-
# Curry-Howard Correspondence for Model Theory

The connection between first-order logic and type theory:
- Formulas are types
- Proofs are programs (λ-terms)
- Models provide computational interpretations
- Satisfaction = normalization
-/

/-! ## Types as Formulas -/

/-- The Curry-Howard isomorphism maps propositions to types.
    Here we define the type corresponding to a formula. -/
def Formula.asType (M : Structure) (φ : Formula) (σ : Assignment M) : Type :=
  M.satisfiesFormula σ φ

/-- A proof of φ in M under σ is a term of type (M.satisfiesFormula σ φ).
    This is exactly the Curry-Howard view of proofs as terms. -/
def Proof (M : Structure) (φ : Formula) (σ : Assignment M) : Type :=
  M.satisfiesFormula σ φ

/-- Implication elimination (modus ponens) corresponds to function application. -/
def modusPonens {M : Structure} {φ ψ : Formula} {σ : Assignment M}
    (h_imp : Proof M (Formula.imp φ ψ) σ) (h_φ : Proof M φ σ) : Proof M ψ σ :=
  h_imp h_φ

/-- Implication introduction corresponds to λ-abstraction. -/
def implicationIntro {M : Structure} {φ ψ : Formula} {σ : Assignment M}
    (f : Proof M φ σ → Proof M ψ σ) : Proof M (Formula.imp φ ψ) σ :=
  f

/-- Universal quantification elimination: ∀x.φ → φ[t/x]. -/
def forallElim {M : Structure} {v : Nat} {φ : Formula} {σ : Assignment M} (x : M.domain)
    (h_all : Proof M (Formula.all v φ) σ) : Proof M φ (σ.update v x) :=
  h_all x

/-- Universal quantification introduction: if ⊢ φ[σ(v:=x)] for all x, then ⊢ ∀v.φ. -/
def forallIntro {M : Structure} {v : Nat} {φ : Formula} {σ : Assignment M}
    (h : ∀ (x : M.domain), Proof M φ (σ.update v x)) : Proof M (Formula.all v φ) σ :=
  h

/-- Conjunction elimination left: φ∧ψ → φ. -/
def andElimLeft {M : Structure} {φ ψ : Formula} {σ : Assignment M}
    (h_and : Proof M (Formula.and φ ψ) σ) : Proof M φ σ :=
  h_and.1

/-- Conjunction elimination right: φ∧ψ → ψ. -/
def andElimRight {M : Structure} {φ ψ : Formula} {σ : Assignment M}
    (h_and : Proof M (Formula.and φ ψ) σ) : Proof M ψ σ :=
  h_and.2

/-- Conjunction introduction: φ → ψ → φ∧ψ. -/
def andIntro {M : Structure} {φ ψ : Formula} {σ : Assignment M}
    (h_φ : Proof M φ σ) (h_ψ : Proof M ψ σ) : Proof M (Formula.and φ ψ) σ :=
  And.intro h_φ h_ψ

/-! ## Model theory as computational semantics -/

/-- A structure M provides a computational interpretation of a formula φ:
    a program of type φ is a proof (realizer) in M. -/
def Interprets (M : Structure) (φ : Formula) : Prop :=
  Structure.satisfiesSentence M φ

/-- Model checking for quantifier-free formulas in a finite structure
    is algorithmically decidable by exhaustive search.
    (Stated as an acknowledged property; implementation requires
    traversal over the finite domain for quantifiers.) -/

/-! ## Soundness of proofs in a model -/

/-- If M ⊨ φ and we have a derivation of φ in M,
    the program corresponding to the derivation computes a realizer. -/
def isSoundProof {M : Structure} (φ : Formula) (σ : Assignment M)
    (derivation : Proof M φ σ) : Prop :=
  M.satisfiesFormula σ φ

/-- Trivial soundness: a proof of φ in M is exactly a realizer of φ in M. -/
theorem soundness_trivial {M : Structure} (φ : Formula) (σ : Assignment M)
    (p : Proof M φ σ) : isSoundProof φ σ p :=
  p

/-! ## Completeness via Henkin (sketch) -/

/-- Henkin's proof of completeness: every consistent set of sentences
    has a model built from the constants of the language.
    TODO: formalize the Henkin construction (term model with provability as truth). -/
def HenkinModel (T : Theory) (h_consistent : Theory.consistent T) : Structure where
  domain := Term    -- use closed terms as domain
  predInterp p args := sorry
  constInterp c := Term.var c

/-! ## Connection to LF and type systems -/

/-- The logical framework LF represents formulas as types
    and proofs as λ-terms. Our `Proof` type is an embedding
    of this idea in Lean's own type theory. -/
inductive LFType : Type where
  | o : LFType                           -- type of propositions
  | imp : LFType → LFType → LFType       -- implication type
  | forall : LFType → LFType             -- universal type (simplified)

/-- LF-style typing: a proof is a term of a given type in a context. -/
def ProofTerm := Nat  -- simplified: de Bruijn index

/-- Embedding of our Formula type into LF types. -/
def Formula.toLF : Formula → LFType
  | Formula.pred _ _ => LFType.o
  | Formula.eq _ _ => LFType.o
  | Formula.bot => LFType.o
  | Formula.imp φ ψ => LFType.imp (toLF φ) (toLF ψ)
  | Formula.all _ φ => LFType.forall (toLF φ)

/-! ## Prop-valued models (Kripke semantics generalization) -/

/-- A Prop-valued model (simplified) assigns propositions to formulas,
    generalizing Tarski semantics to intuitionistic logic via Kripke models. -/
structure PropValuedModel where
  domain : Type
  predInterp : Nat → List domain → Prop
  constInterp : Nat → domain

/-- Truth in a Prop-valued model (classical, not forcing).
    Same as standard Tarski semantics but as a generic construction. -/
def PropValuedModel.satisfiesFormula (M : PropValuedModel)
    (σ : Assignment {
      domain := M.domain
      predInterp := M.predInterp
      constInterp := M.constInterp
    }) : Formula → Prop
  | Formula.pred p terms => M.predInterp p (terms.map (λ t =>
      t.eval {domain := M.domain | predInterp := M.predInterp | constInterp := M.constInterp} σ))
  | Formula.eq t₁ t₂ =>
      t₁.eval {domain := M.domain | predInterp := M.predInterp | constInterp := M.constInterp} σ =
      t₂.eval {domain := M.domain | predInterp := M.predInterp | constInterp := M.constInterp} σ
  | Formula.bot => False
  | Formula.imp φ ψ => (satisfiesFormula M σ φ) → (satisfiesFormula M σ ψ)
  | Formula.all v φ => ∀ (x : M.domain), satisfiesFormula M (σ.update v x) φ

/-! ## Curry-Howard examples -/

/-- The identity formula: φ → φ. -/
def identityFormula (φ : Formula) : Formula :=
  Formula.imp φ φ

/-- Proof of φ → φ in any model. -/
def identityProof (M : Structure) (φ : Formula) (σ : Assignment M) :
    Proof M (identityFormula φ) σ :=
  λ h => h

/-- Commutation: (φ → ψ → χ) → (ψ → φ → χ). -/
def commProof (M : Structure) (φ ψ χ : Formula) (σ : Assignment M) :
    Proof M (Formula.imp
      (Formula.imp φ (Formula.imp ψ χ))
      (Formula.imp ψ (Formula.imp φ χ))) σ :=
  λ f y x => f x y

/-- The K combinator: φ → ψ → φ. -/
def kProof (M : Structure) (φ ψ : Formula) (σ : Assignment M) :
    Proof M (Formula.imp φ (Formula.imp ψ φ)) σ :=
  λ x _ => x

/-- The S combinator: (φ → ψ → χ) → (φ → ψ) → φ → χ. -/
def sProof (M : Structure) (φ ψ χ : Formula) (σ : Assignment M) :
    Proof M (Formula.imp
      (Formula.imp φ (Formula.imp ψ χ))
      (Formula.imp (Formula.imp φ ψ)
        (Formula.imp φ χ))) σ :=
  λ f g x => f x (g x)

/-! ## Example structure for type interpretation -/

def unitStructure : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

example : Proof unitStructure Formula.top (λ _ => ()) := by
  simp [Formula.top, Structure.satisfiesFormula, unitStructure]

#eval "CurryHoward.lean loaded"
#eval "  Curry-Howard correspondence for first-order logic"
#eval "  Proof = Type, modusPonens = function application"
#eval "  identityProof, commProof, kProof, sProof"
#eval "  Boolean-valued models, LF type embedding"

end MiniFunctionRelation
