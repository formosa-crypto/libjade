require import AllCore StdRing IntDiv StdOrder List. 
from Jasmin require import JModel.

import IntOrder Ring.IntID.

abbrev MAX x y = if (x < y)%Int then y else x.

(**********************************************************************************************

                                          W64 DIGITS

**********************************************************************************************)


op val_digits (base: int) (x: int list) =
 foldr (fun w r => w + base * r) 0 x.

lemma val_digits_nil base: val_digits base [] = 0 by done.

lemma val_digits_cons base x xs: val_digits base (x::xs) = x + base * val_digits base xs by done.

lemma val_digits_cat base x y:
 val_digits base (x++y) = val_digits base x + base^(size x) * val_digits base y.
proof.
elim: x => //= x xs IH /=.
rewrite !val_digits_cons IH (addrC (1)) exprSr.
 by apply size_ge0. 
by ring.
qed.

op add_digits (x y: int list) : int list =
 with x="[]", y="[]" => []
 with x=(::) _ _, y="[]" => x
 with x="[]", y=(::) _ _ => y
 with x=(::) x xs, y=(::) y ys => (x+y)::add_digits xs ys.
 
lemma add_digits_nill y: add_digits [] y = y by case y.

lemma add_digits_nilr x: add_digits x [] = x by case x.

lemma add_digits_cons x xs y ys:
 add_digits (x::xs) (y::ys) = (x+y) :: add_digits xs ys by done.

lemma add_digitsP x y base:
 val_digits base (add_digits x y) = val_digits base x + val_digits base y.
proof.
elim: x y => /= [ys|x xs IH].
 by rewrite val_digits_nil add_digits_nill. 
elim => //= y ys IH2 /=.
by rewrite !val_digits_cons IH; ring.
qed.

op mul1_digits (x:int) (y: int list): int list = map (fun h => x*h) y.

lemma mul1_digitsCE x y:
 mul1_digits x y = List.map (transpose Int.( * ) x) y.
proof. by elim: y => //= y ys IH => @/mul1_digits /=; split; 1: ring. qed.

lemma mul1_digitsP x y base:
 val_digits base (mul1_digits x y) = x * val_digits base y.
proof.
elim: y; first by rewrite /mul1_digits.
by move=> y ys; rewrite /mul1_digits /= !val_digits_cons => ->; ring.
qed.

op mul_digits (x y: int list) : int list =
 with x="[]" => []
 with x=(::) x xs => add_digits (mul1_digits x y) (0::mul_digits xs y).

lemma mul_digitsP x y base:
 val_digits base (mul_digits x y) = val_digits base x * val_digits base y.
proof.
elim: x => // x xs IH.
rewrite /= add_digitsP /= mul1_digitsP !val_digits_cons IH; ring.
qed.





(**********************************************************************************************

                                          WORD BOUNDS

**********************************************************************************************)


(** [ubW64 bound] is a predicate that bounds the content of a W64 register *)  
op ubW64 (n:int) (x: W64.t) = to_uint x <= n.

lemma ubW64T (x: W64.t):
 ubW64 W64.max_uint x.
proof.
rewrite /ubW64 -(lez_add2r 1) W64.max_uintS -ltzE.
by have := (W64.to_uint_cmp x).
qed.

lemma ubW64ge0 nx x:
 ubW64 nx x => 0 <= nx.
proof. rewrite /ubW64; smt(W64.to_uint_cmp). qed.

lemma ubW640 (x: W64.t):
 ubW64 0 x <=> x=W64.zero.
proof. 
rewrite /ubW64; split => H.
 have <-: W64.of_int (to_uint x) = W64.of_int 0.
  congr; by smt(W64.to_uint_cmp).
 by rewrite to_uintK.
by rewrite H to_uint0.
qed.

lemma ubW641 (b: bool):
 ubW64 1 (W64.of_int (b2i b)).
proof. by case: b. qed.

lemma ubW64W n1 n2 (x: W64.t):
 (n1 <= n2)%Int =>
 ubW64 n1 x =>
 ubW64 n2 x.
proof.
rewrite /ubW64 => H H0.
by apply (lez_trans _ _ _ H0 H).
qed.

lemma ubW64D nx ny (x y: W64.t):
 ubW64 nx x =>
 ubW64 ny y =>
 ubW64 (nx+ny) (x+y).
proof. by rewrite /ubW64 to_uintD; smt (le_modz W64.to_uint_cmp). qed.

lemma ubW64M nx ny (x y: W64.t):
 ubW64 nx x =>
 ubW64 ny y =>
 ubW64 (nx*ny) (x*y).
proof. rewrite /ubW64 to_uintM; smt(ler_pmul le_modz W64.to_uint_cmp). qed.

lemma ubW64Mhi nx ny (x y: W64.t):
 ubW64 nx x =>
 ubW64 ny y =>
 ubW64 ((nx*ny) %/ W64.modulus) (mulhi x y).
proof.
rewrite /ubW64 /mulhi => *.
rewrite of_uintK modz_small.
 have ?: to_uint x * to_uint y %/ W64.modulus < W64.modulus.
  have := (divz_cmp W64.modulus (to_uint x * to_uint y) W64.modulus _ _); first smt().
   split; move=> *. 
    smt (mulr_ge0 W64.to_uint_cmp).
   by apply ltr_pmul; have := W64.to_uint_cmp; smt().
  by move=> [? ?].
 split; move=> *.
  rewrite divz_ge0 1:/#.
  by apply mulr_ge0;  smt(W64.to_uint_cmp).
 by apply (ltr_le_trans W64.modulus).
apply leq_div2r; last by apply W64.ge0_modulus.
by apply ler_pmul; smt (W64.to_uint_cmp).
qed.

lemma ubW64_mulhi0 nx ny x y:
 ubW64 nx x =>
 ubW64 ny y =>
 nx * ny < W64.modulus =>
 to_uint (mulhi x y) = 0.
proof.
move=> H H0 ?.
move: (ubW64Mhi _ _ _ _ H H0).
rewrite /mulhi divz_small.
 apply bound_abs; split => //.
 smt(ubW64ge0).
by rewrite ubW640 => ->.
qed.

lemma ubW64shr k n (x: W64.t):
 0 <= k =>
 ubW64 n x =>
 ubW64 (n %/ 2^k) (x `>>>` k).
proof.
move=> ? H0;
rewrite /ubW64 to_uint_shr //.
apply leq_div2r.
 by apply H0.
smt(gt0_pow2).
qed.

lemma ubW64shl k n (x: W64.t):
 0 <= k =>
 ubW64 n x =>
 ubW64 (2^k * n) (x `<<<` k).
proof.
move=> *;
rewrite /ubW64 to_uint_shl // mulzC.
apply (ler_trans (2 ^ k * to_uint x)).
 apply le_modz; apply mulr_ge0; smt(gt0_pow2 W64.to_uint_cmp).
apply ler_wpmul2l; smt(gt0_pow2).
qed.

lemma ubW64andlsb k n (x: W64.t):
 0 <= k =>
 ubW64 n x =>
 ubW64 (2^k -1) (x `&` W64.masklsb k).
proof.
move=> ?; rewrite /ubW64 to_uint_and_mod 1:/#  => ?.
have := modz_cmp (to_uint x) (2^k) _.
 by apply gt0_pow2.
smt().
qed.

lemma ubW64Wand n (x y: W64.t):
 ubW64 n x =>
 ubW64 n (x `&` y).
proof.
rewrite /ubW64 => *.
apply (ler_trans (to_uint x)) => //.
have := (W64.ule_andw x y).
by rewrite uleE; apply.
qed.

lemma ubW64D_to_uint n1 n2 x y:
 (n1+n2 < W64.modulus)%Int =>
 ubW64 n1 x =>
 ubW64 n2 y =>
 to_uint (x+y) = to_uint x + to_uint y.
proof.
rewrite /ubW64 => *.
rewrite to_uintD_small //.
apply (ler_lt_trans (n1+n2)) => //.
by apply ler_add.
qed.

lemma ubW64M_to_uint n1 n2 x y:
 (n1*n2 < W64.modulus)%Int =>
 ubW64 n1 x =>
 ubW64 n2 y =>
 to_uint (x*y) = to_uint x * to_uint y.
proof.
rewrite /ubW64 => *.
rewrite to_uintM_small //.
apply (ler_lt_trans (n1*n2)) => //.
apply ler_pmul => //; smt(W64.to_uint_cmp).
qed.

(** [bW64 nbits] is a predicate that bounds the "live bits" of a register *)  
op bW64 size (w: W64.t) : bool = 0 <= size && to_uint w < 2^size
 axiomatized by bW64E.

lemma bW64_pos size w: bW64 size w => 0 <= size.
proof. by rewrite bW64E => />. qed.

lemma bW64P size x: bW64 size x => 0 <= size /\ ubW64 (2^size - 1) x.
proof. rewrite bW64E /ubW64; smt(). qed.

lemma bW64ub size x: 0 <= size => bW64 size x <=> ubW64 (2^size - 1) x.
proof.
move=> *; split; first by smt(bW64P).
rewrite /ubW64 bW64E /#.
qed.

(* *)

lemma bW64T (x: W64.t) : bW64 64 x.
proof. by rewrite bW64ub //; apply ubW64T. qed.

lemma bW64_0: bW64 0 W64.zero.
proof. by rewrite bW64E W64.to_uint0. qed.

lemma bW64_1: bW64 1 W64.one.
proof. by rewrite bW64E W64.to_uint1. qed.

lemma bW64W n1 n2 (x: W64.t):
 (n1 <= n2)%Int =>
 bW64 n1 x =>
 bW64 n2 x.
proof.
move=> ? /bW64P [? ?]; rewrite bW64ub 1:/#.
apply (ubW64W (2 ^ n1 - 1)) => //.
apply ler_sub => //. 
apply ler_weexpn2l => //.
qed.

lemma bW64D nx ny (x y: W64.t):
 bW64 nx x =>
 bW64 ny y =>
 bW64 (max nx ny + 1) (x+y).
proof.
move=> /bW64P [H H0] /bW64P [H1 H2]; rewrite bW64ub 1:/#.
have T := (ubW64D _ _ _ _ H0 H2).
apply (ubW64W _ _ _ _ T).
apply (lez_trans (2^(max nx ny + 1)-1)).
 rewrite exprSr 1:/#.
 case: (nx <= ny) => ?.
  apply (ler_trans (2 ^ ny - 1 + (2 ^ ny - 1))); 1: smt(ler_weexpn2l). 
  smt(ler_weexpn2l).
 smt(ler_weexpn2l).
smt(ler_weexpn2l).
qed.

lemma bW64DW nx ny (x y: W64.t) n:
 max nx ny < n =>
 bW64 nx x =>
 bW64 ny y =>
 bW64 n (x+y).
proof.
move=> *; apply (bW64W (max nx ny + 1)); first smt().
by apply bW64D.
qed.

lemma bW64M nx ny (x y: W64.t):
 bW64 nx x =>
 bW64 ny y =>
 bW64 (nx+ny) (x*y).
proof.
move=> /bW64P [H H0] /bW64P [H1 H2].
rewrite bW64ub 1:/#.
have T := (ubW64M _ _ _ _ H0 H2).
apply (ubW64W _ _ _ _ T); clear T.
have ->: (2 ^ nx - 1) * (2 ^ ny - 1) = 2 ^ (nx+ny) - 2 ^ nx - 2 ^ ny + 1.
+ by rewrite exprD_nneg //;ring.
smt(gt0_pow2).
qed.

lemma bW64mask n x:
 0 <= n =>
 bW64 n (andw x (W64.masklsb n)).
proof.
rewrite bW64E /mask => /> *.
rewrite to_uint_and_mod 1:/#.
have HH: 0 < 2^n by apply gt0_pow2.
by move: (modz_cmp (to_uint x) (2^n) HH); smt(). 
qed.

lemma nosmt bW64andmaskE n w:
 0 <= n => bW64 n w <=> w = w `&` W64.masklsb n.
proof.
move=> *; split; last by move=> ->; apply bW64mask.
rewrite bW64ub // /ubW64 => ?.
apply W64.word_modeqP; rewrite !modz_small;
 first 2 by apply bound_abs; apply W64.to_uint_cmp.
rewrite to_uint_and_mod 1:/#  modz_small //.
by apply bound_abs; smt(W64.to_uint_cmp).
qed.

(* packed lemmas for SMT calls *)
theory BW64.

lemma bW64T' n (x: W64.t) : 64 <= n => bW64 n x.
proof. by move => ?; apply (bW64W 64) => //; apply bW64T. qed.

lemma bW64const n (c: int) : 0 <= n => 0 <= c < 2^n => bW64 n (W64.of_int c).
proof. 
move=> H [??]; rewrite bW64E.
rewrite of_uintK.
case: (c < W64.modulus) => *.
 rewrite modz_small; first by apply bound_abs; split => // /#.
 smt().
rewrite H /=.
have [? H4]:= modz_cmp c W64.modulus _; first by apply W64.gt0_modulus.
have ?: W64.modulus < 2^n.
 apply (ler_lt_trans c); by rewrite // lezNgt.
by apply (ltz_trans _ _ _ H4).
qed.

lemma bW64W' n1 n2 (x: W64.t):
 (n1 <= n2)%Int =>
 bW64 n1 x =>
 bW64 n2 x.
proof. by move=> *; apply (bW64W n1). qed.


lemma bW64DW n x1 x2: bW64 (n-1) x1 => bW64 (n-1) x2 => bW64 n (x1+x2).
proof. by move=> *; apply (bW64D (n-1) (n-1)). qed.

lemma bW64MW nx (x y: W64.t) (n: int):
 bW64 nx x =>
 bW64 (n-nx) y =>
 bW64 n (x*y).
proof. 
move=> *; apply (bW64W (nx + (n-nx))); first smt().
by apply bW64M.
qed.

lemma bW64_shr n k x:
 0 <= k < 64 => 0 <= n => bW64 (n+k) x => bW64 n (x `>>` W8.of_int k).
proof.
move=> /> ???.
case: (n < 64); last first.
 move=> ??; apply (bW64W 64); first smt ().
 by apply bW64T.
rewrite !bW64E => /> ??H4 ?.
rewrite to_uint_shr.
 by rewrite of_uintK; smt(modz_small).
have ->: (to_uint ((of_int k))%W8 %% 64) = k
 by rewrite of_uintK; smt(modz_small).
move: H4;rewrite exprD_nneg //= => *.
have := (divz_cmp (2^k) (to_uint x) (2^n) _ _); first by apply gt0_pow2.
 smt(W64.to_uint_cmp).
smt().
qed.

lemma bW64_shrw n k x:
 0 <= k < 64 => 0 <= n => bW64 (n+k) x => bW64 n (x `>>>` k).
proof. by move=> *; rewrite -W64.shr_shrw //; apply bW64_shr. qed.

lemma bW64_shl n k x:
 0 <= k < 64 => 0 <= n => bW64 (n-k) x => bW64 n (x `<<` W8.of_int k).
proof.
move=> /> ???.
case: (n < 64); last first.
 move=> ??; apply (bW64W 64); first smt ().
 by apply bW64T.
rewrite !bW64E => /> H4.
rewrite to_uint_shl.
 by rewrite of_uintK; smt(modz_small).
have ->: (to_uint ((of_int k))%W8 %% 64) = k
 by rewrite of_uintK; smt(modz_small).
move: H4; rewrite -(ltr_pmul2r (2^k)); first by apply gt0_pow2.
rewrite ltr_pmul2r 1:gt0_pow2  => H3 ?. 
rewrite exprD_subz 1,2: /# ltz_divRL; first by apply gt0_pow2. 
+ apply dvdz_exp2l; 1: by smt().
move => H4.
rewrite modz_small //.
apply bound_abs; split => *; first smt(divr_ge0 W64.to_uint_cmp gt0_pow2).
apply (ltr_le_trans (2 ^ n) _ _ H4). 
apply ler_weexpn2l; smt().  
qed.

lemma bW64_shlw n k x:
 0 <= k < 64 => 0 <= n => bW64 (n-k) x => bW64 n (x `<<<` k).
proof. by move=> *; rewrite -W64.shl_shlw //; apply bW64_shl. qed.

end BW64.

(* 
   variants of [to_uintX_small]
   ============================
*)

lemma bW64_to_uintD x y: 
 bW64 63 x => bW64 63 y => to_uint (x+y) = to_uint x + to_uint y.
proof.
rewrite !bW64E => /> *.
by rewrite W64.to_uintD_small /#.
qed.

lemma bW64_to_uintM nx ny x y:
 (nx+ny <= 64)%Int => bW64 nx x => bW64 ny y => to_uint (x*y) = to_uint x * to_uint y.
proof.
rewrite !bW64E => /> *; apply W64.to_uintM_small.
move: (W64.to_uint_cmp x) (W64.to_uint_cmp y) => *.
apply (StdOrder.IntOrder.ltr_le_trans (2^nx * 2^ny)).
apply ltr_pmul; smt(W64.to_uint_cmp).
rewrite -exprD_nneg //; apply ler_weexpn2l => //. 
smt().
qed.


(**********************************************************************************************

                                    REDUNDANT LIMBS

**********************************************************************************************)

abbrev digits64 = List.map W64.to_uint.
abbrev val_limbs base l = val_digits base (digits64 l).
abbrev bW64_limbs w = List.all (bW64 w).

lemma val_limbs_cat base x y:
 val_limbs base (x++y) = val_limbs base x + base^(size x) * val_limbs base y.
proof.
have ->: val_limbs base (x ++ y)
         = val_digits base (digits64 x ++ digits64 y) by rewrite -map_cat.
by rewrite val_digits_cat size_map.
qed.

lemma bW64W_limbs n1 n2 (x: W64.t list):
 (n1 <= n2)%Int =>
 bW64_limbs n1 x =>
 bW64_limbs n2 x.
proof.
move=> ?; elim: x => //= x xs IH [??]; split; first by apply (bW64W n1).
by apply IH.
qed.

op add_limbs (x y: W64.t list) : W64.t list =
 with x="[]", y="[]" => []
 with x=(::) _ _, y="[]" => x
 with x="[]", y=(::) _ _ => y
 with x=(::) x xs, y=(::) y ys => (x+y)::add_limbs xs ys.

lemma add_limbs_nill y: add_limbs [] y = y by case y.
lemma add_limbs_nilr x: add_limbs x [] = x by case x.
lemma add_limbs_cons x xs y ys: add_limbs (x::xs) (y::ys) = (x+y)::add_limbs xs ys
 by done.

lemma size_add_limbs x y:
 size (add_limbs x y) = max (size x) (size y).
proof.
elim: x y => //=.
 move=> y; rewrite add_limbs_nill ler_maxr //; apply size_ge0.
move=> x xs IH; elim => //=.
 by rewrite ler_maxl; smt(size_ge0).
move=> y IH2; rewrite IH /#.
qed.

lemma add_limbsP x y base:
 bW64_limbs 63 x =>
 bW64_limbs 63 y =>
 val_limbs base (add_limbs x y) = val_limbs base x + val_limbs base y.
proof.
elim: x y => //= ? ?.
 by rewrite add_limbs_nill val_digits_nil.
move=> IH; elim => //= y ys IH2 [? ?] [? ?].
by rewrite !val_digits_cons IH // bW64_to_uintD //; ring.
qed.

lemma bW64D_limbs nx ny (x y: W64.t list):
 bW64_limbs nx x =>
 bW64_limbs ny y =>
 bW64_limbs (max nx ny + 1) (add_limbs x y).
proof.
elim: x y => /= ?.
 rewrite add_limbs_nill; apply bW64W_limbs; smt().
move=> xs IH; elim => /=.
 move=> [??]; split.
  by apply (bW64W nx); smt().
 by apply (bW64W_limbs nx); smt().
move=> y ys IH2 [??] [??]; split.
 by apply bW64D.
by apply IH.
qed.

op mul1_limbs (x:W64.t) (y: W64.t list): W64.t list = map (fun h => x*h) y
 axiomatized by mul1_limbsE.

hint simplify mul1_limbsE.

lemma bW64M1_limbs nx ny (x: W64.t) (y:W64.t list):
 bW64 nx x =>
 bW64_limbs ny y =>
 bW64_limbs (nx+ny) (mul1_limbs x y).
proof.
move=> Hx; elim: y => //= y ys IH [??]; split; first by apply bW64M.
by apply IH.
qed.

lemma mul1_limbsP nx ny x y base:
 (nx + ny <= 64)%Int =>
 bW64 nx x =>
 bW64_limbs ny y =>
 val_limbs base (mul1_limbs x y) = to_uint x * val_limbs base y.
proof.
move=> Hn Hx; elim: y => //= y ys IH [? ?].
by rewrite !val_digits_cons (bW64_to_uintM nx ny) // IH //; ring.
qed.

op mul_limbs (x y: W64.t list) : W64.t list =
 with x="[]" => []
 with x=(::) x xs => add_limbs (mul1_limbs x y) (W64.zero::mul_limbs xs y).

lemma bW64M_limbs_nilr x: all (bW64 0) (mul_limbs x []).
proof. by elim: x => //= x xs; split; first apply bW64_0. qed.

lemma bW64M_limbs nx ny (x y:W64.t list):
 0 <= ny =>
 bW64_limbs nx x =>
 bW64_limbs ny y =>
 bW64_limbs (nx+ny+size x) (mul_limbs x y).
proof.
move=> H; elim: x y => //= x xs IH; elim => /=.
 move=> [??]; split.
  apply (bW64W 0); first smt(size_ge0 bW64_pos).
  by apply bW64_0.
 apply (bW64W_limbs 0); first smt(size_ge0 bW64_pos).
 by apply bW64M_limbs_nilr.
move=> y ys IH2 [??] [??]; split.
 smt(@BW64 size_ge0).
apply (bW64W_limbs (max (nx+ny) (nx+ny+size xs) + 1)); first smt(size_ge0).
apply bW64D_limbs.
 by rewrite -(mul1_limbsE x); apply bW64M1_limbs.
by apply IH.
qed.

lemma mul_limbsP nx ny x y base:
 0 <= ny =>
 (nx + ny + size x <= 64)%Int =>
 bW64_limbs nx x =>
 bW64_limbs ny y =>
 val_limbs base (mul_limbs x y) = val_limbs base x * val_limbs base y.
proof.
move=> Hny; elim: x => //= x xs IH ? [??] ?.
rewrite add_limbsP.
  apply (bW64W_limbs (nx+ny)); first smt(size_ge0).
  by rewrite -(mul1_limbsE x); apply bW64M1_limbs.
 rewrite /= (bW64W 0) //=; first by rewrite bW64_0.
 rewrite (bW64W_limbs (nx+ny+size xs)); first smt(size_ge0).
 by apply bW64M_limbs.
rewrite /= !val_digits_cons IH //; first smt().
rewrite -(mul1_limbsE x) (mul1_limbsP nx ny) //; first smt(size_ge0).
by ring.
qed.


(**********************************************************************************************

                                    NON-REDUNDANT LIMBS

**********************************************************************************************)

op nth_digits (x: int list) (n: int) : int = nth 0 x n.

abbrev val_digits64 = val_digits (2^64).
abbrev val_limbs64 x = val_digits64 (digits64 x).

lemma val_limbs64_cons x xs:
 val_limbs64 (x::xs) = to_uint x + 2^64 * val_limbs64 xs.
proof. by rewrite /= val_digits_cons. qed.

op nth_limbs64 (x: W64.t list) (n: int) = nth W64.zero x n.

lemma to_uint_nth_limbs64 x n:
 to_uint (nth_limbs64 x n) = nth_digits (digits64 x) n.
proof.
rewrite /nth_limbs64 /nth_digits; elim: x n => //= x xs IH n.
by case: (n=0) => //= ?; rewrite IH.
qed.

op carryprop_limbs64 (x: W64.t list) (c: bool) : bool * W64.t list =
 with x = "[]" => (c, [])
 with x = (::) y ys => let (c',ys') = carryprop_limbs64 ys (carry_add W64.zero y c)
                       in (c', (y + W64.of_int (b2i c))::ys').

lemma carryprop_limbs64_nil c: carryprop_limbs64 [] c = (c, []) by done.
lemma carryprop_limbs64_cons x xs c:
 carryprop_limbs64 (x::xs) c = let (c',xs') = carryprop_limbs64 xs (carry_add W64.zero x c)
                               in (c', (x + W64.of_int (b2i c))::xs') by done.

lemma size_carryprop_limbs64 x c:
 size (carryprop_limbs64 x c).`2 = size x.
proof.
elim: x c => //= x xs IH c.
by rewrite -(IH (carry_add W64.zero x c)); case: (carryprop_limbs64 xs (carry_add W64.zero x c)).
qed.

lemma carryprop_limbs64P x c:
 (let (c',z) = carryprop_limbs64 x c
 in val_limbs64 z + 2^(64*size x) * b2i c') = val_limbs64 x + b2i c.
proof.
elim: x c => //= x xs IH c.
have := (IH (carry_add W64.zero x c)).
case: (carryprop_limbs64 xs (carry_add W64.zero x c)) => x1 x2 /=.
rewrite !val_digits_cons.
have := W64.addcP W64.zero x c.
rewrite addcE /= => E1 E2.
have ->: 2 ^ (64 * (1 + size xs)) * b2i x1 = 2^64*2^(64*size xs)*b2i x1.
 rewrite mulzDr exprD_nneg //; smt(size_ge0).
smt().
qed.

(*
lemma carryprop_limbs64_ncP x c:
 0 < size x =>
 1 + nth_digits (digits64 x) (size x - 1) < W64.modulus =>
 val_limbs64 (carryprop_limbs64 x c).`2 = val_limbs64 x + b2i c.
proof.
elim: x c => //= x xs IH c H0 /=.
rewrite /nth_digits /=; case: (size xs = 0) => /= E ?.
 rewrite size_eq0 in E; rewrite E carryprop_limbs64_nil /val_digits /=.
 rewrite to_uintD_small of_uintK; smt(modz_small).
have E2: 0 < size xs by smt(size_ge0).
have := IH (carry_add W64.zero x c) E2 H.
case: (carryprop_limbs64 _ _) => /= ??.
rewrite !val_digits_cons H1.
by move: (W64.addcP W64.zero x c); rewrite addcE /#.
qed.
*)

lemma nosmt carryprop_limbs64_ncP bx x c:
 0 < size x =>
 1 + bx < W64.modulus =>
 ubW64 bx (nth_limbs64 x (size x - 1)) =>
 val_limbs64 (carryprop_limbs64 x c).`2 = val_limbs64 x + b2i c
 /\ ubW64 (bx+1) (nth_limbs64 (carryprop_limbs64 x c).`2 (size x - 1)).
proof.
elim: x c => //= x xs IH c H0 /=.
rewrite /nth_limbs64 /nth_digits /=; case: (size xs = 0) => /= E H.
 rewrite size_eq0 in E; rewrite E carryprop_limbs64_nil /val_digits /=.
 move=> H1; split; first by rewrite to_uintD_small of_uintK; smt(modz_small).
 apply (ubW64D _ _ _ (W64.of_int (b2i c)) H1).
 by apply ubW641.
have E2 H1 : 0 < size xs by smt(size_ge0).
have := IH (carry_add W64.zero x c) E2 H H1.
case: (carryprop_limbs64 _ _) => /= ? [H2?].
rewrite !val_digits_cons H2 E /=.
split; last by [].
by move: (W64.addcP W64.zero x c); rewrite addcE /#.
qed.

op add_limbs64 (x y: W64.t list) (c: bool) : bool * W64.t list =
 with x = "[]", y = "[]" => (c, [])
 with x = "[]", y = (::) y' ys => carryprop_limbs64 y c
 with x = (::) x' xs, y = "[]" => carryprop_limbs64 x c
 with x = (::) x' xs, y = (::) y' ys =>
  let z = W64.addc x' y' c in 
  let r = add_limbs64 xs ys z.`1 in
  (r.`1, z.`2::r.`2).

lemma add_limbs64_nill y c: add_limbs64 [] y c = carryprop_limbs64 y c by case y.
lemma add_limbs64_nilr x c: add_limbs64 x [] c = carryprop_limbs64 x c by case x.
lemma add_limbs64_cons x xs y ys c:
 add_limbs64 (x::xs) (y::ys) c = let (c',z') = add_limbs64 xs ys (addc_carry x y c)
                                 in (c', (x+y+W64.of_int (b2i c)) :: z').
proof. by rewrite /= !addcE /=; case: (add_limbs64 xs ys (carry_add x y c)). qed.

lemma size_add_limbs64 x y c:
 size (add_limbs64 x y c).`2 = MAX (size x) (size y).
proof.
elim: x y c => //=.
 elim => //= y ys IH c.
 have:= size_carryprop_limbs64 ys (carry_add W64.zero y c).
 by case: (carryprop_limbs64 ys (carry_add W64.zero y c)) => /= ??; smt(size_ge0).
move=> x xs IH; elim => //= [|y ys IH2] c.
 have:= size_carryprop_limbs64 xs (carry_add W64.zero x c).
 by case: (carryprop_limbs64 xs (carry_add W64.zero x c)) => /= ??; smt(size_ge0).
rewrite (IH ys (addc x y c).`1); smt().
qed.

lemma nosmt add_limbs64P x y c:
 let (c',z) = add_limbs64 x y c
 in val_limbs64 z + 2^(64*MAX (size x) (size y)) * b2i c' = val_limbs64 x + val_limbs64 y + b2i c.
proof.
elim: x y c => /= [|x xs IH].
 move=> y c; rewrite !add_limbs64_nill val_digits_nil /=.
 have ->: MAX 0 (size y) = size y by smt(size_ge0).
 move: (carryprop_limbs64P y c).
 by rewrite (Core.pairS (carryprop_limbs64 _ _)) //=.
elim => /=.
 move=> {IH} c; rewrite !val_digits_cons /=.
 have ->: MAX (1 + size xs) 0 = 1 + size xs by smt(size_ge0).
 move: (carryprop_limbs64P xs (carry_add W64.zero x c)).
 rewrite (Core.pairS (carryprop_limbs64 _ _)) //=.
 move: (W64.addcP W64.zero x c); rewrite addcE /= => E1 E2.
 by rewrite !val_digits_cons mulzDr exprD_nneg; smt(size_ge0).
move=> y ys IH2 c; rewrite !val_digits_cons !addcE /=.
have ->: MAX (1 + size xs) (1 + size ys) = 1 + MAX (size xs) (size ys) by smt(size_ge0).
rewrite mulzDr exprD_nneg /=; first 2 smt(size_ge0).
move: (IH ys (carry_add x y c)); rewrite (Core.pairS (add_limbs64 _ _ _ )) //=. 
case: (add_limbs64 xs ys (carry_add x y c)) => /= ?? E.
by move: (W64.addcP x y c); rewrite addcE /= => ?; smt().
qed.

lemma nosmt add_limbs64nc_aux nx ny x y c:
 0 < MAX (size x) (size y) =>
 1 + nx + ny < W64.modulus =>
 ubW64 nx (nth_limbs64 x (MAX (size x) (size y) - 1)) =>
 ubW64 ny (nth_limbs64 y (MAX (size x) (size y) - 1)) =>
 val_limbs64 (add_limbs64 x y c).`2 = val_limbs64 x + val_limbs64 y + b2i c
 /\ ubW64 (nx+ny+1) (nth_limbs64 (add_limbs64 x y c).`2 (MAX (size x) (size y) - 1)).
proof.
elim: x y c => /= [|x xs IH].
 move=> y c H0 Hb Hx Hy; rewrite !add_limbs64_nill val_digits_nil /=.
 have ->: MAX 0 (size y) = size y by smt(size_ge0).
 apply (carryprop_limbs64_ncP (nx+ny) y c _ _ _); first 2 by smt().
 by apply (ubW64W ny); smt(ubW64ge0).
elim.
 move=> c H0 Hb Hx Hy; rewrite !add_limbs64_nilr val_digits_nil.
 have ->: MAX (1 + size xs) 0 = 1 + size xs by smt(size_ge0).
 apply (carryprop_limbs64_ncP (nx+ny) (x::xs) c _ _ _); first 2 by smt().
 by apply (ubW64W nx); smt(ubW64ge0).
move=> y ys IH2 c /= H0 Hb; rewrite !val_digits_cons /= !addcE /nth_digits /=.
have ->: MAX (1 + size xs) (1 + size ys) = 1 + MAX (size xs) (size ys) by smt(size_ge0).
case: (MAX (size xs) (size ys) = 0) => E /=.
 have ->: xs = [] by smt(size_ge0).
 have ->: ys = [] by smt(size_ge0).
 rewrite add_limbs64_nill carryprop_limbs64_nil /= val_digits_nil /nth_limbs64 /= => Hx Hy.
 split; first by rewrite !to_uintD_small 1:/# 2:/# of_uintK modz_small /#.
 apply (ubW64D (nx+ny) 1 (x+y) (W64.of_int (b2i c))); last by apply ubW641.
 by apply (ubW64D _ _ _ _ Hx Hy).
rewrite /nth_limbs64 /= E /= => Hx Hy.
have [-> ?]:= (IH ys (carry_add x y c) _ Hb Hx Hy); first by smt().
by move: (W64.addcP x y c); rewrite addcE /= => ?; smt().
qed.

op add_limbs64nc l1 l2 = (add_limbs64 l1 l2 false).`2.

lemma size_add_limbs64nc x y:
 size (add_limbs64nc x y) = MAX (size x) (size y).
proof. by rewrite /add_limbs64nc; apply (size_add_limbs64 x y false). qed.

lemma nosmt add_limbs64ncP nx ny x y:
 0 < MAX (size x) (size y) =>
 1 + nx + ny < W64.modulus =>
 ubW64 nx (nth_limbs64 x (MAX (size x) (size y) - 1)) =>
 ubW64 ny (nth_limbs64 y (MAX (size x) (size y) - 1)) =>
 val_limbs64 (add_limbs64nc x y) = val_limbs64 x + val_limbs64 y.
proof. by move=> *; have [? _] := add_limbs64nc_aux nx ny x y false _ _ _ _. qed.

lemma nosmt add_limbs64ncP' nx ny x y:
 0 < MAX (size x) (size y) =>
 1 + nx + ny < W64.modulus =>
 ubW64 nx (nth_limbs64 x (MAX (size x) (size y) - 1)) =>
 ubW64 ny (nth_limbs64 y (MAX (size x) (size y) - 1)) =>
 val_limbs64 (add_limbs64nc x y) = val_limbs64 x + val_limbs64 y
 /\ ubW64 (nx+ny+1) (nth_limbs64 (add_limbs64nc x y) (MAX (size x) (size y) - 1)).
proof. by move=> *; have ? := add_limbs64nc_aux nx ny x y false _ _ _ _. qed.

(* For non-redundant multiplications, we do not handle additions upfront, since it
 is always better to hand-pick the carry-propagatios carefully...  *)
op mul_limbs64 (x y: W64.t list) : int list =
 with x="[]" => []
 with x=(::) x xs =>
  add_digits (mul1_digits (to_uint x) (digits64 y))
             (0::mul_limbs64 xs y).

lemma mul_limbs64P x y:
    val_digits64 (mul_limbs64 x y) = val_limbs64 x * val_limbs64 y.
proof.
elim: x y => //= x xs IH ys.
rewrite !val_digits_cons !add_digitsP !val_digits_cons /=.
have ->: (to_uint x + 2^64 * val_limbs64 xs) * val_limbs64 ys
         = to_uint x * val_limbs64 ys + 2^64 * (val_limbs64 xs * val_limbs64 ys) by ring.
rewrite -IH; congr => //.
rewrite mul1_digitsP /#.
qed.


(* we can further decompose the two-word multiplications... (doesn't seem to be useful
 in practice) *)
(*
op mul1hi_limbs (x:W64.t) (y: W64.t list): W64.t list = map (fun h => mulhi x h) y
 axiomatized by mul1hi_limbsE.

lemma mul1hi_limbsP x ys:
 val_limbs64 (mul1_limbs x ys) + 2^64 * val_limbs64 (mul1hi_limbs x ys)
 = to_uint x * val_limbs64 ys.
proof.
elim: ys => /=.
 by rewrite mul1hi_limbsE !val_digits_nil.
move=> y ys IH; rewrite mul1hi_limbsE /= !val_digits_cons (mulzDr (to_uint x)).
have ->: to_uint x * (2^64 * val_limbs64 ys) = 2^64 * (to_uint x * val_limbs64 ys) by ring.
by rewrite -IH -mulhiP mul1hi_limbsE; ring.
qed.

hint simplify mul1hi_limbsE.

op mul_limbs64mulhi (x y: W64.t list) : int list =
 with x="[]" => []
 with x=(::) x xs =>
  (add_digits (add_digits (digits64 (mul1_limbs x y))
                          (0::digits64 (mul1hi_limbs x y)))
              (0::mul_limbs64mulhi xs y)).
              
lemma mul_limbs64mulhiP x y:
    val_digits64 (mul_limbs64mulhi x y) = val_limbs64 x * val_limbs64 y.
proof.
elim: x y => //= x xs IH ys.
rewrite !val_digits_cons !add_digitsP !val_digits_cons /= -!mul1hi_limbsE -!mul1_limbsE.
have ->: (to_uint x + 2^64 * val_limbs64 xs) * val_limbs64 ys
         = to_uint x * val_limbs64 ys + 2^64 * (val_limbs64 xs * val_limbs64 ys) by ring.
rewrite -IH; congr.
by apply mul1hi_limbsP.
qed.
*)



(*
lemma xxx x0 x1 x2 y0 y1 z:
 (mul_limbs64 [x0;x1;x2] [y0;y1]) = z.
simplify.
*)

(* FIXME: MOVE TO WORD *)
lemma or0(w0 w1 : W64.t) : (w0 `|` w1 = W64.zero) <=> (w0 = W64.zero /\ w1 = W64.zero).
split; last by move => [-> ->]; rewrite or0w /=.
rewrite !wordP => H.
case (w0 = zero_u64).
+ move => -> /= k kb.
  by move : (H k kb) => /= /#.
move => *; have Hk : exists k, 0 <= k < 64 /\ w0.[k]; last by
  elim Hk => k [kb kval]; move : (H k kb); rewrite orwE kval /=. 
by move : (W64.wordP w0 W64.zero); smt(W64.zerowE W64.get_out).
qed.
