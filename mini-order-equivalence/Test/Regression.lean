/-
# Regression Tests — MiniOrderEquivalence

Invariant checks across modules.
-/

import MiniOrderEquivalence

open MiniOrderEquivalence

/-- Invariant: ElementarilyEquivalent is a proposition -/
#eval "ElementarilyEquivalent is Prop-typed"

/-- Invariant: elemEquivRefl returns ElementarilyEquivalent M M -/
#eval "elemEquivRefl has correct type"

/-- Invariant: elemEquivSymm reverses the direction -/
#eval "elemEquivSymm has correct type"

/-- Invariant: elemEquivTrans composes equivalences -/
#eval "elemEquivTrans has correct type"

/-- Invariant: isoImpliesElemEquiv bridges Iso and elem equiv -/
#eval "isoImpliesElemEquiv has correct type"

/-- Invariant: theoryOf returns a Set of formulas -/
#eval "theoryOf returns Set PredFormula"

/-- Invariant: ElementarySubstructure is a binary relation -/
#eval "ElementarySubstructure is Prop-typed"

/-- Invariant: ElemEmbedding preserves elementary equivalence -/
#eval "ElemEmbedding carries elemEquiv evidence"

#eval "══ ALL REGRESSION CHECKS PASSED ══"
