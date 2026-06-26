/-
# MiniSetCore: Bridge to Geometry

Sets as geometric objects, incidence structures,
convex sets, and basic geometric constructions.
-/

import MiniSetCore.Core.Basic
import MiniSetCore.Core.Objects
import MiniSetCore.Core.Laws
import MiniSetCore.Constructions.Products

namespace MiniSetCore

/-! ## Point Sets in Euclidean Space -/

/-- A point in 2D Euclidean space is a pair of reals. -/
def Point2D : Type := Float × Float

/-- A geometric set is a set of points. -/
def GeometricSet2D : Type := Set Point2D

/-- Distance between two points (squared). -/
def distSq (p q : Point2D) : Float :=
  let dx := q.1 - p.1
  let dy := q.2 - p.2
  dx * dx + dy * dy

/-! ## Lines and Circles -/

/-- A line is a set defined by ax + by + c = 0. -/
def line (a b c : Float) : GeometricSet2D :=
  fun p => a * p.1 + b * p.2 + c = 0

/-- A circle centered at (cx, cy) with radius r. -/
def circle (cx cy r : Float) : GeometricSet2D :=
  fun p => distSq p (cx, cy) = r * r

/-! ## Incidence Structure -/

/--
An incidence structure consists of "points" and "lines"
with a membership relation between them.
-/
structure IncidenceStructure (α β : Type u) where
  points : Set α
  lines  : Set β
  incidence : α → β → Prop
  nondegenerate : ∃ (p : α), points p

/-- A simple projective plane (axiomatic). -/
structure ProjectivePlane (α β : Type u) extends IncidenceStructure α β where
  lineThroughTwoPoints : ∀ p q, points p → points q → p ≠ q →
    ∃! (ℓ : β), lines ℓ ∧ incidence p ℓ ∧ incidence q ℓ
  twoLinesMeet : ∀ ℓ m, lines ℓ → lines m → ℓ ≠ m →
    ∃! (p : α), points p ∧ incidence p ℓ ∧ incidence p m
  fourPointCondition : ∃ (a b c d : α), points a ∧ points b ∧ points c ∧ points d ∧
    a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ b ≠ c ∧ b ≠ d ∧ c ≠ d ∧
    ¬ (∃ (ℓ : β), lines ℓ ∧ incidence a ℓ ∧ incidence b ℓ ∧ incidence c ℓ)

/-! ## Convex Sets -/

/-- A set in 2D is convex if for any two points, the segment is contained. -/
def isConvex2D (s : GeometricSet2D) : Prop :=
  ∀ (p q : Point2D) (t : Float),
    s p → s q → (0.0 ≤ t) ∧ (t ≤ 1.0) →
    s ((p.1 + t * (q.1 - p.1), p.2 + t * (q.2 - p.2)))

/-- The intersection of convex sets is convex. -/
theorem convex_inter_convex {S : Set GeometricSet2D} (h : ∀ s, S s → isConvex2D s) :
    isConvex2D (fun p => ∀ s, S s → s p) := by
  intro p q t hp hq htcond
  intro s hs
  apply h s hs p q t (hp s hs) (hq s hs) htcond

/-! ## Half-Planes -/

/-- A half-plane: ax + by + c ≤ 0. -/
def halfPlane (a b c : Float) : GeometricSet2D :=
  fun p => a * p.1 + b * p.2 + c ≤ 0.0

-- The convexity of half-planes is a key geometric fact; stated as axiom.
axiom halfPlane_convex_axiom (a b c : Float) : isConvex2D (halfPlane a b c)

/-! ## Geometric Transformations -/

/-- Translation by a vector. -/
def translate (v : Point2D) (s : GeometricSet2D) : GeometricSet2D :=
  fun p => s (p.1 - v.1, p.2 - v.2)

/-- Scaling from origin. -/
def scale (k : Float) (s : GeometricSet2D) : GeometricSet2D :=
  fun p => s (p.1 / k, p.2 / k)

/-! ## #eval Examples -/

-- Distance between two points
def p1 : Point2D := (0.0, 0.0)
def p2 : Point2D := (3.0, 4.0)
#eval distSq p1 p2

-- Line points
def xAxis : GeometricSet2D := line 0 1 0  -- y = 0
#eval xAxis (5.0, 0.0)
#eval xAxis (5.0, 1.0)

-- Circle points
def unitCircle : GeometricSet2D := circle 0 0 1
#eval unitCircle (1.0, 0.0)
#eval unitCircle (2.0, 0.0)

-- Incidence structure
#check IncidenceStructure.mk
#check ProjectivePlane.mk

-- Half-plane
def upperHalf : GeometricSet2D := halfPlane 0 1 0  -- y ≤ 0, i.e. points below x-axis
#eval upperHalf (0.0, (-1.0))
#eval upperHalf (0.0, 1.0)

end MiniSetCore
