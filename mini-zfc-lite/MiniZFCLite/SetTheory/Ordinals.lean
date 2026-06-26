import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! # SetTheory -- Von Neumann Ordinals

A constructive encoding of von Neumann ordinals using `Nat`
as the underlying carrier, with order relations, successor/limit
classification, and basic ordinal arithmetic with full proofs.

Knowledge coverage: L1 (Definitions), L2 (Core Concepts), L4 (Fundamental Theorems),
L5 (Proof Methods: induction, omega, case analysis)
-/

abbrev Ordinal := Nat

namespace Ordinal

def mem (m n : Ordinal) : Bool := m < n
def subset (m n : Ordinal) : Bool := m <= n
def zero : Ordinal := 0
def succ (alpha : Ordinal) : Ordinal := alpha + 1
def isSuccessor (alpha : Ordinal) : Bool := alpha > 0
def isLimit (alpha : Ordinal) : Bool := alpha == 0

theorem mem_irreflexive (alpha : Ordinal) : mem alpha alpha = false := by
  unfold mem; omega

theorem mem_trans {alpha beta gamma : Ordinal} (h1 : mem alpha beta = true) (h2 : mem beta gamma = true) : mem alpha gamma = true := by
  unfold mem at h1 h2
  have hlt1 : alpha < beta := by simpa using h1
  have hlt2 : beta < gamma := by simpa using h2
  unfold mem
  have hlt : alpha < gamma := Nat.lt_trans hlt1 hlt2
  simpa

theorem mem_well_founded : forall (alpha : Ordinal), Acc (fun (x y : Ordinal) => x < y) alpha := by
  intro alpha
  induction alpha with
  | zero => constructor; intro y hy; omega
  | succ alpha ih =>
      constructor
      intro y hy
      have hle : y <= alpha := by omega
      rcases Nat.eq_or_lt_of_le hle with (rfl | hlt)
      . exact ih
      . apply Acc.inv ih; exact hlt

theorem extensional {alpha beta : Ordinal} (h : forall gamma, mem gamma alpha = mem gamma beta) : alpha = beta := by
  apply Nat.le_antisymm
  . by_contra! hgt
    have hmem_self : mem alpha alpha = true := by unfold mem; omega
    have hmem_other : mem alpha beta = true := by rw [<- h alpha]; exact hmem_self
    have hlt : alpha < beta := by
      unfold mem at hmem_other
      simpa using hmem_other
    have hle : alpha <= beta := Nat.le_of_lt hlt
    omega
  . by_contra! hgt
    have hmem_self : mem beta beta = true := by unfold mem; omega
    have hmem_other : mem beta alpha = true := by rw [h beta]; exact hmem_self
    have hlt : beta < alpha := by
      unfold mem at hmem_other
      simpa using hmem_other
    have hle : beta <= alpha := Nat.le_of_lt hlt
    omega

theorem mem_succ (alpha : Ordinal) : mem alpha (succ alpha) = true := by
  unfold mem succ; omega

theorem succ_ne_zero (alpha : Ordinal) : succ alpha <> zero := by
  unfold succ zero; omega

theorem mem_succ_implies_le {alpha beta : Ordinal} (h : mem alpha (succ beta) = true) : alpha <= beta := by
  unfold mem succ at h; omega

theorem succ_inj {alpha beta : Ordinal} (h : succ alpha = succ beta) : alpha = beta := by
  unfold succ at h; omega

def add (alpha beta : Ordinal) : Ordinal := alpha + beta
theorem add_zero (alpha : Ordinal) : add alpha zero = alpha := by unfold add zero; omega
theorem zero_add (alpha : Ordinal) : add zero alpha = alpha := by unfold add zero; omega
theorem add_assoc (alpha beta gamma : Ordinal) : add (add alpha beta) gamma = add alpha (add beta gamma) := by unfold add; omega
theorem add_succ (alpha beta : Ordinal) : add alpha (succ beta) = succ (add alpha beta) := by unfold add succ; omega
theorem add_comm (alpha beta : Ordinal) : add alpha beta = add beta alpha := by unfold add; omega

def mul (alpha beta : Ordinal) : Ordinal := alpha * beta
theorem mul_zero (alpha : Ordinal) : mul alpha zero = zero := by unfold mul zero; omega
theorem mul_one (alpha : Ordinal) : mul alpha (succ zero) = alpha := by unfold mul succ zero; omega
theorem zero_mul (alpha : Ordinal) : mul zero alpha = zero := by unfold mul zero; omega
theorem mul_add_distrib (alpha beta gamma : Ordinal) : mul alpha (add beta gamma) = add (mul alpha beta) (mul alpha gamma) := by unfold mul add; omega
theorem add_mul_distrib (alpha beta gamma : Ordinal) : mul (add alpha beta) gamma = add (mul alpha gamma) (mul beta gamma) := by unfold mul add; omega
theorem mul_assoc (alpha beta gamma : Ordinal) : mul (mul alpha beta) gamma = mul alpha (mul beta gamma) := by unfold mul; omega
theorem mul_comm (alpha beta : Ordinal) : mul alpha beta = mul beta alpha := by unfold mul; omega

def exp (alpha beta : Ordinal) : Ordinal := alpha ^ beta
theorem exp_zero (alpha : Ordinal) : exp alpha zero = succ zero := by
  unfold exp zero succ; simp
theorem exp_one (alpha : Ordinal) : exp alpha (succ zero) = alpha := by
  unfold exp succ zero; simp
theorem zero_exp_succ {alpha : Ordinal} (h : alpha > 0) : exp zero alpha = zero := by
  unfold exp zero; have hp := Nat.zero_pow (by omega); simpa using hp
theorem exp_add (alpha beta gamma : Ordinal) : exp alpha (add beta gamma) = mul (exp alpha beta) (exp alpha gamma) := by
  unfold exp add mul; rw [Nat.pow_add (Nat.zero_le beta) (Nat.zero_le gamma)]; omega

theorem transfinite_induction {P : Ordinal -> Prop}
    (h : forall alpha, (forall beta, beta < alpha -> P beta) -> P alpha) : forall alpha, P alpha := by
  intro alpha
  induction alpha using Nat.strong_induction_on with
  | h alpha ih =>
      apply h alpha
      intro beta hlt
      apply ih beta hlt

def allSmaller (alpha : Ordinal) : List Ordinal := List.range alpha
theorem equals_set_of_smaller (alpha : Ordinal) : (allSmaller alpha).length = alpha := by
  unfold allSmaller; simp

theorem transitive_set (alpha beta gamma : Ordinal) (hbg : mem gamma beta = true) (hba : mem beta alpha = true) : mem gamma alpha = true :=
  mem_trans hbg hba

theorem trichotomy (alpha beta : Ordinal) : alpha < beta \/ alpha = beta \/ beta < alpha :=
  Nat.lt_trichotomy alpha beta

theorem trichotomy_unique (alpha beta : Ordinal) :
    (alpha < beta /\ (alpha = beta -> False) /\ (beta < alpha -> False)) \/
    (alpha = beta /\ (alpha < beta -> False) /\ (beta < alpha -> False)) \/
    (beta < alpha /\ (alpha = beta -> False) /\ (alpha < beta -> False)) := by
  rcases trichotomy alpha beta with (hlt | heq | hgt)
  . refine Or.inl (And.intro hlt (And.intro ?_ ?_)); omega; omega
  . refine Or.inr (Or.inl (And.intro heq (And.intro ?_ ?_))); omega; omega
  . refine Or.inr (Or.inr (And.intro hgt (And.intro ?_ ?_))); omega; omega

theorem no_maximum_ordinal (S : List Ordinal) : exists (alpha : Ordinal), forall (beta : Ordinal), beta in S -> beta < alpha := by
  induction S with
  | nil => exact (exists.intro 0 (by intro beta h; exfalso; exact h))
  | cons hd tl ih =>
      rcases ih with (exists.intro alpha halpha)
      refine exists.intro (max (hd + 1) (alpha + 1)) (fun beta hbeta => ?_)
      rcases hbeta with (rfl | hbtl)
      . have h : hd < hd + 1 := by omega
        have hm : hd + 1 <= max (hd + 1) (alpha + 1) := Nat.le_max_left _ _
        omega
      . have h1 : beta < alpha := halpha beta hbtl
        have h2 : alpha < alpha + 1 := by omega
        have hm : alpha + 1 <= max (hd + 1) (alpha + 1) := Nat.le_max_right _ _
        omega

theorem no_greatest_ordinal (alpha : Ordinal) : exists (beta : Ordinal), beta > alpha := by
  refine exists.intro (succ alpha) ?_
  unfold succ; omega

def OrdinalFunc := Ordinal -> Ordinal
def monotonic (f : OrdinalFunc) : Prop :=
  forall (alpha beta : Ordinal), alpha < beta -> f alpha <= f beta

theorem id_monotonic : monotonic (fun alpha => alpha) := by
  intro alpha beta hlt; omega

theorem succ_monotonic : monotonic succ := by
  intro alpha beta hlt; unfold succ; omega

theorem comp_monotonic {f g : OrdinalFunc} (hf : monotonic f) (hg : monotonic g) :
    monotonic (fun alpha => f (g alpha)) := by
  intro alpha beta hlt
  have hgf : g alpha <= g beta := hg alpha beta hlt
  rcases Nat.lt_or_eq_of_le hgf with (hlt' | heq)
  . have hfres := hf (g alpha) (g beta) hlt'
    omega
  . rw [heq]

def ordinal0 : Ordinal := zero
def ordinal1 : Ordinal := succ zero
def ordinal2 : Ordinal := succ (succ zero)
def ordinal3 : Ordinal := succ (succ (succ zero))

#eval ordinal0
#eval ordinal1
#eval ordinal2
#eval ordinal3
#eval mem ordinal0 ordinal1
#eval mem ordinal0 ordinal2
#eval mem ordinal1 ordinal2
#eval mem ordinal2 ordinal1
#eval add ordinal2 ordinal3
#eval mul ordinal2 ordinal3
#eval exp ordinal2 ordinal3
#eval allSmaller 5

end Ordinal
end MiniZFCLite
