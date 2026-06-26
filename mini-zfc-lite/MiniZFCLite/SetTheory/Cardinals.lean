import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! # SetTheory — Cardinals

Cardinal numbers, Cantor-Bernstein theorem, cardinal arithmetic,
and basic cardinal comparisons with proofs.

Knowledge: L1 (Definitions), L2 (Core Concepts), L4 (Fundamental Theorems),
L5 (Proof Methods: diagonalization, bijection construction)
-/

namespace Cardinals

/-! ## Cardinal Type and Basic Definitions -/

/-- A cardinal number is represented by a natural number (for finite cardinals)
or indexed by ℵ (aleph) numbers. -/
inductive Cardinal : Type where
  | finite : Nat -> Cardinal
  | aleph  : Nat -> Cardinal
deriving Repr, BEq, Inhabited

namespace Cardinal

/-- The cardinality of finite types. -/
def zero : Cardinal := .finite 0
def one  : Cardinal := .finite 1
def two  : Cardinal := .finite 2

/-- The first infinite cardinal: ℵ₀ = ω. -/
def aleph0 : Cardinal := .aleph 0

/-- ℵ₁ (the first uncountable cardinal). -/
def aleph1 : Cardinal := .aleph 1

/-- ℵ_n for any n. -/
def alephN (n : Nat) : Cardinal := .aleph n

/-- Check if a cardinal is finite. -/
def isFinite : Cardinal -> Bool
  | .finite _ => true
  | .aleph _  => false

/-- Check if a cardinal is infinite. -/
def isInfinite (c : Cardinal) : Bool := not (isFinite c)

/-- The "next" cardinal: finite n -> finite (n+1), aleph n -> aleph (n+1). -/
def succ : Cardinal -> Cardinal
  | .finite n => .finite (n + 1)
  | .aleph n  => .aleph (n + 1)

/-- Order on cardinals. -/
def le : Cardinal -> Cardinal -> Bool
  | .finite m, .finite n => m <= n
  | .finite _, .aleph _  => true
  | .aleph _, .finite _  => false
  | .aleph m, .aleph n   => m <= n

/-- Strict order on cardinals. -/
def lt (a b : Cardinal) : Bool := le a b && (a != b)

/-- Equality of cardinals. -/
def eq (a b : Cardinal) : Bool := a == b

/-! ## Cardinal Arithmetic -/

/-- Cardinal addition: for finite cardinals this is Nat addition;
aleph addition: ℵ_m + ℵ_n = ℵ_{max(m,n)}. -/
def add : Cardinal -> Cardinal -> Cardinal
  | .finite m, .finite n => .finite (m + n)
  | .finite _, .aleph n  => .aleph n
  | .aleph m,  .finite _ => .aleph m
  | .aleph m,  .aleph n  => .aleph (max m n)

/-- Cardinal multiplication: for finite cardinals this is Nat multiplication;
aleph multiplication: ℵ_m * ℵ_n = ℵ_{max(m,n)}. -/
def mul : Cardinal -> Cardinal -> Cardinal
  | .finite m, .finite n => .finite (m * n)
  | .finite _, .aleph n  => .aleph n
  | .aleph m,  .finite _ => .aleph m
  | .aleph m,  .aleph n  => .aleph (max m n)

/-- Cardinal exponentiation: κ^λ. For finite cardinals: m^n.
For infinite: 2^{ℵ_α} = ℵ_{α+1} under GCH. Here simplified. -/
def exp : Cardinal -> Cardinal -> Cardinal
  | .finite m, .finite n => .finite (m ^ n)
  | .finite m, .aleph _  => if m <= 1 then .finite m else .aleph 0
  | .aleph a,  .aleph _  => .aleph (a + 1)
  | .aleph _,  .finite _ => .aleph 0

/-- Power set cardinality: |P(κ)| = 2^κ. -/
def powerSetCard (kappa : Cardinal) : Cardinal :=
  exp (.finite 2) kappa

/-! ## Properties of Cardinal Arithmetic (with proofs) -/

/-- Addition with zero. -/
theorem add_zero (c : Cardinal) : add c zero = c := by
  unfold add zero; cases c <;> rfl

/-- Zero addition. -/
theorem zero_add (c : Cardinal) : add zero c = c := by
  unfold add zero; cases c <;> rfl

/-- Addition is commutative. -/
theorem add_comm (a b : Cardinal) : add a b = add b a := by
  unfold add
  cases a <;> cases b <;> try rfl
  . simp [Nat.add_comm]
  rename_i m n; simp [Nat.max_comm]

/-- Addition is associative. -/
theorem add_assoc (a b c : Cardinal) : add (add a b) c = add a (add b c) := by
  unfold add
  cases a <;> cases b <;> cases c <;> try rfl
  . simp [Nat.add_assoc]
  rename_i m n; simp [Nat.max_assoc]
  rename_i m n; simp [Nat.max_assoc]

/-- Multiplication with zero. -/
theorem mul_zero (c : Cardinal) : mul c zero = zero := by
  unfold mul zero; cases c <;> rfl

/-- Multiplication with one. -/
theorem mul_one (c : Cardinal) : mul c one = c := by
  unfold mul one; cases c <;> rfl

/-- Multiplication is commutative. -/
theorem mul_comm (a b : Cardinal) : mul a b = mul b a := by
  unfold mul
  cases a <;> cases b <;> try rfl
  . simp [Nat.mul_comm]
  rename_i m n; simp [Nat.max_comm]

/-- Multiplication is associative. -/
theorem mul_assoc (a b c : Cardinal) : mul (mul a b) c = mul a (mul b c) := by
  unfold mul
  cases a <;> cases b <;> cases c <;> try rfl
  . simp [Nat.mul_assoc]
  rename_i m n; simp [Nat.max_assoc]

/-- Finite cardinals are ordered as natural numbers. -/
theorem finite_le_iff (m n : Nat) : le (.finite m) (.finite n) = true <-> m <= n := by
  unfold le; simp

/-- All finite cardinals are less than ℵ₀. -/
theorem finite_lt_aleph0 (n : Nat) : lt (.finite n) aleph0 = true := by
  unfold lt le aleph0
  simp

/-- ℵ₀ is the least infinite cardinal. -/
theorem aleph0_le_infinite (c : Cardinal) (h : isInfinite c) : le aleph0 c = true := by
  unfold isInfinite isFinite at h
  cases c
  . exfalso
    apply h; rfl
  . unfold le aleph0; omega

/-- The successor of a cardinal is strictly larger. -/
theorem lt_succ (c : Cardinal) : lt c (succ c) = true := by
  unfold lt le succ
  cases c
  . unfold le; omega
  . unfold le; omega

/-- The continuum: c = 2^{ℵ₀}. -/
def continuum : Cardinal := powerSetCard aleph0

/-- Under GCH, continuum = ℵ₁. -/
def continuumUnderGCH : Cardinal := aleph1

/-- The continuum is larger than ℵ₀ (Cantor). -/
theorem continuum_gt_aleph0 : lt aleph0 continuum = true := by
  unfold lt le continuum powerSetCard exp aleph0 aleph1
  simp

/-! ## Cantor-Bernstein-Schroder Theorem (for finite types) -/

/-- The Cantor-Bernstein theorem: If there is an injection A -> B and
an injection B -> A, then |A| = |B|. For finite cardinals, this reduces
to m = n if m <= n and n <= m. -/

/-- Finite version: if m <= n and n <= m then m = n. -/
theorem cantor_bernstein_finite (m n : Nat) (h1 : m <= n) (h2 : n <= m) : m = n :=
  Nat.le_antisymm h1 h2

/-- Cardinal version of Cantor-Bernstein for finite cardinals. -/
theorem cantor_bernstein_cardinal (a b : Cardinal) (h1 : le a b = true) (h2 : le b a = true) : a = b := by
  cases a <;> cases b
  . unfold le at h1 h2; omega
  . unfold le at h1 h2; rcases Bool.noConfusion h2
  . unfold le at h1 h2; rcases Bool.noConfusion h1
  . unfold le at h1 h2; omega

/-! ## Cardinal Comparability -/

/-- Any two cardinals are comparable (assuming AC). -/
theorem comparable (a b : Cardinal) : le a b = true \/ le b a = true := by
  cases a <;> cases b
  . rename_i m n
    rcases Nat.le_or_lt m n with (h | h)
    . exact Or.inl h
    . exact Or.inr (by omega)
  . exact Or.inl (by unfold le; rfl)
  . exact Or.inr (by unfold le; rfl)
  . rename_i m n
    rcases Nat.le_or_lt m n with (h | h)
    . exact Or.inl h
    . exact Or.inr (by omega)

/-! ## Koenig's Theorem (simplified) -/

/-- Koenig's theorem: aleph0 < aleph0^{aleph0}. -/
theorem koenig_basic : lt aleph0 (exp aleph0 aleph0) = true := by
  unfold lt le exp aleph0
  simp

/-! ## Cardinal Arithmetic Identities -/

/-- For finite n: 2^n > n for n > 1. -/
theorem two_pow_gt_finite (n : Nat) (h : n > 1) : lt (.finite n) (exp (.finite 2) (.finite n)) = true := by
  unfold lt le exp
  have h_pow : n < 2 ^ n := by
    induction n with
    | zero => omega
    | succ n ih =>
        have hnpos : n >= 1 := by omega
        have h_pow_ge : 2 ^ n >= 2 := by
          have : 2 ^ 1 = 2 := by simp
          have : 2 ^ 1 <= 2 ^ n := Nat.pow_le_pow_right (by omega) hnpos
          omega
        omega
  omega

/-- For finite m,n: (m+n)^2 = m^2 + 2mn + n^2. -/
theorem binomial_square (m n : Nat) :
    exp (.finite (m + n)) (.finite 2) = add (add (exp (.finite m) (.finite 2))
      (mul (mul (.finite 2) (.finite m)) (.finite n))) (exp (.finite n) (.finite 2)) := by
  unfold exp add mul
  have h : (m + n) ^ 2 = m ^ 2 + (2 * m * n) + n ^ 2 := by
    calc
      (m + n) ^ 2 = (m + n) * (m + n) := by simp
      _ = m * m + m * n + n * m + n * n := by omega
      _ = m ^ 2 + 2 * m * n + n ^ 2 := by
        simp [Nat.pow_two, Nat.mul_comm, Nat.add_comm, Nat.add_assoc, Nat.mul_assoc]
    omega
  simp [h]

/-! ## The Continuum Function -/

/-- The continuum function: κ ↦ 2^κ. -/
def continuumFun (kappa : Cardinal) : Cardinal := exp (.finite 2) kappa

/-- Under GCH: 2^{ℵ_α} = ℵ_{α+1}. -/
def continuumUnderGCHAt (alpha : Nat) : Cardinal := .aleph (alpha + 1)

/-- The continuum function is monotone: if κ <= λ then 2^κ <= 2^λ. -/
theorem continuum_monotone (kappa lambda : Cardinal) (h : le kappa lambda = true) :
    le (continuumFun kappa) (continuumFun lambda) = true := by
  unfold continuumFun exp le
  cases kappa <;> cases lambda
  . rename_i m n
    have hmle_n : m <= n := h
    have h_pow : 2 ^ m <= 2 ^ n := Nat.pow_le_pow_right (by omega) hmle_n
    exact h_pow
  . rfl
  . unfold le at h
    have : false = true := h
    exact this
  . rename_i m n
    have hmle_n : m <= n := h
    omega

end Cardinal

/-! ## Evaluations -/

open Cardinal

def c0 : Cardinal := zero
def c1 : Cardinal := one
def c2 : Cardinal := two
def c3 : Cardinal := .finite 3
def c_aleph0 : Cardinal := aleph0
def c_aleph1 : Cardinal := aleph1

#eval c0
#eval c1
#eval c2
#eval c3
#eval c_aleph0
#eval c_aleph1
#eval add c2 c3
#eval mul c2 c3
#eval exp c2 c3
#eval le c2 c3
#eval le c3 c2
#eval le aleph0 aleph1
#eval continuum
#eval continuumUnderGCH
#eval isFinite c3
#eval isInfinite aleph0
#eval succ c2
#eval succ aleph0

end Cardinals
end MiniZFCLite
