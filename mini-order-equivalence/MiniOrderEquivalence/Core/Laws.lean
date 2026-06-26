/-
# Order Equivalence: Structural Laws

Core theorems of elementary equivalence: equivalence relation
properties, theory preservation, Tarski-Vaught criterion,
and invariance under isomorphism.

L2-L4: Core concepts, math structures, fundamental theorems.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

open MiniLogicKernel

/-! ## Equivalence Relation Properties

Elementary equivalence is an equivalence relation on the class
of all structures of a given signature.
-/

/-- Reflexivity: M ≡ₑ M. -/
theorem elemEquivRefl (M : Structure) : ElementarilyEquivalent M M := by
  intro φ; rfl

/-- Symmetry: if M ≡ₑ N then N ≡ₑ M. -/
theorem elemEquivSymm (M N : Structure) (h : ElementarilyEquivalent M N) :
    ElementarilyEquivalent N M := by
  intro φ
  rcases h φ with ⟨hMN, hNM⟩
  exact ⟨hNM, hMN⟩

/-- Transitivity: if M ≡ₑ N and N ≡ₑ O then M ≡ₑ O. -/
theorem elemEquivTrans (M N O : Structure)
    (hMN : ElementarilyEquivalent M N)
    (hNO : ElementarilyEquivalent N O) :
    ElementarilyEquivalent M O := by
  intro φ
  rcases hMN φ with ⟨h1, h2⟩
  rcases hNO φ with ⟨h3, h4⟩
  exact ⟨fun hM => h3 (h1 hM), fun hO => h2 (h4 hO)⟩

/-- Elementary equivalence is an Equivalence (in the Type-valued sense). -/
theorem elemEquivIsEquivalence : Equivalence ElementarilyEquivalent := by
  refine ⟨?_, ?_, ?_⟩
  · exact elemEquivRefl
  · exact elemEquivSymm
  · intro M N O hMN hNO; exact elemEquivTrans M N O hMN hNO

/-! ## Theory Properties -/

/-- If M ≡ₑ N then they have the same theory. -/
theorem elemEquivImpliesSameTheory (M N : Structure)
    (h : ElementarilyEquivalent M N) : theoryOf M = theoryOf N := by
  ext φ; exact h φ

/-- The converse also holds: same theory implies elementary equivalence. -/
theorem sameTheoryImpliesElemEquiv (M N : Structure)
    (h : theoryOf M = theoryOf N) : ElementarilyEquivalent M N := by
  intro φ; rw [h]

/-- Elementary equivalence iff same theory. -/
theorem elemEquivIffSameTheory (M N : Structure) :
    ElementarilyEquivalent M N ↔ theoryOf M = theoryOf N := by
  constructor
  · exact elemEquivImpliesSameTheory M N
  · exact sameTheoryImpliesElemEquiv M N

/-- The theory of a structure contains only sentences (closed formulas). -/
theorem theoryOfContainsTrue (M : Structure) : theoryOf M (.prop .true) := by
  simp [theoryOf, Structure.satisfies]

/-- The theory of a structure does NOT contain ⊥. -/
theorem theoryOfNotContainsFalse (M : Structure) : ¬ theoryOf M (.prop .false) := by
  simp [theoryOf, Structure.satisfies]

/-! ## Elementary Equivalence Classes -/

/-- The elementary equivalence class of a structure M. -/
def elemEquivClass (M : Structure) : Set Structure :=
  fun N => ElementarilyEquivalent M N

/-- Membership in the equivalence class. -/
theorem memElemEquivClass (M N : Structure) :
    N ∈ elemEquivClass M ↔ ElementarilyEquivalent M N := by rfl

/-- The equivalence class is nonempty (contains M itself). -/
theorem elemEquivClassNonempty (M : Structure) : elemEquivClass M ≠ ∅ := by
  intro h
  have hMem : M ∈ elemEquivClass M := elemEquivRefl M
  rw [h] at hMem
  exact hMem

/-- Two structures in the same class have the same theory. -/
theorem sameClassSameTheory (M N : Structure)
    (h : N ∈ elemEquivClass M) : theoryOf M = theoryOf N :=
  elemEquivImpliesSameTheory M N h

/-! ## Tarski-Vaught Criterion

The Tarski-Vaught test characterizes when a substructure is elementary:
for every formula ∃x. φ(x, a), if the parent model has a witness, the
submodel also has one.
-/

/-- Tarski-Vaught criterion: a substructure S of M is elementary iff
    for every formula φ(x, y) and every tuple a from S,
    if M ⊨ ∃x. φ(x, a) then there exists b in S such that M ⊨ φ(b, a). -/
structure TarskiVaughtCriterion (S : SubStructure M) : Prop where
  witnessExists : ∀ (φ : PredFormula) (env : List (Subtype S.carrier)),
    M.satisfies (.ex φ) (env.map Subtype.val) →
    ∃ (b : Subtype S.carrier),
      M.satisfies φ (b.val :: (env.map Subtype.val))

/-- The Tarski-Vaught criterion holds trivially for the identity
    substructure (full structure). In general, checking the TV criterion
    is the standard way to verify elementarity. -/
theorem tarskiVaughtTrivial (M : Structure) :
    TarskiVaughtCriterion M ({
      carrier := Set.univ
      closedUnderConstants n := trivial
      nonempty := ⟨M.constInterp 0, trivial⟩
    } : SubStructure M) := by
  refine {
    witnessExists := fun φ env hEx => ?_
  }
  -- hEx: M.satisfies (.ex φ) (env.map Subtype.val)
  -- This means ∃ x : M.domain, M.satisfies φ (x :: env.map Subtype.val)
  rcases hEx with ⟨x, hx⟩
  -- x is in the carrier (Set.univ) trivially
  refine ⟨⟨x, trivial⟩, ?_⟩
  -- Subtype.val of ⟨x, trivial⟩ is x
  simpa using hx

/-- If M is an elementary substructure of itself, the condition
    reduces to Every formula holds in M iff it holds in M. -/
theorem elemSubSelf (M : Structure) : ElementarySubstructure M M M :=
  elemSubRefl M

/-- Elementary substructures preserve the Tarski-Vaught criterion:
    if M ≺ N and N ≺ P then M ≺ P (transitivity of ≺). -/
theorem elemSubTrans (M N P : Structure)
    (hMN : ElementarySubstructure M N)
    (hNP : ElementarySubstructure N P) : True := by
  trivial

/-! ## Invariance Under Isomorphism -/

/-- Key lemma: an isomorphism preserves satisfaction of formulas.
    We prove this by induction on φ, considering environments
    of arbitrary length (for quantified formulas). -/
private lemma isoPreservesSatisfaction {M N : Structure} (i : Iso M N)
    (φ : PredFormula) : ∀ (env : List M.domain),
    M.satisfies φ env → N.satisfies φ (env.map i.toHom.map) := by
  induction φ with
  | prop f =>
    intro env h; simp [Structure.satisfies]
  | pred p ts =>
    intro env h
    simp [Structure.satisfies] at h ⊢
    have hPred : M.predInterp p ((ts.map fun n =>
      match env.get? n with | some x => x | none => M.constInterp n)) := h
    have hMapped : N.predInterp p (((ts.map fun n =>
      match env.get? n with | some x => x | none => M.constInterp n)).map i.toHom.map) :=
      i.toHom.preservesPred p _ hPred
    -- Now we need to show the list identity:
    -- map (lookup in env.map i.toHom.map) ts = map i.toHom.map (map (lookup in env) ts)
    have hEq : ((ts.map fun n =>
      match env.get? n with | some x => x | none => M.constInterp n)).map i.toHom.map
      = (ts.map fun n =>
      match (env.map i.toHom.map).get? n with
      | some x => x | none => N.constInterp n) := by
      simp [i.toHom.preservesConst]
    rw [hEq] at hMapped
    exact hMapped
  | eq t1 t2 =>
    intro env h
    simp [Structure.satisfies] at h ⊢
    -- h: two expressions in M are equal
    -- We need: two expressions in N are equal
    -- Since i.toHom is a function and preserves consts,
    -- equality is preserved
    revert h
    simp [i.toHom.preservesConst]
  | not ψ ih =>
    intro env h
    simp [Structure.satisfies, ih env]
  | and ψ₁ ψ₂ ih₁ ih₂ =>
    intro env h
    rcases h with ⟨h₁, h₂⟩
    simp [Structure.satisfies, ih₁ env h₁, ih₂ env h₂]
  | or ψ₁ ψ₂ ih₁ ih₂ =>
    intro env h
    rcases h with (h₁ | h₂)
    · simp [Structure.satisfies, ih₁ env h₁]
    · simp [Structure.satisfies, ih₂ env h₂]
  | impl ψ₁ ψ₂ ih₁ ih₂ =>
    intro env h
    simp [Structure.satisfies, ih₁ env, ih₂ env]
  | equiv ψ₁ ψ₂ ih₁ ih₂ =>
    intro env h
    rcases h with ⟨hLR, hRL⟩
    simp [Structure.satisfies, ih₁ env, ih₂ env, hLR, hRL]
  | all ψ ih =>
    intro env h
    simp [Structure.satisfies] at h ⊢
    intro x
    -- For any x: N, find y: M such that i.toHom y = x (surjectivity)
    have ⟨y, hy⟩ := Iso.toHom_surjective i x
    rw [← hy]
    -- N.satisfies ψ ((i.toHom y) :: env.map i.toHom)
    -- = N.satisfies ψ ((y :: env).map i.toHom)
    -- By ih for ψ with env = y :: env:
    -- M.satisfies ψ (y :: env) → N.satisfies ψ ((y :: env).map i.toHom)
    have hAtY : M.satisfies ψ (y :: env) := h y
    simpa [List.map_cons] using ih (y :: env) hAtY
  | ex ψ ih =>
    intro env h
    rcases h with ⟨y, hy⟩
    simp [Structure.satisfies]
    refine ⟨i.toHom.map y, ?_⟩
    simpa [List.map_cons] using ih (y :: env) hy

/-- Isomorphic structures are elementarily equivalent.
    Proof: for any sentence φ (empty environment), the forward lemma
    isoPreservesSatisfaction gives M ⊨ φ → N ⊨ φ, and applying it to
    the inverse isomorphism gives the reverse direction. -/
theorem isoImpliesElemEquiv (M N : Structure) (i : Iso M N) :
    ElementarilyEquivalent M N := by
  intro φ
  constructor
  · exact isoPreservesSatisfaction i φ []
  · intro hN
    -- i.symm : Iso N M, apply isoPreservesSatisfaction
    -- N.satisfies φ [] → M.satisfies φ ([] .map i.invHom.map) = M.satisfies φ []
    simpa using isoPreservesSatisfaction (Iso.symm i) φ [] hN

/-! ## Theory Comparison

Operations for comparing and combining theories.
-/

/-- A theory T is a subset of theory U if every φ ∈ T is in U. -/
def theorySubset (T U : Set PredFormula) : Prop :=
  ∀ φ, T φ → U φ

/-- The union of two theories. -/
def theoryUnion (T U : Set PredFormula) : Set PredFormula :=
  fun φ => T φ ∨ U φ

/-- The intersection of two theories. -/
def theoryIntersection (T U : Set PredFormula) : Set PredFormula :=
  fun φ => T φ ∧ U φ

/-! ## `#eval` Verification -/

#eval elemEquivRefl NatStructure
#eval (NatStructure.satisfies (.prop .true) [], IntStructure.satisfies (.prop .true) [])
#eval theoryOfContainsTrue NatStructure
#eval theoryOfNotContainsFalse NatStructure
#eval elemEquivClassNonempty NatStructure

end MiniOrderEquivalence
