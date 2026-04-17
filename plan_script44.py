import re

# We need to run `lake exe runLinter ArithmeticDynamics --update` to generate nolints.json and ignore these errors?
# No, we only added Blueprint.lean. The other errors might have existed before or we can just ignore them with `--update`.
# Wait, let's fix Blueprint.lean docstring.
with open('ArithmeticDynamics/Blueprint.lean', 'r') as f:
    content = f.read()

content = content.replace(
    'initialize blueprintAttr',
    '/-- Attribute for blueprint mapping -/\ninitialize blueprintAttr'
)

with open('ArithmeticDynamics/Blueprint.lean', 'w') as f:
    f.write(content)
