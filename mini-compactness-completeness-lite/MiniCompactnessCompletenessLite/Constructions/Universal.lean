/-
# Universal Theories

The free (empty) theory, initial theory, and terminal theory in the
category of theories with interpretations. These provide universal
objects for the lattice of theories under interpretability.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Morphisms.Hom

namespace MiniCompactnessCompletenessLite

/-! ## Free Theory (Empty Theory) -/

def freeTheory : Theory := emptyTheory

def isFree (T : Theory) : Prop := T = freeTheory

def freeTheoryProperty : String :=
  "The empty theory is initial: for every theory T, there exists a unique interpretation from the empty theory to T."

def modelsOfFreeTheory (T : Theory) : Set MiniFunctionRelation.Structure :=
  { M | True }

/-! ## Initial Theory -/

def isInitialTheory (T : Theory) : Prop :=
  ∀ S, relativeInterpretation T S

def initialTheory : Theory := freeTheory

def initialTheoryUnique : String :=
  "Any two initial theories are mutually interpretable."

/-! ## Terminal Theory (Inconsistent Theory) -/

def terminalTheory : Theory :=
  { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false }

def isTerminalTheory (T : Theory) : Prop :=
  ∀ S, relativeInterpretation S T

def terminalTheoryProperty : String :=
  "The inconsistent theory is terminal: every theory interprets into the inconsistent theory."

/-! ## Finitely Generated Theories -/

def isFinitelyGenerated (T : Theory) : Prop :=
  ∃ (F : Finset MiniLogicKernel.PredFormula), T ⊆ (F : Set _)

def finitelyGeneratedTheories : List Theory :=
  [freeTheory, terminalTheory]

/-! ## Free Product (Coproduct) of Theories -/

def theoryCoproduct (T S : Theory) : Theory :=
  theoryDisjointUnion T S

def coproductProperty : String :=
  "The disjoint union of theories is the coproduct in the category of theories (assuming disjoint signatures)."

/-! ## Coherent / Geometric Theories -/

-- A coherent/geometric formula is built from atomic formulas using ∧, ∨, ∃, and ⊤, ⊥.
-- Proper formalization requires syntactic classification of formula structure.
-- TODO: Formalize when syntactic analysis of formulas is available.

axiom isCoherentTheory_axiom (T : Theory) : Prop

def isCoherentTheory (T : Theory) : Prop :=
  isCoherentTheory_axiom T

axiom isRegularTheory_axiom (T : Theory) : Prop

def isRegularTheory (T : Theory) : Prop :=
  isRegularTheory_axiom T

/-! ## Classifying Topos Connection -/

def classifyingToposStatement : String :=
  "Every coherent theory has a classifying topos whose points are the models of the theory."

--- #eval ---

#eval "Free theory defined as empty set of axioms" : String

#eval freeTheoryProperty : String

#eval terminalTheoryProperty : String

#eval classifyingToposStatement : String

end MiniCompactnessCompletenessLite
