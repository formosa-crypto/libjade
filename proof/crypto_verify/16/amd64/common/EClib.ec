require import AllCore IntDiv StdOrder List.
from Jasmin require import JModel.
require import Array2 WArray16.


import IntOrder.
import Ring.IntID.

lemma ltr_pmul2 x1 x2 y1 y2:
 0 <= x1 => 0 <= x2 => x1 < y1 => x2 < y2 => x1 * x2 < y1 * y2.
proof.
case: (x1 <= 0) => *.
 smt().
have HH1: 0 < x1 by smt().
apply (ltz_trans (x1 * y2)).
 by rewrite (StdOrder.IntOrder.ltr_pmul2l _ HH1).
have HH2: 0 < y2 by smt().
by rewrite (StdOrder.IntOrder.ltr_pmul2r _ HH2).
qed.

lemma divzU a b q r:
 0 <= r < `|b|%Int => a = b*q+r => q=a%/b.
proof.
move=> H H0.
have H1:= divz_eq a b.
have [??] := euclideU b q (a%/b) r (a%%b) _ _ _ => //.
 by rewrite mulzC -H0 {1}H1.
smt(modz_ge0 ltz_mod).
qed.

lemma divz_div a b c:
 0<b => 0<c => a %/ b %/ c = a %/ (b * c).
proof.
move=> *.
apply (divzU _ _ _ (b*((a%/b)%%c) + a %% b)).
 apply bound_abs; split.
  smt(StdOrder.IntOrder.mulr_ge0 addz_ge0 modz_ge0).
 move => *.
 apply (StdOrder.IntOrder.ltr_le_trans (b * (a %/ b %% c) + b)).
  rewrite StdOrder.IntOrder.ltr_add2l; smt(modz_cmp).
 have ->: b * (a %/ b %% c) + b = b * (a %/ b %% c + 1) by smt().
 have -> := (StdOrder.IntOrder.ler_pmul2l b _) => //.
 have := modz_cmp (a%/b) c _; smt().
rewrite {1}(divz_eq a b) addzA; congr.
rewrite mulzA -mulzDr mulzC; congr.
by rewrite {1}(divz_eq (a%/b) c); ring.
qed.

lemma modz_minus x d:
 (d <= x < 2*d)%Int => x %% d = x-d.
proof.
move=> *; have {1}->: x = x-d+d by smt().
rewrite -modzDm modzz /= modz_mod modz_small //.
by apply bound_abs; smt().
qed.

lemma iota_split len2 n len:
 0 <= len2 <= len =>
 iota_ n len = iota_ n len2 ++ iota_ (n+len2) (len-len2).
proof.
move=> H; have E: len = len2 + (len - len2) by smt().
by rewrite {1} E iota_add // /#.
qed.

require import W64limbs.

(* different views on datatypes *)
lemma of_int2u64 i0 i1:
 pack2 [ W64.of_int i0; W64.of_int i1] = W128.of_int (i0 %% W64.modulus + W64.modulus * i1).
proof.
rewrite W2u64.of_uint_pack2 -iotaredE /=; congr; congr;congr.
 apply W64.word_modeqP; congr.
 by rewrite !of_uintK mulzC modzMDr !modz_mod.
rewrite mulzC divzMDr //.
have ->:i0 %% 18446744073709551616 %/ 18446744073709551616 = 0 by smt(modz_cmp divz_eq0).
by rewrite !of_intE modz_mod.
qed.

lemma to_uint_unpack2u64 w:
 W128.to_uint w = val_digits W64.modulus (map W64.to_uint (W2u64.to_list w)).
proof.
have [? ?]:= W128.to_uint_cmp w.
rewrite /val_digits /=.
do 2! (rewrite bits64_div 1:// /=).
rewrite !of_uintK /=.
have P: forall x,
         x = x %% 18446744073709551616 + 18446744073709551616 * (x %/ 18446744073709551616).
 by move=> x; rewrite {1}(divz_eq x 18446744073709551616) /=; ring.
rewrite {1}(P (to_uint w)) {1}(P (to_uint w %/ 18446744073709551616)) divz_div 1..2:/# /=.
ring. 
by rewrite divz_small; 1: by rewrite gtr0_norm; smt(W128.to_uint_cmp pow2_128).
qed.

lemma to_uint2u64 w0 w1:
 to_uint (W2u64.pack2 [w0; w1]) = to_uint w0 + W64.modulus * to_uint w1.
proof. by rewrite to_uint_unpack2u64. qed.

lemma to_uint_unpack4u32 w:
 W128.to_uint w = val_digits W32.modulus (map W32.to_uint (W4u32.to_list w)).
proof.
have [? ?]:= W128.to_uint_cmp w.
rewrite /val_digits /=.
do 4! (rewrite bits32_div 1:// /=).
rewrite !of_uintK /=.
have P: forall x, x = x %% 4294967296 + 4294967296 * (x %/ 4294967296).
 by move=> x; rewrite {1}(divz_eq x 4294967296) /=; ring.
rewrite {1}(P (to_uint w)) {1}(P (to_uint w %/ 4294967296)) divz_div 1..2:/#
        {1}(P (to_uint w %/ 18446744073709551616)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 79228162514264337593543950336)) divz_div 1..2:/# /=.
ring;smt(pow2_128).
qed.

lemma to_uint_unpack16u8 w:
 W128.to_uint w = val_digits W8.modulus (map W8.to_uint (W16u8.to_list w)).
proof.
have [? ?]:= W128.to_uint_cmp w.
rewrite /val_digits /=.
do 16! (rewrite bits8_div 1:// /=).
have P: forall x, x = x %% 256 + 256 * (x %/ 256).
 by move=> x; rewrite {1}(divz_eq x W8.modulus) /=; ring.
rewrite {1}(P (to_uint w)) {1}(P (to_uint w %/ 256)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 65536)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 16777216)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 4294967296)) divz_div 1..2:/# /=.
rewrite {1}(P (to_uint w %/ 1099511627776)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 281474976710656)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 72057594037927936)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 18446744073709551616)) divz_div 1..2:/# /=.
rewrite {1}(P (to_uint w %/ 4722366482869645213696)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 1208925819614629174706176)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 309485009821345068724781056)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 79228162514264337593543950336)) divz_div 1..2:/# /=.
rewrite {1}(P (to_uint w %/ 20282409603651670423947251286016)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 5192296858534827628530496329220096)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 1329227995784915872903807060280344576)) divz_div 1..2:/# /=.
ring; smt(pow2_128).
qed.

lemma to_uint_unpack8u8 w:
 W64.to_uint w = val_digits W8.modulus (map W8.to_uint (W8u8.to_list w)).
proof.
have [? ?]:= W64.to_uint_cmp w.
rewrite /val_digits /=.
do 8! (rewrite bits8_div 1:// /=).
have P: forall x, x = x %% 256 + 256 * (x %/ 256).
 by move=> x; rewrite {1}(divz_eq x 256) /=; ring.
rewrite {1}(P (to_uint w)) {1}(P (to_uint w %/ 256)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 65536)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 16777216)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 4294967296)) divz_div 1..2:/# /=.
rewrite {1}(P (to_uint w %/ 1099511627776)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 281474976710656)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 72057594037927936)) divz_div 1..2:/# /=
        {1}(P (to_uint w %/ 18446744073709551616)) divz_div 1..2:/# /=.
ring; smt(pow2_64).
qed.

lemma pack8u8_init_mkseq f:
 pack8_t (init f)%W8u8.Pack = pack8 (mkseq f 8).
proof. by rewrite W8u8.Pack.init_of_list. qed.

lemma load8u8' mem p:
 loadW64 mem p = pack8 (mkseq (fun i => mem.[p+i]) 8).
proof.
rewrite /mkseq /= /loadW64; congr.
by rewrite W8u8.Pack.init_of_list.
qed.


lemma WArray16_init64K (f:int -> W8.t):
  WArray16.init64 ("_.[_]" (Array2.init (WArray16.get64 (WArray16.init f)))) = WArray16.init f.
proof.
rewrite /WArray16.init64.
apply WArray16.init_ext => x xb /=. 
rewrite Array2.initE /=.
have ->/=:  0 <= x %/ 8 < 2 by smt().
rewrite WArray16.get64E /= pack8bE /=; first smt().
rewrite W8u8.Pack.initE.
have ->/=: 0 <= x %% 8 < 8 by smt().
rewrite WArray16.initiE; smt().
qed.

lemma loadW128_storeW128_eq mem ptr a : 
   loadW128 (storeW128 mem ptr a) ptr = a.
proof.
  rewrite /loadW128 storeW128E.
  rewrite -{2}(W16u8.unpack8K a);congr.
  apply W16u8.Pack.packP => i hi. 
  rewrite initE hi /= get_storesE /= get_unpack8 1:// /#.
qed.

