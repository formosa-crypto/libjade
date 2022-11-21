require import AllCore List Int IntDiv Real.
from Jasmin require import JModel.
require import Zp Array2.
import Zp.

(* First equivalence proof. Change control flow to match avx2 implementation. *)

require import Poly1305_spec.

module Mhop1 = { 
  proc poly1305_setup(k:W64.t): zp * W64.t = {
    var r;
    r <- load_clamp Glob.mem k;
    k <- k + (W64.of_int 16);
    return (r, k);
  }
  proc poly1305_update(in_0 inlen: W64.t, h r: zp): W64.t * W64.t * zp = {
    var x;
    while (((W64.of_int 16) \ule inlen)) {
      x <- load_block Glob.mem in_0;
      h <- h + x;
      h <- h * r;
      in_0 <- (in_0 + (W64.of_int 16));
      inlen <- (inlen - (W64.of_int 16));
    }
    return (in_0, inlen, h);
  }
  proc poly1305_finish(in_0 inlen k: W64.t, h r: zp): W64.t Array2.t = {
    var x, h_int, s;
    if (((W64.of_int 0) \ult inlen)) {
      x <- load_lblock Glob.mem inlen in_0;
      h <- h + x;
      h <- h * r;
    }
    h_int <- (asint h) %% 2^128;
    s <- W128.to_uint (loadW128 Glob.mem (to_uint k));
    h_int <- (h_int + s) %% 2^128;
    return Array2.init (fun i =>  W64.of_int (h_int %/ (if i = 0 then 1 else W64.modulus)));
  }
  proc poly1305_short (in_0:W64.t, inlen:W64.t, k:W64.t) : W64.t Array2.t = {
    var r, h : zp;
    var s, h_int : int;
    var rr;
    (r, k) <@ poly1305_setup(k);
    h <- Zp.zero;
    (in_0, inlen, h) <@ poly1305_update(in_0, inlen, h, r);
    rr <@poly1305_finish(in_0, inlen, k, h, r);
    return rr;
  }
  proc poly1305_long ( in_0:W64.t, inlen:W64.t, k:W64.t) : W64.t Array2.t = {
    var r, h, x : zp;
    var s, h_int : int;
    var rr;

    (r, k) <@ poly1305_setup(k);
    h <- Zp.zero;
    
    while (((W64.of_int 64) \ule inlen)) {
      x <- load_block Glob.mem in_0;
      h <- h + x;
      h <- h * r;
      in_0 <- (in_0 + (W64.of_int 16));
      x <- load_block Glob.mem in_0;
      h <- h + x;
      h <- h * r;
      in_0 <- (in_0 + (W64.of_int 16));
      x <- load_block Glob.mem in_0;
      h <- h + x;
      h <- h * r;
      in_0 <- (in_0 + (W64.of_int 16));
      x <- load_block Glob.mem in_0;
      h <- h + x;
      h <- h * r;
      in_0 <- (in_0 + (W64.of_int 16));
      inlen <- (inlen - (W64.of_int 64));
    }
    (in_0, inlen, h) <@ poly1305_update(in_0, inlen, h, r);
    rr <@poly1305_finish(in_0, inlen, k, h, r);
    return rr;
  }
  proc poly1305 (in_0:W64.t, inlen:W64.t, k:W64.t) : W64.t Array2.t = {
    var rr : W64.t Array2.t;
    rr <- witness;
    if ((inlen \ult (W64.of_int 256))) {
      rr <@poly1305_short (in_0, inlen, k);
    } else {
      rr <@poly1305_long (in_0, inlen, k);
    }
    return rr;
  }
}.

equiv hop1eq : 
    Mspec.poly1305 ~ Mhop1.poly1305 : ={Glob.mem, in_0, inlen, k} ==> ={res, Glob.mem}.
proof.
proc => /=.
case ( (inlen{2} \ult (of_int 256)%W64) ). 
+ rcondt{2} 2; 1: by auto.
 (* Short messages *)
 inline*.
 swap {1} 7 -5. 
 seq 9 24 : (h_int{1} = h_int0{2} /\ ={Glob.mem}); last by auto.
 by sim.

(* Long messages *)
+ rcondf{2} 2; 1: by auto.
inline*.
swap {1} 3 -2; swap {2} 3 -2; swap {1} 7 -4.
sp 1 5.
seq 3 4 : (#{/~ ={k}}{/~ k{2}}{/~ k1{2}}pre /\ ={r,h} /\ k{1}=k0{2}); first by auto.
splitwhile {1} 1 : (64 <= to_uint inlen0 \/ (to_uint inlen - to_uint inlen0) %% 64 <> 0).
seq 1 1 : (#{/~inlen0{2}}
            {~inlen0{1}}
            {~in_00{2}}
            {~={in_0}}
            {~={inlen}}pre /\ inlen0{1} = inlen0{2} /\
                              in_0{1} = in_00{2} /\
                              W64.to_uint inlen0{1} <= 64); last first. 
+ seq 5 15 : (h_int{1} = h_int0{2}  /\ ={Glob.mem}); last by auto.
  by sim.

async while
  [ (fun r => r = (to_uint inlen0)%r), 
    (to_uint inlen0{2})%r ]
  [ (fun r => r = (to_uint inlen0)%r), 
    (to_uint inlen0{1})%r ]
    (to_uint inlen0{1} = to_uint inlen0{2}) 
    (to_uint inlen0{2} <= to_uint inlen0{1})
  :
    (#{/~ ={in_0}}
      {~(in_00{2} = in_0{2})}
      {~(inlen0{1} = inlen{1})}
      {~(inlen0{2} = inlen{2})}
      {~(in_0{1} = in_00{2})}
      {~={r}}
      {~={h}}pre /\
      (to_uint inlen{2} - to_uint inlen0{2}) %% 64 = 0 /\
      (   (* in sync *)
          (to_uint inlen0{1} = to_uint inlen0{2} /\
           ={h,r} /\ in_0{1} = in_00{2}) \/
          (* 3 ahead *)
          (to_uint inlen0{1} - 3*16 = to_uint inlen0{2} /\
           ={r} /\ 
           ((((h{1} + load_block Glob.mem{1} in_0{1}) * r{1}
              + load_block Glob.mem{1} (in_0{1} + W64.of_int 16)) * r{1})
                + load_block Glob.mem{1} (in_0{1} + W64.of_int 32)) * r{1}
                  = h{2} /\
           in_0{1} + W64.of_int (3*16) = in_00{2}) \/
          (* 2 ahead *)
          (to_uint inlen0{1} - 2*16 = to_uint inlen0{2} /\
           ={r} /\ 
           (((h{1} + load_block Glob.mem{1} in_0{1}) * r{1}
              + load_block Glob.mem{1} (in_0{1} + W64.of_int 16)) * r{1}
                 = h{2})  /\
           in_0{1} + W64.of_int (2*16) = in_00{2})  \/
          (* 1 ahead *)
          (to_uint inlen0{1} - 16 = to_uint inlen0{2} /\
           ={r} /\ 
           ((h{1} + load_block Glob.mem{1} in_0{1}) * r{1}
               = h{2})  /\
           in_0{1} + W64.of_int 16 = in_00{2})
      )).
 (* inv3 => c1 \/ c2 => inv1 => c1 /\ c2 /\ f p /\ g q *)
 + move => &1 &2 />; rewrite uleE ultE  /= =>  H H0 H1 H2 ?.
   elim H2;rewrite ?uleE /=;move => [#] *; do split; smt().

 (* inv3 => c1 \/ c2 => !inv1 => inv2 => c1 *)
 + move => &1 &2 />; rewrite uleE ultE  /= =>  H H0 H1 H2 ?.
   elim H2;rewrite ?uleE /=;move => [#] *; do split; smt().

 (* inv3 => c1 \/ c2 => !inv1 => !inv2 => c2 *)
 + move => &1 &2 />; rewrite uleE ultE  /= =>  H H0 H1 H2 ?.
   elim H2;rewrite ?uleE /=;move => [#] *; smt().

 (* {inv3 /\ c1 /\ !inv1 /\ inv2} Body1 {inv3} *)
 + move => *; auto => /> &1; rewrite ultE uleE  /= => H H0 H1 H2 ??.
   rewrite !to_uintD /= !to_uintN /=;smt(W64.to_uint_cmp pow2_64). 

 (* { inv3 /\ c2 /\ !inv1 /\ !inv2} Body2 {inv3} *)
 + move => *; exfalso; smt().

 + move => v1_ v2_. 
   while 
     (#{/~inlen0{2}}
              {~in_00{2}}
              {~={in_0}}
              {~={r}}
              {~={h}}
              {~v1_}
              {~v2_}pre /\
       (to_uint inlen{2} - to_uint inlen0{2}) %% 64 = 0 /\ 
       (  (* in sync *)
          (to_uint inlen0{1} = to_uint inlen0{2} /\
           ={h,r} /\ in_0{1} = in_00{2} /\
          v1_ = (to_uint inlen0{2})%r /\ v2_ = (to_uint inlen0{1})%r) \/
          (* 3 ahead *)
          (to_uint inlen0{1} - 3*16 = to_uint inlen0{2} /\
           ={r} /\ 
           ((((h{1} + load_block Glob.mem{1} in_0{1}) * r{1}
              + load_block Glob.mem{1} (in_0{1} + W64.of_int 16)) * r{1})
                + load_block Glob.mem{1} (in_0{1} + W64.of_int 32)) * r{1}
                  = h{2} /\
           in_0{1} + W64.of_int (3*16) = in_00{2} /\
          v1_ = (to_uint inlen0{2})%r + 64%r /\ v2_ = (to_uint inlen0{1})%r + 16%r) 
        )).
    inline *; auto => /> &1 &2.
    rewrite !uleE !ultE  /= =>  H H0 H1 H2 ??.
    rewrite !to_uintD /= !to_uintN /=; do split; 1,3..: smt(W64.to_uint_cmp pow2_64). 
     elim H1. 
     + move => *; right; do split; smt(W64.to_uint_cmp pow2_64). 
     move => *; left; do split; smt(W64.to_uint_cmp pow2_64). 
   
    - auto => /> &1 &2.
      rewrite !uleE !ultE  /= =>  H H0 H1 H2 ?.
      do split; smt(W64.to_uint_cmp pow2_64). 

 (* inv3 ==> islossless while(c1 /\ !inv1 /\ inv2) Body1 *)
 + while true (W64.to_uint inlen0).
    move => ?; wp; skip => &hr.
    rewrite uleE to_uintD /= to_uintN; smt().

    skip => &hr /> *; rewrite uleE; smt().

 (* inv3 ==> islossless while(c1 /\ !inv1 /\ !inv2) Body2 *)
 + while (#pre) (W64.to_uint inlen0).
    - auto => /> &hr.
      rewrite !uleE !ultE  /= =>  H H0 H1 H2 ???.
      do split; smt(W64.to_uint_cmp pow2_64). 

    skip => &hr /> *; rewrite uleE; smt().

 (* !c1 => !c2 => inv3 => #post *)
 skip => /> &1; rewrite ultE /= => ???????.
 rewrite !uleE /= => H??H2; do split; smt(W64.to_uint_eq W64.to_uint_cmp pow2_64). 

qed.

