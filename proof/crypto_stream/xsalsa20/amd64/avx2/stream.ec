require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array4 Array8 Array16.
require import WArray32 WArray64 WArray128 WArray256 WArray512.

abbrev SALSA20_P8888_V_AVX2 = W256.of_int 50216813883093446113408574321028839036673414367756098207752.


abbrev SALSA20_P76543210_V_AVX2 = W256.of_int 188719626707717088982296698380167795313645871959412740063448560304128.


abbrev SALSA20_SIGMA_V_AVX2 = Array4.of_list witness [W256.of_int 44073064126609806855391717116077731678275203726397694096946023845364623243365;
W256.of_int 23125187529432558845629540468101975958865586010904976319010681524266723206254;
W256.of_int 54903317630289628372966993210398408063843973048718200005123542515998963936562;
W256.of_int 48454714119498993367416293155753147246354200180586516487276217358402952652148].


module M = {
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
  
  proc __line_ref (k:W32.t Array16.t, a:int, b:int, c:int, r:int) : W32.t Array16.t = {
    
    var t:W32.t;
    var  _0:bool;
    var  _1:bool;
    
    t <- k.[b];
    t <- (t + k.[c]);
    ( _0,  _1, t) <- ROL_32 t (W8.of_int r);
    k.[a] <- (k.[a] `^` t);
    return (k);
  }
  
  proc __quarter_round_ref (k:W32.t Array16.t, a:int, b:int, c:int, d:int) : 
  W32.t Array16.t = {
    
    
    
    k <@ __line_ref (k, b, a, d, 7);
    k <@ __line_ref (k, c, b, a, 9);
    k <@ __line_ref (k, d, c, b, 13);
    k <@ __line_ref (k, a, d, c, 18);
    return (k);
  }
  
  proc __column_round_ref (k:W32.t Array16.t, k2:W32.t, k3:W32.t) : W32.t Array16.t *
                                                                    W32.t *
                                                                    W32.t = {
    
    var k12:W32.t;
    var k13:W32.t;
    
    k <@ __quarter_round_ref (k, 0, 4, 8, 12);
    k12 <- k.[12];
    k.[2] <- k2;
    k <@ __quarter_round_ref (k, 5, 9, 13, 1);
    k13 <- k.[13];
    k.[3] <- k3;
    k <@ __quarter_round_ref (k, 10, 14, 2, 6);
    k <@ __quarter_round_ref (k, 15, 3, 7, 11);
    return (k, k12, k13);
  }
  
  proc __line_round_ref (k:W32.t Array16.t, k12:W32.t, k13:W32.t) : W32.t Array16.t *
                                                                    W32.t *
                                                                    W32.t = {
    
    var k2:W32.t;
    var k3:W32.t;
    
    k <@ __quarter_round_ref (k, 0, 1, 2, 3);
    k2 <- k.[2];
    k.[12] <- k12;
    k <@ __quarter_round_ref (k, 5, 6, 7, 4);
    k3 <- k.[3];
    k.[13] <- k13;
    k <@ __quarter_round_ref (k, 10, 11, 8, 9);
    k <@ __quarter_round_ref (k, 15, 12, 13, 14);
    return (k, k2, k3);
  }
  
  proc __double_round_ref (k:W32.t Array16.t, k2:W32.t, k3:W32.t) : W32.t Array16.t *
                                                                    W32.t *
                                                                    W32.t = {
    
    var k12:W32.t;
    var k13:W32.t;
    
    (k, k12, k13) <@ __column_round_ref (k, k2, k3);
    (k, k2, k3) <@ __line_round_ref (k, k12, k13);
    return (k, k2, k3);
  }
  
  proc __rounds_ref (k:W32.t Array16.t, k2:W32.t, k3:W32.t) : W32.t Array16.t *
                                                              W32.t = {
    
    var k15:W32.t;
    var c:W32.t;
    var s_c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    c <- (W32.of_int (20 %/ 2));
    s_c <- c;
    (k, k2, k3) <@ __double_round_ref (k, k2, k3);
    c <- s_c;
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      s_c <- c;
      (k, k2, k3) <@ __double_round_ref (k, k2, k3);
      c <- s_c;
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    k15 <- k.[15];
    k.[2] <- k2;
    k.[3] <- k3;
    return (k, k15);
  }
  
  proc __hsalsa20_init_ref (nonce:W64.t, key:W64.t) : W32.t Array16.t *
                                                      W32.t * W32.t = {
    var aux: int;
    
    var st:W32.t Array16.t;
    var st2:W32.t;
    var st3:W32.t;
    var i:int;
    st <- witness;
    i <- 0;
    while (i < 4) {
      st.[(i + 1)] <-
      (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    st2 <- st.[2];
    st3 <- st.[3];
    i <- 4;
    while (i < 8) {
      st.[(i + 7)] <-
      (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    st.[0] <- (W32.of_int 1634760805);
    st.[5] <- (W32.of_int 857760878);
    st.[10] <- (W32.of_int 2036477234);
    st.[15] <- (W32.of_int 1797285236);
    i <- 0;
    while (i < 4) {
      st.[(i + 6)] <-
      (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    return (st, st2, st3);
  }
  
  proc __hsalsa20_store_ref (sk:W32.t Array16.t) : W32.t Array8.t = {
    var aux: int;
    
    var sks:W32.t Array8.t;
    var i:int;
    sks <- witness;
    i <- 0;
    while (i < 4) {
      sks.[i] <- sk.[(5 * i)];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      sks.[(i + 4)] <- sk.[(6 + i)];
      i <- i + 1;
    }
    return (sks);
  }
  
  proc __hsalsa20_ref (nonce:W64.t, key:W64.t) : W32.t Array8.t = {
    
    var sk:W32.t Array8.t;
    var st:W32.t Array16.t;
    var st2:W32.t;
    var st3:W32.t;
    var st15:W32.t;
    sk <- witness;
    st <- witness;
    (st, st2, st3) <@ __hsalsa20_init_ref (nonce, key);
    (st, st15) <@ __rounds_ref (st, st2, st3);
    st.[15] <- st15;
    sk <@ __hsalsa20_store_ref (st);
    return (sk);
  }
  
  proc __init_v_1_avx2 (nonce:W64.t, key:W32.t Array8.t) : W256.t Array16.t = {
    var aux: int;
    
    var _st:W256.t Array16.t;
    var _key:W32.t Array8.t;
    var i:int;
    var st:W256.t Array16.t;
    _key <- witness;
    _st <- witness;
    st <- witness;
    _key <-
    (Array8.init (fun i => get32
    (WArray32.init8 (fun i => copy_32 (Array32.init (fun i => get8
                                      (WArray32.init32 (fun i => key.[i]))
                                      i)).[i]))
    i));
    i <- 0;
    while (i < 4) {
      st.[(i + 1)] <- VPBROADCAST_8u32 _key.[i];
      i <- i + 1;
    }
    i <- 4;
    while (i < 8) {
      st.[(i + 7)] <- VPBROADCAST_8u32 _key.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      st.[(i * 5)] <- SALSA20_SIGMA_V_AVX2.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 2) {
      st.[(i + 6)] <-
      VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (i * 4)))));
      i <- i + 1;
    }
    st.[8] <- SALSA20_P76543210_V_AVX2;
    st.[9] <- setw0_256 ;
    _st <-
    (Array16.init (fun i => get256
    (WArray512.init8 (fun i => copy_256 (Array512.init (fun i => get8
                                        (WArray512.init256 (fun i => st.[i]))
                                        i)).[i]))
    i));
    return (_st);
  }
  
  proc __increment_counter_v_avx2 (st:W256.t Array16.t) : W256.t Array16.t = {
    
    var x:W256.t;
    var y:W256.t;
    var a:W256.t;
    var b:W256.t;
    
    x <- st.[8];
    y <- st.[9];
    a <- VPUNPCKL_8u32 x y;
    b <- VPUNPCKH_8u32 x y;
    a <- (a \vadd64u256 SALSA20_P8888_V_AVX2);
    b <- (b \vadd64u256 SALSA20_P8888_V_AVX2);
    x <- VPUNPCKL_8u32 a b;
    y <- VPUNPCKH_8u32 a b;
    a <- VPUNPCKL_8u32 x y;
    b <- VPUNPCKH_8u32 x y;
    st.[8] <- a;
    st.[9] <- b;
    return (st);
  }
  
  proc __store_xor_h_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                           k:W256.t Array4.t) : W64.t * W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <-
      (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (32 * i))))));
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) 
      k.[i];
      i <- i + 1;
    }
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 128);
    return (output, plain, len);
  }
  
  proc __store_xor_last_h_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                                k:W256.t Array4.t) : unit = {
    var aux: int;
    
    var i:int;
    var r0:W128.t;
    var r1:W64.t;
    var r2:W8.t;
    
    if (((W64.of_int 64) \ule len)) {
      i <- 0;
      while (i < 2) {
        k.[i] <-
        (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (32 * i))))));
        Glob.mem <-
        storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) 
        k.[i];
        i <- i + 1;
      }
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 64);
      k.[0] <- k.[2];
      k.[1] <- k.[3];
    } else {
      
    }
    if (((W64.of_int 32) \ule len)) {
      k.[0] <-
      (k.[0] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 0))) k.[0];
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 32);
      k.[0] <- k.[1];
    } else {
      
    }
    r0 <- (truncateu128 k.[0]);
    if (((W64.of_int 16) \ule len)) {
      r0 <-
      (r0 `^` (loadW128 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r0;
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 16);
      r0 <- VEXTRACTI128 k.[0] (W8.of_int 1);
    } else {
      
    }
    r1 <- VPEXTR_64 r0 (W8.of_int 0);
    if (((W64.of_int 8) \ule len)) {
      r1 <-
      (r1 `^` (loadW64 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r1;
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 8);
      r1 <- VPEXTR_64 r0 (W8.of_int 1);
    } else {
      
    }
    
    while (((W64.of_int 0) \ult len)) {
      r2 <- (truncateu8 r1);
      r2 <-
      (r2 `^` (loadW8 Glob.mem (W64.to_uint (plain + (W64.of_int 0)))));
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r2;
      r1 <- (r1 `>>` (W8.of_int 8));
      (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 1);
    }
    return ();
  }
  
  proc __store_xor_h_x2_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                              k1:W256.t Array4.t, k2:W256.t Array4.t) : 
  W64.t * W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k1.[i] <-
      (k1.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (32 * i))))));
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) 
      k1.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      k2.[i] <-
      (k2.[i] `^` (loadW256 Glob.mem (W64.to_uint (plain + (W64.of_int (32 * (i + 4)))))));
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * (i + 4))))) 
      k2.[i];
      i <- i + 1;
    }
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 256);
    return (output, plain, len);
  }
  
  proc __store_xor_last_h_x2_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                                   k1:W256.t Array4.t, k2:W256.t Array4.t) : unit = {
    
    
    
    if (((W64.of_int 128) \ule len)) {
      (output, plain, len) <@ __store_xor_h_avx2 (output, plain, len, k1);
      k1 <-
      (Array4.init (fun i => get256
      (WArray128.init8 (fun i => copy_256 (Array128.init (fun i => get8
                                          (WArray128.init256 (fun i => k2.[i]))
                                          i)).[i]))
      i));
    } else {
      
    }
    __store_xor_last_h_avx2 (output, plain, len, k1);
    return ();
  }
  
  proc __store_h_avx2 (output:W64.t, len:W64.t, k:W256.t Array4.t) : 
  W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) 
      k.[i];
      i <- i + 1;
    }
    (output, len) <@ __update_ptr_ref (output, len, 128);
    return (output, len);
  }
  
  proc __store_last_h_avx2 (output:W64.t, len:W64.t, k:W256.t Array4.t) : unit = {
    var aux: int;
    
    var i:int;
    var r0:W128.t;
    var r1:W64.t;
    var r2:W8.t;
    
    if (((W64.of_int 64) \ule len)) {
      i <- 0;
      while (i < 2) {
        Glob.mem <-
        storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) 
        k.[i];
        i <- i + 1;
      }
      (output, len) <@ __update_ptr_ref (output, len, 64);
      k.[0] <- k.[2];
      k.[1] <- k.[3];
    } else {
      
    }
    if (((W64.of_int 32) \ule len)) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 0))) k.[0];
      (output, len) <@ __update_ptr_ref (output, len, 32);
      k.[0] <- k.[1];
    } else {
      
    }
    r0 <- (truncateu128 k.[0]);
    if (((W64.of_int 16) \ule len)) {
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r0;
      (output, len) <@ __update_ptr_ref (output, len, 16);
      r0 <- VEXTRACTI128 k.[0] (W8.of_int 1);
    } else {
      
    }
    r1 <- VPEXTR_64 r0 (W8.of_int 0);
    if (((W64.of_int 8) \ule len)) {
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r1;
      (output, len) <@ __update_ptr_ref (output, len, 8);
      r1 <- VPEXTR_64 r0 (W8.of_int 1);
    } else {
      
    }
    
    while (((W64.of_int 0) \ult len)) {
      r2 <- (truncateu8 r1);
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) r2;
      r1 <- (r1 `>>` (W8.of_int 8));
      (output, len) <@ __update_ptr_ref (output, len, 1);
    }
    return ();
  }
  
  proc __store_h_x2_avx2 (output:W64.t, len:W64.t, k1:W256.t Array4.t,
                          k2:W256.t Array4.t) : W64.t * W64.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) 
      k1.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 4) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * (i + 4))))) 
      k2.[i];
      i <- i + 1;
    }
    (output, len) <@ __update_ptr_ref (output, len, 256);
    return (output, len);
  }
  
  proc __store_last_h_x2_avx2 (output:W64.t, len:W64.t, k1:W256.t Array4.t,
                               k2:W256.t Array4.t) : unit = {
    
    
    
    if (((W64.of_int 128) \ule len)) {
      (output, len) <@ __store_h_avx2 (output, len, k1);
      k1 <-
      (Array4.init (fun i => get256
      (WArray128.init8 (fun i => copy_256 (Array128.init (fun i => get8
                                          (WArray128.init256 (fun i => k2.[i]))
                                          i)).[i]))
      i));
    } else {
      
    }
    __store_last_h_avx2 (output, len, k1);
    return ();
  }
  
  proc __sub_rotate_avx2 (t:W256.t Array8.t) : W256.t Array8.t = {
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
  
  proc __rotate_avx2 (x:W256.t Array8.t) : W256.t Array8.t = {
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
    t <@ __sub_rotate_avx2 (t);
    return (t);
  }
  
  proc __rotate_stack_avx2 (s:W256.t Array8.t) : W256.t Array8.t = {
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
    t <@ __sub_rotate_avx2 (t);
    return (t);
  }
  
  proc __rotate_first_half_v_avx2 (k:W256.t Array16.t) : W256.t Array8.t *
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
    k0_7 <@ __rotate_avx2 (k0_7);
    return (k0_7, s_k8_15);
  }
  
  proc __rotate_second_half_v_avx2 (s_k8_15:W256.t Array8.t) : W256.t Array8.t = {
    
    var k8_15:W256.t Array8.t;
    k8_15 <- witness;
    k8_15 <@ __rotate_stack_avx2 (s_k8_15);
    return (k8_15);
  }
  
  proc __interleave_avx2 (s:W256.t Array8.t, k:W256.t Array8.t, o:int) : 
  W256.t Array4.t * W256.t Array4.t = {
    
    var sk1:W256.t Array4.t;
    var sk2:W256.t Array4.t;
    sk1 <- witness;
    sk2 <- witness;
    sk1.[0] <- s.[(o + 0)];
    sk1.[1] <- k.[(o + 0)];
    sk1.[2] <- s.[(o + 1)];
    sk1.[3] <- k.[(o + 1)];
    sk2.[0] <- s.[(o + 2)];
    sk2.[1] <- k.[(o + 2)];
    sk2.[2] <- s.[(o + 3)];
    sk2.[3] <- k.[(o + 3)];
    return (sk1, sk2);
  }
  
  proc __store_xor_half_interleave_v_avx2 (output:W64.t, plain:W64.t,
                                           len:W64.t, k:W256.t Array8.t,
                                           o:int) : unit = {
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
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) 
      k.[i];
      i <- i + 1;
    }
    return ();
  }
  
  proc __store_xor_v_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                           k:W256.t Array16.t) : W64.t * W64.t * W64.t = {
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx2 (k);
    __store_xor_half_interleave_v_avx2 (output, plain, len, k0_7, 0);
    k8_15 <@ __rotate_second_half_v_avx2 (s_k8_15);
    __store_xor_half_interleave_v_avx2 (output, plain, len, k8_15, 32);
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 512);
    return (output, plain, len);
  }
  
  proc __store_xor_last_v_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                                k:W256.t Array16.t) : unit = {
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var s_k0_7:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    var k0_3:W256.t Array4.t;
    var k4_7:W256.t Array4.t;
    k0_3 <- witness;
    k0_7 <- witness;
    k4_7 <- witness;
    k8_15 <- witness;
    s_k0_7 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx2 (k);
    s_k0_7 <-
    (Array8.init (fun i => get256
    (WArray256.init8 (fun i => copy_256 (Array256.init (fun i => get8
                                        (WArray256.init256 (fun i => k0_7.[i]))
                                        i)).[i]))
    i));
    k8_15 <@ __rotate_second_half_v_avx2 (s_k8_15);
    (k0_3, k4_7) <@ __interleave_avx2 (s_k0_7, k8_15, 0);
    if (((W64.of_int 256) \ule len)) {
      (output, plain, len) <@ __store_xor_h_x2_avx2 (output, plain, len,
      k0_3, k4_7);
      (k0_3, k4_7) <@ __interleave_avx2 (s_k0_7, k8_15, 4);
    } else {
      
    }
    __store_xor_last_h_x2_avx2 (output, plain, len, k0_3, k4_7);
    return ();
  }
  
  proc __store_half_interleave_v_avx2 (output:W64.t, len:W64.t,
                                       k:W256.t Array8.t, o:int) : unit = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 8) {
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) 
      k.[i];
      i <- i + 1;
    }
    return ();
  }
  
  proc __store_v_avx2 (output:W64.t, len:W64.t, k:W256.t Array16.t) : 
  W64.t * W64.t = {
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx2 (k);
    __store_half_interleave_v_avx2 (output, len, k0_7, 0);
    k8_15 <@ __rotate_second_half_v_avx2 (s_k8_15);
    __store_half_interleave_v_avx2 (output, len, k8_15, 32);
    (output, len) <@ __update_ptr_ref (output, len, 512);
    return (output, len);
  }
  
  proc __store_last_v_avx2 (output:W64.t, len:W64.t, k:W256.t Array16.t) : unit = {
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var s_k0_7:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    var k0_3:W256.t Array4.t;
    var k4_7:W256.t Array4.t;
    k0_3 <- witness;
    k0_7 <- witness;
    k4_7 <- witness;
    k8_15 <- witness;
    s_k0_7 <- witness;
    s_k8_15 <- witness;
    (k0_7, s_k8_15) <@ __rotate_first_half_v_avx2 (k);
    s_k0_7 <-
    (Array8.init (fun i => get256
    (WArray256.init8 (fun i => copy_256 (Array256.init (fun i => get8
                                        (WArray256.init256 (fun i => k0_7.[i]))
                                        i)).[i]))
    i));
    k8_15 <@ __rotate_second_half_v_avx2 (s_k8_15);
    (k0_3, k4_7) <@ __interleave_avx2 (s_k0_7, k8_15, 0);
    if (((W64.of_int 256) \ule len)) {
      (output, len) <@ __store_h_x2_avx2 (output, len, k0_3, k4_7);
      (k0_3, k4_7) <@ __interleave_avx2 (s_k0_7, k8_15, 4);
    } else {
      
    }
    __store_last_h_x2_avx2 (output, len, k0_3, k4_7);
    return ();
  }
  
  proc __copy_state_v_avx2 (st:W256.t Array16.t) : W256.t Array16.t = {
    
    var k:W256.t Array16.t;
    k <- witness;
    k <-
    (Array16.init (fun i => get256
    (WArray512.init8 (fun i => copy_256 (Array512.init (fun i => get8
                                        (WArray512.init256 (fun i => st.[i]))
                                        i)).[i]))
    i));
    return (k);
  }
  
  proc __rotate_v_avx2 (x:W256.t, r:int) : W256.t = {
    
    var t:W256.t;
    
    t <- (x \vshl32u256 (W8.of_int r));
    x <- (x \vshr32u256 (W8.of_int (32 - r)));
    x <- (x `^` t);
    return (x);
  }
  
  proc __line_v_avx2 (k:W256.t Array16.t, a:int, b:int, c:int, r:int) : 
  W256.t Array16.t = {
    
    var t:W256.t;
    
    t <- (k.[b] \vadd32u256 k.[c]);
    t <@ __rotate_v_avx2 (t, r);
    k.[a] <- (k.[a] `^` t);
    return (k);
  }
  
  proc __quarter_round_v_avx2 (k:W256.t Array16.t, a:int, b:int, c:int, d:int) : 
  W256.t Array16.t = {
    
    
    
    k <@ __line_v_avx2 (k, b, a, d, 7);
    k <@ __line_v_avx2 (k, c, b, a, 9);
    k <@ __line_v_avx2 (k, d, c, b, 13);
    k <@ __line_v_avx2 (k, a, d, c, 18);
    return (k);
  }
  
  proc __column_round_v_avx2 (k:W256.t Array16.t, k2:W256.t, k3:W256.t) : 
  W256.t Array16.t * W256.t * W256.t = {
    
    var k12:W256.t;
    var k13:W256.t;
    
    k <@ __quarter_round_v_avx2 (k, 0, 4, 8, 12);
    k12 <- k.[12];
    k.[2] <- k2;
    k <@ __quarter_round_v_avx2 (k, 5, 9, 13, 1);
    k13 <- k.[13];
    k.[3] <- k3;
    k <@ __quarter_round_v_avx2 (k, 10, 14, 2, 6);
    k <@ __quarter_round_v_avx2 (k, 15, 3, 7, 11);
    return (k, k12, k13);
  }
  
  proc __line_round_v_avx2 (k:W256.t Array16.t, k12:W256.t, k13:W256.t) : 
  W256.t Array16.t * W256.t * W256.t = {
    
    var k2:W256.t;
    var k3:W256.t;
    
    k <@ __quarter_round_v_avx2 (k, 0, 1, 2, 3);
    k2 <- k.[2];
    k.[12] <- k12;
    k <@ __quarter_round_v_avx2 (k, 5, 6, 7, 4);
    k3 <- k.[3];
    k.[13] <- k13;
    k <@ __quarter_round_v_avx2 (k, 10, 11, 8, 9);
    k <@ __quarter_round_v_avx2 (k, 15, 12, 13, 14);
    return (k, k2, k3);
  }
  
  proc __double_round_v_avx2 (k:W256.t Array16.t, k2:W256.t, k3:W256.t) : 
  W256.t Array16.t * W256.t * W256.t = {
    
    var k12:W256.t;
    var k13:W256.t;
    
    (k, k12, k13) <@ __column_round_v_avx2 (k, k2, k3);
    (k, k2, k3) <@ __line_round_v_avx2 (k, k12, k13);
    return (k, k2, k3);
  }
  
  proc __rounds_v_avx2 (k:W256.t Array16.t) : W256.t Array16.t = {
    
    var k2:W256.t;
    var k3:W256.t;
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    k2 <- k.[2];
    k3 <- k.[3];
    c <- (W32.of_int (20 %/ 2));
    (k, k2, k3) <@ __double_round_v_avx2 (k, k2, k3);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      (k, k2, k3) <@ __double_round_v_avx2 (k, k2, k3);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    k.[2] <- k2;
    k.[3] <- k3;
    return (k);
  }
  
  proc __sum_states_v_avx2 (k:W256.t Array16.t, st:W256.t Array16.t) : 
  W256.t Array16.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 16) {
      k.[i] <- (k.[i] \vadd32u256 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc __salsa20_xor_v_1_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                               nonce:W64.t, key:W32.t Array8.t) : unit = {
    
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    st <@ __init_v_1_avx2 (nonce, key);
    
    while (((W64.of_int 512) \ule len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k);
      k <@ __sum_states_v_avx2 (k, st);
      (output, plain, len) <@ __store_xor_v_avx2 (output, plain, len, k);
      st <@ __increment_counter_v_avx2 (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k);
      k <@ __sum_states_v_avx2 (k, st);
      __store_xor_last_v_avx2 (output, plain, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __salsa20_v_1_avx2 (output:W64.t, len:W64.t, nonce:W64.t,
                           key:W32.t Array8.t) : unit = {
    
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    st <@ __init_v_1_avx2 (nonce, key);
    
    while (((W64.of_int 512) \ule len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k);
      k <@ __sum_states_v_avx2 (k, st);
      (output, len) <@ __store_v_avx2 (output, len, k);
      st <@ __increment_counter_v_avx2 (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k);
      k <@ __sum_states_v_avx2 (k, st);
      __store_last_v_avx2 (output, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __salsa20_xor_1_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                             nonce:W64.t, key:W32.t Array8.t) : unit = {
    
    
    
    __salsa20_xor_v_1_avx2 (output, plain, len, nonce, key);
    return ();
  }
  
  proc __salsa20_1_avx2 (output:W64.t, len:W64.t, nonce:W64.t,
                         key:W32.t Array8.t) : unit = {
    
    
    
    __salsa20_v_1_avx2 (output, len, nonce, key);
    return ();
  }
  
  proc __xsalsa20_xor_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                            nonce:W64.t, key:W64.t) : unit = {
    
    var _output:W64.t;
    var _plain:W64.t;
    var _len:W64.t;
    var _nonce:W64.t;
    var _key:W64.t;
    var subkey:W32.t Array8.t;
    subkey <- witness;
    _output <- output;
    _plain <- plain;
    _len <- len;
    _nonce <- nonce;
    _key <- key;
    subkey <@ __hsalsa20_ref (nonce, key);
    output <- _output;
    plain <- _plain;
    len <- _len;
    nonce <- _nonce;
    nonce <- (nonce + (W64.of_int 16));
    __salsa20_xor_1_avx2 (output, plain, len, nonce, subkey);
    return ();
  }
  
  proc __xsalsa20_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var _output:W64.t;
    var _len:W64.t;
    var _nonce:W64.t;
    var _key:W64.t;
    var subkey:W32.t Array8.t;
    subkey <- witness;
    _output <- output;
    _len <- len;
    _nonce <- nonce;
    _key <- key;
    subkey <@ __hsalsa20_ref (nonce, key);
    output <- _output;
    len <- _len;
    nonce <- _nonce;
    nonce <- (nonce + (W64.of_int 16));
    __salsa20_1_avx2 (output, len, nonce, subkey);
    return ();
  }
  
  proc jade_stream_xsalsa20_amd64_avx2_xor (output:W64.t, plain:W64.t,
                                            len:W64.t, nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __xsalsa20_xor_avx2 (output, plain, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
  
  proc jade_stream_xsalsa20_amd64_avx2 (output:W64.t, len:W64.t, nonce:W64.t,
                                        key:W64.t) : W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __xsalsa20_avx2 (output, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

