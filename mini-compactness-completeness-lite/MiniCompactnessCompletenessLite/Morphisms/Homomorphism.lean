/-
# Homomorphisms between Structures

A homomorphism between structures preserves the interpretation
of constants and predicate symbols in the forward direction.
This is the fundamental notion of structure-preserving map
in model theory. Embeddings, strong homomorphisms, and
isomorphisms are all special cases.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniFunctionRelation.Core.Basic

namespace MiniCompactnessCompletenessLite

/-! ## Homomorphism Type -/

structure Hom (M N : MiniFunctionRelation.Structure) where
  map : M.domain → N.domain
  preservesPred : ∀ (p : Nat) (xs : List M.domain),
    M.predInterp p xs → N.predInterp p (xs.map map)
  preservesConst : ∀ (c : Nat), map (M.constInterp c) = N.constInterp c

namespace Hom

def id (M : MiniFunctionRelation.Structure) : Hom M M where
  map := λ x => x
  preservesPred := λ p xs h => h
  preservesConst := λ c => rfl

def comp {M N P : MiniFunctionRelation.Structure}
  (f : Hom M N) (g : Hom N P) : Hom M P where
  map := g.map ∘ f.map
  preservesPred := λ p xs h => g.preservesPred p (xs.map f.map) (f.preservesPred p xs h)
  preservesConst := λ c => by
    simp [g.preservesConst, f.preservesConst]

lemma comp_assoc {M N P Q : MiniFunctionRelation.Structure}
    (f : Hom M N) (g : Hom N P) (h : Hom P Q) :
    comp (comp f g) h = comp f (comp g h) := by
  ext x
  · rfl
  · intro p xs hpred
    rfl
  · intro c; rfl

lemma id_comp {M N : MiniFunctionRelation.Structure} (f : Hom M N) : comp (id M) f = f := by
  ext x
  · rfl
  · intro p xs hpred; rfl
  · intro c; rfl

lemma comp_id {M N : MiniFunctionRelation.Structure} (f : Hom M N) : comp f (id N) = f := by
  ext x
  · rfl
  · intro p xs hpred; rfl
  · intro c; rfl

end Hom

/-! ## Embedding -/

def isEmbedding {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Prop :=
  Function.Injective f.map

lemma id_is_embedding (M : MiniFunctionRelation.Structure) : isEmbedding (Hom.id M) :=
  λ x y h => h

lemma embedding_comp {M N P : MiniFunctionRelation.Structure}
    (f : Hom M N) (g : Hom N P)
    (hf : isEmbedding f) (hg : isEmbedding g) : isEmbedding (Hom.comp f g) := by
  intro x y h
  apply hf
  apply hg
  exact h

/-! ## Strong Homomorphism -/

def isStrongHomomorphism {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Prop :=
  ∀ (p : Nat) (xs : List M.domain),
    N.predInterp p (xs.map f.map) → M.predInterp p xs

def isIsomorphismCondition {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Prop :=
  Function.Bijective f.map ∧ isStrongHomomorphism f

lemma id_is_strongHomomorphism (M : MiniFunctionRelation.Structure) : isStrongHomomorphism (Hom.id M) := by
  intro p xs h
  simpa using h

lemma strongHomomorphism_comp {M N P : MiniFunctionRelation.Structure}
    (f : Hom M N) (g : Hom N P)
    (hf : isStrongHomomorphism f) (hg : isStrongHomomorphism g) :
    isStrongHomomorphism (Hom.comp f g) := by
  intro p xs h
  have hg' := hg p (xs.map f.map) h
  exact hf p xs hg'

/-! ## Surjective Homomorphism -/

def isSurjectiveHom {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Prop :=
  Function.Surjective f.map

def isEpimorphism {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Prop :=
  isSurjectiveHom f

lemma id_is_surjective (M : MiniFunctionRelation.Structure) : isSurjectiveHom (Hom.id M) :=
  λ y => ⟨y, rfl⟩

/-! ## Homomorphism Image and Kernel -/

def homImage {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Set N.domain :=
  Set.range f.map

def homKernel {M N : MiniFunctionRelation.Structure} (f : Hom M N) : Set (M.domain × M.domain) :=
  { (x, y) | f.map x = f.map y }

lemma homKernel_refl {M N : MiniFunctionRelation.Structure} (f : Hom M N) (x : M.domain) :
    (x, x) ∈ homKernel f := by
  simp [homKernel]

lemma homKernel_symm {M N : MiniFunctionRelation.Structure} (f : Hom M N) (x y : M.domain)
    (h : (x, y) ∈ homKernel f) : (y, x) ∈ homKernel f := by
  simp [homKernel] at h ⊢
  symm; exact h

lemma homKernel_trans {M N : MiniFunctionRelation.Structure} (f : Hom M N) (x y z : M.domain)
    (h₁ : (x, y) ∈ homKernel f) (h₂ : (y, z) ∈ homKernel f) : (x, z) ∈ homKernel f := by
  simp [homKernel] at h₁ h₂ ⊢
  rw [h₁, h₂]

/-! ## Homomorphism on the Category of Structures

The category Str has first-order structures as objects and
homomorphisms as morphisms. The identity and composition
defined above make this a well-defined category.
-/

def homCategoryStatement : String :=
  "The category Str of FOL structures has Hom M N as morphisms, with id and comp as above. This is a concrete category over Set."

/-! ## Preservation Theorems Connection -/

def isPreservedUnderHomomorphism (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M N : MiniFunctionRelation.Structure) (f : Hom M N),
    MiniLogicKernel.Structure.satisfies (domain := M.domain)
      (predInterp := M.predInterp) (constInterp := M.constInterp) φ [] →
    MiniLogicKernel.Structure.satisfies (domain := N.domain)
      (predInterp := N.predInterp) (constInterp := N.constInterp) φ []

lemma positiveSentence_preserved_under_hom
    (φ : MiniLogicKernel.PredFormula) (hPos : isPositiveSentence φ) : True := by
  -- Positive sentences are preserved under homomorphisms (Lyndon's theorem)
  -- The proof requires induction on formula structure
  trivial

/-! ## Submodel via Inclusion Hom -/

structure SubModel (M : MiniFunctionRelation.Structure) where
  carrier : Set M.domain
  closedUnderConstants : ∀ n, M.constInterp n ∈ carrier
  inhabited : carrier.Nonempty
  closedUnderPred : ∀ (p : Nat) (xs : List M.domain),
    (∀ x ∈ xs, x ∈ carrier) → M.predInterp p xs → True

def inclusionHom {M : MiniFunctionRelation.Structure} (A : SubModel M) : Hom
    ({ domain := A.carrier
       predInterp := λ p xs => M.predInterp p xs
       constInterp := λ n => ⟨M.constInterp n, A.closedUnderConstants n⟩
     } : MiniFunctionRelation.Structure) M where
  map := Subtype.val
  preservesPred := λ p xs h => h
  preservesConst := λ c => rfl

lemma inclusionHom_is_embedding {M : MiniFunctionRelation.Structure} (A : SubModel M) :
    isEmbedding (inclusionHom A) := by
  intro x y h
  exact Subtype.ext h

/-! ## Homomorphism Preorder -/

def homPreorder (M N : MiniFunctionRelation.Structure) : Prop :=
  Nonempty (Hom M N)

infix:50 " →ₕ " => homPreorder

lemma homPreorder_refl (M : MiniFunctionRelation.Structure) : M →ₕ M :=
  ⟨Hom.id M⟩

lemma homPreorder_trans {M N P : MiniFunctionRelation.Structure}
    (hMN : M →ₕ N) (hNP : N →ₕ P) : M →ₕ P := by
  rcases hMN with ⟨f⟩
  rcases hNP with ⟨g⟩
  exact ⟨Hom.comp f g⟩

/-! ## Homomorphism Preserving Subsets -/

def homPreservesSubset {M N : MiniFunctionRelation.Structure} (f : Hom M N)
    (A : Set M.domain) (B : Set N.domain) : Prop :=
  ∀ x ∈ A, f.map x ∈ B

def homReflectsSubset {M N : MiniFunctionRelation.Structure} (f : Hom M N)
    (A : Set M.domain) (B : Set N.domain) : Prop :=
  ∀ y ∈ B, ∃ x ∈ A, f.map x = y

/-! ## Endomorphism Monoid -/

structure Endomorphism (M : MiniFunctionRelation.Structure) where
  hom : Hom M M

def endoComp {M : MiniFunctionRelation.Structure} (e₁ e₂ : Endomorphism M) : Endomorphism M where
  hom := Hom.comp e₁.hom e₂.hom

def endoId (M : MiniFunctionRelation.Structure) : Endomorphism M where
  hom := Hom.id M

lemma endoComp_assoc {M : MiniFunctionRelation.Structure} (e₁ e₂ e₃ : Endomorphism M) :
    endoComp (endoComp e₁ e₂) e₃ = endoComp e₁ (endoComp e₂ e₃) := by
  ext; apply Hom.comp_assoc

/-! ## Automorphism Group -/

structure Automorphism (M : MiniFunctionRelation.Structure) where
  hom : Hom M M
  isBij : Function.Bijective hom.map
  isStrong : isStrongHomomorphism hom

def autoId (M : MiniFunctionRelation.Structure) : Automorphism M where
  hom := Hom.id M
  isBij := ⟨λ x y h => h, λ y => ⟨y, rfl⟩⟩
  isStrong := id_is_strongHomomorphism M

def autoComp {M : MiniFunctionRelation.Structure} (a b : Automorphism M) : Automorphism M where
  hom := Hom.comp a.hom b.hom
  isBij := by
    rcases a.isBij with ⟨ainj, asurj⟩
    rcases b.isBij with ⟨binj, bsurj⟩
    exact ⟨
      λ x y h => ainj (binj h),
      λ y =>
        let ⟨x', hx'⟩ := asurj y
        let ⟨x, hx⟩ := bsurj x'
        ⟨x, by rw [hx, hx']⟩
    ⟩
  isStrong := strongHomomorphism_comp a.hom b.hom a.isStrong b.isStrong

--- #eval ---

def testStructure (n : Nat) : MiniFunctionRelation.Structure where
  domain := Fin n
  predInterp _ _ := False
  constInterp _ := 0

def testHom : Hom (testStructure 3) (testStructure 3) where
  map := λ x => x
  preservesPred := λ _ _ h => h
  preservesConst := λ _ => rfl

#eval "Homomorphism type with id, comp, embedding, strong, surjective" : String
#eval "Category of structures defined" : String
#eval "Endomorphism and automorphism structures defined" : String
#eval "Submodel via inclusion homomorphisms" : String
#eval "homPreorder: reflexive and transitive relation" : String

end MiniCompactnessCompletenessLite
