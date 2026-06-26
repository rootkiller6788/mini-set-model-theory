/-
MiniCardinalOrdinal — Lake Build Configuration

Cardinal invariants, stability theory, and the classification spectrum
for first-order model theory.  Requires leanprover/lean4:v4.7.0.
-/
import Lake
open Lake DSL

package «mini-cardinal-ordinal» where
  srcDir := "."

@[default_target]
lean_lib «MiniCardinalOrdinal» where
  srcDir := "MiniCardinalOrdinal"

-- Dependencies: math-kernel layer
require «mini-logic-kernel» from "../../0. mini-math-kernel/mini-logic-kernel"

-- Dependencies: set-model-theory layer
require «mini-function-relation» from "../mini-function-relation"
require «mini-set-core» from "../mini-set-core"
