import ArithmeticDynamics.Computability.Fractran
import ArithmeticDynamics.Computability.MinskyBounds

open ArithmeticDynamics.Computability
open ArithmeticDynamics.Computability.MinskyBounds

#eval fractranStep [2/3] 3

-- Minsky encoding test
#eval E (fun _ => 2) 2 3 () 1 1
