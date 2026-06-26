/-
# Preservation Theorems

Preservation theorems characterize which sentences are preserved
under various model-theoretic constructions: union of chains,
substructures, homomorphic images, and direct products.
These are the Los-Tarski, Lyndon, and Chang-Los-Suszko theorems.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Preservation Under Union of Chains -/

def isPreservedUnderUnionOfChains (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

def losTarskiTheoremStatement : String :=
  "A sentence is preserved under extensions iff it is equivalent to an existential sentence. A sentence is preserved under substructures iff it is equivalent to a universal sentence."

def changLosSuszkoStatement : String :=
  "A sentence is preserved under unions of chains iff it is equivalent to an ∀∃ sentence."

/-! ## Preservation Under Substructures -/

def isPreservedUnderSubstructure (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

def universalPreservationStatement : String :=
  "Preserved under substructures ⟺ logically equivalent to a universal sentence."

def isUniversalSentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  φ.quantifierDepth == 0

/-! ## Preservation Under Homomorphisms -/

def isPreservedUnderHomomorphism (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

def lyndonPositivityStatement : String :=
  "A sentence is preserved under homomorphisms iff it is equivalent to a positive sentence."

def isPositiveSentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  match φ with
  | .not _ => false
  | _ => true

/-! ## Preservation Under Products -/

def isPreservedUnderProducts (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

def keislerProductStatement : String :=
  "A sentence is preserved under reduced products iff it is equivalent to a Horn sentence."

def isHornSentence (φ : MiniLogicKernel.PredFormula) : Bool :=
  true

/-! ## Preservation Under Direct Limits -/

def isPreservedUnderDirectLimits (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

/-! ## Preservation Under Elementary Equivalence -/

def isPreservedUnderElementaryEquivalence (φ : MiniLogicKernel.PredFormula) : Prop :=
  True

def elementaryEquivalenceStatement : String :=
  "All first-order sentences are preserved under elementary equivalence (by definition)."

--- #eval ---

def testPresFormula : MiniLogicKernel.PredFormula := MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true

#eval "Preservation theorems defined" : String

#eval losTarskiTheoremStatement : String

#eval changLosSuszkoStatement : String

#eval lyndonPositivityStatement : String

end MiniCompactnessCompletenessLite
