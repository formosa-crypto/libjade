require import AllCore List Int IntDiv Real.
require import Array2 Array3 Array4 Array5.
require import WArray16 WArray24 WArray64 WArray96 WArray128 WArray160. 
from Jasmin require import JModel.
require import Zp W64limbs EClib Rep3Limb Rep5Limb.

import Zp.
import Array5.
import Array4.
import Array3.
import Array2.

(* Third equivalence proof: connects to pre-vectorized code by
   instantiating Zp operations with low-level code. Functional
   correctness of low-level ops is proved in *_corr files. *)

module Mhop3 = {

  module Rep3Impl = Mrep3

  module Rep5Impl = Mrep5

  proc load_1x_Rep5(m:W64.t) : Rep5 = {
    var t : W64.t Array2.t;
    var x : Rep5;
    t <- witness<:W64.t Array2.t>.[0 <- loadW64 Glob.mem (to_uint m)];
    t.[1] <- loadW64 Glob.mem (to_uint (m + W64.of_int 8));
    x <@ Rep5Impl.unpack2_bit128(t);
    return x;
  }

   (* Rep5 4-lane implementations *)

   proc precompute_Rep5(r : W64.t Array3.t) : Rep5 * Rep5 * Rep5 * Rep5 * 
                    W64.t Array4.t * W64.t Array4.t * W64.t Array4.t * W64.t Array4.t = {
    var rpow1,rpow2,rpow3,rpow4 : Rep5;
    var rpow1x5,rpow2x5,rpow3x5,rpow4x5 : W64.t Array4.t;
    var aux: int;
    
    var i:int;
    var rt:W64.t Array3.t;

    rt <- witness;
    i <- 0;
    while (i < 2) {
      rt.[i] <- r.[i];
      i <- i + 1;
    }
    rt.[2] <- (W64.of_int 0);
    rpow1 <@ Rep5Impl.unpack(rt);
    rt <@ Mrep3.mulmod (rt,r);
    rpow2 <@ Rep5Impl.unpack(rt);
    rt <@ Mrep3.mulmod (rt,r);
    rpow3 <@ Rep5Impl.unpack(rt);
    rt <@ Mrep3.mulmod (rt,r);
    rpow4 <@ Rep5Impl.unpack(rt);
    rpow1x5 <@ Rep5Impl.x5(rpow1);
    rpow2x5 <@ Rep5Impl.x5(rpow2);
    rpow3x5 <@ Rep5Impl.x5(rpow3);
    rpow4x5 <@ Rep5Impl.x5(rpow4);
    return (rpow1,rpow2,rpow3,rpow4,rpow1x5,rpow2x5,rpow3x5,rpow4x5);
  }
  
  proc load_4x_Rep5(m:W64.t) : Rep5 * Rep5 * Rep5 * Rep5 * W64.t = {
    var x1,x2,x3,x4 : Rep5;

    x1 <@ load_1x_Rep5(m);
    m <- m + W64.of_int 16;
    x2 <@ load_1x_Rep5(m);
    m <- m + W64.of_int 16;
    x3 <@ load_1x_Rep5(m);
    m <- m + W64.of_int 16;
    x4 <@ load_1x_Rep5(m);
    m <- m + W64.of_int 16;
    return  (x1,x2,x3,x4,m);
  }

  proc add_mulmod_x4_Rep5(h1 : Rep5,h2 : Rep5,h3 : Rep5,h4 : Rep5,
                       x1 : Rep5,x2 : Rep5,x3 : Rep5,x4 : Rep5,
                       rpow4 : Rep5, rpow4x5 : W64.t Array4.t) : Rep5 * Rep5 * Rep5 * Rep5 = {
    h1 <@ Rep5Impl.add(h1, x1);
    h2 <@ Rep5Impl.add(h2, x2);
    h3 <@ Rep5Impl.add(h3, x3);
    h4 <@ Rep5Impl.add(h4, x4);
    h1 <@ Rep5Impl.mulmod(h1, rpow4, rpow4x5);
    h2 <@ Rep5Impl.mulmod(h2, rpow4, rpow4x5);
    h3 <@ Rep5Impl.mulmod(h3, rpow4, rpow4x5);
    h4 <@ Rep5Impl.mulmod(h4, rpow4, rpow4x5);
    h1 <@ Rep5Impl.carry_reduce(h1);
    h2 <@ Rep5Impl.carry_reduce(h2);
    h3 <@ Rep5Impl.carry_reduce(h3);
    h4 <@ Rep5Impl.carry_reduce(h4);

    return (h1,h2,h3,h4);
  }
  proc add_mulmod_x4_final_Rep5(h1 : Rep5,h2 : Rep5,h3 : Rep5,h4 : Rep5,
                                x1 : Rep5,x2 : Rep5,x3 : Rep5,x4 : Rep5,
                                rpow1 : Rep5, rpow2 : Rep5, rpow3 : Rep5, rpow4 : Rep5, 
                                rpow1x5 : W64.t Array4.t, rpow2x5 : W64.t Array4.t,
                                rpow3x5 : W64.t Array4.t, rpow4x5 : W64.t Array4.t) 
       : Rep5 * Rep5 * Rep5 * Rep5 = {
    h1 <@ Rep5Impl.add(h1, x1);
    h2 <@ Rep5Impl.add(h2, x2);
    h3 <@ Rep5Impl.add(h3, x3);
    h4 <@ Rep5Impl.add(h4, x4);
    h1 <@ Rep5Impl.mulmod(h1, rpow4, rpow4x5);
    h2 <@ Rep5Impl.mulmod(h2, rpow3, rpow3x5);
    h3 <@ Rep5Impl.mulmod(h3, rpow2, rpow2x5);
    h4 <@ Rep5Impl.mulmod(h4, rpow1, rpow1x5);
    h1 <@ Rep5Impl.carry_reduce(h1);
    h2 <@ Rep5Impl.carry_reduce(h2);
    h3 <@ Rep5Impl.carry_reduce(h3);
    h4 <@ Rep5Impl.carry_reduce(h4);
    return (h1,h2,h3,h4);
  }

  proc poly1305_long  (in_0:W64.t, inlen:W64.t, k:W64.t) : W64.t Array2.t = {
    var r : W64.t Array3.t;
    var h : Rep3;
    var x1,x2,x3,x4,h1,h2,h3,h4,rpow1,rpow2,rpow3,rpow4:Rep5;
    var rpow1x5,rpow2x5,rpow3x5,rpow4x5 : W64.t Array4.t;
    var s, h2r3:W64.t Array2.t;
    var rr;

    r <@ Rep3Impl.clamp (k);
    h1 <@ Rep5Impl.zero();
    h2 <@ Rep5Impl.zero();
    h3 <@ Rep5Impl.zero();
    h4 <@ Rep5Impl.zero();
    (rpow1,rpow2,rpow3,rpow4,rpow1x5,rpow2x5,rpow3x5,rpow4x5) <@ precompute_Rep5(r);
 
    (x1,x2,x3,x4,in_0) <@ load_4x_Rep5(in_0);
    while (((W64.of_int 128) \ule inlen)) {
      (h1,h2,h3,h4) <@ add_mulmod_x4_Rep5(h1, h2, h3, h4, x1, x2, x3, x4, rpow4, rpow4x5);
      (x1,x2,x3,x4,in_0) <@ load_4x_Rep5(in_0);
      inlen <- (inlen - (W64.of_int 64));
    }
    inlen <- (inlen - (W64.of_int 64));
    (h1,h2,h3,h4) <@ add_mulmod_x4_final_Rep5(h1, h2, h3, h4, x1, x2, x3, x4,
                                              rpow1, rpow2, rpow3, rpow4,
                                              rpow1x5, rpow2x5, rpow3x5, rpow4x5);
    h <@ Rep5Impl.add_pack(h1,h2,h3,h4);

    (in_0, inlen, h) <@ Rep3Impl.update(in_0, inlen, h, r);
    k <- (k + (W64.of_int 16));
    rr <@ Rep3Impl.finish(in_0, inlen, k, h, r);
    return rr;
 }

 proc poly1305 (in_0:W64.t, inlen:W64.t, k:W64.t) : W64.t Array2.t = {
    var rr <- witness;
    if ((inlen \ult (W64.of_int 256))) {
      rr <@ Rep3Impl.poly1305 (in_0, inlen, k);
    } else {
      rr <@ poly1305_long (in_0, inlen, k);
    }
    return rr;
 }
}.

(******************************************************************************************

                                    Rep3Impl Equiv

 ******************************************************************************************)

require import Poly1305_spec Poly1305_hop2.

equiv update_eq :
 Mhop2.poly1305_update ~ Mhop3.Rep3Impl.update:
   ={Glob.mem, in_0, inlen} /\ h{1} = repres3 h{2} /\ ubW64 4 h{2}.[2] /\
   r{1} = repres3r r{2} /\ Rep3r_ok r{2} /\ good_ptr (to_uint in_0{2}) (to_uint inlen{2})
 ==>
   ={Glob.mem} /\ res{1}.`1 = res{2}.`1 /\ res{1}.`2 = res{2}.`2 /\
   res{1}.`3 = repres3 res{2}.`3 /\ ubW64 4 res{2}.`3.[2] /\
   to_uint res{2}.`2 < 16 /\ to_uint res{2}.`1 + to_uint res{2}.`2 < W64.modulus.
proof.
proc => /=.
while (#pre); last first. 
auto => /> &1 ???????? h in0 inlen; rewrite uleE /= /#.
seq 2 1: (#[/1:4,6:]pre /\ ubW64 6 h{2}.[2]).
 exists* Glob.mem{2}, h{2}, in_0{2}; elim* => mem hh inp.
 call{2} (load_add_spec mem hh inp).
 auto => /> &1 8?; rewrite uleE /= => *; do split;  smt().
wp; exists* h{2}, r{2}; elim* => hh rr.
call{2} (Rep3Limb.mulmod_spec hh rr).
auto => /> &1 7?; rewrite uleE /= !to_uintD /= to_uintN /= => *; do split; smt(W64.to_uint_cmp).
qed.

equiv finish_eq :
 Mhop2.poly1305_finish ~ Mhop3.Rep3Impl.finish:
   ={Glob.mem, in_0, inlen, k} /\ h{1} = repres3 h{2} /\ ubW64 4 h{2}.[2] /\
   r{1} = repres3r r{2} /\ Rep3r_ok r{2} /\ to_uint inlen{2} < 16 /\
   good_ptr (to_uint in_0{2}) (to_uint inlen{2}) /\ good_ptr (to_uint k{2}) 16 
 ==>
   ={Glob.mem,res}.
proof.
proc => /=.
seq 2 4: (#pre /\ h_int{1} = valRep2 h2{2}).
 seq 1 3: (#pre).
  sp 0 2; if => //=.
  seq 2 1: (#[/1:7,9:]pre /\ ubW64 6 h{2}.[2]).
   exists* Glob.mem{2}, h{2}, in_0{2}, inlen{2}; elim* => mem hh inp iinlen.
   call{2} (load_last_add_spec mem hh inp iinlen).
   auto => /> &1;rewrite ultE => *; smt().
  wp; exists* h{2}, r{2}; elim* => hh rr.
  call{2} (Rep3Limb.mulmod_spec hh rr). 
  auto => /> /#. 

 exists* h{2}; elim* => hh.
 by call{2} (freeze_spec hh); wp; skip =>  /> *; smt().
seq 1 1: (#pre /\ s{1}=valRep2 s{2}).
 exists* Glob.mem{2}, k{2}; elim* => mem kk.
 wp; call{2} (load2_spec mem kk); skip => /> *; smt().
seq 1 1: (#pre).
 exists* h2{2}, s{2}; elim* => hh ss.
 wp; call{2} (add2_spec hh ss); skip  => /> *; smt().
auto => /> *.
rewrite tP => i ib.
rewrite initiE //=.
case (i = 0); 1: by move => -> /=; rewrite to_uint_eq of_uintK /=; smt(W64.to_uint_cmp pow2_64). 
case (i = 1); 1: by move => -> /=; rewrite to_uint_eq of_uintK /=; smt(W64.to_uint_cmp pow2_64). 
by smt().
qed.

equiv poly1305_short_eq :
 Mhop2.poly1305_short ~ Mhop3.Rep3Impl.poly1305:
   ={Glob.mem, in_0, inlen, k} /\
   inv_ptr (to_uint k{2}) (to_uint in_0{2}) (to_uint inlen{2})
 ==>
   ={res,Glob.mem}.
proof.
proc => /=.
call finish_eq.
call update_eq.
inline Poly1305_hop1.Mhop1.poly1305_setup.
inline Poly1305_savx2.M.poly1305_ref3_setup.
exists* Glob.mem{2}, k{2}; elim* => mem kk.
unroll for {2} 7.
simplify.
wp; call{2} (clamp_spec mem kk); wp; skip; rewrite /inv_ptr; auto => /> *;split; 1:smt().
move => *; do split.
+ by rewrite repres3E.
+ smt().
move => *;rewrite to_uintD_small of_uintK modz_small //.
smt(W64.to_uint_cmp). 
qed.

(******************************************************************************************

                                    4 lanes * Rep5Impl specs

 ******************************************************************************************)

lemma precompute_Rep5_spec_h (rr : W64.t Array3.t) :
  hoare [ Mhop3.precompute_Rep5 : r = rr /\ Rep3r_ok rr ==>
           let rzp = repres3r rr in
           bRep5 28 res.`1 /\
           bRep5 28 res.`2 /\
           bRep5 28 res.`3 /\
           bRep5 28 res.`4 /\
           repres5 res.`1 = rzp /\
           repres5 res.`2 = rzp*rzp /\
           repres5 res.`3 = rzp*rzp*rzp /\
           repres5 res.`4 = rzp*rzp*rzp*rzp /\
           res.`5 = mul5Rep54 res.`1 /\ 
           res.`6 = mul5Rep54 res.`2 /\
           res.`7 = mul5Rep54 res.`3 /\
           res.`8 = mul5Rep54 res.`4].
proof.
proc.
unroll for 3. 
inline Mhop3.Rep5Impl.x5; wp.
seq 7 : (#pre /\ repres3 rt = repres3r rr /\ ubW64 4 rt.[2]) => //=.
 auto => /> *.  rewrite repres3E /valRep3 /valRep3r.
  by rewrite  /val_digits /to_list /mkseq -iotaredE /=  repres3rE /= /#. 
seq 2 : (#{/~rt}pre /\ repres5 rpow1 = repres3r rr /\ bRep5 28 rpow1 /\
              repres3 rt = repres3r rr * repres3r rr /\ ubW64 4 rt.[2]) => //=.
 exists* rt; elim* => rtt.
 call (Rep3Limb.mulmod_spec_h rtt rr).
 call (unpack_spec_h rtt).
 auto => />; smt().
seq 2 : (#{/~rt}pre /\ repres5 rpow2 = repres3r rr * repres3r rr /\ bRep5 28 rpow2 /\
              repres3 rt = repres3r rr * repres3r rr * repres3r rr /\ ubW64 4 rt.[2]) => //=.
 exists* rt; elim* => rtt.
 call (Rep3Limb.mulmod_spec_h rtt rr).
 call (unpack_spec_h rtt).
 auto => />; smt().
seq 2 : (#{/~rt}pre /\ repres5 rpow3 = repres3r rr * repres3r rr * repres3r rr /\ bRep5 28 rpow3 /\
              repres3 rt = repres3r rr * repres3r rr * repres3r rr * repres3r rr /\ ubW64 4 rt.[2]) => //=.
 exists* rt; elim* => rtt.
 call (Rep3Limb.mulmod_spec_h rtt rr).
 call (unpack_spec_h rtt).
 auto => />; smt().
exists* rt; elim* => rtt.
call (unpack_spec_h rtt).
skip; rewrite /mul5Rep54 /=; auto => /> *; do split; 
[ 1: smt() 
| 2..: by rewrite -Array4.ext_eq_all /all_eq => /> *; do split; ring ].
qed.

lemma precompute_Rep5_spec_ll : islossless Mhop3.precompute_Rep5.
proof. by proc; unroll for 3; islossless. qed.

lemma precompute_Rep5_spec (rr : W64.t Array3.t) :
  phoare [ Mhop3.precompute_Rep5 : r = rr /\ Rep3r_ok rr ==>
           let rzp = repres3r rr in
           bRep5 28 res.`1 /\
           bRep5 28 res.`2 /\
           bRep5 28 res.`3 /\
           bRep5 28 res.`4 /\
           repres5 res.`1 = rzp /\
           repres5 res.`2 = rzp*rzp /\
           repres5 res.`3 = rzp*rzp*rzp /\
           repres5 res.`4 = rzp*rzp*rzp*rzp /\
           res.`5 = mul5Rep54 res.`1 /\ 
           res.`6 = mul5Rep54 res.`2 /\
           res.`7 = mul5Rep54 res.`3 /\
           res.`8 = mul5Rep54 res.`4] = 1%r.
proof. by conseq precompute_Rep5_spec_ll (precompute_Rep5_spec_h rr). qed.

lemma load_1x_Rep5_spec_h mem ptr: 
  hoare [ Mhop3.load_1x_Rep5 :
            m = ptr /\ Glob.mem = mem /\ good_ptr (to_uint ptr) 16
          ==>
            bRep5 26 res /\ 
            repres5 res = load_block mem ptr /\
            Glob.mem = mem ].
proof.
proc.
sp; exists* t; elim* => tt.
call (unpack2_bit128_spec_h tt).
skip => ?[<-[->[->[->?]]]]; split; first done.
move=> X ?[H0?]; clear X; split; first done.
split; last done.
rewrite H0 /load_block /load_lblock repres2E /= -inzpD; congr.
rewrite -(W16u8.Pack.init_ext (fun i => mem.[to_uint ptr + i])) 1:/#.
rewrite to_uintD_small of_uintK modz_small //; first smt(W64.to_uint_cmp pow2_64).
rewrite !load8u8' /val_digits /mkseq /=.
rewrite !(to_uint_unpack8u8 (W8u8.pack8 _)) /=.
rewrite (to_uint_unpack16u8 (W16u8.pack16_t _)) /=.
by rewrite /val_digits -iotaredE /=; ring.
qed.

lemma load4x_spec_h mem ptr: 
  hoare [ Mhop3.load_4x_Rep5 :
           m = ptr /\ Glob.mem = mem /\ good_ptr (to_uint ptr) 64
          ==>
           bRep5 26 res.`1 /\
           bRep5 26 res.`2 /\
           bRep5 26 res.`3 /\
           bRep5 26 res.`4 /\
           repres5 res.`1 = load_block mem ptr /\
           repres5 res.`2 = load_block mem (ptr + W64.of_int 16) /\
           repres5 res.`3 = load_block mem (ptr + W64.of_int 32) /\
           repres5 res.`4 = load_block mem (ptr + W64.of_int 48) /\
           res.`5 = ptr + W64.of_int 64 /\
           Glob.mem = mem ].
proof.
proc; simplify.
wp; ecall (load_1x_Rep5_spec_h mem (ptr + (of_int 48)%W64)).
wp; ecall (load_1x_Rep5_spec_h mem (ptr + (of_int 32)%W64)).
wp; ecall (load_1x_Rep5_spec_h mem (ptr + (of_int 16)%W64)).
wp; ecall (load_1x_Rep5_spec_h mem ptr).
skip; auto => /> &1 *; do split; 1..2: smt().
move => *; do split; 1:smt().
+ rewrite to_uintD /= /=; smt(W64.to_uint_cmp).
move => *; do split; 1:smt().
+ rewrite to_uintD /= /=; smt(W64.to_uint_cmp).
move => *; do split; 1:smt().
rewrite to_uintD /= /=; smt(W64.to_uint_cmp).
qed.

lemma load4x_spec_ll: islossless Mhop3.load_4x_Rep5 by islossless.

lemma load4x_spec mem ptr: 
  phoare [ Mhop3.load_4x_Rep5 :
           m = ptr /\ Glob.mem = mem /\ good_ptr (to_uint ptr) 64
          ==>
           bRep5 26 res.`1 /\
           bRep5 26 res.`2 /\
           bRep5 26 res.`3 /\
           bRep5 26 res.`4 /\
           repres5 res.`1 = load_block mem ptr /\
           repres5 res.`2 = load_block mem (ptr + W64.of_int 16) /\
           repres5 res.`3 = load_block mem (ptr + W64.of_int 32) /\
           repres5 res.`4 = load_block mem (ptr + W64.of_int 48) /\
           res.`5 = ptr + W64.of_int 64 /\
           Glob.mem = mem ] = 1%r.
proof. by conseq load4x_spec_ll (load4x_spec_h mem ptr). qed.

lemma add_mulmod_x4_Rep5_spec_h hh1 hh2 hh3 hh4 xx1 xx2 xx3 xx4 rrpow4:
  hoare [ Mhop3.add_mulmod_x4_Rep5 : 
             bRep5 27 hh1 /\ bRep5 27 hh2 /\ 
             bRep5 27 hh3 /\ bRep5 27 hh4 /\
             bRep5 26 xx1 /\ bRep5 26 xx2 /\ 
             bRep5 26 xx3 /\ bRep5 26 xx4 /\
              bRep5 28 rrpow4 /\
             hh1 = h1 /\ hh2 = h2 /\  hh3 = h3 /\  hh4 = h4 /\
             xx1 = x1 /\ xx2 = x2 /\  xx3 = x3 /\  xx4 = x4 /\
             rrpow4 = rpow4 /\ rpow4x5 = mul5Rep54 rrpow4
             ==>
             bRep5 27 res.`1 /\ bRep5 27 res.`2 /\ 
             bRep5 27 res.`3 /\ bRep5 27 res.`4 /\
             repres5 res.`1 = ((repres5 hh1) + (repres5 xx1)) * (repres5 rrpow4) /\ 
             repres5 res.`2 = ((repres5 hh2) + (repres5 xx2)) * (repres5 rrpow4) /\
             repres5 res.`3 = ((repres5 hh3) + (repres5 xx3)) * (repres5 rrpow4) /\
             repres5 res.`4 = ((repres5 hh4) + (repres5 xx4)) * (repres5 rrpow4)].
proof.
have Hb: max 27 26 < 63 by done.
proc; simplify.
ecall (carry_reduce_spec_h h4).
ecall (carry_reduce_spec_h h3).
ecall (carry_reduce_spec_h h2).
ecall (carry_reduce_spec_h h1).
ecall (mulmod_spec_h h4 rpow4).
ecall (mulmod_spec_h h3 rpow4).
ecall (mulmod_spec_h h2 rpow4).
ecall (mulmod_spec_h h1 rpow4).
call (add_spec_h 27 26 hh4 xx4 Hb).
call (add_spec_h 27 26 hh3 xx3 Hb).
call (add_spec_h 27 26 hh2 xx2 Hb).
call (add_spec_h 27 26 hh1 xx1 Hb).
skip; rewrite /max /=; smt().
qed.

lemma add_mulmod_x4_Rep5_spec_ll: islossless Mhop3.add_mulmod_x4_Rep5 by islossless.

lemma add_mulmod_x4_Rep5_spec hh1 hh2 hh3 hh4 xx1 xx2 xx3 xx4 rrpow4:
  phoare [ Mhop3.add_mulmod_x4_Rep5 : 
             bRep5 27 hh1 /\ bRep5 27 hh2 /\ 
             bRep5 27 hh3 /\ bRep5 27 hh4 /\
             bRep5 26 xx1 /\ bRep5 26 xx2 /\ 
             bRep5 26 xx3 /\ bRep5 26 xx4 /\
              bRep5 28 rrpow4 /\
             hh1 = h1 /\ hh2 = h2 /\  hh3 = h3 /\  hh4 = h4 /\
             xx1 = x1 /\ xx2 = x2 /\  xx3 = x3 /\  xx4 = x4 /\
             rrpow4 = rpow4 /\ rpow4x5 = mul5Rep54 rrpow4
             ==>
             bRep5 27 res.`1 /\ bRep5 27 res.`2 /\ 
             bRep5 27 res.`3 /\ bRep5 27 res.`4 /\
             repres5 res.`1 = ((repres5 hh1) + (repres5 xx1)) * (repres5 rrpow4) /\ 
             repres5 res.`2 = ((repres5 hh2) + (repres5 xx2)) * (repres5 rrpow4) /\
             repres5 res.`3 = ((repres5 hh3) + (repres5 xx3)) * (repres5 rrpow4) /\
             repres5 res.`4 = ((repres5 hh4) + (repres5 xx4)) * (repres5 rrpow4)] = 1%r.
proof.
by conseq add_mulmod_x4_Rep5_spec_ll
          (add_mulmod_x4_Rep5_spec_h hh1 hh2 hh3 hh4 xx1 xx2 xx3 xx4 rrpow4).
qed.

lemma add_mulmod_x4_final_Rep5_spec_h hh1 hh2 hh3 hh4 xx1 xx2 xx3 xx4
      rrpow1 rrpow2 rrpow3 rrpow4:
  hoare [ Mhop3.add_mulmod_x4_final_Rep5 : 
             bRep5 27 hh1 /\ bRep5 27 hh2 /\ 
             bRep5 27 hh3 /\ bRep5 27 hh4 /\
             bRep5 26 xx1 /\ bRep5 26 xx2 /\ 
             bRep5 26 xx3 /\ bRep5 26 xx4 /\
             bRep5 28 rrpow1 /\ bRep5 28 rrpow2 /\
             bRep5 28 rrpow3 /\ bRep5 28 rrpow4 /\
             hh1 = h1 /\ hh2 = h2 /\  hh3 = h3 /\  hh4 = h4 /\
             xx1 = x1 /\ xx2 = x2 /\  xx3 = x3 /\  xx4 = x4 /\
             rrpow1 = rpow1 /\
             rrpow2 = rpow2 /\
             rrpow3 = rpow3 /\
             rrpow4 = rpow4 /\
             rpow1x5 = mul5Rep54 rrpow1 /\
             rpow2x5 = mul5Rep54 rrpow2 /\
             rpow3x5 = mul5Rep54 rrpow3 /\
             rpow4x5 = mul5Rep54 rrpow4 
             ==>
             bRep5 27 res.`1 /\ bRep5 27 res.`2 /\ 
             bRep5 27 res.`3 /\ bRep5 27 res.`4 /\
             repres5 res.`1 = ((repres5 hh1) + (repres5 xx1)) * (repres5 rrpow4) /\ 
             repres5 res.`2 = ((repres5 hh2) + (repres5 xx2)) * (repres5 rrpow3) /\
             repres5 res.`3 = ((repres5 hh3) + (repres5 xx3)) * (repres5 rrpow2) /\
             repres5 res.`4 = ((repres5 hh4) + (repres5 xx4)) * (repres5 rrpow1)].
proof.
have Hb: max 27 26 < 63 by done.
proc; simplify.
ecall (carry_reduce_spec_h h4).
ecall (carry_reduce_spec_h h3).
ecall (carry_reduce_spec_h h2).
ecall (carry_reduce_spec_h h1).
ecall (mulmod_spec_h h4 rrpow1).
ecall (mulmod_spec_h h3 rrpow2).
ecall (mulmod_spec_h h2 rrpow3).
ecall (mulmod_spec_h h1 rrpow4).
call (add_spec_h 27 26 hh4 xx4 Hb).
call (add_spec_h 27 26 hh3 xx3 Hb).
call (add_spec_h 27 26 hh2 xx2 Hb).
call (add_spec_h 27 26 hh1 xx1 Hb).
skip; rewrite /max /=; smt().
qed.

lemma add_mulmod_x4_final_Rep5_spec_ll: islossless Mhop3.add_mulmod_x4_final_Rep5.
proc; by islossless. qed.

lemma add_mulmod_x4_final_Rep5_spec hh1 hh2 hh3 hh4 xx1 xx2 xx3 xx4
      rrpow1 rrpow2 rrpow3 rrpow4:
 phoare [ Mhop3.add_mulmod_x4_final_Rep5 : 
             bRep5 27 hh1 /\ bRep5 27 hh2 /\ 
             bRep5 27 hh3 /\ bRep5 27 hh4 /\
             bRep5 26 xx1 /\ bRep5 26 xx2 /\ 
             bRep5 26 xx3 /\ bRep5 26 xx4 /\
             bRep5 28 rrpow1 /\ bRep5 28 rrpow2 /\
             bRep5 28 rrpow3 /\ bRep5 28 rrpow4 /\
             hh1 = h1 /\ hh2 = h2 /\  hh3 = h3 /\  hh4 = h4 /\
             xx1 = x1 /\ xx2 = x2 /\  xx3 = x3 /\  xx4 = x4 /\
             rrpow1 = rpow1 /\
             rrpow2 = rpow2 /\
             rrpow3 = rpow3 /\
             rrpow4 = rpow4 /\
             rpow1x5 = mul5Rep54 rrpow1 /\
             rpow2x5 = mul5Rep54 rrpow2 /\
             rpow3x5 = mul5Rep54 rrpow3 /\
             rpow4x5 = mul5Rep54 rrpow4 
           ==>
             bRep5 27 res.`1 /\ bRep5 27 res.`2 /\ 
             bRep5 27 res.`3 /\ bRep5 27 res.`4 /\
             repres5 res.`1 = ((repres5 hh1) + (repres5 xx1)) * (repres5 rrpow4) /\ 
             repres5 res.`2 = ((repres5 hh2) + (repres5 xx2)) * (repres5 rrpow3) /\
             repres5 res.`3 = ((repres5 hh3) + (repres5 xx3)) * (repres5 rrpow2) /\
             repres5 res.`4 = ((repres5 hh4) + (repres5 xx4)) * (repres5 rrpow1)] = 1%r.
proof.
by conseq add_mulmod_x4_final_Rep5_spec_ll
          (add_mulmod_x4_final_Rep5_spec_h hh1 hh2 hh3 hh4 xx1 xx2 xx3 xx4
            rrpow1 rrpow2 rrpow3 rrpow4).
qed.

(******************************************************************************************

                                    Final equiv

 ******************************************************************************************)

equiv hop3eq : 
    Mhop2.poly1305 ~ Mhop3.poly1305 : 
      ={Glob.mem, in_0, inlen, k} /\ inv_ptr (to_uint k{2}) (to_uint in_0{2}) (to_uint inlen{2})
    ==>
      ={res,Glob.mem}.
proof.
proc => /=; seq 1 1 : #pre; 1: by auto.
if => //=; first by call poly1305_short_eq.
inline Mhop2.poly1305_long Mhop3.poly1305_long.
wp;call finish_eq.
wp; call update_eq; simplify.
ecall {2} (add_pack_spec h1{2} h2{2} h3{2} h4{2}).
ecall {2} (add_mulmod_x4_final_Rep5_spec h1{2} h2{2} h3{2} h4{2} x1{2} x2{2} x3{2} x4{2}
                                         rpow1{2} rpow2{2} rpow3{2} rpow4{2}).
wp; seq 12 10: (255 < to_uint inlen0{2} /\ ={Glob.mem, in_00, inlen0} /\
          good_ptr (to_uint k0{2}) 32 /\ good_ptr (to_uint in_00{2}) (to_uint inlen0{2} - 64) /\
          k0{1} = k0{2} + W64.of_int 16 /\
          r{1}=repres3r r{2} /\ Rep3r_ok r{2} /\
          r{1}=repres5 rpow1{2} /\ bRep5 28 rpow1{2} /\
          rpow2{1}=repres5 rpow2{2} /\ bRep5 28 rpow2{2} /\
          rpow3{1}=repres5 rpow3{2} /\ bRep5 28 rpow3{2} /\
          rpow4{1}=repres5 rpow4{2} /\ bRep5 28 rpow4{2} /\
          (rpow1x5 = mul5Rep54 rpow1){2} /\
          (rpow2x5 = mul5Rep54 rpow2){2} /\
          (rpow3x5 = mul5Rep54 rpow3){2} /\
          (rpow4x5 = mul5Rep54 rpow4){2} /\
          h1{1}=repres5 h1{2} /\ bRep5 27 h1{2} /\
          h2{1}=repres5 h2{2} /\ bRep5 27 h2{2} /\
          h3{1}=repres5 h3{2} /\ bRep5 27 h3{2} /\
          h4{1}=repres5 h4{2} /\ bRep5 27 h4{2} /\
          x1{1}=repres5 x1{2} /\ bRep5 26 x1{2} /\
          x2{1}=repres5 x2{2} /\ bRep5 26 x2{2} /\
          x3{1}=repres5 x3{2} /\ bRep5 26 x3{2} /\
          x4{1}=repres5 x4{2} /\ bRep5 26 x4{2}).
 ecall {2} (load4x_spec Glob.mem{2} in_00{2}).
 ecall {2} (precompute_Rep5_spec r{2}).
 inline Mhop2.load_4x Mhop3.Rep5Impl.zero Mhop2.poly1305_setup; wp.
 ecall {2} (clamp_spec Glob.mem{2} k0{2}).
 wp; skip; rewrite /inv_ptr => &1 &2 />; rewrite !ultE /= => *; do split;  1..2:smt().
move => *; do split; 1,2:smt(W64.to_uint_cmp pow2_64).
move => 11?; rewrite !to_uint_eq !to_uintD /= => *. 
do split; 1..9,18..:smt(W64.to_uint_cmp pow2_64).
by rewrite repres5E valRep5E ; smt().
rewrite bRep5E /=; smt(bW64_0 @BW64). 
by rewrite repres5E valRep5E ; smt().
rewrite bRep5E /=; smt(bW64_0 @BW64). 
by rewrite repres5E valRep5E ; smt().
rewrite bRep5E /=; smt(bW64_0 @BW64). 
by rewrite repres5E valRep5E ; smt().
rewrite bRep5E /=; smt(bW64_0 @BW64). 
while (#[2:]pre /\ 64 <= to_uint inlen0{2}).
 inline Mhop2.load_4x; wp. 
 ecall {2} (load4x_spec Glob.mem{2} in_00{2}).
 ecall {2} (add_mulmod_x4_Rep5_spec h1{2} h2{2} h3{2} h4{2} x1{2} x2{2} x3{2} x4{2} rpow4{2}).
auto => /> &2; rewrite uleE /= => *; do split; 1,2: smt(W64.to_uint_cmp pow2_64).
move => 11? H; do split; 1,4..11: smt().
rewrite H !to_uintD /= to_uintN /=; smt(W64.to_uint_cmp pow2_64).
rewrite H !to_uintD /= to_uintN /=; smt(W64.to_uint_cmp pow2_64).
rewrite!to_uintD /= to_uintN /=; smt(W64.to_uint_cmp pow2_64).
auto => /> &2 => *; do split; 1: smt(W64.to_uint_cmp pow2_64).
move =>34? H; do split; 1:smt().
rewrite !to_uintD /= to_uintN /=; smt(W64.to_uint_cmp pow2_64).
rewrite !to_uintD /= to_uintN /=; smt(W64.to_uint_cmp pow2_64).
move => *; do split; 1,2: smt(W64.to_uint_cmp pow2_64).
rewrite!to_uintD /=; smt(W64.to_uint_cmp pow2_64).
qed.

