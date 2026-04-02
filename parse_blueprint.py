import re

with open('BLUEPRINT.md', 'r') as f:
    content = f.read()

tasks = re.split(r'(?=## Target Task)', content)
for task in tasks:
    if not task.strip(): continue
    if '## Target Task' in task and '[COMPLETED]' not in task:
        print(task)
        break
