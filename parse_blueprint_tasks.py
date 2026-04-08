import re

with open('BLUEPRINT.md', 'r') as f:
    content = f.read()

tasks = content.split('## Target Task')
for i, task in enumerate(tasks[1:]):
    if '- [ ]' in task:
        print(f"Task {i+1}:")
        print(task[:100].strip())
        print("...")
