with open('TODO.md', 'r') as f:
    content = f.read()

import re
match = re.search(r'- \[(.)\] \*\*Finish Existing: Complete proofs in `HenselLift.lean`, `QuasiPolynomial.lean`, and `LipschitzCausality.lean`\.\*\*', content)
if match:
    print("Found exact match for TODO.md entry:", match.group(0))
else:
    match = re.search(r'- \[(.)\].*HenselLift.lean.*QuasiPolynomial.lean.*LipschitzCausality.lean.*', content)
    if match:
        print("Found partial match:", match.group(0))
    else:
        print("Could not find the exact TODO.md entry.")
