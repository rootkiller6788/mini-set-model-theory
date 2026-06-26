/-
# Main Entry Point for MiniCompactnessCompletenessLite

Prints the key theorem statements and classification data.
-/

import MiniCompactnessCompletenessLite

open MiniCompactnessCompletenessLite

def main : IO Unit := do
  IO.println s!"=== MiniCompactnessCompletenessLite ==="
  IO.println s!""
  IO.println s!"Core Theorems:"
  IO.println s!"  Compactness: {MiniCompactnessCompletenessLite.compactnessStatement}"
  IO.println s!"  Completeness (Godel): {MiniCompactnessCompletenessLite.completenessTheorem}"
  IO.println s!"  Downward LS: {MiniCompactnessCompletenessLite.downwardLS}"
  IO.println s!"  Upward LS: {MiniCompactnessCompletenessLite.upwardLS}"
  IO.println s!""
  IO.println s!"Classification:"
  IO.println s!"  Morley: {MiniCompactnessCompletenessLite.morleyCategoricity}"
  IO.println s!"  Baldwin-Lachlan: {MiniCompactnessCompletenessLite.baldwinLachlan}"
  IO.println s!"  Vaught Never-2: {MiniCompactnessCompletenessLite.vaughtsNeverTwo}"
  IO.println s!"  Shelah Main Gap: {MiniCompactnessCompletenessLite.shelahMainGap}"
  IO.println s!""
  IO.println s!"Examples:"
  IO.println s!"  DLO classification: {dloClassificationData}"
  IO.println s!"  ACF0 classification: {acf0ClassificationData}"
  IO.println s!"  Theories with N models: {theoriesWithNModels}"
  IO.println s!""
  IO.println s!"Decidability:"
  IO.println s!"  Decidable theories: {decidableTheories}"
  IO.println s!"  Undecidable theories: {undecidableTheories}"
  IO.println s!""
  IO.println s!"Type Spaces:"
  IO.println s!"  Type space is Stone: {typeSpaceIsStone}"
  IO.println s!"  Ryll-Nardzewski: {ryllNardzewski}"
  IO.println s!""
  IO.println s!"Counterexamples:"
  IO.println s!"  {counterexamplesSummary}"
  IO.println s!"  {incompleteTheoryExample}"
