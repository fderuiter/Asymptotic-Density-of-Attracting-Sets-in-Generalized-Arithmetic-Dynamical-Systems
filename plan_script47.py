# Wait, why was `lake lint` failing locally without build?
# Actually, the action says:
# `lake check-lint succeeded -> will run lake lint`
# `build: false -> will not run lake build`
# So the action is explicitly instructed NOT to build before linting, or perhaps linting usually builds what it needs?
# Wait! In lean4, `lake lint` does NOT automatically build the project!
# So setting `build: true` in the action will compile `lake build` before running `lake lint`. This will fix the issue.
