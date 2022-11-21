require import AllCore List Int IntDiv StdOrder.
require import EClib Array5 Array4.
require import W64limbs.
require import Zp.
from Jasmin require import JModel.
require ZModP.
import Zp.


abbrev zeroh32(w : W64.t) = w `&` W64.masklsb 32.
op (`|*`) a b = zeroh32 a * zeroh32 b axiomatized by lmulE.
hint simplify lmulE.

lemma SHRD_64_spec r1 r2 k:
 0 < k < 64 =>
 (SHRD_64 r1 r2 (W8.of_int k)).`6
 = (r1 `>>` (W8.of_int k)) + (r2 `<<` W8.of_int (64-k)).
proof. 
move => [kbl kbh].
rewrite /SHRD_64 /shift_mask /rflags_OF /PF_of  /(`>>`) /(`<<`)  /=.
rewrite  !modz_small; 1..6: by rewrite StdOrder.IntOrder.gtr0_norm /#. 
rewrite ifF 1: /#.
case (k = 1).
+ move => -> /=.
  rewrite to_uint_eq to_uintD /= -to_uint_orw_disjoint. 
  + rewrite /(`>>>`) /(`<<<`) wordP => i ib.
    by rewrite andE map2iE // !initiE //=; smt(W64.get_out).
  rewrite modz_small; 1: smt(W64.to_uint_cmp pow2_64).
  rewrite -to_uint_eq wordP => i ib.
  by rewrite  xorE orE !map2iE /= ib /=; smt(W64.get_out).

move => ? /=.
rewrite to_uint_eq to_uintD /= -to_uint_orw_disjoint. 
+ rewrite /(`>>>`) /(`<<<`) wordP => i ib.
  by rewrite andE map2iE // !initiE //=; smt(W64.get_out).
rewrite modz_small; 1: smt(W64.to_uint_cmp pow2_64).
rewrite -to_uint_eq wordP => i ib.
by rewrite  xorE orE !map2iE /= ib /=; smt(W64.get_out).
qed.

(* bounded representations *)
type Rep5 = W64.t Array5.t.

abbrev bRep5 (size:int) (x: Rep5) : bool = bW64_limbs size (to_list x).

lemma bRep5E size (x: Rep5):
 bRep5 size x
 = (bW64 size x.[0] /\ bW64 size x.[1] /\ bW64 size x.[2] /\ bW64 size x.[3] /\ bW64 size x.[4]).
proof. by rewrite /to_list /mkseq -iotaredE /=. qed.

lemma bRep5P size (x: Rep5):
 bRep5 size x =>
 (bW64 size x.[0] /\ bW64 size x.[1] /\ bW64 size x.[2] /\ bW64 size x.[3] /\ bW64 size x.[4]).
proof. by rewrite bRep5E. qed.

abbrev val_limbs26 l = val_limbs 67108864 l.
abbrev valRep5 (x: Rep5) = val_limbs26 (to_list x).
abbrev inzp_limbs26 l = inzp_limbs 67108864 l.

abbrev twoPow26 = 67108864.
abbrev twoPow52 = 4503599627370496.
abbrev twoPow78 = 302231454903657293676544.
abbrev twoPow104 = 20282409603651670423947251286016.

lemma valRep5E x:
 valRep5 x = to_uint x.[0] + to_uint x.[1] * twoPow26 + to_uint x.[2] * twoPow52
            + to_uint x.[3] * twoPow78 + to_uint x.[4] * twoPow104.
proof. by rewrite /to_list /mkseq -iotaredE /val_limbs /val_digits /=; ring. qed.

abbrev congpRep5 x xval = zpcgr (valRep5 x) xval.

op repres5(r : Rep5) = inzp (valRep5 r) axiomatized by repres5E.

lemma eqRep5 (x y:Rep5):
 x=y <=> (x.[0]=y.[0]) /\ (x.[1]=y.[1]) /\ (x.[2]=y.[2]) /\ (x.[3]=y.[3]) /\ (x.[4]=y.[4]).
proof. by move => /> *; apply (Array5.ext_eq_all x y). qed.


lemma equiv_class5 x r:
  congpRep5 r (valRep5 x) <=> repres5 x = repres5 r.
proof.
split.
 move=> h; apply/Zp.asint_inj/eq_sym.
  by rewrite !repres5E /= !inzpK.
by rewrite !repres5E /congpRep5 -!inzpK => ->.
qed.

lemma equiv_class5M r x y:
 congpRep5 r (valRep5 x * valRep5 y) <=>
 repres5 r = (repres5 x * repres5 y).
proof.
split.
 rewrite /congpRep5 => ?.
 rewrite !repres5E -inzpM.
 apply Zp.asint_inj.
 by rewrite !inzpK.
by rewrite !repres5E /congpRep5 -!inzpK inzpM => ->.
qed.

lemma equiv_class5D r x y:
 congpRep5 r (valRep5 x + valRep5 y) <=>
 repres5 r = (repres5 x + repres5 y).
proof.
split.
 rewrite /congpRep5 => ?.
 rewrite !repres5E -inzpD.
 apply Zp.asint_inj.
 by rewrite !inzpK.
by rewrite !repres5E /congpRep5 -!inzpK inzpD => ->.
qed.

(** Specification and auxiliary lemmata for modular
 operations acting on Rep5 *)

op addRep5 (x y: Rep5) : Rep5 =
 Array5.of_list W64.zero (add_limbs (to_list x) (to_list y)).
 
lemma addRep5P x y:
 bRep5 63 x => bRep5 63 y =>
 valRep5 (addRep5 x y) = valRep5 x + valRep5 y.
proof.
move=> H H0.
rewrite /addRep5 Array5.of_listK.
 rewrite size_add_limbs !Array5.size_to_list /#.
by rewrite (add_limbsP (to_list x) (to_list y) (2^26) H H0).
qed.

lemma bRep5_addRep5 n x y:
 n < 64 => bRep5 n x => bRep5 n y =>
 bRep5 (n+1) (addRep5 x y).
proof.
move=> ? /bRep5P [?[?[?[??]]]] /bRep5P [?[?[?[??]]]].
rewrite bRep5E /addRep5 /to_list /mkseq -iotaredE /=; smt(@BW64).
qed.

op mul5Rep54 (x: Rep5) : W64.t Array4.t =
 Array4.init (fun i => x.[i+1] `|*` W64.of_int 5).

op mulmodRep5 (x y: Rep5) (y5: W64.t Array4.t): Rep5 =
 Array5.of_list W64.zero
   [ x.[0]*y.[0] + x.[4]*y5.[0] + x.[3]*y5.[1] + x.[2]*y5.[2] + x.[1]*y5.[3]
   ; x.[1]*y.[0] + x.[0]*y.[1] + x.[4]*y5.[1] + x.[3]*y5.[2] + x.[2]*y5.[3]
   ; x.[2]*y.[0] + x.[1]*y.[1] + x.[0]*y.[2] + x.[4]*y5.[2] + x.[3]*y5.[3]
   ; x.[3]*y.[0] + x.[2]*y.[1] + x.[1]*y.[2] + x.[0]*y.[3] + x.[4]*y5.[3]
   ; x.[4]*y.[0] + x.[3]*y.[1] + x.[2]*y.[2] + x.[1]*y.[3] + x.[0]*y.[4]
   ].

lemma val_limbs26_red2 x:
 List.all (bW64 60) x =>
 inzp (val_limbs26 x)
 = inzp (val_limbs26 (take 5 x)) + inzp (val_limbs26 (mul1_limbs (W64.of_int 5) (drop 5 x))).
proof.
move=> /List.allP H.
rewrite -{1}(cat_take_drop 5 x) val_limbs_cat inzpD; congr.
case: (size x <= 5) => *.
 by rewrite drop_oversize //.
rewrite size_take 1:/#.
have -> /=: 5 < size x by smt().
rewrite inzp_over; congr.
have ->:= mul1_limbsP 3 60 (W64.of_int 5) (drop 5 x) 67108864 _ _ _ => //.
 by rewrite bW64ub.
rewrite allP => ?H1; apply H.
by apply (mem_drop _ _ _ H1).
qed.

lemma rep_limbs26_red x:
 List.all (bW64 60) x =>
 inzp_limbs26 x
 = inzp_limbs26 (add_limbs (take 5 x) (mul1_limbs (W64.of_int 5) (drop 5 x))).
proof.
move=> /List.allP H.
rewrite /inzp_limbs (val_limbs26_red2 x).
 by rewrite allP.
rewrite -inzpD; congr.
rewrite add_limbsP //.
 rewrite allP => y /mem_take Hy; apply (bW64W 60) => //.
 by apply H.
rewrite mul1_limbsE allP => y /mapP [z [/mem_drop Hz ->/=]].
apply (bW64M 3 60) => //.
 by rewrite bW64ub.
by apply H.
qed.

lemma andneutral b  (w: W64.t) : 0 <= b < 32 => bW64 b w => zeroh32 w = w.
move => H H0; rewrite to_uint_eq to_uint_and_mod /max //=.
move : H0; rewrite /bW64. 
smt(modz_small StdOrder.IntOrder.gtr0_norm W64.to_uint_cmp IntOrder.ler_weexpn2r pow2_32).
qed. 

lemma mulmodRep5P x y:
 bRep5 28 x => bRep5 28 y =>
 repres5 (mulmodRep5 x y (mul5Rep54 y)) = repres5 x * repres5 y.
proof.
move=> H; move: (H) => /bRep5P [?[?[?[??]]]].
move=> H5; move: (H5) => /bRep5P [?[?[?[??]]]].
rewrite !repres5E -inzpM eq_sym.
have <- := (mul_limbsP 28 28 (to_list x) (to_list y) (2^26) _ _ _ _) => //.
 by rewrite Array5.size_to_list.
have ->: 2^26 = 67108864 by smt().
rewrite -/(inzp_limbs 67108864 (mul_limbs (to_list x) (to_list y))).
rewrite -/(inzp_limbs 67108864 (to_list (mulmodRep5 x y (mul5Rep54 y)))).
rewrite /mulmodRep5 /mul5Rep54 /to_list /mkseq /=.
rewrite rep_limbs26_red -iotaredE /=.
 do (split; first smt(@BW64)); smt(@BW64).
congr; rewrite !(andneutral 28) //=; 1: by rewrite /bW64 /=.
do split; ring.
qed.

(* specific lemmas for [bW64] predicate *)

lemma bW64_to_uintM5 nx x:
 (nx + 3 <= 64)%Int =>
 bW64 nx x =>
 to_uint (x*W64.of_int 5) = to_uint x * 5.
proof.
move=> *.
have ?: bW64 3 (W64.of_int 5) by rewrite bW64ub.
by apply (bW64_to_uintM nx 3).
qed.


theory BW64'.

clone import BW64.

lemma bW64_5: bW64 3 (W64.of_int 5).
proof. by apply bW64const. qed.

lemma bW64mask26 n x: (26 <= n)%Int => bW64 n (x `&` (of_int 67108863)%W64). 
proof. by move=> *; apply (bW64W 26) => //; apply (bW64mask 26 x). qed.


end BW64'.



(******************************************************************************************

                                   5-limb implementations

 ******************************************************************************************)

require import Array2 Array3 Rep3Limb.

abbrev mask26 = W64.masklsb 26.
abbrev u64_5 = W64.of_int 5.

module Mrep5 = {

  proc unpack2 (t:Rep2) : Rep5 = {
    var x: Rep5;
    x <- witness<:Rep5>.[0 <- t.[0] `&` mask26]; 
    x.[1] <- (t.[0] `>>` W8.of_int 26) `&` mask26;
    t.[0] <- t.[0] `>>` W8.of_int 48;
    x.[2] <- (((t.[0] `|` (t.[1] `<<` W8.of_int 16))  `>>` W8.of_int 4) `&` mask26);
    x.[3] <- (((t.[0] `|` (t.[1] `<<` W8.of_int 16))  `>>` W8.of_int 30) `&` mask26);
    x.[4] <- (t.[1] `>>` W8.of_int 40);
    return x;   
  }

  proc unpack2_bit128 (t: Rep2): Rep5 = {
    var x: Rep5;
    x <@ unpack2(t);
    x.[4] <- x.[4] `|` (W64.of_int 16777216);
    return x;
  }

  proc unpack (rt:Rep3) : Rep5 = {
    var ro : Rep5;   
    var l:W64.t;
    var h:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    var  _5:bool;
    var  _6:bool;
    var  _7:bool;
    var  _8:bool;
    var  _9:bool;
    
    l <- rt.[0];
    ro<- witness<:Rep5>.[0 <- l `&` mask26];
    l <- (l `>>` (W8.of_int 26));
    ro.[1] <- l `&` mask26;
    l <- rt.[0];
    ( _0, _1, _2, _3, _4,l) <- SHRD_64 l rt.[1] (W8.of_int 52);
    h <- l;
    ro.[2] <- l `&` mask26;
    l <- h;
    l <- (l `>>` (W8.of_int 26));
    l <- l `&` mask26;
    ro.[3] <- l;
    l <- rt.[1];
    ( _5, _6, _7, _8, _9,l) <- SHRD_64 l rt.[2] (W8.of_int 40);
    ro.[4] <- l;
    return (ro);
  }

  proc zero () : Rep5 = {
    var h: Rep5;
    h <- witness<:Rep5>.[0 <- W64.zero];
    h.[1] <- W64.zero;
    h.[2] <- W64.zero;
    h.[3] <- W64.zero;
    h.[4] <- W64.zero;
    return h;
  }

  proc add(h m: Rep5) = {
    h.[0] <- h.[0] + m.[0];
    h.[1] <- h.[1] + m.[1];
    h.[2] <- h.[2] + m.[2];
    h.[3] <- h.[3] + m.[3];
    h.[4] <- h.[4] + m.[4];
    return h;
  }

  proc x5 (r:Rep5) : W64.t Array4.t = {
    var r5 : W64.t Array4.t;
    r5 <- witness<:W64.t Array4.t>.[0 <- u64_5 `|*` r.[1]];
    r5.[1] <- u64_5 `|*` r.[2];
    r5.[2] <- u64_5 `|*` r.[3];
    r5.[3] <- u64_5 `|*` r.[4];
    return r5;
  }

  proc mulmod(h r: Rep5, rx5 : W64.t Array4.t) = {
    var t:W64.t Array5.t;
    var u:W64.t Array4.t;
    t <- witness<:W64.t Array5.t>.[0 <- h.[0] `|*`r.[0]];
    t.[1] <- h.[1] `|*` r.[0];
    t.[2] <- h.[2] `|*` r.[0];
    t.[3] <- h.[3] `|*`r.[0];
    t.[4] <- h.[4] `|*`r.[0];
    u <- witness<:W64.t Array4.t>.[0 <- h.[0] `|*`r.[1]];
    u.[1] <- h.[1] `|*`r.[1];
    u.[2] <- h.[2] `|*`r.[1];
    u.[3] <- h.[3] `|*`r.[1];
    t.[1] <- t.[1] + u.[0];
    t.[2] <- t.[2] + u.[1];
    t.[3] <- t.[3] + u.[2];
    t.[4] <- t.[4] + u.[3];
    u.[0] <- h.[1] `|*`rx5.[3];
    u.[1] <- h.[2] `|*`rx5.[3];
    u.[2] <- h.[3] `|*`rx5.[3];
    u.[3] <- h.[4] `|*`rx5.[3];
    t.[0] <- t.[0] + u.[0];
    t.[1] <- t.[1] + u.[1];
    t.[2] <- t.[2] + u.[2];
    t.[3] <- t.[3] + u.[3];
    u.[0] <- h.[0] `|*`r.[2];
    u.[1] <- h.[1] `|*`r.[2];
    u.[2] <- h.[2] `|*`r.[2];
    t.[2] <- t.[2] + u.[0];
    t.[3] <- t.[3] + u.[1];
    t.[4] <- t.[4] + u.[2];
    u.[0] <- h.[2] `|*`rx5.[2];
    u.[1] <- h.[3] `|*`rx5.[2];
    h.[2] <- h.[4] `|*`rx5.[2];
    t.[0] <- t.[0] + u.[0];
    t.[1] <- t.[1] + u.[1];
    h.[2] <- h.[2] + t.[2];
    u.[0] <- h.[0] `|*`r.[3];
    u.[1] <- h.[1] `|*`r.[3];
    t.[3] <- t.[3] + u.[0];
    t.[4] <- t.[4] + u.[1];
    u.[0] <- h.[3] `|*`rx5.[1];
    h.[1] <- h.[4] `|*`rx5.[1];
    t.[0] <- t.[0] + u.[0];
    h.[1] <- h.[1] + t.[1];
    u.[0] <- h.[4] `|*`rx5.[0];
    u.[1] <- h.[0] `|*`r.[4];
    h.[0] <- t.[0] + u.[0];
    h.[3] <- t.[3];
    h.[4] <- t.[4] + u.[1];
    return h;
  }

  proc carry_reduce (x:Rep5) : Rep5 = {
    var z:W64.t Array2.t;
    var t:W64.t;
    z <- witness<:W64.t Array2.t>.[0 <- x.[0] `>>` W8.of_int 26];
    z.[1] <- x.[3] `>>` W8.of_int 26;
    x.[0] <- x.[0] `&` mask26;
    x.[3] <- x.[3] `&` mask26;
    x.[1] <- x.[1] + z.[0];
    x.[4] <- x.[4] + z.[1];
    z.[0] <- x.[1] `>>` W8.of_int 26;
    z.[1] <- x.[4] `>>` W8.of_int 26;
    t <- z.[1] `<<` W8.of_int 2;
    z.[1] <- z.[1] + t;
    x.[1] <- x.[1] `&` mask26;
    x.[4] <- x.[4] `&` mask26;
    x.[2] <- x.[2] + z.[0];
    x.[0] <- x.[0] + z.[1];
    z.[0] <- x.[2] `>>` W8.of_int 26;
    z.[1] <- x.[0] `>>` W8.of_int 26;
    x.[2] <- x.[2] `&` mask26;
    x.[0] <- x.[0] `&` mask26;
    x.[3] <- x.[3] + z.[0];
    x.[1] <- x.[1] + z.[1];
    z.[0] <- x.[3] `>>` W8.of_int 26;
    x.[3] <- x.[3] `&` mask26;
    x.[4] <- x.[4] + z.[0];
    return (x);
  }

  proc add_mulmod(h m r: Rep5, rx5 : W64.t Array4.t) : Rep5 = {
    h <@ add(h, m);
    h <@ mulmod(h, r, rx5);
    h <@ carry_reduce(h);
    return h;
  }

  proc add_pack(h1: Rep5, h2: Rep5, h3: Rep5, h4: Rep5) : Rep3 = {
    var t00,t01,t02,t03,t10,t11,t12,t13 : W64.t;
    var d,r : W64.t Array3.t;
    var aux_0,c,cx4 : W64.t;
    var aux,cf : bool;
 
    t00 <- (h1.[1] `<<` W8.of_int 26) + h1.[0];
    t01 <- (h2.[1] `<<` W8.of_int 26) + h2.[0];
    t02 <- (h3.[1] `<<` W8.of_int 26) + h3.[0];
    t03 <- (h4.[1] `<<` W8.of_int 26) + h4.[0];
    t10 <- (h1.[3] `<<` W8.of_int 26) + h1.[2];
    t11 <- (h2.[3] `<<` W8.of_int 26) + h2.[2];
    t12 <- (h3.[3] `<<` W8.of_int 26) + h3.[2];
    t13 <- (h4.[3] `<<` W8.of_int 26) + h4.[2];
    d <- witness<:W64.t Array3.t>.[0 <- t00 + t02 + t01 + t03];
    d.[1] <- t10 + t12 + t11 + t13;
    d.[2] <- h4.[4] + h3.[4] + h2.[4] + h1.[4];

    r <- witness<:W64.t Array3.t>.[0 <- d.[1]];
    r.[0] <- (r.[0] `<<` (W8.of_int 52));
    r.[1] <- d.[1];
    r.[1] <- (r.[1] `>>` (W8.of_int 12));
    r.[2] <- d.[2];
    r.[2] <- (r.[2] `>>` (W8.of_int 24));
    d.[2] <- (d.[2] `<<` (W8.of_int 40));
    (aux,aux_0) <- addc r.[0] d.[0] false;
    cf <- aux;
    r.[0] <- aux_0;
    (aux,aux_0) <- addc r.[1] d.[2] cf;
    cf <- aux;
    r.[1] <- aux_0;
    (aux,aux_0) <- addc r.[2] (W64.of_int 0) cf;
    r.[2] <- aux_0;
    c <- r.[2];
    cx4 <- r.[2];
    r.[2] <- (r.[2] `&` (W64.of_int 3));
    c <- (c `>>` (W8.of_int 2));
    cx4 <- (cx4 `&` (W64.of_int (- 4)));
    c <- (c + cx4);
    (aux,aux_0) <- addc r.[0] c false;
    cf <- aux;
    r.[0] <- aux_0;
    (aux,aux_0) <- addc r.[1] (W64.of_int 0) cf;
    cf <- aux;
    r.[1] <- aux_0;
    (aux,aux_0) <- addc r.[2] (W64.of_int 0) cf;
    r.[2] <- aux_0;

    return (r);
  }
}.

(****************************        Rep5 specs              *******************************)

lemma zero_spec_h:
  hoare [ Mrep5.zero : true ==> repres5 res = Zp.zero ].
proof.
proc; by auto => /> *; rewrite repres5E valRep5E /Zp.zero. qed.

lemma zero_spec_ll: islossless Mrep5.zero.
proof. by islossless. qed.

lemma zero_spec:
  phoare [ Mrep5.zero : true ==> repres5 res = Zp.zero ] = 1%r.
proof. by conseq zero_spec_ll zero_spec_h. qed.
          
lemma x5_spec_h rr:
  hoare [ Mrep5.x5 : r = rr ==> res = mul5Rep54 rr ].
proof.
proc; auto => /> *.
rewrite -Array4.ext_eq_all /mul5Rep54 /Array4.all_eq /=.
by do (split; first by ring); ring.
qed.

lemma x5_spec_ll: islossless Mrep5.x5.
proof. by islossless. qed.

lemma x5_spec rr:
  phoare [ Mrep5.x5 : r = rr ==> res = mul5Rep54 rr ] = 1%r.
proof. by conseq x5_spec_ll (x5_spec_h rr). qed.

lemma add_spec_h b_hh b_mm hh mm:
  max b_hh b_mm < 63 =>
  hoare [ Mrep5.add : 
             bRep5 b_hh hh /\ bRep5 b_mm mm /\
             hh = h /\ mm = m 
             ==>
             bRep5 (max b_hh b_mm + 1) res /\
             repres5 res = repres5 hh + repres5 mm ].
proof.
move=> *; proc; wp; skip; rewrite !bRep5E => /> *; split.
 rewrite bRep5E /max /=; smt(@BW64).
rewrite !repres5E -inzpD; congr.
rewrite -addRep5P; first 2 by rewrite bRep5E; smt(@BW64).
by congr; rewrite /addRep5 /to_list /mkseq -iotaredE /=.
qed.

lemma add_spec_ll: islossless Mrep5.add.
proof. by islossless. qed.

lemma add_spec b_hh b_mm hh mm:
  max b_hh b_mm < 63 =>
  phoare [ Mrep5.add : 
             bRep5 b_hh hh /\ bRep5 b_mm mm /\
             hh = h /\ mm = m 
           ==>
             bRep5 (max b_hh b_mm + 1) res /\
             repres5 res = repres5 hh + repres5 mm ] = 1%r.
proof. by move=> H; conseq add_spec_ll (add_spec_h b_hh b_mm hh mm H). qed.

lemma mulmod_spec_h hh rr:
  hoare [ Mrep5.mulmod : 
             bRep5 28 hh /\ bRep5 28 rr /\
             hh = h /\ rr = r /\
             rx5 = mul5Rep54 r 
             ==>
             bRep5 63 res /\
             repres5 res = repres5 hh * repres5 rr ].
proof.
proc; auto => />H H0; split.
 move: H H0; rewrite !bRep5E /mul5Rep54 /= => *;
 rewrite (andneutral 28 hh.[0]) // 1:/#
 (andneutral 28 hh.[1]) 1,2:/#
 (andneutral 28 hh.[2]) 1,2:/#
 (andneutral 28 hh.[3]) 1,2:/#
 (andneutral 28 hh.[4]) 1,2:/#
 (andneutral 28 rr.[0]) 1,2:/#
 (andneutral 28 rr.[1]) 1,2:/#
 (andneutral 28 rr.[2]) 1,2:/#
 (andneutral 28 rr.[3]) 1,2:/#
 (andneutral 28 rr.[4]) 1,2:/#
 (andneutral 28 u64_5) //;  [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[3] * u64_5)) //; [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[2] * u64_5)) //; [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[1] * u64_5)) //; [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[4] * u64_5)) //; [ smt(@BW64') |
 smt(@BW64')]]]]].

rewrite -mulmodRep5P //; congr.
rewrite /mulmodRep5 eqRep5 /=. 
 rewrite /mul5Rep54 !initiE /= //. 
 rewrite bRep5E in H.
 rewrite bRep5E in H0.
 rewrite (andneutral 28 hh.[0]) // 1:/#
 (andneutral 28 hh.[1]) 1,2:/#
 (andneutral 28 hh.[2]) 1,2:/#
 (andneutral 28 hh.[3]) 1,2:/#
 (andneutral 28 hh.[4]) 1,2:/#
 (andneutral 28 rr.[0]) 1,2:/#
 (andneutral 28 rr.[1]) 1,2:/#
 (andneutral 28 rr.[2]) 1,2:/#
 (andneutral 28 rr.[3]) 1,2:/#
 (andneutral 28 rr.[4]) 1,2:/#
 (andneutral 28 u64_5) //;  [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[3] * u64_5)) //; [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[2] * u64_5)) //; [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[1] * u64_5)) //; [ smt(@BW64') |
   rewrite (andneutral 31 (rr.[4] * u64_5)) //; [ smt(@BW64') |
 do split; ring ]]]]].

qed.

lemma mulmod_spec_ll: islossless Mrep5.mulmod.
proof. by islossless. qed.

lemma mulmod_spec hh rr:
 phoare [ Mrep5.mulmod : 
             bRep5 28 hh /\ bRep5 28 rr /\
             hh = h /\ rr = r /\
             rx5 = mul5Rep54 r 
           ==>
             bRep5 63 res /\
             repres5 res = repres5 hh * repres5 rr ] = 1%r.
proof. by conseq mulmod_spec_ll (mulmod_spec_h hh rr). qed.

lemma unpack2_spec_h rr :
  hoare [ Mrep5.unpack2 : t = rr ==>
                repres5 res = repres2 rr /\ bRep5 26 res /\ bW64 24 res.[4] ].
proof.
proc; auto =>  &hr  <- /> *; do split; last 2 first.
  rewrite bRep5E /= /max /=; smt(@BW64').
 smt(@BW64').
rewrite repres5E repres2E; congr.
have ->: valRep2 t{hr}
         = val_limbs26 [ t{hr}.[0] `&` mask26
                       ; (t{hr}.[0] `>>` W8.of_int 26) `&` mask26
                       ; (t{hr}.[0] `>>` W8.of_int 52)
                         `|` (t{hr}.[1] `<<` W8.of_int 12) `&` mask26
                       ; (t{hr}.[1] `>>` W8.of_int 14) `&` mask26
                       ; (t{hr}.[1] `>>` W8.of_int 40)
                       ].
 rewrite valRep2E /val_digits /= !W64.shl_shlw // !W64.shr_shrw //.
 rewrite (W64.splitwE 26 t{hr}.[0]) //.
 rewrite (W64.splitwE 26 (t{hr}.[0] `>>>` 26)) // shrw_add //=.
 rewrite (W64.splitwE 14 t{hr}.[1]) //.
 rewrite (W64.splitwE 26 (t{hr}.[1] `>>>` 14)) // shrw_add //=.
 ring.
 rewrite to_uint_orw_disjoint.
  rewrite andwA eq_sym -(W64.and0w mask26); congr.
  by rewrite shrw_shlw_disjoint.
 rewrite (W64.shlw_andmask 12 26) //.
 rewrite to_uint_shl //= !modz_small //.
  apply bound_abs.
  have := W64.to_uint_ule_andw (of_int 16383)%W64 t{hr}.[1].
  rewrite andwC of_uintK modz_small /max //=; smt(W64.to_uint_cmp).
 by ring.
congr; congr; rewrite /to_list /mkseq -iotaredE !W64.shl_shlw //= !W64.shr_shrw/max  //=; split.
 apply/W64.wordP => i Hi /=. 
 rewrite (W64.masklsbE 26) /min /= Hi /=; smt(W64.get_out). 
apply/W64.wordP => i Hi /=.
rewrite (W64.masklsbE 26) /=; smt(W64.get_out).
qed.

lemma unpack2_spec_ll: islossless Mrep5.unpack2.
proof. by islossless. qed.

lemma unpack2_spec rr :
  phoare [ Mrep5.unpack2 : t = rr ==>
           repres5 res = repres2 rr /\ bRep5 26 res /\ bW64 24 res.[4] ] = 1%r.
proof. by conseq unpack2_spec_ll (unpack2_spec_h rr). qed.

lemma unpack2_bit128_spec_h rr :
  hoare [ Mrep5.unpack2_bit128 : t = rr ==>
                repres5 res = repres2 rr + inzp (2^128) /\ bRep5 26 res  ].
proof.
proc; wp; call (unpack2_spec_h rr); skip => /> result H H0 H1.
have E: result.[4] `&` Poly1305_savx2.bit25_u64 = Poly1305_savx2.zero_u64.
 have ->: Poly1305_savx2.bit25_u64 = (W64.one `<<<` 24).
  apply W64.word_modeqP; congr.
  by rewrite to_uint_shl // !of_uintK.
 apply W64.wordP => i Hi.
 move: H1; rewrite bW64andmaskE // => ->.
 rewrite -andwA.
 have ->: (masklsb 24)%W64 `&` (W64.one `<<<` 24) = W64.zero.
  apply W64.wordP => j Hj /=;smt(W64.get_out). 
  by smt(). 
split; last first.
 move: H0; rewrite !bRep5E /=; progress.
 move: H1; rewrite !bW64ub /ubW64 // => H1.
 rewrite to_uint_orw_disjoint //.
 rewrite of_uintK modz_small; first smt().
 move: H1; rewrite /=; smt().
rewrite -H !repres5E -inzpD; congr.
by rewrite !valRep5E /= to_uint_orw_disjoint //=; ring.
qed.

lemma unpack2_bit128_spec_ll: islossless Mrep5.unpack2_bit128.
proof. by islossless. qed.

lemma unpack2_bit128_spec rr :
  phoare [ Mrep5.unpack2_bit128 : t = rr ==>
           repres5 res = repres2 rr + inzp (2^128) /\ bRep5 26 res] = 1%r.
proof. by conseq unpack2_bit128_spec_ll (unpack2_bit128_spec_h rr). qed.

lemma unpack_spec_h rr :
  hoare [ Mrep5.unpack : rt = rr /\ ubW64 4 rr.[2] ==>
                repres5 res = repres3 rr /\ bRep5 28 res  ].
proc.
wp; skip; progress; last first.
 have ?: bW64 3 rt{hr}.[2] by rewrite bW64ub //=; apply (ubW64W 4).
 rewrite bRep5E /=. 
 rewrite (SHRD_64_spec rt{hr}.[0] rt{hr}.[1] 52) //.
 rewrite (SHRD_64_spec rt{hr}.[1] rt{hr}.[2] 40) //.
 rewrite /max /=;do split;  smt(@BW64'). 

rewrite repres5E repres3E; congr.
rewrite (SHRD_64_spec rt{hr}.[0] rt{hr}.[1] 52) //.
rewrite (SHRD_64_spec rt{hr}.[1] rt{hr}.[2] 40) //.
have ->: valRep3 rt{hr}
         = val_limbs26 [ rt{hr}.[0] `&` mask26
                       ; (rt{hr}.[0] `>>` W8.of_int 26) `&` mask26
                       ; (rt{hr}.[0] `>>` W8.of_int 52) `|` (rt{hr}.[1] `<<` W8.of_int 12) `&` mask26
                       ; (rt{hr}.[1] `>>` W8.of_int 14) `&` mask26
                       ; (rt{hr}.[1] `>>` W8.of_int 40) `|` (rt{hr}.[2] `<<` W8.of_int 24)
                       ].
 rewrite valRep3E /val_digits /= !W64.shr_shrw // !W64.shl_shlw //.
 rewrite (W64.splitwE 26 rt{hr}.[0]) //.
 rewrite (W64.splitwE 26 (rt{hr}.[0] `>>>` 26)) // shrw_add //=.
 rewrite (W64.splitwE 14 rt{hr}.[1]) //.
 rewrite (W64.splitwE 26 (rt{hr}.[1] `>>>` 14)) // shrw_add //=.
 ring.
 rewrite to_uint_orw_disjoint.
  apply/W64.wordP => i Hi /=;  smt(W64.get_out).
 rewrite to_uint_orw_disjoint.
  rewrite andwA eq_sym -(W64.and0w mask26); congr.
  by rewrite shrw_shlw_disjoint.
 rewrite (W64.shlw_andmask 12 26) //.
 rewrite to_uint_shl //= !modz_small //.
  apply bound_abs.
  have := W64.to_uint_ule_andw (of_int 16383)%W64 rt{hr}.[1].
  by rewrite andwC of_uintK modz_small //; smt(W64.to_uint_cmp).
 ring.
 rewrite to_uint_shl // modz_small.
  apply bound_abs.
  have := W64.to_uint_ule_andw (of_int 16383)%W64 rt{hr}.[1].
  rewrite andwC of_uintK modz_small /max //=; smt(W64.to_uint_cmp).
 by ring.
congr; congr; rewrite /to_list /mkseq -iotaredE  /= !W64.shl_shlw // !W64.shr_shrw //; split.
  rewrite -W64.orw_disjoint.
   apply/W64.wordP => i Hi /=.
   smt(W64.get_out).
  rewrite andw_orwDl; congr.
  by rewrite (W64.shrw_andmaskK 52 26).
 rewrite -W64.orw_disjoint.
  by rewrite W64.shrw_shlw_disjoint.
 rewrite -shrw_or 1:// shrw_add 1..2://= shrw_out 1:// or0w.
 rewrite shlw_shrw_shrw 1..2://.
 rewrite andmask_shrw 1:// -andwA  /=. 
 rewrite (W64.mask_and_mask (64-12-(26-12)) 26) 1..2:// /min /max /=.
rewrite orw_disjoint //.
by rewrite shrw_shlw_disjoint.
qed.

lemma unpack_spec_ll: islossless Mrep5.unpack.
proof. by islossless. qed.

lemma unpack_spec rr:
 phoare [ Mrep5.unpack : rt = rr /\ ubW64 4 rr.[2] ==>
                repres5 res = repres3 rr /\ bRep5 28 res ] = 1%r.
proof. by conseq unpack_spec_ll (unpack_spec_h rr). qed.

lemma carry_reduce_spec_h xx :
    hoare [Mrep5.carry_reduce:
            bRep5 63 x /\ xx = x
           ==>
            bRep5 27 res /\ repres5 res = repres5 xx].
proof.
proc.
wp;skip => &hr; rewrite !bRep5E => [# 5? ->] /=; do split;  
 1: by rewrite !bRep5E /max /=; smt(@BW64').
(* congp *) 
apply eq_sym.  
pose X0 := W64.splitBits 26 x{hr}.[0].
pose X3 := W64.splitBits 26 x{hr}.[3].
pose X4 := W64.splitBits 26 (x{hr}.[4] + X3.`2).
apply (eq_trans _ (inzp (val_limbs26 [ X0.`1
                                     ; x{hr}.[1] + X0.`2
                                     ; x{hr}.[2]
                                     ; X3.`1
                                     ; X4.`1])
                   + inzp (2^130 * to_uint X4.`2))).
 rewrite repres5E valRep5E /to_list /mkseq  /val_digits /= -inzpD; congr.
 rewrite (W64.splitwE 26 x{hr}.[0]) //=.
 rewrite (W64.splitwE 26 x{hr}.[3]) //=.
 have := W64.to_uint_splitBits 26 (x{hr}.[4] + X3.`2) _ => //.
 rewrite /splitBits /= bW64_to_uintD; 1,2:  smt(@BW64').
 rewrite /X4/X3/X0 /splitBits /=; clear X0 X3 X4; progress.
 by rewrite !bW64_to_uintD; first 3 smt(@BW64').
apply (eq_trans _ (inzp (val_limbs26 [ X0.`1 + u64_5 * X4.`2
                                     ; x{hr}.[1] + X0.`2
                                     ; x{hr}.[2]
                                     ; X3.`1
                                     ; X4.`1 ]))).
 rewrite inzp_over -inzpD; congr.
 have ->: 5 * to_uint X4.`2 = to_uint (u64_5 * X4.`2).
  rewrite (bW64_to_uintM 3 (64-26)) //; smt(@BW64'). 
 rewrite /val_digits /= !bW64_to_uintD /X0 /X3 /X4 /splitBits /max /=; 1..5:  smt(@BW64'). 
rewrite repres5E /valRep5; congr.
pose Y0 := W64.splitBits 26 (X0.`1 + u64_5 * X4.`2).
pose Y1 := W64.splitBits 26 (x{hr}.[1] + X0.`2).
pose Y2 := W64.splitBits 26 (x{hr}.[2] + Y1.`2).
pose Y3 := W64.splitBits 26 (X3.`1 + Y2.`2).
apply (eq_trans _ (val_limbs26 [ Y0.`1
                               ; Y1.`1 + Y0.`2
                               ; Y2.`1
                               ; Y3.`1
                               ; X4.`1 + Y3.`2])).
 rewrite /val_digits /=.
 rewrite (W64.splitwE 26 (X0.`1 + u64_5 * X4.`2)) //=.
 rewrite (W64.splitwE 26 (x{hr}.[1] + X0.`2)) //=.
 have : to_uint (x{hr}.[2]) + to_uint (Y1.`2)
        = to_uint Y2.`1 + twoPow26 * to_uint Y2.`2.
  have -> := W64.to_uint_splitBits 26 (x{hr}.[2] + Y1.`2) _ => //.
  rewrite bW64_to_uintD // /Y1 /splitBits; smt(@BW64').
 have : to_uint (X3.`1) + to_uint (Y2.`2) = to_uint Y3.`1 + twoPow26 * to_uint Y3.`2.
  have -> := W64.to_uint_splitBits 26 (X3.`1 + Y2.`2) _ => //.
  rewrite bW64_to_uintD // /X3 /Y2 /splitBits /max /=; smt(@BW64').
 rewrite /Y3/Y2/Y1/Y0/X4/X3/X0 /splitBits /max //=; clear X0 X3 X4 Y0 Y1 Y2 Y3.
 rewrite !bW64_to_uintD  /=; smt(@BW64').
congr; congr; rewrite /to_list /mkseq /= !W64.shl_shlw // !W64.shr_shrw //.
rewrite /Y3/Y2/Y1/Y0/X4/X3/X0 /splitBits /=; clear X0 X3 X4 Y0 Y1 Y2 Y3.
have <-: u64_5 * (x{hr}.[4] + (x{hr}.[3] `>>>` 26) `>>>` 26)
         = ((x{hr}.[4] + (x{hr}.[3] `>>>` 26) `>>>` 26) +
            (x{hr}.[4] + (x{hr}.[3] `>>>` 26) `>>>` 26 `<<<` 2)).
 pose X:= x{hr}.[4] + (x{hr}.[3] `>>>` 26) `>>>` 26.
 apply W64.word_modeqP; congr.
 rewrite bW64_to_uintD; first 2 rewrite /X; smt(@BW64).
 have H4: bW64 38 X by rewrite /X; smt(@BW64').
 rewrite (bW64_to_uintM 3 38) //; first smt(@BW64').
 rewrite to_uint_shl //= modz_small.
  apply bound_abs.
  move: H4; rewrite bW64ub //=; smt(W64.to_uint_cmp).
 smt().
by rewrite -iotaredE /=.
qed.

lemma carry_reduce_spec_ll: islossless Mrep5.carry_reduce.
proof. by islossless. qed.

lemma carry_reduce_spec xx :
  phoare [Mrep5.carry_reduce:
            bRep5 63 x /\ xx = x
           ==>
            bRep5 27 res /\ repres5 res = repres5 xx] = 1%r.
proof. by conseq carry_reduce_spec_ll (carry_reduce_spec_h xx). qed.

lemma add_mulmod_spec_h hh mm rr:
   hoare [ Mrep5.add_mulmod: 
             bRep5 27 hh /\ bRep5 26 mm /\ bRep5 28 rr /\
             hh = h /\ mm = m /\ rr = r /\ 
             rx5 = mul5Rep54 r
             ==>
             bRep5 27 res /\
             repres5 res = ((repres5 hh) + (repres5 mm)) * (repres5 rr) ].
proof.
proc => /=.
seq 1: (#[/1:3,5:]pre /\ repres5 h = repres5 hh + repres5 mm /\ bRep5 28 h).
 have H: max 27 26 < 63 by smt().
 call (add_spec_h 27 26 hh mm H) => //.
exists* h; elim* => h1.
seq 1: (#[/2:7]pre /\
        repres5 h = (repres5 hh + repres5 mm) * repres5 rr /\ bRep5 63 h).
  call (mulmod_spec_h h1 rr); auto => /> *; smt().
exists* h; elim* => h2.
call (carry_reduce_spec_h h2); skip; progress; smt().
qed.

lemma add_mulmod_spec_ll: islossless Mrep5.add_mulmod.
proof. by islossless. qed.

lemma add_mulmod_spec hh mm rr:
  phoare [ Mrep5.add_mulmod: 
             bRep5 27 hh /\ bRep5 26 mm /\ bRep5 28 rr /\
             hh = h /\ mm = m /\ rr = r /\ 
             rx5 = mul5Rep54 r
             ==>
             bRep5 27 res /\
             repres5 res = ((repres5 hh) + (repres5 mm)) * (repres5 rr) ] = 1%r.
proof. by conseq add_mulmod_spec_ll (add_mulmod_spec_h hh mm rr). qed.

lemma add_pack_spec_h hh1 hh2 hh3 hh4 :
  hoare [ Mrep5.add_pack: 
            bRep5 27 hh1 /\ bRep5 27 hh2 /\ bRep5 27 hh3 /\ bRep5 27 hh4 /\
            hh1 = h1 /\ hh2 = h2 /\  hh3 = h3 /\  hh4 = h4 
          ==>
            ubW64 4 res.[2] /\
            repres3 res = repres5 hh1 + repres5 hh2 + repres5 hh3 + repres5 hh4 ].
proof.
proc.
seq 11: (#pre /\
         valRep5 h1 + valRep5 h2 + valRep5 h3 + valRep5 h4
         = val_limbs twoPow52 (to_list d) /\
         bW64 29 d.[2]).
 wp; skip; rewrite !bRep5E => &hr /= [#] 20? ->>->>->>->>; do split => //; last first. 
  have ->: h4{hr}.[4] + h3{hr}.[4] + h2{hr}.[4] + h1{hr}.[4]
           = (h4{hr}.[4] + h3{hr}.[4]) + (h2{hr}.[4] + h1{hr}.[4]) by ring;
    smt(@BW64'). 
    smt(@BW64'). 
 rewrite !valRep5E /val_digits /to_list /mkseq -iotaredE /max /=.
 do 2!(rewrite set_neqiE //).
 do 1!(rewrite set_eqiE //).
 do 1!(rewrite set_neqiE //).
 do 1!(rewrite set_eqiE //).
 rewrite !bW64_to_uintD; first 34 by smt(@BW64).
 rewrite !W64.shl_shlw // !W64.to_uint_shl //=.
 have P: forall (w: W64.t), bW64 27 w =>
            to_uint w * twoPow26 %% W64.modulus = to_uint w * twoPow26.
  move=> w; rewrite bW64ub /ubW64 -(StdOrder.IntOrder.ler_pmul2r twoPow26) //= => Hw.
  rewrite modz_small //; smt(W64.to_uint_cmp).
 by rewrite !P //; ring.
seq 7: (#[/:8]pre /\
         valRep5 h1 + valRep5 h2 + valRep5 h3 + valRep5 h4
         = val_limbs64 [d.[0]; d.[2]] + valRep3 r /\
        bW64 5 r.[2]).
 wp; skip; rewrite !bRep5E => &hr /= [#] 20? ->>->>->>->> H19 H20 />.
 do split; last by smt(@BW64').
 move: H19.
 rewrite valRep5E /val_limbs /= /to_list /mkseq  -iotaredE /= /val_digits /=. 
 rewrite !W64.shl_shlw // !W64.shr_shrw // /val_digits /to_list /mkseq  /=.
 pose x1 := W64.splitBits 12 d{hr}.[1].
 have := W64.to_uint_splitBits 12 d{hr}.[1] _; first done.
 rewrite /splitBits /= => Hx1.
 pose x2 := W64.splitBits 24 d{hr}.[2].
 have := W64.to_uint_splitBits 24 d{hr}.[2] _; first done.
 rewrite /splitBits /= => Hx2.
 rewrite -Hx1 -Hx2 => H19.
 have ->: d{hr}.[2] `<<<` 40 = (d{hr}.[2] `&` W64.masklsb 24) `<<<` 40.
  rewrite W64.andmask_shlw // -bW64andmaskE //.
  by apply bW64T.
 have ->: d{hr}.[1] `<<<` 52 = (d{hr}.[1] `&` W64.masklsb 12) `<<<` 52.
  rewrite W64.andmask_shlw // -bW64andmaskE //.
  by apply bW64T.
 rewrite W64.to_uint_shl //= modz_small.
  rewrite to_uint_and_mod /max //=; smt(StdOrder.IntOrder.gtr0_norm modz_cmp).
 rewrite W64.to_uint_shl // modz_small.
  rewrite to_uint_and_mod /max //=; smt(StdOrder.IntOrder.gtr0_norm modz_cmp).
 by ring H19. 

seq 8: (#[/:8]pre /\
         valRep5 h1 + valRep5 h2 + valRep5 h3 + valRep5 h4
         = valRep3 r /\
        bW64 6 r.[2]).

+ wp; skip; rewrite !bRep5E => &hr /= [#] 20? ->>->>->>->> H19 H20 />.
 do split; last first. 
  rewrite !addcE /=.
  apply (bW64D 5 1) => //.
  case: (W64.carry_add _ _ _); rewrite ?b2i1 ?b2i0.
   by apply (BW64.bW64const 1).
  by apply (bW64W 0) => //; apply (BW64.bW64const 0).
 apply (eq_trans _ (val_limbs64 (add_limbs64nc [r{hr}.[0]; r{hr}.[1]; r{hr}.[2]]
                                               [d{hr}.[0]; d{hr}.[2]]))).
  move: H20; rewrite bW64ub // /ubW64 /= => H20.
  rewrite (add_limbs64ncP 31 0) // H19 /val_digits /to_list /mkseq /=. 
  by ring.
 rewrite /add_limbs64nc /val_digits /=; ring.
 by rewrite !addcE /=; ring.
wp; skip; rewrite !bRep5E => &hr /= [#] 20? ->>->>->>->> H19 H20 />.
do split.
 rewrite !W64.addcE /= /ubW64.
 have ?: to_uint (r{hr}.[2] `&` (of_int 3)%W64) <= 3.
  by rewrite andwC; apply W64.to_uint_ule_andw.
 case: (W64.carry_add _ _ _); rewrite ?b2i0 ?b2i1; 1,2:
  rewrite (_: 3 = 2^2-1) 1:/# to_uintD W64.to_uint_and_mod //=; smt(W64.to_uint_cmp pow2_64).
rewrite repres3E !repres5E.
have ->: inzp (valRep5 h1{hr}) + inzp (valRep5 h2{hr})
           + inzp (valRep5 h3{hr}) + inzp (valRep5 h4{hr})
         = inzp (valRep5 h1{hr} + valRep5 h2{hr} + valRep5 h3{hr} + valRep5 h4{hr})
 by rewrite !inzpD.
rewrite H19 valRep3E /=; clear H19.
have ->:  (of_int (-4))%W64 = invw (W64.masklsb 2).
 rewrite of_intN.
 apply W64.word_modeqP; congr.
 by rewrite to_uintNE of_uintK !modz_small // to_uint_invw of_uintK modz_small.
have ->: ((r{hr}.[2] `>>` (of_int 2)%W8) +
          r{hr}.[2] `&` invw ((masklsb 2))%W64) = u64_5 * (r{hr}.[2] `>>>` 2).
 rewrite -shrl_andmaskN // W64.shr_shrw //.
 apply W64.word_modeqP; congr.
 rewrite bW64_to_uintD; first 2 by smt(@BW64').
 rewrite (bW64_to_uintM 3 4); first 3 by smt(@BW64').
 rewrite of_uintK modz_small // to_uint_shl // modz_small //=.
  apply bound_abs; split; first smt(W64.to_uint_cmp).
  have : bW64 4 (r{hr}.[2] `>>>` 2) by smt(@BW64).
  by rewrite bW64ub // /ubW64 /= => *;  smt(W64.to_uint_cmp).
 have ->: to_uint (r{hr}.[2] `>>>` 2) + to_uint (r{hr}.[2] `>>>` 2) * 4
          = 5 * to_uint (r{hr}.[2] `>>>` 2) by ring.
 done.
apply (eq_trans _ (inzp (val_limbs64 [r{hr}.[0]; r{hr}.[1]; r{hr}.[2]`&`W64.masklsb 2]
                         + val_limbs64 [u64_5 * (r{hr}.[2] `>>>` 2)]))).
 congr; rewrite -(add_limbs64ncP 3 0) // /nth_limbs64 /=.
   by rewrite -(bW64ub 2) // (bW64mask 2) //.
 rewrite /val_digits /to_list /mkseq /add_limbs64nc /max /=.
 by rewrite !addcE /= (W64.carry_addC r{hr}.[1] W64.zero); ring.
rewrite inzpD /val_digits /to_list /mkseq /= eq_sym.
rewrite (bW64_to_uintM 3 4) //; first 2 by smt(@BW64').
rewrite of_uintK modz_small // -inzp_over -inzpD; congr.
by rewrite (W64.splitwE 2 r{hr}.[2]) //=; ring.
qed.

lemma add_pack_spec_ll: islossless Mrep5.add_pack.
proof. by islossless. qed.

lemma add_pack_spec hh1 hh2 hh3 hh4 :
 phoare [ Mrep5.add_pack: 
           bRep5 27 hh1 /\ bRep5 27 hh2 /\ bRep5 27 hh3 /\ bRep5 27 hh4 /\
           hh1 = h1 /\ hh2 = h2 /\  hh3 = h3 /\  hh4 = h4 
          ==>
           ubW64 4 res.[2] /\
           repres3 res = repres5 hh1 + repres5 hh2 + repres5 hh3 + repres5 hh4] = 1%r.
proof. by conseq add_pack_spec_ll (add_pack_spec_h hh1 hh2 hh3 hh4). qed.

