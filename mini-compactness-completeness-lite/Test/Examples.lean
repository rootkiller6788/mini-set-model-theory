/-
# Example Tests for MiniCompactnessCompletenessLite

Tests for structural and classification examples.
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

--- Finite structures ---
#eval finiteStructure 3 : MiniFunctionRelation.Structure

--- Classifiable theory ---
#eval ClassifiableTheory.mk "ACF0" true "2^ℵ₀" : ClassifiableTheory

--- Decidability ---
#eval isDecidable "RCF"
#eval isDecidable "ZFC"

--- Type spaces ---
#eval typeSpace "T" 3
#eval basicOpenSet "φ(x)"

--- Classification data ---
#eval dloClassificationData
#eval acf0ClassificationData
#eval acfpClassificationData

--- Theory operations ---
#eval testTheory : Theory
#eval emptyTheory : Theory
#eval areDisjoint testSubtheory emptyTheory : Prop
#eval isExtension testExt testExt : Prop

--- Lindenbaum algebra ---
#eval lindenbaumTop : LindenbaumElement
#eval lindenbaumAlgebraOf testSubtheory : String

--- Standard examples ---
#eval dloProperties : List String
#eval rcfProperties : List String
#eval randomGraphAxioms : List String

--- Interpretability ---
#eval testInterp : Interpretation testTheoryT testTheoryS
#eval relativeInterpretation testTheoryT testTheoryT : Prop
#eval moritaEquivalenceStatement : String
#eval dloDegree.name : String

--- Universal ---
#eval freeTheoryProperty : String
#eval terminalTheoryProperty : String

--- Preservation ---
#eval ultrapower : String
#eval categoricalExamples : List String

--- Stability ---
#eval forkingIndependenceStatement : String
#eval orderPropertyStatement : String
