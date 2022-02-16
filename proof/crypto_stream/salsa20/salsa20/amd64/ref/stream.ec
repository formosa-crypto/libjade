require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array8 Array16.
require import WArray64.



module M = {
  proc __init_ref (nonce:W64.t, key:W64.t) : W32.t Array16.t = {
    var aux: int;
    
    var st:W32.t Array16.t;
    var i:int;
    var t:W32.t;
    st <- witness;
    i <- 0;
    while (i < 4) {
      t <- (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      st.[(i + 1)] <- t;
      i <- i + 1;
    }
    i <- 4;
    while (i < 8) {
      t <- (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (i * 4)))));
      st.[(i + 7)] <- t;
      i <- i + 1;
    }
    st.[0] <- (W32.of_int 1634760805);
    st.[5] <- (W32.of_int 857760878);
    st.[10] <- (W32.of_int 2036477234);
    st.[15] <- (W32.of_int 1797285236);
    i <- 0;
    while (i < 2) {
      t <- (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (i * 4)))));
      st.[(i + 6)] <- t;
      i <- i + 1;
    }
    i <- 0;
    while (i < 2) {
      st.[(i + 8)] <- (W32.of_int 0);
      i <- i + 1;
    }
    return (st);
  }
  
  proc __increment_counter_ref (st:W32.t Array16.t) : W32.t Array16.t = {
    
    var t:W64.t;
    
    t <- (get64 (WArray64.init32 (fun i => st.[i])) 4);
    t <- (t + (W64.of_int 1));
    st <-
    Array16.init
    (WArray64.get32 (WArray64.set64 (WArray64.init32 (fun i => st.[i])) 4 t));
    return (st);
  }
  
  proc __update_ptr_xor_ref (output:W64.t, plain:W64.t, len:W64.t, n:int) : 
  W64.t * W64.t * W64.t = {
    
    
    
    output <- (output + (W64.of_int n));
    plain <- (plain + (W64.of_int n));
    len <- (len - (W64.of_int n));
    return (output, plain, len);
  }
  
  proc __sum_states_store_xor_ref (s_output:W64.t, s_plain:W64.t,
                                   s_len:W64.t, k:W32.t Array16.t, k15:W32.t,
                                   st:W32.t Array16.t) : W64.t * W64.t *
                                                         W64.t = {
    var aux_0: int;
    
    var kk:W64.t Array8.t;
    var aux:W64.t;
    var plain:W64.t;
    var output:W64.t;
    var i:int;
    var len:W64.t;
    kk <- witness;
    k.[1] <- (k.[1] + st.[1]);
    k.[0] <- (k.[0] + st.[0]);
    kk.[0] <- (zeroextu64 k.[1]);
    kk.[0] <- (kk.[0] `<<` (W8.of_int 32));
    aux <- (zeroextu64 k.[0]);
    kk.[0] <- (kk.[0] `^` aux);
    plain <- s_plain;
    kk.[0] <-
    (kk.[0] `^` (loadW64 Glob.mem (W64.to_uint (plain + (W64.of_int (8 * 0))))));
    k.[3] <- (k.[3] + st.[3]);
    k.[2] <- (k.[2] + st.[2]);
    kk.[1] <- (zeroextu64 k.[3]);
    kk.[1] <- (kk.[1] `<<` (W8.of_int 32));
    aux <- (zeroextu64 k.[2]);
    kk.[1] <- (kk.[1] `^` aux);
    kk.[1] <-
    (kk.[1] `^` (loadW64 Glob.mem (W64.to_uint (plain + (W64.of_int (8 * 1))))));
    output <- s_output;
    Glob.mem <-
    storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * 0)))) kk.[0];
    i <- 2;
    while (i < 8) {
      if ((((2 * i) + 1) = 15)) {
        k.[((2 * i) + 1)] <- k15;
      } else {
        
      }
      k.[((2 * i) + 1)] <- (k.[((2 * i) + 1)] + st.[((2 * i) + 1)]);
      k.[(2 * i)] <- (k.[(2 * i)] + st.[(2 * i)]);
      kk.[i] <- (zeroextu64 k.[((2 * i) + 1)]);
      kk.[i] <- (kk.[i] `<<` (W8.of_int 32));
      aux <- (zeroextu64 k.[(2 * i)]);
      kk.[i] <- (kk.[i] `^` aux);
      kk.[i] <-
      (kk.[i] `^` (loadW64 Glob.mem (W64.to_uint (plain + (W64.of_int (8 * i))))));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * (i - 1))))) 
      kk.[(i - 1)];
      i <- i + 1;
    }
    Glob.mem <-
    storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * 7)))) kk.[7];
    len <- s_len;
    (output, plain, len) <@ __update_ptr_xor_ref (output, plain, len, 64);
    s_output <- output;
    s_plain <- plain;
    s_len <- len;
    return (s_output, s_plain, s_len);
  }
  
  proc __store_xor_last_ref (s_output:W64.t, s_plain:W64.t, s_len:W64.t,
                             k:W32.t Array16.t, k15:W32.t) : unit = {
    var aux: int;
    
    var i:int;
    var s_k:W32.t Array16.t;
    var u:W32.t;
    var output:W64.t;
    var plain:W64.t;
    var len:W64.t;
    var len8:W64.t;
    var j:W64.t;
    var t:W64.t;
    var pi:W8.t;
    s_k <- witness;
    i <- 0;
    while (i < 15) {
      s_k.[i] <- k.[i];
      i <- i + 1;
    }
    u <- k15;
    s_k.[15] <- u;
    output <- s_output;
    plain <- s_plain;
    len <- s_len;
    len8 <- len;
    len8 <- (len8 `>>` (W8.of_int 3));
    j <- (W64.of_int 0);
    
    while ((j \ult len8)) {
      t <- (loadW64 Glob.mem (W64.to_uint (plain + ((W64.of_int 8) * j))));
      t <-
      (t `^` (get64 (WArray64.init32 (fun i => s_k.[i])) (W64.to_uint j)));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + ((W64.of_int 8) * j))) t;
      j <- (j + (W64.of_int 1));
    }
    j <- (j `<<` (W8.of_int 3));
    
    while ((j \ult len)) {
      pi <- (loadW8 Glob.mem (W64.to_uint (plain + j)));
      pi <-
      (pi `^` (get8 (WArray64.init32 (fun i => s_k.[i])) (W64.to_uint j)));
      Glob.mem <- storeW8 Glob.mem (W64.to_uint (output + j)) pi;
      j <- (j + (W64.of_int 1));
    }
    return ();
  }
  
  proc __update_ptr_ref (output:W64.t, len:W64.t, n:int) : W64.t * W64.t = {
    
    
    
    output <- (output + (W64.of_int n));
    len <- (len - (W64.of_int n));
    return (output, len);
  }
  
  proc __sum_states_store_ref (s_output:W64.t, s_len:W64.t,
                               k:W32.t Array16.t, k15:W32.t,
                               st:W32.t Array16.t) : W64.t * W64.t = {
    var aux_0: int;
    
    var kk:W64.t Array8.t;
    var aux:W64.t;
    var output:W64.t;
    var i:int;
    var len:W64.t;
    kk <- witness;
    k.[1] <- (k.[1] + st.[1]);
    k.[0] <- (k.[0] + st.[0]);
    kk.[0] <- (zeroextu64 k.[1]);
    kk.[0] <- (kk.[0] `<<` (W8.of_int 32));
    aux <- (zeroextu64 k.[0]);
    kk.[0] <- (kk.[0] `^` aux);
    k.[3] <- (k.[3] + st.[3]);
    k.[2] <- (k.[2] + st.[2]);
    kk.[1] <- (zeroextu64 k.[3]);
    kk.[1] <- (kk.[1] `<<` (W8.of_int 32));
    aux <- (zeroextu64 k.[2]);
    kk.[1] <- (kk.[1] `^` aux);
    output <- s_output;
    Glob.mem <-
    storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * 0)))) kk.[0];
    i <- 2;
    while (i < 8) {
      if ((((2 * i) + 1) = 15)) {
        k.[((2 * i) + 1)] <- k15;
      } else {
        
      }
      k.[((2 * i) + 1)] <- (k.[((2 * i) + 1)] + st.[((2 * i) + 1)]);
      k.[(2 * i)] <- (k.[(2 * i)] + st.[(2 * i)]);
      kk.[i] <- (zeroextu64 k.[((2 * i) + 1)]);
      kk.[i] <- (kk.[i] `<<` (W8.of_int 32));
      aux <- (zeroextu64 k.[(2 * i)]);
      kk.[i] <- (kk.[i] `^` aux);
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * (i - 1))))) 
      kk.[(i - 1)];
      i <- i + 1;
    }
    Glob.mem <-
    storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * 7)))) kk.[7];
    len <- s_len;
    (output, len) <@ __update_ptr_ref (output, len, 64);
    s_output <- output;
    s_len <- len;
    return (s_output, s_len);
  }
  
  proc __store_last_ref (s_output:W64.t, s_len:W64.t, k:W32.t Array16.t,
                         k15:W32.t) : unit = {
    var aux: int;
    
    var i:int;
    var s_k:W32.t Array16.t;
    var u:W32.t;
    var output:W64.t;
    var len:W64.t;
    var len8:W64.t;
    var j:W64.t;
    var t:W64.t;
    var pi:W8.t;
    s_k <- witness;
    i <- 0;
    while (i < 15) {
      s_k.[i] <- k.[i];
      i <- i + 1;
    }
    u <- k15;
    s_k.[15] <- u;
    output <- s_output;
    len <- s_len;
    len8 <- len;
    len8 <- (len8 `>>` (W8.of_int 3));
    j <- (W64.of_int 0);
    
    while ((j \ult len8)) {
      t <- (get64 (WArray64.init32 (fun i => s_k.[i])) (W64.to_uint j));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + ((W64.of_int 8) * j))) t;
      j <- (j + (W64.of_int 1));
    }
    j <- (j `<<` (W8.of_int 3));
    
    while ((j \ult len)) {
      pi <- (get8 (WArray64.init32 (fun i => s_k.[i])) (W64.to_uint j));
      Glob.mem <- storeW8 Glob.mem (W64.to_uint (output + j)) pi;
      j <- (j + (W64.of_int 1));
    }
    return ();
  }
  
  proc __copy_state_ref (st:W32.t Array16.t) : W32.t Array16.t * W32.t *
                                               W32.t = {
    var aux: int;
    
    var k:W32.t Array16.t;
    var s_k2:W32.t;
    var s_k3:W32.t;
    var i:int;
    k <- witness;
    i <- 0;
    while (i < 4) {
      k.[i] <- st.[i];
      i <- i + 1;
    }
    s_k2 <- k.[2];
    s_k3 <- k.[3];
    i <- 4;
    while (i < 16) {
      k.[i] <- st.[i];
      i <- i + 1;
    }
    return (k, s_k2, s_k3);
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
  
  proc __sum_states_ref (k:W32.t Array16.t, k15:W32.t, st:W32.t Array16.t) : 
  W32.t Array16.t * W32.t = {
    var aux: int;
    
    var i:int;
    var k14:W32.t;
    var t:W32.t;
    
    i <- 0;
    while (i < 15) {
      k.[i] <- (k.[i] + st.[i]);
      i <- i + 1;
    }
    k14 <- k.[14];
    t <- k15;
    t <- (t + st.[15]);
    k15 <- t;
    k.[14] <- k14;
    return (k, k15);
  }
  
  proc __salsa20_xor_ref (output:W64.t, plain:W64.t, len:W64.t, nonce:W64.t,
                          key:W64.t) : unit = {
    
    var s_output:W64.t;
    var s_plain:W64.t;
    var s_len:W64.t;
    var st:W32.t Array16.t;
    var k:W32.t Array16.t;
    var k2:W32.t;
    var k3:W32.t;
    var k15:W32.t;
    k <- witness;
    st <- witness;
    s_output <- output;
    s_plain <- plain;
    s_len <- len;
    st <@ __init_ref (nonce, key);
    len <- s_len;
    while (((W64.of_int 64) \ule len)) {
      (k, k2, k3) <@ __copy_state_ref (st);
      (k, k15) <@ __rounds_ref (k, k2, k3);
      (s_output, s_plain, s_len) <@ __sum_states_store_xor_ref (s_output,
      s_plain, s_len, k, k15, st);
      st <@ __increment_counter_ref (st);
      len <- s_len;
    }
    if (((W64.of_int 0) \ult len)) {
      (k, k2, k3) <@ __copy_state_ref (st);
      (k, k15) <@ __rounds_ref (k, k2, k3);
      (k, k15) <@ __sum_states_ref (k, k15, st);
      __store_xor_last_ref (s_output, s_plain, s_len, k, k15);
    } else {
      
    }
    return ();
  }
  
  proc __salsa20_ref (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    var s_output:W64.t;
    var s_len:W64.t;
    var st:W32.t Array16.t;
    var k:W32.t Array16.t;
    var k2:W32.t;
    var k3:W32.t;
    var k15:W32.t;
    k <- witness;
    st <- witness;
    s_output <- output;
    s_len <- len;
    st <@ __init_ref (nonce, key);
    len <- s_len;
    while (((W64.of_int 64) \ule len)) {
      (k, k2, k3) <@ __copy_state_ref (st);
      (k, k15) <@ __rounds_ref (k, k2, k3);
      (s_output, s_len) <@ __sum_states_store_ref (s_output, s_len, k, k15,
      st);
      st <@ __increment_counter_ref (st);
      len <- s_len;
    }
    if (((W64.of_int 0) \ult len)) {
      (k, k2, k3) <@ __copy_state_ref (st);
      (k, k15) <@ __rounds_ref (k, k2, k3);
      (k, k15) <@ __sum_states_ref (k, k15, st);
      __store_last_ref (s_output, s_len, k, k15);
    } else {
      
    }
    return ();
  }
  
  proc jade_stream_salsa20_salsa20_amd64_ref_xor (output:W64.t, plain:W64.t,
                                                  len:W64.t, nonce:W64.t,
                                                  key:W64.t) : W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __salsa20_xor_ref (output, plain, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
  
  proc jade_stream_salsa20_salsa20_amd64_ref (output:W64.t, len:W64.t,
                                              nonce:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __salsa20_ref (output, len, nonce, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

