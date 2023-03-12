require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel.

require import Array3 Array8 Array16.
require import WArray12 WArray32 WArray64.



module M = {
  proc init (key:W64.t, nonce:W64.t, counter:W32.t) : W32.t Array16.t = {
    var aux: int;
    
    var st:W32.t Array16.t;
    var i:int;
    var k:W32.t Array8.t;
    var n:W32.t Array3.t;
    k <- witness;
    n <- witness;
    st <- witness;
    st.[0] <- (W32.of_int 1634760805);
    st.[1] <- (W32.of_int 857760878);
    st.[2] <- (W32.of_int 2036477234);
    st.[3] <- (W32.of_int 1797285236);
    i <- 0;
    while (i < 8) {
      k.[i] <- (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (4 * i)))));
      st.[(4 + i)] <- k.[i];
      i <- i + 1;
    }
    st.[12] <- counter;
    i <- 0;
    while (i < 3) {
      n.[i] <-
      (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (4 * i)))));
      st.[(13 + i)] <- n.[i];
      i <- i + 1;
    }
    return (st);
  }
  
  proc copy_state (st:W32.t Array16.t) : W32.t Array16.t * W32.t = {
    var aux: int;
    
    var k:W32.t Array16.t;
    var s_k15:W32.t;
    var k15:W32.t;
    var i:int;
    k <- witness;
    k15 <- st.[15];
    s_k15 <- k15;
    i <- 0;
    while (i < 15) {
      k.[i] <- st.[i];
      i <- i + 1;
    }
    return (k, s_k15);
  }
  
  proc inlined_double_quarter_round (k:W32.t Array16.t, a0:int, b0:int,
                                     c0:int, d0:int, a1:int, b1:int, c1:int,
                                     d1:int) : W32.t Array16.t = {
    var aux_0: bool;
    var aux: bool;
    var aux_1: W32.t;
    
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
    var  _10:bool;
    var  _11:bool;
    var  _12:bool;
    var  _13:bool;
    var  _14:bool;
    var  _15:bool;
    
    k.[a0] <- (k.[a0] + k.[b0]);
    k.[a1] <- (k.[a1] + k.[b1]);
    k.[d0] <- (k.[d0] `^` k.[a0]);
    k.[d1] <- (k.[d1] `^` k.[a1]);
    (aux_0, aux, aux_1) <- ROL_32 k.[d0] (W8.of_int 16);
     _0 <- aux_0;
     _1 <- aux;
    k.[d0] <- aux_1;
    (aux_0, aux, aux_1) <- ROL_32 k.[d1] (W8.of_int 16);
     _2 <- aux_0;
     _3 <- aux;
    k.[d1] <- aux_1;
    k.[c0] <- (k.[c0] + k.[d0]);
    k.[c1] <- (k.[c1] + k.[d1]);
    k.[b0] <- (k.[b0] `^` k.[c0]);
    k.[b1] <- (k.[b1] `^` k.[c1]);
    (aux_0, aux, aux_1) <- ROL_32 k.[b0] (W8.of_int 12);
     _4 <- aux_0;
     _5 <- aux;
    k.[b0] <- aux_1;
    (aux_0, aux, aux_1) <- ROL_32 k.[b1] (W8.of_int 12);
     _6 <- aux_0;
     _7 <- aux;
    k.[b1] <- aux_1;
    k.[a0] <- (k.[a0] + k.[b0]);
    k.[a1] <- (k.[a1] + k.[b1]);
    k.[d0] <- (k.[d0] `^` k.[a0]);
    k.[d1] <- (k.[d1] `^` k.[a1]);
    (aux_0, aux, aux_1) <- ROL_32 k.[d0] (W8.of_int 8);
     _8 <- aux_0;
     _9 <- aux;
    k.[d0] <- aux_1;
    (aux_0, aux, aux_1) <- ROL_32 k.[d1] (W8.of_int 8);
     _10 <- aux_0;
     _11 <- aux;
    k.[d1] <- aux_1;
    k.[c0] <- (k.[c0] + k.[d0]);
    k.[c1] <- (k.[c1] + k.[d1]);
    k.[b0] <- (k.[b0] `^` k.[c0]);
    k.[b1] <- (k.[b1] `^` k.[c1]);
    (aux_0, aux, aux_1) <- ROL_32 k.[b0] (W8.of_int 7);
     _12 <- aux_0;
     _13 <- aux;
    k.[b0] <- aux_1;
    (aux_0, aux, aux_1) <- ROL_32 k.[b1] (W8.of_int 7);
     _14 <- aux_0;
     _15 <- aux;
    k.[b1] <- aux_1;
    return (k);
  }
  
  proc rounds (k:W32.t Array16.t, k15:W32.t) : W32.t Array16.t * W32.t = {
    
    var c:W32.t;
    var zf:bool;
    var k14:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    
    c <- (W32.of_int 10);
    k <@ inlined_double_quarter_round (k, 0, 4, 8, 12, 2, 6, 10, 14);
    k14 <- k.[14];
    k.[15] <- k15;
    k <@ inlined_double_quarter_round (k, 1, 5, 9, 13, 3, 7, 11, 15);
    k <@ inlined_double_quarter_round (k, 1, 6, 11, 12, 0, 5, 10, 15);
    k15 <- k.[15];
    k.[14] <- k14;
    k <@ inlined_double_quarter_round (k, 2, 7, 8, 13, 3, 4, 9, 14);
    ( _0,  _1,  _2, zf, c) <- DEC_32 c;
    while ((! zf)) {
      k <@ inlined_double_quarter_round (k, 0, 4, 8, 12, 2, 6, 10, 14);
      k14 <- k.[14];
      k.[15] <- k15;
      k <@ inlined_double_quarter_round (k, 1, 5, 9, 13, 3, 7, 11, 15);
      k <@ inlined_double_quarter_round (k, 1, 6, 11, 12, 0, 5, 10, 15);
      k15 <- k.[15];
      k.[14] <- k14;
      k <@ inlined_double_quarter_round (k, 2, 7, 8, 13, 3, 4, 9, 14);
      ( _0,  _1,  _2, zf, c) <- DEC_32 c;
    }
    return (k, k15);
  }
  
  proc sum_states (k:W32.t Array16.t, k15:W32.t, st:W32.t Array16.t) : 
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
  
  proc update_ptr (output:W64.t, plain:W64.t, len:W32.t, n:int) : W64.t *
                                                                  W64.t *
                                                                  W32.t = {
    
    
    
    output <- (output + (W64.of_int n));
    plain <- (plain + (W64.of_int n));
    len <- (len - (W32.of_int n));
    return (output, plain, len);
  }
  
  proc sum_states_store (s_output:W64.t, s_plain:W64.t, s_len:W32.t,
                         k:W32.t Array16.t, k15:W32.t, st:W32.t Array16.t) : 
  W64.t * W64.t * W32.t = {
    var aux_0: int;
    
    var kk:W64.t Array8.t;
    var aux:W64.t;
    var plain:W64.t;
    var output:W64.t;
    var i:int;
    var len:W32.t;
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
    storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * 0)))) (
    kk.[0]);
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
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * (i - 1))))) (
      kk.[(i - 1)]);
      i <- i + 1;
    }
    Glob.mem <-
    storeW64 Glob.mem (W64.to_uint (output + (W64.of_int (8 * 7)))) (
    kk.[7]);
    len <- s_len;
    (output, plain, len) <@ update_ptr (output, plain, len, 64);
    s_output <- output;
    s_plain <- plain;
    s_len <- len;
    return (s_output, s_plain, s_len);
  }
  
  proc store_last (s_output:W64.t, s_plain:W64.t, s_len:W32.t,
                   k:W32.t Array16.t, k15:W32.t) : unit = {
    var aux: int;
    
    var i:int;
    var s_k:W32.t Array16.t;
    var u:W32.t;
    var output:W64.t;
    var plain:W64.t;
    var len:W32.t;
    var len8:W32.t;
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
    
    while (((truncateu32 j) \ult len8)) {
      t <- (loadW64 Glob.mem (W64.to_uint (plain + ((W64.of_int 8) * j))));
      t <-
      (t `^` (get64 (WArray64.init32 (fun i_0 => s_k.[i_0])) (W64.to_uint j)));
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + ((W64.of_int 8) * j))) (t);
      j <- (j + (W64.of_int 1));
    }
    j <- (j `<<` (W8.of_int 3));
    
    while (((truncateu32 j) \ult len)) {
      pi <- (loadW8 Glob.mem (W64.to_uint (plain + j)));
      pi <-
      (pi `^` (get8 (WArray64.init32 (fun i_0 => s_k.[i_0])) (W64.to_uint j)));
      Glob.mem <- storeW8 Glob.mem (W64.to_uint (output + j)) (pi);
      j <- (j + (W64.of_int 1));
    }
    return ();
  }
  
  proc increment_counter (st:W32.t Array16.t) : W32.t Array16.t = {
    
    var t:W32.t;
    
    t <- (W32.of_int 1);
    t <- (t + st.[12]);
    st.[12] <- t;
    return (st);
  }
  
  proc chacha20_ref (output:W64.t, plain:W64.t, len:W32.t, key:W64.t,
                     nonce:W64.t, counter:W32.t) : unit = {
    
    var s_output:W64.t;
    var s_plain:W64.t;
    var s_len:W32.t;
    var st:W32.t Array16.t;
    var k:W32.t Array16.t;
    var k15:W32.t;
    k <- witness;
    st <- witness;
    s_output <- output;
    s_plain <- plain;
    s_len <- len;
    st <@ init (key, nonce, counter);
    
    while (((W32.of_int 64) \ule s_len)) {
      (k, k15) <@ copy_state (st);
      (k, k15) <@ rounds (k, k15);
      (s_output, s_plain, s_len) <@ sum_states_store (s_output, s_plain,
      s_len, k, k15, st);
      st <@ increment_counter (st);
    }
    if (((W32.of_int 0) \ult s_len)) {
      (k, k15) <@ copy_state (st);
      (k, k15) <@ rounds (k, k15);
      (k, k15) <@ sum_states (k, k15, st);
      store_last (s_output, s_plain, s_len, k, k15);
    } else {
      
    }
    return ();
  }
}.

