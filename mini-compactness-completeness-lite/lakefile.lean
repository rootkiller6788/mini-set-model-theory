import Lake
open Lake DSL

package «mini-compactness-completeness-lite» where

@[default_target]
lean_lib «MiniCompactnessCompletenessLite» where

require «mini-function-relation» from "../mini-function-relation"
require «mini-cardinal-ordinal» from "../mini-cardinal-ordinal"
require «mini-satisfaction-model» from "../mini-satisfaction-model"
require «mini-logic-kernel» from "../../0. mini-math-kernel/mini-logic-kernel"
