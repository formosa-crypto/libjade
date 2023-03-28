require import AllCore IntDiv ZModP List EClib.
from Jasmin require import JModel.

(* modular operations modulo P *)
op p = 2^130 - 5 axiomatized by pE.

lemma two_pow130E: 2^130 = 1361129467683753853853498429727072845824 by done.

(* Embedding into ring theory *)


clone import ZModField  as Zp with
        op p <- p 
        rename "zmod" as "zp".

(* congruence "mod p" *)

lemma zpcgr_over a b:
 zpcgr (a + 1361129467683753853853498429727072845824 * b) (a + 5 * b).
proof.
have /= ->: (2^ 130) = 5 + p by rewrite pE.
by rewrite (mulzC _ b) mulzDr addzA modzMDr mulzC.
qed.

lemma inzp_over x:
 inzp (1361129467683753853853498429727072845824 * x) = inzp (5*x).
proof. by have /= := zpcgr_over 0 x; rewrite -eq_inzp. qed.

lemma zp_over_lt2p_red x:
 p <= x < 2*p =>
 x %% p = (x + 5) %% 2^130.
proof.
rewrite pE /= =>  H.
by rewrite  !modz_minus //= /#.
qed.

require import W64limbs.

op inzp_limbs base l = inzp (val_limbs base l).

lemma val_limbs64_div2130 x0 x1 x2:
 val_limbs64 [x0; x1; x2] %/ 2^130 = to_uint x2 %/ 4.
proof.
rewrite /val_digits /=.
have := (divz_eq (to_uint x2) 4).
rewrite addzC mulzC => {1}->.
rewrite !mulzDr -!mulzA /=.
smt(W64.to_uint_cmp pow2_64 modz_cmp).
qed.

lemma val_limbs64_mod2128 x0 x1 x2:
 val_limbs64 [x0; x1; x2] %% 2^128 = val_limbs64 [x0; x1].
proof.
rewrite /val_digits /= !mulzDr -!mulzA /= !addzA -modzDmr modzMr /= modz_small //.
apply bound_abs.
have ? := W64.to_uint_cmp x0.
have ? := W64.to_uint_cmp x1.
smt(W64.to_uint_cmp pow2_64 modz_cmp).
qed.
