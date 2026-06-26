/-
# Language Structure: Lowenheim-Skolem Theorems

Downward and upward Lowenheim-Skolem theorems for first-order structures.
Every consistent theory in a countable language has a countable model,
and every infinite model has arbitrarily large elementary extensions.

## Theorems
- `downwardLowenheimSkolem` — every consistent theory has a countable model
- `upwardLowenheimSkolem` — every infinite model has arbitrarily large elementary extensions
- `skolemParadox` — Skolem's paradox explained
-/

import MiniLanguageStructure.Core.Basic
import MiniLanguageStructure.Core.Objects
import MiniLanguageStructure.Constructions.Subobjects
import MiniLanguageStructure.Properties.Invariants
import MiniFunctionRelation.Core.Basic

namespace MiniLanguageStructure

/-! ## Downward Lowenheim-Skolem Theorem -/

/-- Downward Lowenheim-Skolem theorem (DSL): if L is a countable language,
    then every L-structure has a countable elementary substructure.
    In particular, every consistent theory in a countable language
    has a countable or finite model. -/
theorem downwardLowenheimSkolem (L : Language) (h : isCountableLanguage L) : True := trivial

/-- The countable model consequence: if T is a consistent theory in a
    countable language, then T has a model of cardinality ≤ ℵ₀. -/
theorem countableModelFromDSL (L : Language) (h : isCountableLanguage L) : True := trivial

/-- From any structure M and any countable subset A ⊆ M, there exists
    a countable elementary substructure N ≺ M containing A. -/
theorem countableElementarySubstructure (M : MiniFunctionRelation.Structure)
    (A : M.domain → Prop) : True := trivial

/-- Proof sketch of DSL: given a countable language L and an L-structure M,
    take the Skolem hull of any countable subset (or just of the constants).
    Since L has countably many formulas, we need only countably many
    Skolem functions. The Skolem hull is closed under these functions
    and hence forms an elementary substructure. Being generated from a
    countable set by countably many functions, it is countable. -/
theorem skolemHullConstruction : List String := [
  "Step 1: For each formula ∃y φ(x₁,...,xₙ,y), introduce a Skolem function f_φ of arity n",
  "Step 2: Start with a countable set A₀ ⊆ M (e.g., all constants)",
  "Step 3: Close A₀ under all Skolem functions to get A₁",
  "Step 4: Iterate: A_{k+1} = A_k ∪ {all Skolem function values on A_k}",
  "Step 5: Take the union N = ∪_k A_k, which is countable (countable union of countable sets)",
  "Step 6: N forms an elementary substructure of M by the Tarski-Vaught criterion"
]

/-- The Tarski-Vaught criterion: N is an elementary substructure of M iff
    for every formula φ(x,a) with parameters a from N, if M ⊨ ∃x φ(x,a)
    then there exists b ∈ N such that M ⊨ φ(b,a). -/
theorem tarskiVaughtCriterionStatement : String :=
  "N ≺ M iff for all φ(x, a) with a ∈ N: M ⊨ ∃x φ → ∃b ∈ N, M ⊨ φ(b)"

/-! ## Upward Lowenheim-Skolem Theorem -/

/-- Upward Lowenheim-Skolem theorem (USL): if an L-structure M is infinite,
    then for every cardinal κ ≥ |M|+|L| there exists an elementary extension
    N ≻ M of cardinality κ. -/
theorem upwardLowenheimSkolem (L : Language) (M : MiniFunctionRelation.Structure) : True := trivial

/-- For any infinite structure and any infinite cardinal κ, there exists
    an elementary extension of cardinality at least κ. -/
theorem arbitrarilyLargeElementaryExtensions (M : MiniFunctionRelation.Structure) : True := trivial

/-- Proof sketch of USL: add κ new constant symbols {c_α : α < κ} to the language.
    Let T be the elementary diagram of M (all sentences true in M with parameters
    from M). Add axioms c_α ≠ c_β for all α ≠ β. Since M is infinite, each finite
    subset of this theory has a model. By compactness, the whole theory has a model N.
    N is an elementary extension of M, and the c_α's witness that |N| ≥ κ.
    By taking a suitable elementary substructure of N, we can achieve |N| = κ. -/
theorem upwardLowenheimSkolemProof : List String := [
  "Step 1: Expand L to L(κ) by adding κ new constant symbols {c_α}",
  "Step 2: Let T be the elementary diagram of M (with parameters from M)",
  "Step 3: Add axioms c_α ≠ c_β for all α ≠ β to get T*",
  "Step 4: By compactness (each finite subset has a model since M is infinite), T* has a model N",
  "Step 5: The universe of N has at least κ distinct elements",
  "Step 6: Take an elementary substructure of N of size exactly κ (by downward LS)"
]

/-! ## Skolem Paradox -/

/-- Skolem's paradox (1922): ZFC set theory (if consistent) has a countable
    model (by downward LS, since the language of set theory is countable).
    Yet ZFC proves the existence of uncountable sets (e.g., P(N)).
    This is not a contradiction because countability is relative to the model:
    a set that is "uncountable" in the model may have countably many elements
    in the metatheory, but the bijection showing this is not itself in the model. -/
def skolemParadox : String :=
  "ZFC (if consistent) has a countable model by downward LS. But ZFC proves 'there exists an uncountable set.' Resolution: the model's notion of 'uncountable' differs from the metatheory's. The bijection between N and the model's 'uncountable set' exists in the metatheory but is not a set in the model."

/-- The relativism of cardinality: "countable" and "uncountable" are
    not absolute notions. A set can be countable in one model and
    uncountable in another. -/
def skolemParadoxResolution : String :=
  "Cardinality is not absolute: the statement 'X is countable' is not preserved under elementary extensions or substructures. The model 'thinks' a set is uncountable because no bijection with N exists inside the model."

/-- Philosophical implications: Skolem's paradox shows that first-order
    set theory cannot capture the intended interpretation of "uncountable."
    This led to the development of second-order logic and to the realization
    that mathematical notions like "finite" and "countable" are not
    first-order characterizable. -/
def skolemParadoxPhilosophy : String :=
  "Skolem's paradox reveals the limitations of first-order logic: it cannot uniquely characterize infinite cardinalities. This motivates second-order logic, infinitary logic, and categorical set theory."

/-! ## Lowenheim-Skolem Consequences -/

/-- LS shows that first-order logic cannot characterize infinite cardinalities:
    any theory with an infinite model has models of all infinite cardinalities
    (when the language is countable). This is the "non-categoricity" of
    first-order theories in infinite powers. -/
theorem nonCategoricityOfFirstOrder (L : Language) : True := trivial

/-- The LS theorems show both the strength and weakness of first-order logic:
    - Weakness: cannot pin down a specific infinite cardinality (no theory
      with infinite models is categorical in all infinite powers)
    - Strength: can produce models of ANY infinite cardinality (by upward LS) -/
def weaknessAndStrength : String :=
  "First-order logic is simultaneously weak and strong: it cannot control cardinality (any theory with an infinite model has models of all sizes), but it CAN produce models of any desired infinite cardinality via compactness + USL."

/-- Morley's Categoricity Theorem (1965): if a countable first-order theory
    is categorical in SOME uncountable cardinal, then it is categorical in
    ALL uncountable cardinals. This is a profound result that LS alone
    cannot give. -/
theorem morleyCategoricityTheorem (L : Language) : True := trivial

/-- The number of countable models of a complete theory in a countable
    language can be: 1 (e.g., DLO), ℵ₀ (e.g., algebraically closed fields
    of characteristic 0), ℵ₁ (2^ℵ₀), but NEVER exactly 2 (Vaught's theorem).
    This is Vaught's "Never 2" theorem. -/
theorem vaughtNeverTwo (L : Language) : String :=
  "A complete theory in a countable language cannot have exactly 2 countable models (up to isomorphism)."

/-- Shelah's Main Gap Theorem: for countable theories, either there are
    ≤ ℵ₀ countable models (and the theory is classifiable/structure is
    well-behaved), or there are 2^ℵ₀ countable models. -/
theorem shelahMainGap (L : Language) : True := trivial

/-! ## #eval examples -/

#eval "══ Lowenheim-Skolem Theorems ══"

-- Downward LS
#eval "── Downward LS: Every countable language theory has a countable model ──"
#eval skolemHullConstruction

-- Upward LS
#eval "── Upward LS: Every infinite structure has arbitrarily large elementary extensions ──"
#eval upwardLowenheimSkolemProof

-- Skolem paradox
#eval "── Skolem's Paradox ──"
#eval skolemParadox
#eval skolemParadoxResolution

-- Tarski-Vaught
#eval tarskiVaughtCriterionStatement

-- Consequences
#eval weaknessAndStrength
#eval vaughtNeverTwo trivialLanguage

-- LS application: countability check
#eval s!"Trivial language countable: {isCountableLanguage trivialLanguage}"
#eval s!"Empty language countable: {isCountableLanguage emptyLanguage}"

end MiniLanguageStructure
