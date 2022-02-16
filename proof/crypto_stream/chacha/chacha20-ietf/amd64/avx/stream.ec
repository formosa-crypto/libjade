require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array4 Array8 Array16.
require import WArray64 WArray128 WArray256.

abbrev CHACHA_P4444_V_AVX = W128.of_int 316912650130844326686193876996.


abbrev CHACHA_P0002_H_AVX = W128.of_int 2.


abbrev CHACHA_P0001_H_AVX = W128.of_int 1.


abbrev CHACHA_R8_AVX = W128.of_int 18676936380593224926704134051422339075.


abbrev CHACHA_R16_AVX = W128.of_int 17342576855639742879858139805557719810.


abbrev CHACHA_P44_V_AVX = W128.of_int 73786976294838206468.


abbrev CHACHA_P3210_V_AVX = W128.of_int 237684487579686500932345921536.


abbrev CHACHA_SIGMA_V_AVX = Array4.of_list witness [W128.of_int 129519094760645606705801321186012985445;
W128.of_int 67958818256384961134917122602578240622;
W128.of_int 161346349289517898123623123153137577266;
W128.of_int 142395606795449994141864265039627707764].


abbrev CHACHA_P02_H_AVX = W128.of_int 2.


abbrev CHACHA_P01_H_AVX = W128.of_int 1.


abbrev CHACHA_SIGMA_H_AVX = W128.of_int 142395606799862307709414285570774956133.


module M = {
  proc __init_h_avx (nonce:W64.t, key:W64.t) : W128.t Array4.t = {
    
    var st:W128.t Array4.t;
    st <- witness;
    st.[0] <- CHACHA_SIGMA_H_AVX;
    st.[1] <- (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 0))));
    st.[2] <- (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 16))));
    st.[3] <- setw0_128 ;
    st.[3] <- VPINSR_4u32 st.[3]
    (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int 0)))) (W8.of_int 1);
    st.[3] <- VPINSR_2u64 st.[3]
    (loadW64 Glob.mem (W64.to_uint (nonce + (W64.of_int 4)))) (W8.of_int 1);
    return (st);
  }
  
  proc __increment_counter02_h_avx (st:W128.t Array4.t) : W128.t Array4.t = {
    
    
    
    st.[3] <- (st.[3] \vadd32u128 CHACHA_P0002_H_AVX);
    return (st);
  }
  
  proc __increment_counter01_h_avx (st:W128.t Array4.t) : W128.t Array4.t = {
    
    
    
    st.[3] <- (st.[3] \vadd32u128 CHACHA_P0001_H_AVX);
    return (st);
  }
  
  proc __init_v_avx (nonce:W64.t, key:W64.t) : W128.t Array16.t = {
    var aux: int;
    
    var _st:W128.t Array16.t;
    var i:int;
    var st:W128.t Array16.t;
    _st <- witness;
    st <- witness;
    i <- 0;
    while (i < 4) {
      st.[i] <- CHACHA_SIGMA_V_AVX.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      st.[(4 + i)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (4 * i)))));
      i <- i + 1;
    }
    st.[12] <- CHACHA_P3210_V_AVX;
    i <- 0;
    while (i < 3) {
      st.[(13 + i)] <-
      VPBROADCAST_4u32 (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (4 * i)))));
      i <- i + 1;
    }
    _st <-
    (Array16.init (fun i => get128
    (WArray256.init8 (fun i => copy_128 (Array256.init (fun i => get8
                                        (WArray256.init128 (fun i => st.[i]))
                                        i)).[i]))
    i));
    return (_st);
  }
  
  proc __increment_counter_v_avx (st:W128.t Array16.t) : W128.t Array16.t = {
    
    var c:W128.t;
    
    c <- CHACHA_P4444_V_AVX;
    c <- (c \vadd32u128 st.[12]);
    st.[12] <- c;
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
  
  proc __copy_state_h_avx (st:W128.t Array4.t) : W128.t Array4.t = {
    
    var k:W128.t Array4.t;
    k <- witness;
    k <-
    (Array4.init (fun i => get128
    (WArray64.init8 (fun i => copy_128 (Array64.init (fun i => get8
                                       (WArray64.init128 (fun i => st.[i]))
                                       i)).[i]))
    i));
    return (k);
  }
  
  proc __rotate_h_avx (k:W128.t Array4.t, i:int, r:int, r16:W128.t, r8:W128.t) : 
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
  
  proc __line_h_avx (k:W128.t Array4.t, a:int, b:int, c:int, r:int,
                     r16:W128.t, r8:W128.t) : W128.t Array4.t = {
    
    
    
    k.[a] <- (k.[a] \vadd32u128 k.[b]);
    k.[c] <- (k.[c] `^` k.[a]);
    k <@ __rotate_h_avx (k, c, r, r16, r8);
    return (k);
  }
  
  proc __round_h_avx (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : W128.t Array4.t = {
    
    
    
    k <@ __line_h_avx (k, 0, 1, 3, 16, r16, r8);
    k <@ __line_h_avx (k, 2, 3, 1, 12, r16, r8);
    k <@ __line_h_avx (k, 0, 1, 3, 8, r16, r8);
    k <@ __line_h_avx (k, 2, 3, 1, 7, r16, r8);
    return (k);
  }
  
  proc __shuffle_state_h_avx (k:W128.t Array4.t) : W128.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_128 k.[1]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    k.[2] <- VPSHUFD_128 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_128 k.[3]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    return (k);
  }
  
  proc __reverse_shuffle_state_h_avx (k:W128.t Array4.t) : W128.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_128 k.[1]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    k.[2] <- VPSHUFD_128 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_128 k.[3]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    return (k);
  }
  
  proc __column_round_h_avx (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : 
  W128.t Array4.t = {
    
    
    
    k <@ __round_h_avx (k, r16, r8);
    return (k);
  }
  
  proc __diagonal_round_h_avx (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : 
  W128.t Array4.t = {
    
    
    
    k <@ __shuffle_state_h_avx (k);
    k <@ __round_h_avx (k, r16, r8);
    k <@ __reverse_shuffle_state_h_avx (k);
    return (k);
  }
  
  proc __double_round_h_avx (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : 
  W128.t Array4.t = {
    
    
    
    k <@ __column_round_h_avx (k, r16, r8);
    k <@ __diagonal_round_h_avx (k, r16, r8);
    return (k);
  }
  
  proc __rounds_h_avx (k:W128.t Array4.t, r16:W128.t, r8:W128.t) : W128.t Array4.t = {
    
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    c <- (W32.of_int (20 %/ 2));
    k <@ __double_round_h_avx (k, r16, r8);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      k <@ __double_round_h_avx (k, r16, r8);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    return (k);
  }
  
  proc __sum_states_h_avx (k:W128.t Array4.t, st:W128.t Array4.t) : W128.t Array4.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <- (k.[i] \vadd32u128 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc __copy_state_h_x2_avx (st:W128.t Array4.t) : W128.t Array4.t *
                                                    W128.t Array4.t = {
    
    var k1:W128.t Array4.t;
    var k2:W128.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    k1 <-
    (Array4.init (fun i => get128
    (WArray64.init8 (fun i => copy_128 (Array64.init (fun i => get8
                                       (WArray64.init128 (fun i => st.[i]))
                                       i)).[i]))
    i));
    k2 <-
    (Array4.init (fun i => get128
    (WArray64.init8 (fun i => copy_128 (Array64.init (fun i => get8
                                       (WArray64.init128 (fun i => st.[i]))
                                       i)).[i]))
    i));
    k2 <@ __increment_counter01_h_avx (k2);
    return (k1, k2);
  }
  
  proc __round_h_x2_inline_avx (k1:W128.t Array4.t, k2:W128.t Array4.t,
                                r16:W128.t, r8:W128.t) : W128.t Array4.t *
                                                         W128.t Array4.t = {
    
    var t1:W128.t;
    
    k1.[0] <- (k1.[0] \vadd32u128 k1.[1]);
    k2.[0] <- (k2.[0] \vadd32u128 k2.[1]);
    k1.[3] <- (k1.[3] `^` k1.[0]);
    k2.[3] <- (k2.[3] `^` k2.[0]);
    k1 <@ __rotate_h_avx (k1, 3, 16, r16, r8);
    k2 <@ __rotate_h_avx (k2, 3, 16, r16, r8);
    k1.[2] <- (k1.[2] \vadd32u128 k1.[3]);
    k2.[2] <- (k2.[2] \vadd32u128 k2.[3]);
    k1.[1] <- (k1.[1] `^` k1.[2]);
    t1 <- (k1.[1] \vshl32u128 (W8.of_int 12));
    k1.[1] <- (k1.[1] \vshr32u128 (W8.of_int 20));
    k2.[1] <- (k2.[1] `^` k2.[2]);
    k1.[1] <- (k1.[1] `^` t1);
    k2 <@ __rotate_h_avx (k2, 1, 12, r16, r8);
    k1.[0] <- (k1.[0] \vadd32u128 k1.[1]);
    k2.[0] <- (k2.[0] \vadd32u128 k2.[1]);
    k1.[3] <- (k1.[3] `^` k1.[0]);
    k2.[3] <- (k2.[3] `^` k2.[0]);
    k1 <@ __rotate_h_avx (k1, 3, 8, r16, r8);
    k2 <@ __rotate_h_avx (k2, 3, 8, r16, r8);
    k1.[2] <- (k1.[2] \vadd32u128 k1.[3]);
    k2.[2] <- (k2.[2] \vadd32u128 k2.[3]);
    k1.[1] <- (k1.[1] `^` k1.[2]);
    t1 <- (k1.[1] \vshl32u128 (W8.of_int 7));
    k1.[1] <- (k1.[1] \vshr32u128 (W8.of_int 25));
    k2.[1] <- (k2.[1] `^` k2.[2]);
    k1.[1] <- (k1.[1] `^` t1);
    k2 <@ __rotate_h_avx (k2, 1, 7, r16, r8);
    return (k1, k2);
  }
  
  proc __shuffle_state_h_x2_avx (k1:W128.t Array4.t, k2:W128.t Array4.t) : 
  W128.t Array4.t * W128.t Array4.t = {
    
    
    
    k1 <@ __shuffle_state_h_avx (k1);
    k2 <@ __shuffle_state_h_avx (k2);
    return (k1, k2);
  }
  
  proc __reverse_shuffle_state_h_x2_avx (k1:W128.t Array4.t,
                                         k2:W128.t Array4.t) : W128.t Array4.t *
                                                               W128.t Array4.t = {
    
    
    
    k1 <@ __reverse_shuffle_state_h_avx (k1);
    k2 <@ __reverse_shuffle_state_h_avx (k2);
    return (k1, k2);
  }
  
  proc __column_round_h_x2_avx (k1:W128.t Array4.t, k2:W128.t Array4.t,
                                r16:W128.t, r8:W128.t) : W128.t Array4.t *
                                                         W128.t Array4.t = {
    
    
    
    (k1, k2) <@ __round_h_x2_inline_avx (k1, k2, r16, r8);
    return (k1, k2);
  }
  
  proc __diagonal_round_h_x2_avx (k1:W128.t Array4.t, k2:W128.t Array4.t,
                                  r16:W128.t, r8:W128.t) : W128.t Array4.t *
                                                           W128.t Array4.t = {
    
    
    
    (k1, k2) <@ __shuffle_state_h_x2_avx (k1, k2);
    (k1, k2) <@ __round_h_x2_inline_avx (k1, k2, r16, r8);
    (k1, k2) <@ __reverse_shuffle_state_h_x2_avx (k1, k2);
    return (k1, k2);
  }
  
  proc __double_round_h_x2_avx (k1:W128.t Array4.t, k2:W128.t Array4.t,
                                r16:W128.t, r8:W128.t) : W128.t Array4.t *
                                                         W128.t Array4.t = {
    
    
    
    (k1, k2) <@ __column_round_h_x2_avx (k1, k2, r16, r8);
    (k1, k2) <@ __diagonal_round_h_x2_avx (k1, k2, r16, r8);
    return (k1, k2);
  }
  
  proc __rounds_h_x2_avx (k1:W128.t Array4.t, k2:W128.t Array4.t, r16:W128.t,
                          r8:W128.t) : W128.t Array4.t * W128.t Array4.t = {
    
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    c <- (W32.of_int (20 %/ 2));
    (k1, k2) <@ __double_round_h_x2_avx (k1, k2, r16, r8);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      (k1, k2) <@ __double_round_h_x2_avx (k1, k2, r16, r8);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    return (k1, k2);
  }
  
  proc __sum_states_h_x2_avx (k1:W128.t Array4.t, k2:W128.t Array4.t,
                              st:W128.t Array4.t) : W128.t Array4.t *
                                                    W128.t Array4.t = {
    
    
    
    k1 <@ __sum_states_h_avx (k1, st);
    k2 <@ __sum_states_h_avx (k2, st);
    k2 <@ __increment_counter01_h_avx (k2);
    return (k1, k2);
  }
  
  proc __chacha_xor_h_x2_avx (output:W64.t, plain:W64.t, len:W64.t,
                              nonce:W64.t, key:W64.t) : unit = {
    
    var r16:W128.t;
    var r8:W128.t;
    var st:W128.t Array4.t;
    var k1:W128.t Array4.t;
    var k2:W128.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    r16 <- CHACHA_R16_AVX;
    r8 <- CHACHA_R8_AVX;
    st <@ __init_h_avx (nonce, key);
    
    while (((W64.of_int 128) \ule len)) {
      (k1, k2) <@ __copy_state_h_x2_avx (st);
      (k1, k2) <@ __rounds_h_x2_avx (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx (k1, k2, st);
      (output, plain, len) <@ __store_xor_h_x2_avx (output, plain, len, k1,
      k2);
      st <@ __increment_counter02_h_avx (st);
    }
    if (((W64.of_int 64) \ult len)) {
      (k1, k2) <@ __copy_state_h_x2_avx (st);
      (k1, k2) <@ __rounds_h_x2_avx (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx (k1, k2, st);
      (output, plain, len) <@ __store_xor_h_avx (output, plain, len, k1);
      __store_xor_last_h_avx (output, plain, len, k2);
    } else {
      k1 <@ __copy_state_h_avx (st);
      k1 <@ __rounds_h_avx (k1, r16, r8);
      k1 <@ __sum_states_h_avx (k1, st);
      __store_xor_last_h_avx (output, plain, len, k1);
    }
    return ();
  }
  
  proc __chacha_h_x2_avx (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var r16:W128.t;
    var r8:W128.t;
    var st:W128.t Array4.t;
    var k1:W128.t Array4.t;
    var k2:W128.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    r16 <- CHACHA_R16_AVX;
    r8 <- CHACHA_R8_AVX;
    st <@ __init_h_avx (nonce, key);
    
    while (((W64.of_int 128) \ule len)) {
      (k1, k2) <@ __copy_state_h_x2_avx (st);
      (k1, k2) <@ __rounds_h_x2_avx (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx (k1, k2, st);
      (output, len) <@ __store_h_x2_avx (output, len, k1, k2);
      st <@ __increment_counter02_h_avx (st);
    }
    if (((W64.of_int 64) \ult len)) {
      (k1, k2) <@ __copy_state_h_x2_avx (st);
      (k1, k2) <@ __rounds_h_x2_avx (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx (k1, k2, st);
      (output, len) <@ __store_h_avx (output, len, k1);
      __store_last_h_avx (output, len, k2);
    } else {
      k1 <@ __copy_state_h_avx (st);
      k1 <@ __rounds_h_avx (k1, r16, r8);
      k1 <@ __sum_states_h_avx (k1, st);
      __store_last_h_avx (output, len, k1);
    }
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
  
  proc __rotate_v_avx (k:W128.t Array16.t, i:int, r:int, r16:W128.t,
                       r8:W128.t) : W128.t Array16.t = {
    
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
  
  proc __line_v_avx (k:W128.t Array16.t, a:int, b:int, c:int, r:int,
                     r16:W128.t, r8:W128.t) : W128.t Array16.t = {
    
    
    
    k.[a] <- (k.[a] \vadd32u128 k.[b]);
    k.[c] <- (k.[c] `^` k.[a]);
    k <@ __rotate_v_avx (k, c, r, r16, r8);
    return (k);
  }
  
  proc __quarter_round_v_avx (k:W128.t Array16.t, a:int, b:int, c:int, d:int,
                              r16:W128.t, r8:W128.t) : W128.t Array16.t = {
    
    
    
    k <@ __line_v_avx (k, a, b, d, 16, r16, r8);
    k <@ __line_v_avx (k, c, d, b, 12, r16, r8);
    k <@ __line_v_avx (k, a, b, d, 8, r16, r8);
    k <@ __line_v_avx (k, c, d, b, 7, r16, r8);
    return (k);
  }
  
  proc __column_round_v_avx (k:W128.t Array16.t, k15:W128.t, r16:W128.t,
                             r8:W128.t) : W128.t Array16.t * W128.t = {
    
    var k14:W128.t;
    
    k <@ __quarter_round_v_avx (k, 0, 4, 8, 12, r16, r8);
    k <@ __quarter_round_v_avx (k, 1, 5, 9, 13, r16, r8);
    k <@ __quarter_round_v_avx (k, 2, 6, 10, 14, r16, r8);
    k14 <- k.[14];
    k.[15] <- k15;
    k <@ __quarter_round_v_avx (k, 3, 7, 11, 15, r16, r8);
    k15 <- k.[15];
    k.[14] <- k14;
    return (k, k15);
  }
  
  proc __diagonal_round_v_avx (k:W128.t Array16.t, k15:W128.t, r16:W128.t,
                               r8:W128.t) : W128.t Array16.t * W128.t = {
    
    var k14:W128.t;
    
    k14 <- k.[14];
    k.[15] <- k15;
    k <@ __quarter_round_v_avx (k, 0, 5, 10, 15, r16, r8);
    k15 <- k.[15];
    k.[14] <- k14;
    k <@ __quarter_round_v_avx (k, 1, 6, 11, 12, r16, r8);
    k <@ __quarter_round_v_avx (k, 2, 7, 8, 13, r16, r8);
    k <@ __quarter_round_v_avx (k, 3, 4, 9, 14, r16, r8);
    return (k, k15);
  }
  
  proc __double_round_v_avx (k:W128.t Array16.t, k15:W128.t, r16:W128.t,
                             r8:W128.t) : W128.t Array16.t * W128.t = {
    
    
    
    (k, k15) <@ __column_round_v_avx (k, k15, r16, r8);
    (k, k15) <@ __diagonal_round_v_avx (k, k15, r16, r8);
    return (k, k15);
  }
  
  proc __rounds_v_avx (k:W128.t Array16.t, r16:W128.t, r8:W128.t) : W128.t Array16.t = {
    
    var k15:W128.t;
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    k15 <- k.[15];
    c <- (W32.of_int (20 %/ 2));
    (k, k15) <@ __double_round_v_avx (k, k15, r16, r8);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      (k, k15) <@ __double_round_v_avx (k, k15, r16, r8);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    k.[15] <- k15;
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
  
  proc __chacha_xor_v_avx (output:W64.t, plain:W64.t, len:W64.t, nonce:W64.t,
                           key:W64.t) : unit = {
    
    var _r16:W128.t;
    var _r8:W128.t;
    var r16:W128.t;
    var r8:W128.t;
    var st:W128.t Array16.t;
    var k:W128.t Array16.t;
    k <- witness;
    st <- witness;
    _r16 <- CHACHA_R16_AVX;
    _r8 <- CHACHA_R8_AVX;
    r16 <- _r16;
    r8 <- _r8;
    st <@ __init_v_avx (nonce, key);
    
    while (((W64.of_int 256) \ule len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k, r16, r8);
      k <@ __sum_states_v_avx (k, st);
      (output, plain, len) <@ __store_xor_v_avx (output, plain, len, k);
      st <@ __increment_counter_v_avx (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k, r16, r8);
      k <@ __sum_states_v_avx (k, st);
      __store_xor_last_v_avx (output, plain, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __chacha_v_avx (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var _r16:W128.t;
    var _r8:W128.t;
    var r16:W128.t;
    var r8:W128.t;
    var st:W128.t Array16.t;
    var k:W128.t Array16.t;
    k <- witness;
    st <- witness;
    _r16 <- CHACHA_R16_AVX;
    _r8 <- CHACHA_R8_AVX;
    r16 <- _r16;
    r8 <- _r8;
    st <@ __init_v_avx (nonce, key);
    
    while (((W64.of_int 256) \ule len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k, r16, r8);
      k <@ __sum_states_v_avx (k, st);
      (output, len) <@ __store_v_avx (output, len, k);
      st <@ __increment_counter_v_avx (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx (st);
      k <@ __rounds_v_avx (k, r16, r8);
      k <@ __sum_states_v_avx (k, st);
      __store_last_v_avx (output, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __chacha_xor_avx (output:W64.t, plain:W64.t, len:W64.t, nonce:W64.t,
                         key:W64.t) : unit = {
    
    
    
    if ((len \ult (W64.of_int 129))) {
      __chacha_xor_h_x2_avx (output, plain, len, nonce, key);
    } else {
      __chacha_xor_v_avx (output, plain, len, nonce, key);
    }
    return ();
  }
  
  proc __chacha_avx (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    
    
    if ((len \ult (W64.of_int 129))) {
      __chacha_h_x2_avx (output, len, nonce, key);
    } else {
      __chacha_v_avx (output, len, nonce, key);
    }
    return ();
  }
  
  proc jade_stream_chacha_chacha20_ietf_amd64_avx_xor (output:W64.t,
                                                       plain:W64.t,
                                                       len:W64.t,
                                                       nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __chacha_xor_avx (output, plain, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
  
  proc jade_stream_chacha_chacha20_ietf_amd64_avx (output:W64.t, len:W64.t,
                                                   nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __chacha_avx (output, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

