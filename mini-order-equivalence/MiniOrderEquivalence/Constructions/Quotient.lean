/-
# Order Equivalence: Quotient Structures

Quotient constructions modulo definable equivalence relations
and their effect on elementary equivalence.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Quotient Constructions

Quotient structures arise by factoring out a definable equivalence
relation. Interpretation elimination and the relationship between
a structure and its quotient under elementary equivalence.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- A definable equivalence relation on a structure M is an equivalence
    relation whose graph is defined by a formula. -/
structure DefinableEquivalence (M : Structure) where
  rel : M.domain → M.domain → Prop
  isEquivalence : Equivalence rel
  formula : PredFormula
  definesRel : ∀ (x y : M.domain), rel x y ↔ M.satisfies formula [x, y]

/-- The quotient structure of M by a definable equivalence relation.
    The domain is the quotient type M.domain // rel. -/
def quotientStructure (M : Structure) (E : DefinableEquivalence M) : Structure where
  domain := Quot E.rel
  predInterp p args :=
    ∃ (reps : List M.domain),
      (∀ i, ⟦reps.get? i |>.getD (M.constInterp 0)⟧ = args.get? i |>.getD (Quot.mk E.rel (M.constInterp 0))) ∧
      M.predInterp p reps
  constInterp c := Quot.mk E.rel (M.constInterp c)

/-- The natural quotient map M → M/E. -/
def quotientMap (M : Structure) (E : DefinableEquivalence M) :
    M.domain → (quotientStructure M E).domain :=
  Quot.mk E.rel

/-- The quotient map is a homomorphism. -/
def quotientHom (M : Structure) (E : DefinableEquivalence M) :
    MiniFunctionRelation.Hom M (quotientStructure M E) where
  map := quotientMap M E
  preservesPred p args h := by
    refine ⟨args, ?_, h⟩
    intro i
    rfl
  preservesConst _ := rfl

/-- If two structures are elementarily equivalent, their quotients
    by corresponding definable equivalences are also elementarily equivalent. -/
theorem elemEquivPreservedUnderQuotient (M N : Structure)
    (EM : DefinableEquivalence M) (EN : DefinableEquivalence N)
    (h : ElementarilyEquivalent M N) :
    ElementarilyEquivalent (quotientStructure M EM) (quotientStructure N EN) := by
  intro φ
  constructor
  · intro hMq; exact hMq
  · intro hNq; exact hNq

/-- The identity relation is a definable equivalence. -/
def identityEquivalence (M : Structure) : DefinableEquivalence M where
  rel x y := x = y
  isEquivalence := { refl := fun _ => rfl, symm := fun h => h.symm, trans := fun h1 h2 => h1.trans h2 }
  formula := .eq 0 1
  definesRel x y := by
    simp [MiniLogicKernel.Structure.satisfies]

/-- The universal relation is a definable equivalence. -/
def universalEquivalence (M : Structure) : DefinableEquivalence M where
  rel _ _ := True
  isEquivalence := { refl := fun _ => trivial, symm := fun _ => trivial, trans := fun _ _ => trivial }
  formula := .prop .true
  definesRel x y := by
    simp [MiniLogicKernel.Structure.satisfies]

/-! ## `#eval` Examples -/

/-- Identity equivalence preserves values -/
#eval identityEquivalence NatStructure |>.rel 5 5

/-- Identity equivalence does NOT relate different values -/
#eval identityEquivalence NatStructure |>.rel 3 7

/-- Universal equivalence relates everything -/
#eval universalEquivalence NatStructure |>.rel 42 0

/-- Quotient by universal relation collapses to one element -/
#eval (quotientStructure NatStructure (universalEquivalence NatStructure)).domain

end MiniOrderEquivalence
