/-
# MiniZFCLite: Morphisms — Adjoint

Elementary equivalence of set structures, inner model equivalences,
and bisimulations between set models.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Elementary Equivalence -/

/-- Two set structures are elementarily equivalent if they satisfy
the same first-order sentences -/
structure ElementarilyEquivalent where
  modelA : String
  modelB : String
  agreement : String := "M ≡ N (same first-order theory)"
  deriving Repr

/-- The standard V and the constructible L for Σ2 sentences -/
def vEquivL_Sigma2 : ElementarilyEquivalent :=
  { modelA := "V"
    modelB := "L"
    agreement := "V and L agree on Σ₂(L) sentences (Shoenfield absoluteness)" }

/-- Any two models of ZFC agree on arithmetic statements -/
def arithmeticAgreement : ElementarilyEquivalent :=
  { modelA := "M₁ ⊨ ZFC"
    modelB := "M₂ ⊨ ZFC"
    agreement := "M₁ and M₂ have the same natural numbers (up to isomorphism)" }

/-! ## Inner Model Equivalence -/

/-- Two inner models are equivalent (as classes) -/
structure InnerModelEquivalence where
  model1 : String
  model2 : String
  relation : String
  deriving Repr

/-- L = HOD in models of V=L -/
def lEqualsHodUnderVL : InnerModelEquivalence :=
  { model1 := "L"
    model2 := "HOD"
    relation := "If V=L then L=HOD; otherwise L⊆HOD" }

/-- L and HOD are distinct in general -/
def lSubsetOfHod : InnerModelEquivalence :=
  { model1 := "L"
    model2 := "HOD"
    relation := "L ⊆ HOD in all models of ZF" }

/-! ## Bisimulations -/

/-- A bisimulation between two set models relates equivalent elements -/
structure Bisimulation where
  model1 : String
  model2 : String
  relation : String
  isBisimulation : String
  deriving Repr

/-- The Mostowski collapse gives a bisimulation -/
def mostowskiBisimulation : Bisimulation :=
  { model1 := "well-founded extensional structure"
    model2 := "its transitive collapse"
    relation := "x ~ y iff π(x) = y"
    isBisimulation := "Mostowski collapse is an isomorphism" }

/-- Bisimulation invariance of first-order logic -/
def bisimulationInvariance : String :=
  "Bisimilar models satisfy the same first-order sentences"

/-! ## Forcing Extensions -/

/-- A forcing extension equivalence: the ground model can be recovered
from the generic extension (in some cases) -/
structure ForcingExtension where
  groundModel : String
  genericExtension : String
  poset : String
  isExtension : String
  deriving Repr

/-- Cohen forcing adds a new real -/
def cohenForcingExtension : ForcingExtension :=
  { groundModel := "M ⊨ ZFC"
    genericExtension := "M[G] ⊨ ZFC"
    poset := "Fn(ω,2) (Cohen forcing)"
    isExtension := "M ⊂ M[G] with a new Cohen real" }

/-- Random forcing adds a random real -/
def randomForcingExtension : ForcingExtension :=
  { groundModel := "M ⊨ ZFC"
    genericExtension := "M[G] ⊨ ZFC"
    poset := "Borel(2^ω)/Null (Random forcing)"
    isExtension := "M ⊂ M[G] with a new random real" }

/-! ## Galois Connections -/

/-- A Galois connection between posets of intermediate models -/
structure ModelGaloisConnection where
  leftAdjoint : String
  rightAdjoint : String
  description : String
  deriving Repr

/-- The ground model and generic extension form an adjoint pair -/
def forcingGaloisConnection : ModelGaloisConnection :=
  { leftAdjoint := "Taking generic extension M → M[G]"
    rightAdjoint := "Taking ground model via names"
    description := "Forcing ↔ Names adjunction" }

/-! ## Evaluations -/

#eval vEquivL_Sigma2.modelA
#eval vEquivL_Sigma2.modelB
#eval lSubsetOfHod.relation
#eval cohenForcingExtension.poset
#eval bisimulationInvariance
#eval forcingGaloisConnection.description

end MiniZFCLite
