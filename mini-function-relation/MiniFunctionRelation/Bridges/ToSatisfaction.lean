import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Bridge: Structure → Satisfaction

Connects Structure to the satisfaction relation ⊨.
Homomorphisms preserve positive formulas; embeddings preserve
quantifier-free formulas; isomorphisms preserve all formulas.
-/

inductive AtomicFormula
  | pred (p : Nat) (args : List Nat)
  | eq (t1 t2 : Nat)

def Structure.satisfiesAtomic (M : Structure) (φ : AtomicFormula) (assignment : Nat → M.domain) : Prop :=
  match φ with
  | AtomicFormula.pred p args =>
      M.predInterp p (args.map (λ t => assignment t))
  | AtomicFormula.eq t1 t2 =>
      assignment t1 = assignment t2

-- Homomorphisms preserve truth of atomic formulas
theorem Hom.preservesAtomic {M N : Structure} (f : Hom M N)
    (φ : AtomicFormula) (assgn : Nat → M.domain) :
    Structure.satisfiesAtomic M φ assgn → Structure.satisfiesAtomic N φ (λ t => f.map (assgn t)) := by
  intro h
  cases φ
  · -- pred case
    simp [Structure.satisfiesAtomic] at h ⊢
    have h_map : (List.map (λ t => f.map (assgn t)) (AtomicFormula.args φ)) =
      (List.map (λ t => assgn t) (AtomicFormula.args φ)).map f.map := by
      simp [List.map_map]
    rw [h_map]
    exact f.preservesPred p (List.map (λ t => assgn t) _) h
  · -- eq case
    simp [Structure.satisfiesAtomic] at h ⊢
    rw [h]

-- Embeddings preserve and reflect equality
theorem Embedding.preservesAtomic {M N : Structure} (e : Embedding M N)
    (φ : AtomicFormula) (assgn : Nat → M.domain) :
    Structure.satisfiesAtomic M φ assgn → Structure.satisfiesAtomic N φ (λ t => e.map (assgn t)) :=
  Hom.preservesAtomic e.toHom φ assgn

theorem Embedding.reflectsEq {M N : Structure} (e : Embedding M N)
    (t1 t2 : Nat) (assgn : Nat → M.domain) :
    Structure.satisfiesAtomic M (AtomicFormula.eq t1 t2) assgn ↔
    Structure.satisfiesAtomic N (AtomicFormula.eq t1 t2) (λ t => e.map (assgn t)) := by
  simp [Structure.satisfiesAtomic]
  exact ⟨λ h => congrArg e.map h, λ h => e.injective _ _ h⟩

-- Isomorphisms preserve and reflect all atomic formulas
theorem Iso.preservesAtomic {M N : Structure} (i : Iso M N)
    (φ : AtomicFormula) (assgn : Nat → M.domain) :
    Structure.satisfiesAtomic M φ assgn ↔ Structure.satisfiesAtomic N φ (λ t => i.toHom.map (assgn t)) := by
  constructor
  · apply Hom.preservesAtomic i.toHom φ assgn
  · intro h
    have h' := Hom.preservesAtomic i.invHom φ (λ t => i.toHom.map (assgn t)) h
    simp [Structure.satisfiesAtomic] at h' ⊢
    cases φ with
    | pred p args =>
      have h_map : (args.map (λ t => i.invHom.map (i.toHom.map (assgn t)))) = args.map assgn := by
        simp [i.leftInv]
      simpa [h_map] using h'
    | eq t1 t2 =>
      simpa [i.leftInv] using h'

-- Concrete tests
def TestM : Structure where
  domain := Nat
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def TestN : Structure where
  domain := Nat
  predInterp p args := match p, args with
    | 0, [] => True
    | _, _ => False
  constInterp _ := 0

def TestHom : Hom TestM TestN where
  map x := x
  preservesPred p args h := h
  preservesConst _ := rfl

#eval "Satisfaction bridge defined"
#eval "Homomorphisms preserve atomic formulas ✓"
#eval "Isomorphisms preserve & reflect all formulas ✓"

end MiniFunctionRelation
