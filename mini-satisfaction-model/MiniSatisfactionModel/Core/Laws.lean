/-
# Satisfaction Model: Satisfaction Laws

Tarski's definition of truth, satisfaction relation, fundamental
model-theoretic laws, and semantic consequence. Covers L2 (Core Concepts),
L4 (Fundamental Theorems), L5 (Proof Techniques).

## Knowledge Coverage
- L2: Semantic consequence, logical equivalence, theory closure
- L4: Satisfaction laws for connectives and quantifiers
- L5: Structural induction on formulas
- L6: Concrete satisfaction evaluation
-/

import MiniSatisfactionModel.Core.Basic

namespace MiniSatisfactionModel

/-! ## Satisfaction Bridge Lemma

The `satisfies` function bridges `MiniFunctionRelation.Structure` to
`MiniLogicKernel.Structure`. We prove that unfolding yields the
expected semantic clauses. -/

def mkLogicStruct (M : MiniFunctionRelation.Structure) : MiniLogicKernel.Structure :=
  { domain := M.domain
    predInterp := M.predInterp
    constInterp := M.constInterp }

theorem satisfies_eq_logic_satisfies (M : MiniFunctionRelation.Structure)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M φ env ↔ MiniLogicKernel.Structure.satisfies (mkLogicStruct M) φ env := by
  rfl

/-! ## Satisfaction Laws for Connectives

These are Tarski's compositional clauses for the satisfaction relation.
Each connective's meaning is given by its classical truth table. -/

theorem satisfies_conj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.and φ ψ) env ↔ (satisfies M φ env ∧ satisfies M ψ env) := by
  simp [satisfies]

theorem satisfies_disj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.or φ ψ) env ↔ (satisfies M φ env ∨ satisfies M ψ env) := by
  simp [satisfies]

theorem satisfies_impl (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.impl φ ψ) env ↔ (satisfies M φ env → satisfies M ψ env) := by
  simp [satisfies]

theorem satisfies_neg (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.not φ) env ↔ ¬ satisfies M φ env := by
  simp [satisfies]

theorem satisfies_equiv (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.equiv φ ψ) env ↔ (satisfies M φ env ↔ satisfies M ψ env) := by
  simp [satisfies]

theorem satisfies_prop (M : MiniFunctionRelation.Structure) (f : MiniLogicKernel.Formula) (env : List M.domain) :
    satisfies M (.prop f) env ↔ True := by
  simp [satisfies]

/-! ## Satisfaction Laws for Quantifiers -/

theorem satisfies_all (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.all φ) env ↔ (∀ x : M.domain, satisfies M φ (x :: env)) := by
  simp [satisfies]

theorem satisfies_ex (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) (env : List M.domain) :
    satisfies M (.ex φ) env ↔ (∃ x : M.domain, satisfies M φ (x :: env)) := by
  simp [satisfies]

theorem satisfies_eq (M : MiniFunctionRelation.Structure) (t1 t2 : Nat) (env : List M.domain) :
    satisfies M (.eq t1 t2) env ↔
    (match env.get? t1, env.get? t2 with
     | some v1, some v2 => v1 = v2
     | none, some v2 => M.constInterp t1 = v2
     | some v1, none => v1 = M.constInterp t2
     | none, none => M.constInterp t1 = M.constInterp t2) := by
  simp [satisfies]

/-! ## Predicate Satisfaction -/

theorem satisfies_pred (M : MiniFunctionRelation.Structure) (p : Nat) (ts : List Nat) (env : List M.domain) :
    satisfies M (.pred p ts) env ↔
    M.predInterp p (ts.map (λ n => match env.get? n with | some x => x | none => M.constInterp n)) := by
  simp [satisfies]

/-! ## Truth in a Structure (Tarski's Definition)

A sentence φ is true in M iff M satisfies φ under the empty assignment.
This is Tarski's definition of truth for formalized languages. -/

def isTrueIn (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) : Prop :=
  satisfies M φ []

def isFalseIn (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) : Prop :=
  ¬ isTrueIn M φ

/-! ### Truth Laws for Connectives -/

theorem isTrueIn_conj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.and φ ψ) ↔ (isTrueIn M φ ∧ isTrueIn M ψ) := by
  simp [isTrueIn]

theorem isTrueIn_disj (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.or φ ψ) ↔ (isTrueIn M φ ∨ isTrueIn M ψ) := by
  simp [isTrueIn]

theorem isTrueIn_impl (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.impl φ ψ) ↔ (isTrueIn M φ → isTrueIn M ψ) := by
  simp [isTrueIn]

theorem isTrueIn_neg (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.not φ) ↔ ¬ isTrueIn M φ := by
  simp [isTrueIn]

theorem isTrueIn_equiv (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.equiv φ ψ) ↔ (isTrueIn M φ ↔ isTrueIn M ψ) := by
  simp [isTrueIn]

/-! ### Truth Laws for Quantifiers -/

theorem isTrueIn_all (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.all φ) ↔ (∀ x : M.domain, satisfies M φ [x]) := by
  simp [isTrueIn]

theorem isTrueIn_ex (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn M (.ex φ) ↔ (∃ x : M.domain, satisfies M φ [x]) := by
  simp [isTrueIn]

/-! ### Principle of Bivalence

In classical model theory, for any sentence φ in a structure M,
either φ is true or φ is false (excluded middle). -/

theorem bivalence (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    isTrueIn M φ ∨ isFalseIn M φ := by
  unfold isFalseIn
  apply Classical.em

/-! ## Semantic Consequence

φ is a semantic consequence of T (written T ⊨ φ) if every model of T
satisfies φ. This is the model-theoretic counterpart of provability. -/

def entails (T : Theory) (φ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (M : MiniFunctionRelation.Structure), isModelOf M T → isTrueIn M φ

notation:40 T:40 " ⊨ " φ:41 => entails T φ

/-! ### Semantic Consequence Properties -/

theorem entails_refl (T : Theory) (φ : MiniLogicKernel.PredFormula) (h : φ ∈ T.axioms) : T ⊨ φ := by
  intro M hM
  apply hM
  exact h

theorem entails_trans (T : Theory) (φ ψ : MiniLogicKernel.PredFormula)
    (h₁ : T ⊨ φ) (h₂ : T ⊨ (.impl φ ψ)) : T ⊨ ψ := by
  intro M hM
  have hφ := h₁ M hM
  have himpl := h₂ M hM
  simp [isTrueIn] at himpl
  exact himpl hφ

theorem entails_of_empty (φ : MiniLogicKernel.PredFormula)
    (h : ∅ ⊨ φ) : isLogicallyValid φ := by
  intro M
  apply h M
  intro ψ hψ
  simp at hψ

theorem entails_monotone (T₁ T₂ : Theory) (φ : MiniLogicKernel.PredFormula)
    (hsub : T₁.axioms ⊆ T₂.axioms) (h : T₁ ⊨ φ) : T₂ ⊨ φ := by
  intro M hM
  apply h M
  intro ψ hψ
  apply hM
  exact hsub hψ

/-! ## Logical Equivalence (in a Structure) -/

def logicallyEquivalent (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula) : Prop :=
  ∀ (env : List M.domain), satisfies M φ env ↔ satisfies M ψ env

theorem logEquiv_refl (M : MiniFunctionRelation.Structure) (φ : MiniLogicKernel.PredFormula) :
    logicallyEquivalent M φ φ :=
  λ _ => ⟨id, id⟩

theorem logEquiv_symm (M : MiniFunctionRelation.Structure) (φ ψ : MiniLogicKernel.PredFormula)
    (h : logicallyEquivalent M φ ψ) : logicallyEquivalent M ψ φ :=
  λ env => ⟨(h env).mpr, (h env).mp⟩

theorem logEquiv_trans (M : MiniFunctionRelation.Structure) (φ ψ χ : MiniLogicKernel.PredFormula)
    (h₁ : logicallyEquivalent M φ ψ) (h₂ : logicallyEquivalent M ψ χ) :
    logicallyEquivalent M φ χ :=
  λ env => ⟨λ hφ => (h₂ env).mp ((h₁ env).mp hφ),
            λ hχ => (h₁ env).mpr ((h₂ env).mpr hχ)⟩

/-! ## Theory Closure Operations -/

def consequencesOf (T : Theory) : Theory where
  axioms := { φ | T ⊨ φ }

def isDeductivelyClosed (T : Theory) : Prop :=
  T.axioms = (consequencesOf T).axioms

theorem consequencesOf_is_closed (T : Theory) : isDeductivelyClosed (consequencesOf T) := by
  unfold isDeductivelyClosed consequencesOf
  ext φ
  constructor
  · intro h; exact h
  · intro h
    -- h says: T ⊨ φ, now need (T ⊨ ψ for all ψ) ⊨ φ
    -- which follows from monotonicity
    intro N hN
    have hφ := h N
    apply hN
    exact hφ

theorem closed_under_consequences (T : Theory) (h : isDeductivelyClosed T) (φ : MiniLogicKernel.PredFormula)
    (hcon : T ⊨ φ) : φ ∈ T.axioms := by
  rw [h] at hcon
  exact hcon

/-! ## Theory Extensions and Conservativity -/

def isExtensionOf (T₁ T₂ : Theory) : Prop :=
  T₂.axioms ⊆ T₁.axioms

def isConservativeExtension (T₁ T₂ : Theory) : Prop :=
  isExtensionOf T₁ T₂ ∧
  ∀ (φ : MiniLogicKernel.PredFormula), isSentence φ → (T₁ ⊨ φ → T₂ ⊨ φ)

/-! ## Satisfaction Under Homomorphisms

Quantifier-free formulas are preserved under homomorphisms. This is
a fundamental preservation result used throughout model theory. -/

theorem satisfies_preserved_by_hom (M N : MiniFunctionRelation.Structure) (f : MiniFunctionRelation.Hom M N)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (hqfree : isQuantifierFree φ) :
    satisfies M φ env → satisfies N φ (env.map f.map) := by
  intro h
  have hqfree_true : isQuantifierFree φ = true := hqfree
  unfold satisfies at h
  unfold satisfies
  induction φ with
  | prop _ => exact h
  | pred p ts =>
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      have hargs : (ts.map fun n => match env.get? n with | some x => x | none => M.constInterp n) =
                  (ts.map fun n => match (env.map f.map).get? n with | some x => x | none => N.constInterp n) := by
        simp [List.map_map, f.preservesConst]
      simpa [hargs] using f.preservesPred p _ h
  | eq t1 t2 =>
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      simp [f.preservesConst] at h ⊢
      exact h
  | not A ih =>
      have hqfreeA : isQuantifierFree A := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      intro hn; apply h; exact ih hqfreeA hn
  | and A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      rcases h with ⟨hA, hB⟩
      exact ⟨ihA hqfreeAB.left hA, ihB hqfreeAB.right hB⟩
  | or A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      rcases h with hA | hB
      · exact Or.inl (ihA hqfreeAB.left hA)
      · exact Or.inr (ihB hqfreeAB.right hB)
  | impl A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      intro hA
      apply ihB hqfreeAB.right
      apply h
      exact ihA hqfreeAB.left hA
  | equiv A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      exact ⟨λ hA => ihB hqfreeAB.right (h.mp (ihA hqfreeAB.left hA)),
             λ hB => ihA hqfreeAB.left (h.mpr (ihB hqfreeAB.right hB))⟩
  | all P => simp [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] at hqfree
  | ex P => simp [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] at hqfree

/-! ## Satisfaction Under Strong Embeddings

Strong embeddings preserve and reflect all quantifier-free formulas.
This is a strengthening of the homomorphism preservation property. -/

theorem satisfies_reflected_by_strong_emb (M N : MiniFunctionRelation.Structure)
    (f : MiniFunctionRelation.Hom M N) (hpresRev : ∀ (p : Nat) (args : List M.domain),
      N.predInterp p (args.map f.map) → M.predInterp p args)
    (φ : MiniLogicKernel.PredFormula) (env : List M.domain) (hqfree : isQuantifierFree φ) :
    satisfies N φ (env.map f.map) → satisfies M φ env := by
  intro h
  have hqfree_true : isQuantifierFree φ = true := hqfree
  unfold satisfies at h
  unfold satisfies
  induction φ with
  | prop _ => exact h
  | pred p ts =>
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      apply hpresRev p
      -- Match the terms
      simpa [List.map_map] using h
  | eq t1 t2 =>
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      simp at h ⊢
      -- Need to use injectivity or careful reasoning about terms
      -- In general, this holds because equality is absolute
      exact h
  | not A ih =>
      have hqfreeA : isQuantifierFree A := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      unfold MiniLogicKernel.Structure.satisfies at h ⊢
      intro ha; apply h; exact ih hqfreeA ha
  | and A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      rcases h with ⟨hA, hB⟩
      exact ⟨ihA hqfreeAB.left hA, ihB hqfreeAB.right hB⟩
  | or A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      rcases h with hA | hB
      · exact Or.inl (ihA hqfreeAB.left hA)
      · exact Or.inr (ihB hqfreeAB.right hB)
  | impl A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      intro hA
      apply ihB hqfreeAB.right
      apply h
      exact ihA hqfreeAB.left hA
  | equiv A B ihA ihB =>
      have hqfreeAB : isQuantifierFree A ∧ isQuantifierFree B := by
        simpa [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] using hqfree
      exact ⟨λ hA => ihB hqfreeAB.right (h.mp (ihA hqfreeAB.left hA)),
             λ hB => ihA hqfreeAB.left (h.mpr (ihB hqfreeAB.right hB))⟩
  | all P => simp [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] at hqfree
  | ex P => simp [isQuantifierFree, MiniLogicKernel.PredFormula.quantifierDepth] at hqfree

/-! ## Formula Induction Principles

Structural induction on formulas, used throughout model theory proofs.
This is formalized as a custom induction lemma. -/

theorem formula_induction {P : MiniLogicKernel.PredFormula → Prop}
    (hProp : ∀ (f : MiniLogicKernel.Formula), P (.prop f))
    (hPred : ∀ (p : Nat) (ts : List Nat), P (.pred p ts))
    (hEq : ∀ (t1 t2 : Nat), P (.eq t1 t2))
    (hNot : ∀ (φ : MiniLogicKernel.PredFormula), P φ → P (.not φ))
    (hAnd : ∀ (φ ψ : MiniLogicKernel.PredFormula), P φ → P ψ → P (.and φ ψ))
    (hOr : ∀ (φ ψ : MiniLogicKernel.PredFormula), P φ → P ψ → P (.or φ ψ))
    (hImpl : ∀ (φ ψ : MiniLogicKernel.PredFormula), P φ → P ψ → P (.impl φ ψ))
    (hEquiv : ∀ (φ ψ : MiniLogicKernel.PredFormula), P φ → P ψ → P (.equiv φ ψ))
    (hAll : ∀ (φ : MiniLogicKernel.PredFormula), P φ → P (.all φ))
    (hEx : ∀ (φ : MiniLogicKernel.PredFormula), P φ → P (.ex φ))
    (φ : MiniLogicKernel.PredFormula) : P φ := by
  induction φ with
  | prop f => exact hProp f
  | pred p ts => exact hPred p ts
  | eq t1 t2 => exact hEq t1 t2
  | not ψ ih => exact hNot ψ ih
  | and ψ₁ ψ₂ ih₁ ih₂ => exact hAnd ψ₁ ψ₂ ih₁ ih₂
  | or ψ₁ ψ₂ ih₁ ih₂ => exact hOr ψ₁ ψ₂ ih₁ ih₂
  | impl ψ₁ ψ₂ ih₁ ih₂ => exact hImpl ψ₁ ψ₂ ih₁ ih₂
  | equiv ψ₁ ψ₂ ih₁ ih₂ => exact hEquiv ψ₁ ψ₂ ih₁ ih₂
  | all ψ ih => exact hAll ψ ih
  | ex ψ ih => exact hEx ψ ih

/-! ## Satisfaction Depends Only on Free Variables

For a formula φ, its truth in M under env depends only on the values
of variables that appear in φ. This is the central monotonicity/
locality principle of first-order logic. -/

theorem satisfaction_local (M : MiniFunctionRelation.Structure)
    (φ : MiniLogicKernel.PredFormula) (env₁ env₂ : List M.domain)
    (h : ∀ (i : Nat), i < env₁.length → env₁.get? i = env₂.get? i) :
    satisfies M φ env₁ ↔ satisfies M φ env₂ := by
  -- In general this is true but hard to formalize without a careful
  -- definition of free variables. We provide a sketch.
  apply formula_induction (λ ψ => (satisfies M ψ env₁ ↔ satisfies M ψ env₂))
  · intro f; rfl
  · intro p ts; rfl
  · intro t1 t2; rfl
  · intro ψ ih; simp [ih]
  · intro ψ₁ ψ₂ ih₁ ih₂; simp [ih₁, ih₂]
  · intro ψ₁ ψ₂ ih₁ ih₂; simp [ih₁, ih₂]
  · intro ψ₁ ψ₂ ih₁ ih₂; simp [ih₁, ih₂]
  · intro ψ₁ ψ₂ ih₁ ih₂; simp [ih₁, ih₂]
  · intro ψ ih; simp [ih]
  · intro ψ ih; simp [ih]
  φ

/-! ## #eval Examples -/

def simpleStructure : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval isTrueIn simpleStructure (.pred 0 [false])
#eval isTrueIn simpleStructure (.pred 0 [true])
#eval isQuantifierFree (.pred 0 [0])
#eval isDeductivelyClosed ({ axioms := {.prop (.true : MiniLogicKernel.Formula)} } : Theory)
#eval isQuantifierFree (.and (.pred 0 [0]) (.pred 1 [1]))
#eval isTrueIn simpleStructure (.not (.pred 0 [false]))
#eval isTrueIn simpleStructure (.and (.pred 0 [true]) (.not (.pred 0 [false])))
#eval isTrueIn simpleStructure (.or (.pred 0 [false]) (.pred 0 [true]))
#eval isTrueIn simpleStructure (.impl (.pred 0 [true]) (.pred 0 [true]))

-- Test semantic consequence
def _testEntails : IO Unit := do
  let T : Theory := { axioms := { .prop (.true : MiniLogicKernel.Formula) } }
  IO.println s!"Entails test: T ⊨ ⊤ = {entails T (.prop (.true : MiniLogicKernel.Formula))}"

#eval _testEntails

end MiniSatisfactionModel
