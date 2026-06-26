import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Core.Syntax
import MiniFunctionRelation.Properties.PreservationTheorem

namespace MiniFunctionRelation

/-
# Definability in First-Order Structures

A set X ⊆ Mⁿ is definable if there exists a formula φ(v₁,...,vₙ)
such that X = {(a₁,...,aₙ) ∈ Mⁿ | M ⊨ φ[a₁,...,aₙ]}.
-/

/-! ## Definable sets -/

/-- A subset of the domain is definable (without parameters) if
    there is a formula φ(v) with one free variable that defines it. -/
def IsDefinable (M : Structure) (X : Set M.domain) : Prop :=
  ∃ (φ : Formula),
    -- φ has at most variable 0 free
    (Formula.freeVars φ ⊆ {0}) ∧
    -- X = {a | M ⊨ φ[a]}
    ∀ (a : M.domain), a ∈ X ↔
      M.satisfiesFormula (λ v => if v = 0 then a else M.constInterp 0) φ

/-- A binary relation R ⊆ M × M is definable if there is a formula φ(v₀,v₁)
    with two free variables defining it. -/
def IsBinaryDefinable (M : Structure) (R : M.domain → M.domain → Prop) : Prop :=
  ∃ (φ : Formula),
    (Formula.freeVars φ ⊆ {0, 1}) ∧
    ∀ (a b : M.domain), R a b ↔
      M.satisfiesFormula (λ v =>
        if v = 0 then a
        else if v = 1 then b
        else M.constInterp 0) φ

/-- A definable function f : M → M. -/
def IsFunctionDefinable (M : Structure) (f : M.domain → M.domain) : Prop :=
  ∃ (φ : Formula),
    (Formula.freeVars φ ⊆ {0, 1}) ∧
    (∀ (a : M.domain), ∃! (b : M.domain),
      M.satisfiesFormula (λ v =>
        if v = 0 then a
        else if v = 1 then b
        else M.constInterp 0) φ) ∧
    ∀ (a : M.domain),
      M.satisfiesFormula (λ v =>
        if v = 0 then a
        else if v = 1 then f a
        else M.constInterp 0) φ

/-! ## Definability with parameters -/

/-- A set is A-definable (definable with parameters from A ⊆ M). -/
def IsDefinableWithParams (M : Structure) (A : Set M.domain) (X : Set M.domain) : Prop :=
  ∃ (φ : Formula) (params : List M.domain),
    (∀ p ∈ params, p ∈ A) ∧
    (Formula.freeVars φ ⊆ {0}) ∧
    ∀ (a : M.domain), a ∈ X ↔
      M.satisfiesFormula (λ v => if v = 0 then a else M.constInterp 0) φ

/-- A structure with the property that every definable set is either finite or cofinite
    is called "minimal" (strongly minimal if true in all elementary extensions). -/
def IsMinimal (M : Structure) : Prop :=
  ∀ (X : Set M.domain), IsDefinable M X →
    (Set.Finite X) ∨ (Set.Finite (Set.univ \ X))

/-! ## Quantifier elimination (structural) -/

/-- A theory T admits quantifier elimination if every formula is T-equivalent
    to a quantifier-free formula. -/
def Theory.admitsQE (T : Theory) : Prop :=
  ∀ (φ : Formula), ∃ (ψ : Formula),
    (QuantifierFree ψ) ∧
    (∀ (M : Structure), Structure.satisfiesTheory M T →
      ∀ (σ : Assignment M),
        M.satisfiesFormula σ φ ↔ M.satisfiesFormula σ ψ)

/-! ## Examples of definable sets -/

def natStruct : Structure where
  domain := Nat
  predInterp 0 args := match args with
    | [x, y] => x < y
    | _ => False
  predInterp _ _ := False
  constInterp 0 := 0
  constInterp _ := 0

/-- The set {0} is definable in (ℕ, <, 0) via the formula ¬∃y (y < x). -/
def zeroFormula : Formula :=
  Formula.not (Formula.ex 1 (Formula.pred 0 [Term.var 1, Term.var 0]))

theorem zero_is_definable_in_nat : IsDefinable natStruct {x | x = 0} := by
  refine ⟨zeroFormula, ?_, ?_⟩
  · simp [zeroFormula, Formula.freeVars, Term.freeVars]
  · intro a; simp [zeroFormula, Formula.ex, Formula.not, natStruct, Structure.satisfiesFormula,
      Term.eval, Set.mem_setOf_eq]
    constructor
    · intro h_eq; subst h_eq; intro y; exact Nat.not_lt_zero _
    · intro h; by_contra! hpos
      have hlt : 0 < a := Nat.pos_of_ne_zero hpos
      exact h 0 hlt

/-- The order relation < is definable in (ℕ, <, 0) by the formula pred(0; x, y). -/
def orderFormula : Formula := Formula.pred 0 [Term.var 0, Term.var 1]

theorem order_is_definable_in_nat : IsBinaryDefinable natStruct (λ x y => x < y) := by
  refine ⟨orderFormula, ?_, ?_⟩
  · simp [orderFormula, Formula.freeVars, Term.freeVars]
  · intro a b; simp [orderFormula, natStruct, Structure.satisfiesFormula, Term.eval]

/-! ## The graph of a definable function -/

def succFormula : Formula :=
  Formula.and
    (Formula.pred 0 [Term.var 0, Term.var 1])
    (Formula.not (Formula.ex 2
      (Formula.and
        (Formula.pred 0 [Term.var 0, Term.var 2])
        (Formula.pred 0 [Term.var 2, Term.var 1]))))

theorem succ_definable_in_nat : IsFunctionDefinable natStruct (λ x => x + 1) := by
  refine ⟨succFormula, ?_, ?_, ?_⟩
  · simp [succFormula, Formula.freeVars, Term.freeVars, Formula.and, Formula.not, Formula.ex]
  · intro a
    refine ⟨a + 1, ?_, ?_⟩
    · simp [succFormula, Formula.and, Formula.not, Formula.ex, natStruct,
        Structure.satisfiesFormula, Term.eval]
      constructor
      · exact Nat.lt_succ_self a
      · intro z hz
        have hlt1 : a < z := hz.1
        have hlt2 : z < a + 1 := hz.2
        have : z ≤ a := Nat.le_of_lt_succ hlt2
        linarith
    · intro b hb
      have hb_lt : a < b := by
        -- extract from hb
        simp [succFormula, Formula.and, natStruct, Structure.satisfiesFormula, Term.eval] at hb
        exact hb.1
      have hb_min : b ≤ a + 1 := by
        simp [succFormula, Formula.and, natStruct, Structure.satisfiesFormula, Term.eval] at hb
        by_contra! h_gt
        have h_mid : a < a + 1 := Nat.lt_succ_self a
        have h_mid_lt_b : a + 1 < b := h_gt
        apply hb.2 (a + 1)
        exact ⟨h_mid, h_mid_lt_b⟩
      apply Nat.le_antisymm hb_min (Nat.succ_le_of_lt hb_lt)
  · intro a
    simp [succFormula, Formula.and, natStruct, Structure.satisfiesFormula, Term.eval]
    constructor
    · exact Nat.lt_succ_self a
    · intro z hz
      have h_sum : a + 1 ≤ z := Nat.succ_le_of_lt hz.1
      have h_lt_succ : z < a + 1 := hz.2
      linarith

#eval "Definability.lean loaded — IsDefinable, IsBinaryDefinable, IsFunctionDefinable"
#eval "  Example: {0} definable in (ℕ, <)"
#eval "  Example: < definable in (ℕ, <)"
#eval "  Example: successor function definable in (ℕ, <)"

end MiniFunctionRelation
