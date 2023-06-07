require import AllCore List Int IntDiv.
require import Array2 Array3 Array4 Array5.
require import WArray16 WArray24 WArray64 WArray96 WArray128 WArray160. 
require import Ops.
from Jasmin require import JModel.

(* Pre-vectorized code is identical to final implementation,
   but vectorized instructions are replaced with calls to VOps
   code that can be reorganized for connection to the hop3 code. *)

require Rep3Limb Rep5Limb.

abbrev bit25_u64 = W64.of_int 16777216.
abbrev mask26_u64 = W64.of_int 67108863.
abbrev five_u64 = W64.of_int 5.
abbrev zero_u64 = W64.of_int 0.

module Mvec = {

  module Rep3Impl = Rep3Limb.Mrep3
  
  (*********************************************)
  (*********************************************)
  (*********************************************)
  (*********************************************)
  (*********************************************)
  (*********************************************)

  proc unpack (r1234:vt4u64 Array5.t,rt:W64.t Array3.t,o:int) : vt4u64 Array5.t = {
    
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
    r1234 <@ OpsV.set_160(r1234,0,o,l);
    l <- rt.[0];
    l <- (l `>>` (W8.of_int 26));
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ OpsV.set_160(r1234,1,o,l);
    l <- rt.[0];
    ( _0, _1, _2, _3, _4,l) <- SHRD_64 l rt.[1] (W8.of_int 52);
    h <- l;
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ OpsV.set_160(r1234,2,o,l);
    l <- h;
    l <- (l `>>` (W8.of_int 26));
    l <- (l `&` (W64.of_int mask26));
    r1234 <@ OpsV.set_160(r1234,3,o,l);
    l <- rt.[1];
    ( _5, _6, _7, _8, _9,l) <- SHRD_64 l rt.[2] (W8.of_int 40);
    r1234 <@ OpsV.set_160(r1234,4,o,l);
    return (r1234);
  }
  
  proc times_5 (r1234:vt4u64 Array5.t) : vt4u64 Array4.t = {
    var aux: int;
    
    var r1234x5:vt4u64 Array4.t;
    var five:vt4u64;
    var i:int;
    var t:vt4u64;
    r1234x5 <- witness;
    five <@ OpsV.iVPBROADCAST_4u64(five_u64);
    i <- 0;
    while (i < 4) {
      t <@ OpsV.iVPMULU_256(five,r1234.[(1 + i)]);
      r1234x5.[i] <- t;
      i <- i + 1;
    }
    return (r1234x5);
  }
  
  proc broadcast_r4 (r1234:vt4u64 Array5.t,r1234x5:vt4u64 Array4.t) : 
  vt4u64 Array5.t * vt4u64 Array4.t = {
    var aux: int;
    
    var r4444:vt4u64 Array5.t;
    var r4444x5:vt4u64 Array4.t;
    var i:int;
    var ti:vt4u64;
    var xx : W64.t;
    r4444 <- witness;
    r4444x5 <- witness;
    i <- 0;
    while (i < 5) {
      xx <@ OpsV.get_160(r1234,i,0);
      ti <@ OpsV.iVPBROADCAST_4u64(xx);
      r4444.[i] <- ti;
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      xx <@ OpsV.get_128(r1234x5,i,0);
      ti <@ OpsV.iVPBROADCAST_4u64(xx);
      r4444x5.[i] <- ti;
      i <- i + 1;
    }
    return (r4444,r4444x5);
  }
  
  proc poly1305_avx2_setup (r:W64.t Array3.t) : vt4u64 Array5.t *
                                                vt4u64 Array4.t *
                                                vt4u64 Array5.t *
                                                vt4u64 Array4.t = {
    var aux: int;
    
    var r4444:vt4u64 Array5.t;
    var r4444x5:vt4u64 Array4.t;
    var r1234:vt4u64 Array5.t;
    var r1234x5:vt4u64 Array4.t;
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
  
  proc load_avx2 (in_0:W64.t,mask26:vt4u64,s_bit25:vt4u64) : vt4u64 Array5.t *
                                                               W64.t = {
    var m0,m1,m2,m3,m4 : vt4u64;
    var t:vt4u64;
    t <@ OpsV.iload4u64(Glob.mem,in_0 + (W64.of_int 0));
    m1 <@ OpsV.iload4u64(Glob.mem,in_0 + (W64.of_int 32));
    in_0 <- (in_0 + (W64.of_int 64));
    m0 <@ OpsV.iVPERM2I128(t,m1,(W8.of_int 32));
    m1 <@ OpsV.iVPERM2I128(t,m1,(W8.of_int 49));
    m2 <@ OpsV.iVPSRLDQ_256(m0,(W8.of_int 6));
    m3 <@ OpsV.iVPSRLDQ_256(m1,(W8.of_int 6));
    m4 <@ OpsV.iVPUNPCKH_4u64(m0,m1);
    m0 <@ OpsV.iVPUNPCKL_4u64(m0,m1);
    m3 <@ OpsV.iVPUNPCKL_4u64(m2,m3);
    m2 <@ OpsV.ivshr64u256(m3,(W8.of_int 4));
    m2 <@ OpsV.iland4u64(m2,mask26);
    m1 <@ OpsV.ivshr64u256(m0,(W8.of_int 26));
    m0 <@ OpsV.iland4u64(m0,mask26);
    m3 <@ OpsV.ivshr64u256(m3,(W8.of_int 30));
    m3 <@ OpsV.iland4u64(m3,mask26);
    m4 <@ OpsV.ivshr64u256(m4,(W8.of_int 40));
    m4 <@ OpsV.ilor4u64(m4,s_bit25);
    m1 <@ OpsV.iland4u64(m1,mask26);
    return (Array5.of_list witness [m0;m1;m2;m3;m4],in_0);
  }
  
  proc pack_avx2 (h:vt4u64 Array5.t) : W64.t Array3.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var d0,d1,d2 : W64.t;
    var r0,r1,r2 : W64.t;
    var t0,t1,t2 : vt4u64;
    var u0,u1,u2 : vt4u64;
    var t0_:vt2u64;
    var cf:bool;
    var c:W64.t;
    var cx4:W64.t;
    var  _0:bool;
    var  _1:bool;
    var xx;
    t0 <@ OpsV.ivshl64u256(h.[1],(W8.of_int 26));
    t0 <@ OpsV.ivadd64u256(t0,h.[0]);
    t1 <@ OpsV.ivshl64u256(h.[3],(W8.of_int 26));
    t1 <@ OpsV.ivadd64u256(t1,h.[2]);
    t2 <@ OpsV.iVPSRLDQ_256(h.[4],(W8.of_int 8));
    t2 <@ OpsV.ivadd64u256(t2,h.[4]);
    t2 <@ OpsV.iVPERMQ(t2,(W8.of_int 128));
    u0 <@ OpsV.iVPERM2I128(t0,t1,(W8.of_int 32));
    u1 <@ OpsV.iVPERM2I128(t0,t1,(W8.of_int 49));
    t0 <@ OpsV.ivadd64u256(u0,u1);
    u0 <@ OpsV.iVPUNPCKL_4u64(t0,t2);
    u1 <@ OpsV.iVPUNPCKH_4u64(t0,t2);
    t0 <@ OpsV.ivadd64u256(u0,u1);
    t0_ <@ OpsV.iVEXTRACTI128(t0,(W8.of_int 1));
    xx <@ OpsV.itruncate_4u64_2u64(t0);
    d0 <@ OpsV.iVPEXTR_64(xx,(W8.of_int 0)); 
    d1 <@ OpsV.iVPEXTR_64(t0_,(W8.of_int 0));
    d2 <@ OpsV.iVPEXTR_64(t0_,(W8.of_int 1));
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
  
  proc carry_reduce_avx2 (x:vt4u64 Array5.t,mask26:vt4u64) : vt4u64 Array5.t = {
    
    var z0,z1:vt4u64;
    var x0,x1,x2,x3,x4:vt4u64;
    var t:vt4u64;
    z0 <@ OpsV.ivshr64u256(x.[0],(W8.of_int 26));
    z1 <@ OpsV.ivshr64u256(x.[3],(W8.of_int 26));
    x0 <@ OpsV.iland4u64(x.[0],mask26);
    x3 <@ OpsV.iland4u64(x.[3],mask26);
    x1 <@ OpsV.ivadd64u256(x.[1],z0);
    x4 <@ OpsV.ivadd64u256(x.[4],z1);
    z0 <@ OpsV.ivshr64u256(x1,(W8.of_int 26));
    z1 <@ OpsV.ivshr64u256(x4,(W8.of_int 26));
    t <@ OpsV.ivshl64u256(z1,(W8.of_int 2));
    z1 <@ OpsV.ivadd64u256(z1,t);
    x1 <@ OpsV.iland4u64(x1,mask26);
    x4 <@ OpsV.iland4u64(x4,mask26);
    x2 <@ OpsV.ivadd64u256(x.[2],z0);
    x0 <@ OpsV.ivadd64u256(x0,z1);
    z0 <@ OpsV.ivshr64u256(x2,(W8.of_int 26));
    z1 <@ OpsV.ivshr64u256(x0,(W8.of_int 26));
    x2 <@ OpsV.iland4u64(x2,mask26);
    x0 <@ OpsV.iland4u64(x0,mask26);
    x3 <@ OpsV.ivadd64u256(x3,z0);
    x1 <@ OpsV.ivadd64u256(x1,z1);
    z0 <@ OpsV.ivshr64u256(x3,(W8.of_int 26));
    x3 <@ OpsV.iland4u64(x3,mask26);
    x4 <@ OpsV.ivadd64u256(x4,z0);
    return (Array5.of_list witness [x0;x1;x2;x3;x4]);
  }
  
  proc add_mulmod_avx2 (h:vt4u64 Array5.t,m:vt4u64 Array5.t,
                        s_r:vt4u64 Array5.t,s_rx5:vt4u64 Array4.t,
                        s_mask26:vt4u64,s_bit25:vt4u64) : vt4u64 Array5.t = {
    var r0:vt4u64;
    var r1:vt4u64;
    var r4x5:vt4u64;
    var t0,t1,t2,t3,t4:vt4u64;
    var h0,h1,h2,h3,h4:vt4u64;
    var u0,u1,u2,u3:vt4u64;
    var r2:vt4u64;
    var r3x5:vt4u64;
    var r3:vt4u64;
    var r2x5:vt4u64;
    r0 <- s_r.[0];
    r1 <- s_r.[1];
    r4x5 <- s_rx5.[(4 - 1)];
    h0 <@ OpsV.ivadd64u256(h.[0],m.[0]);
    h1 <@ OpsV.ivadd64u256(h.[1],m.[1]);
    h2 <@ OpsV.ivadd64u256(h.[2],m.[2]);
    h3 <@ OpsV.ivadd64u256(h.[3],m.[3]);
    h4 <@ OpsV.ivadd64u256(h.[4],m.[4]);
    t0 <@ OpsV.iVPMULU_256(h0,r0);
    t1 <@ OpsV.iVPMULU_256(h1,r0);
    t2 <@ OpsV.iVPMULU_256(h2,r0);
    t3 <@ OpsV.iVPMULU_256(h3,r0);
    t4 <@ OpsV.iVPMULU_256(h4,r0);
    u0 <@ OpsV.iVPMULU_256(h0,r1);
    u1 <@ OpsV.iVPMULU_256(h1,r1);
    u2 <@ OpsV.iVPMULU_256(h2,r1);
    u3 <@ OpsV.iVPMULU_256(h3,r1);
    r2 <- s_r.[2];
    t1 <@ OpsV.ivadd64u256(t1,u0);
    t2 <@ OpsV.ivadd64u256(t2,u1);
    t3 <@ OpsV.ivadd64u256(t3,u2);
    t4 <@ OpsV.ivadd64u256(t4,u3);
    u0 <@ OpsV.iVPMULU_256(h1,r4x5);
    u1 <@ OpsV.iVPMULU_256(h2,r4x5);
    u2 <@ OpsV.iVPMULU_256(h3,r4x5);
    u3 <@ OpsV.iVPMULU_256(h4,r4x5);
    r3x5 <- s_rx5.[(3 - 1)];
    t0 <@ OpsV.ivadd64u256(t0,u0);
    t1 <@ OpsV.ivadd64u256(t1,u1);
    t2 <@ OpsV.ivadd64u256(t2,u2);
    t3 <@ OpsV.ivadd64u256(t3,u3);
    u0 <@ OpsV.iVPMULU_256(h0,r2);
    u1 <@ OpsV.iVPMULU_256(h1,r2);
    u2 <@ OpsV.iVPMULU_256(h2,r2);
    r3 <- s_r.[3];
    t2 <@ OpsV.ivadd64u256(t2,u0);
    t3 <@ OpsV.ivadd64u256(t3,u1);
    t4 <@ OpsV.ivadd64u256(t4,u2);
    u0 <@ OpsV.iVPMULU_256(h2,r3x5);
    u1 <@ OpsV.iVPMULU_256(h3,r3x5);
    h2 <@ OpsV.iVPMULU_256(h4,r3x5);
    r2x5 <- s_rx5.[(2 - 1)];
    t0 <@ OpsV.ivadd64u256(t0,u0);
    t1 <@ OpsV.ivadd64u256(t1,u1);
    h2 <@ OpsV.ivadd64u256(h2,t2);
    u0 <@ OpsV.iVPMULU_256(h0,r3);
    u1 <@ OpsV.iVPMULU_256(h1,r3);
    t3 <@ OpsV.ivadd64u256(t3,u0);
    t4 <@ OpsV.ivadd64u256(t4,u1);
    u0 <@ OpsV.iVPMULU_256(h3,r2x5);
    h1 <@ OpsV.iVPMULU_256(h4,r2x5);
    t0 <@ OpsV.ivadd64u256(t0,u0);
    h1 <@ OpsV.ivadd64u256(h1,t1);
    u0 <@ OpsV.iVPMULU_256(h4,s_rx5.[(1 - 1)]);
    u1 <@ OpsV.iVPMULU_256(h0,s_r.[4]);
    h0 <@ OpsV.ivadd64u256(t0,u0);
    h3 <- t3;
    h4 <@ OpsV.ivadd64u256(t4,u1);
    return (Array5.of_list witness [h0;h1;h2;h3;h4]);
  }
  
  proc mainloop_avx2_v1 (h:vt4u64 Array5.t,m:vt4u64 Array5.t,in_0:W64.t,
                         s_r:vt4u64 Array5.t,s_rx5:vt4u64 Array4.t,
                         s_mask26:vt4u64,s_bit25:vt4u64) : vt4u64 Array5.t *
                                                            vt4u64 Array5.t *
                                                            W64.t = {
    
    var r0:vt4u64;
    var r1:vt4u64;
    var r4x5:vt4u64;
    var t0,t1,t2,t3,t4:vt4u64;
    var h0,h1,h2,h3,h4:vt4u64;
    var m0,m1,m2,m3,m4:vt4u64;
    var u0,u1,u2,u3:vt4u64;
    var _m0:vt4u64;
    var r2:vt4u64;
    var r3x5:vt4u64;
    var r3:vt4u64;
    var r2x5:vt4u64;
    var mask26:vt4u64;
    var z0,z1:vt4u64;
    var _z0:vt4u64;
    r0 <- s_r.[0];
    r1 <- s_r.[1];
    r4x5 <- s_rx5.[(4 - 1)];
    h0 <@ OpsV.ivadd64u256(h.[0],m.[0]);
    h1 <@ OpsV.ivadd64u256(h.[1],m.[1]);
    t0 <@ OpsV.iVPMULU_256(h0,r0);
    h2 <@ OpsV.ivadd64u256(h.[2],m.[2]);
    u0 <@ OpsV.iVPMULU_256(h0,r1);
    h3 <@ OpsV.ivadd64u256(h.[3],m.[3]);
    t1 <@ OpsV.iVPMULU_256(h1,r0);
    h4 <@ OpsV.ivadd64u256(h.[4],m.[4]);
    u1 <@ OpsV.iVPMULU_256(h1,r1);
    t2 <@ OpsV.iVPMULU_256(h2,r0);
    u2 <@ OpsV.iVPMULU_256(h2,r1);
    t3 <@ OpsV.iVPMULU_256(h3,r0);
    t1 <@ OpsV.ivadd64u256 (t1,u0);
    u3 <@ OpsV.iVPMULU_256(h3,r1);
    t2 <@ OpsV.ivadd64u256(t2,u1);
    t4 <@ OpsV.iVPMULU_256(h4,r0);
    t3 <@ OpsV.ivadd64u256(t3,u2);
    t4 <@ OpsV.ivadd64u256(t4,u3);
    u0 <@ OpsV.iVPMULU_256(h1,r4x5);
    _m0 <@ OpsV.iload4u64(Glob.mem,in_0 + W64.of_int 0);
    u1 <@ OpsV.iVPMULU_256(h2,r4x5);
    r2 <- s_r.[2];
    u2 <@ OpsV.iVPMULU_256(h3,r4x5);
    u3 <@ OpsV.iVPMULU_256(h4,r4x5);
    t0 <@ OpsV.ivadd64u256(t0,u0);
    m1 <@ OpsV.iload4u64(Glob.mem,in_0 + W64.of_int 32);
    t1 <@ OpsV.ivadd64u256(t1,u1);
    t2 <@ OpsV.ivadd64u256(t2,u2);
    t3 <@ OpsV.ivadd64u256(t3,u3);
    u0 <@ OpsV.iVPMULU_256(h0,r2);
    m0 <@ OpsV.iVPERM2I128(_m0,m1,W8.of_int 32);
    u1 <@ OpsV.iVPMULU_256(h1,r2);
    m1 <@ OpsV.iVPERM2I128(_m0,m1,W8.of_int 49);
    u2 <@ OpsV.iVPMULU_256(h2,r2);
    t2 <@ OpsV.ivadd64u256(t2,u0);
    r3x5 <- s_rx5.[(3 - 1)];
    t3 <@ OpsV.ivadd64u256(t3,u1);
    t4 <@ OpsV.ivadd64u256(t4,u2);
    u0 <@ OpsV.iVPMULU_256(h2,r3x5);
    u1 <@ OpsV.iVPMULU_256(h3,r3x5);
    r3 <- s_r.[3];
    h2 <@ OpsV.iVPMULU_256(h4,r3x5);
    m2 <@ OpsV.iVPSRLDQ_256(m0,W8.of_int 6);
    t0 <@ OpsV.ivadd64u256(t0,u0);
    m3 <@ OpsV.iVPSRLDQ_256(m1,W8.of_int 6);
    t1 <@ OpsV.ivadd64u256(t1,u1);
    h2 <@ OpsV.ivadd64u256(h2,t2);
    r2x5 <- s_rx5.[(2 - 1)];
    u0 <@ OpsV.iVPMULU_256(h0,r3);
    u1 <@ OpsV.iVPMULU_256(h1,r3);
    m4 <@ OpsV.iVPUNPCKH_4u64(m0,m1);
    m0 <@ OpsV.iVPUNPCKL_4u64(m0,m1);
    t3 <@ OpsV.ivadd64u256(t3,u0);
    t4 <@ OpsV.ivadd64u256(t4,u1);
    u0 <@ OpsV.iVPMULU_256(h3,r2x5);
    h1 <@ OpsV.iVPMULU_256(h4,r2x5);
    t0 <@ OpsV.ivadd64u256(t0,u0);
    h1 <@ OpsV.ivadd64u256(h1,t1);
    mask26 <- s_mask26;
    u0 <@ OpsV.iVPMULU_256(h4,s_rx5.[(1 - 1)]);
    u1 <@ OpsV.iVPMULU_256(h0,s_r.[4]);
    m3 <@ OpsV.iVPUNPCKL_4u64(m2,m3);
    m2 <@ OpsV.ivshr64u256(m3,(W8.of_int 4));
    h0 <@ OpsV.ivadd64u256(t0,u0);
    z0 <@ OpsV.ivshr64u256(h0,(W8.of_int 26));
    h0 <@ OpsV.iland4u64(h0,mask26);
    h3 <@ OpsV.iland4u64(t3,mask26);
    z1 <@ OpsV.ivshr64u256(t3,(W8.of_int 26));
    h4 <@ OpsV.ivadd64u256(t4,u1);
    m2 <@ OpsV.iland4u64(m2,mask26);
    m1 <@ OpsV.ivshr64u256(m0,(W8.of_int 26));
    h1 <@ OpsV.ivadd64u256(h1,z0);
    h4 <@ OpsV.ivadd64u256(h4,z1);
    z0 <@ OpsV.ivshr64u256(h1,(W8.of_int 26));
    z1 <@ OpsV.ivshr64u256(h4,(W8.of_int 26));
    _z0 <@ OpsV.ivshl64u256(z1,(W8.of_int 2));
    z1 <@ OpsV.ivadd64u256(z1,_z0);
    h1 <@ OpsV.iland4u64(h1,mask26);
    h4 <@ OpsV.iland4u64(h4,mask26);
    h2 <@ OpsV.ivadd64u256(h2,z0);
    h0 <@ OpsV.ivadd64u256(h0,z1);
    z0 <@ OpsV.ivshr64u256(h2,(W8.of_int 26));
    z1 <@ OpsV.ivshr64u256(h0,(W8.of_int 26));
    h2 <@ OpsV.iland4u64(h2,mask26);
    h0 <@ OpsV.iland4u64(h0,mask26);
    h3 <@ OpsV.ivadd64u256(h3,z0);
    h1 <@ OpsV.ivadd64u256(h1,z1);
    z0 <@ OpsV.ivshr64u256(h3,(W8.of_int 26));
    h3 <@ OpsV.iland4u64(h3,mask26);
    h4 <@ OpsV.ivadd64u256(h4,z0);
    in_0 <- (in_0 + (W64.of_int 64));
    m0 <@ OpsV.iland4u64(m0,mask26);
    m3 <@ OpsV.ivshr64u256(m3,(W8.of_int 30));
    m3 <@ OpsV.iland4u64(m3,mask26);
    m4 <@ OpsV.ivshr64u256(m4,(W8.of_int 40));
    m4 <@ OpsV.ilor4u64(m4,s_bit25);
    m1 <@ OpsV.iland4u64(m1,mask26);
    return (Array5.of_list witness [h0;h1;h2;h3;h4],Array5.of_list witness [m0;m1;m2;m3;m4],in_0);
  }
  
  proc final_avx2_v0 (h:vt4u64 Array5.t,m:vt4u64 Array5.t,
                      s_r:vt4u64 Array5.t,s_rx5:vt4u64 Array4.t,
                      s_mask26:vt4u64,s_bit25:vt4u64) : vt4u64 Array5.t = {
    
    var mask26:vt4u64;
    
    h <@ add_mulmod_avx2 (h,m,s_r,s_rx5,s_mask26,s_bit25);
    mask26 <- s_mask26;
    h <@ carry_reduce_avx2 (h,mask26);
    return (h);
  }
  
  proc poly1305_avx2_update (in_0:W64.t,len:W64.t,r4444:vt4u64 Array5.t,
                             r4444x5:vt4u64 Array4.t,r1234:vt4u64 Array5.t,
                             r1234x5:vt4u64 Array4.t) : W64.t * W64.t *
                                                        W64.t Array3.t = {
    var aux: int;
    var hi : vt4u64;
    var h64:W64.t Array3.t;
    var i:int;
    var h:vt4u64 Array5.t;
    var t:vt4u64;
    var s_mask26:vt4u64;
    var mask26:vt4u64;
    var s_bit25:vt4u64;
    var m:vt4u64 Array5.t;
    h <- witness;
    h64 <- witness;
    m <- witness;
    i <- 0;
    while (i < 5) {
      hi <@ OpsV.iVPBROADCAST_4u64(zero_u64);
      h.[i] <- hi;
      i <- i + 1;
    }
    t <@ OpsV.iVPBROADCAST_4u64(mask26_u64);
    s_mask26 <- t;
    mask26 <- t;
    t <@ OpsV.iVPBROADCAST_4u64(bit25_u64);
    s_bit25 <- t;
    (m,in_0) <@ load_avx2 (in_0,mask26,s_bit25);
    
    while (((W64.of_int 128) \ule len)) {
      (h,m,in_0) <@ mainloop_avx2_v1 (h,m,in_0,r4444,r4444x5,s_mask26,
      s_bit25);
      len <- (len - (W64.of_int 64));
    }
    len <- (len - (W64.of_int 64));
    h <@ final_avx2_v0 (h,m,r1234,r1234x5,s_mask26,s_bit25);
    h64 <@ pack_avx2 (h);
    return (in_0,len,h64);
  }
  
  proc poly1305_avx2_wrapper (in_0:W64.t,inlen:W64.t,k:W64.t) : W64.t Array2.t = {
    
    var len:W64.t;
    var h:W64.t Array3.t;
    var r:W64.t Array3.t;
    var r4444:vt4u64 Array5.t;
    var r4444x5:vt4u64 Array4.t;
    var r1234:vt4u64 Array5.t;
    var r1234x5:vt4u64 Array4.t;
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
  
  proc poly1305(in_0:W64.t,inlen:W64.t,k:W64.t) : W64.t Array2.t = {
    
    
    var rr <- witness;
    if ((inlen \ult (W64.of_int 256))) {
      rr <@ Rep3Impl.poly1305 (in_0,inlen,k);
    } else {
      rr <@ poly1305_avx2_wrapper (in_0,inlen,k);
    }
    return rr;
  }
}.

(* --------------------------------------------------------------------------------- *)
(* Poly1305_savx2_prevec <-> Mvec.poly1305                                           *)

require import Poly1305_savx2_prevec.

equiv eq_pack_avx2 : Mprevec.pack_avx2 ~ Mvec.pack_avx2 : is4u64_5 h{1} h{2} ==> ={res}.
proof.
  proc;wp.
  do !(call eq_iVPEXTR_64 || (call eq_itruncate_4u64_2u64 || (call eq_iVEXTRACTI128 || (call eq_iVPERM2I128 || (call eq_ivshl64u256 ||
         (call eq_ivadd64u256 || (call eq_iVPSRLDQ_256 || (call eq_iVPERMQ || (call eq_iVPUNPCKH_4u64 || call eq_iVPUNPCKL_4u64 ))))))))).
  wp; skip => /> &1 &2; rewrite /is4u64_5 /is4u64 => />.
qed.
 
equiv eq_carry_reduce_avx2 :  Mprevec.carry_reduce_avx2 ~ Mvec.carry_reduce_avx2 : 
  is4u64_5 x{1} x{2} /\ is4u64 mask26{1} mask26{2} ==> is4u64_5 res{1} res{2}.
proof.
  proc;wp.  
  do !((call eq_ivadd64u256 || call eq_iland4u64) || ((call eq_ivshr64u256 || call eq_ivadd64u256) || call eq_ivshl64u256)). 
  wp; skip => />.
  by rewrite /is4u64_5 /is4u64 => /> *; 
     apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
qed.

equiv eq_add_mulmod_avx2 :  Mprevec.add_mulmod_avx2 ~ Mvec.add_mulmod_avx2 : 
  is4u64_5 h{1} h{2} /\ is4u64_5 m{1} m{2} /\ is4u64_5 s_r{1} s_r{2} /\ is4u64_4 s_rx5{1} s_rx5{2} /\ is4u64 s_mask26{1} s_mask26{2} /\ is4u64 s_bit25{1} s_bit25{2} ==>
  is4u64_5 res{1} res{2}.
proof.
  proc;wp.
  do ! (do !(call eq_ivadd64u256 || (call eq_iVPMULU_256));wp); skip => />.
  rewrite /is4u64_5 /is4u64_4 /is4u64 => /> *.
  by apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
qed.

equiv eq_mainloop_avx2_v1 in_1 :  Mprevec.mainloop_avx2_v1 ~ Mvec.mainloop_avx2_v1 : 
  ={in_0, Glob.mem} /\ is4u64_5 h{1} h{2} /\ is4u64_5 m{1} m{2} /\ is4u64_5 s_r{1} s_r{2} /\ is4u64_4 s_rx5{1} s_rx5{2} /\ is4u64 s_mask26{1} s_mask26{2} /\ is4u64 s_bit25{1} s_bit25{2} /\ W64.to_uint in_0{1} = in_1 /\ in_1 + 64 < W64.modulus ==>
  is4u64_5 res{1}.`1 res{2}.`1 /\
  is4u64_5 res{1}.`2 res{2}.`2 /\
  res{1}.`3 = res{2}.`3 /\ ={Glob.mem} /\ W64.to_uint res{1}.`3 = in_1 + 64.
proof.
  proc.
  do !(do !(call eq_iland4u64 || (call eq_ilor4u64 || (call eq_ivshr64u256 || (call eq_ivadd64u256 ||
     (call eq_ivshl64u256 || (call eq_iVPUNPCKL_4u64 || (call eq_iVPMULU_256 || (call eq_iVPUNPCKH_4u64 || 
     (call eq_iVPSRLDQ_256 || (call eq_iVPERM2I128 || (call eq_iload4u64)))))))))));wp).
  skip; rewrite /is4u64_5 /is4u64_4 /is4u64 => /> *.
  split;1:smt(); move=> ?;split.
  + rewrite W64.to_uintD_small /= /#.
  move=> *; split.
  + by apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
  split.
  + by apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
  by rewrite W64.to_uintD_small.
qed.

equiv eq_load_avx2 in_1 : Mprevec.load_avx2 ~ Mvec.load_avx2 : 
  ={in_0, Glob.mem} /\ is4u64 mask26{1} mask26{2} /\ is4u64 s_bit25{1} s_bit25{2} /\ W64.to_uint in_0{1} = in_1 /\ in_1 + 64 < W64.modulus ==>
  is4u64_5 res{1}.`1 res{2}.`1 /\
  res{1}.`2 = res{2}.`2 /\ ={Glob.mem} /\ W64.to_uint res{1}.`2 = in_1 + 64.
proof.
  proc.
  do !(call eq_iland4u64 || (call eq_ilor4u64 || (call eq_ivshr64u256 || (call eq_iVPUNPCKL_4u64 || (call eq_iVPUNPCKH_4u64 ||
       (call eq_iVPSRLDQ_256 || (call eq_iVPERM2I128))))))); wp.
  do 2! call eq_iload4u64; wp; skip => />.
  rewrite /is4u64_5 /is4u64_4 /is4u64 => /> *.
  split;1:smt(); move=> *.
  rewrite to_uintD_small /= 1:/#;split;1:smt();move=> *;split.
  + by apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
  by rewrite to_uintD_small /=.
qed.

equiv eq_poly1305_avx2_update : Mprevec.poly1305_avx2_update ~ Mvec.poly1305_avx2_update : 
  ={in_0, Glob.mem, len} /\ is4u64_5 r4444{1} r4444{2} /\ is4u64_4 r4444x5{1} r4444x5{2} /\
    is4u64_5 r1234{1} r1234{2} /\ is4u64_4 r1234x5{1} r1234x5{2} /\ 256 <= to_uint len{1} /\ to_uint in_0{1} + to_uint len{1} < W64.modulus ==>
  ={res}.
proof.
  proc.
  call eq_pack_avx2.
  inline Mprevec.final_avx2_v0 Mvec.final_avx2_v0; wp.
  call eq_carry_reduce_avx2;wp.
  call eq_add_mulmod_avx2;wp => /=.
  while (={len, in_0, Glob.mem} /\ is4u64_5 h{1} h{2} /\ is4u64_5 m{1} m{2} /\ is4u64_5 r4444{1} r4444{2} /\ is4u64_4 r4444x5{1} r4444x5{2} /\
         is4u64 s_mask26{1} s_mask26{2} /\ is4u64 s_bit25{1} s_bit25{2} /\ to_uint in_0{1} + to_uint len{1} - 64 < W64.modulus).
  + wp.
    ecall (eq_mainloop_avx2_v1 (to_uint in_0{1})); skip => /> &1 &2.
    rewrite W64.uleE /= => *;split;1:smt().
    by move=> ? [???] [???] /> *; rewrite to_uintB 1:uleE /= /#.
  ecall (eq_load_avx2 (to_uint in_0{1})); wp. 
  call eq_iVPBROADCAST_4u64;wp.
  call eq_iVPBROADCAST_4u64.
  unroll for{1} ^while. unroll for{2} ^while.
  do !(wp; call eq_iVPBROADCAST_4u64).
  wp;skip => />.
  rewrite /is4u64_5 /is4u64_4 /is4u64 => /> *.
  split;1:smt().
  move=> ? [??] [??] /> *;split;2:smt().
  by apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
qed.

 
equiv eq_broadcast_r4 : Mprevec.broadcast_r4 ~ Mvec.broadcast_r4 : 
   is4u64_5 r1234{1} r1234{2} /\ is4u64_4 r1234x5{1} r1234x5{2} ==>
   is4u64_5 res{1}.`1 res{2}.`1 /\
   is4u64_4 res{1}.`2 res{2}.`2.
proof.
  proc.
  do 2!unroll for{1} ^while; do 2!unroll for{2} ^while.
  do !(wp;(call eq_iVPBROADCAST_4u64 || (call eq_get_128 || (call eq_get_160))));wp; skip => />.
  rewrite /is4u64_5 /is4u64_4 /is4u64 => /> *;split.
  + by apply Array5.all_eq_eq;rewrite /Array5.all_eq /=.
  by apply Array4.all_eq_eq;rewrite /Array4.all_eq /=.
qed.

equiv eq_times_5 : Mprevec.times_5 ~ Mvec.times_5 : is4u64_5 r1234{1} r1234{2} ==> is4u64_4 res{1} res{2}.
proof.
  proc.
  unroll for{1} ^while; unroll for{2} ^while.
  do !(wp;(call eq_iVPMULU_256 || call eq_iVPBROADCAST_4u64)); wp; skip => />.
  rewrite /is4u64_5 /is4u64_4 /is4u64 => /> *.
  by apply Array4.all_eq_eq;rewrite /Array4.all_eq /=.
qed.

lemma get64_pack32u8 ws o : 0 <= o < 4 => 
  W32u8.pack32_t ws \bits64 o = W8u8.pack8_t (W8u8.Pack.init (fun i => ws.[ 8 * o + i])).
proof.
  move=> ho;rewrite W4u64.bits64E; apply W64.wordP => i hi.
  rewrite initiE 1:// /= pack8wE 1:// initiE /=.
  + by rewrite lez_divRL 1:// ltz_divLR //.
  rewrite pack32wE 1:/#;smt(edivzP).
qed.

lemma bits64_bits8 (w:W256.t) o k:
   0 <= o < 4 => 0 <= k < 8 =>
   w \bits64 o \bits8 k = w \bits8 8 * o + k.
proof.
  move=> ho hk; rewrite !bits8E bits64E.
  apply W8.wordP => i hi.
  rewrite !W8.initiE 1,2:// /= W64.initiE 1:/# /=;congr;ring.
qed.

equiv eq_set_160_1 vv_1 vv_2 i0 o0 : Ops.set_160 ~ OpsV.set_160 : 
  ={i,o,v} /\ 0 <= i{1} < 5 /\ 0 <= o{1} < 4 /\ vv{1} = vv_1 /\ vv{2} = vv_2 /\ i{1} = i0 /\ o{1} = o0 ==>
  res{1}.[i0].[o0] = res{2}.[i0] \bits64 o0 /\
  (forall i1 o1, 
     0 <= i1 < 5 => 0 <= o1 < 4 => 
     (i1 <> i0 \/ o1 <> o0) => 
     res{1}.[i1].[o1] = vv_1.[i1].[o1] /\ res{2}.[i1] \bits64 o1 = vv_2.[i1] \bits64 o1).
proof.
  proc; skip => /> &1 &2 *.
  split.
  + rewrite initiE 1:/# /= get256E.
    rewrite get_setE 1:// /= get_setE 1:// /= get64_pack32u8 1://.
    rewrite -unpack8K;congr.
    apply W8u8.Pack.packP => k hk; rewrite !W8u8.Pack.initiE 1,2:// /=.
    rewrite W32u8.Pack.initiE 1:/# /=.
    rewrite /get64 set64E /init256 WArray160.initiE 1:/# /= /unpack8 !initiE 1,2:/# /=. 
    by smt(edivzP).
  move=> i1 o1 h5 h6 h7 h8 h9; split.
  + smt (Array5.get_setE Array4.get_setE).
  rewrite initiE 1:/# /= get256E get64_pack32u8 1:/# -(W8u8.unpack8K (vv_2.[i1] \bits64 _)); congr.
  apply W8u8.Pack.packP => k hk; rewrite W8u8.Pack.initiE 1:// /unpack8 /= initiE 1:/# /= initiE 1://.
  rewrite set64E WArray160.initiE 1:/# /= /init256 WArray160.initiE 1:/# /= bits64_bits8 1,2://.
  smt (edivzP).
qed.

equiv eq_unpack r1234_1 r1234_2 o0: 
  Mprevec.unpack ~ Mvec.unpack : ={rt,o} /\ 0 <= o{1} < 4 /\ o{1} = o0 /\ r1234{1} = r1234_1 /\ r1234{2} = r1234_2 ==> 
  forall i, 0 <= i < 5 =>
    res{1}.[i].[o0] = res{2}.[i] \bits64 o0 /\
    forall o1, 0 <= o1 < 4 => o1 <> o0 => 
       res{1}.[i].[o1] = r1234_1.[i].[o1] /\
       res{2}.[i] \bits64 o1 = r1234_2.[i] \bits64 o1.
proof.
  proc.
  ecall (eq_set_160_1 r1234{1} r1234{2} 4 o{1}); wp => /=.
  ecall (eq_set_160_1 r1234{1} r1234{2} 3 o{1}); wp => /=.
  ecall (eq_set_160_1 r1234{1} r1234{2} 2 o{1}); wp => /=.
  ecall (eq_set_160_1 r1234{1} r1234{2} 1 o{1}); wp => /=.
  ecall (eq_set_160_1 r1234{1} r1234{2} 0 o{1}); wp => /=.
  skip => /> /#.
qed.

equiv eq_mulmod : Mprevec.Rep3Impl.mulmod ~ Mvec.Rep3Impl.mulmod : ={h,r} ==> ={res}.
proof. by sim. qed.

equiv eq_poly1305_avx2_setup : Mprevec.poly1305_avx2_setup ~ Mvec.poly1305_avx2_setup : 
   ={r} ==> 
   is4u64_5 res{1}.`1 res{2}.`1 /\
   is4u64_4 res{1}.`2 res{2}.`2 /\
   is4u64_5 res{1}.`3 res{2}.`3 /\
   is4u64_4 res{1}.`4 res{2}.`4.
proof.
  proc.
  call eq_broadcast_r4; call eq_times_5.
  do 2!unroll for{1} ^while;do 2!unroll for{2} ^while.
  do 3!(wp; ecall (eq_unpack r1234{1} r1234{2} (2-i{1}));call eq_mulmod).
  wp; ecall (eq_unpack r1234{1} r1234{2} 3);wp; skip => />.
  move=> r13 r23 h3 r12 r22 h2 r11 r21 h1 r10 r20 h0.
  rewrite /is4u64_5.
  apply Array5.tP => i hi;rewrite Array5.initiE 1:// /=.
  rewrite -(unpack64K r20.[i]); congr.
  apply W4u64.Pack.packP => j hj.
  rewrite /unpack64 /= initiE 1://.
  have /=  := W4u64.Pack.init_of_list (fun j => r10.[i].[j]);rewrite -iotaredE /= => <-.
  rewrite initiE 1:// /= /#.
qed.

equiv prevec_vec : Mprevec.poly1305 ~ Mvec.poly1305 : ={Glob.mem, in_0, inlen, k} /\ (to_uint in_0 + to_uint inlen){1} < W64.modulus ==> ={res,Glob.mem}.
proof.
  proc => /=; seq 1 1 : #pre; 1: by auto.
  if => //; 1: sim.
  call (_: ={Glob.mem, in_0, inlen, k} /\ (to_uint in_0 + to_uint inlen < W64.modulus /\ 256 <= to_uint inlen){1} ==> ={res,Glob.mem}); last first.
  + skip => /> &2;rewrite ultE /=  /#.
  proc; sim 10 10. 
  call eq_poly1305_avx2_update.
  call eq_poly1305_avx2_setup => /=.
  by call (_: ={Glob.mem}); 1:(by sim); wp; skip.
qed.
 
require import Poly1305_savx2.

equiv veceq : 
    Mvec.poly1305 ~ M.poly1305_avx2 : ={Glob.mem, in_0, inlen, k} ==> ={res,Glob.mem}.
proof.
proc => /=; seq 1 1: #pre; 1: by auto.
if => //=; first by sim. 
call (_: ={Glob.mem}); last by auto => />.
seq 8 8 : (={Glob.mem,h,r,k,in_0,inlen,len});first by sim.
seq 1 1 : (#pre /\ ={r4444,r4444x5,r1234,r1234x5}).
inline Mvec.poly1305_avx2_setup M.poly1305_avx2_setup.
wp;call(_: ={Glob.mem}).
inline *.
unroll for {1} 6.
unroll for {2} 7.
unroll for {1} 4.
unroll for {2} 5.
by auto => />.
conseq />. 
wp;call(_: ={Glob.mem}).
inline *.
unroll for {1} 5.
unroll for {2} 4.
by auto => />.
conseq />. 
unroll for {1} 12.
unroll for {1} 8.
unroll for {2} 8.
unroll for {2} 34.
seq 21 78: (={r12340,rt,i}); last by 
 inline Mvec.unpack OpsV.set_160; auto => />. 
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
conseq />.
seq 18 56: (={r12340,rt,i,r0}); last by 
 inline Mvec.unpack OpsV.set_160; auto => />. 
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
conseq />.
seq 15 34: (={r12340,rt,i,r0}); last by 
 inline Mvec.unpack OpsV.set_160; auto => />. 
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
conseq />.
seq 12 12: (={r12340,rt,i,r0}); last by 
 inline Mvec.unpack OpsV.set_160; auto => />. 
by sim.

inline Mvec.Rep3Impl.finish M.poly1305_ref3_last.
seq 11 11 : ( ={h2,Glob.mem,h0,k0,s}); last first.
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
by auto => />.
seq 2 2 : #pre. 
inline Mvec.Rep3Impl.update  M.poly1305_ref3_update.
seq 1 1 : #pre. 
wp;call(_: ={Glob.mem}). 
conseq />. 
wp;call(_: ={Glob.mem}).
+ by inline *; auto => /> *;apply Array3.all_eq_eq; rewrite /Array3.all_eq /=. 
wp;call(_: ={Glob.mem}).
+ by inline *; auto => /> *;apply Array5.all_eq_eq; rewrite /Array5.all_eq /=. 
seq 11 11 : (#pre /\ ={s_mask26,s_bit25,h,m}).
unroll for {1} 5.
unroll for {2} 5.
wp;call(_: ={Glob.mem}); first by inline *; auto => /> *; apply Array5.all_eq_eq; rewrite /Array5.all_eq /=. 
by inline *;auto => />.
wp.
while (#pre).
+ by inline *; auto => /> *; do split; 
   apply Array5.all_eq_eq; rewrite /Array5.all_eq /=. 
by auto => />.
by auto => />.
wp;while(#pre /\ ={inlen1,h1,in_01,r1}).
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
wp;call(_: ={Glob.mem}); first by inline *; auto => />.
by auto => />.      
by auto => />.      
seq 7 7 : (#pre /\ ={in_00,inlen0,k0,h0,r0,h2,s}); first by auto => />.
if  => //=.
wp;call(_: ={Glob.mem}); first by  sim.
wp;call(_: ={Glob.mem}); first by sim.
wp;call(_: ={Glob.mem}); first by sim.
by auto => />.
by sim.
qed.

require import Poly1305_spec Poly1305_hop1 Poly1305_hop2 Poly1305_hop3.

equiv eq_mspec_savx2 : Mspec.poly1305 ~ Poly1305_savx2.M.poly1305_avx2 :
   ={Glob.mem, in_0, inlen, k} /\ (inv_ptr (to_uint k) (to_uint in_0) (to_uint inlen)){1} ==> ={res,Glob.mem}.
proof.
  transitivity Mhop1.poly1305 
    (={Glob.mem, in_0, inlen, k} ==> ={res,Glob.mem})
    (={Glob.mem, in_0, inlen, k} /\ (inv_ptr (to_uint k) (to_uint in_0) (to_uint inlen)){1}  ==> ={res,Glob.mem}).
  + smt(). +done. +by apply hop1eq.
  transitivity Mhop2.poly1305 
    (={Glob.mem, in_0, inlen, k} ==> ={res,Glob.mem})
    (={Glob.mem, in_0, inlen, k} /\ (inv_ptr (to_uint k) (to_uint in_0) (to_uint inlen)){1} ==> ={res,Glob.mem}).
  + smt (). + done. + by apply hop2eq.
  transitivity Mhop3.poly1305 
    (={Glob.mem, in_0, inlen, k} /\ (inv_ptr (to_uint k) (to_uint in_0) (to_uint inlen)){2} ==> ={res,Glob.mem})
    (={Glob.mem, in_0, inlen, k} /\ (inv_ptr (to_uint k) (to_uint in_0) (to_uint inlen)){1} ==> ={res,Glob.mem}).
  + smt(). + done. + by apply Poly1305_hop3.hop3eq.
  transitivity Mprevec.poly1305
    (={Glob.mem, in_0, inlen, k} ==> ={res,Glob.mem})
    (={Glob.mem, in_0, inlen, k} /\ (inv_ptr (to_uint k) (to_uint in_0) (to_uint inlen)){1} ==> ={res,Glob.mem}).
  + smt(). + done. + by apply Poly1305_savx2_prevec.hop3_savx2prevec_eq.
  transitivity Mvec.poly1305
    (={Glob.mem, in_0, inlen, k} /\ (to_uint in_0 + to_uint inlen){1} < W64.modulus ==> ={res,Glob.mem})
    (={Glob.mem, in_0, inlen, k} ==> ={res,Glob.mem}).
  + rewrite/inv_ptr; smt(). + done. + by apply prevec_vec.
  by apply veceq.
qed.

lemma avx2_corr mem rr ss mm inn inl kk :
  phoare [ M.poly1305_avx2 : 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem ] = 1%r.
proof.
  bypr; rewrite /inv_ptr => &m H. 
  have <- : 
    Pr[Mspec.poly1305(in_0{m}, inlen{m}, k{m}) @ &m : poly1305_post rr ss mm res mem Glob.mem] =
    Pr[M.poly1305_avx2(in_0{m}, inlen{m}, k{m}) @ &m : poly1305_post rr ss mm res mem Glob.mem].
  + by move: H => /> *; byequiv eq_mspec_savx2; progress. 
  + byphoare (Poly1305_spec.corr mem rr ss mm inn inl kk); smt().
qed.
