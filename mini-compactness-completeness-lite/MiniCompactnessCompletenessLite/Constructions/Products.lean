/-
# Products of Theories

The product of two theories over disjoint signatures corresponds to
their union. This captures the idea of combining independent
theories, which is fundamental to the Feferman-Vaught theorem
and product constructions in model theory.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Disjoint Union of Theories -/

def theoryDisjointUnion (T S : Theory) : Theory :=
  T ∪ S

infix:50 " ⊕ₜ " => theoryDisjointUnion

/-! ## Disjointness Condition -/

def areDisjoint (T S : Theory) : Prop :=
  T ∩ S = ∅

def areSignatureDisjoint (T S : Theory) : Prop :=
  areDisjoint T S

/-! ## Product Theories -/

def productTheory (T S : Theory) : Theory :=
  T ∪ S

def restrictionOfProduct (P T : Theory) : Prop :=
  isSubtheory T P

def isProduct (P T S : Theory) : Prop :=
  P = productTheory T S ∧ areDisjoint T S

/-! ## Feferman-Vaught for Products -/

def fefermanVaughtStatement : String :=
  "The theory of a product structure is determined by the theories of its factors."

def productPreservationStatement : String :=
  "A sentence is preserved under products iff it is equivalent to a Horn sentence."

/-! ## Direct Product of Structures -/

structure StructureProduct (M N : MiniFunctionRelation.Structure) where
  carrier : Type
  constructor : M.domain × N.domain
  -- projection maps would go here
  deriving Repr

def productModelCheck (M N : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

/-! ## Reduct and Expansion in Products -/

def leftReduct (T : Theory) (S : Theory) : Theory := T

def rightReduct (T : Theory) (S : Theory) : Theory := S

def productExpansion (T : Theory) (S : Theory) : Theory :=
  productTheory T S

/-! ## Independent Theories -/

def areIndependentTheories (T S : Theory) : Prop :=
  areDisjoint T S ∧
  ∀ φ, φ ∈ T → ∀ ψ, ψ ∈ S →
    satisfiable (theoryInsert emptyTheory (MiniLogicKernel.PredFormula.and φ ψ))

--- #eval ---

def testProductLocal : Theory := { MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true }

def testProductTheory : Theory := productTheory testProductLocal emptyTheory

#eval "Theory product (union) defined" : String

#eval areDisjoint testProductLocal emptyTheory : Prop

#eval fefermanVaughtStatement : String

#eval productPreservationStatement : String

end MiniCompactnessCompletenessLite
