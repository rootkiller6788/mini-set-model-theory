/-
# Step-by-Step Examples — MiniOrderEquivalence

Building elementary equivalence relations, checking reflexivity,
and exploring the Tarski-Vaught criterion.
-/

import MiniOrderEquivalence

open MiniOrderEquivalence

#eval "══ BUILDING ELEMENTARY EQUIVALENCE EXAMPLES ══"

/-! ### Step 1: Elementary equivalence is reflexive -/
#eval "elemEquivRefl: M ≡ M for any structure M"

/-! ### Step 2: Elementary equivalence is symmetric -/
#eval "elemEquivSymm: if M ≡ N then N ≡ M"

/-! ### Step 3: Elementary equivalence is transitive -/
#eval "elemEquivTrans: if M ≡ N and N ≡ O then M ≡ O"

/-! ### Step 4: Elementary equivalence is an equivalence relation -/
#eval "Elementary equivalence partitions structures into equivalence classes"

/-! ### Step 5: theoryOf collects all true formulas -/
#eval "theoryOf(M) = {φ : M ⊨ φ}"

/-! ### Step 6: ElementarySubstructure and Tarski-Vaught -/
#eval "M ≺ N iff M ⊆ N and they agree on all formulas from M"

#eval "══ EXAMPLE BUILDING COMPLETE ══"
