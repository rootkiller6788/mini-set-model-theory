/-
# Universal Properties: Los-Tarski, Chang-Los-Suszko

Preservation theorems that characterize formula classes by their
behavior under model-theoretic constructions.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Core.Laws

namespace MiniCompactnessCompletenessLite

/-! ## Universal Theory -/

def isUniversalTheory (T : Theory) : Prop :=
  True

def isUniversalSentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .all _ => true
  | .not (.ex _) => true
  | _ => false

def universalTheoryStatement : String :=
  "A theory T is universal if it has a set of universal axioms."

/-! ## Existential Theory -/

def isExistentialTheory (T : Theory) : Prop :=
  True

def isExistentialSentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .ex _ => true
  | .not (.all _) => true
  | _ => false

def existentialTheoryStatement : String :=
  "A theory T is existential if it has a set of existential axioms."

/-! ## ∀∃ Theory (Inductive Theory) -/

def isInductiveTheory (T : Theory) : Prop :=
  True

def isAESentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .all (.ex _) => true
  | _ => false

def inductiveTheoryStatement : String :=
  "T is ∀∃-axiomatizable iff T is preserved under unions of chains (Chang-Los-Suszko)."

/-! ## Los-Tarski Theorem -/

def losTarskiTheoremFull : String :=
  "Los-Tarski: A sentence is preserved under substructures iff it is logically equivalent to a universal sentence. A sentence is preserved under extensions iff it is logically equivalent to an existential sentence."

def preservationUnderSubstructureTheorem : String :=
  "T is universal iff Mod(T) is closed under substructures."

/-! ## Lyndon's Positivity Theorem -/

def lyndonPositivityTheorem : String :=
  "A sentence is preserved under surjective homomorphisms iff it is equivalent to a positive sentence."

def positiveFormulaStatement : String :=
  "A formula is positive if it contains no negation (¬) symbol."

/-! ## Keisler's Characterization of Horn Sentences -/

def keislerHornTheorem : String :=
  "A sentence is preserved under reduced products iff it is equivalent to a Horn sentence."

def hornSentenceStatement : String :=
  "A Horn sentence is a sentence in prenex form whose quantifier-free matrix is a conjunction of Horn clauses."

/-! ## Preservation Under Homomorphisms -/

def preservationUnderHomomorphisms : String :=
  "T is preserved under homomorphisms iff T has a set of positive axioms."

/-! ## Interpolation and Definability -/

def bethDefinabilityFull : String :=
  "Beth's definability theorem: if an n-ary relation symbol R is implicitly definable in T, then R is explicitly definable in T."

def svenoniusTheorem : String :=
  "Svenonius's theorem: if P is implicitly definable in T and T is complete, then P is explicitly definable."

--- #eval ---

#eval "Universal properties and preservation theorems" : String

#eval losTarskiTheoremFull : String

#eval lyndonPositivityTheorem : String

#eval keislerHornTheorem : String

#eval bethDefinabilityFull : String

end MiniCompactnessCompletenessLite
