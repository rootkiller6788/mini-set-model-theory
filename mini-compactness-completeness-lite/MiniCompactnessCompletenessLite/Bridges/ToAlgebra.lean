/-
# Bridge to Algebra: Model Theory of Algebraic Structures

Birkhoff's HSP theorem characterizes varieties (equational classes)
as classes closed under homomorphic images, subalgebras, and products.
Model theory provides the tools for studying algebraic structures
from a logical perspective: quantifier elimination, model-completeness,
and the compactness theorem applied to algebra.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Core.Laws

namespace MiniCompactnessCompletenessLite

/-! ## Birkhoff's HSP Theorem -/

def birkhoffHSPStatement : String :=
  "Birkhoff's HSP theorem: A class of algebras is a variety (equationally axiomatizable) iff it is closed under Homomorphic images, Subalgebras, and Products."

def varietyDefinition : String :=
  "A variety is an equational class: a class of algebras defined by a set of identities (universally quantified equations)."

def equationalTheory : String :=
  "An equational theory consists of universally quantified equations t = s. Varieties correspond precisely to equational theories."

/-! ## Model Theory of Groups -/

def groupTheoryStatement : String :=
  "The theory of groups in the language {·, 1, ⁻¹} is not complete. Different groups can be elementarily inequivalent (e.g., abelian vs non-abelian)."

def divModelTheoryGroups : String :=
  "Divisible abelian groups have quantifier elimination. Divisible ordered abelian groups are model-complete."

def freeGroupTheory : String :=
  "Non-abelian free groups of different finite ranks are elementarily equivalent (Sela, Kharlampovich-Myasnikov). They are stable (Sela)."

/-! ## Model Theory of Fields -/

def fieldTheoryStatement : String :=
  "ACF has quantifier elimination. ACFp is complete for each p (prime or 0). The compactness theorem applied to ACF yields the Lefschetz principle."

def lefschetzPrinciple : String :=
  "Lefschetz principle: A first-order sentence true in ACF0 is true in ACFp for all sufficiently large primes p. This follows from compactness (or ultraproducts)."

def axGrothendieckTheorem : String :=
  "Ax-Grothendieck: Every injective polynomial map Cⁿ → Cⁿ is surjective. Proved by model theory of finite fields + compactness."

/-! ## Model Theory of Modules -/

def moduleTheoryStatement : String :=
  "The theory of R-modules (for a fixed ring R) is axiomatizable in first-order logic. The model theory of modules reduces to the study of positive-primitive formulas."

def zieglerSpectrum : String :=
  "Ziegler's spectrum: the topological space of indecomposable pure-injective R-modules. Closed sets correspond to theories of modules."

def pureInjectiveModels : String :=
  "Pure-injective modules are the model-theoretic analogue of injective modules. Every module has a pure-injective hull."

/-! ## Compactness in Algebra -/

def malcevLocalTheorems : String :=
  "Malcev's local theorems: If a property is finitely axiomatizable and holds for all finitely generated subgroups, it holds for the whole group (via compactness)."

def compactnessInAlgebra : String :=
  "Compactness allows proving properties of infinite algebraic structures from their finite substructures. Examples: Malcev's theorem on linear groups, residual finiteness results."

--- #eval ---

#eval birkhoffHSPStatement : String

#eval lefschetzPrinciple : String

#eval axGrothendieckTheorem : String

#eval compactnessInAlgebra : String

#eval zieglerSpectrum : String

end MiniCompactnessCompletenessLite
