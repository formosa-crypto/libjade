require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array5 Array24 Array25.
require import WArray40 WArray192 WArray200.

abbrev KECCAK1600_RC = Array24.of_list witness [W64.of_int 1;
W64.of_int 32898; W64.of_int (-9223372036854742902);
W64.of_int (-9223372034707259392); W64.of_int 32907; W64.of_int 2147483649;
W64.of_int (-9223372034707259263); W64.of_int (-9223372036854743031);
W64.of_int 138; W64.of_int 136; W64.of_int 2147516425; W64.of_int 2147483658;
W64.of_int 2147516555; W64.of_int (-9223372036854775669);
W64.of_int (-9223372036854742903); W64.of_int (-9223372036854743037);
W64.of_int (-9223372036854743038); W64.of_int (-9223372036854775680);
W64.of_int 32778; W64.of_int (-9223372034707292150);
W64.of_int (-9223372034707259263); W64.of_int (-9223372036854742912);
W64.of_int 2147483649; W64.of_int (-9223372034707259384)].


module M = {
  proc __index (x:int, y:int) : int = {
    
    var r:int;
    
    r <- ((x %% 5) + (5 * (y %% 5)));
    return (r);
  }
  
  proc __keccak_rho_offsets (i:int) : int = {
    var aux: int;
    
    var r:int;
    var x:int;
    var y:int;
    var t:int;
    var z:int;
    
    r <- 0;
    x <- 1;
    y <- 0;
    t <- 0;
    while (t < 24) {
      if ((i = (x + (5 * y)))) {
        r <- ((((t + 1) * (t + 2)) %/ 2) %% 64);
      } else {
        
      }
      z <- (((2 * x) + (3 * y)) %% 5);
      x <- y;
      y <- z;
      t <- t + 1;
    }
    return (r);
  }
  
  proc __theta_spec (a:W64.t Array25.t) : W64.t Array25.t = {
    var aux_1: bool;
    var aux_0: bool;
    var aux: int;
    var aux_2: W64.t;
    
    var x:int;
    var c:W64.t Array5.t;
    var y:int;
    var d:W64.t Array5.t;
    var  _0:bool;
    var  _1:bool;
    c <- witness;
    d <- witness;
    x <- 0;
    while (x < 5) {
      c.[x] <- (W64.of_int 0);
      y <- 0;
      while (y < 5) {
        c.[x] <- (c.[x] `^` a.[(x + (5 * y))]);
        y <- y + 1;
      }
      x <- x + 1;
    }
    x <- 0;
    while (x < 5) {
      d.[x] <- c.[((x + 1) %% 5)];
      (aux_1, aux_0, aux_2) <- ROL_64 d.[x] (W8.of_int 1);
       _0 <- aux_1;
       _1 <- aux_0;
      d.[x] <- aux_2;
      d.[x] <- (d.[x] `^` c.[((x + 4) %% 5)]);
      x <- x + 1;
    }
    x <- 0;
    while (x < 5) {
      y <- 0;
      while (y < 5) {
        a.[(x + (5 * y))] <- (a.[(x + (5 * y))] `^` d.[x]);
        y <- y + 1;
      }
      x <- x + 1;
    }
    return (a);
  }
  
  proc __rho_spec (a:W64.t Array25.t) : W64.t Array25.t = {
    var aux_1: bool;
    var aux_0: bool;
    var aux: int;
    var aux_2: W64.t;
    
    var x:int;
    var y:int;
    var i:int;
    var z:int;
    var  _0:bool;
    var  _1:bool;
    
    x <- 0;
    while (x < 5) {
      y <- 0;
      while (y < 5) {
        i <@ __index (x, y);
        z <@ __keccak_rho_offsets (i);
        (aux_1, aux_0, aux_2) <- ROL_64 a.[i] (W8.of_int z);
         _0 <- aux_1;
         _1 <- aux_0;
        a.[i] <- aux_2;
        y <- y + 1;
      }
      x <- x + 1;
    }
    return (a);
  }
  
  proc __pi_spec (a:W64.t Array25.t) : W64.t Array25.t = {
    var aux: int;
    
    var i:int;
    var t:W64.t;
    var b:W64.t Array25.t;
    var y:int;
    var x:int;
    b <- witness;
    i <- 0;
    while (i < 25) {
      t <- a.[i];
      b.[i] <- t;
      i <- i + 1;
    }
    x <- 0;
    while (x < 5) {
      y <- 0;
      while (y < 5) {
        t <- b.[(x + (5 * y))];
        i <@ __index (y, ((2 * x) + (3 * y)));
        a.[i] <- t;
        y <- y + 1;
      }
      x <- x + 1;
    }
    return (a);
  }
  
  proc __chi_spec (a:W64.t Array25.t) : W64.t Array25.t = {
    var aux: int;
    
    var x:int;
    var y:int;
    var i:int;
    var c:W64.t Array5.t;
    c <- witness;
    y <- 0;
    while (y < 5) {
      x <- 0;
      while (x < 5) {
        i <@ __index ((x + 1), y);
        c.[x] <- a.[i];
        c.[x] <- (invw c.[x]);
        i <@ __index ((x + 2), y);
        c.[x] <- (c.[x] `&` a.[i]);
        i <@ __index (x, y);
        c.[x] <- (c.[x] `^` a.[i]);
        x <- x + 1;
      }
      x <- 0;
      while (x < 5) {
        a.[(x + (5 * y))] <- c.[x];
        x <- x + 1;
      }
      y <- y + 1;
    }
    return (a);
  }
  
  proc __iota_spec (a:W64.t Array25.t, c:W64.t) : W64.t Array25.t = {
    
    
    
    a.[0] <- (a.[0] `^` c);
    return (a);
  }
  
  proc __keccakP1600_round_spec (state:W64.t Array25.t, c:W64.t) : W64.t Array25.t = {
    
    
    
    state <@ __theta_spec (state);
    state <@ __rho_spec (state);
    state <@ __pi_spec (state);
    state <@ __chi_spec (state);
    state <@ __iota_spec (state, c);
    return (state);
  }
  
  proc __keccakf1600_spec (state:W64.t Array25.t) : W64.t Array25.t = {
    
    var kRCp:W64.t Array24.t;
    var round:W64.t;
    var rC:W64.t;
    kRCp <- witness;
    kRCp <- KECCAK1600_RC;
    round <- (W64.of_int 0);
    
    while ((round \ult (W64.of_int 24))) {
      rC <- kRCp.[(W64.to_uint round)];
      state <@ __keccakP1600_round_spec (state, rC);
      round <- (round + (W64.of_int 1));
    }
    return (state);
  }
  
  proc __st0_spec () : W64.t Array25.t = {
    var aux: int;
    
    var state:W64.t Array25.t;
    var i:int;
    state <- witness;
    i <- 0;
    while (i < 25) {
      state.[i] <- (W64.of_int 0);
      i <- i + 1;
    }
    return (state);
  }
  
  proc __add_full_block_spec (state:W64.t Array25.t, in_0:W64.t, inlen:W64.t,
                              r8:W64.t) : W64.t Array25.t * W64.t * W64.t = {
    
    var r64:W64.t;
    var i:W64.t;
    var t:W64.t;
    
    r64 <- r8;
    r64 <- (r64 `>>` (W8.of_int 3));
    i <- (W64.of_int 0);
    
    while ((i \ult r64)) {
      t <- (loadW64 Glob.mem (W64.to_uint (in_0 + ((W64.of_int 8) * i))));
      state.[(W64.to_uint i)] <- (state.[(W64.to_uint i)] `^` t);
      i <- (i + (W64.of_int 1));
    }
    in_0 <- (in_0 + r8);
    inlen <- (inlen - r8);
    return (state, in_0, inlen);
  }
  
  proc __add_final_block_spec (state:W64.t Array25.t, in_0:W64.t,
                               inlen:W64.t, trail_byte:W8.t, r8:W64.t) : 
  W64.t Array25.t = {
    
    var inlen8:W64.t;
    var i:W64.t;
    var t:W64.t;
    var c:W8.t;
    
    inlen8 <- inlen;
    inlen8 <- (inlen8 `>>` (W8.of_int 3));
    i <- (W64.of_int 0);
    
    while ((i \ult inlen8)) {
      t <- (loadW64 Glob.mem (W64.to_uint (in_0 + ((W64.of_int 8) * i))));
      state.[(W64.to_uint i)] <- (state.[(W64.to_uint i)] `^` t);
      i <- (i + (W64.of_int 1));
    }
    i <- (i `<<` (W8.of_int 3));
    
    while ((i \ult inlen)) {
      c <- (loadW8 Glob.mem (W64.to_uint (in_0 + i)));
      state <-
      Array25.init
      (WArray200.get64 (WArray200.set8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i) (
      (get8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i)) `^` c)));
      i <- (i + (W64.of_int 1));
    }
    state <-
    Array25.init
    (WArray200.get64 (WArray200.set8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i) (
    (get8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i)) `^` trail_byte)));
    i <- r8;
    i <- (i - (W64.of_int 1));
    state <-
    Array25.init
    (WArray200.get64 (WArray200.set8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i) (
    (get8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i)) `^` (W8.of_int 128))));
    return (state);
  }
  
  proc __xtr_full_block_spec (state:W64.t Array25.t, out:W64.t, outlen:W64.t,
                              rate:W64.t) : W64.t * W64.t = {
    
    var rate64:W64.t;
    var i:W64.t;
    var t:W64.t;
    
    rate64 <- rate;
    rate64 <- (rate64 `>>` (W8.of_int 3));
    i <- (W64.of_int 0);
    
    while ((i \ult rate64)) {
      t <- state.[(W64.to_uint i)];
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (out + ((W64.of_int 8) * i))) t;
      i <- (i + (W64.of_int 1));
    }
    out <- (out + rate);
    outlen <- (outlen - rate);
    return (out, outlen);
  }
  
  proc __xtr_bytes_spec (state:W64.t Array25.t, out:W64.t, outlen:W64.t) : unit = {
    
    var outlen8:W64.t;
    var i:W64.t;
    var t:W64.t;
    var c:W8.t;
    
    outlen8 <- outlen;
    outlen8 <- (outlen8 `>>` (W8.of_int 3));
    i <- (W64.of_int 0);
    
    while ((i \ult outlen8)) {
      t <- state.[(W64.to_uint i)];
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (out + ((W64.of_int 8) * i))) t;
      i <- (i + (W64.of_int 1));
    }
    i <- (i `<<` (W8.of_int 3));
    
    while ((i \ult outlen)) {
      c <- (get8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i));
      Glob.mem <- storeW8 Glob.mem (W64.to_uint (out + i)) c;
      i <- (i + (W64.of_int 1));
    }
    return ();
  }
  
  proc __keccak1600_spec (out:W64.t, outlen:W64.t, in_0:W64.t, inlen:W64.t,
                          trail_byte:W8.t, rate:W64.t) : unit = {
    
    var s_out:W64.t;
    var s_outlen:W64.t;
    var s_trail_byte:W8.t;
    var state:W64.t Array25.t;
    var s_in:W64.t;
    var s_inlen:W64.t;
    var s_rate:W64.t;
    state <- witness;
    s_out <- out;
    s_outlen <- outlen;
    s_trail_byte <- trail_byte;
    state <@ __st0_spec ();
    
    while ((rate \ule inlen)) {
      (state, in_0, inlen) <@ __add_full_block_spec (state, in_0, inlen,
      rate);
      s_in <- in_0;
      s_inlen <- inlen;
      s_rate <- rate;
      state <@ __keccakf1600_spec (state);
      inlen <- s_inlen;
      in_0 <- s_in;
      rate <- s_rate;
    }
    trail_byte <- s_trail_byte;
    state <@ __add_final_block_spec (state, in_0, inlen, trail_byte, rate);
    outlen <- s_outlen;
    
    while ((rate \ult outlen)) {
      s_outlen <- outlen;
      s_rate <- rate;
      state <@ __keccakf1600_spec (state);
      out <- s_out;
      outlen <- s_outlen;
      rate <- s_rate;
      (out, outlen) <@ __xtr_full_block_spec (state, out, outlen, rate);
      s_outlen <- outlen;
      s_out <- out;
    }
    state <@ __keccakf1600_spec (state);
    out <- s_out;
    outlen <- s_outlen;
    __xtr_bytes_spec (state, out, outlen);
    return ();
  }
  
  proc __shake256_spec (out:W64.t, outlen:W64.t, in_0:W64.t, inlen:W64.t) : unit = {
    
    var trail_byte:W8.t;
    var rate:W64.t;
    
    trail_byte <- (W8.of_int 31);
    rate <- (W64.of_int (1088 %/ 8));
    __keccak1600_spec (out, outlen, in_0, inlen, trail_byte, rate);
    return ();
  }
  
  proc jade_xof_shake256_amd64_spec (out:W64.t, outlen:W64.t, in_0:W64.t,
                                     inlen:W64.t) : W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __shake256_spec (out, outlen, in_0, inlen);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

