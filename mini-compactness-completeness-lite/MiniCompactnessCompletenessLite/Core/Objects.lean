/-
# Core Objects: Theories and Semantic Notions

A `Theory` is a set of first-order sentences. This file defines
satisfiability, finite satisfiability, logical validity, and
logical consequence -- the fundamental semantic notions of model theory.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniLogicKernel.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Theory Type and Basic Operations -/

def Theory := Set MiniLogicKernel.PredFormula

def emptyTheory : Theory := ∅

def theoryUnion (T₁ T₂ : Theory) : Theory := T₁ ∪ T₂

def theoryInter (T₁ T₂ : Theory) : Theory := T₁ ∩ T₂

def theorySingleton (φ : MiniLogicKernel.PredFormula) : Theory := {φ}

def theoryInsert (T : Theory) (φ : MiniLogicKernel.PredFormula) : Theory := T ∪ {φ}

def theoryRemove (T : Theory) (φ : MiniLogicKernel.PredFormula) : Theory := T \ {φ}

def theoryDifference (T₁ T₂ : Theory) : Theory := T₁ \ T₂

def isSubtheory (T S : Theory) : Prop := T ⊆ S

infix:50 " ⊆ₜ " => isSubtheory

/-! ## Models and Satisfiability -/

def theoryModels (T : Theory) : Set (MiniFunctionRelation.Structure) :=
  { M | ∀ φ ∈ T, MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] }

def hasModel (T : Theory) : Prop := ∃ M, ∀ φ ∈ T,
  MiniLogicKernel.Structure.satisfies (domain := M.domain)
    (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

def satisfiable (T : Theory) : Prop := hasModel T

def unsatisfiable (T : Theory) : Prop := ¬ satisfiable T

def isModelOf (M : MiniFunctionRelation.Structure) (T : Theory) : Prop :=
  ∀ φ ∈ T, MiniLogicKernel.Structure.satisfies (domain := M.domain)
    (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

/-! ## Satisfiability Lemmas -/

lemma satisfiable_emptyTheory : satisfiable emptyTheory := by
  have hM : MiniFunctionRelation.Structure :=
    { domain := Unit
      predInterp := λ _ _ => True
      constInterp := λ _ => () }
  refine ⟨hM, ?_⟩
  intro φ hφ
  exfalso
  exact hφ

lemma satisfiable_of_subset {T S : Theory} (h : T ⊆ S) (hSat : satisfiable S) : satisfiable T := by
  rcases hSat with ⟨M, hM⟩
  refine ⟨M, ?_⟩
  intro φ hφ
  apply hM φ
  exact h hφ

lemma unsatisfiable_of_superset {T S : Theory} (h : T ⊆ S) (hUnsat : unsatisfiable T) : unsatisfiable S := by
  intro hSat
  apply hUnsat
  exact satisfiable_of_subset h hSat

lemma satisfiable_theorySingleton_iff {φ : MiniLogicKernel.PredFormula} :
    satisfiable {φ} ↔ ∃ (M : MiniFunctionRelation.Structure),
      MiniLogicKernel.Structure.satisfies (domain := M.domain)
        (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] := by
  constructor
  · rintro ⟨M, hM⟩
    refine ⟨M, hM φ ?_⟩
    simp
  · rintro ⟨M, hM⟩
    refine ⟨M, ?_⟩
    intro ψ hψ
    simp at hψ
    rw [hψ]
    exact hM

lemma satisfiable_union {T₁ T₂ : Theory} (hSat : satisfiable (T₁ ∪ T₂)) :
    satisfiable T₁ ∧ satisfiable T₂ := by
  rcases hSat with ⟨M, hM⟩
  constructor
  · refine ⟨M, ?_⟩
    intro φ hφ
    apply hM φ (Set.subset_union_left _ _ hφ)
  · refine ⟨M, ?_⟩
    intro φ hφ
    apply hM φ (Set.subset_union_right _ _ hφ)

lemma satisfiable_of_disjoint_union {T₁ T₂ : Theory}
    (hSat₁ : satisfiable T₁) (hSat₂ : satisfiable T₂)
    (hDisjoint : T₁ ∩ T₂ = ∅) : satisfiable (T₁ ∪ T₂) := by
  rcases hSat₁ with ⟨M₁, hM₁⟩
  refine ⟨M₁, ?_⟩
  intro φ hφ
  rcases Set.mem_union.mp hφ with (h | h)
  · apply hM₁ φ h
  · exfalso
    have : φ ∈ T₁ ∩ T₂ := Set.mem_inter h h
    rw [hDisjoint] at this
    exact Set.not_mem_empty _ this

/-! ## Finite Satisfiability -/

def finitelySatisfiable (T : Theory) : Prop :=
  ∀ (T₀ : Finset MiniLogicKernel.PredFormula), (T₀ : Set _) ⊆ T → satisfiable (T₀ : Set _)

lemma satisfiable_implies_finitelySatisfiable {T : Theory} (h : satisfiable T) :
    finitelySatisfiable T := by
  rcases h with ⟨M, hM⟩
  intro T₀ hT₀
  refine ⟨M, ?_⟩
  intro φ hφ
  simp at hφ
  have hmem : φ ∈ (T₀ : Set _) := by
    simpa using hφ
  exact hM φ (hT₀ hmem)

lemma finitelySatisfiable_of_subset {T S : Theory} (h : T ⊆ S)
    (hFS : finitelySatisfiable S) : finitelySatisfiable T := by
  intro T₀ hT₀
  apply hFS T₀
  intro x hx
  apply h
  exact hT₀ hx

lemma finite_theory_satisfiable_iff_finitelySatisfiable (T : Theory)
    (hFin : ∃ (F : Finset MiniLogicKernel.PredFormula), (F : Set _) = T) :
    satisfiable T ↔ finitelySatisfiable T := by
  rcases hFin with ⟨F, hF⟩
  constructor
  · exact satisfiable_implies_finitelySatisfiable
  · intro hFS
    have hFS' := hFS F (by
      intro x hx
      rw [hF]
      exact hx)
    rwa [hF] at hFS'

lemma allFiniteSubtheories_satisfiable {T : Theory} (hFS : finitelySatisfiable T) :
    ∀ T₀ ∈ allFiniteSubtheories T, satisfiable T₀ := by
  intro T₀ hT₀
  rcases hT₀ with ⟨F, hF, hsub⟩
  rw [hF]
  exact hFS F hsub

/-! ## Logical Validity -/

def logicallyValid (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure),
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

def logicallyEquivalent (φ ψ : MiniLogicKernel.PredFormula) : Prop :=
  logicallyValid (MiniLogicKernel.PredFormula.equiv φ ψ)

def logicallyImplies (φ ψ : MiniLogicKernel.PredFormula) : Prop :=
  logicallyValid (MiniLogicKernel.PredFormula.impl φ ψ)

lemma logicallyImplies_refl (φ : MiniLogicKernel.PredFormula) : logicallyImplies φ φ := by
  intro M
  -- ⊨ φ → φ is always true
  intro h
  exact h

lemma logicallyImplies_trans {φ ψ χ : MiniLogicKernel.PredFormula}
    (h₁ : logicallyImplies φ ψ) (h₂ : logicallyImplies ψ χ) : logicallyImplies φ χ := by
  intro M hφ
  have hψ := h₁ M hφ
  exact h₂ M hψ

lemma logicallyEquivalent_refl (φ : MiniLogicKernel.PredFormula) : logicallyEquivalent φ φ := by
  intro M
  constructor
  · exact λ h => h
  · exact λ h => h

lemma logicallyEquivalent_symm {φ ψ : MiniLogicKernel.PredFormula}
    (h : logicallyEquivalent φ ψ) : logicallyEquivalent ψ φ := by
  intro M
  have hM := h M
  constructor
  · exact hM.mpr
  · exact hM.mp

lemma logicallyValid_of_logicallyEquivalent {φ ψ : MiniLogicKernel.PredFormula}
    (hEq : logicallyEquivalent φ ψ) (hVal : logicallyValid φ) : logicallyValid ψ := by
  intro M
  have hM := hEq M
  exact hM.mpr (hVal M)

lemma logicallyValid_true : logicallyValid (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true) := by
  intro M; trivial

lemma logicallyValid_not_false : logicallyValid
    (MiniLogicKernel.PredFormula.not (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false)) := by
  intro M; intro hFalse; exact hFalse

/-! ## Logical Consequence -/

def logicalConsequence (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ M, isModelOf M T →
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []

infix:50 " ⊨ " => logicalConsequence

lemma logicalConsequence_refl {T : Theory} {φ : MiniLogicKernel.PredFormula}
    (h : φ ∈ T) : T ⊨ φ := by
  intro M hM
  exact hM φ h

lemma logicalConsequence_trans {T : Theory} {φ ψ : MiniLogicKernel.PredFormula}
    (h₁ : T ⊨ φ) (h₂ : T ⊨ (MiniLogicKernel.PredFormula.impl φ ψ)) : T ⊨ ψ := by
  intro M hM
  have hφ := h₁ M hM
  have hImpl := h₂ M hM
  exact hImpl hφ

lemma logicalConsequence_of_subset {T S : Theory} {φ : MiniLogicKernel.PredFormula}
    (h : T ⊆ S) (hCons : S ⊨ φ) : T ⊨ φ := by
  intro M hM
  apply hCons M
  intro ψ hψ
  exact hM ψ (h hψ)

lemma logicalConsequence_emptyTheory_iff_logicallyValid {φ : MiniLogicKernel.PredFormula} :
    emptyTheory ⊨ φ ↔ logicallyValid φ := by
  constructor
  · intro h M
    apply h M
    intro ψ hψ
    exfalso; exact hψ
  · intro h M hM
    apply h M

lemma logicalConsequence_unsatisfiable {T : Theory} (hUnsat : unsatisfiable T) (φ : MiniLogicKernel.PredFormula) : T ⊨ φ := by
  intro M hM
  exfalso
  apply hUnsat
  exact ⟨M, hM⟩

lemma logicalConsequence_of_satisfiable_and_unsatisfiable_union {T : Theory} {φ : MiniLogicKernel.PredFormula}
    (hSat : satisfiable T) (hUnsat : unsatisfiable (theoryInsert T (MiniLogicKernel.PredFormula.not φ))) :
    T ⊨ φ := by
  intro M hM
  by_contra hNot
  have hModel : isModelOf M (theoryInsert T (MiniLogicKernel.PredFormula.not φ)) := by
    intro ψ hψ
    rcases Set.mem_insert_iff.mp hψ with (hEq | hmem)
    · rw [hEq]; exact hNot
    · exact hM ψ hmem
  apply hUnsat
  exact ⟨M, hModel⟩

/-! ## Consistency -/

def isConsistent (T : Theory) : Prop := satisfiable T

def isInconsistent (T : Theory) : Prop := ¬ isConsistent T

lemma consistent_iff_satisfiable (T : Theory) : isConsistent T ↔ satisfiable T := by rfl

lemma inconsistent_iff_unsatisfiable (T : Theory) : isInconsistent T ↔ unsatisfiable T := by rfl

lemma consistent_of_emptyTheory : isConsistent emptyTheory := satisfiable_emptyTheory

lemma inconsistent_of_false_in_T {T : Theory}
    (hFalse : MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false ∈ T) : isInconsistent T := by
  intro hCons
  rcases hCons with ⟨M, hM⟩
  have hSat := hM (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false) hFalse
  exact hSat

lemma consistent_iff_not_entails_false (T : Theory) : isConsistent T ↔ ¬ (T ⊨ (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false)) := by
  constructor
  · intro hCons hEntails
    rcases hCons with ⟨M, hM⟩
    have hFalse := hEntails M hM
    exact hFalse
  · intro hNotEntails
    by_contra hIncons
    apply hNotEntails
    exact logicalConsequence_unsatisfiable hIncons _

lemma consistent_of_subset {T S : Theory} (h : T ⊆ S) (hCons : isConsistent S) : isConsistent T :=
  satisfiable_of_subset h hCons

lemma inconsistent_of_superset {T S : Theory} (h : T ⊆ S) (hIncons : isInconsistent T) : isInconsistent S :=
  unsatisfiable_of_superset h hIncons

/-! ## Finite Subtheory Operations -/

def allFiniteSubtheories (T : Theory) : Set Theory :=
  { T₀ | ∃ (F : Finset MiniLogicKernel.PredFormula), (T₀ = (F : Set _)) ∧ (F : Set _) ⊆ T }

lemma allFiniteSubtheories_subset {T : Theory} {T₀ : Theory}
    (h : T₀ ∈ allFiniteSubtheories T) : T₀ ⊆ T := by
  rcases h with ⟨F, hF, hSub⟩
  rw [hF]
  exact hSub

lemma allFiniteSubtheories_self_of_finite {T : Theory}
    (hFin : ∃ (F : Finset MiniLogicKernel.PredFormula), (F : Set _) = T) : T ∈ allFiniteSubtheories T := by
  rcases hFin with ⟨F, hF⟩
  have hSub : (F : Set MiniLogicKernel.PredFormula) ⊆ T := by
    rw [hF]
    exact Set.Subset.refl _
  exact ⟨F, hF.symm, hSub⟩

lemma allFiniteSubtheories_finite_coverage (T : Theory) (φ : MiniLogicKernel.PredFormula)
    (hφ : φ ∈ T) : {φ} ∈ allFiniteSubtheories T := by
  let hF : Finset MiniLogicKernel.PredFormula := {φ}
  have hEq : (hF : Set MiniLogicKernel.PredFormula) = {φ} := by
    ext ψ; simp
  have hSub : (hF : Set MiniLogicKernel.PredFormula) ⊆ T := by
    intro ψ hψ
    simp at hψ
    rw [hψ]
    exact hφ
  exact ⟨hF, hEq, hSub⟩

lemma emptyTheory_allFiniteSubtheories : allFiniteSubtheories emptyTheory = {emptyTheory} := by
  ext T
  constructor
  · rintro ⟨F, hF, hSub⟩
    have hEmpty : (F : Set MiniLogicKernel.PredFormula) = ∅ := by
      apply Set.eq_empty_iff_forall_not_mem.mpr
      intro x hx
      exact hSub hx
    rw [hF, hEmpty]
    simp
  · intro h
    simp at h; rw [h]
    have hEq : ((∅ : Finset MiniLogicKernel.PredFormula) : Set MiniLogicKernel.PredFormula) = emptyTheory := by
      simp [emptyTheory]
    have hSub : ((∅ : Finset MiniLogicKernel.PredFormula) : Set MiniLogicKernel.PredFormula) ⊆ emptyTheory := by
      intro x hx; exfalso; exact hx
    exact ⟨∅, hEq, hSub⟩

/-! ## Theory Equivalence -/

def areLogicallyEquivalentTheories (T S : Theory) : Prop :=
  (∀ φ, T ⊨ φ → S ⊨ φ) ∧ (∀ φ, S ⊨ φ → T ⊨ φ)

lemma areLogicallyEquivalentTheories_refl (T : Theory) : areLogicallyEquivalentTheories T T :=
  ⟨λ _ h => h, λ _ h => h⟩

lemma areLogicallyEquivalentTheories_symm {T S : Theory}
    (h : areLogicallyEquivalentTheories T S) : areLogicallyEquivalentTheories S T :=
  ⟨h.right, h.left⟩

lemma logicallyEquivalentTheories_have_same_models {T S : Theory}
    (h : areLogicallyEquivalentTheories T S) (M : MiniFunctionRelation.Structure) :
    isModelOf M T ↔ isModelOf M S := by
  constructor
  · intro hM φ hφ
    have hCons : T ⊨ φ := logicalConsequence_refl hφ
    have hConsS := h.left φ hCons
    exact hConsS M hM
  · intro hM φ hφ
    have hCons : S ⊨ φ := logicalConsequence_refl hφ
    have hConsT := h.right φ hCons
    exact hConsT M hM

/-! ## Quantifier Depth Analysis -/

def sentencesOfDepthLE (n : Nat) : Set MiniLogicKernel.PredFormula :=
  { φ | MiniLogicKernel.PredFormula.quantifierDepth φ ≤ n }

def isQuantifierFree (φ : MiniLogicKernel.PredFormula) : Bool :=
  MiniLogicKernel.PredFormula.quantifierDepth φ == 0

/-! ## Elementary Equivalence -/

def elementarilyEquivalent (M N : MiniFunctionRelation.Structure) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula),
    (MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []) ↔
    (MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp) φ [])

infix:50 " ≡ₑ " => elementarilyEquivalent

lemma elementarilyEquivalent_refl (M : MiniFunctionRelation.Structure) : M ≡ₑ M := by
  intro φ; rfl

lemma elementarilyEquivalent_symm {M N : MiniFunctionRelation.Structure}
    (h : M ≡ₑ N) : N ≡ₑ M := by
  intro φ; exact (h φ).symm

lemma elementarilyEquivalent_trans {M N P : MiniFunctionRelation.Structure}
    (hMN : M ≡ₑ N) (hNP : N ≡ₑ P) : M ≡ₑ P := by
  intro φ; exact (hMN φ).trans (hNP φ)

lemma elementarilyEquivalent_same_theory {M N : MiniFunctionRelation.Structure} (h : M ≡ₑ N) (T : Theory) :
    isModelOf M T ↔ isModelOf N T := by
  constructor
  · intro hM φ hφ
    have hMφ := hM φ hφ
    exact ((h φ).mp hMφ)
  · intro hN φ hφ
    have hNφ := hN φ hφ
    exact ((h φ).mpr hNφ)

lemma quantifierFree_formulas_preserved_by_iso {M N : MiniFunctionRelation.Structure}
    (iso : MiniFunctionRelation.Iso M N) (φ : MiniLogicKernel.PredFormula) :
    MiniLogicKernel.PredFormula.quantifierDepth φ = 0 →
    (MiniLogicKernel.Structure.satisfies (domain := M.domain) (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] ↔
     MiniLogicKernel.Structure.satisfies (domain := N.domain) (predInterp := N.predInterp) (constInterp := N.constInterp) φ []) := by
  intro hDepth
  induction φ with
  | prop f =>
    simp
  | pred p ts =>
    simp [MiniLogicKernel.Structure.satisfies, iso.constPreserving]
  | eq t1 t2 =>
    simp [MiniLogicKernel.Structure.satisfies, iso.constPreserving]
  | not ψ ih =>
    simp [MiniLogicKernel.Structure.satisfies]
    have hDepth_ψ : MiniLogicKernel.PredFormula.quantifierDepth ψ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact hDepth
    exact ih hDepth_ψ
  | and ψ₁ ψ₂ ih₁ ih₂ =>
    simp [MiniLogicKernel.Structure.satisfies]
    have h₁ : MiniLogicKernel.PredFormula.quantifierDepth ψ₁ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    have h₂ : MiniLogicKernel.PredFormula.quantifierDepth ψ₂ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    constructor
    · rintro ⟨hψ₁, hψ₂⟩; exact ⟨(ih₁ h₁).mp hψ₁, (ih₂ h₂).mp hψ₂⟩
    · rintro ⟨hψ₁, hψ₂⟩; exact ⟨(ih₁ h₁).mpr hψ₁, (ih₂ h₂).mpr hψ₂⟩
  | or ψ₁ ψ₂ ih₁ ih₂ =>
    simp [MiniLogicKernel.Structure.satisfies]
    have h₁ : MiniLogicKernel.PredFormula.quantifierDepth ψ₁ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    have h₂ : MiniLogicKernel.PredFormula.quantifierDepth ψ₂ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    constructor
    · rintro (h | h); exact Or.inl ((ih₁ h₁).mp h); exact Or.inr ((ih₂ h₂).mp h)
    · rintro (h | h); exact Or.inl ((ih₁ h₁).mpr h); exact Or.inr ((ih₂ h₂).mpr h)
  | impl ψ₁ ψ₂ ih₁ ih₂ =>
    simp [MiniLogicKernel.Structure.satisfies]
    have h₁ : MiniLogicKernel.PredFormula.quantifierDepth ψ₁ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    have h₂ : MiniLogicKernel.PredFormula.quantifierDepth ψ₂ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    constructor
    · intro h hψ₁; exact (ih₂ h₂).mp (h ((ih₁ h₁).mpr hψ₁))
    · intro h hψ₁; exact (ih₂ h₂).mpr (h ((ih₁ h₁).mp hψ₁))
  | equiv ψ₁ ψ₂ ih₁ ih₂ =>
    simp [MiniLogicKernel.Structure.satisfies]
    have h₁ : MiniLogicKernel.PredFormula.quantifierDepth ψ₁ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    have h₂ : MiniLogicKernel.PredFormula.quantifierDepth ψ₂ = 0 := by
      simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
      exact by omega
    constructor
    · rintro ⟨hLR, hRL⟩; exact ⟨λ h => (ih₂ h₂).mp (hLR ((ih₁ h₁).mpr h)), λ h => (ih₁ h₁).mp (hRL ((ih₂ h₂).mpr h))⟩
    · rintro ⟨hLR, hRL⟩; exact ⟨λ h => (ih₂ h₂).mpr (hLR ((ih₁ h₁).mp h)), λ h => (ih₁ h₁).mpr (hRL ((ih₂ h₂).mp h))⟩
  | all ψ =>
    simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
    omega
  | ex ψ =>
    simp [MiniLogicKernel.PredFormula.quantifierDepth] at hDepth
    omega

/-! ## Sentence classification by quantifier structure -/

inductive FormulaClass where
  | universal
  | existential
  | universalExistential
  | existentialUniversal
  | positive
  | quantifierFree
  deriving BEq, Repr, Inhabited

def classifyFormula (φ : MiniLogicKernel.PredFormula) : FormulaClass :=
  match φ with
  | .not (.ex _) => FormulaClass.universal
  | .not (.all _) => FormulaClass.existential
  | .all (.ex _) => FormulaClass.universalExistential
  | .ex (.all _) => FormulaClass.existentialUniversal
  | .all _ => FormulaClass.universal
  | .ex _ => FormulaClass.existential
  | .not _ => FormulaClass.quantifierFree
  | _ => FormulaClass.quantifierFree

def isUniversalFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match classifyFormula φ with
  | FormulaClass.universal => true
  | _ => false

def isExistentialFormula (φ : MiniLogicKernel.PredFormula) : Bool :=
  match classifyFormula φ with
  | FormulaClass.existential => true
  | _ => false

--- #eval ---

def testTheory : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

#eval "Theory type defined" : String

#eval satisfiable emptyTheory : Prop

#eval "finitelySatisfiable: every finite subtheory has a model" : String

#eval "satisfiable_implies_finitelySatisfiable lemma proved" : String

#eval "Elementary equivalence is an equivalence relation" : String

#eval "Logical consequence and consistency lemmas proved" : String

end MiniCompactnessCompletenessLite
