with open('TODO.md', 'r') as f:
    for line in f:
        if 'lipschitz' in line.lower() or 'causality' in line.lower():
            print(line.strip())
