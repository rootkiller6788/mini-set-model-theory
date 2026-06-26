/-
# Cardinal Ordinal: Cardinal and Ordinal Numbers

Cardinal and ordinal types with basic arithmetic operations.
-/

import MiniCardinalOrdinal.Core.Basic

namespace MiniCardinalOrdinal

/-! ## Cardinal Numbers -/

structure Cardinal where
  alephIndex : Nat
  deriving BEq, Repr, Inhabited

instance : ToString Cardinal where
  toString
    | ⟨0⟩ => "ℵ₀"
    | ⟨n⟩ => s!"ℵ_{n}"

def Cardinal.alephZero : Cardinal := ⟨0⟩
def Cardinal.alephOne : Cardinal := ⟨1⟩

def Cardinal.add (a b : Cardinal) : Cardinal :=
  if a.alephIndex ≥ b.alephIndex then a else b

def Cardinal.mul (a b : Cardinal) : Cardinal :=
  if a.alephIndex ≥ b.alephIndex then a else b

def Cardinal.exp (a b : Cardinal) : Cardinal :=
  if b.alephIndex = 0 then ⟨1⟩
  else if a.alephIndex ≥ b.alephIndex then ⟨a.alephIndex + 1⟩
  else ⟨a.alephIndex + b.alephIndex⟩

def Cardinal.succ (a : Cardinal) : Cardinal := ⟨a.alephIndex + 1⟩

def Cardinal.isLimit (a : Cardinal) : Bool :=
  a.alephIndex = 0

/-! ## Ordinal Numbers -/

inductive Ordinal where
  | zero : Ordinal
  | succ : Ordinal → Ordinal
  | limit : (Nat → Ordinal) → Ordinal
  deriving Inhabited

instance : OfNat Ordinal 0 where
  ofNat := .zero

def Ordinal.add : Ordinal → Ordinal → Ordinal
  | .zero, b => b
  | .succ a, b => .succ (add a b)
  | .limit f, b => .limit (fun n => add (f n) b)

def Ordinal.mul : Ordinal → Ordinal → Ordinal
  | .zero, _ => .zero
  | .succ a, b => Ordinal.add (mul a b) b
  | .limit f, b => .limit (fun n => mul (f n) b)

def Ordinal.omega : Ordinal :=
  .limit (fun n => Nat.recOn n .zero (fun _ ih => .succ ih))

/-! ## Basic Cardinal-Ordinal Relations -/

def Cardinal.toOrdinal : Cardinal → Ordinal
  | ⟨0⟩ => Ordinal.omega
  | ⟨n+1⟩ => .limit (fun _ => Cardinal.toOrdinal ⟨n⟩)

def isRegularCardinal (κ : Cardinal) : Prop := True
def isStrongLimit (κ : Cardinal) : Prop := True
def isInaccessible (κ : Cardinal) : Prop :=
  isRegularCardinal κ ∧ isStrongLimit κ

def continuumFunction (κ : Cardinal) : Cardinal :=
  κ.exp ⟨1⟩

/-! ## Cardinality Comparisons -/

def Cardinal.eq (a b : Cardinal) : Bool :=
  a.alephIndex == b.alephIndex

def Cardinal.le (a b : Cardinal) : Bool :=
  a.alephIndex ≤ b.alephIndex

def Cardinal.lt (a b : Cardinal) : Bool :=
  a.alephIndex < b.alephIndex

/-! ## Stability Spectrum Parameters -/

def stabilitySpectrum (T : Theory) (κ : Cardinal) : StabilityClass :=
  StabilityClass.stable

def isStableInPower (T : Theory) (κ : Cardinal) : Prop := True
def hasOrderProperty (T : Theory) : Prop := True
def hasIndependenceProperty (T : Theory) : Prop := True

end MiniCardinalOrdinal
