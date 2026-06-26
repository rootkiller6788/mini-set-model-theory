/-
# Regression Tests for MiniCompactnessCompletenessLite

Verifies all definitions are accessible and type-check correctly.
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

--- Core definitions ---
def test_compactness : String := compactnessStatement
def test_completeness : String := completenessTheorem
def test_downwardLS : String := downwardLS
def test_upwardLS : String := upwardLS

--- Classification ---
def test_morley : String := morleyCategoricity
def test_baldwinLachlan : String := baldwinLachlan
def test_vaught : String := vaughtsNeverTwo
def test_shelah : String := shelahMainGap

--- Bridges ---
def test_typeSpace : String := typeSpaceIsStone
def test_ryll : String := ryllNardzewski
def test_decidable : Bool := isDecidable "DLO"
def test_fieldNotVariety : String := fieldNotVariety
def test_chevalley : String := chevalleyTheorem
def test_birkhoff : String := birkhoffHSPStatement

--- Examples ---
def test_counterexamples : String := counterexamplesSummary
def test_incomplete : String := incompleteTheoryExample

--- New: Objects ---
def test_theory_type : Theory := emptyTheory
def test_satisfiable : Prop := satisfiable emptyTheory
def test_consequence : Prop := logicalConsequence emptyTheory
  (MiniLogicKernel.PredFormula.prop MiniLogicKernel.Formula.true)

--- New: Morphisms ---
def test_interpretation : Interpretation emptyTheory emptyTheory :=
  Interpretation.id emptyTheory
def test_bi : Prop := areEquivalent emptyTheory emptyTheory
def test_ext : Prop := isExtension emptyTheory emptyTheory

--- New: Constructions ---
def test_subtheory : Prop := isSubtheory emptyTheory emptyTheory
def test_lindenbaum : LindenbaumElement := lindenbaumTop
def test_product : Theory := productTheory emptyTheory emptyTheory

--- New: Properties ---
def test_classification_data : ClassificationData := dloClassificationData
def test_stability : StabilitySpectrum := stabilityClass emptyTheory

--- New: Theorems ---
def test_henkin : String := henkinConstruction
def test_modelExistence : String := modelExistenceTheorem
def test_preservation : String := losTarskiTheoremFull
def test_lindstrom_context : String := lindstromsTheorem

--- New: Preservation ---
def test_changeLos : String := changLosSuszkoStatement
def test_lyndonPres : String := lyndonPositivityTheorem

--- New: Bridges ---
def test_presburger : String := presburgerArithmeticStatement
def test_o_minimal : List String := oMinimalExamples
def test_stone : String := stoneDualityStatement
def test_zilber : String := zilberTrichotomyGeometry
