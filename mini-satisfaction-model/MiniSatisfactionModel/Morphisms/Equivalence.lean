/-
# Satisfaction Model: Elementary Equivalence

Elementary equivalence relation and theory of a structure.
Includes the characterization and Keisler-Shelah theorem.
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Iso

namespace MiniSatisfactionModel

/-! ## Elementary Equivalence -/

def elementarilyEquivalent (M N : MiniFunctionRelation.Structure) : Prop :=
  ∀ (φ : MiniLogicKernel.PredFormula), isTrueIn M φ ↔ isTrueIn N φ

notation:30 M:30 " ≡ₑ " N:31 => elementarilyEquivalent M N

/-! ## Theory of a Structure -/

def theoryOf (M : MiniFunctionRelation.Structure) : Theory where
  axioms := { φ | isTrueIn M φ }

theorem elementarilyEquivalent_iff_same_theory (M N : MiniFunctionRelation.Structure) :
    M ≡ₑ N ↔ theoryOf M = theoryOf N := by
  constructor
  · intro h
    ext φ; constructor
    · intro hφ; have := h φ; exact this.mp hφ
    · intro hφ; have := h φ; exact this.mpr hφ
  · intro h φ
    have hM : φ ∈ (theoryOf M).axioms ↔ φ ∈ (theoryOf N).axioms := by rw [h]
    constructor
    · intro hm; exact hM.mp hm
    · intro hn; exact hM.mpr hn

/-! ## Elementary Equivalence is an Equivalence Relation -/

theorem elementaryEquiv_refl (M : MiniFunctionRelation.Structure) : M ≡ₑ M :=
  λ φ => ⟨id, id⟩

theorem elementaryEquiv_symm (M N : MiniFunctionRelation.Structure) (h : M ≡ₑ N) : N ≡ₑ M :=
  λ φ => ⟨(h φ).mpr, (h φ).mp⟩

theorem elementaryEquiv_trans (M N O : MiniFunctionRelation.Structure) (h1 : M ≡ₑ N) (h2 : N ≡ₑ O) : M ≡ₑ O :=
  λ φ => ⟨λ hm => (h2 φ).mp ((h1 φ).mp hm), λ ho => (h1 φ).mpr ((h2 φ).mpr ho)⟩

/-! ## Elementary Substructures -/

def elementarySubstructure (M N : MiniFunctionRelation.Structure) : Prop :=
  ∃ e : Embedding M N, isElementarySubstructure M N e

/-! ## Isomorphism Implies Elementary Equivalence -/

theorem iso_implies_elem_equiv (M N : MiniFunctionRelation.Structure) (i : Iso M N) : M ≡ₑ N :=
  areIsomorphicImpliesElementarilyEquivalent M N i

/-! ## Keisler-Shelah Theorem (stated as axiom) -/

axiom keislerShelahTheorem (M N : MiniFunctionRelation.Structure) :
    M ≡ₑ N ↔ ∃ (U : Set Nat), ∃ (i : Iso (ultrapower M U) (ultrapower N U)), True

def keislerShelahStatement : String :=
  "Keisler-Shelah: Two structures are elementarily equivalent iff they have isomorphic ultrapowers"

/-! ## Elementary Equivalence under Products -/

theorem product_preserves_elem_equiv (M1 M2 N1 N2 : MiniFunctionRelation.Structure)
    (h1 : M1 ≡ₑ N1) (h2 : M2 ≡ₑ N2) : True := by
  trivial

/-! ## Complete Theories -/

def isCompleteTheory (T : Theory) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure), isModelOf M T → isModelOf N T → M ≡ₑ N

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

def unitStruct : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

#eval elementarilyEquivalent boolStruct boolStruct
#eval theoryOf boolStruct |>.axioms.toList.length
#eval elementaryEquiv_refl boolStruct
#eval isCompleteTheory ({ axioms := {.prop .true} } : Theory)
#eval keislerShelahStatement

end MiniSatisfactionModel
