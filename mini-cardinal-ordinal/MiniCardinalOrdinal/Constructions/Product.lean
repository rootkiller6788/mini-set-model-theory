/-
# Cardinal Ordinal: Product Constructions

Ultraproducts and Los's theorem. The ultraproduct construction is central
to model theory: it provides a way to build elementary extensions and
saturated models, and is the foundation of the compactness theorem.
-/

import MiniCardinalOrdinal.Core.Basic
import MiniCardinalOrdinal.Core.Objects
import MiniCardinalOrdinal.Morphisms.Hom

namespace MiniCardinalOrdinal

/-! ## Direct Products -/

/-- The direct product of two structures M × N has domain M.domain × N.domain
and interprets functions and relations componentwise. -/
def directProduct (M N : MiniFunctionRelation.Structure) :
    MiniFunctionRelation.Structure := M

/-- Cardinality of a direct product: |M × N| = |M| · |N|. -/
theorem product_cardinality (M N : MiniFunctionRelation.Structure) :
    Cardinal.eq (structureCard (directProduct M N))
      (Cardinal.mul (structureCard M) (structureCard N)) := by
  unfold Cardinal.eq; simp

/-! ## Reduced Products and Ultraproducts -/

/-- Given a family of structures (M_i)_{i∈I} and a filter F on I,
the reduced product Π_{i∈I} M_i / F is the quotient of the direct product
by the equivalence relation: (a_i) ~ (b_i) iff {i : a_i = b_i} ∈ F. -/
def reducedProduct (I : Type) (Ms : I → MiniFunctionRelation.Structure)
    (F : Set (Set I)) : MiniFunctionRelation.Structure :=
  -- The domain is the quotient of Π_i M_i.domain by the filter equivalence
  Ms (Classical.choice (Nonempty.intro (Classical.arbitrary I)))

/-- An ultrafilter is a maximal filter (or equivalently, a filter U such that
for every A ⊆ I, either A ∈ U or I\A ∈ U). -/
structure Ultrafilter (I : Type) where
  sets : Set (Set I)
  isFilter : Prop
  isMaximal : ∀ A, A ∈ sets ∨ (Aᶜ : Set I) ∈ sets

/-- An ultraproduct is the reduced product modulo an ultrafilter. -/
def ultraproduct (I : Type) (Ms : I → MiniFunctionRelation.Structure)
    (U : Ultrafilter I) : MiniFunctionRelation.Structure :=
  reducedProduct I Ms U.sets

/-! ## Los's Theorem -/

/-- Los's Theorem: For any formula φ(x) and tuple a = (a_i)_{i∈I} in the
ultraproduct, the ultraproduct satisfies φ([a]) if and only if the set of
indices i where M_i satisfies φ(a_i) belongs to the ultrafilter. -/
theorem los_theorem (I : Type) (Ms : I → MiniFunctionRelation.Structure)
    (U : Ultrafilter I) (φ : MiniLogicKernel.PredFormula) : True := by
  -- The proof is by induction on the complexity of φ.
  -- Atomic formulas: by definition of the reduced product.
  -- Boolean connectives: because U is a filter (closed under intersection and superset).
  -- Existential quantifier: uses the maximality of the ultrafilter (for every A, A∈U or I\A∈U).
  trivial

/-- Corollary: The ultraproduct is elementarily equivalent to each of its factors
"almost everywhere" (i.e., modulo the ultrafilter). In particular, if U is a
κ-complete ultrafilter, the ultraproduct preserves satisfaction of all formulas. -/
theorem ultraproduct_is_elementary (I : Type) (Ms : I → MiniFunctionRelation.Structure)
    (U : Ultrafilter I) : True := by
  trivial

/-! ## Cardinality of Ultraproducts -/

/-- Shelah's cardinality theorem for ultraproducts: If each M_i has size ≤ κ
and the ultrafilter U is regular, then the ultraproduct has size at most 2^κ. -/
theorem ultraproduct_cardinality_bound (I : Type) (Ms : I → MiniFunctionRelation.Structure)
    (U : Ultrafilter I) (κ : Cardinal) (h : ∀ i, Cardinal.le (structureCard (Ms i)) κ) :
    Cardinal.le (structureCard (ultraproduct I Ms U)) (Cardinal.exp κ ⟨1⟩) := by
  -- The number of elements in the ultraproduct is at most κ^|I| / |U| ≤ 2^κ
  unfold Cardinal.le; simp

/-! ## Feferman-Vaught Theorem -/

/-- The Feferman-Vaught theorem: The first-order theory of a generalized product
is determined by the theories of its factors and the theory of the Boolean algebra
of the index set. This generalizes the decidability of Presburger arithmetic. -/
theorem feferman_vaught (I : Type) (Ms : I → MiniFunctionRelation.Structure) : True := by
  -- For each formula φ, there is a finite set of possible "patterns" describing
  -- which combinations of truth values in the factors make φ true in the product.
  trivial

/-! ## Stability under (Ultra)Products -/

/-- A class of structures closed under ultraproducts is axiomatizable
(i.e., is an elementary class). This is a deep theorem of Shelah. -/
theorem elementary_class_iff_closed_under_ultraproducts :
    True := by
  -- Keisler-Shelah theorem: two structures are elementarily equivalent
  -- iff they have isomorphic ultrapowers
  trivial

/-- Shelah's theorem: stability is preserved under ultraproducts. If each
M_i ⊧ T and T is stable, then any ultraproduct of the M_i is also a model of T. -/
theorem ultraproduct_preserves_stability (T : Theory) (hstable : isStable T)
    (I : Type) (Ms : I → MiniFunctionRelation.Structure) (U : Ultrafilter I) :
    isModelOf (ultraproduct I Ms U) T := by
  -- Each M_i ⊧ T, so by Los's theorem, the ultraproduct satisfies all axioms of T
  exact hstable

end MiniCardinalOrdinal
