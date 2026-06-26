/-
# MiniZFCLite: Constructions — Product

Product of set models, disjoint union of set structures, and
related model-theoretic constructions.
-/

import MiniZFCLite.Core.Basic

namespace MiniZFCLite

/-! ## Product of Set Structures -/

/-- A set structure is a carrier with an epsilon relation -/
structure SetModel where
  domain : Type
  membership : domain → domain → Prop
  deriving Inhabited, Repr

/-- The product of two set structures: elements are pairs,
membership holds coordinatewise -/
def productModel (M N : SetModel) : SetModel :=
  { domain := M.domain × N.domain
    membership := fun (m1, n1) (m2, n2) =>
      M.membership m1 m2 ∧ N.membership n1 n2 }

/-- First projection from product model -/
def productFst {M N : SetModel} : (productModel M N).domain → M.domain :=
  fun (m, _) => m

/-- Second projection from product model -/
def productSnd {M N : SetModel} : (productModel M N).domain → N.domain :=
  fun (_, n) => n

/-! ## Disjoint Union of Set Models -/

/-- Tagged union: elements prefixed by left/right tag -/
inductive Tagged (α β : Type) : Type where
  | inl : α → Tagged α β
  | inr : β → Tagged α β
  deriving Repr, Inhabited

/-- The disjoint union of two set structures -/
def disjointUnionModel (M N : SetModel) : SetModel where
  domain := Tagged M.domain N.domain
  membership := fun t1 t2 =>
    match t1, t2 with
    | .inl m1, .inl m2 => M.membership m1 m2
    | .inr n1, .inr n2 => N.membership n1 n2
    | _, _ => False

/-! ## Product of Axiom Systems -/

/-- The conjunction of two axiom systems: M×N models A iff M models A and N models A -/
structure AxiomProduct where
  sys1 : String
  sys2 : String
  combinedAxioms : String
  modelProperty : String
  deriving Repr

/-- ZF × AC = ZFC (conceptually) -/
def zfProductAC : AxiomProduct :=
  { sys1 := "ZF"
    sys2 := "AC"
    combinedAxioms := "ZF ∪ {AC}"
    modelProperty := "M ⊨ ZF and M ⊨ AC iff M ⊨ ZFC" }

/-! ## Finite Products -/

/-- Product of a list of set models -/
def productList : List SetModel → SetModel
  | [] => { domain := Unit, membership := fun _ _ => False }
  | [m] => m
  | m :: ms => productModel m (productList ms)

/-! ## Ultraproduct (simplified) -/

/-- An ultraproduct collapses models modulo an ultrafilter -/
structure UltraproductInfo where
  indexSet : String
  models : String
  ultrafilter : String
  properties : String
  deriving Repr

/-- Los's theorem: ultraproducts preserve first-order truth -/
def losTheorem : UltraproductInfo :=
  { indexSet := "I"
    models := "{M_i : i ∈ I}"
    ultrafilter := "U (ultrafilter on I)"
    properties := "∏_U M_i ⊨ φ iff {i : M_i ⊨ φ} ∈ U" }

/-! ## Concrete Examples -/

/-- A minimal model with empty domain -/
def emptySetModel : SetModel :=
  { domain := Empty
    membership := fun _ _ => False }

/-- A singleton model -/
def singletonSetModel : SetModel :=
  { domain := Unit
    membership := fun _ _ => False }

/-- The product of empty and singleton -/
def productExample : SetModel := productModel emptySetModel singletonSetModel

/-! ## Extended Example: ZFC Model Product -/

/-- Conceptual product: if M ⊨ ZFC and N ⊨ ZFC, the product inherits some structure -/
def zfcProductProperty : String :=
  "If M ⊨ ZFC and N ⊨ ZFC, then M×N |= extensionality (coordinatewise)"

#eval "Product: emptySetModel × singletonSetModel defined"
#eval zfProductAC.combinedAxioms
#eval losTheorem.properties
#eval zfcProductProperty
#eval "Product model: disjointUnionModel defined"
#eval "Constructions/Product module loaded"

end MiniZFCLite
