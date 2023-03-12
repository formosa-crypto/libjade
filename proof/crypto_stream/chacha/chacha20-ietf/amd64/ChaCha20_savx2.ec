require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel.

require import Array2 Array4 Array8 Array16.
require import WArray16 WArray64 WArray128 WArray256 WArray512.

abbrev g_p0 = W128.of_int 0.


abbrev g_sigma3 = W32.of_int 1797285236.


abbrev g_sigma2 = W32.of_int 2036477234.


abbrev g_sigma1 = W32.of_int 857760878.


abbrev g_sigma0 = W32.of_int 1634760805.


abbrev g_sigma = W128.of_int 142395606799862307709414285570774956133.


abbrev g_p2 = W256.of_int 680564733841876926926749214863536422914.


abbrev g_p1 = W256.of_int 340282366920938463463374607431768211456.


abbrev g_cnt_inc = W256.of_int 215679573387421932252121579908212843056389298378842373074615151886344.


abbrev g_cnt = W256.of_int 188719626707717088982296698380167795313645871959412740063448560304128.


abbrev g_r8 = W256.of_int 6355432118420048154175784972596847518577147054203239762089463134348153782275.


abbrev g_r16 = W256.of_int 5901373100945378232718128989223044758631764214521116316503579100742837863170.


module M = {
  proc load_shufb_cmd () : W256.t * W256.t = {
    
    var s_r16:W256.t;
    var s_r8:W256.t;
    var r16:W256.t;
    var r8:W256.t;
    
    r16 <- g_r16;
    r8 <- g_r8;
    s_r16 <- r16;
    s_r8 <- r8;
    return (s_r16, s_r8);
  }
  
  proc init_x2 (key:W64.t, nonce:W64.t, counter:W32.t) : W256.t Array4.t = {
    
    var st:W256.t Array4.t;
    var nc:W128.t;
    var s_nc:W128.t;
    st <- witness;
    nc <- g_p0;
    nc <- VPINSR_4u32 nc counter (W8.of_int 0);
    nc <- VPINSR_4u32 nc
    (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int 0)))) (W8.of_int 1);
    nc <- VPINSR_2u64 nc
    (loadW64 Glob.mem (W64.to_uint (nonce + (W64.of_int 4)))) (W8.of_int 1);
    s_nc <- nc;
    st.[0] <- VPBROADCAST_2u128 g_sigma;
    st.[1] <-
    VPBROADCAST_2u128 (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 0))));
    st.[2] <-
    VPBROADCAST_2u128 (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 16))));
    st.[3] <- VPBROADCAST_2u128 s_nc;
    st.[3] <- (st.[3] \vadd32u256 g_p1);
    return (st);
  }
  
  proc init_x8 (key:W64.t, nonce:W64.t, counter:W32.t) : W256.t Array16.t = {
    var aux: int;
    
    var st_:W256.t Array16.t;
    var s_counter:W32.t;
    var st:W256.t Array16.t;
    var i:int;
    st <- witness;
    st_ <- witness;
    s_counter <- counter;
    st.[0] <- VPBROADCAST_8u32 g_sigma0;
    st.[1] <- VPBROADCAST_8u32 g_sigma1;
    st.[2] <- VPBROADCAST_8u32 g_sigma2;
    st.[3] <- VPBROADCAST_8u32 g_sigma3;
    i <- 0;
    while (i < 8) {
      st.[(i + 4)] <-
      VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    st.[12] <- VPBROADCAST_8u32 s_counter;
    st.[12] <- (st.[12] \vadd32u256 g_cnt);
    i <- 0;
    while (i < 3) {
      st.[(i + 13)] <-
      VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    st_ <- copy_256 st;
    return (st_);
  }
  
  proc copy_state_x2 (st:W256.t Array4.t) : W256.t Array4.t = {
    
    var k:W256.t Array4.t;
    k <- witness;
    k <- copy_256 st;
    return (k);
  }
  
  proc copy_state_x4 (st:W256.t Array4.t) : W256.t Array4.t * W256.t Array4.t = {
    
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    k1 <- copy_256 st;
    k2 <- copy_256 st;
    k2.[3] <- (k2.[3] \vadd32u256 g_p2);
    return (k1, k2);
  }
  
  proc copy_state_x8 (st:W256.t Array16.t) : W256.t Array16.t = {
    
    var k:W256.t Array16.t;
    k <- witness;
    k <- copy_256 st;
    return (k);
  }
  
  proc sum_states_x2 (k:W256.t Array4.t, st:W256.t Array4.t) : W256.t Array4.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <- (k.[i] \vadd32u256 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc sum_states_x4 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                      st:W256.t Array4.t) : W256.t Array4.t * W256.t Array4.t = {
    
    
    
    k1 <@ sum_states_x2 (k1, st);
    k2 <@ sum_states_x2 (k2, st);
    k2.[3] <- (k2.[3] \vadd32u256 g_p2);
    return (k1, k2);
  }
  
  proc sum_states_x8 (k:W256.t Array16.t, st:W256.t Array16.t) : W256.t Array16.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 16) {
      k.[i] <- (k.[i] \vadd32u256 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc increment_counter_x8 (s:W256.t Array16.t) : W256.t Array16.t = {
    
    var t:W256.t;
    
    t <- g_cnt_inc;
    t <- (t \vadd32u256 s.[12]);
    s.[12] <- t;
    return (s);
  }
  
  proc update_ptr (output:W64.t, plain:W64.t, len:W32.t, n:int) : W64.t *
                                                                  W64.t *
                                                                  W32.t = {
    
    
    
    output <- (output + (W64.of_int n));
    plain <- (plain + (W64.of_int n));
    len <- (len - (W32.of_int n));
    return (output, plain, len);
  }
  
  proc perm_x2 (k:W256.t Array4.t) : W256.t Array4.t = {
    
    var pk:W256.t Array4.t;
    pk <- witness;
    pk.[0] <- VPERM2I128 k.[0] k.[1] (W8.of_int (0 %% 2^4 + 2^4 * 2));
    pk.[1] <- VPERM2I128 k.[2] k.[3] (W8.of_int (0 %% 2^4 + 2^4 * 2));
    pk.[2] <- VPERM2I128 k.[0] k.[1] (W8.of_int (1 %% 2^4 + 2^4 * 3));
    pk.[3] <- VPERM2I128 k.[2] k.[3] (W8.of_int (1 %% 2^4 + 2^4 * 3));
    return (pk);
  }
  
  proc perm_x4 (k1:W256.t Array4.t, k2:W256.t Array4.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    
    var pk1:W256.t Array4.t;
    var pk2:W256.t Array4.t;
    pk1 <- witness;
    pk2 <- witness;
    pk1 <@ perm_x2 (k1);
    pk2 <@ perm_x2 (k2);
    return (pk1, pk2);
  }
  
  proc store (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array2.t) : 
  W64.t * W64.t * W32.t * W256.t Array2.t = {
    
    
    
    k.[0] <-
    (k.[0] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
    k.[1] <-
    (k.[1] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int 32)))));
    Glob.mem <-
    storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (k.[0]);
    Glob.mem <-
    storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 32))) (k.[1]);
    (output, plain, len) <@ update_ptr (output, plain, len, 64);
    return (output, plain, len, k);
  }
  
  proc store_last (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array2.t) : unit = {
    
    var r0:W256.t;
    var r1:W128.t;
    var s0:W8.t Array16.t;
    var j:W64.t;
    var r3:W8.t;
    s0 <- witness;
    r0 <- k.[0];
    if (((W32.of_int 32) \ule len)) {
      r0 <-
      (r0 `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (r0);
      (output, plain, len) <@ update_ptr (output, plain, len, 32);
      r0 <- k.[1];
    } else {
      
    }
    r1 <- VEXTRACTI128 r0 (W8.of_int 0);
    if (((W32.of_int 16) \ule len)) {
      r1 <-
      (r1 `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (r1);
      (output, plain, len) <@ update_ptr (output, plain, len, 16);
      r1 <- VEXTRACTI128 r0 (W8.of_int 1);
    } else {
      
    }
    s0 <-
    Array16.init
    (WArray16.get8 (WArray16.set128 (WArray16.init8 (fun i => s0.[i])) 0 (r1)));
    j <- (W64.of_int 0);
    
    while (((truncateu32 j) \ult len)) {
      r3 <- (loadW8 Glob.mem (W64.to_uint (plain + j)));
      r3 <- (r3 `^` s0.[(W64.to_uint j)]);
      Glob.mem <- storeW8 Glob.mem (W64.to_uint (output + j)) (r3);
      j <- (j + (W64.of_int 1));
    }
    return ();
  }
  
  proc store_x2 (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array4.t) : 
  W64.t * W64.t * W32.t * W256.t Array4.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <-
      (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (32 * i))))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (
      k.[i]);
      i <- i + 1;
    }
    (output, plain, len) <@ update_ptr (output, plain, len, 128);
    return (output, plain, len, k);
  }
  
  proc store_x2_last (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array4.t) : unit = {
    
    var r:W256.t Array2.t;
    r <- witness;
    r.[0] <- k.[0];
    r.[1] <- k.[1];
    if (((W32.of_int 64) \ule len)) {
      (output, plain, len, r) <@ store (output, plain, len, r);
      r.[0] <- k.[2];
      r.[1] <- k.[3];
    } else {
      
    }
    store_last (output, plain, len, r);
    return ();
  }
  
  proc store_x4 (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array8.t) : 
  W64.t * W64.t * W32.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 8) {
      k.[i] <-
      (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (32 * i))))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (
      k.[i]);
      i <- i + 1;
    }
    (output, plain, len) <@ update_ptr (output, plain, len, 256);
    return (output, plain, len);
  }
  
  proc store_x4_last (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array8.t) : unit = {
    var aux: int;
    
    var i:int;
    var r:W256.t Array4.t;
    r <- witness;
    i <- 0;
    while (i < 4) {
      r.[i] <- k.[i];
      i <- i + 1;
    }
    if (((W32.of_int 128) \ule len)) {
      (output, plain, len, r) <@ store_x2 (output, plain, len, r);
      i <- 0;
      while (i < 4) {
        r.[i] <- k.[(i + 4)];
        i <- i + 1;
      }
    } else {
      
    }
    store_x2_last (output, plain, len, r);
    return ();
  }
  
  proc store_half_x8 (output:W64.t, plain:W64.t, len:W32.t,
                      k:W256.t Array8.t, o:int) : unit = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 8) {
      k.[i] <-
      (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (o + (64 * i)))))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) (
      k.[i]);
      i <- i + 1;
    }
    return ();
  }
  
  proc sub_rotate (t:W256.t Array8.t) : W256.t Array8.t = {
    var aux: int;
    
    var x:W256.t Array8.t;
    var i:int;
    x <- witness;
    x.[0] <- VPUNPCKL_4u64 t.[0] t.[1];
    x.[1] <- VPUNPCKL_4u64 t.[2] t.[3];
    x.[2] <- VPUNPCKH_4u64 t.[0] t.[1];
    x.[3] <- VPUNPCKH_4u64 t.[2] t.[3];
    x.[4] <- VPUNPCKL_4u64 t.[4] t.[5];
    x.[5] <- VPUNPCKL_4u64 t.[6] t.[7];
    x.[6] <- VPUNPCKH_4u64 t.[4] t.[5];
    x.[7] <- VPUNPCKH_4u64 t.[6] t.[7];
    i <- 0;
    while (i < 4) {
      t.[i] <- VPERM2I128 x.[((2 * i) + 0)] x.[((2 * i) + 1)]
      (W8.of_int (0 %% 2^4 + 2^4 * 2));
      t.[(i + 4)] <- VPERM2I128 x.[((2 * i) + 0)] x.[((2 * i) + 1)]
      (W8.of_int (1 %% 2^4 + 2^4 * 3));
      i <- i + 1;
    }
    return (t);
  }
  
  proc rotate (x:W256.t Array8.t) : W256.t Array8.t = {
    var aux: int;
    
    var t:W256.t Array8.t;
    var i:int;
    t <- witness;
    i <- 0;
    while (i < 4) {
      t.[i] <- VPUNPCKL_8u32 x.[((2 * i) + 0)] x.[((2 * i) + 1)];
      t.[(i + 4)] <- VPUNPCKH_8u32 x.[((2 * i) + 0)] x.[((2 * i) + 1)];
      i <- i + 1;
    }
    t <@ sub_rotate (t);
    return (t);
  }
  
  proc rotate_stack (s:W256.t Array8.t) : W256.t Array8.t = {
    var aux: int;
    
    var t:W256.t Array8.t;
    var i:int;
    var x:W256.t Array8.t;
    t <- witness;
    x <- witness;
    i <- 0;
    while (i < 4) {
      x.[i] <- s.[((2 * i) + 0)];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      t.[i] <- VPUNPCKL_8u32 x.[i] s.[((2 * i) + 1)];
      t.[(4 + i)] <- VPUNPCKH_8u32 x.[i] s.[((2 * i) + 1)];
      i <- i + 1;
    }
    t <@ sub_rotate (t);
    return (t);
  }
  
  proc rotate_first_half_x8 (k:W256.t Array16.t) : W256.t Array8.t *
                                                   W256.t Array8.t = {
    var aux: int;
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var i:int;
    k0_7 <- witness;
    s_k8_15 <- witness;
    i <- 0;
    while (i < 8) {
      s_k8_15.[i] <- k.[(8 + i)];
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      k0_7.[i] <- k.[i];
      i <- i + 1;
    }
    k0_7 <@ rotate (k0_7);
    return (k0_7, s_k8_15);
  }
  
  proc rotate_second_half_x8 (s_k8_15:W256.t Array8.t) : W256.t Array8.t = {
    
    var k8_15:W256.t Array8.t;
    k8_15 <- witness;
    k8_15 <@ rotate_stack (s_k8_15);
    return (k8_15);
  }
  
  proc interleave_0 (s:W256.t Array8.t, k:W256.t Array8.t, o:int) : W256.t Array8.t = {
    var aux: int;
    
    var sk:W256.t Array8.t;
    var i:int;
    sk <- witness;
    i <- 0;
    while (i < 4) {
      sk.[((2 * i) + 0)] <- s.[(o + i)];
      sk.[((2 * i) + 1)] <- k.[(o + i)];
      i <- i + 1;
    }
    return (sk);
  }
  
  proc store_x8 (output:W64.t, plain:W64.t, len:W32.t, k:W256.t Array16.t) : 
  W64.t * W64.t * W32.t = {
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ rotate_first_half_x8 (k);
    store_half_x8 (output, plain, len, k0_7, 0);
    k8_15 <@ rotate_second_half_x8 (s_k8_15);
    store_half_x8 (output, plain, len, k8_15, 32);
    (output, plain, len) <@ update_ptr (output, plain, len, 512);
    return (output, plain, len);
  }
  
  proc store_x8_last (output:W64.t, plain:W64.t, len:W32.t,
                      k:W256.t Array16.t) : unit = {
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var s_k0_7:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    var i0_7:W256.t Array8.t;
    i0_7 <- witness;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k0_7 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ rotate_first_half_x8 (k);
    s_k0_7 <- copy_256 k0_7;
    k8_15 <@ rotate_second_half_x8 (s_k8_15);
    i0_7 <@ interleave_0 (s_k0_7, k8_15, 0);
    if (((W32.of_int 256) \ule len)) {
      (output, plain, len) <@ store_x4 (output, plain, len, i0_7);
      i0_7 <@ interleave_0 (s_k0_7, k8_15, 4);
    } else {
      
    }
    store_x4_last (output, plain, len, i0_7);
    return ();
  }
  
  proc rotate_x8 (k:W256.t Array4.t, i:int, r:int, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    
    var t:W256.t;
    
    if ((r = 16)) {
      k.[i] <- VPSHUFB_256 k.[i] r16;
    } else {
      if ((r = 8)) {
        k.[i] <- VPSHUFB_256 k.[i] r8;
      } else {
        t <- (k.[i] \vshl32u256 (W8.of_int r));
        k.[i] <- (k.[i] \vshr32u256 (W8.of_int (32 - r)));
        k.[i] <- (k.[i] `^` t);
      }
    }
    return (k);
  }
  
  proc line_x8 (k:W256.t Array4.t, a:int, b:int, c:int, r:int, r16:W256.t,
                r8:W256.t) : W256.t Array4.t = {
    
    
    
    k.[(a %/ 4)] <- (k.[(a %/ 4)] \vadd32u256 k.[(b %/ 4)]);
    k.[(c %/ 4)] <- (k.[(c %/ 4)] `^` k.[(a %/ 4)]);
    k <@ rotate_x8 (k, (c %/ 4), r, r16, r8);
    return (k);
  }
  
  proc round_x2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    
    
    
    k <@ line_x8 (k, 0, 4, 12, 16, r16, r8);
    k <@ line_x8 (k, 8, 12, 4, 12, r16, r8);
    k <@ line_x8 (k, 0, 4, 12, 8, r16, r8);
    k <@ line_x8 (k, 8, 12, 4, 7, r16, r8);
    return (k);
  }
  
  proc column_round_x2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    
    
    
    k <@ round_x2 (k, r16, r8);
    return (k);
  }
  
  proc shuffle_state (k:W256.t Array4.t) : W256.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_256 k.[1]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    k.[2] <- VPSHUFD_256 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_256 k.[3]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    return (k);
  }
  
  proc reverse_shuffle_state (k:W256.t Array4.t) : W256.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_256 k.[1]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    k.[2] <- VPSHUFD_256 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_256 k.[3]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    return (k);
  }
  
  proc diagonal_round_x2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    
    
    
    k <@ shuffle_state (k);
    k <@ round_x2 (k, r16, r8);
    k <@ reverse_shuffle_state (k);
    return (k);
  }
  
  proc rounds_x2 (k:W256.t Array4.t) : W256.t Array4.t = {
    
    var r16:W256.t;
    var r8:W256.t;
    var c:W64.t;
    
    r16 <- g_r16;
    r8 <- g_r8;
    c <- (W64.of_int 0);
    
    while ((c \ult (W64.of_int 10))) {
      k <@ column_round_x2 (k, r16, r8);
      k <@ diagonal_round_x2 (k, r16, r8);
      c <- (c + (W64.of_int 1));
    }
    return (k);
  }
  
  proc round_x4 (k1:W256.t Array4.t, k2:W256.t Array4.t, r16:W256.t,
                 r8:W256.t) : W256.t Array4.t * W256.t Array4.t = {
    
    
    
    k1 <@ round_x2 (k1, r16, r8);
    k2 <@ round_x2 (k2, r16, r8);
    return (k1, k2);
  }
  
  proc column_round_x4 (k1:W256.t Array4.t, k2:W256.t Array4.t, r16:W256.t,
                        r8:W256.t) : W256.t Array4.t * W256.t Array4.t = {
    
    
    
    (k1, k2) <@ round_x4 (k1, k2, r16, r8);
    return (k1, k2);
  }
  
  proc shuffle_state_x2 (k1:W256.t Array4.t, k2:W256.t Array4.t) : W256.t Array4.t *
                                                                   W256.t Array4.t = {
    
    
    
    k1 <@ shuffle_state (k1);
    k2 <@ shuffle_state (k2);
    return (k1, k2);
  }
  
  proc reverse_shuffle_state_x2 (k1:W256.t Array4.t, k2:W256.t Array4.t) : 
  W256.t Array4.t * W256.t Array4.t = {
    
    
    
    k1 <@ reverse_shuffle_state (k1);
    k2 <@ reverse_shuffle_state (k2);
    return (k1, k2);
  }
  
  proc diagonal_round_x4 (k1:W256.t Array4.t, k2:W256.t Array4.t, r16:W256.t,
                          r8:W256.t) : W256.t Array4.t * W256.t Array4.t = {
    
    
    
    (k1, k2) <@ shuffle_state_x2 (k1, k2);
    (k1, k2) <@ round_x4 (k1, k2, r16, r8);
    (k1, k2) <@ reverse_shuffle_state_x2 (k1, k2);
    return (k1, k2);
  }
  
  proc rounds_x4 (k1:W256.t Array4.t, k2:W256.t Array4.t) : W256.t Array4.t *
                                                            W256.t Array4.t = {
    
    var r16:W256.t;
    var r8:W256.t;
    var c:W64.t;
    
    r16 <- g_r16;
    r8 <- g_r8;
    c <- (W64.of_int 0);
    
    while ((c \ult (W64.of_int 10))) {
      (k1, k2) <@ column_round_x4 (k1, k2, r16, r8);
      (k1, k2) <@ diagonal_round_x4 (k1, k2, r16, r8);
      c <- (c + (W64.of_int 1));
    }
    return (k1, k2);
  }
  
  proc rotate_x8_s (k:W256.t Array16.t, i:int, r:int, r16:W256.t, r8:W256.t) : 
  W256.t Array16.t = {
    
    var t:W256.t;
    
    if ((r = 16)) {
      k.[i] <- VPSHUFB_256 k.[i] r16;
    } else {
      if ((r = 8)) {
        k.[i] <- VPSHUFB_256 k.[i] r8;
      } else {
        t <- (k.[i] \vshl32u256 (W8.of_int r));
        k.[i] <- (k.[i] \vshr32u256 (W8.of_int (32 - r)));
        k.[i] <- (k.[i] `^` t);
      }
    }
    return (k);
  }
  
  proc _line_x8_v (k:W256.t Array16.t, a:int, b:int, c:int, r:int,
                   r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    
    
    
    k.[a] <- (k.[a] \vadd32u256 k.[b]);
    k.[c] <- (k.[c] `^` k.[a]);
    k <@ rotate_x8_s (k, c, r, r16, r8);
    return (k);
  }
  
  proc line_x8_v (k:W256.t Array16.t, a0:int, b0:int, c0:int, r0:int, a1:int,
                  b1:int, c1:int, r1:int, r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    
    
    
    k.[a0] <- (k.[a0] \vadd32u256 k.[b0]);
    k.[a1] <- (k.[a1] \vadd32u256 k.[b1]);
    k.[c0] <- (k.[c0] `^` k.[a0]);
    k.[c1] <- (k.[c1] `^` k.[a1]);
    k <@ rotate_x8_s (k, c0, r0, r16, r8);
    k <@ rotate_x8_s (k, c1, r1, r16, r8);
    return (k);
  }
  
  proc double_quarter_round_x8 (k:W256.t Array16.t, a0:int, b0:int, c0:int,
                                d0:int, a1:int, b1:int, c1:int, d1:int,
                                r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    
    
    
    k <@ _line_x8_v (k, a0, b0, d0, 16, r16, r8);
    k <@ line_x8_v (k, c0, d0, b0, 12, a1, b1, d1, 16, r16, r8);
    k <@ line_x8_v (k, a0, b0, d0, 8, c1, d1, b1, 12, r16, r8);
    k <@ line_x8_v (k, c0, d0, b0, 7, a1, b1, d1, 8, r16, r8);
    k <@ _line_x8_v (k, c1, d1, b1, 7, r16, r8);
    return (k);
  }
  
  proc column_round_x8 (k:W256.t Array16.t, k15:W256.t, s_r16:W256.t,
                        s_r8:W256.t) : W256.t Array16.t * W256.t = {
    
    var k_:W256.t;
    
    k <@ double_quarter_round_x8 (k, 0, 4, 8, 12, 2, 6, 10, 14, s_r16, s_r8);
    k.[15] <- k15;
    k_ <- k.[14];
    k <@ double_quarter_round_x8 (k, 1, 5, 9, 13, 3, 7, 11, 15, s_r16, s_r8);
    return (k, k_);
  }
  
  proc diagonal_round_x8 (k:W256.t Array16.t, k14:W256.t, s_r16:W256.t,
                          s_r8:W256.t) : W256.t Array16.t * W256.t = {
    
    var k_:W256.t;
    
    k <@ double_quarter_round_x8 (k, 1, 6, 11, 12, 0, 5, 10, 15, s_r16,
    s_r8);
    k.[14] <- k14;
    k_ <- k.[15];
    k <@ double_quarter_round_x8 (k, 2, 7, 8, 13, 3, 4, 9, 14, s_r16, s_r8);
    return (k, k_);
  }
  
  proc rounds_x8 (k:W256.t Array16.t, s_r16:W256.t, s_r8:W256.t) : W256.t Array16.t = {
    
    var k15:W256.t;
    var c:W64.t;
    var zf:bool;
    var k14:W256.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    
    k15 <- k.[15];
    c <- (W64.of_int 10);
    (k, k14) <@ column_round_x8 (k, k15, s_r16, s_r8);
    (k, k15) <@ diagonal_round_x8 (k, k14, s_r16, s_r8);
    ( _0,  _1,  _2, zf, c) <- DEC_64 c;
    while ((! zf)) {
      (k, k14) <@ column_round_x8 (k, k15, s_r16, s_r8);
      (k, k15) <@ diagonal_round_x8 (k, k14, s_r16, s_r8);
      ( _0,  _1,  _2, zf, c) <- DEC_64 c;
    }
    k.[15] <- k15;
    return (k);
  }
  
  proc chacha20_more_than_256 (output:W64.t, plain:W64.t, len:W32.t,
                               key:W64.t, nonce:W64.t, counter:W32.t) : unit = {
    
    var s_r16:W256.t;
    var s_r8:W256.t;
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    (s_r16, s_r8) <@ load_shufb_cmd ();
    st <@ init_x8 (key, nonce, counter);
    
    while (((W32.of_int 512) \ule len)) {
      k <@ copy_state_x8 (st);
      k <@ rounds_x8 (k, s_r16, s_r8);
      k <@ sum_states_x8 (k, st);
      (output, plain, len) <@ store_x8 (output, plain, len, k);
      st <@ increment_counter_x8 (st);
    }
    if (((W32.of_int 0) \ult len)) {
      k <@ copy_state_x8 (st);
      k <@ rounds_x8 (k, s_r16, s_r8);
      k <@ sum_states_x8 (k, st);
      store_x8_last (output, plain, len, k);
    } else {
      
    }
    return ();
  }
  
  proc chacha20_less_than_257 (output:W64.t, plain:W64.t, len:W32.t,
                               key:W64.t, nonce:W64.t, counter:W32.t) : unit = {
    
    var st:W256.t Array4.t;
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    st <@ init_x2 (key, nonce, counter);
    if (((W32.of_int 128) \ult len)) {
      (k1, k2) <@ copy_state_x4 (st);
      (k1, k2) <@ rounds_x4 (k1, k2);
      (k1, k2) <@ sum_states_x4 (k1, k2, st);
      (k1, k2) <@ perm_x4 (k1, k2);
      (output, plain, len, k1) <@ store_x2 (output, plain, len, k1);
      store_x2_last (output, plain, len, k2);
    } else {
      k1 <@ copy_state_x2 (st);
      k1 <@ rounds_x2 (k1);
      k1 <@ sum_states_x2 (k1, st);
      k1 <@ perm_x2 (k1);
      store_x2_last (output, plain, len, k1);
    }
    return ();
  }
  
  proc chacha20_avx2 (output:W64.t, plain:W64.t, len:W32.t, key:W64.t,
                      nonce:W64.t, counter:W32.t) : unit = {
    
    
    
    if ((len \ult (W32.of_int 257))) {
      chacha20_less_than_257 (output, plain, len, key, nonce, counter);
    } else {
      chacha20_more_than_256 (output, plain, len, key, nonce, counter);
    }
    return ();
  }
}.

