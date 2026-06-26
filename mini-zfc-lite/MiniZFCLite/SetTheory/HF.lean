import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! # SetTheory — Hereditarily Finite Sets

A constructive encoding of hereditarily finite (HF) sets using
an inductive type with a membership relation, supporting
union, intersection, power set, and rank operations.

Knowledge: L1 (Definitions), L2 (Core Concepts), L4 (Theorems), L5 (Induction proofs)
-/

/-- Hereditarily Finite Set as an inductive type.
Atoms are natural numbers. Compound sets are collections of HF sets. -/
inductive HFSet : Type where
  | atom : Nat -> HFSet
  | set  : List HFSet -> HFSet
deriving Repr, BEq, Inhabited

namespace HFSet

/-- The empty set. -/
def empty : HFSet := .set []

/-- Singleton set {x}. -/
def singleton (x : HFSet) : HFSet := .set [x]

/-- Unordered pair {x, y}. -/
def pair (x y : HFSet) : HFSet := .set [x, y]

/-- Membership: x in (set xs) iff x appears in xs. Atoms have no members. -/
def mem (x : HFSet) (s : HFSet) : Bool :=
  match s with
  | .atom _ => false
  | .set xs => xs.any (fun y => y == x)

/-- Subset relation: x subset y iff every member of x is a member of y. -/
def subset (x y : HFSet) : Bool :=
  match x with
  | .atom _ => false
  | .set xs => xs.all (fun a => mem a y)

/-- Proper subset: x is a subset of y but not equal. -/
def properSubset (x y : HFSet) : Bool :=
  subset x y && (x != y)

/-- Union of two HF sets. -/
def union (x y : HFSet) : HFSet :=
  match x, y with
  | .set xs, .set ys => .set (xs ++ ys)
  | .atom a, .set ys => .set (.atom a :: ys)
  | .set xs, .atom b => .set (xs ++ [.atom b])
  | .atom a, .atom b => .set [.atom a, .atom b]

/-- Big union: flatten the elements of a set. -/
def bigUnion (x : HFSet) : HFSet :=
  match x with
  | .atom _ => empty
  | .set xs => .set (xs.bind fun y => match y with
      | .set ys => ys
      | .atom a => [.atom a])

/-- Intersection of two HF sets. -/
def inter (x y : HFSet) : HFSet :=
  match x, y with
  | .set xs, .set ys => .set (xs.filter (fun a => mem a y))
  | _, _ => empty

/-- Set difference: x \ y. -/
def diff (x y : HFSet) : HFSet :=
  match x with
  | .set xs => .set (xs.filter (fun a => not (mem a y)))
  | .atom _ => empty

/-- Power set: collect all subsets of x as a set. Uses list of sublists. -/
def powerSet (x : HFSet) : HFSet :=
  match x with
  | .atom _ => .set [empty]
  | .set xs =>
      let sublists : List (List HFSet) := allSublists xs
      .set (sublists.map fun ys => .set ys)
where
  allSublists : List HFSet -> List (List HFSet)
    | [] => [[]]
    | hd :: tl =>
        let rest := allSublists tl
        rest ++ (rest.map fun ys => hd :: ys)

/-- The rank of an HF set: rank(atom) = 0, rank(set xs) = max rank(x_i) + 1. -/
def rank : HFSet -> Nat
  | .atom _ => 0
  | .set xs => xs.foldl (fun acc x => max acc (rank x)) 0 + 1

/-- Size of the transitive closure (simplified: count elements). -/
def size : HFSet -> Nat
  | .atom _ => 1
  | .set xs => 1 + (xs.map size).sum

/-- Check if set is hereditarily finite (always true by construction). -/
def isHereditarilyFinite (_ : HFSet) : Bool := true

/-- Check if set is transitive: every member of a member is a member. -/
def isTransitive (x : HFSet) : Bool :=
  match x with
  | .atom _ => true
  | .set xs => xs.all (fun y => match y with
      | .atom _ => true
      | .set ys => ys.all (fun z => mem z x))

/-! ## Properties of HF sets (with proofs) -/

/-- The empty set has no members. -/
theorem empty_no_members (x : HFSet) : mem x empty = false := by
  unfold mem empty; rfl

/-- Every set is a member of its singleton. -/
theorem mem_singleton (x : HFSet) : mem x (singleton x) = true := by
  unfold mem singleton; simp

/-- Union contains both operands. -/
theorem mem_union_left (x y : HFSet) : mem x (union x y) = true := by
  unfold mem union
  match x with
  | .atom _ => simp
  | .set xs => simp

/-- Membership in union: x in (a union b) iff x in a or x in b. -/
theorem mem_union_iff (x a b : HFSet) : mem x (union a b) = (mem x a || mem x b) := by
  unfold mem union
  match a, b with
  | .set as, .set bs =>
      simp; rw [List.any_append]
  | .atom _, .set bs =>
      simp; rw [List.any_append]
      have : ([.atom _] : List HFSet).any (fun y => y == x) = (x == .atom _) := by simp
      rw [this]
  | .set as, .atom _ =>
      simp; rw [List.any_append]
  | .atom _, .atom _ =>
      simp

/-- Power set of empty is {empty}. -/
theorem powerSet_empty : powerSet empty = singleton empty := by
  unfold powerSet empty singleton
  rfl

/-- Rank of empty is 0. -/
theorem rank_empty : rank empty = 0 := rfl

/-- Rank of singleton x is rank x + 1. -/
theorem rank_singleton (x : HFSet) : rank (singleton x) = rank x + 1 := by
  unfold rank singleton; simp

/-- Every element in the list xs is a member of .set xs. -/
theorem mem_of_elem_in_list {xs : List HFSet} {a : HFSet} (h : a in xs) : mem a (.set xs) = true := by
  unfold mem
  induction xs with
  | nil => exfalso; exact h
  | cons hd tl ih =>
      rcases h with (rfl | htl)
      · simp
      · simp [ih htl]

/-- Subset is reflexive: every set is a subset of itself. -/
theorem subset_refl (x : HFSet) : subset x x = true := by
  unfold subset
  match x with
  | .atom _ => rfl
  | .set xs =>
      rw [List.all_eq_true]
      intro a ha
      exact mem_of_elem_in_list ha

/-- The empty set is a subset of every set. -/
theorem empty_subset (x : HFSet) : subset empty x = true := by
  unfold empty subset; rfl

/-! ## Constructing the V_n hierarchy -/

/-- V_0 = empty set. -/
def v0 : HFSet := empty

/-- V_{n+1} = P(V_n). -/
def vStep (n : Nat) : HFSet :=
  match n with
  | 0 => v0
  | n+1 => powerSet (vStep n)

/-- The standard finite ordinals as HF sets: 0={}, 1={0}, 2={0,1}, ... -/
def ordinalAsHF (n : Nat) : HFSet :=
  match n with
  | 0 => empty
  | n+1 => union (ordinalAsHF n) (singleton (ordinalAsHF n))

/-! ## Evaluations -/

def hf0 : HFSet := empty
def hf1 : HFSet := singleton hf0
def hf2 : HFSet := pair hf0 hf1
def hf3 : HFSet := union hf1 (singleton hf2)

#eval hf0
#eval hf1
#eval hf2
#eval hf3
#eval mem hf0 hf1
#eval mem hf0 hf2
#eval mem hf1 hf2
#eval rank hf0
#eval rank hf1
#eval rank hf2
#eval rank hf3
#eval size hf0
#eval size hf3
#eval powerSet (powerSet hf0)
#eval ordinalAsHF 0
#eval ordinalAsHF 1
#eval ordinalAsHF 2
#eval ordinalAsHF 3

end HFSet
end MiniZFCLite
