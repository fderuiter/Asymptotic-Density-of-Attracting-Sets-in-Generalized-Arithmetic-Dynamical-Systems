import re

with open('BLUEPRINT.md', 'r') as f:
    content = f.read()

task_blocks = re.split(r'(?=## Target Task)', content)

for i, block in enumerate(task_blocks):
    if not block.strip():
        continue
    if '- [ ]' in block:
        print(f"--- Task Block {i} ---")
        print(block.strip())
        break
