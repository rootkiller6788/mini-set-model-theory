/-
# Ultraproducts and Los's Theorem

The ultraproduct construction is a central tool in model theory.
Los's theorem states that a sentence holds in the ultraproduct
iff it holds in "almost all" factors (modulo the ultrafilter).
Ultraproducts prove compactness and enable saturation constructions.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects

namespace MiniCompactnessCompletenessLite

/-! ## Ultraproduct Concepts -/

def ultraproductConcept : String :=
  "The ultraproduct ∏_U M_i is the product of structures modulo an ultrafilter U. Elements are equivalence classes of sequences (a_i) where a_i ∈ M_i."

def ultrafilterAxioms : String :=
  "A proper filter F on a set I is an ultrafilter if for every X ⊆ I, either X ∈ F or I ∖ X ∈ F. This corresponds to maximality."

/-! ## Los's Theorem -/

def losTheorem : String :=
  "Los's theorem: For any ultrafilter U on I, any structure sequence (M_i)_{i∈I}, any formula φ(x̄), and any sequence of tuples ā_i, ∏_U M_i ⊨ φ([ā]) iff {i | M_i ⊨ φ(ā_i)} ∈ U."

def losTheoremProofSketch : String :=
  "Proof by induction on formula complexity. The atomic case follows from definition; connectives use ultrafilter closure; existential uses axiom of choice. The base case is: predicates hold in ultraproduct iff they hold in U-most factors."

/-! ## Compactness via Ultraproducts -/

def compactnessViaUltraproducts : String :=
  "Proof of compactness: Let T be finitely satisfiable. For each finite T₀ ⊆ T, pick a model M_T₀ ⊨ T₀. Take the ultraproduct over all finite subsets with an appropriate ultrafilter. Los's theorem gives ⊨ T."

def properUltrafilterExistence : String :=
  "The existence of a proper ultrafilter extending the filter of cofinite subsets on the set of finite subtheories requires the Boolean Prime Ideal Theorem (equivalent to ultrafilter lemma)."

/-! ## Keisler-Shelah Isomorphism Theorem -/

def keislerShelahTheorem : String :=
  "Keisler-Shelah: Two structures are elementarily equivalent iff they have isomorphic ultrapowers. This uses GCH. Without GCH: Shelah proved elementarily equivalent structures have isomorphic limit ultrapowers."

def ultrapower : String :=
  "An ultrapower is an ultraproduct where all factors are the same structure: M^I/U. Ultrapowers give elementary extensions: M ≼ M^I/U."

/-! ## Applications of Ultraproducts -/

def axKochenTheorem : String :=
  "Ax-Kochen: The theory of p-adic fields is decidable. Uses ultraproducts of p-adic fields across different primes p to transfer statements between Q_p and F_p((t))."

def ultraproductApplications : List String :=
  ["Compactness theorem",
   "Saturation of ultrapowers (regular ultrafilters)",
   "Keisler-Shelah (elementary equivalence = isomorphic ultrapowers)",
   "Ax-Kochen (p-adic decidability via ultraproducts)",
   "Non-standard analysis (hyperreals as ultrapower of R)"]

--- #eval ---

#eval losTheorem : String

#eval compactnessViaUltraproducts : String

#eval keislerShelahTheorem : String

#eval ultraproductApplications : List String

end MiniCompactnessCompletenessLite
