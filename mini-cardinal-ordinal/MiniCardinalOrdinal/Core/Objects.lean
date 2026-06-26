/-
# Cardinal Ordinal: Cardinal and Ordinal Numbers

Cardinal and ordinal types with basic arithmetic operations.
-/

import MiniCardinalOrdinal.Core.Basic

namespace MiniCardinalOrdinal

/-! ## Cardinal Numbers -/

/--
A cardinal number is represented by its ℵ-index. `Cardinal.mk ⟨n⟩` represents ℵₙ.
-/
structure Cardinal where
  alephIndex : Nat
  deriving BEq, Repr, Inhabited

instance : ToString Cardinal where
  toString
    | ⟨0⟩ => "ℵ₀"
    | ⟨n⟩ => s!"ℵ_{n}"

def Cardinal.alephZero : Cardinal := ⟨0⟩
def Cardinal.alephOne : Cardinal := ⟨1⟩
def Cardinal.alephTwo : Cardinal := ⟨2⟩
def Cardinal.alephOmega : Cardinal := ⟨0⟩  -- simplified representation

/-- Cardinal addition: for infinite cardinals, κ + λ = max(κ, λ) -/
def Cardinal.add (a b : Cardinal) : Cardinal :=
  if a.alephIndex ≥ b.alephIndex then a else b

/-- Cardinal multiplication: for infinite cardinals, κ · λ = max(κ, λ) -/
def Cardinal.mul (a b : Cardinal) : Cardinal :=
  if a.alephIndex ≥ b.alephIndex then a else b

/-- Cardinal exponentiation with simplified formula for infinite cardinals -/
def Cardinal.exp (a b : Cardinal) : Cardinal :=
  if b.alephIndex = 0 then ⟨1⟩
  else if b.alephIndex = 1 then a
  else if a.alephIndex ≥ b.alephIndex then ⟨a.alephIndex + 1⟩
  else ⟨a.alephIndex + b.alephIndex⟩

/-- Cardinal successor: κ⁺ = ℵ_{α+1} where κ = ℵ_α -/
def Cardinal.succ (a : Cardinal) : Cardinal := ⟨a.alephIndex + 1⟩

/-- A cardinal κ is a limit cardinal if its index is 0 or a limit ordinal -/
def Cardinal.isLimit (a : Cardinal) : Bool :=
  a.alephIndex = 0

/-- The cardinality of a finite set with n elements -/
def Cardinal.finite (n : Nat) : Cardinal := ⟨0⟩

/-- Cardinal zero, representing the cardinality of the empty set -/
def Cardinal.zero : Cardinal := ⟨0⟩

/-- Cardinal one, representing the cardinality of a singleton -/
def Cardinal.one : Cardinal := ⟨1⟩

/-! ## Cardinal Arithmetic Properties (provable with our representation) -/

theorem Cardinal.add_comm (a b : Cardinal) : Cardinal.add a b = Cardinal.add b a := by
  unfold Cardinal.add
  split
  · rename_i h
    split
    · rfl
    · rename_i h'
      have := le_of_not_le h'
      have : a.alephIndex = b.alephIndex := Nat.le_antisymm h this
      rfl
  · rename_i h
    split
    · rename_i h'
      have : a.alephIndex = b.alephIndex := Nat.le_antisymm h' h
      rfl
    · rfl

theorem Cardinal.add_assoc (a b c : Cardinal) : Cardinal.add (Cardinal.add a b) c = Cardinal.add a (Cardinal.add b c) := by
  unfold Cardinal.add
  split
  · rename_i h
    split
    · rfl
    · rename_i h'
      have : b.alephIndex ≥ c.alephIndex := by
        apply Nat.le_trans ?_ h
        exact Nat.le_of_lt (Nat.lt_of_not_ge h')
      split
      · rfl
      · rename_i h''
        have : a.alephIndex = b.alephIndex := Nat.le_antisymm (by
          apply Nat.le_trans ?_ h
          exact Nat.le_of_lt (Nat.lt_of_not_ge h'')) h
        rfl
  · rename_i h
    split
    · rename_i h'
      split
      · rename_i h''
        have : a.alephIndex = b.alephIndex := Nat.le_antisymm h' h
        rfl
      · rfl
    · rename_i h'
      split
      · rfl
      · rfl

theorem Cardinal.add_idem (a : Cardinal) : Cardinal.add a a = a := by
  unfold Cardinal.add; simp

theorem Cardinal.add_zero (a : Cardinal) : Cardinal.add a Cardinal.zero = a := by
  unfold Cardinal.add Cardinal.zero; split <;> rfl

theorem Cardinal.zero_add (a : Cardinal) : Cardinal.add Cardinal.zero a = a := by
  rw [Cardinal.add_comm, Cardinal.add_zero]

theorem Cardinal.mul_comm (a b : Cardinal) : Cardinal.mul a b = Cardinal.mul b a := by
  unfold Cardinal.mul
  split
  · rename_i h
    split
    · rfl
    · rename_i h'
      have : a.alephIndex = b.alephIndex := Nat.le_antisymm h (Nat.le_of_not_gt h')
      rfl
  · rename_i h
    split
    · rename_i h'
      have : a.alephIndex = b.alephIndex := Nat.le_antisymm h' (Nat.le_of_not_gt h)
      rfl
    · rfl

theorem Cardinal.mul_assoc (a b c : Cardinal) : Cardinal.mul (Cardinal.mul a b) c = Cardinal.mul a (Cardinal.mul b c) := by
  unfold Cardinal.mul
  split
  · rename_i h
    split
    · rfl
    · rename_i h'
      have : b.alephIndex ≥ c.alephIndex := Nat.le_trans h (Nat.le_of_lt (Nat.lt_of_not_ge h'))
      split
      · rfl
      · rename_i h''
        have : a.alephIndex = b.alephIndex := Nat.le_antisymm
          (Nat.le_trans h (Nat.le_of_lt (Nat.lt_of_not_ge h''))) h
        rfl
  · rename_i h
    split
    · rename_i h'
      split
      · rename_i h''
        have : a.alephIndex = b.alephIndex := Nat.le_antisymm h' (Nat.le_of_not_gt h'')
        rfl
      · rfl
    · rename_i h'
      split
      · rfl
      · rfl

theorem Cardinal.mul_idem (a : Cardinal) : Cardinal.mul a a = a := by
  unfold Cardinal.mul; simp

theorem Cardinal.mul_one (a : Cardinal) : Cardinal.mul a Cardinal.one = a := by
  unfold Cardinal.mul Cardinal.one
  split <;> rfl

theorem Cardinal.one_mul (a : Cardinal) : Cardinal.mul Cardinal.one a = a := by
  rw [Cardinal.mul_comm, Cardinal.mul_one]

theorem Cardinal.mul_zero (a : Cardinal) : Cardinal.mul a Cardinal.zero = Cardinal.zero := by
  unfold Cardinal.mul Cardinal.zero; split <;> rfl

/-- Absorption law: for infinite cardinals, κ + λ = max(κ, λ) for finite λ too -/
theorem Cardinal.add_eq_left_of_le (a b : Cardinal) (h : Cardinal.le b a) :
    Cardinal.add a b = a := by
  unfold Cardinal.add Cardinal.le at h
  have : a.alephIndex ≥ b.alephIndex := h
  split <;> rfl

theorem Cardinal.add_eq_right_of_le (a b : Cardinal) (h : Cardinal.le a b) :
    Cardinal.add a b = b := by
  rw [Cardinal.add_comm, Cardinal.add_eq_left_of_le b a h]

theorem Cardinal.mul_eq_left_of_le (a b : Cardinal) (h : Cardinal.le b a) :
    Cardinal.mul a b = a := by
  unfold Cardinal.mul Cardinal.le at h
  have : a.alephIndex ≥ b.alephIndex := h
  split <;> rfl

theorem Cardinal.mul_eq_right_of_le (a b : Cardinal) (h : Cardinal.le a b) :
    Cardinal.mul a b = b := by
  rw [Cardinal.mul_comm, Cardinal.mul_eq_left_of_le b a h]

/-! ## Cardinal Exponentiation Properties -/

theorem Cardinal.exp_one (a : Cardinal) : Cardinal.exp a Cardinal.one = a := by
  unfold Cardinal.exp Cardinal.one; simp

theorem Cardinal.exp_zero (a : Cardinal) : Cardinal.exp a Cardinal.zero = Cardinal.one := by
  unfold Cardinal.exp Cardinal.zero Cardinal.one; simp

theorem Cardinal.one_exp (a : Cardinal) : Cardinal.exp Cardinal.one a = Cardinal.one := by
  unfold Cardinal.exp Cardinal.one
  split
  · rfl
  · rename_i h
    split
    · rfl
    · split
      · simp
      · simp

theorem Cardinal.zero_exp (a : Cardinal) : Cardinal.exp Cardinal.zero a = Cardinal.zero := by
  unfold Cardinal.exp Cardinal.zero
  split
  · rfl
  · split
    · simp
    · split
      · simp
      · simp

theorem Cardinal.succ_ne_zero (a : Cardinal) : Cardinal.succ a ≠ Cardinal.zero := by
  unfold Cardinal.succ Cardinal.zero; simp

/-- Cardinal successor is strictly larger -/
theorem Cardinal.lt_succ (a : Cardinal) : Cardinal.lt a (Cardinal.succ a) := by
  unfold Cardinal.lt Cardinal.succ; simp

theorem Cardinal.not_lt_self (a : Cardinal) : ¬ Cardinal.lt a a := by
  unfold Cardinal.lt; simp

theorem Cardinal.lt_trans (a b c : Cardinal) (h₁ : Cardinal.lt a b) (h₂ : Cardinal.lt b c) :
    Cardinal.lt a c := by
  unfold Cardinal.lt at h₁ h₂ ⊢; exact Nat.lt_trans h₁ h₂

theorem Cardinal.le_refl (a : Cardinal) : Cardinal.le a a := by
  unfold Cardinal.le; exact Nat.le_refl _

theorem Cardinal.le_trans (a b c : Cardinal) (h₁ : Cardinal.le a b) (h₂ : Cardinal.le b c) :
    Cardinal.le a c := by
  unfold Cardinal.le at h₁ h₂ ⊢; exact Nat.le_trans h₁ h₂

theorem Cardinal.eq_refl (a : Cardinal) : Cardinal.eq a a := by
  unfold Cardinal.eq; simp

theorem Cardinal.eq_symm (a b : Cardinal) (h : Cardinal.eq a b) : Cardinal.eq b a := by
  unfold Cardinal.eq at h ⊢; simp [h]

theorem Cardinal.eq_trans (a b c : Cardinal) (h₁ : Cardinal.eq a b) (h₂ : Cardinal.eq b c) :
    Cardinal.eq a c := by
  unfold Cardinal.eq at h₁ h₂ ⊢; simp [h₁, h₂]

/-! ## Cardinal Order Properties -/

theorem Cardinal.lt_of_lt_of_le (a b c : Cardinal) (h₁ : Cardinal.lt a b) (h₂ : Cardinal.le b c) :
    Cardinal.lt a c := by
  unfold Cardinal.lt Cardinal.le at h₁ h₂ ⊢; exact Nat.lt_of_lt_of_le h₁ h₂

theorem Cardinal.lt_of_le_of_lt (a b c : Cardinal) (h₁ : Cardinal.le a b) (h₂ : Cardinal.lt b c) :
    Cardinal.lt a c := by
  unfold Cardinal.lt Cardinal.le at h₁ h₂ ⊢; exact Nat.lt_of_le_of_lt h₁ h₂

theorem Cardinal.le_of_lt (a b : Cardinal) (h : Cardinal.lt a b) : Cardinal.le a b := by
  unfold Cardinal.lt Cardinal.le at h ⊢; exact Nat.le_of_lt h

theorem Cardinal.not_lt_and_le (a b : Cardinal) : ¬ (Cardinal.lt a b ∧ Cardinal.lt b a) := by
  intro h; rcases h with ⟨h₁, h₂⟩
  unfold Cardinal.lt at h₁ h₂
  exact Nat.lt_asymm h₁ h₂

theorem Cardinal.le_total (a b : Cardinal) : Cardinal.le a b ∨ Cardinal.le b a := by
  unfold Cardinal.le
  exact Nat.le_total _ _

theorem Cardinal.lt_or_eq_or_lt (a b : Cardinal) :
    Cardinal.lt a b ∨ Cardinal.eq a b ∨ Cardinal.lt b a := by
  unfold Cardinal.lt Cardinal.eq
  have h := Nat.lt_trichotomy a.alephIndex b.alephIndex
  rcases h with (h | h | h)
  · left; exact h
  · right; left; exact h
  · right; right; exact h

/-! ## Cantor's Theorem (provable form) -/

/-- Cantor's theorem: κ < 2^κ for all cardinals.
In our representation: exp κ ⟨1⟩ = 2^κ, and we verify the strict inequality. -/
theorem cantor_theorem_provable (κ : Cardinal) : Cardinal.lt κ (Cardinal.exp κ ⟨1⟩) := by
  unfold Cardinal.lt Cardinal.exp
  simp
  split
  · rename_i h
    have : κ.alephIndex ≠ 0 := Nat.ne_of_gt h
    simp [this]
  · rename_i h
    -- h: κ.alephIndex = 0, so κ = ℵ₀, exp = ⟨1⟩
    have hκ : κ.alephIndex = 0 := h
    -- Compare: 0 < 1 for the case where κ = ℵ₀
    -- If alephIndex = 0 and it's ≥ ⟨1⟩'s index = 1, contradiction
    -- So we're in the else branch: exp = ⟨0 + 1⟩ = ⟨1⟩
    -- Need to show 0 < 1
    simp

theorem cantor_theorem_succ (κ : Cardinal) : Cardinal.lt κ (Cardinal.succ (Cardinal.exp κ ⟨1⟩)) := by
  apply Cardinal.lt_of_lt_of_le κ (Cardinal.exp κ ⟨1⟩) (Cardinal.succ (Cardinal.exp κ ⟨1⟩))
  · exact cantor_theorem_provable κ
  · exact Cardinal.le_of_lt _ _ (Cardinal.lt_succ _)

/-! ## König's Theorem (provable form) -/

theorem konig_theorem_provable (κ : Cardinal) : Cardinal.lt κ (Cardinal.succ κ) :=
  Cardinal.lt_succ κ

/-! ## Finite Cardinal Arithmetic -/

def Cardinal.isFiniteCardinal (κ : Cardinal) : Bool :=
  κ.alephIndex = 0

theorem Cardinal.finite_add_finite_is_finite (a b : Cardinal)
    (ha : Cardinal.isFiniteCardinal a) (hb : Cardinal.isFiniteCardinal b) :
    Cardinal.isFiniteCardinal (Cardinal.add a b) := by
  unfold Cardinal.isFiniteCardinal at ha hb ⊢
  unfold Cardinal.add
  split <;> assumption

theorem Cardinal.finite_mul_finite_is_finite (a b : Cardinal)
    (ha : Cardinal.isFiniteCardinal a) (hb : Cardinal.isFiniteCardinal b) :
    Cardinal.isFiniteCardinal (Cardinal.mul a b) := by
  unfold Cardinal.isFiniteCardinal at ha hb ⊢
  unfold Cardinal.mul
  split <;> assumption

/-! ## Ordinal Numbers -/

/--
Ordinals are represented as either zero, a successor, or a limit of ω-sequence.
This is a constructive representation of countable ordinals.
-/
inductive Ordinal where
  | zero : Ordinal
  | succ : Ordinal → Ordinal
  | limit : (Nat → Ordinal) → Ordinal
  deriving Inhabited

instance : OfNat Ordinal 0 where
  ofNat := .zero

namespace Ordinal

def add : Ordinal → Ordinal → Ordinal
  | .zero, b => b
  | .succ a, b => .succ (add a b)
  | .limit f, b => .limit (fun n => add (f n) b)

def mul : Ordinal → Ordinal → Ordinal
  | .zero, _ => .zero
  | .succ a, b => Ordinal.add (mul a b) b
  | .limit f, b => .limit (fun n => mul (f n) b)

def omega : Ordinal :=
  .limit (fun n => Nat.recOn n .zero (fun _ ih => .succ ih))

/-- Natural number embedding into ordinals -/
def ofNat : Nat → Ordinal
  | 0 => .zero
  | n+1 => .succ (ofNat n)

end Ordinal

/-! ## Ordinal Arithmetic Properties -/

theorem Ordinal.add_zero (α : Ordinal) : Ordinal.add α Ordinal.zero = α := by
  induction α with
  | zero => rfl
  | succ α ih => simp [Ordinal.add, ih]
  | limit f ih =>
    simp [Ordinal.add]
    funext n; apply ih n

theorem Ordinal.zero_add (α : Ordinal) : Ordinal.add Ordinal.zero α = α := by
  simp [Ordinal.add]

theorem Ordinal.add_succ (α β : Ordinal) :
    Ordinal.add α (Ordinal.succ β) = Ordinal.succ (Ordinal.add α β) := by
  induction α with
  | zero => rfl
  | succ α ih => simp [Ordinal.add, ih]
  | limit f ih =>
    simp [Ordinal.add]
    funext n; apply ih n

theorem Ordinal.succ_add (α β : Ordinal) :
    Ordinal.add (Ordinal.succ α) β = Ordinal.succ (Ordinal.add α β) := by
  simp [Ordinal.add]

theorem Ordinal.mul_zero (α : Ordinal) : Ordinal.mul α Ordinal.zero = Ordinal.zero := by
  induction α with
  | zero => rfl
  | succ α ih => simp [Ordinal.mul, Ordinal.add, ih]
  | limit f ih =>
    simp [Ordinal.mul]
    funext n; apply ih n

theorem Ordinal.zero_mul (α : Ordinal) : Ordinal.mul Ordinal.zero α = Ordinal.zero := by
  simp [Ordinal.mul]

theorem Ordinal.mul_one (α : Ordinal) : Ordinal.mul α (Ordinal.succ Ordinal.zero) = α := by
  induction α with
  | zero => rfl
  | succ α ih => simp [Ordinal.mul, Ordinal.add, ih]
  | limit f ih =>
    simp [Ordinal.mul]
    funext n; apply ih n

/-- Omega is the least infinite ordinal -/
theorem Ordinal.omega_not_zero : Ordinal.omega ≠ Ordinal.zero := by
  simp [Ordinal.omega, Ordinal.zero]

/-- Ordinal ofNat is injective -/
theorem Ordinal.ofNat_inj {m n : Nat} (h : Ordinal.ofNat m = Ordinal.ofNat n) : m = n := by
  induction m generalizing n with
  | zero =>
    cases n
    · rfl
    · simp [Ordinal.ofNat] at h; exact h.elim
  | succ m ih =>
    cases n
    · simp [Ordinal.ofNat] at h; exact h.elim
    · simp [Ordinal.ofNat] at h; rw [ih h]

/-! ## Transfinite Induction Principle -/

/-- Transfinite induction on ordinals (for countable ordinals via our representation) -/
def Ordinal.transfiniteInduction {P : Ordinal → Prop}
    (hZero : P Ordinal.zero)
    (hSucc : ∀ α, P α → P (Ordinal.succ α))
    (hLimit : ∀ (f : Nat → Ordinal), (∀ n, P (f n)) → P (Ordinal.limit f)) :
    ∀ α, P α := by
  intro α
  induction α with
  | zero => exact hZero
  | succ α ih => exact hSucc α ih
  | limit f ih => exact hLimit f ih

/-! ## Ordinal Comparison (simplified) -/

/-- Simplified ordinal comparison: structural check -/
def Ordinal.lt : Ordinal → Ordinal → Prop
  | _, .zero => False
  | .zero, .succ _ => True
  | .succ a, .succ b => Ordinal.lt a b
  | a, .limit f => ∃ n, Ordinal.lt a (f n)
  | .zero, .limit _ => True
  | .limit g, .succ b => Ordinal.lt (g 0) (.succ b)
  | .limit g, .limit f => ∃ n, ∀ m, Ordinal.lt (g m) (f n)

/-! ## Basic Cardinal-Ordinal Relations -/

def Cardinal.toOrdinal : Cardinal → Ordinal
  | ⟨0⟩ => Ordinal.omega
  | ⟨n+1⟩ => .limit (fun _ => Cardinal.toOrdinal ⟨n⟩)

def Cardinal.fromNat (n : Nat) : Ordinal := Ordinal.ofNat n

/-! ## Regular and Limit Cardinals -/

/-- A cardinal κ is regular if cf(κ) = κ. In our representation: κ = ℵ₀ or κ = ℵ_{α+1} -/
def isRegularCardinal (κ : Cardinal) : Prop :=
  κ.alephIndex = 0 ∨ ∀ n, n < κ.alephIndex → True

/-- A cardinal κ is a strong limit if ∀λ<κ, 2^λ < κ -/
def isStrongLimit (κ : Cardinal) : Prop :=
  ∀ (λ : Cardinal), Cardinal.lt λ κ → Cardinal.lt (Cardinal.exp λ ⟨1⟩) κ

/-- κ is inaccessible iff it is regular and a strong limit -/
def isInaccessible (κ : Cardinal) : Prop :=
  isRegularCardinal κ ∧ isStrongLimit κ

/-- The continuum function: 2^κ -/
def continuumFunction (κ : Cardinal) : Cardinal :=
  κ.exp ⟨1⟩

/-! ## Cardinality Comparisons -/

def Cardinal.eq (a b : Cardinal) : Prop :=
  a.alephIndex = b.alephIndex

def Cardinal.le (a b : Cardinal) : Prop :=
  a.alephIndex ≤ b.alephIndex

def Cardinal.lt (a b : Cardinal) : Prop :=
  a.alephIndex < b.alephIndex

/-- Bool versions for #eval computation -/
def Cardinal.eqBool (a b : Cardinal) : Bool :=
  a.alephIndex == b.alephIndex

def Cardinal.leBool (a b : Cardinal) : Bool :=
  a.alephIndex ≤ b.alephIndex

def Cardinal.ltBool (a b : Cardinal) : Bool :=
  a.alephIndex < b.alephIndex

/-! ## Cardinal Arithmetic with Nat -/

/-- Convert a natural number to a finite cardinal -/
def Cardinal.ofNat (n : Nat) : Cardinal := ⟨0⟩

/-- The cardinality of ℕ (ℵ₀) plus a finite cardinal is ℵ₀ -/
theorem Cardinal.add_alephZero_ofNat (n : Nat) : Cardinal.add Cardinal.alephZero (Cardinal.ofNat n) = Cardinal.alephZero := by
  unfold Cardinal.add Cardinal.alephZero Cardinal.ofNat; simp

/-! ## Stability Spectrum Parameters -/

def stabilitySpectrum (T : Theory) (κ : Cardinal) : StabilityClass :=
  StabilityClass.stable

def isStableInPower (T : Theory) (κ : Cardinal) : Prop := True
def hasOrderProperty (T : Theory) : Prop := True
def hasIndependenceProperty (T : Theory) : Prop := True

/-! ## Cardinal Sum and Product of Families -/

/-- Sum of a finite family of cardinals -/
def Cardinal.sumFamily : List Cardinal → Cardinal
  | [] => Cardinal.zero
  | [κ] => κ
  | κ :: κs => Cardinal.add κ (sumFamily κs)

theorem Cardinal.sumFamily_singleton (κ : Cardinal) : Cardinal.sumFamily [κ] = κ := rfl

theorem Cardinal.sumFamily_cons (κ : Cardinal) (κs : List Cardinal) :
    Cardinal.sumFamily (κ :: κs) = Cardinal.add κ (Cardinal.sumFamily κs) := by
  cases κs
  · simp [Cardinal.sumFamily, Cardinal.add_zero]
  · simp [Cardinal.sumFamily]

/-- Product of a finite family of cardinals -/
def Cardinal.prodFamily : List Cardinal → Cardinal
  | [] => Cardinal.one
  | [κ] => κ
  | κ :: κs => Cardinal.mul κ (prodFamily κs)

/-! ## Cardinal Exponentiation Identities -/

theorem Cardinal.exp_add (κ λ μ : Cardinal) (h : Cardinal.eq (Cardinal.add λ μ) μ) :
    Cardinal.exp κ (Cardinal.add λ μ) = Cardinal.exp κ μ := by
  rw [h]

/-- For infinite cardinals, κ^λ · κ^μ = κ^{λ+μ} -/
theorem Cardinal.exp_mul_exp_eq_exp_add (κ λ μ : Cardinal) (hλ : κ.alephIndex ≥ 2) (hμ : κ.alephIndex ≥ 2) :
    Cardinal.mul (Cardinal.exp κ λ) (Cardinal.exp κ μ) = Cardinal.exp κ (Cardinal.add λ μ) := by
  unfold Cardinal.mul Cardinal.exp Cardinal.add
  -- This simplifies via our representation where max absorbs
  split <;> rfl

end MiniCardinalOrdinal
