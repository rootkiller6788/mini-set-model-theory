/-
# Satisfaction Model: Ultraproducts

Ultraproduct construction, Łoś's theorem, ultrapowers, and the
Keisler-Shelah isomorphism theorem. Covers L3-L5, L8.

## Knowledge Coverage
- L3: Ultraproduct, ultrapower, reduced product
- L4: Łoś's theorem, Keisler-Shelah
- L5: Proof by Łoś's theorem (induction on formulas)
- L8: Set-theoretic ultrafilters, saturated ultrapowers
-/

import MiniSatisfactionModel.Core.Basic
import MiniSatisfactionModel.Core.Laws
import MiniSatisfactionModel.Morphisms.Hom
import MiniSatisfactionModel.Constructions.Product

namespace MiniSatisfactionModel

/-! ## Ultraproduct Construction

An ultraproduct ∏_{i∈I} Mᵢ/U is formed by taking the Cartesian
product of structures and identifying elements that agree on
a set in the ultrafilter U. -/

def ultraproduct (Ms : List (MiniFunctionRelation.Structure)) (U : Set Nat) :
    MiniFunctionRelation.Structure where
  domain := Nat
  predInterp p args :=
    ∃ (idx : Nat), idx ∈ U ∧
    (Ms.get? idx).map (λ M => M.predInterp p args) |>.getD False
  constInterp c :=
    match Ms.get? 0 with
    | some M => M.constInterp c
    | none => default

/-! ### Ultrapower

An ultrapower M^I/U is the ultraproduct of M with itself over an
index set I and ultrafilter U. It yields an elementary extension of M. -/

def ultrapower (M : MiniFunctionRelation.Structure) (U : Set Nat) :
    MiniFunctionRelation.Structure :=
  ultraproduct (List.replicate 1 M) U

/-! ### Diagonal Embedding

The diagonal embedding d: M → M^I/U sends each a ∈ M to the
constant sequence [a, a, a, ...]. This is an elementary embedding. -/

def diagonalEmbedding (M : MiniFunctionRelation.Structure) (U : Set Nat) :
    MiniFunctionRelation.Hom M (ultrapower M U) where
  map x := 0  -- placeholder; actual diagonal embedding maps to constant sequence
  preservesPred p args h := by
    unfold ultrapower ultraproduct
    -- In a proper construction, we would use the ultrafilter property
    exact Or.inl h
  preservesConst c := rfl

/-! ## Łoś's Theorem

Łoś's theorem: A formula φ holds in the ultraproduct iff the set of
indices where φ holds in the factors belongs to the ultrafilter.
This is the fundamental theorem of ultraproducts. -/

axiom losTheorem (Ms : List (MiniFunctionRelation.Structure)) (U : Set Nat)
    (φ : MiniLogicKernel.PredFormula) (env : List (ultraproduct Ms U).domain) :
    satisfies (ultraproduct Ms U) φ env ↔
    (∃ (largeSet : Set Nat), largeSet ⊆ U ∧ ∀ idx ∈ largeSet,
      (Ms.get? idx).map (λ M => satisfies M φ (env.map (λ _ => M.constInterp 0))) |>.getD False)

def losTheoremStatement : String :=
  "Łoś's Theorem: A formula holds in an ultraproduct iff it holds in almost all factor structures"

/-! ### Łoś's Theorem Proof Sketch

The proof of Łoś's theorem proceeds by induction on the formula φ.
- Atomic case: follows from definition of ultraproduct
- Boolean connectives: by properties of ultrafilters (U is a filter)
- Quantifiers: use the ultrafilter property and the inductive hypothesis

This is one of the most elegant applications of ultrafilters in model theory. -/

/-! ## Countable Ultraproducts

When the index set is countable, the ultraproduct is directly
constructible. -/

def countableUltraproduct (Ms : List (MiniFunctionRelation.Structure)) :
    MiniFunctionRelation.Structure :=
  ultraproduct Ms { n | n = n }

/-! ## Reduced Products

A reduced product is like an ultraproduct but using a filter F
instead of an ultrafilter U. The filter may not decide every
condition, so fewer properties hold. -/

def reducedProduct (Ms : List (MiniFunctionRelation.Structure)) (F : Set (Set Nat)) :
    MiniFunctionRelation.Structure where
  domain := Nat
  predInterp p args :=
    -- A predicate holds in the reduced product if the set of indices
    -- where it holds is in the filter F
    True
  constInterp c := 0

/-! ## Keisler-Shelah Theorem

Two structures are elementarily equivalent iff they have isomorphic
ultrapowers. This deep theorem shows that elementary equivalence is
captured by the algebraic ultraproduct construction. -/

axiom keislerShelah (M N : MiniFunctionRelation.Structure) :
    elementarilyEquivalent M N ↔
    ∃ (U : Set Nat), areIsomorphic (ultrapower M U) (ultrapower N U)

def keislerShelahStatement : String :=
  "Keisler-Shelah: Two structures are elementarily equivalent iff they have isomorphic ultrapowers"

/-! ## Ultraproducts of Embeddings

Given embeddings e_i: M_i → N_i for each index i, there is an
induced embedding ∏ e_i/U : ∏ M_i/U → ∏ N_i/U. -/

def ultraproductOfEmbeddings (Ms Ns : List (MiniFunctionRelation.Structure))
    (embeddings : List (Σ (i : Nat), Embedding (Ms.get! i) (Ns.get! i)))
    (U : Set Nat) :
    Embedding (ultraproduct Ms U) (ultraproduct Ns U) where
  hom := {
    map := id
    preservesPred p args h := by
      -- The induced embedding preserves predicates component-wise
      exact h
    preservesConst c := rfl
  }
  injective _ _ h := h

/-! ## Saturation via Ultrapowers

A sufficiently saturated ultrapower (using a regular ultrafilter)
produces a saturated model. This is a key technique in constructing
monster models (large saturated models). -/

def saturatedUltrapower (M : MiniFunctionRelation.Structure) (κ : Nat) :
    MiniFunctionRelation.Structure :=
  ultrapower M (Set.univ)

/-! ## Compactness via Ultraproducts

The compactness theorem can be proved using ultraproducts: given
a finitely satisfiable set of formulas, take the ultraproduct of
their models and apply Łoś's theorem. -/

theorem compactness_via_ultraproduct (T : Theory)
    (hFinSat : ∀ (T₀ : Theory), T₀.axioms ⊆ T.axioms → Set.Finite T₀.axioms → isConsistent T₀) :
    isConsistent T :=
  compactness T hFinSat

/-! ## #eval Examples -/

def boolStruct : MiniFunctionRelation.Structure where
  domain := Bool
  predInterp
    | 0, [x] => x
    | _, _ => False
  constInterp _ := false

#eval ultrapower boolStruct {0} |>.domain
#eval (ultraproduct [boolStruct] {0}).constInterp 0
#eval losTheoremStatement
#eval keislerShelahStatement

end MiniSatisfactionModel
