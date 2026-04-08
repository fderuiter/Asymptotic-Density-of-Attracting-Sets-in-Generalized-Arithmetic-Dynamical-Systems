import re

with open('BLUEPRINT.md', 'r') as f:
    content = f.read()

tasks = content.split('## Target Task')
for i, task in enumerate(tasks[1:]):
    if 'Finish Existing: Complete proofs in `HenselLift.lean`, `QuasiPolynomial.lean`, and `LipschitzCausality.lean`.' in task:
        print(task.strip())
        break
