/-
# Theory Interpretations (Homomorphisms of Theories)

A theory interpretation maps one theory into another,
preserving satisfiability. This is the model-theoretic
analogue of a homomorphism between logical theories.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Interpretation Structure -/

structure Interpretation (T S : Theory) where
  formulaMap : MiniLogicKernel.PredFormula → MiniLogicKernel.PredFormula
  preservesTrue : MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true = MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true
  preservesSatisfiability : satisfiable T → satisfiable S

/-! ## Identity Interpretation -/

def idInterpretation (T : Theory) : Interpretation T T where
  formulaMap := λ φ => φ
  preservesTrue := rfl
  preservesSatisfiability := λ h => h

/-! ## Composition of Interpretations -/

def compInterpretation {T₁ T₂ T₃ : Theory}
  (I₁ : Interpretation T₁ T₂) (I₂ : Interpretation T₂ T₃) : Interpretation T₁ T₃ where
  formulaMap := I₂.formulaMap ∘ I₁.formulaMap
  preservesTrue := I₁.preservesTrue.trans I₂.preservesTrue
  preservesSatisfiability := I₂.preservesSatisfiability ∘ I₁.preservesSatisfiability

/-! ## Relative Interpretation -/

def relativeInterpretation (T S : Theory) : Prop :=
  Nonempty (Interpretation T S)

/-! ## Faithful Interpretation -/

def isFaithful (I : Interpretation T S) : Prop :=
  ∀ φ, I.formulaMap φ = MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false → φ = MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false

def isConservativeInterpretation (I : Interpretation T S) : Prop :=
  ∀ φ, satisfiable (theoryInsert T φ) → satisfiable (theoryInsert S (I.formulaMap φ))

/-! ## Interpretability Lattice -/

def interpretabilityPreorder (T S : Theory) : Prop :=
  relativeInterpretation T S

infix:50 " ≲ " => interpretabilityPreorder

def mutuallyInterpretable (T S : Theory) : Prop :=
  T ≲ S ∧ S ≲ T

--- #eval ---

def testTheoryT : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }
def testTheoryS : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def testInterp : Interpretation testTheoryT testTheoryS := idInterpretation testTheoryT

#eval "Identity interpretation defined" : String

#eval interpretabilityPreorder testTheoryT testTheoryT

#eval "Interpretation composition defined" : String

end MiniCompactnessCompletenessLite
