require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel.

require import Array4 Array8 Array16 Array128 Array256 Array512.
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
  var leakages : leakages_t
  
  proc __init_h_avx2 (nonce:W64.t, key:W64.t) : W256.t Array4.t = {
    var aux_0: W128.t;
    var aux: W256.t;
    
    var st:W256.t Array4.t;
    var t:W128.t;
    st <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_SIGMA_H_AVX2;
    leakages <- LeakAddr([0]) :: leakages;
    st.[0] <- aux;
    leakages <- LeakAddr([(W64.to_uint (key + (W64.of_int 0)))]) :: leakages;
    aux <- VPBROADCAST_2u128 (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 0))));
    leakages <- LeakAddr([1]) :: leakages;
    st.[1] <- aux;
    leakages <- LeakAddr([(W64.to_uint (key + (W64.of_int 16)))]) :: leakages;
    aux <- VPBROADCAST_2u128 (loadW128 Glob.mem (W64.to_uint (key + (W64.of_int 16))));
    leakages <- LeakAddr([2]) :: leakages;
    st.[2] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- set0_128 ;
    t <- aux_0;
    leakages <- LeakAddr([(W64.to_uint (nonce + (W64.of_int 0)))]) :: leakages;
    aux_0 <- VPINSR_2u64 t
    (loadW64 Glob.mem (W64.to_uint (nonce + (W64.of_int 0)))) (W8.of_int 1);
    t <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux <- set0_256 ;
    leakages <- LeakAddr([3]) :: leakages;
    st.[3] <- aux;
    leakages <- LeakAddr([3]) :: leakages;
    aux <- VINSERTI128 st.[3] t (W8.of_int 0);
    leakages <- LeakAddr([3]) :: leakages;
    st.[3] <- aux;
    leakages <- LeakAddr([3]) :: leakages;
    aux <- VINSERTI128 st.[3] t (W8.of_int 1);
    leakages <- LeakAddr([3]) :: leakages;
    st.[3] <- aux;
    leakages <- LeakAddr([3]) :: leakages;
    aux <- (st.[3] \vadd64u256 CHACHA_P0100_H_AVX2);
    leakages <- LeakAddr([3]) :: leakages;
    st.[3] <- aux;
    return (st);
  }
  
  proc __increment_counter0404_h_avx2 (st:W256.t Array4.t) : W256.t Array4.t = {
    var aux: W256.t;
    
    
    
    leakages <- LeakAddr([3]) :: leakages;
    aux <- (st.[3] \vadd64u256 CHACHA_P0404_H_AVX2);
    leakages <- LeakAddr([3]) :: leakages;
    st.[3] <- aux;
    return (st);
  }
  
  proc __increment_counter0202_h_avx2 (st:W256.t Array4.t) : W256.t Array4.t = {
    var aux: W256.t;
    
    
    
    leakages <- LeakAddr([3]) :: leakages;
    aux <- (st.[3] \vadd64u256 CHACHA_P0202_H_AVX2);
    leakages <- LeakAddr([3]) :: leakages;
    st.[3] <- aux;
    return (st);
  }
  
  proc __update_ptr_xor_ref (output:W64.t, input:W64.t, len:W64.t, n:int) : 
  W64.t * W64.t * W64.t = {
    var aux: W64.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <- (output + (W64.of_int n));
    output <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- (input + (W64.of_int n));
    input <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- (len - (W64.of_int n));
    len <- aux;
    return (output, input, len);
  }
  
  proc __update_ptr_ref (output:W64.t, len:W64.t, n:int) : W64.t * W64.t = {
    var aux: W64.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <- (output + (W64.of_int n));
    output <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- (len - (W64.of_int n));
    len <- aux;
    return (output, len);
  }
  
  proc __store_xor_h_avx2 (output:W64.t, input:W64.t, len:W64.t,
                           k:W256.t Array4.t) : W64.t * W64.t * W64.t = {
    var aux: int;
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int (32 * i)))); i]) :: leakages;
      aux_0 <- (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (input + (W64.of_int (32 * i))))));
      leakages <- LeakAddr([i]) :: leakages;
      k.[i] <- aux_0;
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * i))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (aux_0);
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 128);
    output <- aux_3;
    input <- aux_2;
    len <- aux_1;
    return (output, input, len);
  }
  
  proc __store_xor_last_h_avx2 (output:W64.t, input:W64.t, len:W64.t,
                                k:W256.t Array4.t) : unit = {
    var aux: int;
    var aux_5: W8.t;
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_4: W128.t;
    var aux_0: W256.t;
    
    var i:int;
    var r0:W128.t;
    var r1:W64.t;
    var r2:W8.t;
    
    leakages <- LeakCond(((W64.of_int 64) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 64) \ule len)) {
      leakages <- LeakFor(0,2) :: LeakAddr([]) :: leakages;
      i <- 0;
      while (i < 2) {
        leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int (32 * i))));
                             i]) :: leakages;
        aux_0 <- (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (input + (W64.of_int (32 * i))))));
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux_0;
        leakages <- LeakAddr([i]) :: leakages;
        aux_0 <- k.[i];
        leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * i))))]) :: leakages;
        Glob.mem <-
        storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (aux_0);
        i <- i + 1;
      }
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 64);
      output <- aux_3;
      input <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([2]) :: leakages;
      aux_0 <- k.[2];
      leakages <- LeakAddr([0]) :: leakages;
      k.[0] <- aux_0;
      leakages <- LeakAddr([3]) :: leakages;
      aux_0 <- k.[3];
      leakages <- LeakAddr([1]) :: leakages;
      k.[1] <- aux_0;
    } else {
      
    }
    leakages <- LeakCond(((W64.of_int 32) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 32) \ule len)) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int 0))); 0]) :: leakages;
      aux_0 <- (k.[0] `^` (loadW256 Glob.mem (W64.to_uint (input + (W64.of_int 0)))));
      leakages <- LeakAddr([0]) :: leakages;
      k.[0] <- aux_0;
      leakages <- LeakAddr([0]) :: leakages;
      aux_0 <- k.[0];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_0);
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 32);
      output <- aux_3;
      input <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([1]) :: leakages;
      aux_0 <- k.[1];
      leakages <- LeakAddr([0]) :: leakages;
      k.[0] <- aux_0;
    } else {
      
    }
    leakages <- LeakAddr([0]) :: leakages;
    aux_0 <- k.[0];
    r0 <- (truncateu128 aux_0);
    leakages <- LeakCond(((W64.of_int 16) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 16) \ule len)) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int 0)))]) :: leakages;
      aux_4 <- (r0 `^` (loadW128 Glob.mem (W64.to_uint (input + (W64.of_int 0)))));
      r0 <- aux_4;
      leakages <- LeakAddr([]) :: leakages;
      aux_4 <- r0;
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_4);
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 16);
      output <- aux_3;
      input <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([0]) :: leakages;
      aux_4 <- VEXTRACTI128 k.[0] (W8.of_int 1);
      r0 <- aux_4;
    } else {
      
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_3 <- VPEXTR_64 r0 (W8.of_int 0);
    r1 <- aux_3;
    leakages <- LeakCond(((W64.of_int 8) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 8) \ule len)) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int 0)))]) :: leakages;
      aux_3 <- (r1 `^` (loadW64 Glob.mem (W64.to_uint (input + (W64.of_int 0)))));
      r1 <- aux_3;
      leakages <- LeakAddr([]) :: leakages;
      aux_3 <- r1;
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_3);
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 8);
      output <- aux_3;
      input <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_3 <- VPEXTR_64 r0 (W8.of_int 1);
      r1 <- aux_3;
    } else {
      
    }
    
    leakages <- LeakCond(((W64.of_int 0) \ult len)) :: LeakAddr([]) :: leakages;
    
    while (((W64.of_int 0) \ult len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_3 <- r1;
      r2 <- (truncateu8 aux_3);
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int 0)))]) :: leakages;
      aux_5 <- (r2 `^` (loadW8 Glob.mem (W64.to_uint (input + (W64.of_int 0)))));
      r2 <- aux_5;
      leakages <- LeakAddr([]) :: leakages;
      aux_5 <- r2;
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_5);
      leakages <- LeakAddr([]) :: leakages;
      aux_3 <- (r1 `>>` (W8.of_int 8));
      r1 <- aux_3;
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 1);
      output <- aux_3;
      input <- aux_2;
      len <- aux_1;
    leakages <- LeakCond(((W64.of_int 0) \ult len)) :: LeakAddr([]) :: leakages;
    
    }
    return ();
  }
  
  proc __store_xor_h_x2_avx2 (output:W64.t, input:W64.t, len:W64.t,
                              k1:W256.t Array4.t, k2:W256.t Array4.t) : 
  W64.t * W64.t * W64.t = {
    var aux: int;
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int (32 * i)))); i]) :: leakages;
      aux_0 <- (k1.[i] `^` (loadW256 Glob.mem (W64.to_uint (input + (W64.of_int (32 * i))))));
      leakages <- LeakAddr([i]) :: leakages;
      k1.[i] <- aux_0;
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k1.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * i))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (aux_0);
      i <- i + 1;
    }
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int (32 * (i + 4)))));
                           i]) :: leakages;
      aux_0 <- (k2.[i] `^` (loadW256 Glob.mem (W64.to_uint (input + (W64.of_int (32 * (i + 4)))))));
      leakages <- LeakAddr([i]) :: leakages;
      k2.[i] <- aux_0;
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k2.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * (i + 4)))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * (i + 4))))) (aux_0);
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 256);
    output <- aux_3;
    input <- aux_2;
    len <- aux_1;
    return (output, input, len);
  }
  
  proc __store_xor_last_h_x2_avx2 (output:W64.t, input:W64.t, len:W64.t,
                                   k1:W256.t Array4.t, k2:W256.t Array4.t) : unit = {
    var aux_1: W64.t;
    var aux_0: W64.t;
    var aux: W64.t;
    var aux_2: W8.t Array128.t;
    var aux_3: W256.t Array4.t;
    
    
    
    leakages <- LeakCond(((W64.of_int 128) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 128) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0, aux) <@ __store_xor_h_avx2 (output, input, len, k1);
      output <- aux_1;
      input <- aux_0;
      len <- aux;
      leakages <- LeakAddr([]) :: leakages;
      aux_3 <- copy_256 k2;
      k1 <- aux_3;
    } else {
      
    }
    leakages <- LeakAddr([]) :: leakages;
    __store_xor_last_h_avx2 (output, input, len, k1);
    return ();
  }
  
  proc __store_h_avx2 (output:W64.t, len:W64.t, k:W256.t Array4.t) : 
  W64.t * W64.t = {
    var aux: int;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * i))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (aux_0);
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    (aux_2, aux_1) <@ __update_ptr_ref (output, len, 128);
    output <- aux_2;
    len <- aux_1;
    return (output, len);
  }
  
  proc __store_last_h_avx2 (output:W64.t, len:W64.t, k:W256.t Array4.t) : unit = {
    var aux: int;
    var aux_4: W8.t;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_3: W128.t;
    var aux_0: W256.t;
    
    var i:int;
    var r0:W128.t;
    var r1:W64.t;
    var r2:W8.t;
    
    leakages <- LeakCond(((W64.of_int 64) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 64) \ule len)) {
      leakages <- LeakFor(0,2) :: LeakAddr([]) :: leakages;
      i <- 0;
      while (i < 2) {
        leakages <- LeakAddr([i]) :: leakages;
        aux_0 <- k.[i];
        leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * i))))]) :: leakages;
        Glob.mem <-
        storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (aux_0);
        i <- i + 1;
      }
      leakages <- LeakAddr([]) :: leakages;
      (aux_2, aux_1) <@ __update_ptr_ref (output, len, 64);
      output <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([2]) :: leakages;
      aux_0 <- k.[2];
      leakages <- LeakAddr([0]) :: leakages;
      k.[0] <- aux_0;
      leakages <- LeakAddr([3]) :: leakages;
      aux_0 <- k.[3];
      leakages <- LeakAddr([1]) :: leakages;
      k.[1] <- aux_0;
    } else {
      
    }
    leakages <- LeakCond(((W64.of_int 32) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 32) \ule len)) {
      leakages <- LeakAddr([0]) :: leakages;
      aux_0 <- k.[0];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_0);
      leakages <- LeakAddr([]) :: leakages;
      (aux_2, aux_1) <@ __update_ptr_ref (output, len, 32);
      output <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([1]) :: leakages;
      aux_0 <- k.[1];
      leakages <- LeakAddr([0]) :: leakages;
      k.[0] <- aux_0;
    } else {
      
    }
    leakages <- LeakAddr([0]) :: leakages;
    aux_0 <- k.[0];
    r0 <- (truncateu128 aux_0);
    leakages <- LeakCond(((W64.of_int 16) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 16) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_3 <- r0;
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW128 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_3);
      leakages <- LeakAddr([]) :: leakages;
      (aux_2, aux_1) <@ __update_ptr_ref (output, len, 16);
      output <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([0]) :: leakages;
      aux_3 <- VEXTRACTI128 k.[0] (W8.of_int 1);
      r0 <- aux_3;
    } else {
      
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_2 <- VPEXTR_64 r0 (W8.of_int 0);
    r1 <- aux_2;
    leakages <- LeakCond(((W64.of_int 8) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 8) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_2 <- r1;
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW64 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_2);
      leakages <- LeakAddr([]) :: leakages;
      (aux_2, aux_1) <@ __update_ptr_ref (output, len, 8);
      output <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_2 <- VPEXTR_64 r0 (W8.of_int 1);
      r1 <- aux_2;
    } else {
      
    }
    
    leakages <- LeakCond(((W64.of_int 0) \ult len)) :: LeakAddr([]) :: leakages;
    
    while (((W64.of_int 0) \ult len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_2 <- r1;
      r2 <- (truncateu8 aux_2);
      leakages <- LeakAddr([]) :: leakages;
      aux_4 <- r2;
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int 0)))]) :: leakages;
      Glob.mem <-
      storeW8 Glob.mem (W64.to_uint (output + (W64.of_int 0))) (aux_4);
      leakages <- LeakAddr([]) :: leakages;
      aux_2 <- (r1 `>>` (W8.of_int 8));
      r1 <- aux_2;
      leakages <- LeakAddr([]) :: leakages;
      (aux_2, aux_1) <@ __update_ptr_ref (output, len, 1);
      output <- aux_2;
      len <- aux_1;
    leakages <- LeakCond(((W64.of_int 0) \ult len)) :: LeakAddr([]) :: leakages;
    
    }
    return ();
  }
  
  proc __store_h_x2_avx2 (output:W64.t, len:W64.t, k1:W256.t Array4.t,
                          k2:W256.t Array4.t) : W64.t * W64.t = {
    var aux: int;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k1.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * i))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * i)))) (aux_0);
      i <- i + 1;
    }
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k2.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (32 * (i + 4)))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (32 * (i + 4))))) (aux_0);
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    (aux_2, aux_1) <@ __update_ptr_ref (output, len, 256);
    output <- aux_2;
    len <- aux_1;
    return (output, len);
  }
  
  proc __store_last_h_x2_avx2 (output:W64.t, len:W64.t, k1:W256.t Array4.t,
                               k2:W256.t Array4.t) : unit = {
    var aux_0: W64.t;
    var aux: W64.t;
    var aux_1: W8.t Array128.t;
    var aux_2: W256.t Array4.t;
    
    
    
    leakages <- LeakCond(((W64.of_int 128) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 128) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_0, aux) <@ __store_h_avx2 (output, len, k1);
      output <- aux_0;
      len <- aux;
      leakages <- LeakAddr([]) :: leakages;
      aux_2 <- copy_256 k2;
      k1 <- aux_2;
    } else {
      
    }
    leakages <- LeakAddr([]) :: leakages;
    __store_last_h_avx2 (output, len, k1);
    return ();
  }
  
  proc __copy_state_h_avx2 (st:W256.t Array4.t) : W256.t Array4.t = {
    var aux: W8.t Array128.t;
    var aux_0: W256.t Array4.t;
    
    var k:W256.t Array4.t;
    k <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- copy_256 st;
    k <- aux_0;
    return (k);
  }
  
  proc __rotate_h_avx2 (k:W256.t Array4.t, i:int, r:int, r16:W256.t,
                        r8:W256.t) : W256.t Array4.t = {
    var aux: W256.t;
    
    var t:W256.t;
    
    leakages <- LeakCond((r = 16)) :: LeakAddr([]) :: leakages;
    if ((r = 16)) {
      leakages <- LeakAddr([i]) :: leakages;
      aux <- VPSHUFB_256 k.[i] r16;
      leakages <- LeakAddr([i]) :: leakages;
      k.[i] <- aux;
    } else {
      leakages <- LeakCond((r = 8)) :: LeakAddr([]) :: leakages;
      if ((r = 8)) {
        leakages <- LeakAddr([i]) :: leakages;
        aux <- VPSHUFB_256 k.[i] r8;
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux;
      } else {
        leakages <- LeakAddr([i]) :: leakages;
        aux <- (k.[i] \vshl32u256 (W8.of_int r));
        t <- aux;
        leakages <- LeakAddr([i]) :: leakages;
        aux <- (k.[i] \vshr32u256 (W8.of_int (32 - r)));
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux;
        leakages <- LeakAddr([i]) :: leakages;
        aux <- (k.[i] `^` t);
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux;
      }
    }
    return (k);
  }
  
  proc __line_h_avx2 (k:W256.t Array4.t, a:int, b:int, c:int, r:int,
                      r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    var aux: W256.t;
    var aux_0: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([b; a]) :: leakages;
    aux <- (k.[a] \vadd32u256 k.[b]);
    leakages <- LeakAddr([a]) :: leakages;
    k.[a] <- aux;
    leakages <- LeakAddr([a; c]) :: leakages;
    aux <- (k.[c] `^` k.[a]);
    leakages <- LeakAddr([c]) :: leakages;
    k.[c] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k, c, r, r16, r8);
    k <- aux_0;
    return (k);
  }
  
  proc __round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __line_h_avx2 (k, 0, 1, 3, 16, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __line_h_avx2 (k, 2, 3, 1, 12, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __line_h_avx2 (k, 0, 1, 3, 8, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __line_h_avx2 (k, 2, 3, 1, 7, r16, r8);
    k <- aux;
    return (k);
  }
  
  proc __shuffle_state_h_avx2 (k:W256.t Array4.t) : W256.t Array4.t = {
    var aux: W256.t;
    
    
    
    leakages <- LeakAddr([1]) :: leakages;
    aux <- VPSHUFD_256 k.[1]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    leakages <- LeakAddr([1]) :: leakages;
    k.[1] <- aux;
    leakages <- LeakAddr([2]) :: leakages;
    aux <- VPSHUFD_256 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    leakages <- LeakAddr([2]) :: leakages;
    k.[2] <- aux;
    leakages <- LeakAddr([3]) :: leakages;
    aux <- VPSHUFD_256 k.[3]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    leakages <- LeakAddr([3]) :: leakages;
    k.[3] <- aux;
    return (k);
  }
  
  proc __reverse_shuffle_state_h_avx2 (k:W256.t Array4.t) : W256.t Array4.t = {
    var aux: W256.t;
    
    
    
    leakages <- LeakAddr([1]) :: leakages;
    aux <- VPSHUFD_256 k.[1]
    (W8.of_int (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * (1 %% 2^2 + 2^2 * 2))));
    leakages <- LeakAddr([1]) :: leakages;
    k.[1] <- aux;
    leakages <- LeakAddr([2]) :: leakages;
    aux <- VPSHUFD_256 k.[2]
    (W8.of_int (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * (0 %% 2^2 + 2^2 * 1))));
    leakages <- LeakAddr([2]) :: leakages;
    k.[2] <- aux;
    leakages <- LeakAddr([3]) :: leakages;
    aux <- VPSHUFD_256 k.[3]
    (W8.of_int (1 %% 2^2 + 2^2 * (2 %% 2^2 + 2^2 * (3 %% 2^2 + 2^2 * 0))));
    leakages <- LeakAddr([3]) :: leakages;
    k.[3] <- aux;
    return (k);
  }
  
  proc __column_round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __round_h_avx2 (k, r16, r8);
    k <- aux;
    return (k);
  }
  
  proc __diagonal_round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __shuffle_state_h_avx2 (k);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __round_h_avx2 (k, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __reverse_shuffle_state_h_avx2 (k);
    k <- aux;
    return (k);
  }
  
  proc __double_round_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : 
  W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __column_round_h_avx2 (k, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __diagonal_round_h_avx2 (k, r16, r8);
    k <- aux;
    return (k);
  }
  
  proc __rounds_h_avx2 (k:W256.t Array4.t, r16:W256.t, r8:W256.t) : W256.t Array4.t = {
    var aux_4: bool;
    var aux_3: bool;
    var aux_2: bool;
    var aux_1: bool;
    var aux: W32.t;
    var aux_0: W256.t Array4.t;
    
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    leakages <- LeakAddr([]) :: leakages;
    aux <- (W32.of_int (20 %/ 2));
    c <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __double_round_h_avx2 (k, r16, r8);
    k <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    (aux_4, aux_3, aux_2, aux_1, aux) <- DEC_32 c;
     _0 <- aux_4;
     _1 <- aux_3;
     _2 <- aux_2;
     _3 <- aux_1;
    c <- aux;
    leakages <- LeakCond(((W32.of_int 0) \ult c)) :: LeakAddr([]) :: leakages;
    
    while (((W32.of_int 0) \ult c)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __double_round_h_avx2 (k, r16, r8);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_4, aux_3, aux_2, aux_1, aux) <- DEC_32 c;
       _0 <- aux_4;
       _1 <- aux_3;
       _2 <- aux_2;
       _3 <- aux_1;
      c <- aux;
    leakages <- LeakCond(((W32.of_int 0) \ult c)) :: LeakAddr([]) :: leakages;
    
    }
    return (k);
  }
  
  proc __sum_states_h_avx2 (k:W256.t Array4.t, st:W256.t Array4.t) : 
  W256.t Array4.t = {
    var aux: int;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([i; i]) :: leakages;
      aux_0 <- (k.[i] \vadd32u256 st.[i]);
      leakages <- LeakAddr([i]) :: leakages;
      k.[i] <- aux_0;
      i <- i + 1;
    }
    return (k);
  }
  
  proc __perm_h_avx2 (k:W256.t Array4.t) : W256.t Array4.t = {
    var aux: W256.t;
    
    var p:W256.t Array4.t;
    p <- witness;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- VPERM2I128 k.[0] k.[1] (W8.of_int (0 %% 2^4 + 2^4 * 2));
    leakages <- LeakAddr([0]) :: leakages;
    p.[0] <- aux;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- VPERM2I128 k.[2] k.[3] (W8.of_int (0 %% 2^4 + 2^4 * 2));
    leakages <- LeakAddr([1]) :: leakages;
    p.[1] <- aux;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- VPERM2I128 k.[0] k.[1] (W8.of_int (1 %% 2^4 + 2^4 * 3));
    leakages <- LeakAddr([2]) :: leakages;
    p.[2] <- aux;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- VPERM2I128 k.[2] k.[3] (W8.of_int (1 %% 2^4 + 2^4 * 3));
    leakages <- LeakAddr([3]) :: leakages;
    p.[3] <- aux;
    return (p);
  }
  
  proc __copy_state_h_x2_avx2 (st:W256.t Array4.t) : W256.t Array4.t *
                                                     W256.t Array4.t = {
    var aux: W8.t Array128.t;
    var aux_0: W256.t Array4.t;
    
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- copy_256 st;
    k1 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- copy_256 st;
    k2 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __increment_counter0202_h_avx2 (k2);
    k2 <- aux_0;
    return (k1, k2);
  }
  
  proc __round_h_x2_inline_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                 r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    var aux: W256.t;
    var aux_0: W256.t Array4.t;
    
    var t1:W256.t;
    
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- (k1.[0] \vadd32u256 k1.[1]);
    leakages <- LeakAddr([0]) :: leakages;
    k1.[0] <- aux;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- (k2.[0] \vadd32u256 k2.[1]);
    leakages <- LeakAddr([0]) :: leakages;
    k2.[0] <- aux;
    leakages <- LeakAddr([0; 3]) :: leakages;
    aux <- (k1.[3] `^` k1.[0]);
    leakages <- LeakAddr([3]) :: leakages;
    k1.[3] <- aux;
    leakages <- LeakAddr([0; 3]) :: leakages;
    aux <- (k2.[3] `^` k2.[0]);
    leakages <- LeakAddr([3]) :: leakages;
    k2.[3] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k1, 3, 16, r16, r8);
    k1 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k2, 3, 16, r16, r8);
    k2 <- aux_0;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- (k1.[2] \vadd32u256 k1.[3]);
    leakages <- LeakAddr([2]) :: leakages;
    k1.[2] <- aux;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- (k2.[2] \vadd32u256 k2.[3]);
    leakages <- LeakAddr([2]) :: leakages;
    k2.[2] <- aux;
    leakages <- LeakAddr([2; 1]) :: leakages;
    aux <- (k1.[1] `^` k1.[2]);
    leakages <- LeakAddr([1]) :: leakages;
    k1.[1] <- aux;
    leakages <- LeakAddr([1]) :: leakages;
    aux <- (k1.[1] \vshl32u256 (W8.of_int 12));
    t1 <- aux;
    leakages <- LeakAddr([1]) :: leakages;
    aux <- (k1.[1] \vshr32u256 (W8.of_int 20));
    leakages <- LeakAddr([1]) :: leakages;
    k1.[1] <- aux;
    leakages <- LeakAddr([2; 1]) :: leakages;
    aux <- (k2.[1] `^` k2.[2]);
    leakages <- LeakAddr([1]) :: leakages;
    k2.[1] <- aux;
    leakages <- LeakAddr([1]) :: leakages;
    aux <- (k1.[1] `^` t1);
    leakages <- LeakAddr([1]) :: leakages;
    k1.[1] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k2, 1, 12, r16, r8);
    k2 <- aux_0;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- (k1.[0] \vadd32u256 k1.[1]);
    leakages <- LeakAddr([0]) :: leakages;
    k1.[0] <- aux;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- (k2.[0] \vadd32u256 k2.[1]);
    leakages <- LeakAddr([0]) :: leakages;
    k2.[0] <- aux;
    leakages <- LeakAddr([0; 3]) :: leakages;
    aux <- (k1.[3] `^` k1.[0]);
    leakages <- LeakAddr([3]) :: leakages;
    k1.[3] <- aux;
    leakages <- LeakAddr([0; 3]) :: leakages;
    aux <- (k2.[3] `^` k2.[0]);
    leakages <- LeakAddr([3]) :: leakages;
    k2.[3] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k1, 3, 8, r16, r8);
    k1 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k2, 3, 8, r16, r8);
    k2 <- aux_0;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- (k1.[2] \vadd32u256 k1.[3]);
    leakages <- LeakAddr([2]) :: leakages;
    k1.[2] <- aux;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- (k2.[2] \vadd32u256 k2.[3]);
    leakages <- LeakAddr([2]) :: leakages;
    k2.[2] <- aux;
    leakages <- LeakAddr([2; 1]) :: leakages;
    aux <- (k1.[1] `^` k1.[2]);
    leakages <- LeakAddr([1]) :: leakages;
    k1.[1] <- aux;
    leakages <- LeakAddr([1]) :: leakages;
    aux <- (k1.[1] \vshl32u256 (W8.of_int 7));
    t1 <- aux;
    leakages <- LeakAddr([1]) :: leakages;
    aux <- (k1.[1] \vshr32u256 (W8.of_int 25));
    leakages <- LeakAddr([1]) :: leakages;
    k1.[1] <- aux;
    leakages <- LeakAddr([2; 1]) :: leakages;
    aux <- (k2.[1] `^` k2.[2]);
    leakages <- LeakAddr([1]) :: leakages;
    k2.[1] <- aux;
    leakages <- LeakAddr([1]) :: leakages;
    aux <- (k1.[1] `^` t1);
    leakages <- LeakAddr([1]) :: leakages;
    k1.[1] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_h_avx2 (k2, 1, 7, r16, r8);
    k2 <- aux_0;
    return (k1, k2);
  }
  
  proc __shuffle_state_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t) : 
  W256.t Array4.t * W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __shuffle_state_h_avx2 (k1);
    k1 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __shuffle_state_h_avx2 (k2);
    k2 <- aux;
    return (k1, k2);
  }
  
  proc __reverse_shuffle_state_h_x2_avx2 (k1:W256.t Array4.t,
                                          k2:W256.t Array4.t) : W256.t Array4.t *
                                                                W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __reverse_shuffle_state_h_avx2 (k1);
    k1 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __reverse_shuffle_state_h_avx2 (k2);
    k2 <- aux;
    return (k1, k2);
  }
  
  proc __column_round_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                 r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    var aux_0: W256.t Array4.t;
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __round_h_x2_inline_avx2 (k1, k2, r16, r8);
    k1 <- aux_0;
    k2 <- aux;
    return (k1, k2);
  }
  
  proc __diagonal_round_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                   r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                            W256.t Array4.t = {
    var aux_0: W256.t Array4.t;
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __shuffle_state_h_x2_avx2 (k1, k2);
    k1 <- aux_0;
    k2 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __round_h_x2_inline_avx2 (k1, k2, r16, r8);
    k1 <- aux_0;
    k2 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __reverse_shuffle_state_h_x2_avx2 (k1, k2);
    k1 <- aux_0;
    k2 <- aux;
    return (k1, k2);
  }
  
  proc __double_round_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                                 r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                          W256.t Array4.t = {
    var aux_0: W256.t Array4.t;
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __column_round_h_x2_avx2 (k1, k2, r16, r8);
    k1 <- aux_0;
    k2 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __diagonal_round_h_x2_avx2 (k1, k2, r16, r8);
    k1 <- aux_0;
    k2 <- aux;
    return (k1, k2);
  }
  
  proc __rounds_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                           r16:W256.t, r8:W256.t) : W256.t Array4.t *
                                                    W256.t Array4.t = {
    var aux_5: bool;
    var aux_4: bool;
    var aux_3: bool;
    var aux_2: bool;
    var aux: W32.t;
    var aux_1: W256.t Array4.t;
    var aux_0: W256.t Array4.t;
    
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    leakages <- LeakAddr([]) :: leakages;
    aux <- (W32.of_int (20 %/ 2));
    c <- aux;
    leakages <- LeakAddr([]) :: leakages;
    (aux_1, aux_0) <@ __double_round_h_x2_avx2 (k1, k2, r16, r8);
    k1 <- aux_1;
    k2 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    (aux_5, aux_4, aux_3, aux_2, aux) <- DEC_32 c;
     _0 <- aux_5;
     _1 <- aux_4;
     _2 <- aux_3;
     _3 <- aux_2;
    c <- aux;
    leakages <- LeakCond(((W32.of_int 0) \ult c)) :: LeakAddr([]) :: leakages;
    
    while (((W32.of_int 0) \ult c)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __double_round_h_x2_avx2 (k1, k2, r16, r8);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_5, aux_4, aux_3, aux_2, aux) <- DEC_32 c;
       _0 <- aux_5;
       _1 <- aux_4;
       _2 <- aux_3;
       _3 <- aux_2;
      c <- aux;
    leakages <- LeakCond(((W32.of_int 0) \ult c)) :: LeakAddr([]) :: leakages;
    
    }
    return (k1, k2);
  }
  
  proc __sum_states_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t,
                               st:W256.t Array4.t) : W256.t Array4.t *
                                                     W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __sum_states_h_avx2 (k1, st);
    k1 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __sum_states_h_avx2 (k2, st);
    k2 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __increment_counter0202_h_avx2 (k2);
    k2 <- aux;
    return (k1, k2);
  }
  
  proc __perm_h_x2_avx2 (k1:W256.t Array4.t, k2:W256.t Array4.t) : W256.t Array4.t *
                                                                   W256.t Array4.t = {
    var aux: W256.t Array4.t;
    
    var p1:W256.t Array4.t;
    var p2:W256.t Array4.t;
    p1 <- witness;
    p2 <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __perm_h_avx2 (k1);
    p1 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __perm_h_avx2 (k2);
    p2 <- aux;
    return (p1, p2);
  }
  
  proc __chacha_xor_h_x2_avx2 (output:W64.t, input:W64.t, len:W64.t,
                               nonce:W64.t, key:W64.t) : unit = {
    var aux_4: W64.t;
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux: W256.t;
    var aux_1: W256.t Array4.t;
    var aux_0: W256.t Array4.t;
    
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array4.t;
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R16_AVX2;
    r16 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R8_AVX2;
    r8 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_1 <@ __init_h_avx2 (nonce, key);
    st <- aux_1;
    
    leakages <- LeakCond(((W64.of_int 256) \ule len)) :: LeakAddr([]) :: leakages;
    
    while (((W64.of_int 256) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __copy_state_h_x2_avx2 (st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __perm_h_x2_avx2 (k1, k2);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_4, aux_3, aux_2) <@ __store_xor_h_x2_avx2 (output, input, len, k1,
      k2);
      output <- aux_4;
      input <- aux_3;
      len <- aux_2;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __increment_counter0404_h_avx2 (st);
      st <- aux_1;
    leakages <- LeakCond(((W64.of_int 256) \ule len)) :: LeakAddr([]) :: leakages;
    
    }
    leakages <- LeakCond(((W64.of_int 128) \ult len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 128) \ult len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __copy_state_h_x2_avx2 (st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __perm_h_x2_avx2 (k1, k2);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_4, aux_3, aux_2) <@ __store_xor_h_avx2 (output, input, len, k1);
      output <- aux_4;
      input <- aux_3;
      len <- aux_2;
      leakages <- LeakAddr([]) :: leakages;
      __store_xor_last_h_avx2 (output, input, len, k2);
    } else {
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __copy_state_h_avx2 (st);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __rounds_h_avx2 (k1, r16, r8);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __sum_states_h_avx2 (k1, st);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __perm_h_avx2 (k1);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      __store_xor_last_h_avx2 (output, input, len, k1);
    }
    return ();
  }
  
  proc __chacha_h_x2_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux: W256.t;
    var aux_1: W256.t Array4.t;
    var aux_0: W256.t Array4.t;
    
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array4.t;
    var k1:W256.t Array4.t;
    var k2:W256.t Array4.t;
    k1 <- witness;
    k2 <- witness;
    st <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R16_AVX2;
    r16 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R8_AVX2;
    r8 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_1 <@ __init_h_avx2 (nonce, key);
    st <- aux_1;
    
    leakages <- LeakCond(((W64.of_int 256) \ule len)) :: LeakAddr([]) :: leakages;
    
    while (((W64.of_int 256) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __copy_state_h_x2_avx2 (st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __perm_h_x2_avx2 (k1, k2);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2) <@ __store_h_x2_avx2 (output, len, k1, k2);
      output <- aux_3;
      len <- aux_2;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __increment_counter0404_h_avx2 (st);
      st <- aux_1;
    leakages <- LeakCond(((W64.of_int 256) \ule len)) :: LeakAddr([]) :: leakages;
    
    }
    leakages <- LeakCond(((W64.of_int 128) \ult len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 128) \ult len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __copy_state_h_x2_avx2 (st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __rounds_h_x2_avx2 (k1, k2, r16, r8);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __sum_states_h_x2_avx2 (k1, k2, st);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux_0) <@ __perm_h_x2_avx2 (k1, k2);
      k1 <- aux_1;
      k2 <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2) <@ __store_h_avx2 (output, len, k1);
      output <- aux_3;
      len <- aux_2;
      leakages <- LeakAddr([]) :: leakages;
      __store_last_h_avx2 (output, len, k2);
    } else {
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __copy_state_h_avx2 (st);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __rounds_h_avx2 (k1, r16, r8);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __sum_states_h_avx2 (k1, st);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_1 <@ __perm_h_avx2 (k1);
      k1 <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      __store_last_h_avx2 (output, len, k1);
    }
    return ();
  }
  
  proc __init_v_avx2 (nonce:W64.t, key:W64.t) : W256.t Array16.t = {
    var aux: int;
    var aux_0: W256.t;
    var aux_1: W8.t Array512.t;
    var aux_2: W256.t Array16.t;
    
    var _st:W256.t Array16.t;
    var i:int;
    var st:W256.t Array16.t;
    _st <- witness;
    st <- witness;
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- CHACHA_SIGMA_V_AVX2.[i];
      leakages <- LeakAddr([i]) :: leakages;
      st.[i] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakFor(0,8) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 8) {
      leakages <- LeakAddr([(W64.to_uint (key + (W64.of_int (4 * i))))]) :: leakages;
      aux_0 <- VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (key + (W64.of_int (4 * i)))));
      leakages <- LeakAddr([(4 + i)]) :: leakages;
      st.[(4 + i)] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- CHACHA_P76543210_V_AVX;
    leakages <- LeakAddr([12]) :: leakages;
    st.[12] <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- set0_256 ;
    leakages <- LeakAddr([13]) :: leakages;
    st.[13] <- aux_0;
    leakages <- LeakFor(0,2) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 2) {
      leakages <- LeakAddr([(W64.to_uint (nonce + (W64.of_int (4 * i))))]) :: leakages;
      aux_0 <- VPBROADCAST_8u32 (loadW32 Glob.mem (W64.to_uint (nonce + (W64.of_int (4 * i)))));
      leakages <- LeakAddr([(14 + i)]) :: leakages;
      st.[(14 + i)] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_2 <- copy_256 st;
    _st <- aux_2;
    return (_st);
  }
  
  proc __increment_counter_v_avx2 (st:W256.t Array16.t) : W256.t Array16.t = {
    var aux: W256.t;
    
    var x:W256.t;
    var y:W256.t;
    var a:W256.t;
    var b:W256.t;
    
    leakages <- LeakAddr([12]) :: leakages;
    aux <- st.[12];
    x <- aux;
    leakages <- LeakAddr([13]) :: leakages;
    aux <- st.[13];
    y <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- VPUNPCKL_8u32 x y;
    a <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- VPUNPCKH_8u32 x y;
    b <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- (a \vadd64u256 CHACHA_P8888_V_AVX2);
    a <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- (b \vadd64u256 CHACHA_P8888_V_AVX2);
    b <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- VPUNPCKL_8u32 a b;
    x <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- VPUNPCKH_8u32 a b;
    y <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- VPUNPCKL_8u32 x y;
    a <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- VPUNPCKH_8u32 x y;
    b <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- a;
    leakages <- LeakAddr([12]) :: leakages;
    st.[12] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- b;
    leakages <- LeakAddr([13]) :: leakages;
    st.[13] <- aux;
    return (st);
  }
  
  proc __sub_rotate_avx2 (t:W256.t Array8.t) : W256.t Array8.t = {
    var aux_0: int;
    var aux: W256.t;
    
    var x:W256.t Array8.t;
    var i:int;
    x <- witness;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- VPUNPCKL_4u64 t.[0] t.[1];
    leakages <- LeakAddr([0]) :: leakages;
    x.[0] <- aux;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- VPUNPCKL_4u64 t.[2] t.[3];
    leakages <- LeakAddr([1]) :: leakages;
    x.[1] <- aux;
    leakages <- LeakAddr([1; 0]) :: leakages;
    aux <- VPUNPCKH_4u64 t.[0] t.[1];
    leakages <- LeakAddr([2]) :: leakages;
    x.[2] <- aux;
    leakages <- LeakAddr([3; 2]) :: leakages;
    aux <- VPUNPCKH_4u64 t.[2] t.[3];
    leakages <- LeakAddr([3]) :: leakages;
    x.[3] <- aux;
    leakages <- LeakAddr([5; 4]) :: leakages;
    aux <- VPUNPCKL_4u64 t.[4] t.[5];
    leakages <- LeakAddr([4]) :: leakages;
    x.[4] <- aux;
    leakages <- LeakAddr([7; 6]) :: leakages;
    aux <- VPUNPCKL_4u64 t.[6] t.[7];
    leakages <- LeakAddr([5]) :: leakages;
    x.[5] <- aux;
    leakages <- LeakAddr([5; 4]) :: leakages;
    aux <- VPUNPCKH_4u64 t.[4] t.[5];
    leakages <- LeakAddr([6]) :: leakages;
    x.[6] <- aux;
    leakages <- LeakAddr([7; 6]) :: leakages;
    aux <- VPUNPCKH_4u64 t.[6] t.[7];
    leakages <- LeakAddr([7]) :: leakages;
    x.[7] <- aux;
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([((2 * i) + 1); ((2 * i) + 0)]) :: leakages;
      aux <- VPERM2I128 x.[((2 * i) + 0)] x.[((2 * i) + 1)]
      (W8.of_int (0 %% 2^4 + 2^4 * 2));
      leakages <- LeakAddr([i]) :: leakages;
      t.[i] <- aux;
      leakages <- LeakAddr([((2 * i) + 1); ((2 * i) + 0)]) :: leakages;
      aux <- VPERM2I128 x.[((2 * i) + 0)] x.[((2 * i) + 1)]
      (W8.of_int (1 %% 2^4 + 2^4 * 3));
      leakages <- LeakAddr([(i + 4)]) :: leakages;
      t.[(i + 4)] <- aux;
      i <- i + 1;
    }
    return (t);
  }
  
  proc __rotate_avx2 (x:W256.t Array8.t) : W256.t Array8.t = {
    var aux: int;
    var aux_0: W256.t;
    var aux_1: W256.t Array8.t;
    
    var t:W256.t Array8.t;
    var i:int;
    t <- witness;
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([((2 * i) + 1); ((2 * i) + 0)]) :: leakages;
      aux_0 <- VPUNPCKL_8u32 x.[((2 * i) + 0)] x.[((2 * i) + 1)];
      leakages <- LeakAddr([i]) :: leakages;
      t.[i] <- aux_0;
      leakages <- LeakAddr([((2 * i) + 1); ((2 * i) + 0)]) :: leakages;
      aux_0 <- VPUNPCKH_8u32 x.[((2 * i) + 0)] x.[((2 * i) + 1)];
      leakages <- LeakAddr([(i + 4)]) :: leakages;
      t.[(i + 4)] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_1 <@ __sub_rotate_avx2 (t);
    t <- aux_1;
    return (t);
  }
  
  proc __rotate_stack_avx2 (s:W256.t Array8.t) : W256.t Array8.t = {
    var aux: int;
    var aux_0: W256.t;
    var aux_1: W256.t Array8.t;
    
    var t:W256.t Array8.t;
    var i:int;
    var x:W256.t Array8.t;
    t <- witness;
    x <- witness;
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([((2 * i) + 0)]) :: leakages;
      aux_0 <- s.[((2 * i) + 0)];
      leakages <- LeakAddr([i]) :: leakages;
      x.[i] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakFor(0,4) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 4) {
      leakages <- LeakAddr([((2 * i) + 1); i]) :: leakages;
      aux_0 <- VPUNPCKL_8u32 x.[i] s.[((2 * i) + 1)];
      leakages <- LeakAddr([i]) :: leakages;
      t.[i] <- aux_0;
      leakages <- LeakAddr([((2 * i) + 1); i]) :: leakages;
      aux_0 <- VPUNPCKH_8u32 x.[i] s.[((2 * i) + 1)];
      leakages <- LeakAddr([(4 + i)]) :: leakages;
      t.[(4 + i)] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_1 <@ __sub_rotate_avx2 (t);
    t <- aux_1;
    return (t);
  }
  
  proc __rotate_first_half_v_avx2 (k:W256.t Array16.t) : W256.t Array8.t *
                                                         W256.t Array8.t = {
    var aux: int;
    var aux_0: W256.t;
    var aux_1: W256.t Array8.t;
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var i:int;
    k0_7 <- witness;
    s_k8_15 <- witness;
    leakages <- LeakFor(0,8) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 8) {
      leakages <- LeakAddr([(8 + i)]) :: leakages;
      aux_0 <- k.[(8 + i)];
      leakages <- LeakAddr([i]) :: leakages;
      s_k8_15.[i] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakFor(0,8) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 8) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k.[i];
      leakages <- LeakAddr([i]) :: leakages;
      k0_7.[i] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakAddr([]) :: leakages;
    aux_1 <@ __rotate_avx2 (k0_7);
    k0_7 <- aux_1;
    return (k0_7, s_k8_15);
  }
  
  proc __rotate_second_half_v_avx2 (s_k8_15:W256.t Array8.t) : W256.t Array8.t = {
    var aux: W256.t Array8.t;
    
    var k8_15:W256.t Array8.t;
    k8_15 <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __rotate_stack_avx2 (s_k8_15);
    k8_15 <- aux;
    return (k8_15);
  }
  
  proc __interleave_avx2 (s:W256.t Array8.t, k:W256.t Array8.t, o:int) : 
  W256.t Array4.t * W256.t Array4.t = {
    var aux: W256.t;
    
    var sk1:W256.t Array4.t;
    var sk2:W256.t Array4.t;
    sk1 <- witness;
    sk2 <- witness;
    leakages <- LeakAddr([(o + 0)]) :: leakages;
    aux <- s.[(o + 0)];
    leakages <- LeakAddr([0]) :: leakages;
    sk1.[0] <- aux;
    leakages <- LeakAddr([(o + 0)]) :: leakages;
    aux <- k.[(o + 0)];
    leakages <- LeakAddr([1]) :: leakages;
    sk1.[1] <- aux;
    leakages <- LeakAddr([(o + 1)]) :: leakages;
    aux <- s.[(o + 1)];
    leakages <- LeakAddr([2]) :: leakages;
    sk1.[2] <- aux;
    leakages <- LeakAddr([(o + 1)]) :: leakages;
    aux <- k.[(o + 1)];
    leakages <- LeakAddr([3]) :: leakages;
    sk1.[3] <- aux;
    leakages <- LeakAddr([(o + 2)]) :: leakages;
    aux <- s.[(o + 2)];
    leakages <- LeakAddr([0]) :: leakages;
    sk2.[0] <- aux;
    leakages <- LeakAddr([(o + 2)]) :: leakages;
    aux <- k.[(o + 2)];
    leakages <- LeakAddr([1]) :: leakages;
    sk2.[1] <- aux;
    leakages <- LeakAddr([(o + 3)]) :: leakages;
    aux <- s.[(o + 3)];
    leakages <- LeakAddr([2]) :: leakages;
    sk2.[2] <- aux;
    leakages <- LeakAddr([(o + 3)]) :: leakages;
    aux <- k.[(o + 3)];
    leakages <- LeakAddr([3]) :: leakages;
    sk2.[3] <- aux;
    return (sk1, sk2);
  }
  
  proc __store_xor_half_interleave_v_avx2 (output:W64.t, input:W64.t,
                                           len:W64.t, k:W256.t Array8.t,
                                           o:int) : unit = {
    var aux: int;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,8) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 8) {
      leakages <- LeakAddr([(W64.to_uint (input + (W64.of_int (o + (64 * i)))));
                           i]) :: leakages;
      aux_0 <- (k.[i] `^` (loadW256 Glob.mem (W64.to_uint (input + (W64.of_int (o + (64 * i)))))));
      leakages <- LeakAddr([i]) :: leakages;
      k.[i] <- aux_0;
      i <- i + 1;
    }
    leakages <- LeakFor(0,8) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 8) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (o + (64 * i)))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) (aux_0);
      i <- i + 1;
    }
    return ();
  }
  
  proc __store_xor_v_avx2 (output:W64.t, input:W64.t, len:W64.t,
                           k:W256.t Array16.t) : W64.t * W64.t * W64.t = {
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_0: W256.t Array8.t;
    var aux: W256.t Array8.t;
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __rotate_first_half_v_avx2 (k);
    k0_7 <- aux_0;
    s_k8_15 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    __store_xor_half_interleave_v_avx2 (output, input, len, k0_7, 0);
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_second_half_v_avx2 (s_k8_15);
    k8_15 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    __store_xor_half_interleave_v_avx2 (output, input, len, k8_15, 32);
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2, aux_1) <@ __update_ptr_xor_ref (output, input, len, 512);
    output <- aux_3;
    input <- aux_2;
    len <- aux_1;
    return (output, input, len);
  }
  
  proc __store_xor_last_v_avx2 (output:W64.t, input:W64.t, len:W64.t,
                                k:W256.t Array16.t) : unit = {
    var aux_6: W64.t;
    var aux_5: W64.t;
    var aux_4: W64.t;
    var aux_1: W8.t Array256.t;
    var aux_3: W256.t Array4.t;
    var aux_2: W256.t Array4.t;
    var aux_0: W256.t Array8.t;
    var aux: W256.t Array8.t;
    
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
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __rotate_first_half_v_avx2 (k);
    k0_7 <- aux_0;
    s_k8_15 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- copy_256 k0_7;
    s_k0_7 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_second_half_v_avx2 (s_k8_15);
    k8_15 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2) <@ __interleave_avx2 (s_k0_7, k8_15, 0);
    k0_3 <- aux_3;
    k4_7 <- aux_2;
    leakages <- LeakCond(((W64.of_int 256) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 256) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_6, aux_5, aux_4) <@ __store_xor_h_x2_avx2 (output, input, len,
      k0_3, k4_7);
      output <- aux_6;
      input <- aux_5;
      len <- aux_4;
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2) <@ __interleave_avx2 (s_k0_7, k8_15, 4);
      k0_3 <- aux_3;
      k4_7 <- aux_2;
    } else {
      
    }
    leakages <- LeakAddr([]) :: leakages;
    __store_xor_last_h_x2_avx2 (output, input, len, k0_3, k4_7);
    return ();
  }
  
  proc __store_half_interleave_v_avx2 (output:W64.t, len:W64.t,
                                       k:W256.t Array8.t, o:int) : unit = {
    var aux: int;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,8) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 8) {
      leakages <- LeakAddr([i]) :: leakages;
      aux_0 <- k.[i];
      leakages <- LeakAddr([(W64.to_uint (output + (W64.of_int (o + (64 * i)))))]) :: leakages;
      Glob.mem <-
      storeW256 Glob.mem (W64.to_uint (output + (W64.of_int (o + (64 * i))))) (aux_0);
      i <- i + 1;
    }
    return ();
  }
  
  proc __store_v_avx2 (output:W64.t, len:W64.t, k:W256.t Array16.t) : 
  W64.t * W64.t = {
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux_0: W256.t Array8.t;
    var aux: W256.t Array8.t;
    
    var k0_7:W256.t Array8.t;
    var s_k8_15:W256.t Array8.t;
    var k8_15:W256.t Array8.t;
    k0_7 <- witness;
    k8_15 <- witness;
    s_k8_15 <- witness;
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __rotate_first_half_v_avx2 (k);
    k0_7 <- aux_0;
    s_k8_15 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    __store_half_interleave_v_avx2 (output, len, k0_7, 0);
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_second_half_v_avx2 (s_k8_15);
    k8_15 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    __store_half_interleave_v_avx2 (output, len, k8_15, 32);
    leakages <- LeakAddr([]) :: leakages;
    (aux_2, aux_1) <@ __update_ptr_ref (output, len, 512);
    output <- aux_2;
    len <- aux_1;
    return (output, len);
  }
  
  proc __store_last_v_avx2 (output:W64.t, len:W64.t, k:W256.t Array16.t) : unit = {
    var aux_5: W64.t;
    var aux_4: W64.t;
    var aux_1: W8.t Array256.t;
    var aux_3: W256.t Array4.t;
    var aux_2: W256.t Array4.t;
    var aux_0: W256.t Array8.t;
    var aux: W256.t Array8.t;
    
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
    leakages <- LeakAddr([]) :: leakages;
    (aux_0, aux) <@ __rotate_first_half_v_avx2 (k);
    k0_7 <- aux_0;
    s_k8_15 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- copy_256 k0_7;
    s_k0_7 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_second_half_v_avx2 (s_k8_15);
    k8_15 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2) <@ __interleave_avx2 (s_k0_7, k8_15, 0);
    k0_3 <- aux_3;
    k4_7 <- aux_2;
    leakages <- LeakCond(((W64.of_int 256) \ule len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 256) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_5, aux_4) <@ __store_h_x2_avx2 (output, len, k0_3, k4_7);
      output <- aux_5;
      len <- aux_4;
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2) <@ __interleave_avx2 (s_k0_7, k8_15, 4);
      k0_3 <- aux_3;
      k4_7 <- aux_2;
    } else {
      
    }
    leakages <- LeakAddr([]) :: leakages;
    __store_last_h_x2_avx2 (output, len, k0_3, k4_7);
    return ();
  }
  
  proc __copy_state_v_avx2 (st:W256.t Array16.t) : W256.t Array16.t = {
    var aux: W8.t Array512.t;
    var aux_0: W256.t Array16.t;
    
    var k:W256.t Array16.t;
    k <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- copy_256 st;
    k <- aux_0;
    return (k);
  }
  
  proc __rotate_v_avx2 (k:W256.t Array16.t, i:int, r:int, r16:W256.t,
                        r8:W256.t) : W256.t Array16.t = {
    var aux: W256.t;
    
    var t:W256.t;
    
    leakages <- LeakCond((r = 16)) :: LeakAddr([]) :: leakages;
    if ((r = 16)) {
      leakages <- LeakAddr([i]) :: leakages;
      aux <- VPSHUFB_256 k.[i] r16;
      leakages <- LeakAddr([i]) :: leakages;
      k.[i] <- aux;
    } else {
      leakages <- LeakCond((r = 8)) :: LeakAddr([]) :: leakages;
      if ((r = 8)) {
        leakages <- LeakAddr([i]) :: leakages;
        aux <- VPSHUFB_256 k.[i] r8;
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux;
      } else {
        leakages <- LeakAddr([i]) :: leakages;
        aux <- (k.[i] \vshl32u256 (W8.of_int r));
        t <- aux;
        leakages <- LeakAddr([i]) :: leakages;
        aux <- (k.[i] \vshr32u256 (W8.of_int (32 - r)));
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux;
        leakages <- LeakAddr([i]) :: leakages;
        aux <- (k.[i] `^` t);
        leakages <- LeakAddr([i]) :: leakages;
        k.[i] <- aux;
      }
    }
    return (k);
  }
  
  proc __line_v_avx2 (k:W256.t Array16.t, a:int, b:int, c:int, r:int,
                      r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    var aux: W256.t;
    var aux_0: W256.t Array16.t;
    
    
    
    leakages <- LeakAddr([b; a]) :: leakages;
    aux <- (k.[a] \vadd32u256 k.[b]);
    leakages <- LeakAddr([a]) :: leakages;
    k.[a] <- aux;
    leakages <- LeakAddr([a; c]) :: leakages;
    aux <- (k.[c] `^` k.[a]);
    leakages <- LeakAddr([c]) :: leakages;
    k.[c] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_v_avx2 (k, c, r, r16, r8);
    k <- aux_0;
    return (k);
  }
  
  proc __double_line_v_avx2 (k:W256.t Array16.t, a0:int, b0:int, c0:int,
                             r0:int, a1:int, b1:int, c1:int, r1:int,
                             r16:W256.t, r8:W256.t) : W256.t Array16.t = {
    var aux: W256.t;
    var aux_0: W256.t Array16.t;
    
    
    
    leakages <- LeakAddr([b0; a0]) :: leakages;
    aux <- (k.[a0] \vadd32u256 k.[b0]);
    leakages <- LeakAddr([a0]) :: leakages;
    k.[a0] <- aux;
    leakages <- LeakAddr([b1; a1]) :: leakages;
    aux <- (k.[a1] \vadd32u256 k.[b1]);
    leakages <- LeakAddr([a1]) :: leakages;
    k.[a1] <- aux;
    leakages <- LeakAddr([a0; c0]) :: leakages;
    aux <- (k.[c0] `^` k.[a0]);
    leakages <- LeakAddr([c0]) :: leakages;
    k.[c0] <- aux;
    leakages <- LeakAddr([a1; c1]) :: leakages;
    aux <- (k.[c1] `^` k.[a1]);
    leakages <- LeakAddr([c1]) :: leakages;
    k.[c1] <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_v_avx2 (k, c0, r0, r16, r8);
    k <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __rotate_v_avx2 (k, c1, r1, r16, r8);
    k <- aux_0;
    return (k);
  }
  
  proc __double_quarter_round_v_avx2 (k:W256.t Array16.t, a0:int, b0:int,
                                      c0:int, d0:int, a1:int, b1:int, c1:int,
                                      d1:int, r16:W256.t, r8:W256.t) : 
  W256.t Array16.t = {
    var aux: W256.t Array16.t;
    
    
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __line_v_avx2 (k, a0, b0, d0, 16, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_line_v_avx2 (k, c0, d0, b0, 12, a1, b1, d1, 16, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_line_v_avx2 (k, a0, b0, d0, 8, c1, d1, b1, 12, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_line_v_avx2 (k, c0, d0, b0, 7, a1, b1, d1, 8, r16, r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __line_v_avx2 (k, c1, d1, b1, 7, r16, r8);
    k <- aux;
    return (k);
  }
  
  proc __column_round_v_1_avx2 (k:W256.t Array16.t, k15:W256.t, s_r16:W256.t,
                                s_r8:W256.t) : W256.t Array16.t * W256.t = {
    var aux_0: W256.t;
    var aux: W256.t Array16.t;
    
    var k14:W256.t;
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_quarter_round_v_avx2 (k, 0, 4, 8, 12, 2, 6, 10, 14,
    s_r16, s_r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- k15;
    leakages <- LeakAddr([15]) :: leakages;
    k.[15] <- aux_0;
    leakages <- LeakAddr([14]) :: leakages;
    aux_0 <- k.[14];
    k14 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_quarter_round_v_avx2 (k, 1, 5, 9, 13, 3, 7, 11, 15,
    s_r16, s_r8);
    k <- aux;
    return (k, k14);
  }
  
  proc __diagonal_round_v_1_avx2 (k:W256.t Array16.t, k14:W256.t,
                                  s_r16:W256.t, s_r8:W256.t) : W256.t Array16.t *
                                                               W256.t = {
    var aux_0: W256.t;
    var aux: W256.t Array16.t;
    
    var k15:W256.t;
    
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_quarter_round_v_avx2 (k, 1, 6, 11, 12, 0, 5, 10, 15,
    s_r16, s_r8);
    k <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- k14;
    leakages <- LeakAddr([14]) :: leakages;
    k.[14] <- aux_0;
    leakages <- LeakAddr([15]) :: leakages;
    aux_0 <- k.[15];
    k15 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    aux <@ __double_quarter_round_v_avx2 (k, 2, 7, 8, 13, 3, 4, 9, 14, s_r16,
    s_r8);
    k <- aux;
    return (k, k15);
  }
  
  proc __double_round_v_1_avx2 (k:W256.t Array16.t, k15:W256.t, r16:W256.t,
                                r8:W256.t) : W256.t Array16.t * W256.t = {
    var aux_0: W256.t;
    var aux: W256.t Array16.t;
    
    var k14:W256.t;
    
    leakages <- LeakAddr([]) :: leakages;
    (aux, aux_0) <@ __column_round_v_1_avx2 (k, k15, r16, r8);
    k <- aux;
    k14 <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    (aux, aux_0) <@ __diagonal_round_v_1_avx2 (k, k14, r16, r8);
    k <- aux;
    k15 <- aux_0;
    return (k, k15);
  }
  
  proc __rounds_v_avx2 (k:W256.t Array16.t, r16:W256.t, r8:W256.t) : 
  W256.t Array16.t = {
    var aux_5: bool;
    var aux_4: bool;
    var aux_3: bool;
    var aux_2: bool;
    var aux_0: W32.t;
    var aux: W256.t;
    var aux_1: W256.t Array16.t;
    
    var k15:W256.t;
    var c:W32.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    
    leakages <- LeakAddr([15]) :: leakages;
    aux <- k.[15];
    k15 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <- (W32.of_int (20 %/ 2));
    c <- aux_0;
    leakages <- LeakAddr([]) :: leakages;
    (aux_1, aux) <@ __double_round_v_1_avx2 (k, k15, r16, r8);
    k <- aux_1;
    k15 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    (aux_5, aux_4, aux_3, aux_2, aux_0) <- DEC_32 c;
     _0 <- aux_5;
     _1 <- aux_4;
     _2 <- aux_3;
     _3 <- aux_2;
    c <- aux_0;
    leakages <- LeakCond(((W32.of_int 0) \ult c)) :: LeakAddr([]) :: leakages;
    
    while (((W32.of_int 0) \ult c)) {
      leakages <- LeakAddr([]) :: leakages;
      (aux_1, aux) <@ __double_round_v_1_avx2 (k, k15, r16, r8);
      k <- aux_1;
      k15 <- aux;
      leakages <- LeakAddr([]) :: leakages;
      (aux_5, aux_4, aux_3, aux_2, aux_0) <- DEC_32 c;
       _0 <- aux_5;
       _1 <- aux_4;
       _2 <- aux_3;
       _3 <- aux_2;
      c <- aux_0;
    leakages <- LeakCond(((W32.of_int 0) \ult c)) :: LeakAddr([]) :: leakages;
    
    }
    leakages <- LeakAddr([]) :: leakages;
    aux <- k15;
    leakages <- LeakAddr([15]) :: leakages;
    k.[15] <- aux;
    return (k);
  }
  
  proc __sum_states_v_avx2 (k:W256.t Array16.t, st:W256.t Array16.t) : 
  W256.t Array16.t = {
    var aux: int;
    var aux_0: W256.t;
    
    var i:int;
    
    leakages <- LeakFor(0,16) :: LeakAddr([]) :: leakages;
    i <- 0;
    while (i < 16) {
      leakages <- LeakAddr([i; i]) :: leakages;
      aux_0 <- (k.[i] \vadd32u256 st.[i]);
      leakages <- LeakAddr([i]) :: leakages;
      k.[i] <- aux_0;
      i <- i + 1;
    }
    return (k);
  }
  
  proc __chacha_xor_v_avx2 (output:W64.t, input:W64.t, len:W64.t,
                            nonce:W64.t, key:W64.t) : unit = {
    var aux_3: W64.t;
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux: W256.t;
    var aux_0: W256.t Array16.t;
    
    var _r16:W256.t;
    var _r8:W256.t;
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R16_AVX2;
    _r16 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R8_AVX2;
    _r8 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- _r16;
    r16 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- _r8;
    r8 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __init_v_avx2 (nonce, key);
    st <- aux_0;
    
    leakages <- LeakCond(((W64.of_int 512) \ule len)) :: LeakAddr([]) :: leakages;
    
    while (((W64.of_int 512) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __copy_state_v_avx2 (st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __rounds_v_avx2 (k, r16, r8);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __sum_states_v_avx2 (k, st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_3, aux_2, aux_1) <@ __store_xor_v_avx2 (output, input, len, k);
      output <- aux_3;
      input <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __increment_counter_v_avx2 (st);
      st <- aux_0;
    leakages <- LeakCond(((W64.of_int 512) \ule len)) :: LeakAddr([]) :: leakages;
    
    }
    leakages <- LeakCond(((W64.of_int 0) \ult len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 0) \ult len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __copy_state_v_avx2 (st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __rounds_v_avx2 (k, r16, r8);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __sum_states_v_avx2 (k, st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      __store_xor_last_v_avx2 (output, input, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __chacha_v_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    var aux_2: W64.t;
    var aux_1: W64.t;
    var aux: W256.t;
    var aux_0: W256.t Array16.t;
    
    var _r16:W256.t;
    var _r8:W256.t;
    var r16:W256.t;
    var r8:W256.t;
    var st:W256.t Array16.t;
    var k:W256.t Array16.t;
    k <- witness;
    st <- witness;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R16_AVX2;
    _r16 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- CHACHA_R8_AVX2;
    _r8 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- _r16;
    r16 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux <- _r8;
    r8 <- aux;
    leakages <- LeakAddr([]) :: leakages;
    aux_0 <@ __init_v_avx2 (nonce, key);
    st <- aux_0;
    
    leakages <- LeakCond(((W64.of_int 512) \ule len)) :: LeakAddr([]) :: leakages;
    
    while (((W64.of_int 512) \ule len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __copy_state_v_avx2 (st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __rounds_v_avx2 (k, r16, r8);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __sum_states_v_avx2 (k, st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      (aux_2, aux_1) <@ __store_v_avx2 (output, len, k);
      output <- aux_2;
      len <- aux_1;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __increment_counter_v_avx2 (st);
      st <- aux_0;
    leakages <- LeakCond(((W64.of_int 512) \ule len)) :: LeakAddr([]) :: leakages;
    
    }
    leakages <- LeakCond(((W64.of_int 0) \ult len)) :: LeakAddr([]) :: leakages;
    if (((W64.of_int 0) \ult len)) {
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __copy_state_v_avx2 (st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __rounds_v_avx2 (k, r16, r8);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      aux_0 <@ __sum_states_v_avx2 (k, st);
      k <- aux_0;
      leakages <- LeakAddr([]) :: leakages;
      __store_last_v_avx2 (output, len, k);
    } else {
      
    }
    return ();
  }
  
  proc __chacha_xor_avx2 (output:W64.t, input:W64.t, len:W64.t, nonce:W64.t,
                          key:W64.t) : unit = {
    
    
    
    leakages <- LeakCond((len \ult (W64.of_int 257))) :: LeakAddr([]) :: leakages;
    if ((len \ult (W64.of_int 257))) {
      leakages <- LeakAddr([]) :: leakages;
      __chacha_xor_h_x2_avx2 (output, input, len, nonce, key);
    } else {
      leakages <- LeakAddr([]) :: leakages;
      __chacha_xor_v_avx2 (output, input, len, nonce, key);
    }
    return ();
  }
  
  proc __chacha_avx2 (output:W64.t, len:W64.t, nonce:W64.t, key:W64.t) : unit = {
    
    
    
    leakages <- LeakCond((len \ult (W64.of_int 257))) :: LeakAddr([]) :: leakages;
    if ((len \ult (W64.of_int 257))) {
      leakages <- LeakAddr([]) :: leakages;
      __chacha_h_x2_avx2 (output, len, nonce, key);
    } else {
      leakages <- LeakAddr([]) :: leakages;
      __chacha_v_avx2 (output, len, nonce, key);
    }
    return ();
  }
  
  proc jade_stream_chacha_chacha20_amd64_avx2_xor (output:W64.t, input:W64.t,
                                                   len:W64.t, nonce:W64.t,
                                                   key:W64.t) : W64.t = {
    var aux_3: bool;
    var aux_2: bool;
    var aux_1: bool;
    var aux_0: bool;
    var aux: bool;
    var aux_4: W64.t;
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    leakages <- LeakAddr([]) :: leakages;
    __chacha_xor_avx2 (output, input, len, nonce, key);
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2, aux_1, aux_0, aux, aux_4) <- set0_64 ;
     _0 <- aux_3;
     _1 <- aux_2;
     _2 <- aux_1;
     _3 <- aux_0;
     _4 <- aux;
    r <- aux_4;
    return (r);
  }
  
  proc jade_stream_chacha_chacha20_amd64_avx2 (output:W64.t, len:W64.t,
                                               nonce:W64.t, key:W64.t) : 
  W64.t = {
    var aux_3: bool;
    var aux_2: bool;
    var aux_1: bool;
    var aux_0: bool;
    var aux: bool;
    var aux_4: W64.t;
    
    var r:W64.t;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    var  _3:bool;
    var  _4:bool;
    
    leakages <- LeakAddr([]) :: leakages;
    __chacha_avx2 (output, len, nonce, key);
    leakages <- LeakAddr([]) :: leakages;
    (aux_3, aux_2, aux_1, aux_0, aux, aux_4) <- set0_64 ;
     _0 <- aux_3;
     _1 <- aux_2;
     _2 <- aux_1;
     _3 <- aux_0;
     _4 <- aux;
    r <- aux_4;
    return (r);
  }
}.

