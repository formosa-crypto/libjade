require import List Int IntDiv CoreMap.
require import Array8 Array16.
require import WArray64.
require import ChaCha20_pref ChaCha20_pavx2_cf.

from Jasmin require import JModel.

module M = {
  proc init_x2(key nonce: int, counter:W32.t) : W32.t Array16.t * W32.t Array16.t = {
    var st_1, st_2: W32.t Array16.t;
    st_1 <@ ChaCha20_pref.M.init (key, nonce, counter);
    st_2 <@ ChaCha20_pref.M.increment_counter(st_1);
    return (st_1, st_2);
  }

  proc line_x4 (k: W32.t Array16.t, a b c r: int) : W32.t Array16.t = {
    var i : int;
    k.[a + 0] <- k.[a + 0] + k.[b + 0];
    k.[a + 1] <- k.[a + 1] + k.[b + 1];
    k.[a + 2] <- k.[a + 2] + k.[b + 2];
    k.[a + 3] <- k.[a + 3] + k.[b + 3];

    k.[c + 0] <- k.[c + 0] `^` k.[a + 0];
    k.[c + 1] <- k.[c + 1] `^` k.[a + 1];
    k.[c + 2] <- k.[c + 2] `^` k.[a + 2];
    k.[c + 3] <- k.[c + 3] `^` k.[a + 3];

    k.[c + 0] <- rol k.[c + 0] r;
    k.[c + 1] <- rol k.[c + 1] r;
    k.[c + 2] <- rol k.[c + 2] r;
    k.[c + 3] <- rol k.[c + 3] r;

    return k;
  }

  proc column_round(k: W32.t Array16.t) : W32.t Array16.t = {
    k <@ line_x4(k, 0, 4, 12, 16);
    k <@ line_x4(k, 8, 12, 4, 12);
    k <@ line_x4(k, 0, 4, 12,  8);
    k <@ line_x4(k, 8, 12, 4,  7);
    return k;
  }

  proc shuffle_state_1 (k: W32.t Array16.t) : W32.t Array16.t = {
    var k' : W32.t Array16.t;
    
    k' <- witness<:W32.t Array16.t>.[0  <- k.[0] ];
    k'.[1]  <- k.[1] ;
    k'.[2]  <- k.[2] ;
    k'.[3]  <- k.[3] ;
 
    k'.[4]  <- k.[5] ;
    k'.[5]  <- k.[6] ;
    k'.[6]  <- k.[7] ;
    k'.[7]  <- k.[4] ;

    k'.[8]  <- k.[10];
    k'.[9]  <- k.[11];
    k'.[10] <- k.[8] ;
    k'.[11] <- k.[9] ;

    k'.[12] <- k.[15];
    k'.[13] <- k.[12];
    k'.[14] <- k.[13];
    k'.[15] <- k.[14];
    return k';
  }

  proc reverse_shuffle_state_1 (k: W32.t Array16.t) : W32.t Array16.t = {
    var k' : W32.t Array16.t;

    k' <- witness<:W32.t Array16.t>.[0  <- k.[0] ];
    k'.[1]  <- k.[1] ;
    k'.[2]  <- k.[2] ;
    k'.[3]  <- k.[3] ;

    k'.[5]  <- k.[4] ;
    k'.[6]  <- k.[5] ;
    k'.[7]  <- k.[6] ;
    k'.[4]  <- k.[7] ;

    k'.[10] <- k.[8] ;
    k'.[11] <- k.[9] ;
    k'.[8]  <- k.[10];
    k'.[9]  <- k.[11];

    k'.[15] <- k.[12];
    k'.[12] <- k.[13];
    k'.[13] <- k.[14];
    k'.[14] <- k.[15];
    return k';
  }

  proc diagonal_round(k: W32.t Array16.t) : W32.t Array16.t = {
    k <@ shuffle_state_1(k);
    k <@ column_round(k);
    k <@ reverse_shuffle_state_1(k);
    return k;
  }

  proc rounds(k: W32.t Array16.t) : W32.t Array16.t = {
    var c : int;
    c <- 0;
    while (c < 10) {
      k <@ column_round(k);
      k <@ diagonal_round(k);
      c <- c + 1;
    }
    return k;
  }

  proc line_x8(k1 k2: W32.t Array16.t, a b c r:int) : W32.t Array16.t * W32.t Array16.t = {
    k1 <@ line_x4(k1, a, b, c, r);
    k2 <@ line_x4(k2, a, b, c, r);
    return (k1,k2);
  }

  proc column_round_x2(k1 k2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    (k1,k2) <@ line_x8(k1, k2, 0, 4, 12, 16);
    (k1,k2) <@ line_x8(k1, k2, 8, 12, 4, 12);
    (k1,k2) <@ line_x8(k1, k2, 0, 4, 12,  8);
    (k1,k2) <@ line_x8(k1, k2, 8, 12, 4,  7);
    return (k1, k2);
  }

  proc shuffle_state(k1 k2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    k1 <@ shuffle_state_1(k1);
    k2 <@ shuffle_state_1(k2);
    return (k1, k2);
  }

  proc reverse_shuffle_state(k1 k2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    k1 <@ reverse_shuffle_state_1(k1);
    k2 <@ reverse_shuffle_state_1(k2);
    return (k1, k2);
  }

  proc diagonal_round_x2(k1 k2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    (k1, k2) <@ shuffle_state(k1, k2);
    (k1, k2) <@ column_round_x2(k1, k2);
    (k1, k2) <@ reverse_shuffle_state(k1, k2);
    return (k1, k2);
  }
  
  proc rounds_x2(k1_1 k1_2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    var c : int;
    c <- 0;
    while (c < 10) {
      (k1_1, k1_2) <@ column_round_x2(k1_1, k1_2);
      (k1_1, k1_2) <@ diagonal_round_x2(k1_1, k1_2);
      c <- c + 1;
    }
    return (k1_1, k1_2);
  }

  proc column_round_x2_aux(k1_1 k1_2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    k1_1 <@  column_round(k1_1);
    k1_2 <@  column_round(k1_2);
    return (k1_1, k1_2);
  }

  proc rounds_x2_aux(k1_1 k1_2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    k1_1 <@ rounds(k1_1);
    k1_2 <@ rounds(k1_2);
    return (k1_1, k1_2);
  }

  proc sum_states_x2(k1_1 k1_2 st_1 st_2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    var k1, k2 :  W32.t Array16.t;
    k1 <@ ChaCha20_pref.M.sum_states(k1_1, st_1);
    k2 <@ ChaCha20_pref.M.sum_states(k1_2, st_2);
    return (k1, k2);
  }
    
  proc copy_state_x4(st_1 st_2: W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    st_1.[12] <- st_1.[12] + W32.of_int 2;
    st_2.[12] <- st_2.[12] + W32.of_int 2;
    return (st_1, st_2);
  }

  proc column_round_x4 (k1_1 k1_2 k2_1 k2_2: W32.t Array16.t) = {
    (k1_1, k1_2) <@ column_round_x2(k1_1, k1_2);
    (k2_1, k2_2) <@ column_round_x2(k2_1, k2_2);
    return (k1_1, k1_2, k2_1, k2_2);
  }

  proc shuffle_state_x2(k1_1 k1_2 k2_1 k2_2: W32.t Array16.t) = {
    (k1_1, k1_2) <@ shuffle_state(k1_1, k1_2);
    (k2_1, k2_2) <@ shuffle_state(k2_1, k2_2);
    return (k1_1, k1_2, k2_1, k2_2);
  }

  proc reverse_shuffle_state_x2(k1_1 k1_2 k2_1 k2_2: W32.t Array16.t) = {
    (k1_1, k1_2) <@ reverse_shuffle_state(k1_1, k1_2);
    (k2_1, k2_2) <@ reverse_shuffle_state(k2_1, k2_2);
    return (k1_1, k1_2, k2_1, k2_2);
  }

  proc diagonal_round_x4 (k1_1 k1_2 k2_1 k2_2: W32.t Array16.t) = {
   (k1_1, k1_2, k2_1, k2_2) <@ shuffle_state_x2(k1_1, k1_2, k2_1, k2_2);
   (k1_1, k1_2, k2_1, k2_2) <@ column_round_x4(k1_1, k1_2, k2_1, k2_2);
   (k1_1, k1_2, k2_1, k2_2) <@ reverse_shuffle_state_x2(k1_1, k1_2, k2_1, k2_2);
   return (k1_1, k1_2, k2_1, k2_2);
  }

  proc rounds_x4(k1_1 k1_2 k2_1 k2_2: W32.t Array16.t) = {
    var c : int;
    c <- 0;
    while (c < 10) {
      (k1_1, k1_2, k2_1, k2_2) <@ column_round_x4(k1_1, k1_2, k2_1, k2_2);
      (k1_1, k1_2, k2_1, k2_2) <@ diagonal_round_x4(k1_1, k1_2, k2_1, k2_2);
      c <- c + 1;
    }
    return (k1_1, k1_2, k2_1, k2_2);
  }

  proc sum_states_x4(k1_1 k1_2 k2_1 k2_2 st_1 st_2: W32.t Array16.t) = {
    (k1_1, k1_2) <@ sum_states_x2(k1_1, k1_2, st_1, st_2);
    (k2_1, k2_2) <@ sum_states_x2(k2_1, k2_2, st_1, st_2);
    k2_1.[12] <- k2_1.[12] + W32.of_int 2;
    k2_2.[12] <- k2_2.[12] + W32.of_int 2;
    return (k1_1, k1_2, k2_1, k2_2);
  }

  proc chacha20_less_than_257(output plain len: int, key nonce: int, counter:W32.t) : unit = {
    var st_1, st_2, st_3, st_4, k1_1, k1_2, k2_1, k2_2: W32.t Array16.t;
    (st_1, st_2) <@ init_x2(key, nonce, counter);
    if (128 < len) {
       (st_3, st_4) <@ copy_state_x4(st_1, st_2);
       (k1_1, k1_2, k2_1, k2_2) <@ rounds_x4(st_1, st_2, st_3, st_4);
       (k1_1, k1_2, k2_1, k2_2) <@ sum_states_x4(k1_1, k1_2, k2_1, k2_2, st_1, st_2);
       (output, plain, len) <@ ChaCha20_pavx2_cf.M.store_x2(output, plain, len, k1_1, k1_2);
       ChaCha20_pavx2_cf.M.store_x2_last(output, plain, len, k2_1, k2_2);
    } else {
      (k1_1, k1_2) <@ rounds_x2 (st_1, st_2);
      (k1_1, k1_2) <@ sum_states_x2(k1_1, k1_2, st_1, st_2);
      ChaCha20_pavx2_cf.M.store_x2_last(output, plain, len, k1_1, k1_2);
    } 
  }

  (* ------------------------------------------------------------------- *)
  (* more than 256                                                       *)

  proc init_x8(key, nonce, counter) = {
    var st1, st2, st3, st4, st5, st6, st7, st8 : W32.t Array16.t;
    st1 <@ ChaCha20_pref.M.init (key, nonce, counter);
    st2 <- st1.[12 <- st1.[12] + W32.of_int 1];
    st3 <- st1.[12 <- st1.[12] + W32.of_int 2];
    st4 <- st1.[12 <- st1.[12] + W32.of_int 3];
    st5 <- st1.[12 <- st1.[12] + W32.of_int 4];
    st6 <- st1.[12 <- st1.[12] + W32.of_int 5];
    st7 <- st1.[12 <- st1.[12] + W32.of_int 6];
    st8 <- st1.[12 <- st1.[12] + W32.of_int 7];
    return (st1, st2, st3, st4, st5, st6, st7, st8); 
  }

  proc sum_states_x8(k1 k2 k3 k4 k5 k6 k7 k8 st1 st2 st3 st4 st5 st6 st7 st8: W32.t Array16.t) = {
    k1 <@ ChaCha20_pref.M.sum_states(k1, st1);
    k2 <@ ChaCha20_pref.M.sum_states(k2, st2);
    k3 <@ ChaCha20_pref.M.sum_states(k3, st3);
    k4 <@ ChaCha20_pref.M.sum_states(k4, st4);
    k5 <@ ChaCha20_pref.M.sum_states(k5, st5);
    k6 <@ ChaCha20_pref.M.sum_states(k6, st6);
    k7 <@ ChaCha20_pref.M.sum_states(k7, st7);
    k8 <@ ChaCha20_pref.M.sum_states(k8, st8);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc increment_counter_x8(st1 st2 st3 st4 st5 st6 st7 st8: W32.t Array16.t) = {
    st1.[12] <- st1.[12] + W32.of_int 8;
    st2.[12] <- st2.[12] + W32.of_int 8;
    st3.[12] <- st3.[12] + W32.of_int 8;
    st4.[12] <- st4.[12] + W32.of_int 8;
    st5.[12] <- st5.[12] + W32.of_int 8;
    st6.[12] <- st6.[12] + W32.of_int 8;
    st7.[12] <- st7.[12] + W32.of_int 8;
    st8.[12] <- st8.[12] + W32.of_int 8;
    return (st1, st2, st3, st4, st5, st6, st7, st8); 
  }
 
  proc double_quarter_round_x1_aux (k: W32.t Array16.t, a0 b0 c0 d0 a1 b1 c1 d1 : int) = {
    k <@ ChaCha20_pref.M.quarter_round(k, a0, b0, c0, d0);
    k <@ ChaCha20_pref.M.quarter_round(k, a1, b1, c1, d1);
    return k;
  }

  proc line_2 (k:W32.t Array16.t, a0 b0 c0 r0 a1 b1 c1 r1:int) = {
    k.[a0] <- (k.[a0] + k.[b0]);
    k.[a1] <- (k.[a1] + k.[b1]);

    k.[c0] <- (k.[c0] `^` k.[a0]);
    k.[c1] <- (k.[c1] `^` k.[a1]);

    k.[c0] <- rol k.[c0] r0;
    k.[c1] <- rol k.[c1] r1;

    return (k);
  }
  
  proc line_x1_8(k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array16.t, a b c r: int) = {
    k1 <@ ChaCha20_pref.M.line(k1, a, b, c, r);
    k2 <@ ChaCha20_pref.M.line(k2, a, b, c, r);
    k3 <@ ChaCha20_pref.M.line(k3, a, b, c, r);
    k4 <@ ChaCha20_pref.M.line(k4, a, b, c, r);
    k5 <@ ChaCha20_pref.M.line(k5, a, b, c, r);
    k6 <@ ChaCha20_pref.M.line(k6, a, b, c, r);
    k7 <@ ChaCha20_pref.M.line(k7, a, b, c, r);
    k8 <@ ChaCha20_pref.M.line(k8, a, b, c, r);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc line_2_x1_8 (k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array16.t, a0 b0 c0 r0 a1 b1 c1 r1 : int) = {
    k1 <@ line_2(k1, a0, b0, c0, r0, a1, b1, c1, r1);
    k2 <@ line_2(k2, a0, b0, c0, r0, a1, b1, c1, r1);
    k3 <@ line_2(k3, a0, b0, c0, r0, a1, b1, c1, r1);
    k4 <@ line_2(k4, a0, b0, c0, r0, a1, b1, c1, r1);
    k5 <@ line_2(k5, a0, b0, c0, r0, a1, b1, c1, r1);
    k6 <@ line_2(k6, a0, b0, c0, r0, a1, b1, c1, r1);
    k7 <@ line_2(k7, a0, b0, c0, r0, a1, b1, c1, r1);
    k8 <@ line_2(k8, a0, b0, c0, r0, a1, b1, c1, r1);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc double_quarter_round_x1 (k: W32.t Array16.t, a0 b0 c0 d0 a1 b1 c1 d1 : int) = {
    k <@ ChaCha20_pref.M.line (k, a0, b0, d0, 16);
    k <@ line_2(k, c0, d0, b0, 12, a1, b1, d1, 16);
    k <@ line_2(k, a0, b0, d0, 8,  c1, d1, b1, 12);
    k <@ line_2(k, c0, d0, b0, 7,  a1, b1, d1, 8);
    k <@  ChaCha20_pref.M.line(k,  c1, d1, b1, 7);
    return k;
  }

  proc double_quarter_round_x1_8 (k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array16.t, a0 b0 c0 d0 a1 b1 c1 d1 : int) = {
    k1 <@ double_quarter_round_x1(k1, a0, b0, c0, d0, a1, b1, c1, d1);
    k2 <@ double_quarter_round_x1(k2, a0, b0, c0, d0, a1, b1, c1, d1);
    k3 <@ double_quarter_round_x1(k3, a0, b0, c0, d0, a1, b1, c1, d1);
    k4 <@ double_quarter_round_x1(k4, a0, b0, c0, d0, a1, b1, c1, d1);
    k5 <@ double_quarter_round_x1(k5, a0, b0, c0, d0, a1, b1, c1, d1);
    k6 <@ double_quarter_round_x1(k6, a0, b0, c0, d0, a1, b1, c1, d1);
    k7 <@ double_quarter_round_x1(k7, a0, b0, c0, d0, a1, b1, c1, d1);
    k8 <@ double_quarter_round_x1(k8, a0, b0, c0, d0, a1, b1, c1, d1);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc column_round_x1(k: W32.t Array16.t) = {
    k <@ double_quarter_round_x1(k, 0, 4, 8,  12,     
                                   2, 6, 10, 14);
    k <@ double_quarter_round_x1(k, 1, 5, 9,  13,
                                   3, 7, 11, 15);
    return k;
  }

  proc diagonal_round_x1(k: W32.t Array16.t) = {
    k <@ double_quarter_round_x1(k, 1, 6, 11, 12,
                                    0, 5, 10, 15);
    k <@ double_quarter_round_x1(k, 2, 7, 8, 13,
                                    3, 4, 9, 14);
    return k;
  }

  proc double_quarter_round_x8 (k1 k2 k3 k4 k5 k6 k7 k8:W32.t Array16.t, a0 b0 c0 d0 a1 b1 c1 d1 : int) = {
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ line_x1_8  (k1,k2,k3,k4,k5,k6,k7,k8, a0, b0, d0, 16);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ line_2_x1_8(k1,k2,k3,k4,k5,k6,k7,k8, c0, d0, b0, 12, a1, b1, d1, 16);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ line_2_x1_8(k1,k2,k3,k4,k5,k6,k7,k8, a0, b0, d0, 8,  c1, d1, b1, 12);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ line_2_x1_8(k1,k2,k3,k4,k5,k6,k7,k8, c0, d0, b0, 7,  a1, b1, d1, 8);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ line_x1_8  (k1,k2,k3,k4,k5,k6,k7,k8, c1, d1, b1, 7);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc column_round_x8(k1 k2 k3 k4 k5 k6 k7 k8:W32.t Array16.t) = {
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ 
      double_quarter_round_x8(k1,k2,k3,k4,k5,k6,k7,k8, 0, 4, 8,  12,     
                                                       2, 6, 10, 14);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ 
     double_quarter_round_x8(k1,k2,k3,k4,k5,k6,k7,k8, 1, 5, 9,  13,
                                                      3, 7, 11, 15);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc diagonal_round_x8(k1 k2 k3 k4 k5 k6 k7 k8:W32.t Array16.t) = {
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ 
      double_quarter_round_x8(k1,k2,k3,k4,k5,k6,k7,k8, 1, 6, 11, 12,
                                                       0, 5, 10, 15);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ 
      double_quarter_round_x8(k1,k2,k3,k4,k5,k6,k7,k8, 2, 7, 8, 13,
                                                       3, 4, 9, 14);
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }
  
  proc rounds_x1 (k: W32.t Array16.t) = {
    var c : int;
    c <- 0;
    while (c < 10) {
      k <@ column_round_x1(k);
      k <@ diagonal_round_x1(k);
      c <- c + 1;
    }
    return k;
  }

  proc rounds_x8 (k1 k2 k3 k4 k5 k6 k7 k8:W32.t Array16.t) = {
    var c : int;
    c <- 0;
    while (c < 10) {
      (k1,k2,k3,k4,k5,k6,k7,k8) <@ column_round_x8(k1,k2,k3,k4,k5,k6,k7,k8);
      (k1,k2,k3,k4,k5,k6,k7,k8) <@ diagonal_round_x8(k1,k2,k3,k4,k5,k6,k7,k8);
      c <- c + 1;
    }
    return (k1,k2,k3,k4,k5,k6,k7,k8);
  }

  proc body_x8 (st1 st2 st3 st4 st5 st6 st7 st8: W32.t Array16.t) = {
    var k1,k2,k3,k4,k5,k6,k7,k8: W32.t Array16.t;
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ rounds_x8(st1,st2,st3,st4,st5,st6,st7,st8);
    (k1,k2,k3,k4,k5,k6,k7,k8) <@ sum_states_x8(k1,k2,k3,k4,k5,k6,k7,k8, st1,st2,st3,st4,st5,st6,st7,st8);
    (st1,st2,st3,st4,st5,st6,st7,st8) <@ increment_counter_x8(st1,st2,st3,st4,st5,st6,st7,st8);
    return (k1,k2,k3,k4,k5,k6,k7,k8, st1,st2,st3,st4,st5,st6,st7,st8);
  }

  proc chacha20_more_than_256(output plain len: int, key nonce: int, counter:W32.t) : unit = {
    var k1,k2,k3,k4,k5,k6,k7,k8, st1,st2,st3,st4,st5,st6,st7,st8: W32.t Array16.t;
    
    (st1,st2,st3,st4,st5,st6,st7,st8) <@ init_x8(key, nonce, counter);

    while( 512 <= len) {
      (k1,k2,k3,k4,k5,k6,k7,k8) <@ rounds_x8(st1,st2,st3,st4,st5,st6,st7,st8);
      (k1,k2,k3,k4,k5,k6,k7,k8) <@ sum_states_x8(k1,k2,k3,k4,k5,k6,k7,k8, st1,st2,st3,st4,st5,st6,st7,st8);
      (output, plain, len) <@ ChaCha20_pavx2_cf.M.store_x8(output, plain, len, k1,k2,k3,k4,k5,k6,k7,k8);
      (st1,st2,st3,st4,st5,st6,st7,st8) <@ increment_counter_x8(st1,st2,st3,st4,st5,st6,st7,st8);
    }

    if(0 < len) {
      (k1,k2,k3,k4,k5,k6,k7,k8) <@ rounds_x8(st1,st2,st3,st4,st5,st6,st7,st8);
      (k1,k2,k3,k4,k5,k6,k7,k8) <@ sum_states_x8(k1,k2,k3,k4,k5,k6,k7,k8, st1,st2,st3,st4,st5,st6,st7,st8);
      ChaCha20_pavx2_cf.M.store_x8_last(output, plain, len, k1,k2,k3,k4,k5,k6,k7,k8);
    }
  }

  proc chacha20_avx2(output plain len : int, key nonce: int, counter:W32.t) : unit = {
    if (len < 257) {
      chacha20_less_than_257(output, plain, len, key, nonce, counter);
    } else {
      chacha20_more_than_256(output, plain, len, key, nonce, counter);     
    }
  }
}.

equiv eq_chacha20_init_x2 : ChaCha20_pref.M.init ~ M.init_x2 : 
   ={key, nonce, counter, Glob.mem} ==> res{1} = res{2}.`1 /\  res{2}.`2 = res{1}.[12 <- res{1}.[12] + W32.of_int 1].
proof.
  proc => /=.
  inline ChaCha20_pref.M.increment_counter.
  wp 10 1; conseq (_: st{1} = st_1{2}) => />.
  by inline [tuple] *; sim.
qed.

equiv eq_column_round :ChaCha20_pref.M.column_round ~ M.column_round : ={k} ==> ={res}.
proof.
  proc. 
  conseq (_: Array16.all_eq k{1} k{2}).
  + by move=> ?????;apply Array16.all_eq_eq.
  by rewrite /all_eq /=; inline *; wp; skip. 
qed. 

equiv eq_diagonal_round :ChaCha20_pref.M.diagonal_round ~ M.diagonal_round : ={k} ==> ={res}.
proof.
  proc. 
  conseq (_: Array16.all_eq k{1} k{2}).
  + by move=> ?????;apply Array16.all_eq_eq.
  by rewrite /all_eq /=; inline *; wp; skip.
qed.

equiv eq_rounds : ChaCha20_pref.M.rounds ~ M.rounds : ={k} ==> ={res}.
proof.
  proc; inline ChaCha20_pref.M.round.
  while (={c, k}); last by auto.
  by wp; sp; call eq_diagonal_round; call eq_column_round; auto.
qed.

equiv eq_column_round_x1 : ChaCha20_pref.M.column_round ~M.column_round_x1 : ={k} ==> = {res}.
proof.
  proc.
  conseq (_: Array16.all_eq k{1} k{2}).
  + by move=> ?????;apply Array16.all_eq_eq.
  inline *. wp. skip. 
  by move=> &1 &2 <<-; cbv delta.
qed.

equiv eq_diagonal_round_x1 : ChaCha20_pref.M.diagonal_round ~M.diagonal_round_x1 : ={k} ==> = {res}.
proof.
  proc.
  conseq (_: Array16.all_eq k{1} k{2}).
  + by move=> ?????;apply Array16.all_eq_eq.
  by rewrite /all_eq /=; inline *; wp; skip.
qed.

equiv eq_rounds_x1 : ChaCha20_pref.M.rounds ~ M.rounds_x1 : ={k} ==> ={res}.
proof.
  proc; inline ChaCha20_pref.M.round.
  while (={c, k}); last by auto.
  by wp; sp; call eq_diagonal_round_x1; call eq_column_round_x1; auto.
qed.

equiv eq_line_x4: M.line_x4 ~ M.line_x4 : ={arg} ==> ={res}.
proof. by sim. qed.

equiv eq_column_round_x2_aux : M.column_round_x2_aux ~ M.column_round_x2 : 
 k1_1{1} = k1{2} /\ k1_2{1} = k2{2} ==> ={res}.
proof.
  proc => /=.
  inline [-tuple] M.line_x8 M.column_round.
  interleave{1} [1:1] [7:1] 6.
  by do 4! (wp; do 2! call eq_line_x4); wp; skip.
qed.

equiv eq_rounds_x2 : M.rounds_x2_aux ~ M.rounds_x2 : ={k1_1, k1_2} ==> ={res}.
proof.
  proc => /=.
  inline M.rounds. swap{1} 4 3. swap{1} 4 -2; sp 2 0; wp.
  transitivity* {1} { c <- 0; 
                      while (c < 10) {
                        k <@ M.column_round(k);
                        k <@ M.diagonal_round(k);
                        k0 <@ M.column_round(k0);
                        k0 <@ M.diagonal_round(k0);
                        c <- c + 1;
                      }
                    }.
  + smt(). + done.
  + do 2! unroll for{1} ^while; unroll for{2} ^while.
     interleave{1} [1:3] [32:3] 10; 1: by sim.
  while (#post /\ ={c});last by auto.
  wp; swap{1} 3 -1; conseq />.
  inline M.diagonal_round M.diagonal_round_x2.
  interleave{1} [3:1] [8:1] 5.
  transitivity* {1} { (k, k0) <@ M.column_round_x2_aux(k, k0); 
                      (k, k0) <@ M.shuffle_state(k, k0); 
                      (k, k0) <@ M.column_round_x2_aux(k, k0); 
                      (k, k0) <@ M.reverse_shuffle_state(k, k0); }.
  + smt (). + done. 
  + by inline M.column_round_x2_aux M.shuffle_state M.reverse_shuffle_state; sim.
  sim (_: true); conseq eq_column_round_x2_aux.
qed.

equiv eq_chacha20_less_than_257 : ChaCha20_pavx2_cf.M.chacha20_less_than_257 ~ M.chacha20_less_than_257 :
   ={output, plain, len, key, nonce, counter, Glob.mem} ==> 
   ={Glob.mem}.
proof.
  proc => /=.
  seq 1 1 : (#pre /\ st_1{1} = st_1{2} /\ st_2{2} = st_1{1}.[12 <- st_1{1}.[12] + W32.of_int 1]).
  + by call eq_chacha20_init_x2; skip.
  if => //; last first.
  + inline ChaCha20_pavx2_cf.M.chacha20_less_than_128; sim.
    swap{1} 7 -2. interleave{1} [6:1] [8:1] 2.  
    inline [-tuple] M.sum_states_x2 ChaCha20_pref.M.increment_counter; sim.
    sp 7 0.  
    transitivity * {1} { (k_1, k_2) <@ M.rounds_x2_aux(st_10, st_20); }.
    + smt(). + done.
    + inline M.rounds_x2_aux; wp.
      by do 2! call eq_rounds; wp; skip.
    by call eq_rounds_x2; auto.
  inline{1} ChaCha20_pavx2_cf.M.chacha20_between_128_255; sim.
  swap{1} 7 -2. swap{1} 10 -4. swap{1} 13 -6. 
  interleave{1} [8:1] [10:1] [12:1] [14:1] 2.
  inline ChaCha20_pref.M.increment_counter M.copy_state_x4 M.rounds_x4.
  sp 13 9; conseq />.
  seq 4 3 : (#post /\ st_10{1} = st_1{2} /\ st_20{1} = st_2{2} /\ 
                      st_30{1} = st_1{2}.[12 <- st_1{2}.[12] + W32.of_int 2] /\
                      st_4{1}  = st_2{2}.[12 <- st_2{2}.[12] + W32.of_int 2]).
  + conseq (_: k_4{1} = k2_2{2} /\ k_3{1} = k2_1{2} /\ k_2{1} = k1_2{2} /\ k_1{1} = k1_1{2}) => //.
    transitivity * {1} { (k_1, k_2) <@ M.rounds_x2_aux(st_10, st_20);
                         (k_3, k_4) <@ M.rounds_x2_aux(st_30, st_4); }.
    + smt(). + done.
    + inline M.rounds_x2_aux; wp.
      by do 4! (call eq_rounds; wp); skip.
    transitivity * {1} { (k_1, k_2) <@ M.rounds_x2(st_10, st_20);
                         (k_3, k_4) <@ M.rounds_x2(st_30, st_4); }.
    + smt(). + done.
    + by wp; do 2!call eq_rounds_x2; auto.
    inline [-tuple] M.rounds_x2.
    swap{1} [5..8] 4. swap{1} [5..6] -2; wp; sp 4 0.
    transitivity* {1} {
      c <- 0;
      while(c < 10) {
       (k1_10, k1_20) <@ M.column_round_x2(k1_10, k1_20);
       (k1_10, k1_20) <@ M.diagonal_round_x2(k1_10, k1_20);
       (k1_11, k1_21) <@ M.column_round_x2(k1_11, k1_21);
       (k1_11, k1_21) <@ M.diagonal_round_x2(k1_11, k1_21);
       c <- c + 1;
     } }.
    + smt(). + done.
    + do 2!unroll for{1} ^while; unroll for{2} ^while.
      by interleave{1} [1:3] [32:3] 10; sim.
    while (#post /\ ={c}); last by auto.
    wp; swap{1} 3 -1; conseq />.
    inline M.column_round_x4 M.diagonal_round_x4 M.shuffle_state_x2 M.reverse_shuffle_state_x2
       M.diagonal_round_x2.
    by swap{1} [9..11] -3; swap{1} 12 -2; sim.    
  conseq />; inline M.sum_states_x4; sp; wp.
  seq 2 1: (k_1{1} = k1_11{2} /\ k_2{1} = k1_21{2} /\ k_3{1} = k2_11{2} /\ k_4{1} = k2_21{2} /\
                      st_30{1} = st_11{2}.[12 <- st_11{2}.[12] + W32.of_int 2] /\
                      st_4{1}  = st_21{2}.[12 <- st_21{2}.[12] + W32.of_int 2]).
  + by inline M.sum_states_x2; sim />.
  inline M.sum_states_x2 ChaCha20_pref.M.sum_states; wp. sp 2 6.
  conseq (_: Array16.all_eq k0{1} k0{2}.[12 <- k0{2}.[12] + (of_int 2)%W32] /\ 
             Array16.all_eq k_3{1} k1{2}.[12 <- k1{2}.[12] + (of_int 2)%W32]).
  + by move=> |> ???? /Array16.all_eq_eq -> /Array16.all_eq_eq ->.
  (* FIXME : unroll for 7; unroll for 2. *)
  do 2! (unroll for{1} ^while; unroll for{2} ^while). 
  rewrite /Array16.all_eq /=; wp; skip => />.
  (* FIXME: move=> &2; ring. *)
  move=> &2; split; ring.
qed.

op is_incr_count8 (st: W32.t Array16.t) (st1 st2 st3 st4 st5 st6 st7 st8: W32.t Array16.t) = 
   st1 = st /\
   st2 = st.[12 <- st.[12] +  W32.of_int 1] /\
   st3 = st.[12 <- st.[12] +  W32.of_int 2] /\
   st4 = st.[12 <- st.[12] +  W32.of_int 3] /\
   st5 = st.[12 <- st.[12] +  W32.of_int 4] /\
   st6 = st.[12 <- st.[12] +  W32.of_int 5] /\
   st7 = st.[12 <- st.[12] +  W32.of_int 6] /\
   st8 = st.[12 <- st.[12] +  W32.of_int 7].

equiv eq_line : ChaCha20_pref.M.line ~ ChaCha20_pref.M.line :
   ={k, a, b, c, r} ==> ={res}.
proof. by sim. qed.

equiv eq_line_2 : M.line_2 ~ M.line_2 :
   ={k, a0, b0, c0, r0, a1, b1, c1, r1} ==> ={res}.
proof. by sim. qed.

equiv eq_double_quarter_round_x1_x8 :
   M.double_quarter_round_x1_8 ~ M.double_quarter_round_x8 :
   ={a0,b0,c0,d0, a1,b1,c1,d1, k1,k2,k3,k4,k5,k6,k7,k8}
   ==>
   ={res}.
proof.
  proc => /=.
  inline M.double_quarter_round_x1.
  interleave{1} [1:9] [16:9] [31:9] [46:9] [61:9] [76:9] [91:9] [106:9] 1 .
  interleave{1} [73:1] [79:1] [85:1] [91:1] [97:1] [103:1] [109:1] [115:1] 5.
  wp.
  inline{2} M.line_x1_8 M.line_2_x1_8. 
  wp; do !(call eq_line); wp => /=.
  do !(do !call eq_line_2; wp => /=).
  do !(call eq_line); wp => /=; skip => />.
qed.

axiom order_rw (t:W32.t Array16.t) (i j:int) (wi wj) : i < j =>
   t.[j <- wj].[i <- wi] = t.[i <- wi].[j <- wj].

axiom order_eq_rw (t:W32.t Array16.t) (i j:int) (wi wj) : i = j =>
   t.[j <- wj].[i <- wi] = t.[i <- wi].

(* hint simplify (order_rw, order_eq_rw). *)
       
equiv eq_body_x8 : ChaCha20_pavx2_cf.M.body_x8 ~ M.body_x8 : 
   is_incr_count8 st_1{1} st1{2} st2{2} st3{2} st4{2} st5{2} st6{2} st7{2} st8{2} ==>
   is_incr_count8 res{1}.`1 
    res{2}.`9 res{2}.`10 res{2}.`11 res{2}.`12 res{2}.`13 res{2}.`14 res{2}.`15 res{2}.`16 /\
   res{1}.`2 = res{2}.`1 /\
   res{1}.`3 = res{2}.`2 /\
   res{1}.`4 = res{2}.`3 /\
   res{1}.`5 = res{2}.`4 /\
   res{1}.`6 = res{2}.`5 /\
   res{1}.`7 = res{2}.`6 /\
   res{1}.`8 = res{2}.`7 /\
   res{1}.`9 = res{2}.`8.
proof.
  proc => /=.
  swap{1} 3 -2, {1} 6 -4, {1} 9 -6, {1} 12 -8, {1} 15 -10, {1} 18 -12, {1} 21 -14. 
  interleave{1} [8:1] [10:1] [12:1] [14:1] [16:1] [18:1] [20:1] [22:1] 2.
  seq 7 0 : (is_incr_count8 st_1{1} st1{2} st2{2} st3{2} st4{2} st5{2} st6{2} st7{2} st8{2} /\
             st_1{1} = st1{2} /\ st_2{1} = st2{2} /\ st_3{1} = st3{2} /\ st_4{1} = st4{2} /\ 
             st_5{1} = st5{2} /\ st_6{1} = st6{2} /\ st_7{1} = st7{2} /\ st_8{1} = st8{2}).
  + by inline ChaCha20_pref.M.increment_counter;wp; skip; rewrite /is_incr_count8 => />.
  seq 8 1 : (#pre /\ 
             k_1{1} = k1{2} /\ k_2{1} = k2{2} /\ k_3{1} = k3{2} /\ k_4{1} = k4{2} /\
             k_5{1} = k5{2} /\ k_6{1} = k6{2} /\ k_7{1} = k7{2} /\ k_8{1} = k8{2}).
  + conseq |>.
    transitivity*{1} {
      k_1 <@ M.rounds_x1(st_1);
      k_2 <@ M.rounds_x1(st_2);
      k_3 <@ M.rounds_x1(st_3);
      k_4 <@ M.rounds_x1(st_4);
      k_5 <@ M.rounds_x1(st_5);
      k_6 <@ M.rounds_x1(st_6);
      k_7 <@ M.rounds_x1(st_7);
      k_8 <@ M.rounds_x1(st_8);
    }. + smt(). + done.
    by do 8! call eq_rounds_x1; skip => />.
    inline M.rounds_x1.
    transitivity*{1} {
      (k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8) <- 
        (st_1, st_2, st_3, st_4, st_5, st_6, st_7, st_8);
      c <- 0;
      while(c < 10) {
        k_1 <@ M.column_round_x1(k_1);  
        k_1 <@ M.diagonal_round_x1(k_1);  
        k_2 <@ M.column_round_x1(k_2);  
        k_2 <@ M.diagonal_round_x1(k_2);  
        k_3 <@ M.column_round_x1(k_3);  
        k_3 <@ M.diagonal_round_x1(k_3);  
        k_4 <@ M.column_round_x1(k_4);   
        k_4 <@ M.diagonal_round_x1(k_4);   
        k_5 <@ M.column_round_x1(k_5);   
        k_5 <@ M.diagonal_round_x1(k_5);   
        k_6 <@ M.column_round_x1(k_6);   
        k_6 <@ M.diagonal_round_x1(k_6);   
        k_7 <@ M.column_round_x1(k_7);   
        k_7 <@ M.diagonal_round_x1(k_7);   
        k_8 <@ M.column_round_x1(k_8);
        k_8 <@ M.diagonal_round_x1(k_8);
        c <- c + 1;
      }
    }. + smt(). + done.
    + interleave{1} [1:1] [5:1] [9:1] [13:1] [17:1] [21:1] [25:1] [29:1] 1.
      interleave{1} [9:2] [12:2] [15:2] [18:2] [21:2] [24:2] [27:2] [30:2] 1.
      wp; do 8! unroll for{1} ^while.
      interleave{1} [9:3] [40:3] [71:3] [102:3] [133:3] [164:3] [195:3] [226:3] 10.
      by unroll for{2} ^while; sim.
    inline M.rounds_x8;wp.
    while (={c} /\ #post);last by auto.
    wp; conseq />.
    interleave {1} [1:1] [3:1] [5:1] [7:1] [9:1] [11:1] [13:1] [15:1] 1.
    seq 8 1: (#post).
    + inline M.column_round_x8 M.column_round_x1.
      interleave{1} [1:1] [5:1] [9:1] [13:1] [17:1] [21:1] [25:1] [29:1] 1.
      interleave{1} [9:1] [12:1] [15:1] [18:1] [21:1] [24:1] [27:1] [30:1] 1.
      interleave{1} [17:1] [19:1] [21:1] [23:1] [25:1] [27:1] [29:1] [31:1] 1.
      wp. sp.
      transitivity*{1}{
        (k7,k8,k9,k10,k11,k12,k13,k14) <@ M.double_quarter_round_x1_8
          (k7,k8,k9,k10,k11,k12,k13,k14, 0, 4, 8, 12, 2, 6, 10, 14);
        (k7,k8,k9,k10,k11,k12,k13,k14) <@ M.double_quarter_round_x1_8
          (k7,k8,k9,k10,k11,k12,k13,k14, 1, 5, 9, 13, 3, 7, 11, 15);
      }. + smt(). + done. 
      + inline M.double_quarter_round_x1_8.
        by do !(wp; call (_:true) => /=; 1: by sim); wp; skip => />.
      by do 2! call eq_double_quarter_round_x1_x8; skip.
    inline M.diagonal_round_x8 M.diagonal_round_x1.
    interleave{1} [1:1] [5:1] [9:1] [13:1] [17:1] [21:1] [25:1] [29:1] 1.
    interleave{1} [9:1] [12:1] [15:1] [18:1] [21:1] [24:1] [27:1] [30:1] 1.
    interleave{1} [17:1] [19:1] [21:1] [23:1] [25:1] [27:1] [29:1] [31:1] 1.
    wp. sp.
    transitivity*{1}{
      (k7,k8,k9,k10,k11,k12,k13,k14) <@ M.double_quarter_round_x1_8
        (k7,k8,k9,k10,k11,k12,k13,k14, 1, 6, 11, 12, 0, 5, 10, 15);
      (k7,k8,k9,k10,k11,k12,k13,k14) <@ M.double_quarter_round_x1_8
        (k7,k8,k9,k10,k11,k12,k13,k14, 2, 7, 8, 13, 3, 4, 9, 14);
    }. + smt(). + done. 
    + inline M.double_quarter_round_x1_8.
      by do !(wp; call (_:true) => /=; 1: by sim); wp; skip => />.
    by do 2! call eq_double_quarter_round_x1_x8; skip.
  seq 8 1 : (#pre).  
  + by conseq />; inline M.sum_states_x8; sim.  
  by conseq />; inline *; wp; skip; rewrite /is_incr_count8 => />.
qed.

equiv eq_chacha20_more_than_256 : ChaCha20_pavx2_cf.M.chacha20_more_than_256 ~ M.chacha20_more_than_256 :
   ={output, plain, len, key, nonce, counter, Glob.mem} ==> 
   ={Glob.mem}.
proof.
  proc => /=.
  seq 1 1 : (={output, plain, len, Glob.mem} /\ 
             is_incr_count8 st_1{1} st1{2} st2{2} st3{2} st4{2} st5{2} st6{2} st7{2} st8{2}).
  + conseq />; inline M.init_x8; wp.
    call (_: ={Glob.mem}); 1: by sim.
    by wp; skip => />.
  transitivity* {2} {
    while (512 <= len) {                          
      (k1, k2, k3, k4, k5, k6, k7, k8, st1, st2, st3, st4, st5, st6, st7, st8) <@ 
        M.body_x8(st1, st2, st3, st4, st5, st6, st7, st8);
      (output, plain, len) <@ ChaCha20_pavx2_cf.M.store_x8(output, plain, len, 
                                                           k1, k2, k3, k4, k5, k6, k7, k8);
    }
    if (0 < len) {   
      (k1, k2, k3, k4, k5, k6, k7, k8, st1, st2, st3, st4, st5, st6, st7, st8) <@ 
        M.body_x8(st1, st2, st3, st4, st5, st6, st7, st8);                                  
      ChaCha20_pavx2_cf.M.store_x8_last(output, plain, len,
                                        k1, k2, k3, k4, k5, k6, k7, k8);
    }
  }; [1:smt () |2: done]; last first.
  + seq 1 1 : (#pre).
    + while (#pre); last by auto.
      inline [-tuple] M.body_x8.  
      by swap{2} 3 1; sim.
    if => //.
    by inline [-tuple] M.increment_counter_x8 M.body_x8; sim. 
  seq 1 1 : (#pre).
  + while (#pre); last by auto.
    call (_: ={Glob.mem}) => /=; 1:sim. 
    by call eq_body_x8; skip;rewrite /is_incr_count8 => |> &2 _ ??? ->.
  if => //.
  call (_: ={Glob.mem}) => /=; 1:sim. 
  by call eq_body_x8; skip;rewrite /is_incr_count8 => |> &2 _ ??? ->.
qed.

equiv eq_chacha20_avx2 : ChaCha20_pavx2_cf.M.chacha20_avx2 ~ M.chacha20_avx2 :
   ={output, plain, len, key, nonce, counter, Glob.mem} ==> 
   ={Glob.mem}.
proof.
  proc => /=.
  if => //; 1: by call eq_chacha20_less_than_257; auto.
  by call eq_chacha20_more_than_256;auto.  
qed.

equiv eq_pref_pavx2_chacha20 : ChaCha20_pref.M.chacha20_ref ~ M.chacha20_avx2 :
   ={output, plain, len, key, nonce, counter, Glob.mem} /\ 0 <= len{1} ==> 
   ={Glob.mem}. 
proof.
  transitivity ChaCha20_pavx2_cf.M.chacha20_avx2 
    (={output, plain, len, key, nonce, counter, Glob.mem} /\ 0 <= len{1} ==> ={Glob.mem})
    (={output, plain, len, key, nonce, counter, Glob.mem} ==> ={Glob.mem}).
  + smt(). + done.
  + by apply pref_pavx2_cf_chacha20.
  by apply eq_chacha20_avx2.
qed.



  

