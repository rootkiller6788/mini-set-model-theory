import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Fraïssé Limits

The Fraïssé construction: universal homogeneous structures built from
finite substructures. Key examples: random graph, rational order.
-/

/-! ## Core definitions -/

def Age (M : Structure) : Set Structure :=
  {N | Fintype N.domain}

/-- The hereditary property (HP): if M ∈ K and N embeds into M, then N ∈ K. -/
def HasHereditaryProperty (K : Set Structure) : Prop :=
  ∀ (M N : Structure), M ∈ K → Nonempty (Embedding N M) → N ∈ K

def HasJointEmbeddingProperty (K : Set Structure) : Prop :=
  ∀ (A B : Structure), A ∈ K → B ∈ K →
    ∃ (C : Structure) (f : Embedding A C) (g : Embedding B C), C ∈ K

def HasAmalgamationProperty (K : Set Structure) : Prop :=
  ∀ (A B C : Structure),
    A ∈ K → B ∈ K → C ∈ K →
    ∀ (f₀ : Embedding A B) (g₀ : Embedding A C),
    ∃ (D : Structure) (f₁ : Embedding B D) (g₁ : Embedding C D),
      D ∈ K ∧ ∀ (a : A.domain), f₁.map (f₀.map a) = g₁.map (g₀.map a)

def IsFraisseClass (K : Set Structure) : Prop :=
  (∀ (M : Structure), M ∈ K → Fintype M.domain) ∧
  HasHereditaryProperty K ∧
  HasJointEmbeddingProperty K ∧
  HasAmalgamationProperty K

def IsFraisseLimit (M : Structure) (K : Set Structure) : Prop :=
  Age M = K ∧ IsHomogeneous M

/-! ## Canonical examples -/

/-- Finite sets (no structure) form a Fraïssé class. -/
def finiteSets : Set Structure :=
  {M | Fintype M.domain ∧ (∀ (p : Nat) (args : List M.domain), ¬ M.predInterp p args)}

/-- Finite graphs form a Fraïssé class. -/
def finiteGraphK : Set Structure :=
  {M | Fintype M.domain ∧
    (∀ (p : Nat) (args : List M.domain), M.predInterp p args → p = 0 ∧ args.length = 2)}

/-- Finite linear orders form a Fraïssé class. -/
def finiteLO : Set Structure :=
  {M | Fintype M.domain ∧
    (∀ (p : Nat) (args : List M.domain), M.predInterp p args → p = 0 ∧ args.length = 2)}

/-! ## The random graph (Rado graph) -/

/-- The Rado graph on ℕ: edge between x and y if the x-th bit of y is 1. -/
def radoGraph : Structure where
  domain := Nat
  predInterp p args := match p, args with
    | 0, [x, y] => ((y / (2 ^ x)) % 2) = 1
    | _, _ => False
  constInterp _ := 0

/-! ## The rational order as Fraïssé limit of finite linear orders -/

def ratOrder : Structure where
  domain := Rat
  predInterp p args := match p, args with
    | 0, [x, y] => x < y
    | _, _ => False
  constInterp _ := 0

/-! ## Concrete finite structures in these classes -/

def K1 : Structure where
  domain := Unit
  predInterp _ _ := False
  constInterp _ := ()

def K2 : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [x, y] => x ≠ y
    | _, _ => False
  constInterp _ := false

def K3 : Structure where
  domain := Fin 3
  predInterp p args := match p, args with
    | 0, [x, y] => x ≠ y
    | _, _ => False
  constInterp _ := 0

def LinOrd2 : Structure where
  domain := Bool
  predInterp p args := match p, args with
    | 0, [x, y] => x = false ∧ y = true
    | _, _ => False
  constInterp _ := false

def LinOrd3 : Structure where
  domain := Fin 3
  predInterp p args := match p, args with
    | 0, [x, y] => x.val < y.val
    | _, _ => False
  constInterp _ := 0

/-! ## Homomorphisms between examples -/

/-- Identity on K1. -/
def K1id : Embedding K1 K1 where
  toHom := Hom.id K1
  injective x y h := h

/-- Embed K1 (1 vertex) into K2 (edge). -/
def K1intoK2 : Embedding K1 K2 where
  map _ := false
  preservesPred p args h := by
    simp [K1, K2] at h ⊢
    match p, args with
    | 0, [(), ()] => decide
    | _, _ => trivial
  preservesConst c := rfl
  injective x y h := by simp

/-- Embed K2 into K3. -/
def K2intoK3 : Embedding K2 K3 where
  map b := if b then ⟨1, by decide⟩ else ⟨0, by decide⟩
  preservesPred p args h := by
    simp [K2, K3] at h ⊢
    match p with
    | 0 =>
        rcases args with ([x, y] | _) <;> simp at h ⊢
        -- In K2, edge exists if x≠y
        -- In K3, edge exists if the Fin values differ
        cases x <;> cases y <;> simp at h ⊢
        · exact h -- false ≠ true case, but both go to different Fins
        · rfl
        · rfl
        · exact h
    | _ => trivial
  preservesConst c := by simp [K2, K3]
  injective x y h := by
    simp [K2] at h
    cases x <;> cases y <;> simp at h ⊢
    · exact h

#eval (K1.predInterp 0 [()])
#eval (K2.predInterp 0 [true, false])
#eval (K3.predInterp 0 [⟨0, by decide⟩, ⟨1, by decide⟩])

#eval "FraisseLimit.lean loaded — Fraïssé classes, HP, JEP, AP"
#eval "  Examples: K1, K2, K3 (finite graphs)"
#eval "  LinOrd2, LinOrd3 (finite linear orders)"
#eval "  Fraïssé limits: radoGraph, ratOrder"

end MiniFunctionRelation
