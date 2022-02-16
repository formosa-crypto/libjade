require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array4 Array8 Array16.
require import WArray64 WArray128 WArray256.

abbrev SALSA20_P44_V_AVX = W128.of_int 73786976294838206468.


abbrev SALSA20_P3210_V_AVX = W128.of_int 237684487579686500932345921536.


abbrev SALSA20_SIGMA_V_AVX = Array4.of_list witness [W128.of_int 129519094760645606705801321186012985445;
W128.of_int 67958818256384961134917122602578240622;
W128.of_int 161346349289517898123623123153137577266;
W128.of_int 142395606795449994141864265039627707764].


module M = {
  proc __init_v_avx (nonce:W64.t, key:W64.t) : W128.t Array16.t = {
    var aux: int;
    
    var _st:W128.t Array16.t;
    var i:int;
    var st:W128.t Array16.t;
    _st <- witness;
    st <- witness;
    i <- 0;
    while (i < 4) {
      st.[(i + 1)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    i <- 4;
    while (i < 8) {
      st.[(i + 7)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      st.[(i * 5)] <- SALSA20_SIGMA_V_AVX.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 2) {
      st.[(i + 6)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    st.[8] <- SALSA20_P3210_V_AVX;
    st.[9] <- setw0_128 ;
    _st <-
    (Array16.init (fun i => get128
    (WArray256.init8 (fun i => copy_128 (Array256.init (fun i => get8
                                        (WArray256.init128 (fun i => st.[i]))
                                        i)).[i]))
    i));
    return (_st);
  }
  
  proc __increment_counter_v_avx (st:W128.t Array16.t) : W128.t Array16.t = {
    
    var x:W128.t;
    var y:W128.t;
    var a:W128.t;
    var b:W128.t;
    
    x <- st.[8];
    y <- st.[9];
    a <- VPUNPCKL_4u32 x y;
    b <- VPUNPCKH_4u32 x y;
    a <- (a \vadd64u128 SALSA20_P44_V_AVX);
    b <- (b \vadd64u128 SALSA20_P44_V_AVX);
    x <- VPUNPCKL_4u32 a b;
    y <- VPUNPCKH_4u32 a b;
    a <- VPUNPCKL_4u32 x y;
    b <- VPUNPCKH_4u32 x y;
    st.[8] <- a;
    st.[9] <- b;
    return (st);
  }
  
  proc __update_ptr_xor_ref (output:W64.t, plain:W64.t, len:W64.t, n:int) : 
  W64.t * W64.t * W64.t = {
    
    
    
    output <- (output + (W64.of_int n));
    plain <- (plain + (W64.of_int n));
    len <- (len - (W64.of_int n));
    return (output, plain, len);
  }
  
  proc __update_ptr_ref (output:W64.t, len:W64.t, n:int) : W64.t * W64.t = {
    
    
    
    output <- (output + (W64.of_int n));
    len <- (len - (W64.of_int n));
    return (output, len);
  }
  
  proc __store_xor_h_avx (output:W64.t, plain:W64.t, len:W64.t,
                          k:W128.t Array4.t) : W64.t * W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <-
      (k.[i] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (16 * i))))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) 
      k.[i];
      i <- i + 1;
    }
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 64);
    return (output, plain, len);
  }
  
  proc __store_xor_last_h_avx (output:W64.t, plain:W64.t, len:W64.t,
                               k:W128.t Array4.t) : unit = {
    var aux: int;
    
    var i:int;
    var r0:W64.t;
    var r1:W8.t;
    
    if (((W64.of_int 32) \ule len)) {
      i <- 0;
      while (i < 2) {
        k.[i] <-
        (k.[i] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (16 * i))))));
        Glob.mem <-
        storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) 
        k.[i];
        i <- i + 1;
      }
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 32);
      k.[0] <- k.[2];
      k.[1] <- k.[3];
    } else {
      
    }
    if (((W64.of_int 16) \ule len)) {
      k.[0] <-
      (k.[0] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) k.[0];
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 16);
      k.[0] <- k.[1];
    } else {
      
    }
    r0 <- VPEXTR_64 k.[0] (W8.of_int 0);
    if (((W64.of_int 8) \ule len)) {
      r0 <-
      (r0 `^` (loadW64 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r0;
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 8);
      r0 <- VPEXTR_64 k.[0] (W8.of_int 1);
    } else {
      
    }
    
    while (((W64.of_int 0) \ult len)) {
      r1 <- (truncateu8 r0);
      r1 <-
      (r1 `^` (loadW8 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r1;
      r0 <- (r0 `>>` (W8.of_int 8));
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 1);
    }
    return ();
  }
  
  proc __store_xor_h_x2_avx (output:W64.t, plain:W64.t, len:W64.t,
                             k1:W128.t Array4.t, k2:W128.t Array4.t) : 
  W64.t * W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k1.[i] <-
      (k1.[i] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (16 * i))))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) 
      k1.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      k2.[i] <-
      (k2.[i] `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int (16 * (i + 4)))))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * (i + 4))))) 
      k2.[i];
      i <- i + 1;
    }
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 128);
    return (output, plain, len);
  }
  
  proc __store_xor_last_h_x2_avx (output:W64.t, plain:W64.t, len:W64.t,
                                  k1:W128.t Array4.t, k2:W128.t Array4.t) : unit = {
    
    
    
    if (((W64.of_int 64) \ule len)) {
      (output, plain, len) <@ __store_xor_h_avx (output, plain, len, k1);
      k1 <-
      (Array4.init (fun i => get128
      (WArray64.init8 (fun i => copy_128 (Array64.init (fun i => get8
                                         (WArray64.init128 (fun i => k2.[i]))
                                         i)).[i]))
      i));
    } else {
      
    }
    __store_xor_last_h_avx (output, plain, len, k1);
    return ();
  }
  
  proc __store_h_avx (output:W64.t, len:W64.t, k:W128.t Array4.t) : W64.t *
                                                                    W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) 
      k.[i];
      i <- i + 1;
    }
    (output, len) <@ __update_ptr_ref (output, len, 64);
    return (output, len);
  }
  
  proc __store_last_h_avx (output:W64.t, len:W64.t, k:W128.t Array4.t) : unit = {
    var aux: int;
    
    var i:int;
    var r0:W64.t;
    var r1:W8.t;
    
    if (((W64.of_int 32) \ule len)) {
      i <- 0;
      while (i < 2) {
        Glob.mem <-
        storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) 
        k.[i];
        i <- i + 1;
      }
      (output, len) <@ __update_ptr_ref (output, len, 32);
      k.[0] <- k.[2];
      k.[1] <- k.[3];
    } else {
      
    }
    if (((W64.of_int 16) \ule len)) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) k.[0];
      (output, len) <@ __update_ptr_ref (output, len, 16);
      k.[0] <- k.[1];
    } else {
      
    }
    r0 <- VPEXTR_64 k.[0] (W8.of_int 0);
    if (((W64.of_int 8) \ule len)) {
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r0;
      (output, len) <@ __update_ptr_ref (output, len, 8);
      r0 <- VPEXTR_64 k.[0] (W8.of_int 1);
    } else {
      
    }
    
    while (((W64.of_int 0) \ult len)) {
      r1 <- (truncateu8 r0);
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r1;
      r0 <- (r0 `>>` (W8.of_int 8));
      (output, len) <@ __update_ptr_ref (output, len, 1);
    }
    return ();
  }
  
  proc __store_h_x2_avx (output:W64.t, len:W64.t, k1:W128.t Array4.t,
                         k2:W128.t Array4.t) : W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * i)))) 
      k1.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (16 * (i + 4))))) 
      k2.[i];
      i <- i + 1;
    }
    (output, len) <@ __update_ptr_ref (output, len, 128);
    return (output, len);
  }
  
  proc __store_last_h_x2_avx (output:W64.t, len:W64.t, k1:W128.t Array4.t,
                              k2:W128.t Array4.t) : unit = {
    
    
    
    if (((W64.of_int 64) \ule len)) {
      (output, len) <@ __store_h_avx (output, len, k1);
      k1 <-
      (Array4.init (fun i => get128
      (WArray64.init8 (fun i => copy_128 (Array64.init (fun i => get8
                                         (WArray64.init128 (fun i => k2.[i]))
                                         i)).[i]))
      i));
    } else {
      
    }
    __store_last_h_avx (output, len, k1);
    return ();
  }
  
  proc __sub_rotate_avx (t:W128.t Array8.t) : W128.t Array8.t = {
    
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
  
  proc __rotate_avx (x:W128.t Array8.t) : W128.t Array8.t = {
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
    x <@ __sub_rotate_avx (t);
    return (x);
  }
  
  proc __rotate_stack_avx (s:W128.t Array8.t) : W128.t Array8.t = {
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
    x <@ __sub_rotate_avx (t);
    return (x);
  }
  
  proc __rotate_first_half_v_avx (k:W128.t Array16.t) : W128.t Array8.t *
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
    k0_7 <@ __rotate_avx (k0_7);
    return (k0_7, s_k8_15);
  }
  
  proc __rotate_second_half_v_avx (s_k8_15:W128.t Array8.t) : W128.t Array8.t = {
    
    var k8_15:W128.t Array8.t;
    k8_15 <- witness;
    k8_15 <@ __rotate_stack_avx (s_k8_15);
    return (k8_15);
  }
  
  proc __interleave_avx (s:W128.t Array8.t, k:W128.t Array8.t, o:int) : 
  W128.t Array4.t * W128.t Array4.t = {
    
    var sk1:W128.t Array4.t;
    var sk2:W128.t Array4.t;
    sk1 <- witness;
    sk2 <- witness;
    sk1.[0] <- s.[(o + 0)];
    sk1.[1] <- s.[(o + 1)];
    sk1.[2] <- k.[(o + 0)];
    sk1.[3] <- k.[(o + 1)];
    sk2.[0] <- s.[(o + 2)];
    sk2.[1] <- s.[(o + 3)];
    sk2.[2] <- k.[(o + 2)];
    sk2.[3] <- k.[(o + 3)];
    return (sk1, sk2);
  }
  
  proc __store_xor_half_interleave_v_avx (output:W64.t, plain:W64.t,
                                          len:W64.t, k:W128.t Array8.t, o:int) : unit = {
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
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) 
      k.[(2 * i)];
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int ((o + (64 * i)) + 16)))) 
      k.[((2 * i) + 1)];
      i <- i + 1;
    }
    return ();
  }
  
  proc __store_xor_v_avx (output:W64.t, plain:W64.t, len:W64.t,
                          k:W128.t Array16.t) : W64.t * W64.t * W64.t = {
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
    var k8_15:W128.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx (k);
    __store_xor_half_interleave_v_avx (output, plain, len, k0_7, 0);
    k8_15 <@ __rotate_second_half_v_avx (s_k8_15);
    __store_xor_half_interleave_v_avx (output, plain, len, k8_15, 32);
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 256);
    return (output, plain, len);
  }
  
  proc __store_xor_last_v_avx (output:W64.t, plain:W64.t, len:W64.t,
                               k:W128.t Array16.t) : unit = {
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
    var s_k0_7:W128.t Array8.t;
    var k8_15:W128.t Array8.t;
    var k0_3:W128.t Array4.t;
    var k4_7:W128.t Array4.t;
    k0_3 <- witness;
    k0_7 <- witness;
    k4_7 <- witness;
    k8_15 <- witness;
    s_k0_7 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx (k);
    s_k0_7 <-
    (Array8.init (fun i => get128
    (WArray128.init8 (fun i => copy_128 (Array128.init (fun i => get8
                                        (WArray128.init128 (fun i => k0_7.[i]))
                                        i)).[i]))
    i));
    k8_15 <@ __rotate_second_half_v_avx (s_k8_15);
    (k0_3, k4_7) <@ __interleave_avx (s_k0_7, k8_15, 0);
    if (((W64.of_int 128) \ule len)) {
      (output, plain, len) <@ __store_xor_h_x2_avx (output, plain, len, k0_3,
      k4_7);
      (k0_3, k4_7) <@ __interleave_avx (s_k0_7, k8_15, 4);
    } else {
      
    }
    __store_xor_last_h_x2_avx (output, plain, len, k0_3, k4_7);
    return ();
  }
  
  proc __store_half_interleave_v_avx (output:W64.t, len:W64.t,
                                      k:W128.t Array8.t, o:int) : unit = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) 
      k.[(2 * i)];
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int ((o + (64 * i)) + 16)))) 
      k.[((2 * i) + 1)];
      i <- i + 1;
    }
    return ();
  }
  
  proc __store_v_avx (output:W64.t, len:W64.t, k:W128.t Array16.t) : 
  W64.t * W64.t = {
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
    var k8_15:W128.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx (k);
    __store_half_interleave_v_avx (output, len, k0_7, 0);
    k8_15 <@ __rotate_second_half_v_avx (s_k8_15);
    __store_half_interleave_v_avx (output, len, k8_15, 32);
    (output, len) <@ __update_ptr_ref (output, len, 256);
    return (output, len);
  }
  
  proc __store_last_v_avx (output:W64.t, len:W64.t, k:W128.t Array16.t) : unit = {
    
    var k0_7:W128.t Array8.t;
    var s_k8_15:W128.t Array8.t;
    var s_k0_7:W128.t Array8.t;
    var k8_15:W128.t Array8.t;
    var k0_3:W128.t Array4.t;
    var k4_7:W128.t Array4.t;
    k0_3 <- witness;
    k0_7 <- witness;
    k4_7 <- witness;
    k8_15 <- witness;
    s_k0_7 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx (k);
    s_k0_7 <-
    (Array8.init (fun i => get128
    (WArray128.init8 (fun i => copy_128 (Array128.init (fun i => get8
                                        (WArray128.init128 (fun i => k0_7.[i]))
                                        i)).[i]))
    i));
    k8_15 <@ __rotate_second_half_v_avx (s_k8_15);
    (k0_3, k4_7) <@ __interleave_avx (s_k0_7, k8_15, 0);
    if (((W64.of_int 128) \ule len)) {
      (output, len) <@ __store_h_x2_avx (output, len, k0_3, k4_7);
      (k0_3, k4_7) <@ __interleave_avx (s_k0_7, k8_15, 4);
    } else {
      
    }
    __store_last_h_x2_avx (output, len, k0_3, k4_7);
    return ();
  }
  
  proc __copy_state_v_avx (st:W128.t Array16.t) : W128.t Array16.t = {
    
    var k:W128.t Array16.t;
    k <- witness;
    k <-
    (Array16.init (fun i => get128
    (WArray256.init8 (fun i => copy_128 (Array256.init (fun i => get8
                                        (WArray256.init128 (fun i => st.[i]))
                                        i)).[i]))
    i));
    return (k);
  }
  
  proc __rotate_v_avx (x:W128.t, r:int) : W128.t = {
    
    var t:W128.t;
    
    t <- (x \vshl32u128 (W8.of_int r));
    x <- (x \vshr32u128 (W8.of_int (32 - r)));
    x <- (x `^` t);
    return (x);
  }
  
  proc __line_v_avx (k:W128.t Array16.t, a:int, b:int, c:int, r:int) : 
  W128.t Array16.t = {
    
    var t:W128.t;
    
    t <- (k.[b] \vadd32u128 k.[c]);
    t <@ __rotate_v_avx (t, r);
    k.[a] <- (k.[a] `^` t);
    return (k);
  }
  
  proc __quarter_round_v_avx (k:W128.t Array16.t, a:int, b:int, c:int, d:int) : 
  W128.t Array16.t = {
    
    
    
    k <@ __line_v_avx (k, b, a, d, 7);
    k <@ __line_v_avx (k, c, b, a, 9);
    k <@ __line_v_avx (k, d, c, b, 13);
    k <@ __line_v_avx (k, a, d, c, 18);
    return (k);
  }
  
  proc __column_round_v_avx (k:W128.t Array16.t, k2:W128.t, k3:W128.t) : 
  W128.t Array16.t * W128.t * W128.t = {
    
    var k12:W128.t;
    var k13:W128.t;
    
    k <@ __quarter_round_v_avx (k, 0, 4, 8, 12);
    k12 <- k.[12];
    k.[2] <- k2;
    k <@ __quarter_round_v_avx (k, 5, 9, 13, 1);
    k13 <- k.[13];
    k.[3] <- k3;
    k <@ __quarter_round_v_avx (k, 10, 14, 2, 6);
    k <@ __quarter_round_v_avx (k, 15, 3, 7, 11);
    return (k, k12, k13);
  }
  
  proc __line_round_v_avx (k:W128.t Array16.t, k12:W128.t, k13:W128.t) : 
  W128.t Array16.t * W128.t * W128.t = {
    
    var k2:W128.t;
    var k3:W128.t;
    
    k <@ __quarter_round_v_avx (k, 0, 1, 2, 3);
    k2 <- k.[2];
    k.[12] <- k12;
    k <@ __quarter_round_v_avx (k, 5, 6, 7, 4);
    k3 <- k.[3];
    k.[13] <- k13;
    k <@ __quarter_round_v_avx (k, 10, 11, 8, 9);
    k <@ __quarter_round_v_avx (k, 15, 12, 13, 14);
    return (k, k2, k3);
  }
  
  proc __double_round_v_avx (k:W128.t Array16.t, k2:W128.t, k3:W128.t) : 
  W128.t Array16.t * W128.t * W128.t = {
    
    var k12:W128.t;
    var k13:W128.t;
    
    (k, k12, k13) <@ __column_round_v_avx (k, k2, k3);
    (k, k2, k3) <@ __line_round_v_avx (k, k12, k13);
    return (k, k2, k3);
  }
  
  proc __rounds_v_avx (k:W128.t Array16.t) : W128.t Array16.t = {
    
    var k2:W128.t;
    var k3:W128.t;
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    k2 <- k.[2];
    k3 <- k.[3];
    c <- (W32.of_int (12 %/ 2));
    (k, k2, k3) <@ __double_round_v_avx (k, k2, k3);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      (k, k2, k3) <@ __double_round_v_avx (k, k2, k3);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    k.[2] <- k2;
    k.[3] <- k3;
    return (k);
  }
  
  proc __sum_states_v_avx (k:W128.t Array16.t, st:W128.t Array16.t) : 
  W128.t Array16.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 16) {
      k.[i] <- (k.[i] \vadd32u128 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc __salsa20_xor_v_avx (output:W64.t, plain:W64.t, len:W64.t,
                            nonce:W64.t, key:W64.t) : unit = {
    
    var st:W128.t Array16.t;
    var k:W128.t Array16.t;
    k <- witness;
    st <- witness;
    st <@ __init_v_avx (nonce, key);
    
    while (((W64.of_int 256) \ule len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k);
      k <@ __sum_states_v_avx (k, st);
      (output, plain, len) <@ __store_xor_v_avx (output, plain, len, k);
      st <@ __increment_counter_v_avx (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k);
      k <@ __sum_states_v_avx (k, st);
      __store_xor_last_v_avx (output, plain, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __salsa20_v_avx (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var st:W128.t Array16.t;
    var k:W128.t Array16.t;
    k <- witness;
    st <- witness;
    st <@ __init_v_avx (nonce, key);
    
    while (((W64.of_int 256) \ule len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k);
      k <@ __sum_states_v_avx (k, st);
      (output, len) <@ __store_v_avx (output, len, k);
      st <@ __increment_counter_v_avx (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k);
      k <@ __sum_states_v_avx (k, st);
      __store_last_v_avx (output, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __salsa20_xor_avx (output:W64.t, plain:W64.t, len:W64.t, nonce:W64.t,
                          key:W64.t) : unit = {
    
    
    
    __salsa20_xor_v_avx (output, plain, len, nonce, key);
    return ();
  }
  
  proc __salsa20_avx (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    
    
    __salsa20_v_avx (output, len, nonce, key);
    return ();
  }
  
  proc jade_stream_salsa20_salsa2012_amd64_avx_xor (output:W64.t,
                                                    plain:W64.t, len:W64.t,
                                                    nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __salsa20_xor_avx (output, plain, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
  
  proc jade_stream_salsa20_salsa2012_amd64_avx (output:W64.t, len:W64.t,
                                                nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __salsa20_avx (output, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

