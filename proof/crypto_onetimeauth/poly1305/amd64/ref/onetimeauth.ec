require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array2 Array3.
require import WArray16 WArray24.



module M = {
  proc __crypto_verify_p_u8x16_r_u64x2 (_h:W64.t, h:W64.t Array2.t) : 
  W64.t = {
    
    var t:W64.t;
    var r:W64.t;
    var cf:bool;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    var  _5:bool;
    
    r <- h.[0];
    r <- (r `^` (loadW64 Glob.mem (W64.to_uint (_h + (W64.of_int 0)))));
    t <- h.[1];
    t <- (t `^` (loadW64 Glob.mem (W64.to_uint (_h + (W64.of_int 8)))));
    r <- (r `|` t);
    ( _0,  _1,  _2,  _3,  _4, t) <- set0_64 ;
    (cf, r) <- subc_64 r (W64.of_int 1) false;
    ( _5, t) <- addc_64 t (W64.of_int 0) cf;
    t <- (t - (W64.of_int 1));
    return (t);
  }
  
  proc __load2 (p:W64.t) : W64.t Array2.t = {
    
    var x:W64.t Array2.t;
    x <- witness;
    x.[0] <- (loadW64 Glob.mem (W64.to_uint (p + (W64.of_int 0))));
    x.[1] <- (loadW64 Glob.mem (W64.to_uint (p + (W64.of_int 8))));
    return (x);
  }
  
  proc __load_add (h:W64.t Array3.t, in_0:W64.t) : W64.t Array3.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var cf:bool;
    var  _0:bool;
    
    (aux, aux_0) <- addc_64 h.[0]
    (loadW64 Glob.mem (W64.to_uint (in_0 + (W64.of_int 0)))) false;
    cf <- aux;
    h.[0] <- aux_0;
    (aux, aux_0) <- addc_64 h.[1]
    (loadW64 Glob.mem (W64.to_uint (in_0 + (W64.of_int 8)))) cf;
    cf <- aux;
    h.[1] <- aux_0;
    (aux, aux_0) <- addc_64 h.[2] (W64.of_int 1) cf;
     _0 <- aux;
    h.[2] <- aux_0;
    return (h);
  }
  
  proc __load_last_add_mask (len:W64.t) : W64.t Array2.t * W64.t Array2.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var m2:W64.t Array2.t;
    var m1:W64.t Array2.t;
    var s0:W64.t;
    var s1:W64.t;
    var b:W64.t;
    var nb:W64.t;
    var m:W64.t;
    var s2:W64.t;
    var cf:bool;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    var  _5:bool;
    m1 <- witness;
    m2 <- witness;
    ( _0,  _1,  _2,  _3,  _4, s0) <- set0_64 ;
    s1 <- len;
    s1 <- (s1 `&` (W64.of_int 7));
    s1 <- (s1 `<<` (W8.of_int 3));
    b <- len;
    b <- (b `>>` (W8.of_int 3));
    nb <- b;
    nb <- (nb `^` (W64.of_int 1));
    m <- b;
    m <- (m - (W64.of_int 1));
    s2 <- s1;
    s2 <- (s2 `&` m);
    s0 <- (s0 `^` s2);
    s1 <- (s1 `^` s2);
    m1.[0] <- nb;
    m1.[1] <- b;
    m1.[0] <- (m1.[0] `<<` (truncateu8 s0));
    s0 <- s1;
    m1.[1] <- (m1.[1] `<<` (truncateu8 s0));
    m2 <-
    (Array2.init (fun i => get64
    (WArray16.init8 (fun i => copy_64 (Array16.init (fun i => get8
                                      (WArray16.init64 (fun i => m1.[i])) i)).[i]))
    i));
    (aux, aux_0) <- subc_64 m2.[0] (W64.of_int 1) false;
    cf <- aux;
    m2.[0] <- aux_0;
    (aux, aux_0) <- subc_64 m2.[1] (W64.of_int 0) cf;
     _5 <- aux;
    m2.[1] <- aux_0;
    return (m2, m1);
  }
  
  proc __load_last_add (h:W64.t Array3.t, in_0:W64.t, len:W64.t) : W64.t Array3.t = {
    var aux_0: bool;
    var aux: int;
    var aux_1: W64.t;
    
    var m1:W64.t Array2.t;
    var m2:W64.t Array2.t;
    var i:int;
    var v:W64.t Array2.t;
    var cf:bool;
    var  _0:bool;
    m1 <- witness;
    m2 <- witness;
    v <- witness;
    (m1, m2) <@ __load_last_add_mask (len);
    i <- 0;
    while (i < 2) {
      v.[i] <-
      (loadW64 Glob.mem (W64.to_uint (in_0 + (W64.of_int (8 * i)))));
      v.[i] <- (v.[i] `&` m1.[i]);
      v.[i] <- (v.[i] `|` m2.[i]);
      i <- i + 1;
    }
    (aux_0, aux_1) <- addc_64 h.[0] v.[0] false;
    cf <- aux_0;
    h.[0] <- aux_1;
    (aux_0, aux_1) <- addc_64 h.[1] v.[1] cf;
    cf <- aux_0;
    h.[1] <- aux_1;
    (aux_0, aux_1) <- addc_64 h.[2] (W64.of_int 0) cf;
     _0 <- aux_0;
    h.[2] <- aux_1;
    return (h);
  }
  
  proc __store2 (p:W64.t, x:W64.t Array2.t) : unit = {
    
    
    
    Glob.mem <- storeW64 Glob.mem (W64.to_uint (p + (W64.of_int 0))) x.[0];
    Glob.mem <- storeW64 Glob.mem (W64.to_uint (p + (W64.of_int 8))) x.[1];
    return ();
  }
  
  proc __clamp (k:W64.t) : W64.t Array3.t = {
    
    var r:W64.t Array3.t;
    r <- witness;
    r.[0] <- (loadW64 Glob.mem (W64.to_uint (k + (W64.of_int 0))));
    r.[1] <- (loadW64 Glob.mem (W64.to_uint (k + (W64.of_int 8))));
    r.[0] <- (r.[0] `&` (W64.of_int 1152921487695413247));
    r.[1] <- (r.[1] `&` (W64.of_int 1152921487695413244));
    r.[2] <- r.[1];
    r.[2] <- (r.[2] `>>` (W8.of_int 2));
    r.[2] <- (r.[2] + r.[1]);
    return (r);
  }
  
  proc __add2 (h:W64.t Array2.t, s:W64.t Array2.t) : W64.t Array2.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var cf:bool;
    var  _0:bool;
    
    (aux, aux_0) <- addc_64 h.[0] s.[0] false;
    cf <- aux;
    h.[0] <- aux_0;
    (aux, aux_0) <- addc_64 h.[1] s.[1] cf;
     _0 <- aux;
    h.[1] <- aux_0;
    return (h);
  }
  
  proc __mulmod (h:W64.t Array3.t, r:W64.t Array3.t) : W64.t Array3.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var t2:W64.t;
    var rax:W64.t;
    var rdx:W64.t;
    var t0:W64.t;
    var t1:W64.t;
    var cf:bool;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    
    t2 <- r.[2];
    t2 <- (t2 * h.[2]);
    h.[2] <- (h.[2] * r.[0]);
    rax <- r.[0];
    (rdx, rax) <- mulu_64 rax h.[0];
    t0 <- rax;
    t1 <- rdx;
    rax <- r.[0];
    (rdx, rax) <- mulu_64 rax h.[1];
    (cf, t1) <- addc_64 t1 rax false;
    (aux, aux_0) <- addc_64 h.[2] rdx cf;
     _0 <- aux;
    h.[2] <- aux_0;
    rax <- r.[2];
    (rdx, rax) <- mulu_64 rax h.[1];
    h.[1] <- rdx;
    h.[1] <- (h.[1] + t2);
    t2 <- rax;
    rax <- r.[1];
    (rdx, rax) <- mulu_64 rax h.[0];
    (cf, t0) <- addc_64 t0 t2 false;
    (cf, t1) <- addc_64 t1 rax cf;
    (aux, aux_0) <- addc_64 h.[2] rdx cf;
     _1 <- aux;
    h.[2] <- aux_0;
    h.[0] <- (W64.of_int 18446744073709551612);
    t2 <- h.[2];
    t2 <- (t2 `>>` (W8.of_int 2));
    h.[0] <- (h.[0] `&` h.[2]);
    h.[0] <- (h.[0] + t2);
    h.[2] <- (h.[2] `&` (W64.of_int 3));
    (aux, aux_0) <- addc_64 h.[0] t0 false;
    cf <- aux;
    h.[0] <- aux_0;
    (aux, aux_0) <- addc_64 h.[1] t1 cf;
    cf <- aux;
    h.[1] <- aux_0;
    (aux, aux_0) <- addc_64 h.[2] (W64.of_int 0) cf;
     _2 <- aux;
    h.[2] <- aux_0;
    return (h);
  }
  
  proc __freeze (h:W64.t Array3.t) : W64.t Array2.t = {
    var aux: bool;
    var aux_0: W64.t;
    
    var g:W64.t Array2.t;
    var g2:W64.t;
    var cf:bool;
    var mask:W64.t;
    var  _0:bool;
    g <- witness;
    g.[0] <- h.[0];
    g.[1] <- h.[1];
    g2 <- h.[2];
    (aux, aux_0) <- addc_64 g.[0] (W64.of_int 5) false;
    cf <- aux;
    g.[0] <- aux_0;
    (aux, aux_0) <- addc_64 g.[1] (W64.of_int 0) cf;
    cf <- aux;
    g.[1] <- aux_0;
    ( _0, g2) <- addc_64 g2 (W64.of_int 0) cf;
    g2 <- (g2 `>>` (W8.of_int 2));
    mask <- (- g2);
    g.[0] <- (g.[0] `^` h.[0]);
    g.[1] <- (g.[1] `^` h.[1]);
    g.[0] <- (g.[0] `&` mask);
    g.[1] <- (g.[1] `&` mask);
    g.[0] <- (g.[0] `^` h.[0]);
    g.[1] <- (g.[1] `^` h.[1]);
    return (g);
  }
  
  proc __poly1305_setup_ref (k:W64.t) : W64.t Array3.t * W64.t Array3.t *
                                        W64.t = {
    var aux: int;
    
    var h:W64.t Array3.t;
    var r:W64.t Array3.t;
    var i:int;
    h <- witness;
    r <- witness;
    i <- 0;
    while (i < 3) {
      h.[i] <- (W64.of_int 0);
      i <- i + 1;
    }
    r <@ __clamp (k);
    k <- (k + (W64.of_int 16));
    return (h, r, k);
  }
  
  proc __poly1305_update_ref (in_0:W64.t, inlen:W64.t, h:W64.t Array3.t,
                              r:W64.t Array3.t) : W64.t * W64.t *
                                                  W64.t Array3.t = {
    
    
    
    
    while (((W64.of_int 16) \ule inlen)) {
      h <@ __load_add (h, in_0);
      h <@ __mulmod (h, r);
      in_0 <- (in_0 + (W64.of_int 16));
      inlen <- (inlen - (W64.of_int 16));
    }
    return (in_0, inlen, h);
  }
  
  proc __poly1305_last_ref (in_0:W64.t, inlen:W64.t, k:W64.t,
                            h:W64.t Array3.t, r:W64.t Array3.t) : W64.t Array2.t = {
    
    var h2:W64.t Array2.t;
    var s:W64.t Array2.t;
    h2 <- witness;
    s <- witness;
    if (((W64.of_int 0) \ult inlen)) {
      h <@ __load_last_add (h, in_0, inlen);
      h <@ __mulmod (h, r);
    } else {
      
    }
    h2 <@ __freeze (h);
    s <@ __load2 (k);
    h2 <@ __add2 (h2, s);
    return (h2);
  }
  
  proc __poly1305_ref (out:W64.t, in_0:W64.t, _inlen:W64.t, _k:W64.t) : unit = {
    
    var inlen:W64.t;
    var k:W64.t;
    var h:W64.t Array3.t;
    var r:W64.t Array3.t;
    var h2:W64.t Array2.t;
    h <- witness;
    h2 <- witness;
    r <- witness;
    inlen <- _inlen;
    k <- _k;
    (h, r, k) <@ __poly1305_setup_ref (k);
    (in_0, inlen, h) <@ __poly1305_update_ref (in_0, inlen, h, r);
    h2 <@ __poly1305_last_ref (in_0, inlen, k, h, r);
    __store2 (out, h2);
    return ();
  }
  
  proc __poly1305_verify_ref (_h:W64.t, in_0:W64.t, _inlen:W64.t, _k:W64.t) : 
  W64.t = {
    
    var ret:W64.t;
    var inlen:W64.t;
    var k:W64.t;
    var h:W64.t Array3.t;
    var r:W64.t Array3.t;
    var h2:W64.t Array2.t;
    h <- witness;
    h2 <- witness;
    r <- witness;
    inlen <- _inlen;
    k <- _k;
    (h, r, k) <@ __poly1305_setup_ref (k);
    (in_0, inlen, h) <@ __poly1305_update_ref (in_0, inlen, h, r);
    h2 <@ __poly1305_last_ref (in_0, inlen, k, h, r);
    ret <@ __crypto_verify_p_u8x16_r_u64x2 (_h, h2);
    return (ret);
  }
  
  proc jade_onetimeauth_poly1305_amd64_ref (out:W64.t, in_0:W64.t,
                                            inlen:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __poly1305_ref (out, in_0, inlen, key);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
  
  proc jade_onetimeauth_poly1305_amd64_ref_verify (h:W64.t, in_0:W64.t,
                                                   inlen:W64.t, key:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    
    r <@ __poly1305_verify_ref (h, in_0, inlen, key);
    return (r);
  }
}.

