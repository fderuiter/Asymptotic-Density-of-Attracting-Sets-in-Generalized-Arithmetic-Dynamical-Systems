import re
from pathlib import Path

docs = [
    ("ArithmeticDynamics/Algebra/QuasiPolynomial.lean", "def a"),
    ("ArithmeticDynamics/Algebra/QuasiPolynomial.lean", "def b"),
    ("ArithmeticDynamics/Computability/ChomskyBounds.lean", "inductive Le"),
    ("ArithmeticDynamics/Computability/ChomskyBounds.lean", "def State"),
    ("ArithmeticDynamics/Computability/ChomskyBounds.lean", "def transition"),
    ("ArithmeticDynamics/Computability/ChomskyBounds.lean", "def output"),
    ("ArithmeticDynamics/Computability/ChomskyBounds.lean", "def ObservationalEquivalence"),
    ("ArithmeticDynamics/Computability/ChomskyBounds.lean", "def ComputationalCapacity"),
    ("ArithmeticDynamics/Computability/Fractran.lean", "def Universal"),
    ("ArithmeticDynamics/Computability/Fractran.lean", "def prime_signature_dimension"),
    ("ArithmeticDynamics/ErgodicTheory/LogarithmicDrift.lean", "def classifySystem"),
    ("ArithmeticDynamics/ErgodicTheory/MarkovTransition.lean", "def IsPrimitive"),
    ("ArithmeticDynamics/ErgodicTheory/SpectralGap.lean", "def IsAperiodic"),
    ("ArithmeticDynamics/ErgodicTheory/SpectralGap.lean", "def HasProbabilisticIndependence"),
    ("ArithmeticDynamics/ErgodicTheory/SpectralGap.lean", "def SecondLargestEigenvalueAbs"),
    ("ArithmeticDynamics/SieveAnalytics/ReweightedMeasure.lean", "def markov_transfer_operator_M"),
    ("ArithmeticDynamics/SpecificModels/Expansive5x1.lean", "def TransitionMatrix"),
    ("ArithmeticDynamics/SpecificModels/Expansive5x1.lean", "def StationaryMeasure"),
    ("ArithmeticDynamics/SpecificModels/Expansive5x1.lean", "axiom collatz5x1_div_cond"),
    ("ArithmeticDynamics/SpecificModels/MinskyReduction.lean", "def GeneralizedCollatzMap"),
    ("ArithmeticDynamics/SpecificModels/MinskyReduction.lean", "def IsTuringComplete"),
    ("ArithmeticDynamics/SpecificModels/MinskyReduction.lean", "def branch_count"),
    ("ArithmeticDynamics/SpecificModels/PilotSystem.lean", "def pilot5_a"),
    ("ArithmeticDynamics/SpecificModels/PilotSystem.lean", "def pilot5_b"),
    ("ArithmeticDynamics/SpecificModels/PilotSystem.lean", "axiom pilot5_div_cond"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def unique_periodic_orbit"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def unique_equilibrium_state_for_all_potentials"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "inductive SystemClassification"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def d"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def a"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def b"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def passes_conway_filter"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def essential_spectral_radius"),
    ("ArithmeticDynamics/UniversalLaw/CorrespondenceTheorem.lean", "def classify_system"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def StateSpace"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def f"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def d"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "axiom d_ge_2"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def a"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def b"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def C"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def mu"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def lyapunov_exponent"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def metric_entropy"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def analytic_density"),
    ("ArithmeticDynamics/UniversalLaw/ScalingDuality.lean", "def expected_drift"),
    ("ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean", "def d"),
    ("ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean", "def S_matrix"),
    ("ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean", "def essential_spectral_radius"),
    ("ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean", "def analytic_density"),
    ("ArithmeticDynamics/UniversalLaw/SpectralThreshold.lean", "def support_hausdorff_dimension"),
    ("ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean", "def StateSpace"),
    ("ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean", "def f"),
    ("ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean", "def tau_f"),
    ("ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean", "def metric_entropy_tau_f"),
    ("ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean", "def periodic_orbits_finite"),
    ("ArithmeticDynamics/UniversalLaw/ThermodynamicFormalism.lean", "def all_continuous_potentials_have_equilibrium"),
]

for file, string in docs:
    p = Path(file)
    if not p.exists(): continue
    lines = p.read_text().split('\n')
    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith(string) or line.startswith("noncomputable " + string):
            if i > 0 and not lines[i-1].startswith('/--'):
                new_lines.append('/-- doc -/')
        new_lines.append(line)
        i += 1
    p.write_text('\n'.join(new_lines))
