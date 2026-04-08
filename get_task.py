import re

with open('BLUEPRINT.md', 'r') as f:
    content = f.read()

tasks = content.split('## Target Task')
for i, task in enumerate(tasks[1:]):
    if '- [ ]' in task and 'lipschitz_implies_causality' not in task[:100]:
        print(f"Next Uncompleted Task ({i+1}):")
        print(task[:300])
        print("...")
        break
