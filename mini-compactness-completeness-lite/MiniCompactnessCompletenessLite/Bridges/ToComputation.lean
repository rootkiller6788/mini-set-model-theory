/-
# Bridge to Computation: Decidable Theories

Some first-order theories are decidable: there is an algorithm
determining whether a given sentence is provable. Key examples
include Presburger arithmetic, real closed fields, and DLO.
The finite model property and tree automata provide additional
decidability techniques.
-/

import MiniCompactnessCompletenessLite.Core.Basic
import MiniCompactnessCompletenessLite.Core.Objects
import MiniCompactnessCompletenessLite.Core.Laws

namespace MiniCompactnessCompletenessLite

/-! ## Decidability Predicate -/

def isDecidable (T : String) : Bool :=
  match T with
  | "DLO" => true
  | "ACF0" => true
  | "RCF" => true
  | "Presburger" => true
  | _ => false

def decidableTheories : List String :=
  ["DLO", "ACF0", "RCF", "Presburger Arithmetic", "Boolean Algebra"]

def undecidableTheories : List String :=
  ["Peano Arithmetic", "ZFC Set Theory", "Group Theory", "Field Theory"]

def fieldNotVariety : String :=
  "The class of fields is not a variety (not closed under products)"

/-! ## Presburger Arithmetic -/

def presburgerArithmeticStatement : String :=
  "Presburger arithmetic (Th(N, +, 0, 1)) is decidable. It has quantifier elimination after adding mod-predicates. Super-exponential complexity (2^2^O(n))."

def presburgerQE : String :=
  "Presburger arithmetic has quantifier elimination in the extended language with unary divisibility predicates D_n for each n > 1."

def skolemArithmetic : String :=
  "Skolem arithmetic (Th(N, ·, 0, 1)) is also decidable, via reduction to Presburger using prime factorization."

/-! ## Real Closed Fields (Tarski) -/

def rcfDecidability : String :=
  "RCF (real closed fields) is decidable by Tarski's quantifier elimination algorithm. Complexity: doubly exponential in the number of quantifier alternations."

def cylindricalAlgebraicDecomposition : String :=
  "Cylindrical Algebraic Decomposition (CAD) is a practical algorithm for RCF quantifier elimination, used in computational real algebraic geometry."

/-! ## Finite Model Property -/

def finiteModelProperty : String :=
  "A logic has the finite model property (FMP) if every satisfiable formula has a finite model. FMP implies decidability for finitely axiomatizable theories."

def classicalFMPExamples : List String :=
  ["Modal logic K", "Modal logic S5", "Description logic ALC", "Guarded fragment of FOL", "Two-variable fragment FO²"]

def trakhtenbrotTheorem : String :=
  "Trakhtenbrot's theorem: The set of first-order sentences true in all finite structures is not recursively enumerable. FMP fails for full FOL."

/-! ## Automata and Logic (Buechi, Rabin) -/

def buechiTheorem : String :=
  "Buechi's theorem: Monadic second-order logic of one successor (S1S) is decidable via finite automata. WS1S (weak S1S) uses finite automata on finite words."

def rabinTreeTheorem : String :=
  "Rabin's tree theorem: Monadic second-order logic of two successors (S2S) is decidable via tree automata. This implies decidability of many mathematical theories."

def msoDecidability : String :=
  "MSO on infinite trees is decidable (Rabin 1969). MSO on finite graphs is undecidable (Trakhtenbrot)."

/-! ## Complexity of Decision Procedures -/

def presburgerComplexity : String :=
  "Presburger arithmetic decision: 2-EXPTIME complete (Fischer-Rabin). RCF: EXPSPACE (Ben-Or, Kozen, Reif). DLO: PSPACE."

--- #eval ---

#eval isDecidable "DLO" : Bool

#eval isDecidable "PA" : Bool

#eval decidableTheories : List String

#eval undecidableTheories : List String

#eval finiteModelProperty : String

end MiniCompactnessCompletenessLite
