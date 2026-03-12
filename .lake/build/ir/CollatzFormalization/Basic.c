// Lean compiler output
// Module: CollatzFormalization.Basic
// Imports: public import Init public import Mathlib.Data.Nat.Basic public import Mathlib.Data.Int.Basic public import Mathlib.Data.ZMod.Basic public import Mathlib.Algebra.Divisibility.Basic public import Mathlib.Tactic
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* lean_nat_mod(lean_object*, lean_object*);
lean_object* lean_nat_to_int(lean_object*);
lean_object* lean_int_mul(lean_object*, lean_object*);
lean_object* lean_int_add(lean_object*, lean_object*);
lean_object* lean_int_ediv(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_collatz__formalization_GenCollatzMap_apply__map___redArg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_collatz__formalization_GenCollatzMap_apply__map(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_collatz__formalization_GenCollatzMap_apply__map___redArg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14;
x_4 = lean_ctor_get(x_2, 0);
lean_inc_ref(x_4);
x_5 = lean_ctor_get(x_2, 1);
lean_inc_ref(x_5);
lean_dec_ref(x_2);
x_6 = lean_nat_mod(x_3, x_1);
lean_inc(x_6);
x_7 = lean_apply_1(x_4, x_6);
x_8 = lean_nat_to_int(x_7);
x_9 = lean_nat_to_int(x_3);
x_10 = lean_int_mul(x_8, x_9);
lean_dec(x_9);
lean_dec(x_8);
x_11 = lean_apply_1(x_5, x_6);
x_12 = lean_int_add(x_10, x_11);
lean_dec(x_11);
lean_dec(x_10);
x_13 = lean_nat_to_int(x_1);
x_14 = lean_int_ediv(x_12, x_13);
lean_dec(x_13);
lean_dec(x_12);
return x_14;
}
}
LEAN_EXPORT lean_object* lp_collatz__formalization_GenCollatzMap_apply__map(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5;
x_5 = lp_collatz__formalization_GenCollatzMap_apply__map___redArg(x_1, x_3, x_4);
return x_5;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Nat_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_Int_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Data_ZMod_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Algebra_Divisibility_Basic(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Tactic(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_collatz__formalization_CollatzFormalization_Basic(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Nat_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_Int_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Data_ZMod_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Algebra_Divisibility_Basic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Tactic(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
