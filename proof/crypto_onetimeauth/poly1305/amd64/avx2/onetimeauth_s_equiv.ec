require import AllCore IntDiv CoreMap List Distr StdOrder Ring Poly1305_spec.
from Jasmin require import JModel.

require import Array2 Array3 Array4 Array5.
require import WArray16 WArray24 WArray64 WArray96 WArray128 WArray160.

require import Poly1305_savx2.
require import Onetimeauth_s.

lemma nosmt ltr_weexpn2l (x : int):
   1 < x => forall (m n : int), 0 <= m && m < n => x ^ m < x ^ n.
proof. 
move => Hx m n Hnl.
have := IntOrder.ler_weexpn2l x _ m (n-1) _ => //=;1,2:smt().
have := IntOrder.ler_weexpn2l x _ (n-1) (n) _ => //=;1..2:smt().
by smt(IntOrder.ieexprIn).
qed.

op next_multiple(p : W64.t) = if to_uint p %% 16 = 0 
                              then to_uint p 
                              else (to_uint p %/ 16 + 1) * 16.

(* EQUIVALENCE BETWEEN REG BASED AND MEMORY OUTPUT *)
equiv onetimeauth_s_r_mem_equiv mem outt :
    M.__poly1305_r_avx2 ~ M.__poly1305_avx2 :
    Glob.mem{1} = mem /\ ={Glob.mem} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    good_ptr (to_uint out{2}) 16 /\ out{2} = outt /\
    ={in_0,inlen,k} ==> 
     Glob.mem{1} = mem /\
     Glob.mem{2} = storeW128 mem (W64.to_uint outt)
       (W2u64.pack2 [res{1}.[0];res{1}.[1]]).
proof. 
proc* => //=; inline {2} 1.
sp; seq 1 1 : (={Glob.mem} /\ Glob.mem{1} = mem /\ 
    to_uint out0{2} <= to_uint out{2} + 16 /\ 
     to_uint out0{2} + 16 < 18446744073709551616 /\
    out0{2} = outt /\ r{1} = h2{2}); 1: by conseq />; sim.
inline *; auto => /> &2 ??.
by rewrite store2u64 /= to_uintD_small /=; smt(W64.to_uint_cmp pow2_64).
qed.

(* MAIN PROOF OF EQUIVALENCE TO PREVIOUS VERSION OF POLY FOR MEM BASED *)


equiv update_e :  M.__poly1305_update_ref ~ Poly1305_savx2.M.poly1305_ref3_update : ={Glob.mem,arg} ==> ={res}  by sim.

hoare update_h : M.__poly1305_update_ref :
    good_ptr (to_uint in_0) (next_multiple inlen) ==> 
    to_uint res.`2 < 16 /\ (0< to_uint res.`2 => good_ptr (to_uint res.`1) 16).
proc. 
while (good_ptr (to_uint in_0) (next_multiple inlen)); last by 
  auto => /> &m ?? in_0 inlen; 
  rewrite uleE /next_multiple /=; smt(W64.to_uint_cmp).
inline 2; wp => /=; conseq />.
inline *; auto => />.
auto => /= ???; rewrite uleE /next_multiple /= => ?. 
rewrite to_uintD_small /=; 1:  smt(W64.to_uint_cmp).
rewrite to_uintB /=; 1: by rewrite uleE; smt(W64.to_uint_cmp).
by smt(W64.to_uint_cmp).
qed.

equiv update :  M.__poly1305_update_ref ~ Poly1305_savx2.M.poly1305_ref3_update : 
   good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\ ={Glob.mem,arg} ==> 
   ={res} /\ to_uint res{1}.`2 < 16 /\ 
   (0 < to_uint res{1}.`2 => good_ptr (to_uint res{1}.`1) 16) by conseq update_e update_h.

equiv update_avx2_e :  M.__poly1305_avx2_update ~ Poly1305_savx2.M.poly1305_avx2_update : ={Glob.mem,arg} ==> ={res}.
proc.
wp;call(_: ={Glob.mem}).
+ by  sim; auto => />. 
wp;call(_: ={Glob.mem}).
+ wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}).
  + do 8!(unroll for {1} ^while).
    by auto => />.
  by auto => />.
  wp;conseq (_: _ ==> ={h, m, s_mask26, s_bit25, r1234, r1234x5,in_0,r4444,r4444x5,Glob.mem} /\ inlen{1} = len{2}); 1: by smt().
  while (#post); last first. 
  + inline *. 
    unroll for {1} ^while.
    unroll for {2} ^while.
    by auto => />; rewrite !W4u64.of_uint_pack4 /VPBROADCAST_4u64 -iotaredE /=. 
  wp;conseq (_: _ ==> ={h, m, s_mask26, s_bit25, r1234, r1234x5,in_0} /\ inlen{1} = len{2}); 1: by smt().  
  wp; call(_: ={Glob.mem}); 1: by auto => />.
  by auto => />.
qed.

lemma update_avx2_h : 
  hoare [ M.__poly1305_avx2_update :
    256 <= to_uint inlen /\
    good_ptr (to_uint in_0) (next_multiple inlen) ==> 
    (0< to_uint res.`2 => good_ptr (to_uint res.`1) (next_multiple res.`2))].
proc => /=. 
call(_: true); 1: by auto => />.
call(_: true); 1: by auto => />.
wp; conseq />;1:smt().
while (64 <= to_uint inlen /\ good_ptr (to_uint in_0) (next_multiple (inlen - W64.of_int 64))); last first. 
+ unroll for 5; inline *; auto => /> &hr;rewrite /next_multiple /= => H H0 H1;  do split.
  + smt(). 
  + rewrite to_uintD_small /=; smt(W64.to_uint_cmp).
  rewrite to_uintD_small /=; 1: smt(W64.to_uint_cmp).
  by  rewrite to_uintB /=; 1: rewrite uleE /=; smt(W64.to_uint_cmp uleE).

inline 1; wp; conseq />; auto => />.
rewrite uleE /next_multiple /= => &hr H H0 H1 H2.
move : H0 H1. 
 rewrite !to_uintB /=; 1: by rewrite uleE /=; smt(W64.to_uint_cmp uleE).
  rewrite uleE  !to_uintB /=; 1: by rewrite uleE /=; smt(W64.to_uint_cmp uleE).
  by smt().
 by  rewrite uleE /=; smt(W64.to_uint_cmp).

move => ??; rewrite to_uintD_small /=;smt(W64.to_uint_cmp). 
qed.

lemma update_avx2 : 
 equiv[  M.__poly1305_avx2_update ~ Poly1305_savx2.M.poly1305_avx2_update : 
   256 <= to_uint inlen{1} /\
   good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\ ={Glob.mem,arg} ==> 
   ={res} /\ (0< to_uint res{1}.`2 => good_ptr (to_uint res{1}.`1) (next_multiple res{1}.`2))] by 
  conseq update_avx2_e update_avx2_h  => /#.

equiv load_last :
  M.__load_last_add ~ Poly1305_savx2.M.load_last_add :
  good_ptr  (to_uint in_0{2}) 16 /\
  to_uint len{1} < 16 /\
  ={arg,Glob.mem} ==> ={res,Glob.mem}.
proof.
proc => /=. 
wp 6 6; conseq (_: _ ==> v{1} = s{2}); 1: smt().
seq 4 1 : (#pre /\ 
  (8 <= to_uint len{1} => (* using two words *)
    (forall k, 0 <= k < 8 =>  
      (W8u8.unpack8 m1{1}.[0]).[k] = W8.masklsb 8 /\
      (W8u8.unpack8 m2{1}.[0]).[k] = W8.zero) /\
   (forall k, 0 <= k < to_uint len{1} - 8 => 
      (W8u8.unpack8 m1{1}.[1]).[k] = W8.masklsb 8 /\
      (W8u8.unpack8 m2{1}.[1]).[k] = W8.zero) /\
   (forall k, to_uint len{1} - 8 + 1 <= k < 8 => 
      (W8u8.unpack8 m1{1}.[1]).[k] = W8.zero /\
      (W8u8.unpack8 m2{1}.[1]).[k] = W8.zero) /\
   (W8u8.unpack8 m1{1}.[1]).[to_uint len{1} - 8] = W8.zero /\
   (W8u8.unpack8 m2{1}.[1]).[to_uint len{1} - 8] = W8.one) /\
  (to_uint len{1} < 8 =>
    (forall k, 0 <= k < 8 => 
      (W8u8.unpack8 m1{1}.[1]).[k] = W8.zero /\
      (W8u8.unpack8 m2{1}.[1]).[k] = W8.zero) /\
   (forall k, 0 <= k < to_uint len{1} => 
      (W8u8.unpack8 m1{1}.[0]).[k] = W8.masklsb 8 /\
      (W8u8.unpack8 m2{1}.[0]).[k] = W8.zero) /\
   (forall k, to_uint len{1} + 1 <= k < 8 => 
      (W8u8.unpack8 m1{1}.[0]).[k] = W8.zero /\
      (W8u8.unpack8 m2{1}.[0]).[k] = W8.zero) /\
   (W8u8.unpack8 m1{1}.[0]).[to_uint len{1}] = W8.zero /\
   (W8u8.unpack8 m2{1}.[0]).[to_uint len{1}] = W8.one)
).      
+ inline *. 
  swap {1} 4 2. swap {1} 7 11.
  seq 5 1 : #pre; 1 : by auto.
  sp 1 0.
  seq 3 0 : (#pre /\ to_uint s1{1} = to_uint len{1} %% 8 * 8); first 
  by auto => /> &2 *;
     rewrite /(`<<`) to_uint_shl 1:// /=  (_: 7 = 2^3-1) 1://= W64.to_uint_and_mod //;
     rewrite modz_small /#. 
  seq 2 0 : (#pre /\ to_uint b{1} = to_uint len{1} %/ 8); first by
     auto => /> &2 *; rewrite /(`>>`) to_uint_shr 1:// /=. 
  seq 2 0 : (#pre /\ to_uint nb{1} = if to_uint len{1} < 8 then 1 else 0).
  + auto => /> &1 &2 3?. 
    case(to_uint len{2} < 8).
    + move => *; rewrite -W64.to_uint1  -to_uint_eq wordP =>  /= i ib.
      case (i = 0);1: by rewrite !get_to_uint /= ib /= => ->;  smt(pdiv_small W64.to_uint_cmp).
      move => *; rewrite !get_to_uint /= ib /=.
      by have -> /= : to_uint b{1} = 0 by smt(pdiv_small W64.to_uint_cmp).
       
    + move => *; rewrite -W64.to_uint0  -to_uint_eq wordP =>  /= i ib.
      case (i = 0); 1: by rewrite !get_to_uint /=; smt(). 
      move => *; rewrite !get_to_uint /= ib /=;
       have  := pdiv_small (to_uint b{1}) (2^i) _ => //; last
           smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l). 
      have -> : to_uint b{1} = 2^0; first by simplify; smt().
      split => *; 1: by auto. 
      by smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l). 

  seq 2 0: (#pre /\  m{1} = if to_uint len{1} < 8 then W64.onew else W64.zero).
  + auto => /> &1 &2 *. 
    case(to_uint len{2} < 8).
    + move => *; have -> : b{1} = W64.zero by rewrite to_uint_eq /=; smt(W64.to_uint_cmp).
      by rewrite minus_one; ring. 
    move => *; have -> : b{1} = W64.one by rewrite to_uint_eq /=; smt(W64.to_uint_cmp).
    by ring.
  seq 2 0 : (#pre /\ s2{1} = if to_uint len{1} < 8 then s1{1} else W64.zero).
  + auto => /> &1 &2 *. 
    case(to_uint len{2} < 8); 1: by move => *; rewrite W64.andw1 /=. 
    by move => *; rewrite andw0.
  seq 3 0 : (#{/~s1{1}}pre /\ 
             to_uint s0{1} = (if to_uint len{1} < 8 then to_uint len{1} %% 8 * 8 else 0) /\
             to_uint s1{1} = if to_uint len{1} < 8 then 0 else to_uint len{1} %% 8 * 8).
  + by auto => /> &1 &2 4?;
       case(to_uint len{2} < 8); move => *; rewrite /set0_64_ /= /#.
  auto => /> &1 &2 ?? H H0 H1 H2 H3; split.
  + move => Hl; do split.
    + move => k kbl kbh; split; last first.
      + rewrite wordP => i ib /=.
        rewrite  /(`<<`) /truncateu8 /= H2 /= ifF 1:/# /=. 
        rewrite get_unpack8 // /(\bits8) /= initiE //= !get_to_uint.
        by rewrite H1 ifF 1:/# /=.
      rewrite /copy_64 /= /truncateu8 /= H2 /= ifF 1:/# /=. 
      rewrite /(`<<`)  /subc get_unpack8 // /(\bits8) /b2i /= wordP /= => i ib.
      rewrite /min /=  initiE //= ib/=. 
      have -> /= : (nb{1} `<<<` 0) = W64.zero 
        by rewrite to_uint_eq to_uint_shl //= H1 ifF 1:/# /=.
      by move : (W64.masklsbE 64 (k*8+i)) => -> /= /# . 
    + move => k kbl kbh; split; last first.
      + rewrite wordP => i ib /=; rewrite  /(`<<`) /truncateu8 /= H3 /= ifF 1:/# /=. 
        by rewrite get_unpack8 // /(\bits8) 1:/# /= initiE //= !get_to_uint; smt().
      rewrite /copy_64 /= /truncateu8 /= H2 /= ifF 1:/# /=. 
      rewrite /(`<<`) /subc /borrow_sub get_unpack8 // /(\bits8) /b2i 1: /# /= wordP /= => i ib.
      rewrite /min /=  initiE //= ib/=. 
      have -> /= : (nb{1} `<<<` 0) = W64.zero 
        by rewrite to_uint_eq to_uint_shl //= H1 ifF 1:/# /=.
      rewrite H3 ifF 1:/# /= modz_small 1:/# modz_small 1:/#.
      pose x:= ((b{1} `<<<` (to_uint len{2} - 8) * 8) - W64.one).
      have Hx : to_uint x  %% 2^((to_uint len{2} - 8) * 8) = to_uint (W64.masklsb ((to_uint len{2} - 8) * 8)).
      +  rewrite /x minus_one to_uintD /onew /= to_uint_shl 1:/# /= /max /= ifT 1:/# of_uintK /=.         
         have /= expeb : 2^0 <= 2^((to_uint len{2} - 8) * 8) < 2^64; last
            smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         split; 2:smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         case (to_uint len{2} = 8); 1: by move => -> ;simplify.
         move => *; have : 2^0 <  2 ^ ((to_uint len{2} - 8) * 8); last by smt().
         by apply ltr_weexpn2l; smt().
         
      have : b2i x.[k * 8 + i] = 1; last by smt().
      rewrite W64.b2i_get 1:/#. 
      have : to_uint x %% 2 ^ ((to_uint len{2} - 8) * 8) %/ 2 ^ (k * 8 + i) %% 2 = 1.
      + rewrite Hx -to_uint_shr 1:/# wlsrE /= to_uintE /= /min /= ifT 1:/# /= /w2bits /=.
        pose l := mkseq _ 64.
        have := (BitEncoding.BS2Int.bs2int_cons (0 <= 0 + (k * 8 + i) && 0 + (k * 8 + i) < (to_uint len{2} - 8) * 8) 
                (behead l)). 
        by rewrite /l /w2bits /= /mkseq -iotaredE /= !initiE //= => ->; smt().
      move => <-. 
      have : 2 ^ (k * 8 + i) < 2 ^ ((to_uint len{2} - 8) * 8) 
             by   smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
      by rewrite modz_pow2_div 1:/# modz_dvd /=; 1: rewrite -{1}(Ring.IntID.expr1 2); 1: apply dvdz_exp2l; smt(). 
    + move => k kbl kbh; split; last first.
      + rewrite wordP => i ib /=.
        rewrite  /(`<<`) /truncateu8 /= H3 /= ifF 1:/# /=. 
        rewrite get_unpack8 // /(\bits8) 1:/# /= initiE //= !get_to_uint modz_dvd //=. 
        have : to_uint b{1} %/ 2 ^ (k * 8 + i - to_uint len{2} %% 8 * 8 %% 64) = 0; last 
          smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l). 
        rewrite modz_small; 1: by smt().
        have -> : to_uint b{1} = 2^0; first by simplify; smt().
        apply pdiv_small; split => *; 1: by auto.
        by have : 1<k * 8 + i - to_uint len{2} %% 8 * 8;
          smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l). 


      rewrite /copy_64 /= /truncateu8 /= H2 /= ifF 1:/# /=. 
      rewrite /(`<<`)  /subc /borrow_sub get_unpack8 // /(\bits8) /b2i 1: /# /= wordP /= => i ib.
      rewrite /min /=  initiE //=. 
      have -> /= : (nb{1} `<<<` 0) = W64.zero 
        by rewrite to_uint_eq to_uint_shl //= H1 ifF 1:/# /=.
      rewrite H3 ifF 1:/# /=.
      rewrite modz_small 1:/# modz_small 1:/#.
      have -> : to_uint len{2} %% 8 = to_uint len{2} - 8 by smt().
      pose x:= ((b{1} `<<<` (to_uint len{2} - 8) * 8) - W64.one).
      have : b2i x.[k * 8 + i] = 0; last by smt().
      rewrite W64.b2i_get 1:/#. 
      have : 2 ^ ((to_uint len{2} - 8) * 8)  < 2 ^ (k * 8 + i)
             by   smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
      have : to_uint x = 2 ^ ((to_uint len{2} - 8) * 8) -1 ; last 
             by   smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
      rewrite /x /= to_uintB; 1: by rewrite uleE /= to_uint_shl 1:/# /= modz_small;
            smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64 gt0_pow2). 
      by rewrite /= to_uint_shl 1:/# /= modz_small /=;
           smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64 gt0_pow2).

      rewrite /copy_64 /= /truncateu8 /= H2 /= ifF 1:/# /=. 
      rewrite /(`<<`)  /subc /borrow_sub get_unpack8 // /(\bits8) /b2i 1: /# /= wordP /= => i ib.
      rewrite /min /=  initiE //=. 
      have -> /= : (nb{1} `<<<` 0) = W64.zero 
        by rewrite to_uint_eq to_uint_shl //= H1 ifF 1:/# /=.
      rewrite H3 ifF 1:/# /=.
      rewrite modz_small 1:/# modz_small 1:/#.
      have -> : to_uint len{2} %% 8 = to_uint len{2} - 8 by smt().
      pose x:= ((b{1} `<<<` (to_uint len{2} - 8) * 8) - W64.one).
      have : b2i x.[(to_uint len{2} - 8) * 8 + i] = 0; last by smt().
      rewrite W64.b2i_get 1:/#. 
      have : to_uint x = 2 ^ ((to_uint len{2} - 8) * 8) -1 ; last 
             by   smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
      rewrite /x /= to_uintB; 1: by rewrite uleE /= to_uint_shl 1:/# /= modz_small;
            smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64 gt0_pow2). 
      by rewrite /= to_uint_shl 1:/# /= modz_small /=;
           smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64 gt0_pow2).
    + rewrite wordP => i ib /=.
      rewrite  /(`<<`) /truncateu8 /= H3 /= ifF 1:/# /=. 
      by rewrite get_unpack8 // /(\bits8) 1:/# /= initiE //= !get_to_uint modz_dvd //= /#. 

(*******)
(*******)

  + move => Hl; do split.
    + move => k kbl kbh; split; last first.
      + rewrite wordP => i ib /=.
        rewrite  /(`<<`) /truncateu8 /= H3 /= ifT 1:/# /=. 
        rewrite get_unpack8 // /(\bits8) /= initiE //= !get_to_uint.
        have : to_uint b{1} %/ 2 ^ (k * 8 + i) %% 2 = 0; last by smt().
        by rewrite H0 (pdiv_small _ 8) /=; smt(W64.to_uint_cmp).
      rewrite /copy_64 /= /truncateu8 /= H2 /= ifT 1:/# /=. 
      rewrite /(`<<`)  /subc /borrow_sub get_unpack8 // /(\bits8) /b2i /= wordP /= => i ib.
      rewrite /min /=  initiE //= !modz_dvd //=. 
      have -> /= : (b{1} `<<<` to_uint s1{1} %% 64) = W64.zero by
        rewrite to_uint_eq to_uint_shl //= H3 ifT 1:/# //=; smt(W64.to_uint_cmp).
      by rewrite ifF /=; 1: by rewrite to_uint_shl 1:/# /=;
           smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64 gt0_pow2).
    + move => k kbl kbh; split; last first.
      + rewrite wordP => i ib /=.
        rewrite  /(`<<`) /truncateu8 /= H2 /= ifT 1:/# /=. 
        by rewrite get_unpack8 // /(\bits8) 1:/# /= initiE //= !get_to_uint; smt().
      rewrite /copy_64 /= /truncateu8 /= H2 /= ifT 1:/# /=. 
      rewrite /(`<<`)  /subc /borrow_sub get_unpack8 // /(\bits8) /b2i 1: /# /= wordP /= => i ib.
      rewrite /min /=  initiE //= ib/=  !modz_dvd //= (modz_small _ 8) 1:/# (modz_small _ 64) 1:/#. 
      pose x:= ((nb{1} `<<<` to_uint len{2} * 8) - W64.one).
      have Hx : to_uint x  %% 2^(to_uint len{2} * 8) = to_uint (W64.masklsb (to_uint len{2} * 8)).
      +  rewrite /x minus_one to_uintD /onew /= to_uint_shl 1:/# /= /max /= ifT 1:/# of_uintK /=.
         pose e:= to_uint len{2} * 8. 
         have /= expeb : 2^0 <= 2^e < 2^64; last
          smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         split; last smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         have  : 2 ^ 0 < 2 ^ e; last by smt().
         apply ltr_weexpn2l;by smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64).
      have : b2i x.[k * 8 + i] = 1; last by smt().
      rewrite W64.b2i_get 1:/#. 
      have : to_uint x %% 2 ^ (to_uint len{2}* 8) %/ 2 ^ (k * 8 + i) %% 2 = 1.
      + rewrite Hx -to_uint_shr 1:/# wlsrE /= to_uintE /= /min /= ifT 1:/# /= /w2bits /=.
        pose l := mkseq _ 64.
        have := (BitEncoding.BS2Int.bs2int_cons (0 <= 0 + (k * 8 + i) && 0 + (k * 8 + i) < to_uint len{2} * 8) 
                (behead l)). 
        by rewrite /l /w2bits /= /mkseq -iotaredE /= !initiE //= => ->; smt().
      move => <-. 
      have : 2 ^ (k * 8 + i) < 2 ^ (to_uint len{2} * 8) 
             by   smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
      by rewrite modz_pow2_div 1:/# modz_dvd /=; 1: rewrite -{1}(Ring.IntID.expr1 2); 1: apply dvdz_exp2l; smt(). 
    + move => k kbl kbh; split; last first.
      + rewrite wordP => i ib /=.
        rewrite  /(`<<`) /truncateu8 /= H2 /= ifT 1:/# /=. 
        rewrite get_unpack8 // /(\bits8); 1:smt(W64.to_uint_cmp). 
        rewrite /= initiE //= !get_to_uint modz_dvd //=. 
        have : to_uint nb{1} %/ 2 ^ (k * 8 + i - to_uint len{2} %% 8 * 8 %% 64) = 0.
        rewrite modz_small; 1: by smt().
        have -> : to_uint nb{1} = 2^0; first by simplify; smt().
        apply pdiv_small; split => *; 1: by auto.
        have : 1<k * 8 + i - to_uint len{2} %% 8 * 8;
          smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l). 
        by  smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l). 
      rewrite /copy_64 /= /truncateu8 /= H2 /= ifT 1:/# /=. 
      rewrite /(`<<`)  /subc /borrow_sub get_unpack8 // /(\bits8) /b2i; 1:smt(W64.to_uint_cmp). 
      rewrite /= wordP /= => i ib.
      rewrite /min /=  initiE //=  !modz_dvd //= (modz_small _ 8); 1:smt(W64.to_uint_cmp). 
      rewrite (modz_small _ 64); 1:smt(W64.to_uint_cmp). 
      pose x:= ((nb{1} `<<<` to_uint len{2} * 8) - W64.one).
      case(to_uint len{2} = 0). 
      + move => Hx; rewrite /x Hx /=. 
        have Hxx : to_uint ((nb{1} `<<<` 0) - W64.one) = 0 by
          have -> /= : (nb{1} `<<<` 0) = W64.one by rewrite to_uint_eq to_uint_shl //=;smt(W64.to_uint_cmp). 
        have : b2i ((nb{1} `<<<` 0) - W64.one).[k * 8 + i] = 0; last by smt().
        by rewrite W64.b2i_get 1:/# Hxx /=. 
      move => ?.           
      have Hx : to_uint x = to_uint (W64.masklsb (to_uint len{2} * 8)).
      +  rewrite /x minus_one to_uintD /onew /= to_uint_shl /=; 1:smt(W64.to_uint_cmp).   
         rewrite /max /= ifT;1:smt(W64.to_uint_cmp).
         rewrite of_uintK /=. 
         pose e:= to_uint len{2} * 8. 
         have /= expeb : 2^0 <= 2^e < 2^64; last
          smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         split; last smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         have  : 2 ^ 0 < 2 ^ e; last by smt().
         apply ltr_weexpn2l;by smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64).

         have : b2i x.[k * 8 + i] = 0; last by smt().
         rewrite W64.b2i_get; 1:smt(W64.to_uint_cmp). 
         rewrite Hx -to_uint_shr; 1:smt(W64.to_uint_cmp).
         rewrite wlsrE /= to_uintE /= /min /= ifT 1:/# /= /w2bits /=.
         pose l := mkseq _ 64.
         have := (BitEncoding.BS2Int.bs2int_cons (0 <= 0 + (k * 8 + i) && 0 + (k * 8 + i) < to_uint len{2} * 8) 
                (behead l)). 
         by rewrite /l /w2bits /= /mkseq -iotaredE /= !initiE //= => ->; smt().
      rewrite /copy_64 /= /truncateu8 /= H2 /= ifT 1:/# /=. 
      rewrite /(`<<`)  /subc /borrow_sub get_unpack8 // /(\bits8) /b2i;1:smt(W64.to_uint_cmp).   
      rewrite  /= wordP /= => i ib.
      rewrite /min /=  initiE //=  !modz_dvd //= (modz_small _ 8); 1:smt(W64.to_uint_cmp).  
      rewrite (modz_small _ 64); 1:smt(W64.to_uint_cmp). 
      pose x:= ((nb{1} `<<<` to_uint len{2} * 8) - W64.one).
      case(to_uint len{2} = 0). 
      + move => Hx; rewrite /x Hx /=. 
        have Hxx : to_uint ((nb{1} `<<<` 0) - W64.one) = 0 by
          have -> /= : (nb{1} `<<<` 0) = W64.one by rewrite to_uint_eq to_uint_shl //=;smt(W64.to_uint_cmp). 
        have : b2i ((nb{1} `<<<` 0) - W64.one).[i] = 0; last by smt().
        by rewrite W64.b2i_get 1:/# Hxx /=. 
      move => ?.           
      have Hx : to_uint x = to_uint (W64.masklsb (to_uint len{2} * 8)).
      +  rewrite /x minus_one to_uintD /onew /= to_uint_shl /=; 1:smt(W64.to_uint_cmp).   
         rewrite /max /= ifT;1:smt(W64.to_uint_cmp).
         rewrite of_uintK /=. 
         pose e:= to_uint len{2} * 8. 
         have /= expeb : 2^0 <= 2^e < 2^64; last
          smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         split; last smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64). 
         have  : 2 ^ 0 < 2 ^ e; last by smt().
         apply ltr_weexpn2l;by smt(Ring.IntID.expr0 W64.to_uint_cmp ltr_weexpn2l pow2_64).
         have : b2i x.[to_uint len{2} * 8 + i] = 0; last by smt().
         rewrite W64.b2i_get; 1:smt(W64.to_uint_cmp). 
         rewrite Hx -to_uint_shr; 1:smt(W64.to_uint_cmp).
         rewrite wlsrE /= to_uintE /= /min /= ifT 1:/# /= /w2bits /=.
         pose l := mkseq _ 64.
         have := (BitEncoding.BS2Int.bs2int_cons (0 <= 0 + (to_uint len{2} * 8 + i) && 0 + (to_uint len{2} * 8 + i) < to_uint len{2} * 8) 
                (behead l)). 
         by rewrite /l /w2bits /= /mkseq -iotaredE /= !initiE //= => ->; smt().

    + rewrite wordP => i ib /=.
      rewrite  /(`<<`) /truncateu8 /= H2 /= ifT 1:/# /=. 
      rewrite get_unpack8 // /(\bits8) /=;1: by smt(W64.to_uint_cmp).
      by rewrite initiE //= !get_to_uint modz_dvd //=;1: by smt(W64.to_uint_cmp). 

(*******)
(*******)

  unroll for {1} 2.
  seq 9 0 : (#pre /\ 
    (forall k, 0<=k<to_uint len{1} => (WArray16.init64 (fun (i1 : int) => v{1}.[i1])).[k] = loadW8 Glob.mem{1} (to_uint in_0{1} + k)) /\ 
    (forall k, to_uint len{1} < k < 16 => (WArray16.init64 (fun (i1 : int) => v{1}.[i1])).[k] = W8.zero) /\ 
    (WArray16.init64 (fun (i1 : int) => v{1}.[i1])).[to_uint len{1}] = W8.one). 
  auto => /> &1 &2 vpl vph H H0 H1; do split.
  + move => k kbl kbh; rewrite initiE 1:/# /=.
    case (k < 8).
    + move => *;rewrite set_neqiE 1,2:/# set_eqiE 1,2:/# /= !modz_small //.
      case (8 <= to_uint len{2}).
      + move => Hl; have := (H0 Hl) => [#] H2 H3 H4 H5 H6.
        have := H2 k _; 1:smt().
        rewrite !get_unpack8 // => [#] -> -> /=.
        rewrite and_mod // /max /= /loadW64 pack8bE //= initiE //= modz_small; smt(W8.to_uint_cmp pow2_8). 
    +  move => Hl; have := (H1 _); 1:smt(). 
       move => [#] H2 H3 H4 H5 H6.
       have := H3 k _; 1:smt().
        rewrite !get_unpack8 // => [#] -> -> /=.
        rewrite and_mod // /max /= /loadW64 pack8bE //= initiE //= modz_small; smt(W8.to_uint_cmp pow2_8). 
    + move => *;rewrite set_eqiE 1,2:/# /= (_: k %% 8 = k - 8) 1: /#.
      case (8 <= to_uint len{2}); last by smt().
      + move => Hl; have := (H0 Hl) => [#] H2 H3 H4 H5 H6.
        have := H3 (k-8) _; 1:smt().
        rewrite !get_unpack8 1,2:/# => [#] -> -> /=.
        rewrite and_mod // /max /= /loadW64 pack8bE 1:/# initiE 1:/# modz_small /=;1 : smt(W8.to_uint_cmp pow2_8). 
         rewrite to_uintD_small /=; smt(W64.to_uint_cmp pow2_8).
  + move => k kbl kbh; rewrite initiE /=; 1:smt(W64.to_uint_cmp).
    case (k < 8).
    + move => *;rewrite set_neqiE /=; 1,2:smt(W64.to_uint_cmp).
      rewrite set_eqiE /=; 1,2:smt(W64.to_uint_cmp).
      rewrite !modz_small; 1:smt(W64.to_uint_cmp).
      case (8 <= to_uint len{2}).
      + move => Hl; have := (H0 Hl) => [#] H2 H3 H4 H5 H6.
        have := H2 k _; 1:smt().
        rewrite !get_unpack8; 1,2:smt(W64.to_uint_cmp). 
        move  => [#] -> -> /=.
        by rewrite and_mod // /max /= /loadW64 pack8bE;smt(W64.to_uint_cmp).
    +  move => Hl; have := (H1 _); 1:smt(). 
       move => [#] H2 H3 H4 H5 H6.
       case (k < to_uint len{2}).
       + move => *; have := H3 k _; 1:smt(W64.to_uint_cmp).
        rewrite !get_unpack8; smt(W64.to_uint_cmp).
       case (k = to_uint len{2}).
       + move => Heq *;move :  H5 H6; 1:smt(W64.to_uint_cmp).
       + move => *; have := H4 k _; 1:smt(W64.to_uint_cmp).
        rewrite !get_unpack8; 1,2: smt(W64.to_uint_cmp).
        by move => [#] -> -> /=.

    + move => *;rewrite set_eqiE 1,2:/# /= (_: k %% 8 = k - 8) 1: /#.
      case (8 <= to_uint len{2}).
      + move => Hl; have := (H0 Hl) => [#] H2 H3 H4 H5 H6.
        have := H4 (k-8) _; 1:smt(W64.to_uint_cmp).
        by rewrite !get_unpack8 1,2:/# => [#] -> -> /=.
      move => *. have := (H1 _); 1: smt().
      move => [#] H2 H3 H4 H5 H6.
      move : (H2 (k-8) _); 1: smt().
      by rewrite !get_unpack8 1,2:/# => [#] -> -> /=.
    rewrite initiE /=; 1:smt(W64.to_uint_cmp).
    case (8 <= to_uint len{2}).
    + move => Hl;rewrite set_eqiE /=; 1,2:smt(W64.to_uint_cmp).
      have := (H0 Hl) => [#] H2 H3 H4 H5 H6.
      move :  H5 H6; rewrite /= (_: to_uint len{2} %% 8 =  to_uint len{2} - 8) 1: /#. 
      by rewrite !get_unpack8 1,2:/# /= => [#] -> -> /=.
    + move => Hl;rewrite set_neqiE /=; 1,2:smt(W64.to_uint_cmp).
      rewrite set_eqiE /=; 1,2:smt(W64.to_uint_cmp).
      have := (H1 _);1:smt(W64.to_uint_cmp).
      move => [#] H2 H3 H4 H5 H6.
      move :  H5 H6; rewrite !modz_small;1:smt(W64.to_uint_cmp).
      rewrite !get_unpack8 /=;1,2:smt(W64.to_uint_cmp).  
      by move => -> -> /=.
  seq 0 9 : (#pre /\ 
    (forall k, 0<=k<to_uint len{2} => (WArray16.init64 (fun (i1 : int) => s{2}.[i1])).[k] = loadW8 Glob.mem{1} (to_uint in_0{2} + k)) /\ 
    (forall k, to_uint len{2} < k < 16 => (WArray16.init64 (fun (i1 : int) => s{2}.[i1])).[k] = W8.zero) /\ 
    (WArray16.init64 (fun (i1 : int) => s{2}.[i1])).[to_uint len{2}] = W8.one); last first.
  + auto => /> &1 &2  [#] H H0 H1 H2 H3 H4 H5 H6 H7 H8 H9.
    rewrite tP => i ib.
    rewrite -(W8u8.unpack8K v{1}.[i]) -(W8u8.unpack8K s{2}.[i]).
    have : unpack8 v{1}.[i] = unpack8 s{2}.[i]; last 
      by move => ->; rewrite wordP => k kbl; rewrite !pack8wE //=.
    case (i = 0).
    + move => ->;rewrite packP => k kb.
      case (0 <= k < to_uint len{2}).
      + move => kkb; move : (H4 k kkb) (H7 k kkb); rewrite !initiE 1,2:/# /=.
        by rewrite !unpack8E // !initiE //= /#. 
      case (k = to_uint len{2} /\ to_uint len{2} < 8); first by 
        by move => [#] Heq Hl; move : H6 H9;rewrite Heq !unpack8E // !initiE //=;smt(W64.to_uint_cmp). 
      move => *; move : (H5 k _) (H8 k _); 1..3:smt(W64.to_uint_cmp). 
      by rewrite !unpack8E // !initiE //=;smt(W64.to_uint_cmp). 
    move => *; have -> : i = 1; 1: by smt().
    rewrite packP => k kb.
    case ((k+8) < to_uint len{2}).
    + move => kkb; move : (H4 (k+8) _) (H7 (k+8) _); 1..3:smt(). 
      rewrite !initiE 1,2:/# /=.
      by rewrite !unpack8E // !initiE //= /#. 
      case (k + 8 = to_uint len{2} /\ 8 <= to_uint len{2}); first by  
        move => Heq ?; move : H6 H9;rewrite -Heq !unpack8E // !initiE /=; smt(W64.to_uint_cmp).       

    move => *; move : (H5 (k+8) _) (H8 (k+8) _); 1..3: by case(to_uint len{2} < 8); smt(W64.to_uint_cmp).
    by rewrite !unpack8E // !initiE //=;smt(W64.to_uint_cmp).

conseq />; 1: smt().
seq 0 4 : (#[/1,2]post /\ to_uint len{2} < 16 /\ to_uint j{2} = to_uint len{2}); last first.
+ auto => /> &2  H H0 Hl Hj; do split.
  + move => k kbl kbh.
    rewrite -(H k _) // !initiE //=; 1..2: smt(W64.to_uint_cmp).
    rewrite !initiE //=; 1: smt(W64.to_uint_cmp).
    rewrite get64E /= -(W8u8.unpack8K s{2}.[k %/ 8]).
    have Hkk : forall kk, (0 <= kk < 8 /\ 8*(k %/ 8) + kk <> to_uint len{2}) =>  
       (W8u8.Pack.init(fun (j0 : int) => (set8 ((init64 ("_.[_]" s{2})))%WArray16 (to_uint j{2}) W8.one).[8 * (k %/ 8) + j0])).[kk]  =
       (unpack8 s{2}.[k %/ 8]).[kk]; last first. 
    + rewrite !unpack8E !pack8bE 1..2:/# !initiE 1,2:/# /= -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
      rewrite ifF /=; 1: smt(W64.to_uint_cmp).
      by rewrite /get8 initiE //=; smt(W64.to_uint_cmp).
    move => kk kkb; rewrite !unpack8E !initiE 1,2:/# /= -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
    rewrite ifF /=; 1: smt(W64.to_uint_cmp).
    by rewrite /get8 initiE //=; smt(W64.to_uint_cmp).
  + move => k kbl kbh.
    rewrite -(H0 k _) // !initiE //=; 1..2: smt(W64.to_uint_cmp).
    rewrite !initiE //=; 1: smt(W64.to_uint_cmp).
    rewrite get64E /= -(W8u8.unpack8K s{2}.[k %/ 8]).
    have Hkk : forall kk, (0 <= kk < 8 /\ 8*(k %/ 8) + kk <> to_uint len{2}) =>  
       (W8u8.Pack.init(fun (j0 : int) => (set8 ((init64 ("_.[_]" s{2})))%WArray16 (to_uint j{2}) W8.one).[8 * (k %/ 8) + j0])).[kk]  =
       (unpack8 s{2}.[k %/ 8]).[kk]; last first. 
    + rewrite !unpack8E !pack8bE 1..2:/# !initiE 1,2:/# /= -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
      rewrite ifF /=; 1: smt(W64.to_uint_cmp).
      by rewrite /get8 initiE //=; smt(W64.to_uint_cmp).
    move => kk kkb; rewrite !unpack8E !initiE 1,2:/# /= -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
    rewrite ifF /=; 1: smt(W64.to_uint_cmp).
    by rewrite /get8 initiE //=; smt(W64.to_uint_cmp).
  rewrite initiE /=; 1: smt(W64.to_uint_cmp).
  rewrite initiE /=; 1: smt(W64.to_uint_cmp).
  rewrite get64E /= pack8bE; 1: smt(W64.to_uint_cmp). 
  rewrite initiE /=; 1: smt(W64.to_uint_cmp).
  rewrite -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
  by rewrite ifT /=; 1: smt(W64.to_uint_cmp).

(********)
(********)

while {2}  
  (to_uint in_0{2} <= to_uint in_0{2} + 16 /\ to_uint in_0{2} + 16 < 18446744073709551616 /\
   ((forall (k : int),
      0 <= k => k < to_uint j{2} => ((init64 ("_.[_]" s{2})))%WArray16.[k] = loadW8 Glob.mem{2} (to_uint in_0{2} + k)) /\
   forall (k : int), to_uint j{2} < k => k < 16 => ((init64 ("_.[_]" s{2})))%WArray16.[k] = W8.zero) /\
  to_uint len{2} < 16 /\ to_uint j{2} <= to_uint len{2}) (16 - to_uint j{2}); last first. 
  + auto => /> &1 &2 ????????; do split; 1,3..: smt(W64.to_uint_cmp). 
    move => k kbl kbh; rewrite initiE 1:/# /=.
    case (k < 8). 
    + by move => *; rewrite set_neqiE 1,2:/# set_eqiE 1,2:/# get_zero. 
    by move => *; rewrite set_eqiE 1,2:/# get_zero. 

move => *.
auto => /> &1 &2 H H0 H1 H2 H3; rewrite ultE /= !to_uintD_small /=. smt(W64.to_uint_cmp).  smt(W64.to_uint_cmp). 
move => *;do split; last 2 by smt().
+ move =>  k kbl kbh. 
  case (k = to_uint j{1}); last first.
  + move => *; rewrite initiE /=;1: smt(W64.to_uint_cmp).
    rewrite initiE /=;1: smt(W64.to_uint_cmp).
    rewrite get64E /= pack8bE; 1: smt(W64.to_uint_cmp). 
    rewrite initiE /=; 1: smt(W64.to_uint_cmp).
    rewrite -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
    rewrite ifF /=; 1: smt(W64.to_uint_cmp).
    by rewrite -H0 1,2:/# -/WArray16.get8 /#.
  move => ->.    
  rewrite initiE /=;1: smt(W64.to_uint_cmp).
  rewrite initiE /=;1: smt(W64.to_uint_cmp).
  rewrite get64E /= pack8bE; 1: smt(W64.to_uint_cmp). 
  rewrite initiE /=; 1: smt(W64.to_uint_cmp).
  rewrite -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
  by rewrite ifT /=; 1: smt(W64.to_uint_cmp).

+ move =>  k kbl kbh. 
  have ? : (k <> to_uint j{1}) by smt().
  move => *; rewrite initiE /=;1: smt(W64.to_uint_cmp).
  rewrite initiE /=;1: smt(W64.to_uint_cmp).
  rewrite get64E /= pack8bE; 1: smt(W64.to_uint_cmp). 
  rewrite initiE /=; 1: smt(W64.to_uint_cmp).
  rewrite -/WArray16.get8 get_set8E /=; 1:smt(W64.to_uint_cmp).
  rewrite ifF /=; 1: smt(W64.to_uint_cmp).
  by rewrite -(H1 k) 1,2:/# -/WArray16.get8 /#.
  
qed.

equiv onetimeauth_s_r_equiv :
    M.__poly1305_r_avx2 ~ Poly1305_savx2.M.poly1305_avx2 :
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    ={Glob.mem} /\ ={arg} ==> ={res,Glob.mem}.
proc => /=.
seq 7 1 : #pre; 1: by auto.
if{2}.
rcondf{1} 1.
+ move => &2; auto => />; rewrite ultE uleE => /> /#.
  inline {2} 1. inline {2} 9.
  inline {1} 1. inline {1} 9.
  wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}); 1: by sim.
  conseq />.
  seq 15 15 : (#post /\ ={Glob.mem,in_01,inlen1} /\ r1{1} = r0{2} /\ (0 < to_uint inlen1{2} => good_ptr (to_uint in_01{2}) 16) /\ to_uint inlen1{2} < 16); last first.
  + if; first by auto.
    wp;call(_: ={Glob.mem}); 1: by sim.
    conseq />.
    call load_last;  auto => />; smt(W64.to_uint_cmp).
    by auto => />.
  wp;call update.
  wp;call(_: ={Glob.mem}); 1: by sim.
  by auto => />.  

rcondt{1} 1.
move => &2; auto => />; rewrite ultE uleE => /> /#.
inline {2} 1. inline {2} 15.
inline {1} 5. 
wp;call(_: ={Glob.mem}); 1: by sim.
wp;call(_: ={Glob.mem}); 1: by sim.
wp;call(_: ={Glob.mem}); 1: by sim.
conseq />.
seq 11 21 : (#post /\ ={Glob.mem} /\ inlen0{1} = inlen1{2} /\ in_00{1} = in_01{2} /\ r0{1} = r0{2}  /\ (0<to_uint inlen1{2} => good_ptr (to_uint in_01{2}) 16) /\ to_uint inlen1{2} < 16); last first.
+ if; first by auto.
  wp;call(_: ={Glob.mem}); 1: by sim.
  conseq />. 
    call load_last;  auto => />; smt(W64.to_uint_cmp).
  by auto => />.

wp;call update.
wp;call update_avx2.

wp;call(_: ={Glob.mem}).
+ wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}); 1: by sim.
  do 2!(unroll for {1} ^while).
  do 2!(unroll for {2} ^while).
  inline {1} M.__unpack_avx2.
  conseq />.
  seq 35 31 : (#pre /\ ={rt,r1234,r1234x5,r4444,r4444x5,i}); 1: by auto.
  seq 2 2: #pre. 
  + call(_:true); 1:  by sim. 
    by auto => />.
  seq 24 20 : #pre; 1: by  auto. 
  seq 2 2: #pre. 
  + call(_:true); 1:  by sim. 
    by auto => />.
  seq 24 20 : #pre; 1: by  auto. 
  seq 2 2: #pre. 
  + call(_:true); 1:  by sim. 
    by auto => />.
  by auto => />.

wp; call(_: ={Glob.mem}); 1: by sim.
auto => /> &1??.
rewrite ultE /= => ?; do split; 1: by smt(). 
move => ? rr ?.
case ( 0 < to_uint rr.`2); 1: by smt().
move => *. 
have : (to_uint rr.`2) = 0 by smt(W64.to_uint_cmp).
move => Hrr.
rewrite /next_multiple /= Hrr /=.
by smt(W64.to_uint_cmp pow2_64).
qed.

(* Equivalence to memory based *)

equiv onetimeauth_s_equiv mem outt :
    Poly1305_savx2.M.poly1305_avx2 ~ M.__poly1305_avx2 :
    Glob.mem{1} = mem /\ ={Glob.mem} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    good_ptr (to_uint out{2}) 16 /\ out{2} = outt /\
    ={in_0,inlen,k} ==> 
     Glob.mem{1} = mem /\
     Glob.mem{2} = storeW128 mem (W64.to_uint outt)
       (W2u64.pack2 [res{1}.[0];res{1}.[1]]).
proof. 
transitivity M.__poly1305_r_avx2 
    (={Glob.mem, in_0, inlen, k} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1})
      ==> ={res,Glob.mem})
    (Glob.mem{1} = mem /\ ={Glob.mem} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    good_ptr (to_uint out{2}) 16 /\ out{2} = outt /\
    ={in_0,inlen,k} ==> 
     Glob.mem{1} = mem /\
     Glob.mem{2} = storeW128 mem (W64.to_uint outt)
       (W2u64.pack2 [res{1}.[0];res{1}.[1]])).
+ move => /> &1 &2 => *; rewrite /inv_ptr /=. 
  exists mem arg{1} => //=; do split; smt(W64.to_uint_cmp).
+ smt().
+ by symmetry;proc*;call onetimeauth_s_r_equiv; auto => />.
by proc*; call (onetimeauth_s_r_mem_equiv mem outt); auto => />.
qed.
