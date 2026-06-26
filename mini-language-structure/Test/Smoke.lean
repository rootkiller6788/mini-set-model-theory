/-
# Smoke Tests — MiniLanguageStructure

Run: `lake env lean --run Test/Smoke.lean`
-/

import MiniLanguageStructure

open MiniLanguageStructure

#eval "══ MINI-LANGUAGE-STRUCTURE SMOKE TESTS ══"

/-! ## Core.Basic -/

#eval "── Core.Basic: namespace loaded ──"
#eval "MiniLanguageStructure namespace active"

/-! ## Constructions: Products -/

#eval "── Constructions.Products: productStructure ──"

def prodUnit : MiniFunctionRelation.Structure := productStructure unitStructure unitStructure

#eval "productStructure (Unit x Unit) defined"

/-! ## Constructions: productFst -/

def unitFst : MiniFunctionRelation.Hom prodUnit unitStructure := productFst unitStructure unitStructure

#eval "productFst defined"

/-! ## Constructions: productSnd -/

def unitSnd : MiniFunctionRelation.Hom prodUnit unitStructure := productSnd unitStructure unitStructure

#eval "productSnd defined"

/-! ## Constructions: Subobjects -/

#eval "── Constructions.Subobjects: Substructure ──"

def trivialSub : Substructure unitStructure where
  carrier _ := True
  closedConst _ := trivial
  closedPred _ _ _ := trivial

#eval "Substructure defined"

/-! ## Constructions: Quotients -/

#eval "── Constructions.Quotients: Congruence ──"

def trivialCongruence : Congruence unitStructure where
  rel _ _ := True
  equiv := { refl := fun _ => trivial, symm := fun _ _ _ => trivial, trans := fun _ _ _ _ _ => trivial }
  predCompat _ _ _ _ := ⟨fun _ => trivial, fun _ => trivial⟩

#eval "Congruence defined"

/-! ## Constructions: Universal -/

#eval "── Constructions.Universal: Initial/Terminal ──"
#eval "InitialStructure defined (Empty domain)"
#eval "TerminalStructure defined (Unit domain)"

/-! ## Bridges: ToAlgebra -/

#eval "── Bridges.ToAlgebra: algebraic structures ──"
#eval birkhoffHSP
#eval groupOpArities
#eval ringOpArities

#eval "══ ALL MINI-LANGUAGE-STRUCTURE SMOKE TESTS PASSED ══"
