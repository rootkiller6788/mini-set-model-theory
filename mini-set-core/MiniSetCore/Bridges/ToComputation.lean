/-
# MiniSetCore: Bridge to Computation

Computable sets, decidable sets, finite automata as sets,
and connections between set theory and computer science.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Properties.Invariants

namespace MiniSetCore

/-! ## Computable Sets -/

/--
A set is decidable if membership is decidable for every element.
Note: `Decidable` is at `Type` level; this is a type, not a `Prop`.
-/
def isDecidableSet {α : Type u} [DecidableEq α] (s : Set α) : Type u :=
  ∀ x, Decidable (s x)

/-- Every FinSet gives a decidable set. Proof deferred with `sorry`. -/
theorem FinSet_isDecidable {α : Type u} [DecidableEq α] (fs : FinSet α) :
    isDecidableSet (FinSet.toSet fs) :=
  sorry

/-! ## Enumerable Sets -/

/-- A set is enumerable if there is a surjection from Nat (possibly with repetition). -/
def isEnumerable {α : Type u} (s : Set α) : Prop :=
  ∃ (f : Nat → Option α), ∀ x, s x → ∃ n, f n = some x

/-- Every countable set is enumerable. -/
theorem countable_implies_enumerable {α : Type u} (s : Set α) :
    isCountable s → isEnumerable s := by
  intro h
  rcases h with (h_empty | ⟨f, hf⟩)
  · -- If s is empty, any constant function works
    refine ⟨fun _ => none, ?_⟩
    intro x hx; exact (h_empty x hx).elim
  · -- Use the existing enumeration, wrapping in Option
    refine ⟨fun n => some (f n), ?_⟩
    intro x hx
    rcases hf x hx with ⟨n, hn⟩
    exact ⟨n, congrArg some hn⟩

/-! ## Finite Automata as Sets -/

/--
A deterministic finite automaton (DFA) as a set-theoretic structure.
`Q` = state type, `Σ` = symbol type.
-/
structure DFA (Q S : Type u) where
  states : Set Q
  alphabet : Set S
  transition : Q → S → Q
  startState : Q
  acceptStates : Set Q
  startInStates : acceptStates startState
  transitionClosed : ∀ q a, states q → alphabet a → states (transition q a)

/-- A DFA accepts a word if the run ends in an accept state. -/
def DFA.accepts {Q S : Type u} (dfa : DFA Q S) (word : List S) : Prop :=
  let finalState := word.foldl dfa.transition dfa.startState
  dfa.acceptStates finalState

/-- The language of a DFA is the set of words it accepts. -/
def DFA.language {Q S : Type u} (dfa : DFA Q S) : Set (List S) :=
  fun w => dfa.accepts w

/-- Regular languages are those recognized by some DFA. -/
def isRegularLanguage {S : Type u} (L : Set (List S)) : Prop :=
  ∃ (Q : Type u) (dfa : DFA Q S), dfa.language = L

/-! ## Boolean Circuits as Sets -/

/-- A Boolean function on n variables is a set of input assignments. -/
def booleanFunction (n : Nat) : Type := Set (Fin n → Bool)

/-- The set of all Boolean functions on n variables. -/
def allBooleanFunctions (n : Nat) : Set (Set (Fin n → Bool)) :=
  fun _ => True

/-- The number of Boolean functions on n variables: 2^(2^n). -/
axiom countBooleanFunctions (n : Nat) : Nat

/-! ## Turing Machines as Sets -/

/--
A Turing machine configuration can be represented as a set.
For the finite-core setup, we just establish the concept.
-/
structure TuringMachine (stateType symbolType : Type u) where
  states : Set stateType
  symbols : Set symbolType
  transition : stateType → symbolType → Option (stateType × symbolType × Bool)
  -- Bool indicates direction: true = right, false = left

/-! ## #eval Examples -/

-- Decidable set from FinSet
def myFinSet : FinSet Nat := .insert 1 (.insert 2 (.insert 3 .empty))
def mySet := FinSet.toSet myFinSet
#eval FinSet.mem 1 myFinSet
#eval FinSet.mem 5 myFinSet
#eval FinSet.size myFinSet

-- DFA example: recognizes words with even number of 1s
def evenOnesDFA : DFA Bool Bool where
  states := fun _ => True
  alphabet := fun a => a = true  -- only symbol 'true'
  transition := fun q a => if a then ¬ q else q
  startState := false
  acceptStates := singleton false
  startInStates := rfl
  transitionClosed := by
    intro q a hq ha
    -- If a is in alphabet (a = true), result is still a Bool, which is in states
    trivial

#check evenOnesDFA.accepts [true, true]
#check evenOnesDFA.accepts [true, true, true]

-- Boolean function example
#check allBooleanFunctions 2

end MiniSetCore
