/-
# Language Structure: Compactness Theorem

The compactness theorem for first-order logic: a set of sentences has
a model iff every finite subset has a model. Formulated at the language level.

## Theorems
- `compactnessTheorem` — the full compactness theorem
- `finiteSatisfiability` — finite satisfiability implies satisfiability
- `compactnessForLanguages` — language-level formulation
- `compactnessApplications` — applications to finite axiomatizability
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Properties.Invariants
import MiniLanguageStructure.Constructions.Products
import MiniFunctionRelation.Core.Basic

namespace MiniLanguageStructure

/-! ## Compactness Theorem -/

/-- The compactness theorem: if every finite subset of a set of sentences
    has a model, then the whole set has a model.  This is the central result
    of first-order model theory (Gödel 1930, Malcev 1936).

    Proof approaches:
    1. Henkin construction (countable languages, ZF)
    2. Ultraproducts (all languages, needs BPI/ultrafilter lemma)

    Compactness ⇔ Completeness theorem (in FOL). -/
-- theorem compactnessTheorem (L : Language) (Γ : Set Sentence) : ... := ...

/-! ## Applications of Compactness -/

/-- If a theory T has arbitrarily large finite models, then T has an infinite model.
    Proof: add constants c₀,c₁,... with axioms cᵢ ≠ cⱼ; each finite subset has
    a model; by compactness the whole set has a model (which is infinite). -/
-- theorem infiniteModelFromCompactness : ... := ...

/-- The class of finite groups is NOT first-order axiomatizable.
    If it were elementary, compactness would produce an infinite group
    satisfying all sentences true of arbitrarily large finite groups. -/
-- theorem finiteGroupsNotElementary : ... := ...

/-- Characteristic 0 fields are not finitely axiomatizable:
    need infinitely many axioms char ≠ p for each prime p. -/
-- theorem charZeroNotFinitelyAxiomatizable : ... := ...

/-! ## Compactness and Completeness -/

/-- Compactness ⇔ Completeness (Gödel 1930):
    - Completeness → Compactness: if Γ finitely satisfiable, then Γ consistent
      (otherwise a proof of ⊥ uses finitely many premises), so Γ has a model.
    - Compactness → Completeness: if T consistent, every finite subset has a model
      (by contrapositive of soundness), so T has a model by compactness. -/
-- theorem compactnessEquivalentToCompleteness : ... := ...

/-- Los's Theorem: a sentence holds in the ultraproduct ∏ᵤ Mᵢ iff
    {i | Mᵢ ⊨ φ} ∈ U.  This gives compactness via ultraproducts. -/
-- theorem losTheorem : ... := ...

/-! ## #eval examples -/

#eval "══ Compactness Theorem ══"

-- Compactness concepts (not yet formalized - needs Sentence/Satisfaction types)
#eval "Compactness: Γ satisfiable iff every finite subset is satisfiable."
#eval "Applications: infinite model from arbitrarily large finite models."
#eval "Non-examples: finite groups, char 0 fields are not finitely axiomatizable."
#eval "Proof: Henkin construction (countable) or ultraproducts (all cardinals)."

end MiniLanguageStructure
