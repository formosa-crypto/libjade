require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array4 Array8 Array16.
require import WArray128 WArray256 WArray512.

abbrev CHACHA_R8_AVX2 = W256.of_int 6355432118420048154175784972596847518577147054203239762089463134348153782275.


abbrev CHACHA_R16_AVX2 = W256.of_int 5901373100945378232718128989223044758631764214521116316503579100742837863170.


abbrev CHACHA_P8888_V_AVX2 = W256.of_int 50216813883093446113408574321028839036673414367756098207752.


abbrev CHACHA_P76543210_V_AVX = W256.of_int 188719626707717088982296698380167795313645871959412740063448560304128.


abbrev CHACHA_SIGMA_V_AVX2 = Array4.of_list witness [W256.of_int 44073064126609806855391717116077731678275203726397694096946023845364623243365;
W256.of_int 23125187529432558845629540468101975958865586010904976319010681524266723206254;
W256.of_int 54903317630289628372966993210398408063843973048718200005123542515998963936562;
W256.of_int 48454714119498993367416293155753147246354200180586516487276217358402952652148].


abbrev CHACHA_P0404_H_AVX2 = W256.of_int 1361129467683753853853498429727072845828.


abbrev CHACHA_P0202_H_AVX2 = W256.of_int 680564733841876926926749214863536422914.


abbrev CHACHA_P0100_H_AVX2 = W256.of_int 340282366920938463463374607431768211456.


abbrev CHACHA_SIGMA_H_AVX2 = W256.of_int 48454714121000425871779584242658626266549707228123448124510059929993043015781.


module M = {
  proc __init_h_avx2 (nonce:W64.t, key:W64.t) : W256.t Array4.t = {
    
    var st:W256.t Array4.t;
    var t:W128.t;
    st <- witness;
    st.[0] <- CHACHA_SIGMA_H_AVX2;
    st.[1] <-
    VBROADCAST_2u128 (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 0))));
    st.[2] <-
    VBROADCAST_2u128 (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 16))));
    t <- setw0_128 ;
    t <- VPINSR_2u64 t
    (loadW64 Glob.mem (W64.to_uint (nonce + (W64.of_int 0)))) (W8.of_int 1);
    st.[3] <- setw0_256 ;
    st.[3] <- VINSERTI128 st.[3] t (W8.of_int 0);
    st.[3] <- VINSERTI128 st.[3] t (W8.of_int 1);
    st.[3] <- (st.[3] \vadd64u256 CHACHA_P0100_H_AVX2);
    return (st);
  }
  
  proc __increment_counter0404_h_avx2 (st:W256.t Array4.t) : W256.t Array4.t = {
    
    
    
    st.[3] <- (st.[3] \vadd64u256 CHACHA_P0404_H_AVX2);
    return (st);
  }
  
  proc __increment_counter0202_h_avx2 (st:W256.t Array4.t) : W256.t Array4.t = {
    
    
    
    st.[3] <- (st.[3] \vadd64u256 CHACHA_P0202_H_AVX2);
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
  
  proc __copy_state_h_avx2 (st:W256.t Array4.t) : W256.t Array4.t = {
    
    var k:W256.t Array4.t;
    k <- witness;
    k <-
    (Array4.init (fun i => get256
    (WArray128.init8 (fun i => copy_256 (Array128.init (fun i => get8
                                        (WArray128.init256 (fun i => st.[i]))
                                        i)).[i]))
    i));
    return (k);
  }
  
  proc __rotate_h_avx2 (k:W256.t Array4.t, i:int, r:int, r16:W256.t,
                        r8:W256.t) : W256.t Array4.t = {
    
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
  
  proc __line_h_avx2 (k:W256.t Array4.t, a:int, b:int, c:int, r:int,
                      r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    
    
    
    k.[a] <- (k.[a] \vadd32u256 k.[b]);
    k.[c] <- (k.[c] `^` k.[a]);
    k <@ __rotate_h_avx2 (k, c, r, r16, r8);
    return (k);
  }
  
  proc __round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    
    
    
    k <@ __line_h_avx2 (k, 0, 1, 3, 16, r16, r8);
    k <@ __line_h_avx2 (k, 2, 3, 1, 12, r16, r8);
    k <@ __line_h_avx2 (k, 0, 1, 3, 8, r16, r8);
    k <@ __line_h_avx2 (k, 2, 3, 1, 7, r16, r8);
    return (k);
  }
  
  proc __shuffle_state_h_avx2 (k:W256.t Array4.t) : W256.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_256 k.[1]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    k.[2] <- VPSHUFD_256 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_256 k.[3]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    return (k);
  }
  
  proc __reverse_shuffle_state_h_avx2 (k:W256.t Array4.t) : W256.t Array4.t = {
    
    
    
    k.[1] <- VPSHUFD_256 k.[1]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    k.[2] <- VPSHUFD_256 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    k.[3] <- VPSHUFD_256 k.[3]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    return (k);
  }
  
  proc __column_round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    
    
    
    k <@ __round_h_avx2 (k, r16, r8);
    return (k);
  }
  
  proc __diagonal_round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    
    
    
    k <@ __shuffle_state_h_avx2 (k);
    k <@ __round_h_avx2 (k, r16, r8);
    k <@ __reverse_shuffle_state_h_avx2 (k);
    return (k);
  }
  
  proc __double_round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    
    
    
    k <@ __column_round_h_avx2 (k, r16, r8);
    k <@ __diagonal_round_h_avx2 (k, r16, r8);
    return (k);
  }
  
  proc __rounds_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    c <- (W32.of_int (20 %/ 2));
    k <@ __double_round_h_avx2 (k, r16, r8);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      k <@ __double_round_h_avx2 (k, r16, r8);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    return (k);
  }
  
  proc __sum_states_h_avx2 (k:W256.t Array4.t, st:W256.t Array4.t) : 
  W256.t Array4.t = {
    var aux: int;
    
    var i:int;
    
    i <- 0;
    while (i < 4) {
      k.[i] <- (k.[i] \vadd32u256 st.[i]);
      i <- i + 1;
    }
    return (k);
  }
  
  proc __perm_h_avx2 (k:W256.t Array4.t) : W256.t Array4.t = {
    
    var p:W256.t Array4.t;
    p <- witness;
    p.[0] <- VPERM2I128 k.[0] k.[1] (W8.of_int (0 %% 2^4 + 2^4 * 2));
    p.[1] <- VPERM2I128 k.[2] k.[3] (W8.of_int (0 %% 2^4 + 2^4 * 2));
    p.[2] <- VPERM2I128 k.[0] k.[1] (W8.of_int (1 %% 2^4 + 2^4 * 3));
    p.[3] <- VPERM2I128 k.[2] k.[3] (W8.of_int (1 %% 2^4 + 2^4 * 3));
    return (p);
  }
  
  proc __copy_state_h_x2_avx2 (st:W256.t Array4.t) : W256.t Array4.t *
                                                     W256.t Array4.t = {
    
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    k1 <-
    (Array4.init (fun i => get256
    (WArray128.init8 (fun i => copy_256 (Array128.init (fun i => get8
                                        (WArray128.init256 (fun i => st.[i]))
                                        i)).[i]))
    i));
    k2 <-
    (Array4.init (fun i => get256
    (WArray128.init8 (fun i => copy_256 (Array128.init (fun i => get8
                                        (WArray128.init256 (fun i => st.[i]))
                                        i)).[i]))
    i));
    k2 <@ __increment_counter0202_h_avx2 (k2);
    return (k1, k2);
  }
  
  proc __round_h_x2_inline_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                 r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    
    var t1:W256.t;
    
    k1.[0] <- (k1.[0] \vadd32u256 k1.[1]);
    k2.[0] <- (k2.[0] \vadd32u256 k2.[1]);
    k1.[3] <- (k1.[3] `^` k1.[0]);
    k2.[3] <- (k2.[3] `^` k2.[0]);
    k1 <@ __rotate_h_avx2 (k1, 3, 16, r16, r8);
    k2 <@ __rotate_h_avx2 (k2, 3, 16, r16, r8);
    k1.[2] <- (k1.[2] \vadd32u256 k1.[3]);
    k2.[2] <- (k2.[2] \vadd32u256 k2.[3]);
    k1.[1] <- (k1.[1] `^` k1.[2]);
    t1 <- (k1.[1] \vshl32u256 (W8.of_int 12));
    k1.[1] <- (k1.[1] \vshr32u256 (W8.of_int 20));
    k2.[1] <- (k2.[1] `^` k2.[2]);
    k1.[1] <- (k1.[1] `^` t1);
    k2 <@ __rotate_h_avx2 (k2, 1, 12, r16, r8);
    k1.[0] <- (k1.[0] \vadd32u256 k1.[1]);
    k2.[0] <- (k2.[0] \vadd32u256 k2.[1]);
    k1.[3] <- (k1.[3] `^` k1.[0]);
    k2.[3] <- (k2.[3] `^` k2.[0]);
    k1 <@ __rotate_h_avx2 (k1, 3, 8, r16, r8);
    k2 <@ __rotate_h_avx2 (k2, 3, 8, r16, r8);
    k1.[2] <- (k1.[2] \vadd32u256 k1.[3]);
    k2.[2] <- (k2.[2] \vadd32u256 k2.[3]);
    k1.[1] <- (k1.[1] `^` k1.[2]);
    t1 <- (k1.[1] \vshl32u256 (W8.of_int 7));
    k1.[1] <- (k1.[1] \vshr32u256 (W8.of_int 25));
    k2.[1] <- (k2.[1] `^` k2.[2]);
    k1.[1] <- (k1.[1] `^` t1);
    k2 <@ __rotate_h_avx2 (k2, 1, 7, r16, r8);
    return (k1, k2);
  }
  
  proc __shuffle_state_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t) : 
  W256.t Array4.t * W256.t Array4.t = {
    
    
    
    k1 <@ __shuffle_state_h_avx2 (k1);
    k2 <@ __shuffle_state_h_avx2 (k2);
    return (k1, k2);
  }
  
  proc __reverse_shuffle_state_h_x2_avx2 (k1:W256.t Array4.t,
                                          k2:W256.t Array4.t) : W256.t Array4.t *
                                                                W256.t Array4.t = {
    
    
    
    k1 <@ __reverse_shuffle_state_h_avx2 (k1);
    k2 <@ __reverse_shuffle_state_h_avx2 (k2);
    return (k1, k2);
  }
  
  proc __column_round_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                 r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    
    
    
    (k1, k2) <@ __round_h_x2_inline_avx2 (k1, k2, r16, r8);
    return (k1, k2);
  }
  
  proc __diagonal_round_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                   r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                            W256.t Array4.t = {
    
    
    
    (k1, k2) <@ __shuffle_state_h_x2_avx2 (k1, k2);
    (k1, k2) <@ __round_h_x2_inline_avx2 (k1, k2, r16, r8);
    (k1, k2) <@ __reverse_shuffle_state_h_x2_avx2 (k1, k2);
    return (k1, k2);
  }
  
  proc __double_round_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                 r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    
    
    
    (k1, k2) <@ __column_round_h_x2_avx2 (k1, k2, r16, r8);
    (k1, k2) <@ __diagonal_round_h_x2_avx2 (k1, k2, r16, r8);
    return (k1, k2);
  }
  
  proc __rounds_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                           r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                    W256.t Array4.t = {
    
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    c <- (W32.of_int (20 %/ 2));
    (k1, k2) <@ __double_round_h_x2_avx2 (k1, k2, r16, r8);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      (k1, k2) <@ __double_round_h_x2_avx2 (k1, k2, r16, r8);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    return (k1, k2);
  }
  
  proc __sum_states_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                               st:W256.t Array4.t) : W256.t Array4.t *
                                                     W256.t Array4.t = {
    
    
    
    k1 <@ __sum_states_h_avx2 (k1, st);
    k2 <@ __sum_states_h_avx2 (k2, st);
    k2 <@ __increment_counter0202_h_avx2 (k2);
    return (k1, k2);
  }
  
  proc __perm_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t) : W256.t Array4.t *
                                                                   W256.t Array4.t = {
    
    var p1:W256.t Array4.t;
    var p2:W256.t Array4.t;
    p1 <- witness;
    p2 <- witness;
    p1 <@ __perm_h_avx2 (k1);
    p2 <@ __perm_h_avx2 (k2);
    return (p1, p2);
  }
  
  proc __chacha_xor_h_x2_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                               nonce:W64.t, key:W64.t) : unit = {
    
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array4.t;
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    r16 <- CHACHA_R16_AVX2;
    r8 <- CHACHA_R8_AVX2;
    st <@ __init_h_avx2 (nonce, key);
    
    while (((W64.of_int 256) \ule len)) {
      (k1, k2) <@ __copy_state_h_x2_avx2 (st);
      (k1, k2) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      (k1, k2) <@ __perm_h_x2_avx2 (k1, k2);
      (output, plain, len) <@ __store_xor_h_x2_avx2 (output, plain, len, k1,
      k2);
      st <@ __increment_counter0404_h_avx2 (st);
    }
    if (((W64.of_int 128) \ult len)) {
      (k1, k2) <@ __copy_state_h_x2_avx2 (st);
      (k1, k2) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      (k1, k2) <@ __perm_h_x2_avx2 (k1, k2);
      (output, plain, len) <@ __store_xor_h_avx2 (output, plain, len, k1);
      __store_xor_last_h_avx2 (output, plain, len, k2);
    } else {
      k1 <@ __copy_state_h_avx2 (st);
      k1 <@ __rounds_h_avx2 (k1, r16, r8);
      k1 <@ __sum_states_h_avx2 (k1, st);
      k1 <@ __perm_h_avx2 (k1);
      __store_xor_last_h_avx2 (output, plain, len, k1);
    }
    return ();
  }
  
  proc __chacha_h_x2_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array4.t;
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    r16 <- CHACHA_R16_AVX2;
    r8 <- CHACHA_R8_AVX2;
    st <@ __init_h_avx2 (nonce, key);
    
    while (((W64.of_int 256) \ule len)) {
      (k1, k2) <@ __copy_state_h_x2_avx2 (st);
      (k1, k2) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      (k1, k2) <@ __perm_h_x2_avx2 (k1, k2);
      (output, len) <@ __store_h_x2_avx2 (output, len, k1, k2);
      st <@ __increment_counter0404_h_avx2 (st);
    }
    if (((W64.of_int 128) \ult len)) {
      (k1, k2) <@ __copy_state_h_x2_avx2 (st);
      (k1, k2) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      (k1, k2) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      (k1, k2) <@ __perm_h_x2_avx2 (k1, k2);
      (output, len) <@ __store_h_avx2 (output, len, k1);
      __store_last_h_avx2 (output, len, k2);
    } else {
      k1 <@ __copy_state_h_avx2 (st);
      k1 <@ __rounds_h_avx2 (k1, r16, r8);
      k1 <@ __sum_states_h_avx2 (k1, st);
      k1 <@ __perm_h_avx2 (k1);
      __store_last_h_avx2 (output, len, k1);
    }
    return ();
  }
  
  proc __init_v_avx2 (nonce:W64.t, key:W64.t) : W256.t Array16.t = {
    var aux: int;
    
    var _st:W256.t Array16.t;
    var i:int;
    var st:W256.t Array16.t;
    _st <- witness;
    st <- witness;
    i <- 0;
    while (i < 4) {
      st.[i] <- CHACHA_SIGMA_V_AVX2.[i];
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      st.[(4 + i)] <-
      VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (4 * i)))));
      i <- i + 1;
    }
    st.[12] <- CHACHA_P76543210_V_AVX;
    st.[13] <- setw0_256 ;
    i <- 0;
    while (i < 2) {
      st.[(14 + i)] <-
      VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (4 * i)))));
      i <- i + 1;
    }
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
    
    x <- st.[12];
    y <- st.[13];
    a <- VPUNPCKL_8u32 x y;
    b <- VPUNPCKH_8u32 x y;
    a <- (a \vadd64u256 CHACHA_P8888_V_AVX2);
    b <- (b \vadd64u256 CHACHA_P8888_V_AVX2);
    x <- VPUNPCKL_8u32 a b;
    y <- VPUNPCKH_8u32 a b;
    a <- VPUNPCKL_8u32 x y;
    b <- VPUNPCKH_8u32 x y;
    st.[12] <- a;
    st.[13] <- b;
    return (st);
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
  
  proc __rotate_v_avx2 (k:W256.t Array16.t, i:int, r:int, r16:W256.t,
                        r8:W256.t) : W256.t Array16.t = {
    
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
  
  proc __line_v_avx2 (k:W256.t Array16.t, a:int, b:int, c:int, r:int,
                      r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    
    
    
    k.[a] <- (k.[a] \vadd32u256 k.[b]);
    k.[c] <- (k.[c] `^` k.[a]);
    k <@ __rotate_v_avx2 (k, c, r, r16, r8);
    return (k);
  }
  
  proc __double_line_v_avx2 (k:W256.t Array16.t, a0:int, b0:int, c0:int,
                             r0:int, a1:int, b1:int, c1:int, r1:int,
                             r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    
    
    
    k.[a0] <- (k.[a0] \vadd32u256 k.[b0]);
    k.[a1] <- (k.[a1] \vadd32u256 k.[b1]);
    k.[c0] <- (k.[c0] `^` k.[a0]);
    k.[c1] <- (k.[c1] `^` k.[a1]);
    k <@ __rotate_v_avx2 (k, c0, r0, r16, r8);
    k <@ __rotate_v_avx2 (k, c1, r1, r16, r8);
    return (k);
  }
  
  proc __double_quarter_round_v_avx2 (k:W256.t Array16.t, a0:int, b0:int,
                                      c0:int, d0:int, a1:int, b1:int, c1:int,
                                      d1:int, r16:W256.t, r8:W256.t) : 
  W256.t Array16.t = {
    
    
    
    k <@ __line_v_avx2 (k, a0, b0, d0, 16, r16, r8);
    k <@ __double_line_v_avx2 (k, c0, d0, b0, 12, a1, b1, d1, 16, r16, r8);
    k <@ __double_line_v_avx2 (k, a0, b0, d0, 8, c1, d1, b1, 12, r16, r8);
    k <@ __double_line_v_avx2 (k, c0, d0, b0, 7, a1, b1, d1, 8, r16, r8);
    k <@ __line_v_avx2 (k, c1, d1, b1, 7, r16, r8);
    return (k);
  }
  
  proc __column_round_v_1_avx2 (k:W256.t Array16.t, k15:W256.t, s_r16:W256.t,
                                s_r8:W256.t) : W256.t Array16.t * W256.t = {
    
    var k14:W256.t;
    
    k <@ __double_quarter_round_v_avx2 (k, 0, 4, 8, 12, 2, 6, 10, 14, s_r16,
    s_r8);
    k.[15] <- k15;
    k14 <- k.[14];
    k <@ __double_quarter_round_v_avx2 (k, 1, 5, 9, 13, 3, 7, 11, 15, s_r16,
    s_r8);
    return (k, k14);
  }
  
  proc __diagonal_round_v_1_avx2 (k:W256.t Array16.t, k14:W256.t,
                                  s_r16:W256.t, s_r8:W256.t) : W256.t Array16.t *
                                                               W256.t = {
    
    var k15:W256.t;
    
    k <@ __double_quarter_round_v_avx2 (k, 1, 6, 11, 12, 0, 5, 10, 15, s_r16,
    s_r8);
    k.[14] <- k14;
    k15 <- k.[15];
    k <@ __double_quarter_round_v_avx2 (k, 2, 7, 8, 13, 3, 4, 9, 14, s_r16,
    s_r8);
    return (k, k15);
  }
  
  proc __double_round_v_1_avx2 (k:W256.t Array16.t, k15:W256.t, r16:W256.t,
                                r8:W256.t) : W256.t Array16.t * W256.t = {
    
    var k14:W256.t;
    
    (k, k14) <@ __column_round_v_1_avx2 (k, k15, r16, r8);
    (k, k15) <@ __diagonal_round_v_1_avx2 (k, k14, r16, r8);
    return (k, k15);
  }
  
  proc __rounds_v_avx2 (k:W256.t Array16.t, r16:W256.t, r8:W256.t) : 
  W256.t Array16.t = {
    
    var k15:W256.t;
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    k15 <- k.[15];
    c <- (W32.of_int (20 %/ 2));
    (k, k15) <@ __double_round_v_1_avx2 (k, k15, r16, r8);
    ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    while (((W32.of_int 0) \ult c)) {
      (k, k15) <@ __double_round_v_1_avx2 (k, k15, r16, r8);
      ( _0,  _1,  _2,  _3, c) <- DEC_32 c;
    }
    k.[15] <- k15;
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
  
  proc __chacha_xor_v_avx2 (output:W64.t, plain:W64.t, len:W64.t,
                            nonce:W64.t, key:W64.t) : unit = {
    
    var _r16:W256.t;
    var _r8:W256.t;
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    _r16 <- CHACHA_R16_AVX2;
    _r8 <- CHACHA_R8_AVX2;
    r16 <- _r16;
    r8 <- _r8;
    st <@ __init_v_avx2 (nonce, key);
    
    while (((W64.of_int 512) \ule len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k, r16, r8);
      k <@ __sum_states_v_avx2 (k, st);
      (output, plain, len) <@ __store_xor_v_avx2 (output, plain, len, k);
      st <@ __increment_counter_v_avx2 (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k, r16, r8);
      k <@ __sum_states_v_avx2 (k, st);
      __store_xor_last_v_avx2 (output, plain, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __chacha_v_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var _r16:W256.t;
    var _r8:W256.t;
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    _r16 <- CHACHA_R16_AVX2;
    _r8 <- CHACHA_R8_AVX2;
    r16 <- _r16;
    r8 <- _r8;
    st <@ __init_v_avx2 (nonce, key);
    
    while (((W64.of_int 512) \ule len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k, r16, r8);
      k <@ __sum_states_v_avx2 (k, st);
      (output, len) <@ __store_v_avx2 (output, len, k);
      st <@ __increment_counter_v_avx2 (st);
    }
    if (((W64.of_int 0) \ult len)) {
      k <@ __copy_state_v_avx2 (st);
      k <@ __rounds_v_avx2 (k, r16, r8);
      k <@ __sum_states_v_avx2 (k, st);
      __store_last_v_avx2 (output, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __chacha_xor_avx2 (output:W64.t, plain:W64.t, len:W64.t, nonce:W64.t,
                          key:W64.t) : unit = {
    
    
    
    if ((len \ult (W64.of_int 257))) {
      __chacha_xor_h_x2_avx2 (output, plain, len, nonce, key);
    } else {
      __chacha_xor_v_avx2 (output, plain, len, nonce, key);
    }
    return ();
  }
  
  proc __chacha_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    
    
    if ((len \ult (W64.of_int 257))) {
      __chacha_h_x2_avx2 (output, len, nonce, key);
    } else {
      __chacha_v_avx2 (output, len, nonce, key);
    }
    return ();
  }
  
  proc jade_stream_chacha_chacha20_amd64_avx2_xor (output:W64.t, plain:W64.t,
                                                   len:W64.t, nonce:W64.t,
                                                   key:W64.t) : W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __chacha_xor_avx2 (output, plain, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
  
  proc jade_stream_chacha_chacha20_amd64_avx2 (output:W64.t, len:W64.t,
                                               nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __chacha_avx2 (output, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

