require import AllCore List IntDiv CoreMap.
require import Array16.
require import WArray64.

from Jasmin require import JModel.

module M = {
  proc init (key nonce: address, counter:W32.t) : W32.t Array16.t = {
    var st:W32.t Array16.t;
    var i:int;
    st <- witness;
    st.[0] <- (W32.of_int 1634760805);
    st.[1] <- (W32.of_int 857760878);
    st.[2] <- (W32.of_int 2036477234);
    st.[3] <- (W32.of_int 1797285236);
    i <- 0;
    while (i < 8) {
      st.[(4 + i)] <- loadW32 Glob.mem (key + 4 * i);
      i <- i + 1;
    }
    st.[12] <- counter;
    i <- 0;
    while (i < 3) {
      st.[(13 + i)] <- loadW32 Glob.mem (nonce + 4 * i);
      i <- i + 1;
    }
    return st;
  }
    
  proc line (k:W32.t Array16.t, a:int, b:int, c:int, r:int) : W32.t Array16.t = {
    k.[a] <- (k.[a] + k.[b]);
    k.[c] <- (k.[c] `^` k.[a]);
    k.[c] <- rol k.[c] r;
    return k;
  }
  
  proc quarter_round (k:W32.t Array16.t, a:int, b:int, c:int, d:int) : W32.t Array16.t = {
    k <@ line (k, a, b, d, 16);
    k <@ line (k, c, d, b, 12);
    k <@ line (k, a, b, d, 8);
    k <@ line (k, c, d, b, 7);
    return k;
  }
  
  proc column_round (k:W32.t Array16.t) : W32.t Array16.t = {
    k <@ quarter_round (k, 0, 4, 8, 12);
    k <@ quarter_round (k, 2, 6, 10, 14);
    k <@ quarter_round (k, 1, 5, 9, 13);
    k <@ quarter_round (k, 3, 7, 11, 15);
    return k;
  }
  
  proc diagonal_round (k:W32.t Array16.t) : W32.t Array16.t = {
    k <@ quarter_round (k, 1, 6, 11, 12);
    k <@ quarter_round (k, 0, 5, 10, 15);
    k <@ quarter_round (k, 2, 7, 8, 13);
    k <@ quarter_round (k, 3, 4, 9, 14);
    return k;
  }
  
  proc round (k:W32.t Array16.t) : W32.t Array16.t = {
    k <@ column_round (k);
    k <@ diagonal_round (k);
    return k;
  }
  
  proc rounds (k:W32.t Array16.t) : W32.t Array16.t = {
    var c:int;
    c <- 0;
    while (c < 10) {
      k <@ round (k);
      c <- c + 1;
    }
    return k;
  }
  
  proc sum_states (k:W32.t Array16.t, st:W32.t Array16.t) : W32.t Array16.t = {
    var i:int;
    i <- 0;
    while (i < 16) {
      k.[i] <- (k.[i] + st.[i]);
      i <- i + 1;
    }
    return k;
  }

  proc update_ptr (output plain: address, len n: int) : address * address * int = {
    output <- output + n;
    plain  <- plain  + n;
    len    <- len    - n;
    return (output, plain, len);
  }

  proc store (output plain: address, len: int, k:W32.t Array16.t) : address * address * int = {
    var i:int;
    var k8_0, k8: WArray64.t;
    k8 <- witness;
    k8_0 <- WArray64.init32 (fun i => k.[i]);
    i <- 0;  
    while (i < min 64 len) {
      k8.[i] <- k8_0.[i] `^` loadW8 Glob.mem (plain + i);
      i <- i + 1;
    }
    i <- 0;
    while (i < min 64 len) {
      Glob.mem <- storeW8 Glob.mem (output + i) k8.[i];
      i <- i + 1;
    }
    (output, plain, len) <@ update_ptr (output, plain, len, i);
    return (output, plain, len);
  }
  
  proc increment_counter (st:W32.t Array16.t) : W32.t Array16.t = {
    st.[12] <- st.[12] + W32.of_int 1;
    return st;
  }
  
  proc chacha20_ref (output plain:address, len:int, key nonce: address, counter:W32.t) : unit = {
    
    var st:W32.t Array16.t;
    var k:W32.t Array16.t;

    st <@ init (key, nonce, counter);    
    while (0 < len) {
      k <@ rounds (st);
      k <@ sum_states (k, st);
      (output, plain, len) <@ store (output, plain, len, k);
      st <@ increment_counter (st);
    }
  }
}.


