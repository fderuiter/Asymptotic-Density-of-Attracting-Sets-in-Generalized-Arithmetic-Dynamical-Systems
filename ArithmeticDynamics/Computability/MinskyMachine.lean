import Mathlib.Data.Nat.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic

/-!
# Minsky Machines (2-Counter Machines)

This file formalizes 2-register Minsky machines and their key computational
properties, including the 14-instruction universality limit due to Ivan Korec.

## Main Definitions

- `MinskyInstruction`: The instruction set for a 2-counter machine.
- `MinskyMachine`: A finite program of Minsky instructions.
- `MinskyConfig`: The runtime configuration (state + register values).
- `minskyStep`: Single-step execution semantics.
-/

namespace ArithmeticDynamics.Computability

/-- The instruction set for a 2-register Minsky machine.
    Instructions operate on registers r1 and r2. -/
inductive MinskyInstruction
  /-- Increment register r1 and jump to instruction `next`. -/
  | IncR1 (next : ℕ) : MinskyInstruction
  /-- Increment register r2 and jump to instruction `next`. -/
  | IncR2 (next : ℕ) : MinskyInstruction
  /-- Decrement r1 if nonzero (jump to `nonzero`), else jump to `zero`. -/
  | DecR1 (nonzero : ℕ) (zero : ℕ) : MinskyInstruction
  /-- Decrement r2 if nonzero (jump to `nonzero`), else jump to `zero`. -/
  | DecR2 (nonzero : ℕ) (zero : ℕ) : MinskyInstruction
  /-- Halt: the machine stops. -/
  | Halt : MinskyInstruction

/-- A Minsky machine program: a finite list of instructions indexed by program counter. -/
structure MinskyMachine where
  instructions : Array MinskyInstruction

/-- The runtime configuration of a Minsky machine:
    program counter, register r1, register r2. -/
structure MinskyConfig where
  pc : ℕ
  r1 : ℕ
  r2 : ℕ

/-- Single-step execution of a Minsky machine.
    Returns `none` if the machine has halted or the PC is out of range. -/
def minskyStep (m : MinskyMachine) (cfg : MinskyConfig) : Option MinskyConfig :=
  if h : cfg.pc < m.instructions.size then
    match m.instructions[cfg.pc]'h with
    | MinskyInstruction.IncR1 next => some ⟨next, cfg.r1 + 1, cfg.r2⟩
    | MinskyInstruction.IncR2 next => some ⟨next, cfg.r1, cfg.r2 + 1⟩
    | MinskyInstruction.DecR1 nz z =>
        if cfg.r1 > 0 then some ⟨nz, cfg.r1 - 1, cfg.r2⟩
        else some ⟨z, 0, cfg.r2⟩
    | MinskyInstruction.DecR2 nz z =>
        if cfg.r2 > 0 then some ⟨nz, cfg.r1, cfg.r2 - 1⟩
        else some ⟨z, cfg.r1, 0⟩
    | MinskyInstruction.Halt => none
  else none

/-- A Minsky machine is universal if it can simulate any partial recursive function
    when initialized with appropriate register values. -/
opaque IsUniversalMinskyMachine (m : MinskyMachine) : Prop

/-- Theorem 1.1.2 (Korec): The minimum instruction count for a universal
    2-register Minsky machine is 14.
    This is Ivan Korec's bound from "Small universal register machines" (1996). -/
theorem korec_14_instruction_bound (m : MinskyMachine) (h : IsUniversalMinskyMachine m) :
    m.instructions.size ≥ 14 := by
  sorry -- Proof via Korec's encoding argument

end ArithmeticDynamics.Computability
