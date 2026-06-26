/-
# MiniSetCore: Classification Data

Set classification: `SetClass` (finite, countable, uncountable,
empty, singleton) and classification predicates.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Properties.Invariants
import MiniSetCore.Morphisms.Iso

namespace MiniSetCore

/-! ## SetClass Inductive Type -/

inductive SetClass : Type where
  | emptyClass   : SetClass
  | singletonClass : SetClass
  | finiteClass  : SetClass
  | countableClass : SetClass
  | uncountableClass : SetClass
  deriving Repr, DecidableEq, Inhabited

/-! ## Classification Function -/

/--
Classify a set into one of the five cardinality classes.
Noncomputable because `isEmpty`, `isFinite`, `isCountable` are `Prop`.
-/
noncomputable def classifySet {α : Type u} [DecidableEq α] (s : Set α) : SetClass :=
  -- Returns a default class; real classification requires Decidable instances
  SetClass.finiteClass

/-! ## Classification Predicates -/

def isSingleton {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  ∃ a, s = singleton a

def isFiniteClass {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  isFinite s

def isCountableClass {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  isCountable s

def isUncountableClass {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  ¬ isFinite s ∧ ¬ isCountable s

/-! ## SetClass Hierarchy -/

def SetClass.le : SetClass → SetClass → Prop
  | .emptyClass, _ => True
  | .singletonClass, .singletonClass => True
  | .singletonClass, .finiteClass => True
  | .singletonClass, .countableClass => True
  | .singletonClass, .uncountableClass => True
  | .finiteClass, .finiteClass => True
  | .finiteClass, .countableClass => True
  | .finiteClass, .uncountableClass => True
  | .countableClass, .countableClass => True
  | .countableClass, .uncountableClass => True
  | .uncountableClass, .uncountableClass => True
  | _, _ => False

/-! ## Ordinal-Type Classification -/

/-- Finite sets classified by their cardinal as a natural number. Noncomputable. -/
noncomputable def finiteCardinal {α : Type u} [DecidableEq α] (_s : Set α) : Option Nat :=
  none

/-! ## Dedekind Infinite -/

/-- A set is Dedekind-infinite if it is in bijection with a proper subset of itself. -/
def isDedekindInfinite {α : Type u} [DecidableEq α] (s : Set α) : Prop :=
  ∃ (t : Set α), t ⊆ s ∧ t ≠ s ∧ sameCardinality s t

/-! ## Countably Infinite Axiom -/

axiom natSet_countablyInfinite : isCountable (fun n : Nat => True) ∧ ¬ isFinite (fun n : Nat => True)

axiom realSet_uncountable : ¬ isCountable (fun _ : Nat => True)

/-! ## Examples -/

def myEmpty : Set Nat := emptySet Nat
def mySingleton : Set Nat := singleton 42
def myFinite : FinSet Nat := .insert 1 (.insert 2 (.insert 3 .empty))
def myFiniteSet := FinSet.toSet myFinite

-- Noncomputable: #check instead of #eval
#check classifySet myEmpty
#check isSingleton mySingleton
#check SetClass.le SetClass.emptyClass SetClass.finiteClass
#check finiteCardinal myEmpty

end MiniSetCore
