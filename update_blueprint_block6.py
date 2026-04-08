import re

with open('BLUEPRINT.md', 'r') as f:
    content = f.read()

task_blocks = re.split(r'(?=## Target Task)', content)

for i, block in enumerate(task_blocks):
    if not block.strip():
        continue
    if '- [ ]' in block and 'linearization_of_orbits' in block:
        updated_block = block.replace('- [ ]', '- [x]')
        content = content.replace(block, updated_block)
        break

with open('BLUEPRINT.md', 'w') as f:
    f.write(content)
