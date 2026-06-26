/-
# Compactness Completeness Lite: Core Basic

Compactness, Completeness, Lowenheim-Skolem, Shelah Main Gap,
and the classification program.

This module imports the core dependencies and defines the
basic types and infrastructure needed by all other modules.
-/

import MiniFunctionRelation.Core.Basic
import MiniLogicKernel.Core.Objects
import MiniCardinalOrdinal.Core.Basic
import MiniSatisfactionModel.Properties.Classification

namespace MiniCompactnessCompletenessLite

/-! ## Re-exported definitions for convenience -/

abbrev Structure := MiniFunctionRelation.Structure
abbrev PredFormula := MiniLogicKernel.PredFormula
abbrev Formula := MiniLogicKernel.Formula

end MiniCompactnessCompletenessLite
