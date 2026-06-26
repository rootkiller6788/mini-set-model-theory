/-
# Bridges: Satisfaction Model to Computation

Decidability, computable model theory, QE algorithms, Turing degrees,
and Vaught's conjecture. Covers L7, L8, L9.

## Knowledge Coverage
- L7: Model theory ↔ Computability (decidable theories)
- L8: Computable structures, QE algorithms
- L9: Vaught's conjecture, effective model theory
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Properties.Classification
import MiniSatisfactionModel.Properties.ClassificationData

namespace MiniSatisfactionModel

/-! ## Decidable Theories

A theory T is decidable if there is an algorithm that decides,
for every sentence φ, whether T ⊨ φ. QE implies decidability
(if the quantifier-free fragment is decidable). -/

def isDecidableTheory (T : Theory) : Prop :=
  ∃ (algorithm : MiniLogicKernel.PredFormula → Bool),
    ∀ (φ : MiniLogicKernel.PredFormula), isSentence φ →
    (algorithm φ = true ↔ T ⊨ φ)

/-! ## Decidable and Undecidable Theories -/

def decidableTheories : List String :=
  ["DLO (dense linear orders without endpoints)",
   "ACF₀ (algebraically closed fields of char 0)",
   "ACFₚ (algebraically closed fields of char p)",
   "RCF (real closed fields)",
   "Presburger arithmetic (ℕ, +, 0, 1, <)",
   "Tarski's elementary geometry",
   "Abelian groups",
   "Random graph"]

def undecidableTheories : List String :=
  ["Peano arithmetic (PA)",
   "ZFC set theory",
   "Group theory",
   "Ring theory",
   "Field theory",
   "Robinson arithmetic (Q)",
   "Diophantine equations (Hilbert's 10th problem)"]

/-! ## Decidability via Quantifier Elimination

If T has QE and the quantifier-free consequences of T are
computable, then T is decidable. This is the standard method
for proving decidability. -/

theorem qe_implies_decidability (T : Theory) (hqe : hasQE T)
    (hqfDec : ∃ (f : MiniLogicKernel.PredFormula → Bool),
      ∀ (φ : MiniLogicKernel.PredFormula), isQuantifierFree φ → isSentence φ →
      (f φ = true ↔ T ⊨ φ)) : isDecidableTheory T := by
  rcases hqfDec with ⟨f, hf⟩
  refine ⟨λ φ => f φ, ?_⟩
  intro φ hsent
  rcases hqe φ with ⟨ψ, hqf, hψ⟩
  have hsent_ψ : isSentence ψ := hsent  -- QE preserves sentence status
  constructor
  · intro hfψ
    have hTψ := (hf ψ hqf hsent_ψ).mp hfψ
    intro M hM
    have hψM := hTψ M hM
    exact (hψ {structure := M, theory := T, isModel := hM} rfl).mp hψM
  · intro hTφ
    have hTψ := (hf ψ hqf hsent_ψ).mpr
    apply hTψ
    intro M hM
    exact (hψ {structure := M, theory := T, isModel := hM} rfl).mpr (hTφ M hM)

/-! ## Computable Structures -/

def computableStructureDescription : String :=
  "A computable structure is one whose domain, relations, and functions are computable"

structure ComputableStructure where
  structure : MiniFunctionRelation.Structure
  domainDecidable : DecidableEq structure.domain
  predDecidable : ∀ (p : Nat) (args : List structure.domain),
    Decidable (structure.predInterp p args)
  deriving Repr

/-! ## QE Algorithm Complexity -/

def hasQEAlgorithm (T : ClassifiedTheory) : Bool :=
  T.hasQuantifierElimination

def qeAlgorithmComplexity (T : ClassifiedTheory) : String :=
  match T.name with
  | "DLO" => "O(n²) — Fourier-Motzkin style elimination of dense order"
  | "ACF0" => "Doubly exponential — resultant-based elimination (Grigoriev 1988)"
  | "RCF" => "Doubly exponential — cylindrical algebraic decomposition (Collins 1975)"
  | "ACFp" => "Same as ACF₀ with additional modular predicates"
  | "Presburger Arithmetic" => "Triple exponential — Cooper's algorithm (1972)"
  | "Random Graph" => "O(n²) — simple QE by adjacency reasoning"
  | _ => "Complexity unknown or not applicable"

/-! ## Turing Degrees of Theories -/

def turingDegreeDescription : String :=
  "The Turing degree of a theory is the degree of unsolvability of T ⊨ φ"

def turingDegrees : List String :=
  ["0 (decidable): DLO, ACF, RCF, Presburger, random graph",
   "0' (r.e., complete): Peano arithmetic (PA)",
   "0'' (double jump): True arithmetic Th(ℕ)",
   "0^(ω): ZFC (if consistent)"]

def isRecursivelyAxiomatizable (T : Theory) : Prop :=
  ∃ (f : MiniLogicKernel.PredFormula → Bool),
    ∀ (φ : MiniLogicKernel.PredFormula), φ ∈ T.axioms ↔ f φ = true

/-! ## Vaught's Conjecture (Computational Aspect) -/

def vaughtsConjecture : String :=
  "Vaught's Conjecture: For countable complete T, I(T, ℵ₀) ≤ ℵ₀ or I(T, ℵ₀) = 2^ℵ₀"

def vaughtConjectureStatus : String :=
  "Partial results: Proved for ω-stable (Shelah), superstable (Buechler),
   o-minimal (Mayer), and certain simple theories. Still open in full generality."

/-! ## Effective Completeness Theorem -/

def effectiveGodelCompleteness : String :=
  "Effective completeness (Craig 1957): If T is r.e., the set {φ | T ⊨ φ} is r.e."

def henkinConstructionEffective : String :=
  "The Henkin construction is effective: from a consistent r.e. theory, an r.e. complete Henkin theory can be built"

/-! ## Computational Model Theory -/

def computableModelTheoryTopics : List String :=
  ["Computable categoricity: when computable models are computably isomorphic",
   "Computable dimension: number of computable presentations",
   "Degree spectra: set of Turing degrees of isomorphic copies",
   "Index sets: classifying the complexity of isomorphism types",
   "Computable structure theory: Ash, Knight, Millar, Goncharov"]

/-! ## Decision Procedures via Model Theory -/

def decisionProcedures : List String :=
  ["Fourier-Motzkin: QE for DLO (O(n²))",
   "Cooper's algorithm: QE for Presburger arithmetic (triple exponential)",
   "CAD: Cylindrical Algebraic Decomposition for RCF (Collins 1975)",
   "Resultant method: QE for ACF (Tarski/Chevalley)",
   "SMT solvers: combine decision procedures for different theories"]

/-! ## #eval Examples -/

#eval decidableTheories.length
#eval undecidableTheories.length
#eval hasQEAlgorithm dloClassification
#eval qeAlgorithmComplexity dloClassification
#eval qeAlgorithmComplexity acf0Classification
#eval qeAlgorithmComplexity rcfClassification
#eval turingDegrees
#eval vaughtsConjecture
#eval vaughtConjectureStatus
#eval effectiveGodelCompleteness
#eval henkinConstructionEffective
#eval computableModelTheoryTopics
#eval decisionProcedures

end MiniSatisfactionModel
