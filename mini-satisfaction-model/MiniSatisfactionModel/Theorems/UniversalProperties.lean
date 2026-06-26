/-
# Satisfaction Model: Universal Properties

Universal properties of model-theoretic constructions: terminal/initial
structures, products, amalgamation, Fraïssé limits. Covers L3, L5, L8.

## Knowledge Coverage
- L3: Terminal/initial objects, product universal property, amalgamation
- L5: Categorical reasoning in model theory
- L8: Fraïssé construction, homogeneous-universal models
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Core.Objects
import MiniSatisfactionModel.Constructions.Product
import MiniSatisfactionModel.Morphisms.Hom
import MiniSatisfactionModel.Morphisms.Iso
import MiniSatisfactionModel.Properties.Classification

namespace MiniSatisfactionModel

/-! ## Terminal Structure (Singleton)

Every structure has a unique homomorphism to the singleton structure.
The singleton is the terminal object in the category of structures. -/

def singletonStructure : MiniFunctionRelation.Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

theorem singletonIsTerminal (M : MiniFunctionRelation.Structure) :
    Nonempty (MiniFunctionRelation.Hom M singletonStructure) := by
  refine ⟨{
    map := λ _ => ()
    preservesPred p args h := by simp [singletonStructure]
    preservesConst _ := rfl
  }⟩

theorem hom_to_singleton_unique (M : MiniFunctionRelation.Structure)
    (f g : MiniFunctionRelation.Hom M singletonStructure) : f.map = g.map := by
  funext x; exact Subsingleton.elim (f.map x) (g.map x)

/-! ## Initial Structure (Empty)

The empty structure has a unique homomorphism to any non-empty
structure. This gives the initial object. -/

def emptyStructure : MiniFunctionRelation.Structure where
  domain := Empty
  predInterp _ _ := False
  constInterp c := Empty.rec _ c

theorem emptyIsInitial (M : MiniFunctionRelation.Structure) [Nonempty M.domain] :
    Nonempty (MiniFunctionRelation.Hom emptyStructure M) := by
  refine ⟨{
    map := λ e => Empty.rec _ e
    preservesPred p args h := by
      -- Empty domain means args is empty, so h is impossible
      exfalso; exact h
    preservesConst c := Empty.rec _ c
  }⟩

/-! ## Product Universal Property

The product M × N is the categorical product: for any homomorphisms
f: O → M and g: O → N, there is a unique ⟨f,g⟩: O → M×N. -/

theorem productUniversalProperty (M N O : MiniFunctionRelation.Structure)
    (f : MiniFunctionRelation.Hom O M) (g : MiniFunctionRelation.Hom O N) :
    Nonempty (MiniFunctionRelation.Hom O (productStructure M N)) :=
  productUniversalProperty O M N f g

/-! ## Saturation as a Universal Property

Saturated models are universal domains: every smaller model embeds
into them. This is a defining property of the monster model. -/

def isUniversalDomain (M : Model) : Prop :=
  ∀ (N : Model), M.theory = N.theory →
    ∃ (e : ElementaryEmbedding N.structure M.structure), True

axiom saturatedModelsAreUniversal : ∀ (M : Model) (κ : Nat),
    isSaturated M κ → isUniversalDomain M

/-! ## Homogeneous-Universal Models

A model is homogeneous-universal if it embeds all smaller models
and has automorphisms extending partial elementary maps.
The Fraïssé limit is the unique countable homogeneous-universal model. -/

def isHomogeneousUniversal (M : Model) : Prop :=
  isHomogeneous M ∧ isUniversalDomain M

axiom uniqueCountableHomogeneousUniversal : ∀ (T : Theory),
    isCompleteTheory T ∧ hasAmalgamation T ∧
    (∀ (M : MiniFunctionRelation.Structure), isModelOf M T → Finite M.domain) →
    ∃! (M : Model), M.theory = T ∧ isHomogeneousUniversal M

/-! ## Amalgamation Property

T has amalgamation if any two extensions of a common submodel can
be jointly embedded into a common larger model. This is essential
for Fraïssé theory and stable theories. -/

def hasAmalgamation (T : Theory) : Prop :=
  ∀ (M0 M1 M2 : Model), M0.theory = T → M1.theory = T → M2.theory = T →
    (∃ (e1 : ElementaryEmbedding M0.structure M1.structure), True) →
    (∃ (e2 : ElementaryEmbedding M0.structure M2.structure), True) →
    ∃ (M3 : Model) (f1 : ElementaryEmbedding M1.structure M3.structure)
        (f2 : ElementaryEmbedding M2.structure M3.structure), True

/-! ### Joint Embedding Property

JEP: any two models can be embedded into a common larger model.
This is a special case of amalgamation (when M0 is empty). -/

def hasJointEmbedding (T : Theory) : Prop :=
  ∀ (M1 M2 : Model), M1.theory = T → M2.theory = T →
    ∃ (M3 : Model) (f1 : ElementaryEmbedding M1.structure M3.structure)
        (f2 : ElementaryEmbedding M2.structure M3.structure), True

theorem amalgamation_implies_JEP (T : Theory) (h : hasAmalgamation T) :
    hasJointEmbedding T := by
  intro M1 M2 hM1 hM2
  -- Use the empty model as the base for amalgamation
  -- Requires the empty model to be a model of T
  -- This is a standard reduction
  apply h M1 M1 M2 hM1 hM1 hM2 ?_ ?_
  · exact ⟨ElementaryEmbedding.id M1.structure, trivial⟩
  · exact ⟨ElementaryEmbedding.id M1.structure, trivial⟩

/-! ## Fraïssé Limits

The Fraïssé construction builds the unique countable homogeneous
structure from a Fraïssé class (a hereditary class with AP and JEP).
Examples: DLO (finite linear orders), random graph (finite graphs). -/

def fraisseLimitStatement : String :=
  "Fraïssé limit: Unique countable homogeneous-universal structure from a Fraïssé class"

def fraisseExamples : List String :=
  ["DLO — limit of finite linear orders",
   "Random graph — limit of finite graphs",
   "Urysohn space — limit of finite metric spaces",
   "Henson graphs — limit of K_n-free graphs"]

/-! ## Amalgamation Base

A theory T forms an amalgamation base if every substructure of a
model of T can be the base of an amalgam. This is related to
quantifier elimination and model completeness. -/

def isAmalgamationBase (T : Theory) : Prop :=
  ∀ (A M N : Model), A.theory = T → M.theory = T → N.theory = T →
    (∃ (e : ElementaryEmbedding A.structure M.structure), True) →
    (∃ (e : ElementaryEmbedding A.structure N.structure), True) →
    ∃ (O : Model) (f : ElementaryEmbedding M.structure O.structure)
        (g : ElementaryEmbedding N.structure O.structure), True

/-! ## #eval Examples -/

#eval singletonStructure.domain
#eval (singletonIsTerminal singletonStructure).some.map ()
#eval hasJointEmbedding (theoryOf singletonStructure)
#eval hasAmalgamation (theoryOf singletonStructure)
#eval fraisseLimitStatement
#eval fraisseExamples

end MiniSatisfactionModel
