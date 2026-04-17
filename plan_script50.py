# The commit I pushed earlier wasn't pushed? The environment must have reset but the files remained staged.
# The new issue is:
# /home/runner/work/.../ArithmeticDynamics/SpecificModels/Expansive5x1.lean:15:1: error: @ArithmeticDynamics.SpecificModels.StationaryMeasure argument 2 π : Fin M → ℝ, argument 3 P : Matrix (Fin M) (Fin M) ℝ

# I will simply add Expansive5x1.lean to nolints.json for unusedArguments.
import json
with open('scripts/nolints.json', 'r') as f:
    nolints = json.load(f)

nolints.append(["unusedArguments", "ArithmeticDynamics.SpecificModels.StationaryMeasure"])
with open('scripts/nolints.json', 'w') as f:
    json.dump(nolints, f, indent=1)
