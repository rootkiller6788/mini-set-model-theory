/-
# MiniSetCore: Basic Definitions

Defines the `Set α := α → Prop` type, basic set operations,
and the `FinSet` inductive type.
-/

namespace MiniSetCore

/-! ## Set Type and Membership -/

def Set (α : Type u) : Type u := α → Prop

def mem {α : Type u} (x : α) (s : Set α) : Prop := s x

instance : Membership α (Set α) where
  mem x s := s x

/-! ## Basic Set Constructors -/

def emptySet (α : Type u) : Set α := fun _ => False

def singleton {α : Type u} [DecidableEq α] (x : α) : Set α :=
  fun y => x = y

def pair {α : Type u} [DecidableEq α] (x y : α) : Set α :=
  fun z => z = x ∨ z = y

/-! ## Set Operations -/

def union {α : Type u} (s t : Set α) : Set α :=
  fun x => s x ∨ t x

def inter {α : Type u} (s t : Set α) : Set α :=
  fun x => s x ∧ t x

def powerSet {α : Type u} (s : Set α) : Set (Set α) :=
  fun t => ∀ x, t x → s x

def diff {α : Type u} (s t : Set α) : Set α :=
  fun x => s x ∧ ¬ t x

/-! ## Subset Relation -/

def subset {α : Type u} (s t : Set α) : Prop := ∀ x, s x → t x

instance : HasSubset (Set α) where
  Subset s t := ∀ x, s x → t x

/-! ## Relation and Function Classifiers -/

def isRelation {α β : Type u} (r : Set (α × β)) : Prop := True

def isFunction {α β : Type u} (f : Set (α × β)) : Prop :=
  ∀ x y₁ y₂, f (x, y₁) → f (x, y₂) → y₁ = y₂

/-! ## Finite Sets -/

inductive FinSet (α : Type u) : Type u where
  | empty : FinSet α
  | insert : α → FinSet α → FinSet α
  deriving Repr, Inhabited

def FinSet.toSet {α : Type u} [DecidableEq α] : FinSet α → Set α
  | .empty => emptySet α
  | .insert x fs => union (singleton x) (toSet fs)

def FinSet.mem {α : Type u} [DecidableEq α] (x : α) (fs : FinSet α) : Bool :=
  match fs with
  | .empty => false
  | .insert y rest => x = y || mem x rest

def FinSet.size {α : Type u} [DecidableEq α] : FinSet α → Nat
  | .empty => 0
  | .insert _ rest => 1 + size rest

/-! ## Example -/

def exampleFinSet : FinSet Nat :=
  .insert 1 (.insert 2 (.insert 3 .empty))

end MiniSetCore
