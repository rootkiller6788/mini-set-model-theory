import Lake
open Lake DSL

package «mini-satisfaction-model» where
  srcDir := "."

require «mini-function-relation» from "../mini-function-relation"
require «mini-cardinal-ordinal» from "../mini-cardinal-ordinal"
require «mini-logic-kernel» from "../../0. mini-math-kernel/mini-logic-kernel"
require «mini-object-kernel» from "../../0. mini-math-kernel/mini-object-kernel"

@[default_target]
lean_lib «MiniSatisfactionModel» where
  srcDir := "MiniSatisfactionModel"
