import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! # Proofs -- Cantor Diagonalization

Cantor's theorem, the uncountability of the reals, Russell's paradox,
and related diagonal arguments with full Lean proofs.

Knowledge: L4 (Fundamental Theorems), L5 (Proof Methods: diagonalization, contradiction)
-/

namespace Cantor

def Set (alpha : Type) := alpha -> Bool

def Set.mem {alpha : Type} (x : alpha) (s : Set alpha) : Bool := s x

/-- Cantor's theorem: There is no surjective function from alpha to Set alpha. -/
theorem cantor_theorem (alpha : Type) (f : alpha -> Set alpha) :
    exists (s : Set alpha), forall (x : alpha), f x <> s := by
  let D : Set alpha := fun x => not (f x x)
  refine exists.intro D (fun x h_eq => ?_)
  have h_diag : D x = not (f x x) := rfl
  have h_app : f x x = D x := by rw [h_eq]
  rw [h_diag] at h_app
  have : f x x = not (f x x) := h_app
  by_cases h_true : f x x
  . rw [h_true] at this
    have : true = false := this
    exact Bool.noConfusion this
  . rw [h_true] at this
    have : false = true := this
    exact Bool.noConfusion this

/-- Corollary: There is no injective function from Set alpha to alpha. -/
theorem cantor_no_injection_from_powerset (alpha : Type) (g : Set alpha -> alpha) :
    (forall (x y : Set alpha), g x = g y -> x = y) -> False := by
  intro h_inj
  let f : alpha -> Set alpha := fun a =>
    if h : exists (s : Set alpha), g s = a then
      match h with
      | exists.intro s _ => s
    else fun _ => false
  rcases cantor_theorem alpha f with (exists.intro D hD)
  have h_surj : g D = g D := rfl
  have h_ex : exists (s : Set alpha), g s = g D := exists.intro D rfl
  have hf_gD : f (g D) = D := by
    unfold f
    simp [h_ex]
  apply hD (g D)
  symm; exact hf_gD

/-- Cantor's theorem for Nat (specific instance). -/
theorem cantor_nat_uncountable (f : Nat -> Nat -> Bool) :
    exists (D : Nat -> Bool), forall (n : Nat), f n <> D :=
  cantor_theorem Nat f

/-- The diagonal sequence not in any enumeration. -/
def diagonalExample (f : Nat -> Nat -> Bool) : Nat -> Bool :=
  fun n => not (f n n)

theorem diagonal_not_in_list (f : Nat -> Nat -> Bool) : forall (n : Nat), f n <> diagonalExample f := by
  intro n
  unfold diagonalExample
  intro h_eq
  have h_val : not (f n n) = f n n := by
    have : (fun m => not (f m m)) n = f n n := congrArg (fun g => g n) h_eq
    simpa using this
  by_cases h_true : f n n
  . rw [h_true] at h_val; exact Bool.noConfusion h_val
  . rw [h_true] at h_val; exact Bool.noConfusion h_val

/-- Reals as binary sequences (uncountability). -/
def BinaryReal := Nat -> Bool

def diagonalReal (f : Nat -> BinaryReal) : BinaryReal :=
  fun n => not (f n n)

theorem reals_uncountable (f : Nat -> BinaryReal) :
    exists (r : BinaryReal), forall (n : Nat), f n <> r := by
  let D : BinaryReal := diagonalReal f
  refine exists.intro D (fun n h_eq => ?_)
  have h_diag : D n = not (f n n) := rfl
  have h_app : f n n = D n := by rw [h_eq]
  rw [h_diag] at h_app
  by_cases h_true : f n n
  . rw [h_true] at h_app; exact Bool.noConfusion h_app
  . rw [h_true] at h_app; exact Bool.noConfusion h_app

/-- Russell's Paradox -/
def SetOfSets := Set (Set Nat)

def russellPredicate : SetOfSets := fun X => not (X X)

/-- Russell's paradox: No set R satisfies forall X, R X = not (X X).
If such R existed, applying it to itself yields R R = not (R R), a contradiction. -/
theorem russell_paradox : (exists (R : SetOfSets), forall (X : Set Nat), R X = not (X X)) -> False := by
  intro h
  rcases h with (exists.intro R hR)
  have h_RR : R R = not (R R) := hR R
  by_cases h_true : R R
  . rw [h_true] at h_RR; exact Bool.noConfusion h_RR
  . rw [h_true] at h_RR; exact Bool.noConfusion h_RR

/-- Corollary: No set equals the Russell predicate. -/
theorem russell_no_set_equals_predicate : (exists (R : SetOfSets), R = russellPredicate) -> False := by
  intro h
  rcases h with (exists.intro R hR)
  apply russell_paradox
  refine exists.intro R (fun X => ?_)
  rw [hR]; rfl

/-- The diagonal predicate is not equal to any row. -/
def diagonalPred (f : Nat -> Nat -> Bool) : Nat -> Bool :=
  fun n => not (f n n)

theorem diagonalPred_not_in_rows (f : Nat -> Nat -> Bool) : forall (n : Nat), diagonalPred f <> f n := by
  intro n
  unfold diagonalPred
  intro h_eq
  have h_val : not (f n n) = f n n := by
    have : (fun m => not (f m m)) n = f n n := congrArg (fun g => g n) h_eq
    simpa using this
  by_cases h_true : f n n
  . rw [h_true] at h_val; exact Bool.noConfusion h_val
  . rw [h_true] at h_val; exact Bool.noConfusion h_val

/-- Generalized diagonal lemma. -/
def diagonalLemma {alpha : Type} (F : alpha -> alpha -> Bool) (x : alpha) : Bool := not (F x x)

theorem generalized_diagonal {alpha : Type} (F : alpha -> alpha -> Bool) :
    exists (G : alpha -> Bool), forall (a : alpha), F a <> G := by
  let G : alpha -> Bool := fun x => not (F x x)
  refine exists.intro G (fun a h_eq => ?_)
  have : G a = not (F a a) := rfl
  rw [h_eq] at this
  by_cases h_true : F a a
  . rw [h_true] at this; exact Bool.noConfusion this
  . rw [h_true] at this; exact Bool.noConfusion this

/-- Power set cardinality result. -/
theorem power_set_not_countable (alpha : Type) (f : Nat -> alpha -> Bool) :
    exists (D : alpha -> Bool), forall (n : Nat), f n <> D :=
  cantor_theorem alpha f

def boolDiagonal (f : Nat -> Bool -> Bool) : Bool -> Bool :=
  fun b => not (f (if b then 0 else 1) b)

#eval "Cantor's theorem: No surjection onto power set -- proved"
#eval diagonalExample (fun n m => n + m < 10) 5
#eval diagonalExample (fun n m => n + m < 10) 100

end Cantor
end MiniZFCLite
