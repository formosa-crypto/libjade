require import AllCore IntDiv CoreMap List Distr StdOrder Ring EClib W64limbs.
from Jasmin require import JModel.

require import Array2.

require import Crypto_verify_16_s.

abbrev good_ptr (ptr len : int) : bool = ptr <= ptr + len && ptr + len < W64.modulus.
abbrev zero_u64 = W64.zero.


hoare verify_h hold hnew hhp mem :  
   M.__crypto_verify_p_u8x16_r_u64x2 :
     good_ptr (W64.to_uint hhp) 16 /\ _h = hhp /\
     hold = to_uint (loadW128 mem (W64.to_uint hhp)) /\ h = hnew /\ Glob.mem = mem ==> Glob.mem = mem /\
     (res = W64.zero) = (hnew = Array2.init (fun (i : int) => (W64.of_int (hold %/ if i = 0 then 1 else 18446744073709551616)))).
proc => /=.
seq 2 : (#pre /\ (r = W64.zero) = (loadW64 Glob.mem (to_uint (_h + zero_u64)) = h.[0])); 1: by auto => /> &hr; rewrite W64.WRing.subr_eq0 /= /#.
seq 2 : (#pre /\ (t = W64.zero) = (loadW64 Glob.mem (to_uint (_h + W64.of_int 8)) = h.[1])); 1: by auto => /> &hr; rewrite W64.WRing.subr_eq0 /= /#.
seq 1 : (#{/~r}pre /\ 
        (r = zero_u64) = ((loadW64 Glob.mem (to_uint (_h + zero_u64)) = h.[0]) /\ (loadW64 Glob.mem (to_uint (_h + (of_int 8)%W64)) = h.[1]))); 
  1: by auto => /> &hr ?? <- <- /=; rewrite eq_iff;  smt(or0).
swap 2 -1.
seq 1 : (#{/~r}{/~t}pre /\ 
        cf = ((loadW64 Glob.mem (to_uint (_h + zero_u64)) = h.[0]) /\ (loadW64 Glob.mem (to_uint (_h + (of_int 8)%W64)) = h.[1]))); 1: by 
  auto => /> &hr ?? <- <-;rewrite /subc /borrow_sub /= /b2i  to_uint_eq /=;smt(W64.to_uint_cmp).
seq 2 : (#{/~t}pre /\ 
        (t = W64.one) = ((loadW64 Glob.mem (to_uint (_h + zero_u64)) = h.[0]) /\ (loadW64 Glob.mem (to_uint (_h + (of_int 8)%W64)) = h.[1]))); 1: by 
  auto => /> &hr; rewrite /set0_64_ /= /addc /=/ b2i to_uint_eq /= of_uintK /=;smt(W64.to_uint_cmp).
auto => /> &hr.
have -> : (t{hr} = W64.one) <=> (t{hr} - W64.one = W64.zero);1: by split;  smt(@W64).
move => ??->.
rewrite -load2u64 eq_iff tP.
split; last first.
move => H;move : (H 0 _) => //=; move : (H 1 _) => //= -> -> /=.
rewrite !to_uint2u64 /=.
have -> /= : to_uint (hhp + (W64.of_int 8)) = to_uint hhp + 1*8 
   by rewrite to_uintD_small /= /#. 
split.
+ rewrite to_uint_eq of_uintK /= mulrC modzMDr; smt(W64.to_uint_cmp pow2_64). 
rewrite to_uint_eq of_uintK /= mulrC divzMDr; smt(W64.to_uint_cmp pow2_64). 
move => [#] H0 H1 i ib.
rewrite initiE //= !to_uint2u64 /=.
case (i = 0).
+ move => -> /=; rewrite -H0;rewrite to_uint_eq of_uintK /= mulrC modzMDr; smt(W64.to_uint_cmp pow2_64). 
case (i = 1).
+ move => -> /=; rewrite -H1;rewrite to_uint_eq of_uintK /= mulrC divzMDr; 1: smt(). 
rewrite modz_small /=; 1: smt(W64.to_uint_cmp pow2_64). 
rewrite divz_small /=; 1: smt(W64.to_uint_cmp pow2_64). 
rewrite to_uintD_small /=; smt(W64.to_uint_cmp pow2_64). 
by smt().
qed.

lemma crypto_verify_p_u8x16_r_u64x2_ll : 
  islossless M.__crypto_verify_p_u8x16_r_u64x2 by islossless.

