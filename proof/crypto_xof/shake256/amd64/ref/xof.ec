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
  
  proc __rhotates (x:int, y:int) : int = {
    
    var r:int;
    var i:int;
    
    i <@ __index (x, y);
    r <@ __keccak_rho_offsets (i);
    return (r);
  }
  
  proc __theta_sum_ref (a:W64.t Array25.t) : W64.t Array5.t = {
    var aux: int;
    
    var c:W64.t Array5.t;
    var x:int;
    var y:int;
    c <- witness;
    x <- 0;
    while (x < 5) {
      c.[x] <- a.[(x + 0)];
      x <- x + 1;
    }
    y <- 1;
    while (y < 5) {
      x <- 0;
      while (x < 5) {
        c.[x] <- (c.[x] `^` a.[(x + (y * 5))]);
        x <- x + 1;
      }
      y <- y + 1;
    }
    return (c);
  }
  
  proc __theta_rol_ref (c:W64.t Array5.t) : W64.t Array5.t = {
    var aux_1: bool;
    var aux_0: bool;
    var aux: int;
    var aux_2: W64.t;
    
    var d:W64.t Array5.t;
    var x:int;
    var  _0:bool;
    var  _1:bool;
    d <- witness;
    x <- 0;
    while (x < 5) {
      d.[x] <- c.[((x + 1) %% 5)];
      (aux_1, aux_0, aux_2) <- ROL_64 d.[x] (W8.of_int 1);
       _0 <- aux_1;
       _1 <- aux_0;
      d.[x] <- aux_2;
      d.[x] <- (d.[x] `^` c.[(((x - 1) + 5) %% 5)]);
      x <- x + 1;
    }
    return (d);
  }
  
  proc __rol_sum_ref (a:W64.t Array25.t, d:W64.t Array5.t, y:int) : W64.t Array5.t = {
    var aux_1: bool;
    var aux_0: bool;
    var aux: int;
    var aux_2: W64.t;
    
    var b:W64.t Array5.t;
    var x:int;
    var x_:int;
    var y_:int;
    var r:int;
    var  _0:bool;
    var  _1:bool;
    b <- witness;
    x <- 0;
    while (x < 5) {
      x_ <- ((x + (3 * y)) %% 5);
      y_ <- x;
      r <@ __rhotates (x_, y_);
      b.[x] <- a.[(x_ + (y_ * 5))];
      b.[x] <- (b.[x] `^` d.[x_]);
      if ((r <> 0)) {
        (aux_1, aux_0, aux_2) <- ROL_64 b.[x] (W8.of_int r);
         _0 <- aux_1;
         _1 <- aux_0;
        b.[x] <- aux_2;
      } else {
        
      }
      x <- x + 1;
    }
    return (b);
  }
  
  proc __set_row_ref (e:W64.t Array25.t, b:W64.t Array5.t, y:int, rc:W64.t) : 
  W64.t Array25.t = {
    var aux: int;
    
    var x:int;
    var x1:int;
    var x2:int;
    var t:W64.t;
    
    x <- 0;
    while (x < 5) {
      x1 <- ((x + 1) %% 5);
      x2 <- ((x + 2) %% 5);
      t <- ((invw b.[x1]) `&` b.[x2]);
      t <- (t `^` b.[x]);
      if (((x = 0) /\ (y = 0))) {
        t <- (t `^` rc);
      } else {
        
      }
      e.[(x + (y * 5))] <- t;
      x <- x + 1;
    }
    return (e);
  }
  
  proc __round_ref (a:W64.t Array25.t, rc:W64.t) : W64.t Array25.t = {
    var aux: int;
    
    var e:W64.t Array25.t;
    var c:W64.t Array5.t;
    var d:W64.t Array5.t;
    var y:int;
    var b:W64.t Array5.t;
    b <- witness;
    c <- witness;
    d <- witness;
    e <- witness;
    c <@ __theta_sum_ref (a);
    d <@ __theta_rol_ref (c);
    y <- 0;
    while (y < 5) {
      b <@ __rol_sum_ref (a, d, y);
      e <@ __set_row_ref (e, b, y, rc);
      y <- y + 1;
    }
    return (e);
  }
  
  proc __keccakf1600_ref (a:W64.t Array25.t) : W64.t Array25.t = {
    
    var rC:W64.t Array24.t;
    var c:W64.t;
    var rc:W64.t;
    var e:W64.t Array25.t;
    rC <- witness;
    e <- witness;
    rC <- KECCAK1600_RC;
    c <- (W64.of_int 0);
    rc <- rC.[(W64.to_uint c)];
    e <@ __round_ref (a, rc);
    rc <- rC.[((W64.to_uint c) + 1)];
    a <@ __round_ref (e, rc);
    c <- (c + (W64.of_int 2));
    while ((c \ult (W64.of_int 24))) {
      rc <- rC.[(W64.to_uint c)];
      e <@ __round_ref (a, rc);
      rc <- rC.[((W64.to_uint c) + 1)];
      a <@ __round_ref (e, rc);
      c <- (c + (W64.of_int 2));
    }
    return (a);
  }
  
  proc __keccak_init_ref () : W64.t Array25.t = {
    
    var state:W64.t Array25.t;
    var t:W64.t;
    var i:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    state <- witness;
    ( _0,  _1,  _2,  _3,  _4, t) <- set0_64 ;
    i <- (W64.of_int 0);
    
    while ((i \ult (W64.of_int 25))) {
      state.[(W64.to_uint i)] <- t;
      i <- (i + (W64.of_int 1));
    }
    return (state);
  }
  
  proc __add_full_block_ref (state:W64.t Array25.t, in_0:W64.t, inlen:W64.t,
                             rate:W64.t) : W64.t Array25.t * W64.t * W64.t = {
    
    var rate64:W64.t;
    var i:W64.t;
    var t:W64.t;
    
    rate64 <- rate;
    rate64 <- (rate64 `>>` (W8.of_int 3));
    i <- (W64.of_int 0);
    
    while ((i \ult rate64)) {
      t <- (loadW64 Glob.mem (W64.to_uint (in_0 + ((W64.of_int 8) * i))));
      state.[(W64.to_uint i)] <- (state.[(W64.to_uint i)] `^` t);
      i <- (i + (W64.of_int 1));
    }
    in_0 <- (in_0 + rate);
    inlen <- (inlen - rate);
    return (state, in_0, inlen);
  }
  
  proc __add_final_block_ref (state:W64.t Array25.t, in_0:W64.t, inlen:W64.t,
                              trail_byte:W8.t, rate:W64.t) : W64.t Array25.t = {
    
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
    i <- rate;
    i <- (i - (W64.of_int 1));
    state <-
    Array25.init
    (WArray200.get64 (WArray200.set8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i) (
    (get8 (WArray200.init64 (fun i => state.[i])) (W64.to_uint i)) `^` (W8.of_int 128))));
    return (state);
  }
  
  proc __absorb_ref (state:W64.t Array25.t, in_0:W64.t, inlen:W64.t,
                     s_trail_byte:W8.t, rate:W64.t) : W64.t Array25.t * W64.t = {
    
    var s_in:W64.t;
    var s_inlen:W64.t;
    var s_rate:W64.t;
    var trail_byte:W8.t;
    
    
    while ((rate \ule inlen)) {
      (state, in_0, inlen) <@ __add_full_block_ref (state, in_0, inlen,
      rate);
      s_in <- in_0;
      s_inlen <- inlen;
      s_rate <- rate;
      state <@ __keccakf1600_ref (state);
      in_0 <- s_in;
      inlen <- s_inlen;
      rate <- s_rate;
    }
    trail_byte <- s_trail_byte;
    state <@ __add_final_block_ref (state, in_0, inlen, trail_byte, rate);
    return (state, rate);
  }
  
  proc __xtr_full_block_ref (state:W64.t Array25.t, out:W64.t, outlen:W64.t,
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
  
  proc __xtr_bytes_ref (state:W64.t Array25.t, out:W64.t, outlen:W64.t) : 
  W64.t = {
    
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
    out <- (out + outlen);
    return (out);
  }
  
  proc __squeeze_ref (state:W64.t Array25.t, s_out:W64.t, outlen:W64.t,
                      rate:W64.t) : unit = {
    
    var s_outlen:W64.t;
    var s_rate:W64.t;
    var out:W64.t;
    
    
    while ((rate \ult outlen)) {
      s_outlen <- outlen;
      s_rate <- rate;
      state <@ __keccakf1600_ref (state);
      out <- s_out;
      outlen <- s_outlen;
      rate <- s_rate;
      (out, outlen) <@ __xtr_full_block_ref (state, out, outlen, rate);
      s_out <- out;
    }
    s_outlen <- outlen;
    state <@ __keccakf1600_ref (state);
    out <- s_out;
    outlen <- s_outlen;
    out <@ __xtr_bytes_ref (state, out, outlen);
    return ();
  }
  
  proc __keccak1600_ref (out:W64.t, outlen:W64.t, in_0:W64.t, inlen:W64.t,
                         trail_byte:W8.t, rate:W64.t) : unit = {
    
    var s_out:W64.t;
    var s_outlen:W64.t;
    var s_trail_byte:W8.t;
    var state:W64.t Array25.t;
    state <- witness;
    s_out <- out;
    s_outlen <- outlen;
    s_trail_byte <- trail_byte;
    state <@ __keccak_init_ref ();
    (state, rate) <@ __absorb_ref (state, in_0, inlen, s_trail_byte, rate);
    outlen <- s_outlen;
    __squeeze_ref (state, s_out, outlen, rate);
    return ();
  }
  
  proc __shake256_ref (out:W64.t, outlen:W64.t, in_0:W64.t, inlen:W64.t) : unit = {
    
    var trail_byte:W8.t;
    var rate:W64.t;
    
    trail_byte <- (W8.of_int 31);
    rate <- (W64.of_int (1088 %/ 8));
    __keccak1600_ref (out, outlen, in_0, inlen, trail_byte, rate);
    return ();
  }
  
  proc jade_xof_shake256_amd64_ref (out:W64.t, outlen:W64.t, in_0:W64.t,
                                    inlen:W64.t) : W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __shake256_ref (out, outlen, in_0, inlen);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

