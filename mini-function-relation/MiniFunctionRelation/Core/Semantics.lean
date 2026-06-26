import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Tarski Semantics

Deeper semantic properties: isomorphism preserves truth, elementary equivalence,
elementary embeddings, and semantic consequence.
-/

open Formula

/-! ## Semantic consequence -/

def Theory.entails (T : Theory) (φ : Sentence) : Prop :=
  ∀ (M : Structure), Structure.satisfiesTheory M T → Structure.satisfiesSentence M φ

def Formula.valid (φ : Sentence) : Prop :=
  ∀ (M : Structure), Structure.satisfiesSentence M φ

/-! ## Isomorphism preserves truth -/

def Iso.mapAssignment {M N : Structure} (i : Iso M N) (σ : Assignment M) : Assignment N :=
  λ v => i.toHom.map (σ v)

def Iso.invMapAssignment {M N : Structure} (i : Iso M N) (τ : Assignment N) : Assignment M :=
  λ v => i.invHom.map (τ v)

@[simp]
theorem Iso.mapAssignment_invMapAssignment {M N : Structure} (i : Iso M N) (τ : Assignment N) (v : Nat) :
    i.mapAssignment (i.invMapAssignment τ) v = τ v := by
  simp [Iso.mapAssignment, Iso.invMapAssignment, i.rightInv]

@[simp]
theorem Iso.invMapAssignment_mapAssignment {M N : Structure} (i : Iso M N) (σ : Assignment M) (v : Nat) :
    i.invMapAssignment (i.mapAssignment σ) v = σ v := by
  simp [Iso.mapAssignment, Iso.invMapAssignment, i.leftInv]

theorem Term.eval_iso {M N : Structure} (i : Iso M N) (t : Term) (σ : Assignment M) :
    i.toHom.map (t.eval M σ) = t.eval N (i.mapAssignment σ) := by
  cases t; rfl

/-- An isomorphism preserves satisfaction of all formulas (fundamental lemma of model theory). -/
theorem satisfiesFormula_iso {M N : Structure} (i : Iso M N) (φ : Formula) (σ : Assignment M) :
    M.satisfiesFormula σ φ ↔ N.satisfiesFormula (i.mapAssignment σ) φ := by
  induction φ generalizing σ with
  | pred p terms =>
      simp [Structure.satisfiesFormula, Iso.mapAssignment, Term.eval_iso i, List.map_map]
      constructor
      · exact i.toHom.preservesPred _ _
      · intro h
        have h_inv : M.predInterp p ((terms.map (λ t => t.eval N (i.mapAssignment σ))).map i.invHom.map) :=
          i.invHom.preservesPred _ _ h
        have h_map : (terms.map (λ t => t.eval N (i.mapAssignment σ))).map i.invHom.map =
                     terms.map (λ t => t.eval M σ) := by
          simp [Term.eval_iso i, List.map_map, i.leftInv]
        rw [h_map] at h_inv; exact h_inv
  | eq t₁ t₂ =>
      simp [Structure.satisfiesFormula, Iso.mapAssignment, Term.eval_iso i]
      exact ⟨congrArg i.toHom.map, λ h => i.toHom_injective h⟩
  | bot =>
      simp [Structure.satisfiesFormula]
  | imp φ ψ ihφ ihψ =>
      simp [Structure.satisfiesFormula, ihφ σ, ihψ σ]
  | all v φ ih =>
      simp [Structure.satisfiesFormula]
      constructor
      · intro h y
        have hx := h (i.invHom.map y)
        rw [ih (σ.update v (i.invHom.map y))] at hx
        have h_eq : i.mapAssignment (σ.update v (i.invHom.map y)) =
                   (i.mapAssignment σ).update v y := by
          ext w; simp [Iso.mapAssignment, Assignment.update, i.rightInv]; split <;> rfl
        rw [h_eq] at hx; exact hx
      · intro h x
        have hy := h (i.toHom.map x)
        rw [← ih (σ.update v x)] at hy
        have h_eq : (i.mapAssignment σ).update v (i.toHom.map x) =
                   i.mapAssignment (σ.update v x) := by
          ext w; simp [Iso.mapAssignment, Assignment.update]; split <;> rfl
        rw [h_eq] at hy; exact hy

theorem satisfiesSentence_iso {M N : Structure} (i : Iso M N) (φ : Sentence) :
    Structure.satisfiesSentence M φ ↔ Structure.satisfiesSentence N φ := by
  simp [Structure.satisfiesSentence]
  constructor
  · intro h τ
    rw [← satisfiesFormula_iso i φ (i.invMapAssignment τ)]
    apply h
  · intro h σ
    rw [satisfiesFormula_iso i φ σ]
    apply h

theorem iso_elementarilyEquivalent {M N : Structure} (i : Iso M N) :
    elementarilyEquivalent M N := by
  intro φ; exact satisfiesSentence_iso i φ

/-! ## Elementary embeddings -/

structure ElementaryEmbedding (M N : Structure) extends Embedding M N where
  elemPreserving : ∀ (φ : Formula) (σ : Assignment M),
    M.satisfiesFormula σ φ ↔
    N.satisfiesFormula (λ v => toHom.map (σ v)) φ

structure ElementarySubstructure (M N : Structure) where
  incl : Embedding M N
  isElementary : ∀ (φ : Formula) (σ : Assignment M),
    M.satisfiesFormula σ φ ↔
    N.satisfiesFormula (λ v => incl.map (σ v)) φ

/-! ## Finitely satisfiable theories -/

theorem finitelySatisfiable_has_models (T : Theory) (h : Theory.finitelySatisfiable T)
    (T0 : Finset Sentence) (hsub : (T0 : Set Sentence) ⊆ T) :
    ∃ (M : Structure), Structure.satisfiesTheory M (T0 : Set Sentence) :=
  h T0 hsub

/-! ## Model completeness -/

/-- A theory T is model-complete if every embedding between models of T
    is elementary. -/
def Theory.isModelComplete (T : Theory) : Prop :=
  ∀ (M N : Structure) (e : Embedding M N),
    Structure.satisfiesTheory M T → Structure.satisfiesTheory N T →
    ∀ (φ : Formula) (σ : Assignment M),
      M.satisfiesFormula σ φ ↔
      N.satisfiesFormula (λ v => e.map (σ v)) φ

/-! ## Quantifier elimination (definitional) -/

/-- A theory T has quantifier elimination if every formula is T-equivalent
    to a quantifier-free formula. -/
def Theory.hasQuantifierElimination (T : Theory) : Prop :=
  ∀ (φ : Formula), ∃ (ψ : Formula), (ψ.isUniversal) ∧
    ∀ (M : Structure), Structure.satisfiesTheory M T →
      ∀ (σ : Assignment M),
        M.satisfiesFormula σ φ ↔ M.satisfiesFormula σ ψ

/-! ## Concrete structures and evaluation -/

def trivialStruct : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def twoElementStruct : Structure where
  domain := Bool
  predInterp 0 args := match args with
    | [b] => b = true
    | _ => False
  predInterp _ _ := False
  constInterp _ := false

def threeStruct : Structure where
  domain := Fin 3
  predInterp 0 args := match args with
    | [x, y] => x.val = y.val
    | _ => False
  predInterp _ _ := False
  constInterp _ := 0

def eqRefl : Formula := Formula.all 0 (Formula.eq (Term.var 0) (Term.var 0))

theorem trivial_satisfies_eqRefl : Structure.satisfiesSentence trivialStruct eqRefl := by
  intro σ; simp [eqRefl, Structure.satisfiesFormula, Term.eval]

def transitivityFormula : Formula :=
  Formula.all 0 (Formula.all 1 (Formula.all 2
    (Formula.imp
      (Formula.and (Formula.eq (Term.var 0) (Term.var 1))
                   (Formula.eq (Term.var 1) (Term.var 2)))
      (Formula.eq (Term.var 0) (Term.var 2)))))

theorem transitivity_valid (M : Structure) :
    Structure.satisfiesSentence M transitivityFormula := by
  intro σ
  simp [transitivityFormula, Formula.and, Formula.imp, Structure.satisfiesFormula, Term.eval]
  intro h1 h2; rw [h1, h2]

/-- In a 2-element domain, ∀x∀y (x=y) is false. -/
def allEq : Formula := Formula.all 0 (Formula.all 1 (Formula.eq (Term.var 0) (Term.var 1)))

theorem twoElement_not_allEq : ¬ Structure.satisfiesSentence twoElementStruct allEq := by
  intro h
  have h01 := h (λ _ => false)
  simp [allEq, Structure.satisfiesFormula, Term.eval] at h01
  have : (false : Bool) = true := h01
  exact Bool.false_ne_true this

/-- Identity embedding is elementary. -/
theorem id_is_elementary (M : Structure) : ElementaryEmbedding M M where
  toHom := Hom.id M
  injective x y h := h
  preservesPred p args h := h
  preservesConst _ := rfl
  elemPreserving := by
    intro φ σ; simp [Hom.id, Structure.satisfiesFormula]

/-- Composition of elementary embeddings is elementary. -/
theorem elemEmbedding_comp {M N O : Structure}
    (g : ElementaryEmbedding N O) (f : ElementaryEmbedding M N) :
    ElementaryEmbedding M O where
  toHom := Hom.comp g.toHom f.toHom
  injective x y h := f.injective x y (g.injective _ _ h)
  preservesPred p args h := g.preservesPred p _
    (by simpa [List.map_map] using f.preservesPred p args h)
  preservesConst c := by
    simp [Hom.comp, f.preservesConst c, g.preservesConst c]
  elemPreserving := by
    intro φ σ
    rw [f.elemPreserving φ σ, g.elemPreserving φ (λ v => f.toHom.map (σ v))]
    simp [Hom.comp]

#eval "Core.Semantics loaded — Iso preserves truth, ElementaryEmbedding, QuantifierElimination"

end MiniFunctionRelation
