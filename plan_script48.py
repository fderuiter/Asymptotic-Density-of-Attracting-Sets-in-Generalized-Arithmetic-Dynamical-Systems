# The linter fails because of unused variable on Expansive5x1.lean:
# /home/runner/work/.../ArithmeticDynamics/SpecificModels/Expansive5x1.lean:15:1: error: @ArithmeticDynamics.SpecificModels.StationaryMeasure argument 2 π : Fin
# M → ℝ, argument 3 P : Matrix (Fin M) (Fin M) ℝ
# Wait, why doesn't my local linter complain?
# I updated nolints.json to ignore errors for "blueprintAttr" and "expected_drift", but the file Expansive5x1.lean was not ignored in my local `nolints.json` update because my local build failed with "ArithmeticDynamics/SpecificModels/Expansive5x1.lean:15:1: error: @ArithmeticDynamics.SpecificModels.StationaryMeasure argument 2 π..." Wait, my local linter passed!
# Let me check `scripts/nolints.json`
