import Lake
open Lake DSL

package «mini-zfc-lite» where

@[default_target]
lean_lib «MiniZFCLite» where

require «mini-logic-kernel» from "../../0. mini-math-kernel/mini-logic-kernel"
require «mini-axiom-kernel» from "../../0. mini-math-kernel/mini-axiom-kernel"
