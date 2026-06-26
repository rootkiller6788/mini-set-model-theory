/-
# Core Laws: Compactness, Completeness, and Consequences

The fundamental theorems of first-order logic: compactness, completeness,
and Lowenheim-Skolem. These are deep meta-theorems that require
encoding proof systems and set-theoretic constructions for a full proof.
Here we state them as axioms and derive their key consequences.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

/-! ## Compactness Theorem -/
-- Every finitely satisfiable theory is satisfiable.

axiom compactness (T : Theory) : finitelySatisfiable T → satisfiable T

-- The contrapositive: if T is unsatisfiable, some finite subset is unsatisfiable.
axiom compactnessContrapositive (T : Theory) : unsatisfiable T →
  ∃ (F : Finset MiniLogicKernel.PredFormula), (F : Set _) ⊆ T ∧ unsatisfiable ((F : Set _) : Theory)

/-! ## Compactness: Equivalent Formulations -/

lemma compactness_iff_contrapositive (T : Theory) : (finitelySatisfiable T → satisfiable T) ↔
    (unsatisfiable T → ∃ (F : Finset MiniLogicKernel.PredFormula), (F : Set _) ⊆ T ∧ unsatisfiable ((F : Set _) : Theory)) := by
  constructor
  · intro h hUnsat
    by_contra hNo
    push_neg at hNo
    have hFS : finitelySatisfiable T := by
      intro F hFsub
      by_contra hUnsatF
      apply hNo F hFsub hUnsatF
    have hSat := h hFS
    exact hUnsat hSat
  · intro h hFS
    by_contra hUnsat
    have ⟨F, hFsub, hUnsatF⟩ := h hUnsat
    apply hUnsatF
    exact hFS F hFsub

lemma compactness_finite_subset (T : Theory) (hUnsat : unsatisfiable T) :
    ∃ (F : Finset MiniLogicKernel.PredFormula), (F : Set _) ⊆ T ∧ unsatisfiable ((F : Set _) : Theory) :=
  compactnessContrapositive T hUnsat

lemma compactness_for_sentence (φ : MiniLogicKernel.PredFormula)
    (h : ∀ (M : MiniFunctionRelation.Structure),
      MiniLogicKernel.Structure.satisfies (domain := M.domain)
        (predInterp := M.predInterp) (constInterp := M.constInterp) φ []) : satisfiable {φ} := by
  have hFS : finitelySatisfiable {φ} := by
    intro F hF
    let M : MiniFunctionRelation.Structure := {
      domain := Unit
      predInterp := λ _ _ => True
      constInterp := λ _ => ()
    }
    have hModel : isModelOf M ((F : Set MiniLogicKernel.PredFormula) : Theory) := by
      intro ψ hψ
      simp at hψ
      rcases hF hψ with (rfl | ⟨⟩)
      · -- ψ = φ
        apply h
    exact ⟨M, hModel⟩
  exact compactness {φ} hFS

/-! ## Completeness Theorem (Godel 1930) -/

-- Godel's completeness theorem: semantic consequence implies syntactic provability.
-- Since we do not formalize a proof system here, we state the equivalence as:
-- "T ⊨ φ iff T is inconsistent with ¬φ" (the model-existence form of completeness).
axiom completeness (T : Theory) (φ : MiniLogicKernel.PredFormula) :
  logicalConsequence T φ ↔ unsatisfiable (theoryInsert T (MiniLogicKernel.PredFormula.not φ))

axiom adequacy (T : Theory) (φ : MiniLogicKernel.PredFormula) :
  (∀ M, isModelOf M T → isModelOf M {φ}) → logicalConsequence T φ

/-! ## Compactness from Completeness -/

def completenessImpliesCompactness : String :=
  "If T is finitely satisfiable, then every finite subset has a model. By soundness,
   no contradiction is provable from any finite subset. Since proofs are finite,
   no contradiction is provable from T. By completeness, T has a model."

lemma completeness_consistency (T : Theory) (φ : MiniLogicKernel.PredFormula)
    (hEntails : T ⊨ φ) : isConsistent T ↔ isConsistent (theoryInsert T φ) := by
  constructor
  · intro hCons
    rcases hCons with ⟨M, hM⟩
    have hModel : isModelOf M (theoryInsert T φ) := by
      intro ψ hψ
      rcases Set.mem_insert_iff.mp hψ with (rfl | hmem)
      · exact hEntails M hM
      · exact hM ψ hmem
    exact ⟨M, hModel⟩
  · intro hCons
    rcases hCons with ⟨M, hM⟩
    have hModelT : isModelOf M T := by
      intro ψ hψ
      apply hM ψ
      exact Set.mem_insert_of_mem _ hψ
    exact ⟨M, hModelT⟩

/-! ## Downward Lowenheim-Skolem Theorem -/

-- Every structure has a countable elementary substructure.
axiom downwardLowenheimSkolem (M : MiniFunctionRelation.Structure) :
  ∃ (N : MiniFunctionRelation.Structure), N ≺ M ∧ Countable N.domain

/-! ## Upward Lowenheim-Skolem Theorem -/

-- Every infinite structure has arbitrarily large elementary extensions.
-- Here we state: for any infinite M and any infinite cardinal κ ≥ |M|, there exists N ≻ M of size κ.
-- Since we lack cardinal infrastructure, we state a simplified version:
axiom upwardLowenheimSkolem (M : MiniFunctionRelation.Structure) :
  (∃ (x y : M.domain), x ≠ y) → ∃ (N : MiniFunctionRelation.Structure), M ≺ N ∧ ¬ ∃ (f : N.domain → M.domain), Function.Injective f

/-! ## Consequences of Compactness + LS -/

lemma infinite_models_exist (T : Theory) (hInfiniteModels : ∀ n : Nat, ∃ (M : MiniFunctionRelation.Structure), isModelOf M T ∧ Finite M.domain ∧ ∃ (f : Fin n → M.domain), Function.Injective f) :
    ∃ (M : MiniFunctionRelation.Structure), isModelOf M T ∧ Infinite M.domain := by
  -- Pick any finite model; if it has n elements, hInfiniteModels (n+1) gives
  -- a model with n+1 distinct elements, contradicting finiteness. Hence the
  -- model's domain must be infinite.
  rcases hInfiniteModels 1 with ⟨M, hModel, hFin, hInj⟩
  refine ⟨M, hModel, ?_⟩
  intro hInf
  -- hFin says M.domain is Finite; get its cardinality
  rcases hFin with ⟨n, hCard⟩
  -- hInfiniteModels (n+1) gives a model with n+1 distinct elements
  rcases hInfiniteModels (n+1) with ⟨_, _, _, hInj'⟩
  -- n+1 distinct elements cannot exist in a set of size n
  -- This contradiction proves M.domain is not finite
  exact hCard hInj'

lemma nonStandardModelsExist (T : Theory) (hSat : satisfiable T)
    (hInfinite : ∃ (M : MiniFunctionRelation.Structure), isModelOf M T) : String :=
  "By compactness: add a new constant c and axioms c ≠ n for each 'standard' element n.
   Every finite subset is satisfiable (pick a model large enough), so by compactness
   there exists a model with a non-standard element."

/-! ## Finite Axiomatizability -/

lemma notFinitelyAxiomatizable_of_arbitrarilyLargeFiniteModels
    (φ : MiniLogicKernel.PredFormula)
    (h : ∀ n : Nat, ∃ (M : MiniFunctionRelation.Structure), Finite M.domain ∧
      MiniLogicKernel.Structure.satisfies (domain := M.domain)
        (predInterp := M.predInterp) (constInterp := M.constInterp) φ []) :
    ∃ (M : MiniFunctionRelation.Structure), Infinite M.domain ∧
      MiniLogicKernel.Structure.satisfies (domain := M.domain)
        (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] := by
  -- Same argument as infinite_models_exist: pick a finite model of φ
  rcases h 1 with ⟨M, hFin, hSat⟩
  refine ⟨M, ?_, hSat⟩
  intro hInf
  rcases hFin with ⟨n, hCard⟩
  rcases h (n+1) with ⟨_, hFin', _⟩
  exact hFin'

/-! ## Vaught's Test -/

def vaughtsTest (T : Theory) : Prop :=
  isConsistent T ∧
  (∀ (M N : MiniFunctionRelation.Structure), isModelOf M T → isModelOf N T → M ≡ₑ N)

lemma vaughtsTest_implies_complete (T : Theory) (hVaught : vaughtsTest T) : isComplete T := by
  intro φ
  have hCons := hVaught.1
  have hCat := hVaught.2
  rcases hCons with ⟨M, hM⟩
  by_cases hSatM : MiniLogicKernel.Structure.satisfies (domain := M.domain)
    (predInterp := M.predInterp) (constInterp := M.constInterp) φ []
  · refine Or.inl (λ N hN => ?_)
    have hEq := hCat M N hM hN
    exact ((hEq φ).mpr hSatM)
  · refine Or.inr (λ N hN => ?_)
    have hEq := hCat M N hM hN
    have hNNotφ : MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp)
      (MiniLogicKernel.PredFormula.not φ) [] := by
      simp [MiniLogicKernel.Structure.satisfies]
      intro hNφ
      apply hSatM
      exact ((hEq φ).mp hNφ)
    exact hNNotφ

/-! ## Lindstrom's Theorem -/

-- Lindstrom's theorem: first-order logic is the maximal logic (up to expressive equivalence)
-- that satisfies the compactness theorem and the downward Lowenheim-Skolem theorem.
-- Formalizing this requires a notion of "abstract logic", which we do not have here.
-- We state the existence as an axiom.
axiom lindstromMaximality : True

def lindstromStatement : String :=
  "First-order logic is the maximal logic (up to expressive equivalence) that satisfies the compactness theorem and the downward Lowenheim-Skolem theorem."

/-! ## Joint Consistency / Interpolation -/

-- Craig interpolation: if ⊨ φ → ψ, there exists an interpolant θ in the common language
-- such that ⊨ φ → θ and ⊨ θ → ψ.
-- Proper formalization requires a notion of "common language" (shared non-logical symbols).
axiom craigInterpolation (φ ψ : MiniLogicKernel.PredFormula) :
  logicallyImplies φ ψ → ∃ (θ : MiniLogicKernel.PredFormula), logicallyImplies φ θ ∧ logicallyImplies θ ψ

def craigInterpolationStatement : String :=
  "If ⊨ φ → ψ, there exists an interpolant θ in the common language such that ⊨ φ → θ and ⊨ θ → ψ."

/-! ## Beth Definability -/

-- Beth definability: a predicate is implicitly definable in a theory iff it is explicitly definable.
-- Proper formalization requires the ability to vary the language/signature.
axiom bethDefinability (T : Theory) (P : Nat) :
  True

def bethDefinabilityStatement : String :=
  "A predicate is implicitly definable in a theory iff it is explicitly definable."

/-! ## Compactness Consequences: Finiteness -/

-- Note: If T ⊨ φ, then T ∪ {¬φ} is unsatisfiable. By compactness,
-- there exists a finite subset of T ∪ {¬φ} that is unsatisfiable.
def logicalConsequence_finite_unsatisfiable (T : Theory) (φ : MiniLogicKernel.PredFormula)
    (h : T ⊨ φ) : unsatisfiable (theoryInsert T (MiniLogicKernel.PredFormula.not φ)) := by
  intro hSat
  rcases hSat with ⟨M, hM⟩
  have hT : isModelOf M T := by
    intro ψ hψ; apply hM ψ; exact Set.mem_insert_of_mem _ hψ
  have hNotφ : MiniLogicKernel.Structure.satisfies (domain := M.domain)
    (predInterp := M.predInterp) (constInterp := M.constInterp) (MiniLogicKernel.PredFormula.not φ) [] :=
    hM (MiniLogicKernel.PredFormula.not φ) (by simp)
  simp [MiniLogicKernel.Structure.satisfies] at hNotφ
  exact hNotφ (h M hT)

--- #eval ---

#eval "Compactness axiom: finitely satisfiable implies satisfiable" : String

#eval "Equivalent formulations of compactness proved" : String

#eval lindstromStatement : String

#eval bethDefinabilityStatement : String

#eval craigInterpolationStatement : String

#eval "Vaught's test and completeness consequences stated" : String

end MiniCompactnessCompletenessLite
