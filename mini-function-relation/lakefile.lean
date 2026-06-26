import Lake
open Lake DSL

package «mini-function-relation» where
  -- Depend on mini-object-kernel for the Object typeclass
  moreLinkArgs := #["../../0. mini-math-kernel/mini-object-kernel"]

@[default_target]
lean_lib «MiniFunctionRelation» where
  srcDir := "MiniFunctionRelation"
