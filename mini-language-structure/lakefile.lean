import Lake
open Lake DSL

package «mini-language-structure» where

@[default_target]
lean_lib «MiniLanguageStructure» where
  srcDir := "MiniLanguageStructure"

require «mini-function-relation» from "../mini-function-relation"
require «mini-order-equivalence» from "../mini-order-equivalence"
require «mini-construction-kernel» from "../../0. mini-math-kernel/mini-construction-kernel"
