require import AllCore List Int IntDiv.
require import Array2 Array3 Array4 Array5.
require import WArray16 WArray24 WArray64 WArray96 WArray128 WArray160. 
from Jasmin require import JModel.
require import Ops.

(* Pre-vectorized code is identical to final implementation,
   but vectorized instructions are replaced with non-vectorized
   code that can be reorganized for connection to the hop3 code. *)

require Rep3Limb Rep5Limb.

abbrev bit25_u64 = W64.of_int 16777216.
abbrev mask26_u64 = W64.of_int 67108863.
abbrev five_u64 = W64.of_int 5.
abbrev zero_u64 = W64.of_int 0.

module Mprevec = {

  module Rep3Impl = Rep3Limb.Mrep3
  
  (*********************************************)
  (*********************************************)
  (*********************************************)
  (*********************************************)
  (*********************************************)
  (*********************************************)

  proc unpack (r1234:t4u64 Array5.t,rt:W64.t Array3.t,o:int) : t4u64 Array5.t = {
    
    var mask26:int;
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
    
    mask26 <- 67108863;
    l <- rt.[0];
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ Ops.set_160(r1234,0,o,l);
    l <- rt.[0];
    l <- (l `>>` (W8.of_int 26));
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ Ops.set_160(r1234,1,o,l);
    l <- rt.[0];
    ( _0, _1, _2, _3, _4,l) <- SHRD_64 l rt.[1] (W8.of_int 52);
    h <- l;
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ Ops.set_160(r1234,2,o,l);
    l <- h;
    l <- (l `>>` (W8.of_int 26));
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ Ops.set_160(r1234,3,o,l);
    l <- rt.[1];
    ( _5, _6, _7, _8, _9,l) <- SHRD_64 l rt.[2] (W8.of_int 40);
    r1234 <@ Ops.set_160(r1234,4,o,l);
    return (r1234);
  }
  
  proc times_5 (r1234:t4u64 Array5.t) : t4u64 Array4.t = {
    var aux: int;
    
    var r1234x5:t4u64 Array4.t;
    var five:t4u64;
    var i:int;
    var t:t4u64;
    r1234x5 <- witness;
    five <@ Ops.iVPBROADCAST_4u64(five_u64);
    i <- 0;
    while (i < 4) {
      t <@ Ops.iVPMULU_256(five,r1234.[(1 + i)]);
      r1234x5.[i] <- t;
      i <- i + 1;
    }
    return (r1234x5);
  }
  
  proc broadcast_r4 (r1234:t4u64 Array5.t,r1234x5:t4u64 Array4.t) : 
  t4u64 Array5.t * t4u64 Array4.t = {
    var aux: int;
    
    var r4444:t4u64 Array5.t;
    var r4444x5:t4u64 Array4.t;
    var i:int;
    var ti:t4u64;
    var xx : W64.t;
    r4444 <- witness;
    r4444x5 <- witness;
    i <- 0;
    while (i < 5) {
      xx <@ Ops.get_160(r1234,i,0);
      ti <@ Ops.iVPBROADCAST_4u64(xx);
      r4444.[i] <- ti;
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      xx <@ Ops.get_128(r1234x5,i,0);
      ti <@ Ops.iVPBROADCAST_4u64(xx);
      r4444x5.[i] <- ti;
      i <- i + 1;
    }
    return (r4444,r4444x5);
  }
  
  proc poly1305_avx2_setup (r:W64.t Array3.t) : t4u64 Array5.t *
                                                t4u64 Array4.t *
                                                t4u64 Array5.t *
                                                t4u64 Array4.t = {
    var aux: int;
    
    var r4444:t4u64 Array5.t;
    var r4444x5:t4u64 Array4.t;
    var r1234:t4u64 Array5.t;
    var r1234x5:t4u64 Array4.t;
    var i:int;
    var rt:W64.t Array3.t;
    r1234 <- witness;
    r1234x5 <- witness;
    r4444 <- witness;
    r4444x5 <- witness;
    rt <- witness;
    i <- 0;
    while (i < 2) {
      rt.[i] <- r.[i];
      i <- i + 1;
    }
    rt.[2] <- (W64.of_int 0);
    r1234 <@ unpack (r1234,rt,3);
    i <- 0;
    while (i < 3) {
      rt <@ Rep3Impl.mulmod (rt,r);
      r1234 <@ unpack (r1234,rt,(2 - i));
      i <- i + 1;
    }
    r1234x5 <@ times_5 (r1234);
    (r4444,r4444x5) <@ broadcast_r4 (r1234,r1234x5);
    return (r4444,r4444x5,r1234,r1234x5);
  }
  
  proc load_avx2 (in_0:W64.t,mask26:t4u64,s_bit25:t4u64) : t4u64 Array5.t *
                                                               W64.t = {
    
    var m0,m1,m2,m3,m4:t4u64;
    var t:t4u64;
    t <@ Ops.iload4u64(Glob.mem,in_0 + (W64.of_int 0));
    m1 <@ Ops.iload4u64(Glob.mem,in_0 + (W64.of_int 32));
    in_0 <- (in_0 + (W64.of_int 64));
    m0 <@ Ops.iVPERM2I128(t,m1,(W8.of_int 32));
    m1 <@ Ops.iVPERM2I128(t,m1,(W8.of_int 49));
    m2 <@ Ops.iVPSRLDQ_256(m0,(W8.of_int 6));
    m3 <@ Ops.iVPSRLDQ_256(m1,(W8.of_int 6));
    m4 <@ Ops.iVPUNPCKH_4u64(m0,m1);
    m0 <@ Ops.iVPUNPCKL_4u64(m0,m1);
    m3 <@ Ops.iVPUNPCKL_4u64(m2,m3);
    m2 <@ Ops.ivshr64u256(m3,(W8.of_int 4));
    m2 <@ Ops.iland4u64(m2,mask26);
    m1 <@ Ops.ivshr64u256(m0,(W8.of_int 26));
    m0 <@ Ops.iland4u64(m0,mask26);
    m3 <@ Ops.ivshr64u256(m3,(W8.of_int 30));
    m3 <@ Ops.iland4u64(m3,mask26);
    m4 <@ Ops.ivshr64u256(m4,(W8.of_int 40));
    m4 <@ Ops.ilor4u64(m4,s_bit25);
    m1 <@ Ops.iland4u64(m1,mask26);
    return (Array5.of_list witness [m0;m1;m2;m3;m4],in_0);
  }
  
  proc pack_avx2 (h:t4u64 Array5.t) : W64.t Array3.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var r0,r1,r2:W64.t;
    var t0,t1,t2:t4u64;
    var u0,u1:t4u64;
    var t0_:t2u64;
    
    var d0,d1,d2:W64.t;
    var cf:bool;
    var c:W64.t;
    var cx4:W64.t;
    var  _0:bool;
    var  _1:bool;
    var xx;
    t0 <@ Ops.ivshl64u256(h.[1],(W8.of_int 26));
    t0 <@ Ops.ivadd64u256(t0,h.[0]);
    t1 <@ Ops.ivshl64u256(h.[3],(W8.of_int 26));
    t1 <@ Ops.ivadd64u256(t1,h.[2]);
    t2 <@ Ops.iVPSRLDQ_256(h.[4],(W8.of_int 8));
    t2 <@ Ops.ivadd64u256(t2,h.[4]);
    t2 <@ Ops.iVPERMQ(t2,(W8.of_int 128));
    u0 <@ Ops.iVPERM2I128(t0,t1,(W8.of_int 32));
    u1 <@ Ops.iVPERM2I128(t0,t1,(W8.of_int 49));
    t0 <@ Ops.ivadd64u256(u0,u1);
    u0 <@ Ops.iVPUNPCKL_4u64(t0,t2);
    u1 <@ Ops.iVPUNPCKH_4u64(t0,t2);
    t0 <@ Ops.ivadd64u256(u0,u1);
    t0_ <@ Ops.iVEXTRACTI128(t0,(W8.of_int 1));
    xx <@ Ops.itruncate_4u64_2u64(t0);
    d0 <@ Ops.iVPEXTR_64(xx,(W8.of_int 0)); 
    d1 <@ Ops.iVPEXTR_64(t0_,(W8.of_int 0));
    d2 <@ Ops.iVPEXTR_64(t0_,(W8.of_int 1));
    r0 <- d1;
    r0 <- (r0 `<<` (W8.of_int 52));
    r1 <- d1;
    r1 <- (r1 `>>` (W8.of_int 12));
    r2 <- d2;
    r2 <- (r2 `>>` (W8.of_int 24));
    d2 <- (d2 `<<` (W8.of_int 40));
    (aux,aux_0) <- addc r0 d0 false;
    cf <- aux;
    r0 <- aux_0;
    (aux,aux_0) <- addc r1 d2 cf;
    cf <- aux;
    r1 <- aux_0;
    (aux,aux_0) <- addc r2 (W64.of_int 0) cf;
     _0 <- aux;
    r2 <- aux_0;
    c <- r2;
    cx4 <- r2;
    r2 <- (r2 `&` (W64.of_int 3));
    c <- (c `>>` (W8.of_int 2));
    cx4 <- (cx4 `&` (W64.of_int (- 4)));
    c <- (c + cx4);
    (aux,aux_0) <- addc r0 c false;
    cf <- aux;
    r0 <- aux_0;
    (aux,aux_0) <- addc r1 (W64.of_int 0) cf;
    cf <- aux;
    r1 <- aux_0;
    (aux,aux_0) <- addc r2 (W64.of_int 0) cf;
     _1 <- aux;
    r2 <- aux_0;
    return (Array3.of_list witness [r0;r1;r2]);
  }
  
  proc carry_reduce_avx2 (x:t4u64 Array5.t,mask26:t4u64) : t4u64 Array5.t = {
    
    var z0,z1:t4u64;
    var t:t4u64;
    var x0,x1,x2,x3,x4:t4u64;
    z0 <@ Ops.ivshr64u256(x.[0],(W8.of_int 26));
    z1 <@ Ops.ivshr64u256(x.[3],(W8.of_int 26));
    x0 <@ Ops.iland4u64(x.[0],mask26);
    x3 <@ Ops.iland4u64(x.[3],mask26);
    x1 <@ Ops.ivadd64u256(x.[1],z0);
    x4 <@ Ops.ivadd64u256(x.[4],z1);
    z0 <@ Ops.ivshr64u256(x1,(W8.of_int 26));
    z1 <@ Ops.ivshr64u256(x4,(W8.of_int 26));
    t <@ Ops.ivshl64u256(z1,(W8.of_int 2));
    z1 <@ Ops.ivadd64u256(z1,t);
    x1 <@ Ops.iland4u64(x1,mask26);
    x4 <@ Ops.iland4u64(x4,mask26);
    x2 <@ Ops.ivadd64u256(x.[2],z0);
    x0 <@ Ops.ivadd64u256(x0,z1);
    z0 <@ Ops.ivshr64u256(x2,(W8.of_int 26));
    z1 <@ Ops.ivshr64u256(x0,(W8.of_int 26));
    x2 <@ Ops.iland4u64(x2,mask26);
    x0 <@ Ops.iland4u64(x0,mask26);
    x3 <@ Ops.ivadd64u256(x3,z0);
    x1 <@ Ops.ivadd64u256(x1,z1);
    z0 <@ Ops.ivshr64u256(x3,(W8.of_int 26));
    x3 <@ Ops.iland4u64(x3,mask26);
    x4 <@ Ops.ivadd64u256(x4,z0);
    return (Array5.of_list witness [x0;x1;x2;x3;x4]);
  }
  
  proc add_mulmod_avx2 (h:t4u64 Array5.t,m:t4u64 Array5.t,
                        s_r:t4u64 Array5.t,s_rx5:t4u64 Array4.t
                       ) : t4u64 Array5.t = {
    var r0:t4u64;
    var r1:t4u64;
    var r4x5:t4u64;
    var t0,t1,t2,t3,t4:t4u64;
    var u0,u1,u2,u3,u4:t4u64;
    var h0,h1,h2,h3,h4:t4u64;
    var m0,m1,m2,m3,m4:t4u64;
    var r2:t4u64;
    var r3x5:t4u64;
    var r3:t4u64;
    var r2x5:t4u64;
   r0 <- s_r.[0];
    r1 <- s_r.[1];
    r4x5 <- s_rx5.[(4 - 1)];
    h0 <@ Ops.ivadd64u256(h.[0],m.[0]);
    h1 <@ Ops.ivadd64u256(h.[1],m.[1]);
    h2 <@ Ops.ivadd64u256(h.[2],m.[2]);
    h3 <@ Ops.ivadd64u256(h.[3],m.[3]);
    h4 <@ Ops.ivadd64u256(h.[4],m.[4]);
    t0 <@ Ops.iVPMULU_256(h0,r0);
    t1 <@ Ops.iVPMULU_256(h1,r0);
    t2 <@ Ops.iVPMULU_256(h2,r0);
    t3 <@ Ops.iVPMULU_256(h3,r0);
    t4 <@ Ops.iVPMULU_256(h4,r0);
    u0 <@ Ops.iVPMULU_256(h0,r1);
    u1 <@ Ops.iVPMULU_256(h1,r1);
    u2 <@ Ops.iVPMULU_256(h2,r1);
    u3 <@ Ops.iVPMULU_256(h3,r1);
    r2 <- s_r.[2];
    t1 <@ Ops.ivadd64u256(t1,u0);
    t2 <@ Ops.ivadd64u256(t2,u1);
    t3 <@ Ops.ivadd64u256(t3,u2);
    t4 <@ Ops.ivadd64u256(t4,u3);
    u0 <@ Ops.iVPMULU_256(h1,r4x5);
    u1 <@ Ops.iVPMULU_256(h2,r4x5);
    u2 <@ Ops.iVPMULU_256(h3,r4x5);
    u3 <@ Ops.iVPMULU_256(h4,r4x5);
    r3x5 <- s_rx5.[(3 - 1)];
    t0 <@ Ops.ivadd64u256(t0,u0);
    t1 <@ Ops.ivadd64u256(t1,u1);
    t2 <@ Ops.ivadd64u256(t2,u2);
    t3 <@ Ops.ivadd64u256(t3,u3);
    u0 <@ Ops.iVPMULU_256(h0,r2);
    u1 <@ Ops.iVPMULU_256(h1,r2);
    u2 <@ Ops.iVPMULU_256(h2,r2);
    r3 <- s_r.[3];
    t2 <@ Ops.ivadd64u256(t2,u0);
    t3 <@ Ops.ivadd64u256(t3,u1);
    t4 <@ Ops.ivadd64u256(t4,u2);
    u0 <@ Ops.iVPMULU_256(h2,r3x5);
    u1 <@ Ops.iVPMULU_256(h3,r3x5);
    h2 <@ Ops.iVPMULU_256(h4,r3x5);
    r2x5 <- s_rx5.[(2 - 1)];
    t0 <@ Ops.ivadd64u256(t0,u0);
    t1 <@ Ops.ivadd64u256(t1,u1);
    h2 <@ Ops.ivadd64u256(h2,t2);
    u0 <@ Ops.iVPMULU_256(h0,r3);
    u1 <@ Ops.iVPMULU_256(h1,r3);
    t3 <@ Ops.ivadd64u256(t3,u0);
    t4 <@ Ops.ivadd64u256(t4,u1);
    u0 <@ Ops.iVPMULU_256(h3,r2x5);
    h1 <@ Ops.iVPMULU_256(h4,r2x5);
    t0 <@ Ops.ivadd64u256(t0,u0);
    h1 <@ Ops.ivadd64u256(h1,t1);
    u0 <@ Ops.iVPMULU_256(h4,s_rx5.[(1 - 1)]);
    u1 <@ Ops.iVPMULU_256(h0,s_r.[4]);
    h0 <@ Ops.ivadd64u256(t0,u0);
    h3 <- t3;
    h4 <@ Ops.ivadd64u256(t4,u1);
    return (Array5.of_list witness [h0;h1;h2;h3;h4]);
  }
  
  proc mainloop_avx2_v1 (h:t4u64 Array5.t,m:t4u64 Array5.t,in_0:W64.t,
                         s_r:t4u64 Array5.t,s_rx5:t4u64 Array4.t,
                         s_mask26:t4u64,s_bit25:t4u64) : t4u64 Array5.t *
                                                            t4u64 Array5.t *
                                                            W64.t = {
    
    var r0:t4u64;
    var r1:t4u64;
    var r4x5:t4u64;
    var t0,t1,t2,t3,t4:t4u64;
    var h0,h1,h2,h3,h4:t4u64;
    var m0,m1,m2,m3,m4:t4u64;
    var u0,u1,u2,u3:t4u64;
    var _m0:t4u64;
    var r2:t4u64;
    var r3x5:t4u64;
    var r3:t4u64;
    var r2x5:t4u64;
    var mask26:t4u64;
    var z0,z1:t4u64;
    var _z0:t4u64;
   r0 <- s_r.[0];
    r1 <- s_r.[1];
    r4x5 <- s_rx5.[(4 - 1)];
    h0 <@ Ops.ivadd64u256(h.[0],m.[0]);
    h1 <@ Ops.ivadd64u256(h.[1],m.[1]);
    t0 <@ Ops.iVPMULU_256(h0,r0);
    h2 <@ Ops.ivadd64u256(h.[2],m.[2]);
    u0 <@ Ops.iVPMULU_256(h0,r1);
    h3 <@ Ops.ivadd64u256(h.[3],m.[3]);
    t1 <@ Ops.iVPMULU_256(h1,r0);
    h4 <@ Ops.ivadd64u256(h.[4],m.[4]);
    u1 <@ Ops.iVPMULU_256(h1,r1);
    t2 <@ Ops.iVPMULU_256(h2,r0);
    u2 <@ Ops.iVPMULU_256(h2,r1);
    t3 <@ Ops.iVPMULU_256(h3,r0);
    t1 <@ Ops.ivadd64u256 (t1,u0);
    u3 <@ Ops.iVPMULU_256(h3,r1);
    t2 <@ Ops.ivadd64u256(t2,u1);
    t4 <@ Ops.iVPMULU_256(h4,r0);
    t3 <@ Ops.ivadd64u256(t3,u2);
    t4 <@ Ops.ivadd64u256(t4,u3);
    u0 <@ Ops.iVPMULU_256(h1,r4x5);
    _m0 <@ Ops.iload4u64(Glob.mem,in_0 + W64.of_int 0);
    u1 <@ Ops.iVPMULU_256(h2,r4x5);
    r2 <- s_r.[2];
    u2 <@ Ops.iVPMULU_256(h3,r4x5);
    u3 <@ Ops.iVPMULU_256(h4,r4x5);
    t0 <@ Ops.ivadd64u256(t0,u0);
    m1 <@ Ops.iload4u64(Glob.mem,in_0 + W64.of_int 32);
    t1 <@ Ops.ivadd64u256(t1,u1);
    t2 <@ Ops.ivadd64u256(t2,u2);
    t3 <@ Ops.ivadd64u256(t3,u3);
    u0 <@ Ops.iVPMULU_256(h0,r2);
    m0 <@ Ops.iVPERM2I128(_m0,m1,W8.of_int 32);
    u1 <@ Ops.iVPMULU_256(h1,r2);
    m1 <@ Ops.iVPERM2I128(_m0,m1,W8.of_int 49);
    u2 <@ Ops.iVPMULU_256(h2,r2);
    t2 <@ Ops.ivadd64u256(t2,u0);
    r3x5 <- s_rx5.[(3 - 1)];
    t3 <@ Ops.ivadd64u256(t3,u1);
    t4 <@ Ops.ivadd64u256(t4,u2);
    u0 <@ Ops.iVPMULU_256(h2,r3x5);
    u1 <@ Ops.iVPMULU_256(h3,r3x5);
    r3 <- s_r.[3];
    h2 <@ Ops.iVPMULU_256(h4,r3x5);
    m2 <@ Ops.iVPSRLDQ_256(m0,W8.of_int 6);
    t0 <@ Ops.ivadd64u256(t0,u0);
    m3 <@ Ops.iVPSRLDQ_256(m1,W8.of_int 6);
    t1 <@ Ops.ivadd64u256(t1,u1);
    h2 <@ Ops.ivadd64u256(h2,t2);
    r2x5 <- s_rx5.[(2 - 1)];
    u0 <@ Ops.iVPMULU_256(h0,r3);
    u1 <@ Ops.iVPMULU_256(h1,r3);
    m4 <@ Ops.iVPUNPCKH_4u64(m0,m1);
    m0 <@ Ops.iVPUNPCKL_4u64(m0,m1);
    t3 <@ Ops.ivadd64u256(t3,u0);
    t4 <@ Ops.ivadd64u256(t4,u1);
    u0 <@ Ops.iVPMULU_256(h3,r2x5);
    h1 <@ Ops.iVPMULU_256(h4,r2x5);
    t0 <@ Ops.ivadd64u256(t0,u0);
    h1 <@ Ops.ivadd64u256(h1,t1);
    mask26 <- s_mask26;
    u0 <@ Ops.iVPMULU_256(h4,s_rx5.[(1 - 1)]);
    u1 <@ Ops.iVPMULU_256(h0,s_r.[4]);
    m3 <@ Ops.iVPUNPCKL_4u64(m2,m3);
    m2 <@ Ops.ivshr64u256(m3,(W8.of_int 4));
    h0 <@ Ops.ivadd64u256(t0,u0);
    z0 <@ Ops.ivshr64u256(h0,(W8.of_int 26));
    h0 <@ Ops.iland4u64(h0,mask26);
    h3 <@ Ops.iland4u64(t3,mask26);
    z1 <@ Ops.ivshr64u256(t3,(W8.of_int 26));
    h4 <@ Ops.ivadd64u256(t4,u1);
    m2 <@ Ops.iland4u64(m2,mask26);
    m1 <@ Ops.ivshr64u256(m0,(W8.of_int 26));
    h1 <@ Ops.ivadd64u256(h1,z0);
    h4 <@ Ops.ivadd64u256(h4,z1);
    z0 <@ Ops.ivshr64u256(h1,(W8.of_int 26));
    z1 <@ Ops.ivshr64u256(h4,(W8.of_int 26));
    _z0 <@ Ops.ivshl64u256(z1,(W8.of_int 2));
    z1 <@ Ops.ivadd64u256(z1,_z0);
    h1 <@ Ops.iland4u64(h1,mask26);
    h4 <@ Ops.iland4u64(h4,mask26);
    h2 <@ Ops.ivadd64u256(h2,z0);
    h0 <@ Ops.ivadd64u256(h0,z1);
    z0 <@ Ops.ivshr64u256(h2,(W8.of_int 26));
    z1 <@ Ops.ivshr64u256(h0,(W8.of_int 26));
    h2 <@ Ops.iland4u64(h2,mask26);
    h0 <@ Ops.iland4u64(h0,mask26);
    h3 <@ Ops.ivadd64u256(h3,z0);
    h1 <@ Ops.ivadd64u256(h1,z1);
    z0 <@ Ops.ivshr64u256(h3,(W8.of_int 26));
    h3 <@ Ops.iland4u64(h3,mask26);
    h4 <@ Ops.ivadd64u256(h4,z0);
    in_0 <- (in_0 + (W64.of_int 64));
    m0 <@ Ops.iland4u64(m0,mask26);
    m3 <@ Ops.ivshr64u256(m3,(W8.of_int 30));
    m3 <@ Ops.iland4u64(m3,mask26);
    m4 <@ Ops.ivshr64u256(m4,(W8.of_int 40));
    m4 <@ Ops.ilor4u64(m4,s_bit25);
    m1 <@ Ops.iland4u64(m1,mask26);
    return (Array5.of_list witness [h0;h1;h2;h3;h4],Array5.of_list witness [m0;m1;m2;m3;m4],in_0);    
  }
  
  proc final_avx2_v0 (h:t4u64 Array5.t,m:t4u64 Array5.t,
                      s_r:t4u64 Array5.t,s_rx5:t4u64 Array4.t,
                      s_mask26:t4u64) : t4u64 Array5.t = {
    
    var mask26:t4u64;
    
    h <@ add_mulmod_avx2 (h,m,s_r,s_rx5);
    mask26 <- s_mask26;
    h <@ carry_reduce_avx2 (h,mask26);
    return (h);
  }
  
  proc poly1305_avx2_update (in_0:W64.t,len:W64.t,r4444:t4u64 Array5.t,
                             r4444x5:t4u64 Array4.t,r1234:t4u64 Array5.t,
                             r1234x5:t4u64 Array4.t) : W64.t * W64.t *
                                                        W64.t Array3.t = {
    var aux: int;
    
    var h64:W64.t Array3.t;
    var i:int;
    var h:t4u64 Array5.t;
    var hi : t4u64;
    var t:t4u64;
    var s_mask26:t4u64;
    var mask26:t4u64;
    var s_bit25:t4u64;
    var m:t4u64 Array5.t;
    h <- witness;
    h64 <- witness;
    m <- witness;
    i <- 0;
    while (i < 5) {
      hi <@ Ops.iVPBROADCAST_4u64(zero_u64);
      h.[i] <- hi;
      i <- i + 1;
    }
    t <@ Ops.iVPBROADCAST_4u64(mask26_u64);
    s_mask26 <- t;
    mask26 <- t;
    t <@ Ops.iVPBROADCAST_4u64(bit25_u64);
    s_bit25 <- t;
    (m,in_0) <@ load_avx2 (in_0,mask26,s_bit25);
    
    while (((W64.of_int 128) \ule len)) {
      (h,m,in_0) <@ mainloop_avx2_v1 (h,m,in_0,r4444,r4444x5,s_mask26,
      s_bit25);
      len <- (len - (W64.of_int 64));
    }
    len <- (len - (W64.of_int 64));
    h <@ final_avx2_v0 (h,m,r1234,r1234x5,s_mask26);
    h64 <@ pack_avx2 (h);
    return (in_0,len,h64);
  }
  
  proc poly1305_avx2_wrapper (in_0:W64.t,inlen:W64.t,k:W64.t) : W64.t Array2.t = {
    
    var len:W64.t;
    var h:W64.t Array3.t;
    var r:W64.t Array3.t;
    var r4444:t4u64 Array5.t;
    var r4444x5:t4u64 Array4.t;
    var r1234:t4u64 Array5.t;
    var r1234x5:t4u64 Array4.t;
    var rr;
    h <- witness;
    r <- witness;
    r1234 <- witness;
    r1234x5 <- witness;
    r4444 <- witness;
    r4444x5 <- witness;
    len <- inlen;
    (h,r,k) <@ Rep3Impl.setup (k);
    (r4444,r4444x5,r1234,r1234x5) <@ poly1305_avx2_setup (r);
    (in_0,len,h) <@ poly1305_avx2_update (in_0,len,r4444,r4444x5,r1234,
    r1234x5);
    (in_0,len,h) <@ Rep3Impl.update (in_0,len,h,r);
    rr <@Rep3Impl.finish (in_0,len,k,h,r);
    return rr;
  }
  
  proc poly1305(in_0:W64.t,inlen:W64.t,k:W64.t) : W64.t Array2.t  = {
    
    
    var rr <- witness;
    if ((inlen \ult (W64.of_int 256))) {
      rr<@Rep3Impl.poly1305 (in_0,inlen,k);
    } else {
      rr<@poly1305_avx2_wrapper (in_0,inlen,k);
    }
    return rr;
  }
}.

require import Poly1305_hop3.

op of_columns5 (h1 h2 h3 h4 : W64.t Array5.t) =
 Array5.of_list witness [ 
        Array4.of_list witness [ h1.[0]; h2.[0]; h3.[0]; h4.[0] ] ;
        Array4.of_list witness [ h1.[1]; h2.[1]; h3.[1]; h4.[1] ] ;
        Array4.of_list witness [ h1.[2]; h2.[2]; h3.[2]; h4.[2] ] ;
        Array4.of_list witness [ h1.[3]; h2.[3]; h3.[3]; h4.[3] ] ;
        Array4.of_list witness [ h1.[4]; h2.[4]; h3.[4]; h4.[4] ] 
].

op is_column5 (hv : W64.t Array4.t Array5.t, h : W64.t Array5.t, i : int) =
     hv.[0].[i] = h.[0] /\ 
     hv.[1].[i] = h.[1] /\ 
     hv.[2].[i] = h.[2] /\ 
     hv.[3].[i] = h.[3] /\ 
     hv.[4].[i] = h.[4].

op of_columns4 (h1 h2 h3 h4 : W64.t Array4.t) =
 Array4.of_list witness [ 
        Array4.of_list witness [ h1.[0]; h2.[0]; h3.[0]; h4.[0] ] ;
        Array4.of_list witness [ h1.[1]; h2.[1]; h3.[1]; h4.[1] ] ;
        Array4.of_list witness [ h1.[2]; h2.[2]; h3.[2]; h4.[2] ] ;
        Array4.of_list witness [ h1.[3]; h2.[3]; h3.[3]; h4.[3] ] 
].

op is_column4 (hv : W64.t Array4.t Array4.t, h : W64.t Array5.t, i : int) =
     hv.[0].[i] = h.[0] /\ 
     hv.[1].[i] = h.[1] /\ 
     hv.[2].[i] = h.[2] /\ 
     hv.[3].[i] = h.[3].

equiv hop3_savx2prevec_eq : 
    Mhop3.poly1305 ~ Mprevec.poly1305 : ={Glob.mem, in_0, inlen, k} ==> ={res,Glob.mem}.
proof.
proc =>/=. seq 1 1 : #pre; 1: by auto.
if => //=; first by sim.
(* long messages *)
inline Mhop3.poly1305_long  Mprevec.poly1305_avx2_wrapper Mprevec.Rep3Impl.setup
       Mprevec.poly1305_avx2_setup Mprevec.poly1305_avx2_update.
swap {2} 11 -7.
swap {2} 13 -8.
swap {2} 16 -10.
swap {1} 16 -11.
swap {2} 17 -10.
swap {2} 19 5.
wp;call(_: ={Glob.mem}) => /=; first by sim.
call (_: ={Glob.mem}) => /=; first by sim.
seq 5 23: (#[/1,5]pre /\ ={in_00, k0, r} /\ inlen0{1}=len{2}).
 by unroll for {2} 17; wp; call (_: ={Glob.mem});auto => />.
swap {2} [11..12] 14.
seq 6 27: ( (* MAIN LOOP INV *)
            ={Glob.mem,  k0, r} /\ (in_00,inlen0,r){1}=(in_01,len0,r1){2} /\
            h1{2} = of_columns5 h1{1} h2{1} h3{1} h4{1} /\
            m{2} = of_columns5 x1{1} x2{1} x3{1} x4{1} /\            
            r44441{2} = of_columns5 rpow4{1} rpow4{1} rpow4{1} rpow4{1} /\
            r12341{2} = of_columns5 rpow4{1} rpow3{1} rpow2{1} rpow1{1} /\ 
            r4444x51{2} = of_columns4 rpow4x5{1} rpow4x5{1} rpow4x5{1} rpow4x5{1} /\
            r1234x51{2} = of_columns4 rpow4x5{1} rpow3x5{1} rpow2x5{1} rpow1x5{1} /\
            s_mask26{2} = Array4.create mask26_u64 /\
            s_bit25{2} = Array4.create bit25_u64).
 (* pre-processing *)
 swap{1} 5 -4.
 seq 1 14: (#[/1:3,7:10]post /\ ={in_00} /\ inlen0{1} = len{2} /\ (r){2}=(r1){2}).
  inline Mhop3.precompute_Rep5.
  sp 1 1.
  seq 4 3: (#pre /\ ={rt} /\ r0{1}=r1{2}). 
   unroll for {1} 3; unroll for {2} 2.
   by wp; skip; auto => /> *; apply (Array3.all_eq_eq).
  seq 1 1 : (#pre /\ is_column5 r12340{2} rpow10{1} 3); first by inline *; auto. 
  unroll for {2} 2.
  seq 1 2: (i0{2}=0 /\ #pre); first by inline*; auto.
  seq 1 1: (#pre /\ is_column5 r12340{2} rpow20{1} 2); first by inline *; auto => />.
  seq 1 2: (i0{2}=1 /\ #[/2:]pre); first by inline*; auto.
  seq 1 1: (#pre /\ is_column5 r12340{2} rpow30{1} 1); first by inline *; auto => />.
  seq 1 2: (i0{2}=2 /\ #[/2:]pre); first by inline*; auto.
  seq 1 1: (#pre /\ is_column5 r12340{2} rpow40{1} 0); first by inline *; auto => />.
  inline*.
  unroll for {2} 20; unroll for {2} 18; unroll for {2} 11. 
  wp; auto => /> *; do split. 
  - by apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /=;
       progress; apply (Array4.all_eq_eq).
  - by apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /=;
       progress; apply (Array4.all_eq_eq).
  - by apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /=; 
      do split; apply (Array4.all_eq_eq); rewrite /all_eq /= /#. 
  - by apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /=; 
      do split; apply (Array4.all_eq_eq); rewrite /all_eq /= /#.
 unroll for {2} 5; inline*; auto => /> *; do split.
 - apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /=.
   by progress; apply (Array4.all_eq_eq).
 - apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /=.
   by progress; apply (Array4.all_eq_eq).
 - by apply (Array4.all_eq_eq).
 - by apply (Array4.all_eq_eq).
(* main loop *)
seq 1 1: (#pre).
 while (#pre) => //.
 inline Mhop3.add_mulmod_x4_Rep5 Mprevec.mainloop_avx2_v1.
 (* in order to allow "sim" tackle these goals...
 inline Mhop3.Rep5Impl.add.
 (*usage: interleave [pos1:n1] [pos2:n2] k *)
 interleave {1} [11:1] [19:1]8.
 interleave {1} [11:2] [27:1]8.
 interleave {1} [11:3] [35:1]8.*)
 inline*; wp; skip; auto => /> *; split; 
    apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /of_list /=; do split;
    apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list /=; do split;
    apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list /=; do split;
    apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list /=;do split;
    apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /of_list /=; do split;
      apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list //=. 

(* final *)
simplify; seq 2 2: (#{~m{2}}{~r44441{2}}{~r12341{2}}{~r4444x51{2}}{~r1234x51{2}}
                     {~s_mask26{2}}{~s_bit25{2}}pre).
 (* final iter *)
 inline Mhop3.add_mulmod_x4_final_Rep5 Mprevec.final_avx2_v0; wp.
 seq 1 1: #pre; first by auto => />.
 sp.
 seq 8 1: (#{/s_mask26{2}}pre /\ #post).
  (* add_mulmod *)
 by inline*; wp; skip; auto => /> *;  
    apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /of_list /=; do split;
    apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list /=; do split;
    apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list /=; do split;
    apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list /=;do split;
    apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /of_list /=; do split;
      apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list //=. 
 (* carry reduce *)
 by inline*; auto => /> *;
    apply (Array5.all_eq_eq); rewrite /all_eq /of_columns5 /of_list /=; do split;
        apply (Array4.all_eq_eq); rewrite /all_eq /of_columns4 /of_list //=;do split.
(* final pack *)
inline Mhop3.Rep5Impl.add_pack Mprevec.pack_avx2.
conseq />.
seq 22 26: (#[/1:6]pre /\ r0{1}.[0] = r00{2} /\ r0{1}.[1] = r10{2} /\ r0{1}.[2] = r2{2} /\ ={r,k0} /\ d{1}.[0] = d0{2} /\ d{1}.[2] = d2{2}).
 inline*; auto => /> *; do split; 1..3:
  by rewrite /of_columns5 /=; congr; ring.
  by rewrite /truncate_4u64_2u64 /of_columns5 /=; ring. 
  by rewrite /of_columns5 /=; congr; ring.
by auto => /> &1; apply (Array3.all_eq_eq); rewrite /all_eq => * //. 
qed.

