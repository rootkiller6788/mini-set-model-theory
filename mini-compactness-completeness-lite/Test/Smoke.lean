/-
# Smoke Tests for MiniCompactnessCompletenessLite

Verifies that all core definitions are accessible and evaluate.
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

--- Core Theorems ---
#eval compactnessStatement
#eval compactnessCountable
#eval completenessTheorem
#eval downwardLS
#eval upwardLS
#eval lindstromsTheorem

--- Classification ---
#eval morleyCategoricity
#eval baldwinLachlan
#eval vaughtsNeverTwo
#eval shelahMainGap
#eval classificationProgramStatus

--- Bridges ---
#eval typeSpaceIsStone
#eval ryllNardzewski
#eval fieldNotVariety
#eval chevalleyTheorem
#eval stoneDualityStatement

--- Decidability ---
#eval decidableTheories
#eval undecidableTheories
#eval isDecidable "DLO"
#eval isDecidable "PA"

--- Counterexamples ---
#eval counterexamplesSummary
#eval incompleteTheoryExample
#eval theoriesWithNModels

--- Type spaces ---
#eval typeSpace "DLO" 1
#eval basicOpenSet "x < y"

--- New Objects ---
#eval "Theory type defined" : String
#eval dloProperties : List String
#eval lindenbaumTop : LindenbaumElement
#eval lindenbaumBot : LindenbaumElement

--- New Properties ---
#eval dloClassificationData : ClassificationData
#eval acf0ClassificationData : ClassificationData
#eval classificationHierarchy : List String

--- New Theorems ---
#eval losTarskiTheoremFull : String
#eval lyndonPositivityTheorem : String
#eval bethDefinabilityFull : String
#eval finiteAxiomatizabilityCriterion : String

--- Preservation ---
#eval losTarskiTheoremStatement : String
#eval changLosSuszkoStatement : String
#eval keislerHornTheorem : String

--- New Bridges ---
#eval birkhoffHSPStatement : String
#eval lefschetzPrinciple : String
#eval oMinimalExamples : List String
#eval presburgerArithmeticStatement : String
#eval finiteModelProperty : String

--- Saturation ---
#eval saturatedModelExistence : String
#eval monsterModelConcept : String

--- Diagrams ---
#eval diagramHierarchy : List String
#eval robinsonDiagramProperty : String
