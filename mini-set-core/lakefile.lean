import Lake
open Lake DSL

package «mini-set-core» where

@[default_target]
lean_lib «MiniSetCore» where
  -- Depend on mini-object-kernel
  moreLinkArgs := #["../../0. mini-math-kernel/mini-object-kernel"]
