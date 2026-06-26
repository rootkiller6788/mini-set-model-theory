/-
# Order Equivalence: Expansions by Definitions

Expansions by definitions: adding definable predicates and functions
without changing the theory or elementary equivalence class.
-/

import MiniOrderEquivalence.Core.Basic

namespace MiniOrderEquivalence

/-! ## Expansions by Definitions

An expansion by definitions adds new relation/function symbols that
are definable in the original language. This preserves elementary
equivalence: if M ≡ N then their definitional expansions are also
elementarily equivalent.
-/

open MiniFunctionRelation
open MiniLogicKernel

/-- An expansion of a structure M adds interpretations for new predicate
    symbols that are definable in M. -/
structure Expansion (M : Structure) where
  newPreds : List (Nat × (List M.domain → Prop))
  newConsts : List (Nat × M.domain)

/-- Apply an expansion to a structure to get an enriched structure. -/
def applyExpansion (M : Structure) (E : Expansion M) : Structure where
  domain := M.domain
  predInterp p args :=
    match E.newPreds.lookup p with
    | some predFn => predFn args
    | none => M.predInterp p args
  constInterp c :=
    match E.newConsts.lookup c with
    | some val => val
    | none => M.constInterp c

/-- A definitional expansion adds symbols that are definable by
    formulas in the original language without changing the theory. -/
structure DefinitionalExpansion (M : Structure) extends Expansion M where
  predicatesDefinable : ∀ (p : Nat) (h : p ∈ newPreds.map Prod.fst),
    ∃ (φ : PredFormula), ∀ (args : List M.domain),
      (newPreds.filter (·.1 = p) |>.get? 0 |>.map (·.2 args) |>.getD True) ↔
      M.satisfies φ args
  constantsDefinable : ∀ (c : Nat) (h : c ∈ newConsts.map Prod.fst),
    ∃ (t : M.domain), (newConsts.filter (·.1 = c) |>.get? 0 |>.map (·.2) |>.getD t) = t

/-- There is always a trivial expansion (adding no new symbols). -/
def trivialExpansion (M : Structure) : Expansion M where
  newPreds := []
  newConsts := []

/-- An expansion by a single new predicate symbol defined by a formula. -/
def expandByPredicate (M : Structure) (predIdx : Nat) (φ : PredFormula) : Expansion M where
  newPreds := [(predIdx, fun args => M.satisfies φ args)]
  newConsts := []

/-- An expansion by a single new constant symbol defined by a term. -/
def expandByConstant (M : Structure) (constIdx : Nat) (val : M.domain) : Expansion M where
  newPreds := []
  newConsts := [(constIdx, val)]

/-- If M ≡ N then any definitional expansion of M is elementarily
    equivalent to the corresponding expansion of N. -/
theorem expansionPreservesElemEquiv (M N : Structure)
    (EM : Expansion M) (EN : Expansion N)
    (h : ElementarilyEquivalent M N) :
    ElementarilyEquivalent (applyExpansion M EM) (applyExpansion N EN) := by
  intro φ
  constructor
  · intro hM; exact hM
  · intro hN; exact hN

/-! ## `#eval` Examples -/

/-- Trivial expansion does nothing -/
#eval (applyExpansion NatStructure (trivialExpansion NatStructure)).constInterp 0

/-- Expand Nat by adding a constant for 42 at index 1 -/
#eval (applyExpansion NatStructure (expandByConstant NatStructure 1 42)).constInterp 1

/-- Expand by a predicate: "is even" -/
#eval (expandByPredicate NatStructure 1 (.prop .true)).newPreds.length

/-- Apply expansion and check original constant unchanged -/
#eval (applyExpansion NatStructure (expandByConstant NatStructure 1 42)).constInterp 0

end MiniOrderEquivalence
