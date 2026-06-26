import Lake
open Lake DSL

package «mini-order-equivalence» where

@[default_target]
lean_lib «MiniOrderEquivalence» where
  srcDir := "MiniOrderEquivalence"

require «mini-function-relation» from "../mini-function-relation"
require «mini-logic-kernel» from "../../0. mini-math-kernel/mini-logic-kernel"
