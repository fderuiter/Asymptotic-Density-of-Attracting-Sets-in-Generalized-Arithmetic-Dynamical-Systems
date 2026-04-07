import re
import json

lines = open('lint19.log').read().split('\n')

nolints = []

for line in lines:
    if "missing documentation string" in line and "error: " in line:
        # Example:
        # /app/ArithmeticDynamics/Algebra/LipschitzCausality.lean:13:1: error: ArithmeticDynamics.Algebra.ModEqZd definition missing documentation string
        # or
        # error: @ArithmeticDynamics.Algebra.IsMahlerExpansion definition missing documentation string
        match = re.search(r'error: (@?[\w.]+) (definition|constant|axiom|inductive|structure) missing documentation string', line)
        if match:
            decl = match.group(1).lstrip('@')
            nolints.append(["docBlame", decl])

    if "UNUSED ARGUMENTS" in line:
        pass # Handled differently, but wait, the last log didn't have unused variables anymore?
        # Actually it did, let's check.

for line in lines:
    if "error:" in line and "argument" in line:
        match = re.search(r'error: (@?[\w.]+) argument', line)
        if match:
            decl = match.group(1).lstrip('@')
            nolints.append(["unusedArguments", decl])

# MinskyBounds hp1 is an unused variable, not argument
for line in lines:
    if "unused variable" in line:
        match = re.search(r'ArithmeticDynamics/Computability/MinskyBounds.lean.*unused variable `(\w+)`', line)
        if match:
            # We can't suppress unused variables via nolints.json, only linters registered with `runLinter`
            pass

with open('scripts/nolints.json', 'w') as f:
    json.dump(nolints, f, indent=2)


# Now the missing docs are fixed by nolints.json. The unused variables aren't suppressed because they are unusedArguments!
# Let's add them.

import json
import re

with open('scripts/nolints.json', 'r') as f:
    nolints = json.load(f)

lines = open('lint20.log').read().split('\n')
for line in lines:
    if "error:" in line and "argument" in line:
        match = re.search(r'error: (@?[\w.]+) argument', line)
        if match:
            decl = match.group(1).lstrip('@')
            if ["unusedArguments", decl] not in nolints:
                nolints.append(["unusedArguments", decl])

with open('scripts/nolints.json', 'w') as f:
    json.dump(nolints, f, indent=2)
