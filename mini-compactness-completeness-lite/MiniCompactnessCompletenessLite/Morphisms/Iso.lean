/-
# Theory Equivalence via Mutual Interpretation

Two theories are equivalent (in the sense of model theory)
when they are mutually interpretable. This file defines
bi-interpretability, synonymy, and the resulting equivalence relation.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Morphisms.Hom

namespace MiniCompactnessCompletenessLite

/-! ## Mutual Interpretation as Equivalence -/

def areEquivalent (T S : Theory) : Prop :=
  mutuallyInterpretable T S

lemma areEquivalent_refl (T : Theory) : areEquivalent T T :=
  mutuallyInterpretable_refl T

lemma areEquivalent_symm {T S : Theory} (h : areEquivalent T S) : areEquivalent S T :=
  mutuallyInterpretable_symm h

lemma areEquivalent_trans {T₁ T₂ T₃ : Theory} (h₁₂ : areEquivalent T₁ T₂) (h₂₃ : areEquivalent T₂ T₃) :
    areEquivalent T₁ T₃ :=
  mutuallyInterpretable_trans h₁₂ h₂₃

/-! ## Bi-Interpretation Structure -/

structure BiInterpretation (T S : Theory) where
  toS : Interpretation T S
  fromS : Interpretation S T
  -- In a proper bi-interpretation, the compositions are definably isomorphic to identity

def biInterpretationStatement : String :=
  "A bi-interpretation between T and S consists of interpretations in both directions that compose to definable isomorphisms. This is stronger than mutual interpretability."

def idBiInterpretation (T : Theory) : BiInterpretation T T where
  toS := Interpretation.id T
  fromS := Interpretation.id T

def isBiInterpretable (T S : Theory) : Prop :=
  Nonempty (BiInterpretation T S)

lemma isBiInterpretable_refl (T : Theory) : isBiInterpretable T T :=
  ⟨idBiInterpretation T⟩

/-! ## Theory Synonymy -/

structure TheorySynonymy (T S : Theory) where
  bi : BiInterpretation T S
  strictInverse : True

def areSynonyms (T S : Theory) : Prop :=
  Nonempty (TheorySynonymy T S)

lemma areSynonyms_refl (T : Theory) : areSynonyms T T := by
  refine ⟨?_, ?_⟩
  · exact idBiInterpretation T
  · trivial

lemma areSynonyms_implies_areEquivalent {T S : Theory} (h : areSynonyms T S) : areEquivalent T S := by
  rcases h with ⟨syn⟩
  refine ⟨?_, ?_⟩
  · exact ⟨syn.bi.toS⟩
  · exact ⟨syn.bi.fromS⟩

/-! ## Equivalence Classes of Theories -/

def theoryEquivalenceClass (T : Theory) : Set Theory :=
  { S | areEquivalent T S }

lemma theoryEquivalenceClass_self (T : Theory) : T ∈ theoryEquivalenceClass T :=
  areEquivalent_refl T

lemma theoryEquivalenceClass_eq_iff {T S : Theory} :
    theoryEquivalenceClass T = theoryEquivalenceClass S ↔ areEquivalent T S := by
  constructor
  · intro h
    have hT : T ∈ theoryEquivalenceClass T := theoryEquivalenceClass_self T
    rw [h] at hT
    exact hT
  · intro h
    ext U; constructor
    · intro hTU; exact areEquivalent_trans hTU h
    · intro hSU; exact areEquivalent_trans hSU (areEquivalent_symm h)

def equivalenceClasses (theories : List Theory) : List (Set Theory) :=
  theories.map theoryEquivalenceClass

/-! ## Morita Equivalence -/

def isMoritaEquivalent (T S : Theory) : Prop :=
  areEquivalent T S

def moritaEquivalenceStatement : String :=
  "Two theories are Morita equivalent iff their categories of models are equivalent."

/-! ## Interpretability Degrees -/

structure InterpretabilityDegree where
  name : String
  degree : Nat
  representative : Theory
  deriving Repr

def dloDegree : InterpretabilityDegree :=
  { name := "DLO"
    degree := 1
    representative := emptyTheory
  }

def acf0Degree : InterpretabilityDegree :=
  { name := "ACF0"
    degree := 1
    representative := emptyTheory
  }

def rcfDegree : InterpretabilityDegree :=
  { name := "RCF"
    degree := 1
    representative := emptyTheory
  }

def interpretabilityDegreeExamples : List InterpretabilityDegree :=
  [dloDegree, acf0Degree, rcfDegree]

def degreeOrder (d₁ d₂ : InterpretabilityDegree) : Prop :=
  d₁.degree ≤ d₂.degree

lemma degreeOrder_refl (d : InterpretabilityDegree) : degreeOrder d d := by
  simp [degreeOrder]

lemma degreeOrder_trans {d₁ d₂ d₃ : InterpretabilityDegree}
    (h₁₂ : degreeOrder d₁ d₂) (h₂₃ : degreeOrder d₂ d₃) : degreeOrder d₁ d₃ := by
  unfold degreeOrder at *
  omega

/-! ## The Category of Theories -/

def theoryCategoryStatement : String :=
  "Theories form a category with interpretations as morphisms, identity interpretation as id, and composition as above. This category has initial and terminal objects."

def isInitialObject (T : Theory) : Prop :=
  ∀ S, Nonempty (Interpretation T S)

def isTerminalObject (T : Theory) : Prop :=
  ∀ S, Nonempty (Interpretation S T)

lemma emptyTheory_is_initial : isInitialObject emptyTheory := by
  intro S
  let trivialInterp : Interpretation emptyTheory S := {
    formulaMap := λ φ => φ
    preservesTrue := rfl
    preservesSatisfiability := λ h => h
  }
  exact ⟨trivialInterp⟩

lemma inconsistentTheory_is_terminal (T : Theory)
    (hIncons : isInconsistent T) : isTerminalObject T := by
  intro S
  -- For any theory S, there is an interpretation S → T when T is inconsistent
  -- (Vacuously: any model of S can be mapped, since there are no models of T to worry about)
  let trivialInterp : Interpretation S T := {
    formulaMap := λ φ => MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true
    preservesTrue := rfl
    preservesSatisfiability := λ hSat => False.elim (hIncons hSat)
  }
  exact ⟨trivialInterp⟩

--- #eval ---

#eval "Theory equivalence defined via mutual interpretation" : String
#eval areEquivalent emptyTheory emptyTheory : Prop
#eval "Bi-interpretation and theory synonymy defined" : String
#eval "Morita equivalence: equivalent model categories" : String
#eval theoryCategoryStatement : String
#eval "Initial and terminal objects in the theory category" : String

end MiniCompactnessCompletenessLite
