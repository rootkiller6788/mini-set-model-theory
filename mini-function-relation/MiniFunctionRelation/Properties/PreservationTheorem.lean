import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Morphisms.Hom

namespace MiniFunctionRelation

/-
# Preservation Theorems

Classic preservation theorems:
- Homomorphisms preserve positive formulas
- Embeddings preserve existential formulas
- Embeddings preserve and reflect quantifier-free formulas
-/

open Formula

/-! ## Positive formulas (no negation, no implication to ⊥) -/

inductive Positive : Formula → Prop where
  | pred (p : Nat) (terms : List Term) : Positive (Formula.pred p terms)
  | eq (t₁ t₂ : Term) : Positive (Formula.eq t₁ t₂)
  | and (φ ψ : Formula) : Positive φ → Positive ψ → Positive (Formula.and φ ψ)
  | or (φ ψ : Formula) : Positive φ → Positive ψ → Positive (Formula.or φ ψ)
  | all (v : Nat) (φ : Formula) : Positive φ → Positive (Formula.all v φ)
  | ex (v : Nat) (φ : Formula) : Positive φ → Positive (Formula.ex v φ)

theorem hom_preserves_positive {M N : Structure} (f : Hom M N) (φ : Formula) (hpos : Positive φ)
    (σ : Assignment M) :
    M.satisfiesFormula σ φ → N.satisfiesFormula (λ v => f.map (σ v)) φ := by
  induction hpos with
  | pred p terms =>
      simp [Structure.satisfiesFormula]
      intro h
      have h_map : (terms.map (λ t => t.eval N (λ v => f.map (σ v)))) =
                  (terms.map (λ t => t.eval M σ)).map f.map := by
        simp [Term.eval, List.map_map]
      rw [h_map]
      exact f.preservesPred p _ h
  | eq t₁ t₂ =>
      simp [Structure.satisfiesFormula, Term.eval]
      intro h; rw [h]
  | and φ ψ hφ hψ ihφ ihψ =>
      simp [Formula.and, Formula.not, Structure.satisfiesFormula]
      intro h; exact ⟨ihφ σ h.1, ihψ σ h.2⟩
  | or φ ψ hφ hψ ihφ ihψ =>
      simp [Formula.or, Formula.not, Structure.satisfiesFormula]
      intro h; rcases h with (h' | h'); left; exact ihφ σ h'; right; exact ihψ σ h'
  | all v φ hφ ih =>
      simp [Structure.satisfiesFormula]
      intro h x
      have hx := h x
      have := ih (σ.update v x) hx
      have h_eq : (λ w => f.map ((σ.update v x) w)) =
                 ((λ w => f.map (σ w)).update v (f.map x)) := by
        ext w; simp [Assignment.update]; split <;> rfl
      rw [h_eq]; exact this
  | ex v φ hφ ih =>
      simp [Formula.ex, Formula.not, Structure.satisfiesFormula]
      intro ⟨x, hx⟩
      have hx' := ih (σ.update v x) hx
      have h_eq : (λ w => f.map ((σ.update v x) w)) =
                 ((λ w => f.map (σ w)).update v (f.map x)) := by
        ext w; simp [Assignment.update]; split <;> rfl
      rw [h_eq] at hx'
      exact ⟨f.map x, hx'⟩

/-! ## Existential formulas -/

inductive Existential : Formula → Prop where
  | pred (p : Nat) (terms : List Term) : Existential (Formula.pred p terms)
  | eq (t₁ t₂ : Term) : Existential (Formula.eq t₁ t₂)
  | and (φ ψ : Formula) : Existential φ → Existential ψ → Existential (Formula.and φ ψ)
  | or (φ ψ : Formula) : Existential φ → Existential ψ → Existential (Formula.or φ ψ)
  | ex (v : Nat) (φ : Formula) : Existential φ → Existential (Formula.ex v φ)

theorem embedding_preserves_existential {M N : Structure} (e : Embedding M N) (φ : Formula)
    (hex : Existential φ) (σ : Assignment M) :
    M.satisfiesFormula σ φ → N.satisfiesFormula (λ v => e.map (σ v)) φ := by
  induction hex with
  | pred p terms =>
      simp [Structure.satisfiesFormula]
      intro h
      have h_map : (terms.map (λ t => t.eval N (λ v => e.map (σ v)))) =
                  (terms.map (λ t => t.eval M σ)).map e.map := by
        simp [Term.eval, List.map_map]
      rw [h_map]
      exact e.preservesPred p _ h
  | eq t₁ t₂ =>
      simp [Structure.satisfiesFormula, Term.eval]
      intro h; rw [h]
  | and φ ψ hφ hψ ihφ ihψ =>
      simp [Formula.and, Formula.not, Structure.satisfiesFormula]
      intro h; exact ⟨ihφ σ h.1, ihψ σ h.2⟩
  | or φ ψ hφ hψ ihφ ihψ =>
      simp [Formula.or, Formula.not, Structure.satisfiesFormula]
      intro h; rcases h with (h' | h'); left; exact ihφ σ h'; right; exact ihψ σ h'
  | ex v φ hφ ih =>
      simp [Formula.ex, Formula.not, Structure.satisfiesFormula]
      intro ⟨x, hx⟩
      have hx' := ih (σ.update v x) hx
      have h_eq : (λ w => e.map ((σ.update v x) w)) =
                 ((λ w => e.map (σ w)).update v (e.map x)) := by
        ext w; simp [Assignment.update]; split <;> rfl
      rw [h_eq] at hx'
      exact ⟨e.map x, hx'⟩

/-! ## Quantifier-free formulas -/

inductive QuantifierFree : Formula → Prop where
  | pred (p : Nat) (terms : List Term) : QuantifierFree (Formula.pred p terms)
  | eq (t₁ t₂ : Term) : QuantifierFree (Formula.eq t₁ t₂)
  | bot : QuantifierFree Formula.bot
  | imp (φ ψ : Formula) : QuantifierFree φ → QuantifierFree ψ → QuantifierFree (Formula.imp φ ψ)

/-- Embeddings forward-preserve quantifier-free formulas. -/
theorem embedding_qf_forward {M N : Structure} (e : Embedding M N) (φ : Formula) (hqf : QuantifierFree φ)
    (σ : Assignment M) :
    M.satisfiesFormula σ φ → N.satisfiesFormula (λ v => e.map (σ v)) φ := by
  induction hqf with
  | pred p terms =>
      simp [Structure.satisfiesFormula]
      intro h
      have h_map : (terms.map (λ t => t.eval N (λ v => e.map (σ v)))) =
                  (terms.map (λ t => t.eval M σ)).map e.map := by
        simp [Term.eval, List.map_map]
      rw [h_map]; exact e.preservesPred p _ h
  | eq t₁ t₂ =>
      simp [Structure.satisfiesFormula, Term.eval]
      intro h; rw [h]
  | bot =>
      simp [Structure.satisfiesFormula]
  | imp φ ψ hφ hψ ihφ ihψ =>
      simp [Structure.satisfiesFormula]
      intro h hpos
      apply ihψ σ
      apply h
      apply ihφ σ
      exact hpos

/-- Strong embeddings preserve and reflect all quantifier-free formulas. -/
theorem strongEmbedding_qf_iff {M N : Structure} (se : StrongEmbedding M N) (φ : Formula)
    (hqf : QuantifierFree φ) (σ : Assignment M) :
    M.satisfiesFormula σ φ ↔ N.satisfiesFormula (λ v => se.map (σ v)) φ := by
  induction hqf with
  | pred p terms =>
      simp [Structure.satisfiesFormula]
      constructor
      · intro h
        have h_map : (terms.map (λ t => t.eval N (λ v => se.map (σ v)))) =
                    (terms.map (λ t => t.eval M σ)).map se.map := by
          simp [Term.eval, List.map_map]
        rw [h_map]; exact se.preservesPred p _ h
      · intro h
        have h_map : (terms.map (λ t => t.eval N (λ v => se.map (σ v)))) =
                    (terms.map (λ t => t.eval M σ)).map se.map := by
          simp [Term.eval, List.map_map]
        rw [h_map] at h
        exact se.preservesPredRev p _ h
  | eq t₁ t₂ =>
      simp [Structure.satisfiesFormula, Term.eval]
      constructor
      · intro h; rw [h]
      · apply se.injective
  | bot => simp [Structure.satisfiesFormula]
  | imp φ ψ hφ hψ ihφ ihψ =>
      simp [Structure.satisfiesFormula, ihφ σ, ihψ σ]

/-! ## Concrete examples -/

def natStruct : Structure where
  domain := Nat
  predInterp 0 args := match args with
    | [x, y] => x ≤ y
    | _ => False
  predInterp _ _ := False
  constInterp _ := 0

def intStruct : Structure where
  domain := Int
  predInterp 0 args := match args with
    | [x, y] => x ≤ y
    | _ => False
  predInterp _ _ := False
  constInterp _ := 0

def inclusionHom : Hom natStruct intStruct where
  map x := (x : Int)
  preservesPred p args h := by
    simp [natStruct, intStruct] at h ⊢
    match p with
    | 0 => exact h
    | _ => trivial
  preservesConst _ := rfl

def inclEmbedding : Embedding natStruct intStruct where
  toHom := inclusionHom
  injective x y h := by
    simpa using h

def inclStrong : StrongEmbedding natStruct intStruct where
  toHom := inclusionHom
  injective x y h := by simpa using h
  preservesPredRev p args h := by
    simp [natStruct, intStruct] at h ⊢
    match p with
    | 0 => exact h
    | _ => trivial

def positiveExample : Formula :=
  Formula.ex 1 (Formula.pred 0 [Term.var 0, Term.var 1])

example : Positive positiveExample :=
  Positive.ex 1 (Positive.pred 0 [Term.var 0, Term.var 1])

#eval "PreservationTheorem.lean loaded"
#eval "  Homomorphisms preserve positive formulas"
#eval "  Embeddings preserve existential formulas"
#eval "  Strong embeddings preserve/reflect quantifier-free formulas"

end MiniFunctionRelation
