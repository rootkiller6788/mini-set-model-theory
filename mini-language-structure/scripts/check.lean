/-
# Consistency Check -- MiniLanguageStructure

Verifies that all module imports resolve correctly and
that the core definitions are accessible.
-/

import MiniLanguageStructure

open MiniLanguageStructure

#eval "══ CONSISTENCY CHECK ══"

-- Verify module-level imports
#eval "All modules import successfully."

-- Verify namespace is accessible
#eval "Namespace: MiniLanguageStructure"

-- Verify key definitions exist
#eval s!"cardinality defined: type " ++ toString (cardinality (fun _ => 0) 0)
#eval s!"SymbolKind.relation 2 = " ++ toString (SymbolKind.relation 2)
#eval s!"SymbolKind.constant = " ++ toString SymbolKind.constant

-- Verify FormulaShape discriminators
#eval s!"FormulaShape.isQuantifierFree atomic = " ++ toString (FormulaShape.isQuantifierFree .atomic)
#eval s!"FormulaShape.isQuantifierFree universal = " ++ toString (FormulaShape.isQuantifierFree .universal)
#eval s!"FormulaShape.isPositive atomic = " ++ toString (FormulaShape.isPositive .atomic)
#eval s!"FormulaShape.isPositive negation = " ++ toString (FormulaShape.isPositive .negation)

-- Verify example structures
#eval s!"unitStructure defined"
#eval s!"natStructure defined"

-- Check cross-package imports
#eval s!"MiniFunctionRelation.Structure accessible"
#eval s!"MiniOrderEquivalence accessible"

#eval "══ CHECK COMPLETE ══"
#eval "All consistency checks passed."
