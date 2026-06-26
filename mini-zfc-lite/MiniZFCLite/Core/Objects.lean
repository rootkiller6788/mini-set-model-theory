/-
# ZFC Lite: Axiom System Registration
-/

import MiniZFCLite.Core.Basic
import MiniAxiomKernel.Core.Basic
import MiniAxiomKernel.Core.Laws

open MiniLogicKernel

namespace MiniZFCLite

def zfcPropAxioms : List MiniAxiomKernel.Axiom :=
  zfcAxiomList.map fun (name, pf) =>
    MiniAxiomKernel.Axiom.simple name (.atom (hash name % 16))
  where
    hash (s : String) : Nat := s.foldl (fun acc c => acc * 31 + c.toNat) 0

def zfcAxiomSet : MiniAxiomKernel.AxiomSet :=
  MiniAxiomKernel.AxiomSet.empty.addAll zfcPropAxioms

def zfcSystem : MiniAxiomKernel.AxiomSystem :=
  { name := "ZFC", version := "0.1.0", axioms := zfcAxiomSet, description := some "Zermelo-Fraenkel set theory with Choice" }

def zfcAxioms := zfcAxiomSet

end MiniZFCLite
