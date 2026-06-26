# User Guide — MiniZFCLite

## Getting Started

Import the package:

```lean
import MiniZFCLite
open MiniZFCLite
```

## Inspecting the ZFC Axioms

```lean
-- List all axiom names
#eval zfcAxiomList.map (·.1)

-- Check axiom count
#eval zfcAxiomList.length  -- 8

-- Inspect a specific axiom
#eval zfcExtensionality
#eval zfcChoice
```

## Working with the Axiom System

```lean
-- Create the ZFC axiom set
#eval zfcAxiomSet.size  -- 8

-- Create the ZFC axiom system
#eval zfcSystem.name     -- "ZFC"
#eval zfcSystem.version  -- "0.1.0"

-- Check for specific axioms
#eval zfcAxiomSet.containsName "zfc-pairing"  -- true
```

## Running Tests

```bash
lake env lean --run Test/Smoke.lean
lake env lean --run Test/Examples.lean
lake env lean --run Test/Regression.lean
```
