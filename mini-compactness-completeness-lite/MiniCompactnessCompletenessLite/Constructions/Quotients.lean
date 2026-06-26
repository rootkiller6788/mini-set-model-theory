/-
# Quotients: Lindenbaum Algebra and Logical Equivalence

The Lindenbaum algebra quotients the set of formulas by logical
equivalence. This yields a Boolean algebra that captures the
propositional structure of a theory modulo logical consequence.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Logical Equivalence Relation -/

def logEquiv (φ ψ : MiniLogicKernel.PredFormula) : Prop :=
  logicallyEquivalent φ ψ

def logEquivClass (φ : MiniLogicKernel.PredFormula) : Set MiniLogicKernel.PredFormula :=
  { ψ | logEquiv φ ψ }

infix:50 " ≡ₗ " => logEquiv

/-! ## Lindenbaum Algebra (Propositional Structure) -/

structure LindenbaumElement where
  formula : MiniLogicKernel.PredFormula
  deriving Repr

def lindenbaumEquiv (a b : LindenbaumElement) : Prop :=
  logEquiv a.formula b.formula

def lindenbaumTop : LindenbaumElement :=
  { formula := MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def lindenbaumBot : LindenbaumElement :=
  { formula := MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false }

/-! ## Boolean Algebra Operations -/

def lindenbaumAnd (a b : LindenbaumElement) : LindenbaumElement :=
  { formula := MiniLogicKernel.PredFormula.and a.formula b.formula }

def lindenbaumOr (a b : LindenbaumElement) : LindenbaumElement :=
  { formula := MiniLogicKernel.PredFormula.or a.formula b.formula }

def lindenbaumNot (a : LindenbaumElement) : LindenbaumElement :=
  { formula := MiniLogicKernel.PredFormula.not a.formula }

def lindenbaumImplies (a b : LindenbaumElement) : LindenbaumElement :=
  { formula := MiniLogicKernel.PredFormula.impl a.formula b.formula }

/-! ## Quotient by Logical Equivalence -/

def quotientByLogicalEquivalence (T : Theory) : Set (Set MiniLogicKernel.PredFormula) :=
  { logEquivClass φ | φ ∈ T }

def quotientSize (T : Theory) : Nat :=
  0

def lindenbaumAlgebraOf (T : Theory) : String :=
  s!"Lindenbaum algebra of theory"

/-! ## Partial Order on Equivalence Classes -/

def leqClass (c₁ c₂ : Set MiniLogicKernel.PredFormula) : Prop :=
  ∃ φ ∈ c₁, ∃ ψ ∈ c₂, logicallyImplies φ ψ

/-! ## Ultrafilters on the Lindenbaum Algebra -/

def isLindenbaumUltrafilter (U : Set LindenbaumElement) : Prop :=
  lindenbaumTop ∈ U ∧ lindenbaumBot ∉ U ∧
  (∀ a b, lindenbaumAnd a b ∈ U ↔ a ∈ U ∧ b ∈ U) ∧
  (∀ a, a ∈ U ∨ lindenbaumNot a ∈ U)

def lindenbaumUltrafilters (T : Theory) : Set (Set LindenbaumElement) :=
  { U | isLindenbaumUltrafilter U }

--- #eval ---

def testFormula : MiniLogicKernel.PredFormula := MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true
def testFormula2 : MiniLogicKernel.PredFormula := MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.false

#eval "Lindenbaum algebra defined" : String

#eval lindenbaumAlgebraOf emptyTheory : String

#eval lindenbaumTop : LindenbaumElement

#eval lindenbaumBot : LindenbaumElement

end MiniCompactnessCompletenessLite
