with open('TODO.md', 'r') as f:
    content = f.read()

for i, line in enumerate(content.split('\n')):
    if 'lipschitz_implies_causality' in line:
        print(line)
