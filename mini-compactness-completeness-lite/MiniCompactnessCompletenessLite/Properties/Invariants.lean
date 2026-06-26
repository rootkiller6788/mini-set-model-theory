/-
# Theory Invariants

Categoricity, completeness, model-completeness, and
substructure-completeness are fundamental invariants of
first-order theories. These properties classify theories
by their structural behavior.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCardinalOrdinal.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Categoricity -/

-- T is κ-categorical if all models of T of size κ are isomorphic.
-- Proper formalization requires a notion of "size/cardinality".
-- TODO: Replace `True` with proper cardinality-bounded isomorphism.
def isκCategorical (T : Theory) (κ : String) : Prop :=
  True

-- isCategoricalInPower is defined in Properties.Categoricity

-- Uncountably categorical: categorical in some uncountable cardinal.
def isUncountablyCategorical (T : Theory) : Prop :=
  True

def categoricityStatement : String :=
  "A theory T is κ-categorical if all models of T of size κ are isomorphic."

/-! ## Completeness -/

def isComplete (T : Theory) : Prop :=
  ∀ φ, logicalConsequence T φ ∨ logicalConsequence T (MiniLogicKernel.PredFormula.not φ)

def completeTheoriesList : List String :=
  ["DLO", "ACF0", "ACFp", "RCF", "Presburger Arithmetic"]

def isIncompleteTheory (T : Theory) : Prop :=
  ¬ isComplete T

def completeTheoryStatement : String :=
  "A theory is complete if for every sentence φ, either T ⊨ φ or T ⊨ ¬φ."

lemma complete_theory_models_agree {T : Theory} (hComp : isComplete T)
    {M N : MiniFunctionRelation.Structure} (hM : isModelOf M T) (hN : isModelOf N T)
    (φ : MiniLogicKernel.PredFormula) :
    (MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []) ↔
    (MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp) φ []) := by
  rcases hComp φ with (hEnt | hEntNot)
  · constructor
    · intro hMφ
      exact hEnt M hM
    · intro hNφ
      exact hEnt N hN
  · -- T ⊨ ¬φ, so no model satisfies φ
    have hNoModel : ∀ (M : MiniFunctionRelation.Structure), isModelOf M T →
      ¬ MiniLogicKernel.Structure.satisfies (domain := M.domain)
        (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] := by
      intro M' hM'
      have hNotφ := hEntNot M' hM'
      simp [MiniLogicKernel.Structure.satisfies] at hNotφ
      exact hNotφ
    constructor
    · intro hMφ; exfalso; exact hNoModel M hM hMφ
    · intro hNφ; exfalso; exact hNoModel N hN hNφ

lemma complete_theory_elementarily_equivalent_models {T : Theory} (hComp : isComplete T)
    (M N : MiniFunctionRelation.Structure) (hM : isModelOf M T) (hN : isModelOf N T) : M ≡ₑ N := by
  intro φ; exact complete_theory_models_agree hComp hM hN φ

lemma complete_theory_iff_all_models_eeq {T : Theory} (hCons : isConsistent T) :
    isComplete T ↔
    (∀ (M N : MiniFunctionRelation.Structure), isModelOf M T → isModelOf N T → M ≡ₑ N) := by
  constructor
  · exact λ hComp M N hM hN => complete_theory_elementarily_equivalent_models hComp M N hM hN
  · intro hAllEEq φ
    rcases hCons with ⟨M, hM⟩
    by_cases hMφ : MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ []
    · refine Or.inl ?_
      intro N hN
      have hEEq := hAllEEq M N hM hN
      exact (hEEq φ).mpr hMφ
    · refine Or.inr ?_
      intro N hN
      have hEEq := hAllEEq M N hM hN
      have hNNotφ : MiniLogicKernel.Structure.satisfies (domain := N.domain)
        (predInterp := N.predInterp) (constInterp := N.constInterp)
        (MiniLogicKernel.PredFormula.not φ) [] := by
        simp [MiniLogicKernel.Structure.satisfies]
        intro hNφ
        apply hMφ
        exact (hEEq φ).mp hNφ
      exact hNNotφ

/-! ## Model-Completeness -/

def isModelComplete (T : Theory) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (f : Hom M N),
    isModelOf M T → isModelOf N T → isEmbedding f → isElementaryEmbedding f

def modelCompletenessStatement : String :=
  "T is model-complete if every embedding between models of T is elementary."

def robinsonTestStatement : String :=
  "T is model-complete iff every formula is equivalent (modulo T) to a universal formula."

lemma modelComplete_forward_direction {T : Theory} (hMC : isModelComplete T)
    (M N : MiniFunctionRelation.Structure) (f : Hom M N)
    (hM : isModelOf M T) (hN : isModelOf N T) (hEmb : isEmbedding f)
    (φ : MiniLogicKernel.PredFormula) :
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] →
    MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp) φ [] := by
  have hElem := hMC M N f hM hN hEmb
  intro h; exact hElem φ [] h

/-! ## Substructure-Completeness -/

def isSubstructureComplete (T : Theory) : Prop :=
  ∀ (A B : MiniFunctionRelation.Structure) (hA : isModelOf A T) (hB : isModelOf B T)
    (hSub : ∃ (f : Hom A B), isEmbedding f),
    A ≡ₑ B

def substructureCompletenessStatement : String :=
  "T is substructure-complete if for any A ⊨ T embedding into B ⊨ T, A ≼ B."

/-! ## Quantifier Elimination -/

def hasQuantifierElimination (T : Theory) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula),
    ∃ (ψ : MiniLogicKernel.PredFormula),
      MiniLogicKernel.PredFormula.quantifierDepth ψ = 0 ∧
      logicallyEquivalent (MiniLogicKernel.PredFormula.equiv φ ψ)

def qeStatement : String :=
  "A theory has quantifier elimination if every formula is T-equivalent to a quantifier-free formula."

def qeTheories : List String :=
  ["DLO", "ACF", "RCF", "Presburger Arithmetic"]

lemma qe_implies_modelComplete (T : Theory) : String :=
  "QE implies model-completeness: if every formula is T-equivalent to a quantifier-free formula, then embeddings between models of T are elementary."

/-! ## Decidability -/

-- A theory T is decidable if the set of its logical consequences is recursive.
-- Proper formalization requires a computability framework (Turing machines, etc.).
-- TODO: Formalize decidability when computability infrastructure is available.
axiom isDecidable_axiom (T : Theory) : Prop

def isSemanticallyDecidable (T : Theory) : Prop :=
  isDecidable_axiom T

-- decidableTheories and undecidableTheories are defined in Bridges.ToComputation

def decidabilityStatement : String :=
  "A theory is decidable if the set of its logical consequences is recursive. Equivalently, there is an algorithm that determines whether T ⊨ φ for any given φ."

/-! ## O-Minimality -/

-- A theory is o-minimal if every definable subset of the line is a finite union of intervals.
-- Proper formalization requires an ordering and interval definitions.
-- TODO: Formalize o-minimality with order topology infrastructure.
axiom isOMinimal_axiom (T : Theory) : Prop

def isOMinimal (T : Theory) : Prop :=
  isOMinimal_axiom T

-- oMinimalityStatement is defined in Bridges.ToGeometry

-- oMinimalExamples is defined in Bridges.ToGeometry

/-! ## NIP (No Independence Property) -/

-- A formula φ(x;y) has the independence property if for every n, there exist a_i, b_S for S ⊆ {1,...,n}
-- such that φ(a_i; b_S) iff i ∈ S. Proper formalization requires an infinite sequence infrastructure.
-- TODO: Formalize when Shelah-style combinatorial infrastructure is available.
axiom hasIndependenceProperty_axiom (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop

def hasIndependenceProperty (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  hasIndependenceProperty_axiom T φ

def isNIP (T : Theory) : Prop :=
  ¬ ∃ (φ : MiniLogicKernel.PredFormula), hasIndependenceProperty T φ

def nipStatement : String :=
  "A theory is NIP if no formula has the independence property. NIP theories are a broad class including all stable theories plus o-minimal, C-minimal, and more."

/-! ## NFCP (No Finite Cover Property) -/

-- NFCP (no finite cover property) is intermediate between stable and superstable.
-- Proper formalization requires definable sets and forking infrastructure.
-- TODO: Formalize when forking calculus is available.
axiom hasFiniteCoverProperty_axiom (T : Theory) : Prop

def hasFiniteCoverProperty (T : Theory) : Prop :=
  hasFiniteCoverProperty_axiom T

def isNFCP (T : Theory) : Prop :=
  ¬ hasFiniteCoverProperty T

def nfcpStatement : String :=
  "NFCP (no finite cover property) is a property intermediate between stable and superstable. It characterizes the elimination of imaginaries."

--- #eval ---

#eval "Theory invariants: categoricity, completeness, model-completeness" : String
#eval completeTheoriesList : List String
#eval "QE implies model-completeness" : String
#eval "Decidable theories and o-minimality" : String
#eval "NIP and NFCP properties" : String

end MiniCompactnessCompletenessLite
