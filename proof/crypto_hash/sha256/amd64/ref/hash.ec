require import AllCore IntDiv CoreMap List.
from Jasmin require import JModel.

require import Array8 Array32 Array64.
require import WArray32 WArray128 WArray256.

abbrev SHA256_K = Array64.of_list witness [W32.of_int 1116352408;
W32.of_int 1899447441; W32.of_int (-1245643825); W32.of_int (-373957723);
W32.of_int 961987163; W32.of_int 1508970993; W32.of_int (-1841331548);
W32.of_int (-1424204075); W32.of_int (-670586216); W32.of_int 310598401;
W32.of_int 607225278; W32.of_int 1426881987; W32.of_int 1925078388;
W32.of_int (-2132889090); W32.of_int (-1680079193); W32.of_int (-1046744716);
W32.of_int (-459576895); W32.of_int (-272742522); W32.of_int 264347078;
W32.of_int 604807628; W32.of_int 770255983; W32.of_int 1249150122;
W32.of_int 1555081692; W32.of_int 1996064986; W32.of_int (-1740746414);
W32.of_int (-1473132947); W32.of_int (-1341970488); W32.of_int (-1084653625);
W32.of_int (-958395405); W32.of_int (-710438585); W32.of_int 113926993;
W32.of_int 338241895; W32.of_int 666307205; W32.of_int 773529912;
W32.of_int 1294757372; W32.of_int 1396182291; W32.of_int 1695183700;
W32.of_int 1986661051; W32.of_int (-2117940946); W32.of_int (-1838011259);
W32.of_int (-1564481375); W32.of_int (-1474664885); W32.of_int (-1035236496);
W32.of_int (-949202525); W32.of_int (-778901479); W32.of_int (-694614492);
W32.of_int (-200395387); W32.of_int 275423344; W32.of_int 430227734;
W32.of_int 506948616; W32.of_int 659060556; W32.of_int 883997877;
W32.of_int 958139571; W32.of_int 1322822218; W32.of_int 1537002063;
W32.of_int 1747873779; W32.of_int 1955562222; W32.of_int 2024104815;
W32.of_int (-2067236844); W32.of_int (-1933114872); W32.of_int (-1866530822);
W32.of_int (-1538233109); W32.of_int (-1090935817); W32.of_int (-965641998)].


module M = {
  proc __initH_ref () : W32.t Array8.t = {
    
    var h:W32.t Array8.t;
    h <- witness;
    h.[0] <- (W32.of_int 1779033703);
    h.[1] <- (W32.of_int 3144134277);
    h.[2] <- (W32.of_int 1013904242);
    h.[3] <- (W32.of_int 2773480762);
    h.[4] <- (W32.of_int 1359893119);
    h.[5] <- (W32.of_int 2600822924);
    h.[6] <- (W32.of_int 528734635);
    h.[7] <- (W32.of_int 1541459225);
    return (h);
  }
  
  proc __load_H_ref (h:W32.t Array8.t) : W32.t * W32.t * W32.t * W32.t *
                                         W32.t * W32.t * W32.t * W32.t = {
    
    var a:W32.t;
    var b:W32.t;
    var c:W32.t;
    var d:W32.t;
    var e:W32.t;
    var f:W32.t;
    var g:W32.t;
    var h_0:W32.t;
    
    a <- h.[0];
    b <- h.[1];
    c <- h.[2];
    d <- h.[3];
    e <- h.[4];
    f <- h.[5];
    g <- h.[6];
    h_0 <- h.[7];
    return (a, b, c, d, e, f, g, h_0);
  }
  
  proc __store_H_ref (h:W32.t Array8.t, a:W32.t, b:W32.t, c:W32.t, d:W32.t,
                      e:W32.t, f:W32.t, g:W32.t, h_0:W32.t) : W32.t Array8.t = {
    
    
    
    h.[0] <- a;
    h.[1] <- b;
    h.[2] <- c;
    h.[3] <- d;
    h.[4] <- e;
    h.[5] <- f;
    h.[6] <- g;
    h.[7] <- h_0;
    return (h);
  }
  
  proc __store_ref (out:W64.t, h:W32.t Array8.t) : unit = {
    var aux: int;
    
    var i:int;
    var v:W32.t;
    
    i <- 0;
    while (i < 8) {
      v <- h.[i];
      v <- BSWAP_32 v;
      Glob.mem <-
      storeW32 Glob.mem (W64.to_uint (out + (W64.of_int (i * 4)))) v;
      i <- i + 1;
    }
    return ();
  }
  
  proc __SHR_ref (x:W32.t, c:int) : W32.t = {
    
    var r:W32.t;
    
    r <- x;
    r <- (r `>>` (W8.of_int c));
    return (r);
  }
  
  proc __ROTR_ref (x:W32.t, c:int) : W32.t = {
    
    var r:W32.t;
    var  _0:bool;
    var  _1:bool;
    
    r <- x;
    ( _0,  _1, r) <- ROR_32 r (W8.of_int c);
    return (r);
  }
  
  proc __CH_ref (x:W32.t, y:W32.t, z:W32.t) : W32.t = {
    
    var r:W32.t;
    var s:W32.t;
    
    r <- x;
    r <- (r `&` y);
    s <- x;
    s <- (invw s);
    s <- (s `&` z);
    r <- (r `^` s);
    return (r);
  }
  
  proc __MAJ_ref (x:W32.t, y:W32.t, z:W32.t) : W32.t = {
    
    var r:W32.t;
    var s:W32.t;
    
    r <- x;
    r <- (r `&` y);
    s <- x;
    s <- (s `&` z);
    r <- (r `^` s);
    s <- y;
    s <- (s `&` z);
    r <- (r `^` s);
    return (r);
  }
  
  proc __BSIG0_ref (x:W32.t) : W32.t = {
    
    var r:W32.t;
    var s:W32.t;
    
    r <@ __ROTR_ref (x, 2);
    s <@ __ROTR_ref (x, 13);
    r <- (r `^` s);
    s <@ __ROTR_ref (x, 22);
    r <- (r `^` s);
    return (r);
  }
  
  proc __BSIG1_ref (x:W32.t) : W32.t = {
    
    var r:W32.t;
    var s:W32.t;
    
    r <@ __ROTR_ref (x, 6);
    s <@ __ROTR_ref (x, 11);
    r <- (r `^` s);
    s <@ __ROTR_ref (x, 25);
    r <- (r `^` s);
    return (r);
  }
  
  proc __SSIG0_ref (x:W32.t) : W32.t = {
    
    var r:W32.t;
    var s:W32.t;
    
    r <@ __ROTR_ref (x, 7);
    s <@ __ROTR_ref (x, 18);
    r <- (r `^` s);
    s <@ __SHR_ref (x, 3);
    r <- (r `^` s);
    return (r);
  }
  
  proc __SSIG1_ref (x:W32.t) : W32.t = {
    
    var r:W32.t;
    var s:W32.t;
    
    r <@ __ROTR_ref (x, 17);
    s <@ __ROTR_ref (x, 19);
    r <- (r `^` s);
    s <@ __SHR_ref (x, 10);
    r <- (r `^` s);
    return (r);
  }
  
  proc __Wt_ref (w:W32.t Array64.t, t:int) : W32.t Array64.t = {
    
    var wt2:W32.t;
    var wt:W32.t;
    var wt15:W32.t;
    
    wt2 <- w.[(t - 2)];
    wt <@ __SSIG1_ref (wt2);
    wt <- (wt + w.[(t - 7)]);
    wt15 <- w.[(t - 15)];
    wt15 <@ __SSIG0_ref (wt15);
    wt <- (wt + wt15);
    wt <- (wt + w.[(t - 16)]);
    w.[t] <- wt;
    return (w);
  }
  
  proc _blocks_0_ref (h:W32.t Array8.t, in_0:W64.t, inlen:W64.t) : W32.t Array8.t *
                                                                   W64.t *
                                                                   W64.t = {
    var aux: int;
    
    var kp:W32.t Array64.t;
    var hp:W32.t Array8.t;
    var t:int;
    var v:W32.t;
    var w:W32.t Array64.t;
    var in_s:W64.t;
    var a:W32.t;
    var b:W32.t;
    var c:W32.t;
    var d:W32.t;
    var e:W32.t;
    var f:W32.t;
    var g:W32.t;
    var h_0:W32.t;
    var tr:W64.t;
    var t1:W32.t;
    var r:W32.t;
    var t2:W32.t;
    hp <- witness;
    kp <- witness;
    w <- witness;
    kp <- SHA256_K;
    hp <- h;
    
    while (((W64.of_int 64) \ule inlen)) {
      t <- 0;
      while (t < 16) {
        v <- (loadW32 Glob.mem (W64.to_uint (in_0 + (W64.of_int (t * 4)))));
        v <- BSWAP_32 v;
        w.[t] <- v;
        t <- t + 1;
      }
      in_s <- in_0;
      t <- 16;
      while (t < 64) {
        w <@ __Wt_ref (w, t);
        t <- t + 1;
      }
      (a, b, c, d, e, f, g, h_0) <@ __load_H_ref (hp);
      tr <- (W64.of_int 0);
      
      while ((tr \ult (W64.of_int 64))) {
        t1 <- h_0;
        r <@ __BSIG1_ref (e);
        t1 <- (t1 + r);
        r <@ __CH_ref (e, f, g);
        t1 <- (t1 + r);
        t1 <- (t1 + kp.[(W64.to_uint tr)]);
        t1 <- (t1 + w.[(W64.to_uint tr)]);
        t2 <@ __BSIG0_ref (a);
        r <@ __MAJ_ref (a, b, c);
        t2 <- (t2 + r);
        h_0 <- g;
        g <- f;
        f <- e;
        e <- d;
        e <- (e + t1);
        d <- c;
        c <- b;
        b <- a;
        a <- t1;
        a <- (a + t2);
        tr <- (tr + (W64.of_int 1));
      }
      h <- hp;
      a <- (a + h.[0]);
      b <- (b + h.[1]);
      c <- (c + h.[2]);
      d <- (d + h.[3]);
      e <- (e + h.[4]);
      f <- (f + h.[5]);
      g <- (g + h.[6]);
      h_0 <- (h_0 + h.[7]);
      h <@ __store_H_ref (h, a, b, c, d, e, f, g, h_0);
      hp <- h;
      in_0 <- in_s;
      in_0 <- (in_0 + (W64.of_int 64));
      inlen <- (inlen - (W64.of_int 64));
    }
    h <- hp;
    return (h, in_0, inlen);
  }
  
  proc _blocks_1_ref (h:W32.t Array8.t, sblocks:W32.t Array32.t,
                      nblocks:W64.t) : W32.t Array8.t = {
    var aux: int;
    
    var kp:W32.t Array64.t;
    var hp:W32.t Array8.t;
    var oblocks:W64.t;
    var t:int;
    var v:W32.t;
    var w:W32.t Array64.t;
    var s_oblocks:W64.t;
    var s_sblocks:W32.t Array32.t;
    var a:W32.t;
    var b:W32.t;
    var c:W32.t;
    var d:W32.t;
    var e:W32.t;
    var f:W32.t;
    var g:W32.t;
    var h_0:W32.t;
    var tr:W64.t;
    var t1:W32.t;
    var r:W32.t;
    var t2:W32.t;
    hp <- witness;
    kp <- witness;
    w <- witness;
    s_sblocks <- witness;
    kp <- SHA256_K;
    hp <- h;
    oblocks <- (W64.of_int 0);
    
    while (((W64.of_int 0) \ult nblocks)) {
      t <- 0;
      while (t < 16) {
        v <- sblocks.[((W64.to_uint oblocks) + t)];
        v <- BSWAP_32 v;
        w.[t] <- v;
        t <- t + 1;
      }
      oblocks <- (oblocks + (W64.of_int 16));
      s_oblocks <- oblocks;
      s_sblocks <- sblocks;
      t <- 16;
      while (t < 64) {
        w <@ __Wt_ref (w, t);
        t <- t + 1;
      }
      (a, b, c, d, e, f, g, h_0) <@ __load_H_ref (hp);
      tr <- (W64.of_int 0);
      
      while ((tr \ult (W64.of_int 64))) {
        t1 <- h_0;
        r <@ __BSIG1_ref (e);
        t1 <- (t1 + r);
        r <@ __CH_ref (e, f, g);
        t1 <- (t1 + r);
        t1 <- (t1 + kp.[(W64.to_uint tr)]);
        t1 <- (t1 + w.[(W64.to_uint tr)]);
        t2 <@ __BSIG0_ref (a);
        r <@ __MAJ_ref (a, b, c);
        t2 <- (t2 + r);
        h_0 <- g;
        g <- f;
        f <- e;
        e <- d;
        e <- (e + t1);
        d <- c;
        c <- b;
        b <- a;
        a <- t1;
        a <- (a + t2);
        tr <- (tr + (W64.of_int 1));
      }
      h <- hp;
      a <- (a + h.[0]);
      b <- (b + h.[1]);
      c <- (c + h.[2]);
      d <- (d + h.[3]);
      e <- (e + h.[4]);
      f <- (f + h.[5]);
      g <- (g + h.[6]);
      h_0 <- (h_0 + h.[7]);
      h <@ __store_H_ref (h, a, b, c, d, e, f, g, h_0);
      hp <- h;
      sblocks <- s_sblocks;
      oblocks <- s_oblocks;
      nblocks <- (nblocks - (W64.of_int 1));
    }
    h <- hp;
    return (h);
  }
  
  proc __lastblocks_ref (in_0:W64.t, inlen:W64.t, bits:W64.t) : W32.t Array32.t *
                                                                W64.t = {
    
    var sblocks:W32.t Array32.t;
    var nblocks:W64.t;
    var i:W64.t;
    var v:W8.t;
    var j:W64.t;
    sblocks <- witness;
    i <- (W64.of_int 0);
    
    while ((i \ult inlen)) {
      v <- (loadW8 Glob.mem (W64.to_uint (in_0 + i)));
      sblocks <-
      Array32.init
      (WArray128.get32 (WArray128.set8 (WArray128.init32 (fun i => sblocks.[i])) (W64.to_uint i) v));
      i <- (i + (W64.of_int 1));
    }
    sblocks <-
    Array32.init
    (WArray128.get32 (WArray128.set8 (WArray128.init32 (fun i => sblocks.[i])) (W64.to_uint i) (W8.of_int 128)));
    i <- (i + (W64.of_int 1));
    if ((inlen \ult (W64.of_int 56))) {
      j <- (W64.of_int (64 - 8));
      nblocks <- (W64.of_int 1);
    } else {
      j <- (W64.of_int (128 - 8));
      nblocks <- (W64.of_int 2);
    }
    v <- (W8.of_int 0);
    
    while ((i \ult j)) {
      sblocks <-
      Array32.init
      (WArray128.get32 (WArray128.set8 (WArray128.init32 (fun i => sblocks.[i])) (W64.to_uint i) v));
      i <- (i + (W64.of_int 1));
    }
    i <- (i + (W64.of_int 7));
    
    while ((j \ule i)) {
      sblocks <-
      Array32.init
      (WArray128.get32 (WArray128.set8 (WArray128.init32 (fun i => sblocks.[i])) (W64.to_uint i) (truncateu8 bits)));
      bits <- (bits `>>` (W8.of_int 8));
      i <- (i - (W64.of_int 1));
    }
    i <- (i + (W64.of_int 9));
    
    while ((i \ult (W64.of_int 128))) {
      sblocks <-
      Array32.init
      (WArray128.get32 (WArray128.set8 (WArray128.init32 (fun i => sblocks.[i])) (W64.to_uint i) v));
      i <- (i + (W64.of_int 1));
    }
    return (sblocks, nblocks);
  }
  
  proc __sha256 (out:W64.t, in_0:W64.t, inlen:W64.t) : unit = {
    
    var s_out:W64.t;
    var bits:W64.t;
    var s_bits:W64.t;
    var h:W32.t Array8.t;
    var sblocks:W32.t Array32.t;
    var nblocks:W64.t;
    h <- witness;
    sblocks <- witness;
    s_out <- out;
    bits <- inlen;
    bits <- (bits `<<` (W8.of_int 3));
    s_bits <- bits;
    h <@ __initH_ref ();
    (h, in_0, inlen) <@ _blocks_0_ref (h, in_0, inlen);
    bits <- s_bits;
    (sblocks, nblocks) <@ __lastblocks_ref (in_0, inlen, bits);
    h <@ _blocks_1_ref (h, sblocks, nblocks);
    out <- s_out;
    __store_ref (out, h);
    return ();
  }
  
  proc jade_hash_sha256_amd64_ref (out:W64.t, in_0:W64.t, len:W64.t) : 
  W64.t = {
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    __sha256 (out, in_0, len);
    ( _0,  _1,  _2,  _3,  _4, r) <- set0_64 ;
    return (r);
  }
}.

