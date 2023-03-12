require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel.

require import Array2 Array4 Array8 Array16.
require import WArray32 WArray64 WArray128 WArray256.

abbrev g_sigma3 = W128.of_int 142395606795449994141864265039627707764.


abbrev g_sigma2 = W128.of_int 161346349289517898123623123153137577266.


abbrev g_sigma1 = W128.of_int 67958818256384961134917122602578240622.


abbrev g_sigma0 = W128.of_int 129519094760645606705801321186012985445.


abbrev g_sigma = W128.of_int 142395606799862307709414285570774956133.


abbrev g_p1 = W128.of_int 1.


abbrev g_p0 = W128.of_int 0.


abbrev g_cnt_inc = W128.of_int 316912650130844326686193876996.


abbrev g_cnt = W128.of_int 237684487579686500932345921536.


abbrev g_r8 = W128.of_int 18676936380593224926704134051422339075.


abbrev g_r16 = W128.of_int 17342576855639742879858139805557719810.


module M = {
  proc load_shufb_cmd () : W128.t * W128.t = {
    
    var s_r16:W128.t;
    var s_r8:W128.t;
    var r16:W128.t;
    var r8:W128.t;
    
    r16 <- g_r16;
    r8 <- g_r8;
    s_r16 <- r16;
    s_r8 <- r8;
    return (s_r16, s_r8);
  }
  
  proc init_x1 (key:W64.t, nonce:W64.t, counter:W32.t) : W128.t Array4.t = {
    
    var st:W128.t Array4.t;
    st <- witness;
    st.[0] <- g_sigma;
    st.[1] <- (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 0))));
    st.[2] <- (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 16))));
    st.[3] <- g_p0;
    st.[3] <- VPINSR_4u32 st.[3] counter (W8.of_int 0);
    st.[3] <- VPINSR_4u32 st.[3]
    (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int 0)))) (W8.of_int 1);
    st.[3] <- VPINSR_2u64 st.[3]
    (loadW64 Glob.mem (W64.to_uint (nonce + (W64.of_int 4)))) (W8.of_int 1);
    return (st);
  }
  
  proc init_x4 (k:W64.t, n1:W64.t, ctr:W32.t) : W128.t Array16.t = {
    var aux: int;
    
    var st:W128.t Array16.t;
    var s_ctr:W32.t;
    var s:W128.t Array16.t;
    var i:int;
    s <- witness;
    st <- witness;
    s_ctr <- ctr;
    s.[0] <- g_sigma0;
    s.[1] <- g_sigma1;
    s.[2] <- g_sigma2;
    s.[3] <- g_sigma3;
    i <- 0;
    while (i < 8) {
      s.[(4 + i)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (k + (W64.of_int (4 * i)))));
      i <- i + 1;
    }
    s.[12] <- VPBROADCAST_4u32 s_ctr;
    s.[12] <- (s.[12] \vadd32u128 g_cnt);
    i <- 0;
    while (i < 3) {
      s.[(13 + i)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (n1 + (W64.of_int (4 * i)))));
      i <- i + 1;
    }
    st <- copy_128 s;
    return (st);
  }
  
  proc copy_state_x1 (st:W128.t Array4.t) : W128.t Array4.t = {
    
    var k:W128.t Array4.t;
    k <- witness;
    k <- copy_128 st;
    return (k);
  }
  
  proc copy_state_x2 (st:W128.t Array4.t) : W128.t Array4.t * W128.t Array4.t = {
    
    var k1:W128.t Array4.t;
    var k2:W128.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    k1 <- copy_128 st;
    k2 <- copy_128 st;
    k2.[3] <- (k2.[3] \vadd32u128 g_p1);
    return (k1, k2);
  }
  
  proc copy_state_x4 (st:W128.t Array16.t) : W128.t Array16.t = {
    
    var k:W128.t Array16.t;
    k <- witness;
    k <- copy_128 st;
    return (k);
  }
  
  proc sum_states_x1 (k:W128.t Array4.t, st:W128.t Array4.t) : W128.t Array4.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <- (k.[i] \vadd32u128 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc sum_states_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t,
                      st:W128.t Array4.t) : W128.t Array4.t * W128.t Array4.t = {
    
    
    
    k1 <@ sum_states_x1 (k1, st);
    k2 <@ sum_states_x1 (k2, st);
    k2.[3] <- (k2.[3] \vadd32u128 g_p1);
    return (k1, k2);
  }
  
  proc sum_states_x4 (k:W128.t Array16.t, st:W128.t Array16.t) : W128.t Array16.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 16) {
      k.[i] <- (k.[i] \vadd32u128 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc sub_rotate (t:W128.t Array8.t) : W128.t Array8.t = {
    
    var x:W128.t Array8.t;
    x <- witness;
    x.[0] <- VPUNPCKL_2u64 t.[0] t.[1];
    x.[1] <- VPUNPCKL_2u64 t.[2] t.[3];
    x.[2] <- VPUNPCKH_2u64 t.[0] t.[1];
    x.[3] <- VPUNPCKH_2u64 t.[2] t.[3];
    x.[4] <- VPUNPCKL_2u64 t.[4] t.[5];
    x.[5] <- VPUNPCKL_2u64 t.[6] t.[7];
    x.[6] <- VPUNPCKH_2u64 t.[4] t.[5];
    x.[7] <- VPUNPCKH_2u64 t.[6] t.[7];
    return (x);
  }
  
  proc rotate (x:W128.t Array8.t) : W128.t Array8.t = {
    var aux: int;
    
    var i:int;
    var t:W128.t Array8.t;
    t <- witness;
    i <- 0;
    while (i < 4) {
      t.[i] <- VPUNPCKL_4u32 x.[((2 * i) + 0)] x.[((2 * i) + 1)];
      t.[(4 + i)] <- VPUNPCKH_4u32 x.[((2 * i) + 0)] x.[((2 * i) + 1)];
      i <- i + 1;
    }
    x <@ sub_rotate (t);
    return (x);
  }
  
  proc rotate_stack (s:W128.t Array8.t) : W128.t Array8.t = {
    var aux: int;
    
    var x:W128.t Array8.t;
    var i:int;
    var t:W128.t Array8.t;
    t <- witness;
    x <- witness;
    i <- 0;
    while (i < 4) {
      x.[i] <- s.[((2 * i) + 0)];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      t.[i] <- VPUNPCKL_4u32 x.[i] s.[((2 * i) + 1)];
      t.[(4 + i)] <- VPUNPCKH_4u32 x.[i] s.[((2 * i) + 1)];
      i <- i + 1;
    }
    x <@ sub_rotate (t);
    return (x);
  }
  
  proc rotate_first_half_x8 (k:W128.t Array16.t) : W128.t Array8.t *
                                                   W128.t Array8.t = {
    var aux: int;
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
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
  
  proc rotate_second_half_x8 (s_k8_15:W128.t Array8.t) : W128.t Array8.t = {
    
    var k8_15:W128.t Array8.t;
    k8_15 <- witness;
    k8_15 <@ rotate_stack (s_k8_15);
    return (k8_15);
  }
  
  proc interleave_0 (s:W128.t Array8.t, k:W128.t Array8.t, o:int) : W128.t Array8.t = {
    
    var sk:W128.t Array8.t;
    sk <- witness;
    sk.[0] <- s.[(o + 0)];
    sk.[1] <- s.[(o + 1)];
    sk.[2] <- k.[(o + 0)];
    sk.[3] <- k.[(o + 1)];
    sk.[4] <- s.[(o + 2)];
    sk.[5] <- s.[(o + 3)];
    sk.[6] <- k.[(o + 2)];
    sk.[7] <- k.[(o + 3)];
    return (sk);
  }
  
  proc update_ptr (output:W64.t, plain:W64.t, len:W32.t, n:int) : W64.t *
                                                                  W64.t *
                                                                  W32.t = {
    
    
    
    output <- (output + (W64.of_int n));
    plain <- (plain + (W64.of_int n));
    len <- (len - (W32.of_int n));
    return (output, plain, len);
  }
  
  proc store (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array2.t) : 
  W64.t * W64.t * W32.t * W128.t Array2.t = {
    
    
    
    k.[0] <-
    (k.[0] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
    k.[1] <-
    (k.[1] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int 16)))));
    Glob.mem <-
    storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (k.[0]);
    Glob.mem <-
    storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 16))) (k.[1]);
    (output, plain, len) <@ update_ptr (output, plain, len, 32);
    return (output, plain, len, k);
  }
  
  proc store_last (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array2.t) : unit = {
    
    var r1:W128.t;
    var r2:W64.t;
    var r3:W8.t;
    
    r1 <- k.[0];
    if (((W32.of_int 16) \ule len)) {
      r1 <-
      (r1 `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (r1);
      (output, plain, len) <@ update_ptr (output, plain, len, 16);
      r1 <- k.[1];
    } else {
      
    }
    r2 <- VPEXTR_64 r1 (W8.of_int 0);
    if (((W32.of_int 8) \ule len)) {
      r2 <-
      (r2 `^` (loadW64 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (r2);
      (output, plain, len) <@ update_ptr (output, plain, len, 8);
      r2 <- VPEXTR_64 r1 (W8.of_int 1);
    } else {
      
    }
    
    while (((W32.of_int 0) \ult len)) {
      r3 <- (truncateu8 r2);
      r3 <-
      (r3 `^` (loadW8 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (r3);
      r2 <- (r2 `>>` (W8.of_int 8));
      (output, plain, len) <@ update_ptr (output, plain, len, 1);
    }
    return ();
  }
  
  proc store_x1 (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array4.t) : 
  W64.t * W64.t * W32.t * W128.t Array4.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <-
      (k.[i] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (16 * i))))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) (
      k.[i]);
      i <- i + 1;
    }
    (output, plain, len) <@ update_ptr (output, plain, len, 64);
    return (output, plain, len, k);
  }
  
  proc store_x1_last (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array4.t) : unit = {
    
    var r:W128.t Array2.t;
    r <- witness;
    r.[0] <- k.[0];
    r.[1] <- k.[1];
    if (((W32.of_int 32) \ule len)) {
      (output, plain, len, r) <@ store (output, plain, len, r);
      r.[0] <- k.[2];
      r.[1] <- k.[3];
    } else {
      
    }
    store_last (output, plain, len, r);
    return ();
  }
  
  proc store_x2 (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array8.t) : 
  W64.t * W64.t * W32.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 8) {
      k.[i] <-
      (k.[i] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (16 * i))))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) (
      k.[i]);
      i <- i + 1;
    }
    (output, plain, len) <@ update_ptr (output, plain, len, 128);
    return (output, plain, len);
  }
  
  proc store_x2_last (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array8.t) : unit = {
    var aux: int;
    
    var i:int;
    var r:W128.t Array4.t;
    r <- witness;
    i <- 0;
    while (i < 4) {
      r.[i] <- k.[i];
      i <- i + 1;
    }
    if (((W32.of_int 64) \ule len)) {
      (output, plain, len, r) <@ store_x1 (output, plain, len, r);
      i <- 0;
      while (i < 4) {
        r.[i] <- k.[(i + 4)];
        i <- i + 1;
      }
    } else {
      
    }
    store_x1_last (output, plain, len, r);
    return ();
  }
  
  proc store_half_x4 (output:W64.t, plain:W64.t, len:W32.t,
                      k:W128.t Array8.t, o:int) : unit = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[(2 * i)] <-
      (k.[(2 * i)] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (o + (64 * i)))))));
      k.[((2 * i) + 1)] <-
      (k.[((2 * i) + 1)] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int ((o + (64 * i)) + 16))))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) (
      k.[(2 * i)]);
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int ((o + (64 * i)) + 16)))) (
      k.[((2 * i) + 1)]);
      i <- i + 1;
    }
    return ();
  }
  
  proc store_x4 (output:W64.t, plain:W64.t, len:W32.t, k:W128.t Array16.t) : 
  W64.t * W64.t * W32.t = {
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
    var k8_15:W128.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ rotate_first_half_x8 (k);
    store_half_x4 (output, plain, len, k0_7, 0);
    k8_15 <@ rotate_second_half_x8 (s_k8_15);
    store_half_x4 (output, plain, len, k8_15, 32);
    (output, plain, len) <@ update_ptr (output, plain, len, 256);
    return (output, plain, len);
  }
  
  proc store_x4_last (output:W64.t, plain:W64.t, len:W32.t,
                      k:W128.t Array16.t) : unit = {
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
    var s_k0_7:W128.t Array8.t;
    var k8_15:W128.t Array8.t;
    var i0_7:W128.t Array8.t;
    i0_7 <- witness;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k0_7 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ rotate_first_half_x8 (k);
    s_k0_7 <- copy_128 k0_7;
    k8_15 <@ rotate_second_half_x8 (s_k8_15);
    i0_7 <@ interleave_0 (s_k0_7, k8_15, 0);
    if (((W32.of_int 128) \ule len)) {
      (output, plain, len) <@ store_x2 (output, plain, len, i0_7);
      i0_7 <@ interleave_0 (s_k0_7, k8_15, 4);
    } else {
      
    }
    store_x2_last (output, plain, len, i0_7);
    return ();
  }
  
  proc increment_counter_x4 (s:W128.t Array16.t) : W128.t Array16.t = {
    
    var t:W128.t;
    
    t <- g_cnt_inc;
    t <- (t \vadd32u128 s.[12]);
    s.[12] <- t;
    return (s);
  }
  
  proc rotate_x4 (k:W128.t Array4.t, i:int, r:int, r16:W128.t, r8:W128.t) : 
  W128.t Array4.t = {
    
    var t:W128.t;
    
    if ((r = 16)) {
      k.[i] <- VPSHUFB_128 k.[i] r16;
    } else {
      if ((r = 8)) {
        k.[i] <- VPSHUFB_128 k.[i] r8;
      } else {
        t <- (k.[i] \vshl32u128 (W8.of_int r));
        k.[i] <- (k.[i] \vshr32u128 (W8.of_int (32 - r)));
        k.[i] <- (k.[i] `^` t);
      }
    }
    return (k);
  }
  
  proc line_x4 (k:W128.t Array4.t, a:int, b:int, c:int, r:int, r16:W128.t,
                r8:W128.t) : W128.t Array4.t = {
    
    
    
    k.[(a %/ 4)] <- (k.[(a %/ 4)] \vadd32u128 k.[(b %/ 4)]);
    k.[(c %/ 4)] <- (k.[(c %/ 4)] `^` k.[(a %/ 4)]);
    k <@ rotate_x4 (k, (c %/ 4), r, r16, r8);
    return (k);
  }
  
  proc round_x1 (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : W128.t Array4.t = {
    
    
    
    k <@ line_x4 (k, 0, 4, 12, 16, r16, r8);
    k <@ line_x4 (k, 8, 12, 4, 12, r16, r8);
    k <@ line_x4 (k, 0, 4, 12, 8, r16, r8);
    k <@ line_x4 (k, 8, 12, 4, 7, r16, r8);
    return (k);
  }
  
  proc shuffle_state_x1 (k:W128.t Array4.t) : W128.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_128 k.[1]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    k.[2] <- VPSHUFD_128 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_128 k.[3]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    return (k);
  }
  
  proc reverse_shuffle_state_x1 (k:W128.t Array4.t) : W128.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_128 k.[1]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    k.[2] <- VPSHUFD_128 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_128 k.[3]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    return (k);
  }
  
  proc column_round_x1 (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : W128.t Array4.t = {
    
    
    
    k <@ round_x1 (k, r16, r8);
    return (k);
  }
  
  proc diagonal_round_x1 (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : 
  W128.t Array4.t = {
    
    
    
    k <@ shuffle_state_x1 (k);
    k <@ round_x1 (k, r16, r8);
    k <@ reverse_shuffle_state_x1 (k);
    return (k);
  }
  
  proc rounds_x1 (k:W128.t Array4.t) : W128.t Array4.t = {
    
    var r16:W128.t;
    var r8:W128.t;
    var c:W64.t;
    
    r16 <- g_r16;
    r8 <- g_r8;
    c <- (W64.of_int 0);
    
    while ((c \ult (W64.of_int 10))) {
      k <@ column_round_x1 (k, r16, r8);
      k <@ diagonal_round_x1 (k, r16, r8);
      c <- (c + (W64.of_int 1));
    }
    return (k);
  }
  
  proc inlined_round_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t, r16:W128.t,
                         r8:W128.t) : W128.t Array4.t * W128.t Array4.t = {
    
    var t1:W128.t;
    
    k1.[0] <- (k1.[0] \vadd32u128 k1.[1]);
    k2.[0] <- (k2.[0] \vadd32u128 k2.[1]);
    k1.[3] <- (k1.[3] `^` k1.[0]);
    k2.[3] <- (k2.[3] `^` k2.[0]);
    k1 <@ rotate_x4 (k1, 3, 16, r16, r8);
    k2 <@ rotate_x4 (k2, 3, 16, r16, r8);
    k1.[2] <- (k1.[2] \vadd32u128 k1.[3]);
    k2.[2] <- (k2.[2] \vadd32u128 k2.[3]);
    k1.[1] <- (k1.[1] `^` k1.[2]);
    t1 <- (k1.[1] \vshl32u128 (W8.of_int 12));
    k1.[1] <- (k1.[1] \vshr32u128 (W8.of_int 20));
    k2.[1] <- (k2.[1] `^` k2.[2]);
    k1.[1] <- (k1.[1] `^` t1);
    k2 <@ rotate_x4 (k2, 1, 12, r16, r8);
    k1.[0] <- (k1.[0] \vadd32u128 k1.[1]);
    k2.[0] <- (k2.[0] \vadd32u128 k2.[1]);
    k1.[3] <- (k1.[3] `^` k1.[0]);
    k2.[3] <- (k2.[3] `^` k2.[0]);
    k1 <@ rotate_x4 (k1, 3, 8, r16, r8);
    k2 <@ rotate_x4 (k2, 3, 8, r16, r8);
    k1.[2] <- (k1.[2] \vadd32u128 k1.[3]);
    k2.[2] <- (k2.[2] \vadd32u128 k2.[3]);
    k1.[1] <- (k1.[1] `^` k1.[2]);
    t1 <- (k1.[1] \vshl32u128 (W8.of_int 7));
    k1.[1] <- (k1.[1] \vshr32u128 (W8.of_int 25));
    k2.[1] <- (k2.[1] `^` k2.[2]);
    k1.[1] <- (k1.[1] `^` t1);
    k2 <@ rotate_x4 (k2, 1, 7, r16, r8);
    return (k1, k2);
  }
  
  proc column_round_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t, r16:W128.t,
                        r8:W128.t) : W128.t Array4.t * W128.t Array4.t = {
    
    
    
    (k1, k2) <@ inlined_round_x2 (k1, k2, r16, r8);
    return (k1, k2);
  }
  
  proc shuffle_state_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t) : W128.t Array4.t *
                                                                   W128.t Array4.t = {
    
    
    
    k1 <@ shuffle_state_x1 (k1);
    k2 <@ shuffle_state_x1 (k2);
    return (k1, k2);
  }
  
  proc reverse_shuffle_state_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t) : 
  W128.t Array4.t * W128.t Array4.t = {
    
    
    
    k1 <@ reverse_shuffle_state_x1 (k1);
    k2 <@ reverse_shuffle_state_x1 (k2);
    return (k1, k2);
  }
  
  proc diagonal_round_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t, r16:W128.t,
                          r8:W128.t) : W128.t Array4.t * W128.t Array4.t = {
    
    
    
    (k1, k2) <@ shuffle_state_x2 (k1, k2);
    (k1, k2) <@ inlined_round_x2 (k1, k2, r16, r8);
    (k1, k2) <@ reverse_shuffle_state_x2 (k1, k2);
    return (k1, k2);
  }
  
  proc rounds_x2 (k1:W128.t Array4.t, k2:W128.t Array4.t) : W128.t Array4.t *
                                                            W128.t Array4.t = {
    
    var r16:W128.t;
    var r8:W128.t;
    var c:W64.t;
    
    r16 <- g_r16;
    r8 <- g_r8;
    c <- (W64.of_int 0);
    
    while ((c \ult (W64.of_int 10))) {
      (k1, k2) <@ column_round_x2 (k1, k2, r16, r8);
      (k1, k2) <@ diagonal_round_x2 (k1, k2, r16, r8);
      c <- (c + (W64.of_int 1));
    }
    return (k1, k2);
  }
  
  proc rotate_x4_s (k:W128.t Array16.t, i:int, r:int, r16:W128.t, r8:W128.t) : 
  W128.t Array16.t = {
    
    var t:W128.t;
    
    if ((r = 16)) {
      k.[i] <- VPSHUFB_128 k.[i] r16;
    } else {
      if ((r = 8)) {
        k.[i] <- VPSHUFB_128 k.[i] r8;
      } else {
        t <- (k.[i] \vshl32u128 (W8.of_int r));
        k.[i] <- (k.[i] \vshr32u128 (W8.of_int (32 - r)));
        k.[i] <- (k.[i] `^` t);
      }
    }
    return (k);
  }
  
  proc line_x4_v (k:W128.t Array16.t, a0:int, b0:int, c0:int, r0:int, a1:int,
                  b1:int, c1:int, r1:int, r16:W128.t, r8:W128.t) : W128.t Array16.t = {
    
    
    
    k.[a0] <- (k.[a0] \vadd32u128 k.[b0]);
    k.[a1] <- (k.[a1] \vadd32u128 k.[b1]);
    k.[c0] <- (k.[c0] `^` k.[a0]);
    k.[c1] <- (k.[c1] `^` k.[a1]);
    k <@ rotate_x4_s (k, c0, r0, r16, r8);
    k <@ rotate_x4_s (k, c1, r1, r16, r8);
    return (k);
  }
  
  proc double_quarter_round_x4 (k:W128.t Array16.t, a0:int, b0:int, c0:int,
                                d0:int, a1:int, b1:int, c1:int, d1:int,
                                r16:W128.t, r8:W128.t) : W128.t Array16.t = {
    
    
    
    k <@ line_x4_v (k, a0, b0, d0, 16, a1, b1, d1, 16, r16, r8);
    k <@ line_x4_v (k, c0, d0, b0, 12, c1, d1, b1, 12, r16, r8);
    k <@ line_x4_v (k, a0, b0, d0, 8, a1, b1, d1, 8, r16, r8);
    k <@ line_x4_v (k, c0, d0, b0, 7, c1, d1, b1, 7, r16, r8);
    return (k);
  }
  
  proc column_round_x4 (k:W128.t Array16.t, k15:W128.t, s_r16:W128.t,
                        s_r8:W128.t) : W128.t Array16.t * W128.t = {
    
    var k_:W128.t;
    
    k <@ double_quarter_round_x4 (k, 0, 4, 8, 12, 2, 6, 10, 14, s_r16, s_r8);
    k.[15] <- k15;
    k_ <- k.[14];
    k <@ double_quarter_round_x4 (k, 1, 5, 9, 13, 3, 7, 11, 15, s_r16, s_r8);
    return (k, k_);
  }
  
  proc diagonal_round_x4 (k:W128.t Array16.t, k14:W128.t, s_r16:W128.t,
                          s_r8:W128.t) : W128.t Array16.t * W128.t = {
    
    var k_:W128.t;
    
    k <@ double_quarter_round_x4 (k, 1, 6, 11, 12, 0, 5, 10, 15, s_r16,
    s_r8);
    k.[14] <- k14;
    k_ <- k.[15];
    k <@ double_quarter_round_x4 (k, 2, 7, 8, 13, 3, 4, 9, 14, s_r16, s_r8);
    return (k, k_);
  }
  
  proc rounds_x4 (k:W128.t Array16.t, s_r16:W128.t, s_r8:W128.t) : W128.t Array16.t = {
    
    var k15:W128.t;
    var c:W64.t;
    var zf:bool;
    var k14:W128.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    
    k15 <- k.[15];
    c <- (W64.of_int 10);
    (k, k14) <@ column_round_x4 (k, k15, s_r16, s_r8);
    (k, k15) <@ diagonal_round_x4 (k, k14, s_r16, s_r8);
    ( _0,  _1,  _2, zf, c) <- DEC_64 c;
    while ((! zf)) {
      (k, k14) <@ column_round_x4 (k, k15, s_r16, s_r8);
      (k, k15) <@ diagonal_round_x4 (k, k14, s_r16, s_r8);
      ( _0,  _1,  _2, zf, c) <- DEC_64 c;
    }
    k.[15] <- k15;
    return (k);
  }
  
  proc chacha20_more_than_128 (output:W64.t, plain:W64.t, len:W32.t,
                               key:W64.t, nonce:W64.t, counter:W32.t) : unit = {
    
    var s_r16:W128.t;
    var s_r8:W128.t;
    var st:W128.t Array16.t;
    var k:W128.t Array16.t;
    k <- witness;
    st <- witness;
    (s_r16, s_r8) <@ load_shufb_cmd ();
    st <@ init_x4 (key, nonce, counter);
    
    while (((W32.of_int 256) \ule len)) {
      k <@ copy_state_x4 (st);
      k <@ rounds_x4 (k, s_r16, s_r8);
      k <@ sum_states_x4 (k, st);
      (output, plain, len) <@ store_x4 (output, plain, len, k);
      st <@ increment_counter_x4 (st);
    }
    if (((W32.of_int 0) \ult len)) {
      k <@ copy_state_x4 (st);
      k <@ rounds_x4 (k, s_r16, s_r8);
      k <@ sum_states_x4 (k, st);
      store_x4_last (output, plain, len, k);
    } else {
      
    }
    return ();
  }
  
  proc chacha20_less_than_129 (output:W64.t, plain:W64.t, len:W32.t,
                               key:W64.t, nonce:W64.t, counter:W32.t) : unit = {
    
    var st:W128.t Array4.t;
    var k1:W128.t Array4.t;
    var k2:W128.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    st <@ init_x1 (key, nonce, counter);
    if (((W32.of_int 64) \ult len)) {
      (k1, k2) <@ copy_state_x2 (st);
      (k1, k2) <@ rounds_x2 (k1, k2);
      (k1, k2) <@ sum_states_x2 (k1, k2, st);
      (output, plain, len, k1) <@ store_x1 (output, plain, len, k1);
      store_x1_last (output, plain, len, k2);
    } else {
      k1 <@ copy_state_x1 (st);
      k1 <@ rounds_x1 (k1);
      k1 <@ sum_states_x1 (k1, st);
      store_x1_last (output, plain, len, k1);
    }
    return ();
  }
  
  proc chacha20_avx (output:W64.t, plain:W64.t, len:W32.t, key:W64.t,
                     nonce:W64.t, counter:W32.t) : unit = {
    
    
    
    if ((len \ult (W32.of_int 129))) {
      chacha20_less_than_129 (output, plain, len, key, nonce, counter);
    } else {
      chacha20_more_than_128 (output, plain, len, key, nonce, counter);
    }
    return ();
  }
}.

