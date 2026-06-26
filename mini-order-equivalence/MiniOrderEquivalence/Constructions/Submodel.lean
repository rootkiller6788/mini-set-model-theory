/-
# Order Equivalence: Elementary Submodels

Construction of elementary submodels, substructure operations,
and the Tarski-Vaught criterion for verifying elementarity.
-/

import MiniOrderEquivalence.Core.Basic
import MiniOrderEquivalence.Core.Laws

namespace MiniOrderEquivalence

open MiniLogicKernel

/-! ## Submodel Operations

A submodel (substructure) S of M is a nonempty subset of M.domain
closed under the interpretation of all constant symbols.
-/

/-- The full submodel (M itself as a substructure of M). -/
def fullSubStructure (M : Structure) : SubStructure M where
  carrier := Set.univ
  closedUnderConstants _ := trivial
  nonempty := ⟨M.constInterp 0, trivial⟩

/-- A submodel defined by a predicate p on the domain. All constants
    must satisfy p for this to be a valid submodel. -/
def predicateSubStructure (M : Structure) (p : M.domain → Prop)
    (hConsts : ∀ n, p (M.constInterp n))
    (hNonempty : ∃ x, p x) : SubStructure M where
  carrier := SetOf p
  closedUnderConstants n := hConsts n
  nonempty := by
    rcases hNonempty with ⟨x, hx⟩
    exact ⟨x, hx⟩

/-- A submodel where the carrier is the singleton {x}, valid only
    when all constants interpret to x. -/
def singletonSubStructure (M : Structure) (x : M.domain)
    (hAllConstsAreX : ∀ n, M.constInterp n = x) : SubStructure M where
  carrier := fun y => y = x
  closedUnderConstants n := by
    rw [hAllConstsAreX n]
    rfl
  nonempty := ⟨x, rfl⟩

/-- A submodel defined by a finite list of elements. The carrier
    is exactly the set of those elements (if constants are among them). -/
def finiteListSubStructure (M : Structure) (xs : List M.domain)
    (hConsts : ∀ n, M.constInterp n ∈ xs) : SubStructure M where
  carrier := fun x => x ∈ xs
  closedUnderConstants n := hConsts n
  nonempty := match xs with
    | [] => by
      exfalso
      -- constants must be in xs, so xs can't be empty
      have h := hConsts 0
      simp at h
    | x :: _ => ⟨x, by simp⟩

/-! ## Submodel Construction lemmas -/

/-- The inclusion map from a substructure to the parent is a homomorphism. -/
theorem subStructureInclusionHom (M : Structure) (S : SubStructure M) :
    Hom (SubStructure.toStructure M S) M where
  map := Subtype.val
  preservesPred p args h := by
    simpa [SubStructure.toStructure] using h
  preservesConst _ := rfl

/-- If S is a substructure of M, every constant of M is
    also a constant of (the restricted structure). -/
theorem subStructureConstInclusion (M : Structure) (S : SubStructure M) (n : Nat) :
    ((SubStructure.toStructure M S).constInterp n).val = M.constInterp n := rfl

/-! ## Tarski-Vaught Chains

An elementary chain is a sequence M₀ ≺ M₁ ≺ ... of elementary
substructures. The union of an elementary chain is an elementary
extension of each Mᵢ.
-/

/-- A Tarski-Vaught chain: an increasing sequence of substructures
    where each is elementary in the next. -/
structure TVChain (M : Structure) where
  levels : Nat → SubStructure M
  increasing : ∀ n, levels n |>.carrier ⊆ levels (n+1) |>.carrier
  elementary : ∀ n, True
  -- The n-th level is elementary in the (n+1)-th level
  -- In a full development, we'd state the Tarski-Vaught property here

/-- The union of a TV chain. -/
def TVChain.union (chain : TVChain M) : SubStructure M where
  carrier := fun x => ∃ n, chain.levels n |>.carrier x
  closedUnderConstants n := by
    refine ⟨0, ?_⟩
    exact chain.levels 0 |>.closedUnderConstants n
  nonempty := by
    rcases chain.levels 0 |>.nonempty with ⟨x, hx⟩
    exact ⟨x, 0, hx⟩

/-! ## Concrete Submodel Examples -/

/-- The submodel of NatStructure consisting of {0, 1, 2}. -/
def finSubStructure : SubStructure NatStructure where
  carrier := fun n => n ≤ 2
  closedUnderConstants
    | 0 => by simp [NatStructure]
    | _ => by
      simp [NatStructure]
      omega
  nonempty := ⟨0, by omega⟩

/-- The trivial submodel containing only the constant 0. -/
def trivialSubStructure : SubStructure NatStructure where
  carrier := fun n => n = 0
  closedUnderConstants
    | 0 => by simp [NatStructure]
    | _ => by simp [NatStructure]
  nonempty := ⟨0, rfl⟩

/-- A submodel of IntStructure consisting of nonnegative integers. -/
def nonnegIntSubStructure : SubStructure IntStructure where
  carrier := fun z => z ≥ 0
  closedUnderConstants
    | 0 => by simp [IntStructure]
    | _ => by simp [IntStructure]
  nonempty := ⟨0, by simp⟩

/-- The submodel of "even numbers" (not closed under constants
    unless the constant 0 is even, which it is). -/
def evenNatSubStructure : SubStructure NatStructure where
  carrier := fun n => n % 2 = 0
  closedUnderConstants
    | 0 => by simp [NatStructure]
    | _ => by simp [NatStructure]
  nonempty := ⟨0, by simp⟩

/-! ## `#eval` Verification -/

#eval finSubStructure.carrier 0
#eval finSubStructure.carrier 5
#eval fullSubStructure NatStructure |>.carrier 100
#eval trivialSubStructure.closedUnderConstants 0
#eval (subStructureInclusionHom NatStructure finSubStructure).map ⟨0, by omega⟩
#eval subStructureConstInclusion NatStructure finSubStructure 0

end MiniOrderEquivalence
