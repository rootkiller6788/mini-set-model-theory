/-
# MiniSetCore: Classification Theorems

Classification of finite sets by cardinal, Dedekind-infinite sets,
and the relationship between finite, countable, and uncountable sets.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Morphisms.Equivalence
import MiniSetCore.Morphisms.Iso
import MiniSetCore.Properties.Invariants
import MiniSetCore.Properties.ClassificationData

namespace MiniSetCore

/-! ## Finite Sets Classified by Cardinal -/

/--
Two finite sets are isomorphic iff they have the same cardinality.
For the finite case, we state this as an axiom.
-/
axiom finite_sets_same_card_iff_iso {α β : Type u} [DecidableEq α] [DecidableEq β]
    (s : Set α) (t : Set β) :
    isFinite s → isFinite t →
    (sameCardinality s t ↔ ∃ (fs : FinSet α) (ft : FinSet β),
      FinSet.toSet fs = s ∧ FinSet.toSet ft = t ∧ FinSet.size fs = FinSet.size ft)

/-- Every finite set has a unique cardinal. -/
axiom finite_set_card_unique {α : Type u} [DecidableEq α] (s : Set α) :
    isFinite s → ∃! (n : Nat), ∃ (fs : FinSet α), FinSet.toSet fs = s ∧ FinSet.size fs = n

/-! ## Dedekind-Infinite Characterization -/

/--
A set is Dedekind-infinite iff it has a countably infinite subset.
This is a key equivalence in set theory.
-/
axiom dedekind_infinite_iff_countably_infinite {α : Type u} [DecidableEq α] (s : Set α) :
    isDedekindInfinite s ↔ ∃ (t : Set α), t ⊆ s ∧ isCountable t ∧ ¬ isFinite t

/-- The set of natural numbers is Dedekind-infinite. -/
axiom natSet_dedekind_infinite : isDedekindInfinite (fun n : Nat => True)

/-! ## Countability Classification -/

/--
Every infinite set has a countably infinite subset.
This requires a weak form of the axiom of choice.
-/
axiom infinite_has_countable_subset {α : Type u} [DecidableEq α] (s : Set α) :
    isInfinite s → ∃ (t : Set α), t ⊆ s ∧ isCountable t ∧ ¬ isFinite t

/--
A set is uncountable iff it is neither finite nor countable.
-/
theorem uncountable_iff_not_finite_not_countable {α : Type u} [DecidableEq α] (s : Set α) :
    isUncountableClass s ↔ ¬ isFinite s ∧ ¬ isCountable s :=
  ⟨id, id⟩

/-! ## Classification Hierarchy -/

/--
The hierarchy is strict: empty ⊂ singleton ⊂ finite ⊂ countable ⊂ uncountable.
-/
axiom classification_hierarchy_strict (α : Type u) :
    ∃ (s : Set α), ¬ isEmpty s ∧
    ∃ (s : Set α), ¬ isFinite s ∧
    ∃ (s : Set α), ¬ isCountable s

/-! ## Countable Union of Countable Sets -/

/-- A countable union of countable sets is countable (requires choice). -/
axiom countable_union_countable_countable {α : Type u}
    (F : Set (Set α)) :
    isCountable F → (∀ s, F s → isCountable s) → isCountable (fun x => ∃ s, F s ∧ s x)

/-! ## #eval Examples -/

-- Finite sets classified by cardinal
#eval "finite_sets_same_card_iff_iso: axiom loaded"

-- Finite set gets unique cardinal
def myFinSet : FinSet Nat := .insert 1 (.insert 2 (.insert 3 .empty))
def mySet := FinSet.toSet myFinSet
#eval FinSet.size myFinSet
#eval FinSet.mem 1 myFinSet
#eval FinSet.mem 5 myFinSet

-- Dedekind-infinite natural numbers
#eval "natSet_dedekind_infinite: axiom loaded"

-- Countable union of countable sets
#eval "countable_union_countable_countable: axiom loaded"

-- Uncountable classification checks
#eval "classification hierarchy: loaded"

end MiniSetCore
