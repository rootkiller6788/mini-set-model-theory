import MiniFunctionRelation.Core.Basic
import MiniFunctionRelation.Morphisms.Hom
import MiniFunctionRelation.Morphisms.Iso

namespace MiniFunctionRelation

/-
# Dense Linear Orders

The theory of dense linear orders without endpoints.
(Q, <) is the unique countable model up to isomorphism (Cantor).
-/

-- Dense linear order structure
def DLOStructure (T : Type) (defaultElem : T) (lt : T → T → Prop) : Structure where
  domain := T
  predInterp p args := match p, args with
    | 0, [u, v] => lt u v
    | _, _ => False
  constInterp _ := defaultElem

-- Convenience for inhabited types
def DLOStructure' [Inhabited T] (T : Type) (lt : T → T → Prop) : Structure :=
  DLOStructure T (default : T) lt

-- The axioms: irreflexive, transitive, total, dense, no endpoints
def IsDLO (T : Type) (lt : T → T → Prop) : Prop :=
  (∀ x, ¬ lt x x) ∧                           -- irreflexive
  (∀ x y z, lt x y → lt y z → lt x z) ∧       -- transitive
  (∀ x y, lt x y ∨ x = y ∨ lt y x) ∧          -- total
  (∀ x y, lt x y → ∃ z, lt x z ∧ lt z y) ∧    -- dense
  (∀ x, ∃ y, lt y x) ∧                         -- no left endpoint
  (∀ x, ∃ y, lt x y)                            -- no right endpoint

-- Rational numbers as dense linear order
def RatDLO : Structure := DLOStructure ℚ (0 : ℚ) (· < ·)

-- Any two countable dense linear orders without endpoints are isomorphic
axiom cantorDLO :
  ∀ (T1 T2 : Type) (d1 : T1) (d2 : T2) (lt1 : T1 → T1 → Prop) (lt2 : T2 → T2 → Prop),
    IsDLO T1 lt1 → IsDLO T2 lt2 →
    (∃ (f : T1 → Nat), Function.Injective f) →
    (∃ (f : T2 → Nat), Function.Injective f) →
    Nonempty (Iso (DLOStructure T1 d1 lt1) (DLOStructure T2 d2 lt2))

-- Order-preserving bijection between countable DLOs is an isomorphism
def orderIsoToStructureIso {T1 T2 : Type} {d1 : T1} {d2 : T2}
    {lt1 : T1 → T1 → Prop} {lt2 : T2 → T2 → Prop}
    (f : T1 → T2) (hf : ∀ x y, lt1 x y ↔ lt2 (f x) (f y)) (hBij : Function.Bijective f) :
    Iso (DLOStructure T1 d1 lt1) (DLOStructure T2 d2 lt2) where
  toHom := {
    map := f
    preservesPred := by
      intro p args h
      dsimp [DLOStructure] at h ⊢
      cases p
      · cases args
        · trivial
        · rename_i a as
          cases as
          · trivial
          · rename_i b bs
            cases bs
            · exact (hf a b).mp h
            · trivial
      · trivial
    preservesConst _ := rfl
  }
  invHom := {
    map := Function.invFun f
    preservesPred := by
      intro p args h
      dsimp [DLOStructure] at h ⊢
      cases p
      · cases args
        · trivial
        · rename_i a as
          cases as
          · trivial
          · rename_i b bs
            cases bs
            · have h₁ : f (Function.invFun f a) = a := Function.invFun_eq (hBij.2 a)
              have h₂ : f (Function.invFun f b) = b := Function.invFun_eq (hBij.2 b)
              apply (hf (Function.invFun f a) (Function.invFun f b)).mpr
              simpa [h₁, h₂] using h
            · trivial
      · trivial
    preservesConst _ := rfl
  }
  leftInv x := Function.invFun_eq (hBij.1 x)
  rightInv y := Function.invFun_eq (hBij.2 y)

-- Concrete test with a finite DLO approximation
def FiveDLO : Structure where
  domain := Fin 5
  predInterp p args := match p, args with
    | 0, [u, v] => u.val < v.val
    | _, _ => False
  constInterp _ := 0

#eval "Dense Linear Order structure defined"
#eval (RatDLO.predInterp 0 [(3 : ℚ), (7 : ℚ)])
#eval "Cantor's theorem: any two countable DLOs are isomorphic"

end MiniFunctionRelation
