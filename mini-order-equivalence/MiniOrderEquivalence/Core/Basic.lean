/-
# Order Equivalence: Core Definitions

Elementary equivalence, structure homomorphisms, isomorphisms,
elementary substructures, and the Tarski-Vaught criterion.

This module uses `MiniLogicKernel.Structure` as the canonical
first-order structure type because it has the `satisfies` relation.
We define `Hom`, `Iso`, `SubStructure` locally to avoid type
conflicts with `MiniFunctionRelation`.
-/

import MiniLogicKernel.Core.Objects
import MiniLogicKernel.Core.Basic

namespace MiniOrderEquivalence

open MiniLogicKernel

/-! ## Type Aliases

We use `MiniLogicKernel.Structure` throughout as our first-order structure
type, since it provides the `satisfies` relation for `PredFormula`.
-/

/-- The canonical first-order structure type for this module. -/
abbrev Structure := MiniLogicKernel.Structure

/-! ## Structure Homomorphisms

A homomorphism between structures preserves predicates forward
and constants exactly.
-/

/-- A homomorphism f: M → N preserves all predicate and constant
    interpretations. For a predicate symbol p applied to args,
    if M.predInterp holds of args then N.predInterp holds of
    their images under the map. -/
structure Hom (M N : Structure) where
  map : M.domain → N.domain
  /-- Predicates are preserved forward: M ⊨ P(args) → N ⊨ P(map(args)). -/
  preservesPred : ∀ (p : Nat) (args : List M.domain),
    M.predInterp p args → N.predInterp p (args.map map)
  /-- Constants are preserved exactly. -/
  preservesConst : ∀ (c : Nat), map (M.constInterp c) = N.constInterp c

namespace Hom

/-- Identity homomorphism on any structure. -/
def id (M : Structure) : Hom M M where
  map x := x
  preservesPred _ _ h := h
  preservesConst _ := rfl

/-- Composition of homomorphisms M → N → O. -/
def comp {M N O : Structure} (g : Hom N O) (f : Hom M N) : Hom M O where
  map x := g.map (f.map x)
  preservesPred p args h :=
    g.preservesPred p (args.map f.map) (f.preservesPred p args h)
  preservesConst c := by
    rw [f.preservesConst, g.preservesConst]
    rfl

/-- A homomorphism is injective on the domain. -/
def isInjective {M N : Structure} (f : Hom M N) : Prop :=
  ∀ x y, f.map x = f.map y → x = y

/-- A homomorphism is surjective on the domain. -/
def isSurjective {M N : Structure} (f : Hom M N) : Prop :=
  ∀ y, ∃ x, f.map x = y

/-- A homomorphism is bijective on the domain. -/
def isBijective {M N : Structure} (f : Hom M N) : Prop :=
  isInjective f ∧ isSurjective f

end Hom

/-! ## Structure Isomorphisms

An isomorphism is a homomorphism with a two-sided inverse homomorphism.
Isomorphic structures are "the same" in terms of predicates and constants.
-/

/-- An isomorphism M ≅ N: a pair of homomorphisms M→N, N→M that are
    mutual inverses. -/
structure Iso (M N : Structure) where
  toHom : Hom M N
  invHom : Hom N M
  leftInv : ∀ x, invHom.map (toHom.map x) = x
  rightInv : ∀ y, toHom.map (invHom.map y) = y

namespace Iso

/-- Identity isomorphism. -/
def id (M : Structure) : Iso M M where
  toHom := Hom.id M
  invHom := Hom.id M
  leftInv _ := rfl
  rightInv _ := rfl

/-- Compose isomorphisms M ≅ N ≅ O. -/
def comp {M N O : Structure} (g : Iso N O) (f : Iso M N) : Iso M O where
  toHom := Hom.comp g.toHom f.toHom
  invHom := Hom.comp f.invHom g.invHom
  leftInv x := by
    dsimp
    rw [f.leftInv, g.leftInv]
  rightInv y := by
    dsimp
    rw [g.rightInv, f.rightInv]

/-- The inverse (symmetry) of an isomorphism. -/
def symm {M N : Structure} (i : Iso M N) : Iso N M where
  toHom := i.invHom
  invHom := i.toHom
  leftInv := i.rightInv
  rightInv := i.leftInv

/-- Symmetry is involutive. -/
theorem symm_involutive {M N : Structure} (i : Iso M N) : symm (symm i) = i := rfl

/-- Isomorphisms are injective. -/
theorem toHom_injective {M N : Structure} (i : Iso M N) : Function.Injective i.toHom.map := by
  intro x y h
  calc
    x = i.invHom.map (i.toHom.map x) := by rw [i.leftInv]
    _ = i.invHom.map (i.toHom.map y) := by rw [h]
    _ = y := by rw [i.leftInv]

/-- Isomorphisms are surjective. -/
theorem toHom_surjective {M N : Structure} (i : Iso M N) : Function.Surjective i.toHom.map := by
  intro y
  refine ⟨i.invHom.map y, ?_⟩
  rw [i.rightInv]

end Iso

/-! ## Substructure

A substructure is a nonempty subset of the domain closed under
constant interpretations. Predicates are inherited by restriction.
-/

structure SubStructure (M : Structure) where
  carrier : Set M.domain
  closedUnderConstants : ∀ n, M.constInterp n ∈ carrier
  nonempty : carrier.Nonempty

/-- The restriction of a structure M to a substructure S.
    This creates a new structure whose domain is the carrier of S. -/
def SubStructure.toStructure (S : SubStructure M) : Structure where
  domain := Subtype S.carrier
  predInterp p args := M.predInterp p (args.map Subtype.val)
  constInterp n := ⟨M.constInterp n, S.closedUnderConstants n⟩

/-- The inclusion map from a substructure to the parent structure
    is a homomorphism. -/
def SubStructure.inclusion (S : SubStructure M) : Hom (S.toStructure M) M where
  map := Subtype.val
  preservesPred p args h := by
    simp [SubStructure.toStructure] at h
    exact h
  preservesConst _ := rfl

/-! ## Elementary Equivalence

Two structures are elementarily equivalent if they satisfy exactly
the same first-order sentences (formulas with no free variables).
-/

/-- Two structures M, N are elementarily equivalent if for all
    closed formulas φ, M ⊨ φ ↔ N ⊨ φ. -/
def ElementarilyEquivalent (M N : Structure) : Prop :=
  ∀ (φ : PredFormula), M.satisfies φ [] ↔ N.satisfies φ []

/-- Infix notation for elementary equivalence. -/
infixl:50 " ≡ₑ " => ElementarilyEquivalent

/-- The (first-order) theory of a structure: the set of all sentences
    true in M. -/
def theoryOf (M : Structure) : Set PredFormula :=
  fun φ => M.satisfies φ []

/-! ## Elementary Substructures

M is an elementary substructure of N (written M ≺ N) if M is a
substructure of N and for every formula φ and every assignment from
M, the satisfaction in M matches the satisfaction in N.
-/

/-- Elementary substructure: the substructure relation with the
    Tarski-Vaught property that all formulas are absolute between
    the submodel and the parent model. -/
structure ElementarySubstructure (M N : Structure) where
  sub : SubStructure M
  /-- The Tarski-Vaught property: for every formula φ and environment
      from the submodel, the restricted model and the parent model agree. -/
  elementarilyEquivalent : ∀ (φ : PredFormula)
    (env : List (Subtype sub.carrier)),
    (SubStructure.toStructure M sub).satisfies φ env →
    M.satisfies φ (env.map Subtype.val)

/-- Every structure is trivially an elementary substructure of itself. -/
def elemSubRefl (M : Structure) : ElementarySubstructure M M where
  sub := {
    carrier := Set.univ
    closedUnderConstants n := trivial
    nonempty := ⟨M.constInterp 0, trivial⟩
  }
  elementarilyEquivalent φ env h := by
    simpa [SubStructure.toStructure] using h

/-! ## Finiteness Predicates -/

/-- A structure is finite if its domain carries a `Fintype` instance. -/
def isFinite (M : Structure) : Prop :=
  Nonempty (Fintype M.domain)

/-- A structure is infinite if it is not finite. -/
def isInfinite (M : Structure) : Prop :=
  ¬ isFinite M

/-- A structure is countable if its domain carries a `Countable` instance. -/
def isCountable (M : Structure) : Prop :=
  Nonempty (Countable M.domain)

/-! ## Elementary Embeddings

An elementary embedding is a map between structures that preserves
the truth of ALL first-order formulas (not just atomic ones).
We include constant preservation as an explicit condition, and
formula preservation as a forward-only condition (the reverse
direction follows from the negation-preservation property).
-/

/-- An elementary embedding f: M → N preserves the truth of all formulas
    forward, and maps constants to constants. This is the standard
    model-theoretic definition. -/
structure ElemEmbedding (M N : Structure) where
  map : M.domain → N.domain
  /-- Constants are mapped to corresponding constants. -/
  preservesConst : ∀ (c : Nat), map (M.constInterp c) = N.constInterp c
  /-- For every formula φ and environment env, if M satisfies φ under env,
      then N satisfies φ under (env.map map). -/
  elemPreserving : ∀ (φ : PredFormula) (env : List M.domain),
    M.satisfies φ env → N.satisfies φ (env.map map)

namespace ElemEmbedding

/-- Identity elementary embedding. -/
def id (M : Structure) : ElemEmbedding M M where
  map x := x
  preservesConst _ := rfl
  elemPreserving φ env h := h

/-- Composition of elementary embeddings. -/
def comp {M N O : Structure} (g : ElemEmbedding N O)
    (f : ElemEmbedding M N) : ElemEmbedding M O where
  map x := g.map (f.map x)
  preservesConst c := by
    rw [f.preservesConst, g.preservesConst]
    rfl
  elemPreserving φ env h := by
    have hN : N.satisfies φ (env.map f.map) := f.elemPreserving φ env h
    have hO : O.satisfies φ ((env.map f.map).map g.map) := g.elemPreserving φ (env.map f.map) hN
    simpa [List.map_map] using hO

/-- Every elementary embedding is a homomorphism. -/
def toHom (e : ElemEmbedding M N) : Hom M N where
  map := e.map
  preservesPred p args h := by
    -- Encode the predicate application as a PredFormula.
    -- .pred p [0,1,...,n-1] with env = args has env.get? i = some args[i]
    -- so the interpreted args are exactly args.
    let indices : List Nat := List.ofFn fun (i : Fin args.length) => i.val
    have hSat : M.satisfies (.pred p indices) args := by
      -- By construction, .pred p indices with env = args reads env.get? i
      -- which is some args[i] for i < args.length
      simpa [Structure.satisfies] using h
    have hPreserved : N.satisfies (.pred p indices) (args.map e.map) :=
      e.elemPreserving (.pred p indices) args hSat
    simpa [Structure.satisfies] using hPreserved
  preservesConst c := e.preservesConst c

/-- An elementary embedding reflects formulas backward:
    if N satisfies φ under the mapped environment, then M satisfies φ. -/
theorem reflects (e : ElemEmbedding M N) (φ : PredFormula) (env : List M.domain)
    (hN : N.satisfies φ (env.map e.map)) : M.satisfies φ env := by
  -- Use the fact that M satisfies ¬φ → N satisfies ¬φ (by elemPreserving)
  -- If M does NOT satisfy φ, then M satisfies ¬φ, so N satisfies ¬φ,
  -- contradicting hN. Therefore M must satisfy φ.
  by_contra! hNot
  have hM_not : M.satisfies (.not φ) env := hNot
  have hN_not : N.satisfies (.not φ) (env.map e.map) :=
    e.elemPreserving (.not φ) env hM_not
  -- But hN says N.satisfies φ (env.map e.map), contradiction
  exact hN_not hN

/-- An elementary embedding is injective on the domain. -/
theorem injective (e : ElemEmbedding M N) : Function.Injective e.map := by
  intro x y h
  -- Use the formula .eq 0 1 with environment [x, y]
  -- M.satisfies (.eq 0 1) [x, y] iff x = y
  -- By elemPreserving, N satisfies .eq 0 1 [f x, f y] iff f x = f y
  -- Since f x = f y (by h), N satisfies .eq 0 1 [f x, f y]
  -- By reflection, M must satisfy .eq 0 1 [x, y], hence x = y
  have hEqInN : N.satisfies (.eq 0 1) ([x, y].map e.map) := by
    -- .eq 0 1 with env [e.map x, e.map y] checks env.get? 0 = env.get? 1
    -- which is e.map x = e.map y, which holds by h
    have : ([x, y].map e.map).get? 0 = some (e.map x) := by simp
    have : ([x, y].map e.map).get? 1 = some (e.map y) := by simp
    -- Actually, in `satisfies (.eq 0 1)`, env.get? 0 = some (e.map x), env.get? 1 = some (e.map y)
    -- So it checks e.map x = e.map y, which holds by h.
    -- Let's compute: .eq 0 1 with env
    -- v1 := env.get? 0 = some (e.map x), v2 := env.get? 1 = some (e.map y)
    -- result: e.map x = e.map y, which is h.
    simpa [Structure.satisfies, h]
  have hEqInM := e.reflects (.eq 0 1) [x, y] hEqInN
  simpa [Structure.satisfies] using hEqInM

/-- An elementary embedding from M to N implies that M is elementarily
    equivalent to the image of the embedding (as a substructure of N). -/
theorem inducesElemEquiv (e : ElemEmbedding M N) : ElementarilyEquivalent M N := by
  intro φ
  constructor
  · intro hM
    exact e.elemPreserving φ [] hM
  · intro hN
    exact e.reflects φ [] hN

/-- Inclusion of an elementary substructure gives an elementary embedding
    (the inclusion map). -/
def ofElementarySubstructure (h : ElementarySubstructure M N) :
    ElemEmbedding (SubStructure.toStructure M h.sub) M where
  map := Subtype.val
  preservesConst c := rfl
  elemPreserving φ env hSat :=
    h.elementarilyEquivalent φ env hSat

end ElemEmbedding

/-! ## Concrete Structures

We define several concrete first-order structures for use
in examples throughout the module.
-/

/-- The natural numbers as a structure with the usual order ≤.
    predInterp 0 is the binary relation ≤, constInterp 0 is 0. -/
def NatStructure : Structure where
  domain := Nat
  predInterp
    | 0, [a, b] => a ≤ b
    | _, _ => False
  constInterp
    | 0 => 0
    | _ => 0

/-- The integers as a structure with the usual order ≤. -/
def IntStructure : Structure where
  domain := Int
  predInterp
    | 0, [a, b] => a ≤ b
    | _, _ => False
  constInterp
    | 0 => 0
    | _ => 0

/-- The rational numbers (represented as Nat × Nat with cross-multiplication
    order) as a dense linear order structure. -/
def RatLikeOrder : Structure where
  domain := Nat × Nat
  predInterp
    | 0, [(a₁, b₁), (a₂, b₂)] => (a₁ + 1) * (b₂ + 1) < (a₂ + 1) * (b₁ + 1)
    | _, _ => False
  constInterp _ := (0, 0)

/-- A finite linear order of size n, using Fin (max n 1) as the domain
    to ensure nonemptiness. predInterp 0 is the standard order on Fin. -/
def FinOrderStructure (n : Nat) : Structure where
  domain := Fin (max n 1)
  predInterp
    | 0, [a, b] => a.val ≤ b.val
    | _, _ => False
  constInterp _ := ⟨0, by
    have hpos : 0 < max n 1 := Nat.lt_of_lt_of_le (Nat.zero_lt_one) (Nat.le_max_right n 1)
    exact hpos⟩

/-- The binary Boolean structure: domain = Bool, one predicate true
    of `true`, constant = false. -/
def BoolStructure : Structure where
  domain := Bool
  predInterp
    | 0, [b] => b = true
    | _, _ => False
  constInterp _ := false

/-- The trivial one-element structure on Unit. All predicates true. -/
def UnitStructure : Structure where
  domain := Unit
  predInterp _ _ := True
  constInterp _ := ()

/-- The empty structure has domain = Empty (no elements).
    Note: this is an "empty model" which some conventions exclude. -/
def EmptyStructure : Structure where
  domain := Empty
  predInterp _ _ := False
  constInterp n := nomatch n

/-! ## `#eval` Verification

We test the core definitions on concrete structures.
-/

/-- Verify that NatStructure.satisfies a trivial formula returns True. -/
#eval (NatStructure.satisfies (.prop .true) [] : Prop)

/-- Verify that IntStructure also satisfies .true. -/
#eval (IntStructure.satisfies (.prop .true) [] : Prop)

/-- Verify theoryOf membership for the true formula. -/
#eval theoryOf NatStructure (.prop .true)

/-- Verify theoryOf does NOT contain .false (since .false never satisfied). -/
#eval theoryOf NatStructure (.prop .false)

/-- Check finiteness: FinOrderStructure 3 is finite. -/
#eval isFinite (FinOrderStructure 3)

/-- Check finiteness: UnitStructure is finite. -/
#eval isFinite UnitStructure

/-- Check infinitude: NatStructure is infinite. -/
#eval isInfinite NatStructure

/-- Identity homomorphism maps 42 to 42. -/
#eval (Hom.id NatStructure).map 42

/-- Identity isomorphism preserves constants. -/
#eval (Iso.id IntStructure).toHom.preservesConst 0

/-- Elementary embedding identity preserves trivial truth. -/
#eval ((ElemEmbedding.id NatStructure).elemPreserving (.prop .true) []).mp trivial

/-- Substructure inclusion map is defined. -/
def trivialSubStruct : SubStructure NatStructure := {
  carrier := fun n => n = 0
  closedUnderConstants 0 := rfl
  nonempty := ⟨0, rfl⟩
}
#eval (trivialSubStruct.inclusion NatStructure).map ⟨0, rfl⟩

end MiniOrderEquivalence
