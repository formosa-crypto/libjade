require import AllCore List Int IntDiv CoreMap  LoopTransform.
import IterOp.
require import Array16.
require import WArray64.
require import ChaCha20_pref ChaCha20_pref_proof.

from Jasmin require import JModel.

module M = {
      
  proc store_x2 (output plain len: int, k_1 k_2: W32.t Array16.t) : int * int * int = {
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_1);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_2);
    return (output, plain, len);
  }
  
  proc store_x2_last (output plain len: int, k_1 k_2 : W32.t Array16.t) : unit = {
    var r:W32.t Array16.t;
    r <- k_1;
    if (64 <= len) {
      (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, r);
      r <- k_2;
    }
    ChaCha20_pref.M.store (output, plain, len, r);
  }
  
  proc store_x4 (output plain len: int, k_1 k_2 k_3 k_4: W32.t Array16.t) : int * int * int = {
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_1);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_2);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_3);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_4);
    return (output, plain, len);
  }
  
  proc store_x4_last (output plain len: int, k_1 k_2 k_3 k_4: W32.t Array16.t) : unit = {
    var r_1:W32.t Array16.t;
    var r_2:W32.t Array16.t;
    r_1 <- k_1;
    r_2 <- k_2;
    if (128 <= len) {
      (output, plain, len) <@ store_x2 (output, plain, len, r_1, r_2);
      r_1 <- k_3;
      r_2 <- k_4;
    } 
    store_x2_last (output, plain, len, r_1, r_2);
  }
  
  proc store_x8 (output plain len: int, k_1 k_2 k_3 k_4 k_5 k_6 k_7 k_8: W32.t Array16.t) : int * int * int = {
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_1);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_2);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_3);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_4);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_5);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_6);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_7);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k_8);
    return (output, plain, len);
  }
  
  proc store_x8_last (output plain len: int, k_1 k_2 k_3 k_4 k_5 k_6 k_7 k_8: W32.t Array16.t) : unit = {
    var r_1:W32.t Array16.t;
    var r_2:W32.t Array16.t;
    var r_3:W32.t Array16.t;
    var r_4:W32.t Array16.t;
    r_1 <- k_1;
    r_2 <- k_2;
    r_3 <- k_3;
    r_4 <- k_4;
    if (256 <= len) {
      (output, plain, len) <@ store_x4 (output, plain, len, r_1, r_2, r_3, r_4);
      r_1 <- k_5;
      r_2 <- k_6;
      r_3 <- k_7;
      r_4 <- k_8;
    }
    store_x4_last (output, plain, len, r_1, r_2, r_3, r_4);
  }  
  
  proc body_x8(st_1: W32.t Array16.t) = {
    var st_2, st_3, st_4, st_5, st_6, st_7, st_8 : W32.t Array16.t;
    var k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8 : W32.t Array16.t;

    k_1 <@ ChaCha20_pref.M.rounds (st_1);
    k_1 <@ ChaCha20_pref.M.sum_states (k_1, st_1);
    st_2 <@ ChaCha20_pref.M.increment_counter (st_1);

    k_2 <@ ChaCha20_pref.M.rounds (st_2);
    k_2 <@ ChaCha20_pref.M.sum_states (k_2, st_2);
    st_3 <@ ChaCha20_pref.M.increment_counter (st_2);
  
    k_3 <@ ChaCha20_pref.M.rounds (st_3);
    k_3 <@ ChaCha20_pref.M.sum_states (k_3, st_3);
    st_4 <@ ChaCha20_pref.M.increment_counter (st_3);

    k_4 <@ ChaCha20_pref.M.rounds (st_4);
    k_4 <@ ChaCha20_pref.M.sum_states (k_4, st_4);
    st_5 <@ ChaCha20_pref.M.increment_counter (st_4);

    k_5 <@ ChaCha20_pref.M.rounds (st_5);
    k_5 <@ ChaCha20_pref.M.sum_states (k_5, st_5);
    st_6 <@ ChaCha20_pref.M.increment_counter (st_5);

    k_6 <@ ChaCha20_pref.M.rounds (st_6);
    k_6 <@ ChaCha20_pref.M.sum_states (k_6, st_6);
    st_7 <@ ChaCha20_pref.M.increment_counter (st_6);
  
    k_7 <@ ChaCha20_pref.M.rounds (st_7);
    k_7 <@ ChaCha20_pref.M.sum_states (k_7, st_7);
    st_8 <@ ChaCha20_pref.M.increment_counter (st_7);

    k_8 <@ ChaCha20_pref.M.rounds (st_8);
    k_8 <@ ChaCha20_pref.M.sum_states (k_8, st_8);
    st_1 <@ ChaCha20_pref.M.increment_counter (st_8);
    return (st_1, k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8);
  }
     
  proc chacha20_more_than_256 (output plain len: int, key nonce: int, counter:W32.t) : unit = {
    
    var st_1:W32.t Array16.t;
    var k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8 : W32.t Array16.t;

    st_1 <@ ChaCha20_pref.M.init (key, nonce, counter);
    
    while (512 <= len) {
      (st_1, k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8) <@ body_x8(st_1);
      (output, plain, len) <@ store_x8 (output, plain, len, k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8);
    }
    if (0 < len) {
      (st_1, k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8) <@ body_x8(st_1);
      store_x8_last (output, plain, len, k_1, k_2, k_3, k_4, k_5, k_6, k_7, k_8);
    } 
  }

  proc chacha20_less_than_128 (output plain len: int, st_1 : W32.t Array16.t) : unit = {
    var k_1, k_2, st_2 :W32.t Array16.t;
      
    k_1 <@ ChaCha20_pref.M.rounds (st_1);
    k_1 <@ ChaCha20_pref.M.sum_states (k_1, st_1);
    st_2 <@ ChaCha20_pref.M.increment_counter (st_1);

    k_2 <@ ChaCha20_pref.M.rounds (st_2);
    k_2 <@ ChaCha20_pref.M.sum_states (k_2, st_2);

    store_x2_last (output, plain, len, k_1, k_2);
  }

  proc chacha20_between_128_255 (output plain len: int, st_1 : W32.t Array16.t) : unit = {
    var k_1, k_2, k_3, k_4, st_2, st_3, st_4 : W32.t Array16.t;

    k_1 <@ ChaCha20_pref.M.rounds (st_1);
    k_1 <@ ChaCha20_pref.M.sum_states (k_1, st_1);
    st_2 <@ ChaCha20_pref.M.increment_counter (st_1);

    k_2 <@ ChaCha20_pref.M.rounds (st_2);
    k_2 <@ ChaCha20_pref.M.sum_states (k_2, st_2);
    st_3 <@ ChaCha20_pref.M.increment_counter (st_2);
  
    k_3 <@ ChaCha20_pref.M.rounds (st_3);
    k_3 <@ ChaCha20_pref.M.sum_states (k_3, st_3);
    st_4 <@ ChaCha20_pref.M.increment_counter (st_3);

    k_4 <@ ChaCha20_pref.M.rounds (st_4);
    k_4 <@ ChaCha20_pref.M.sum_states (k_4, st_4);

    (output, plain, len) <@ store_x2 (output, plain, len, k_1, k_2);
    store_x2_last (output, plain, len, k_3, k_4);

  }

  proc chacha20_less_than_257 (output plain len: int, key nonce: int, counter:W32.t) : unit = {
    var st_1:W32.t Array16.t;
    var k1_1:W32.t Array16.t;
    var st_2:W32.t Array16.t;
    var k1_2:W32.t Array16.t;
    var st_3:W32.t Array16.t;
    st_1 <@ ChaCha20_pref.M.init (key, nonce, counter);
    if (128 < len) {
      chacha20_between_128_255(output, plain, len, st_1);
    } else {
      chacha20_less_than_128 (output, plain, len, st_1);
    }
  }

  proc chacha20_avx2 (output plain len: int, key nonce: int, counter:W32.t) : unit = {
    if (len < 257) {
      chacha20_less_than_257 (output, plain, len, key, nonce, counter);
    } else {
      chacha20_more_than_256 (output, plain, len, key, nonce, counter);
    }
  }
 
  (* ------------------------------------------------------------------------------------- *)
  (* Usefull functions to help the proof                                                   *)
  proc chacha20_body (st:W32.t Array16.t) : W32.t Array16.t * W32.t Array16.t = {
    
    var k, st1:W32.t Array16.t;
    k <@ ChaCha20_pref.M.rounds (st);
    k <@ ChaCha20_pref.M.sum_states (k, st);
    st1 <@ ChaCha20_pref.M.increment_counter (st);
    return (k, st1);
  }

  proc chacha20_ref_loop (output plain len: int, st_1 : W32.t Array16.t) : unit = {
     var k:W32.t Array16.t;
     while (0 < len) {
      (k, st_1) <@ chacha20_body(st_1);
      (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k);
    }
    return ();
  }

  proc chacha20_ref (output plain len: int, key nonce: int, counter:W32.t) : unit = {
    var st, k:W32.t Array16.t; (* Do not remove k *)
    st <@ ChaCha20_pref.M.init (key, nonce, counter);
    chacha20_ref_loop(output, plain, len, st);
  }

  proc chacha20_between_128_255_1 (output plain len: int, st : W32.t Array16.t) : unit = {
    var k_1, k_2, st_2, st_3 : W32.t Array16.t;
    (k_1, st_2) <@ chacha20_body(st);
    (k_2, st_3) <@ chacha20_body(st_2);
    (output, plain, len) <@ store_x2 (output, plain, len, k_1, k_2);
    chacha20_less_than_128(output, plain, len, st_3);
  }

  (* ------------------------------------------------------------------------------------- *)

}.

hoare store_len len0 : ChaCha20_pref.M.store : 
  len = len0 /\ 64 <= len ==> res.`3 = len0 - 64.
proof. 
  proc; inline *; wp => /=.
  while (0 <= i <= 64).
  + wp; skip; smt().
  wp; conseq (_:true)=> // /#. 
qed.

hoare store_len_le : ChaCha20_pref.M.store : 
  0 <= len <= 64 ==> res.`3 = 0.
proof. 
  proc; inline *; wp => /=.
  while (0 <= i <= min 64 len).
  + wp; skip; smt().
  wp; conseq (_:true)=> // /#. 
qed.

phoare store0_ll mem0 : [ChaCha20_pref.M.store : len = 0 /\ Glob.mem = mem0 ==> Glob.mem = mem0] = 1%r.
proof. 
  proc; inline *; wp => /=.
  do 2! (rcondf ^while; 1: by auto); auto.
qed.

phoare sum_states_ll : [ChaCha20_pref.M.sum_states : true ==> true] = 1%r.
proof. 
  islossless.
  while (true) (16-i) => //; auto => /#.
qed.

phoare rounds_ll : [ChaCha20_pref.M.rounds : true ==> true] = 1%r.
proof.
  islossless.
  while (true) (10-c); 2: skip => /#.
  by move=> z; wp; conseq (_: true); [smt () | islossless].
qed.  

phoare incr_ll : [ChaCha20_pref.M.increment_counter : true ==> true] = 1%r.
proof. islossless. qed.

phoare chacha20_body_ll : [M.chacha20_body : true ==> true] = 1%r.
proof.
  proc; call incr_ll; call sum_states_ll; call rounds_ll; auto.
qed.

equiv pref_store len0: ChaCha20_pref.M.store ~ ChaCha20_pref.M.store : 
   ={output, plain, len, k,Glob.mem} /\ len{1} =len0 /\ 0 <= len{1} 
   ==> 
   ={Glob.mem, res} /\ res{1}.`3 = len0 - min 64 len0.
proof.
  proc; inline *; wp => /=. 
  while ((0 <= i <= min 64 len){1} /\ ={i, output, plain, len, k8, Glob.mem}).
  + wp; skip => /> /#.
  wp; conseq (_: ={k8}); [smt() | sim].
qed.

equiv pref_store64 len0 : ChaCha20_pref.M.store ~ ChaCha20_pref.M.store : 
  ={output, plain, len, k, Glob.mem} /\ (len = len0 /\ 64 <= len){1} 
  ==>
  ={res, Glob.mem} /\ res{1}.`3 = len0 - 64.
proof. conseq (pref_store len0); smt(). qed.

equiv pref_store_last : ChaCha20_pref.M.store ~ ChaCha20_pref.M.store : 
  ={output, plain, len, k, Glob.mem} ==> ={Glob.mem}.
proof. proc; inline *; wp => /=; sim. qed.

equiv pref_pavx2_cf_less_than_128: 
  M.chacha20_ref_loop ~ M.chacha20_less_than_128 :
  ={Glob.mem, output, plain, len, st_1} /\ (0 <= len <= 128){1}
  ==>
  ={Glob.mem}.
proof.
  proc => /=; inline M.store_x2_last.
  case : (64 <= len{1}).
  + rcondt{2} ^if; 1: by move=> &m; wp; conseq (_:true) => // &m' />.
    rcondt{1} ^while; 1: by move=> &m;skip => &m' /> /#.
    swap{2} [11..12] -1. swap{2} [6..11] -2.
    seq 2 9 : (={Glob.mem} /\ output{1} = output0{2} /\ plain{1} = plain0{2} /\ len{1} = len0{2} /\
               st_1{1} = st_2{2} /\ 0 <= len{1} <= 64).
    + ecall (pref_store64 len{1});wp.
      inline M.chacha20_body;wp => /=.
      conseq (_: k0{1} = k_1{2} /\ st1{1} = st_2{2}); 1: smt().
      by sim.
    case (0 < len{1}).
    + rcondt{1} ^while; 1: by auto.
      rcondf{1} ^while.
      + move=> &m; call store_len_le; conseq (_:true) => // /#.
      by call pref_store_last; inline M.chacha20_body ChaCha20_pref.M.increment_counter; sim.
    rcondf{1} ^while; 1: by auto.
    ecall{2} (store0_ll Glob.mem{2}).
    by wp; call{2} sum_states_ll; call{2} rounds_ll; skip => /> /#.
  rcondf{2} ^if.
  + by move=> &m; wp; conseq (_: true).
  case (0 < len{1}).
  + rcondt{1} ^while; 1: auto.
    rcondf{1} ^while.
    + by move=> &m; call store_len_le; conseq (_: true) => // /#.
    call pref_store_last; wp => /=.
    call{2} sum_states_ll; call{2} rounds_ll.
    by inline M.chacha20_body; sim.
  rcondf{1} ^while; 1: by auto.
  ecall{2} (store0_ll Glob.mem{2}).
  inline ChaCha20_pref.M.increment_counter.
  do 2! (wp; call{2} sum_states_ll; call{2} rounds_ll); skip => /> /#.
qed.

equiv pref_pavx2_cf_between_128_255 : 
  M.chacha20_ref_loop ~ M.chacha20_between_128_255 :
  ={output, plain, len, Glob.mem, st_1} /\ 128 <= len{2} <= 256 
  ==>
  ={Glob.mem}.
proof.
  proc => /=.
  transitivity{1}
    { (k, st_1) <@ M.chacha20_body(st_1);
      (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k);
      (k, st_1) <@ M.chacha20_body(st_1);
      (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k);
      M.chacha20_ref_loop(output, plain, len, st_1);
    }
    (={output, plain, len, Glob.mem, st_1} /\ 128 <= len{2} <= 256 ==> ={Glob.mem})
    (={output, plain, len, Glob.mem, st_1} /\ 128 <= len{2} <= 256 ==> ={Glob.mem}).
  + smt(). + done.
  + inline M.chacha20_ref_loop.
    rcondt{1} 1; 1: by auto => ? /#.
    rcondt{1} 3; 2: by sim.
    by move=> ?; sp; ecall (store_len len); conseq (_:true) => // /> /#.
  swap{2} 12 -6.
  seq 4 7: (={Glob.mem, output, plain, len} /\ st_1{1} = st_3{2} /\ 0 <= len{1} <= 128).
  + inline M.chacha20_body M.store_x2.
    swap{2} 14 -4; wp.
    ecall (pref_store64 len{1});wp => /=.
    swap{1} 6 4.
    ecall (pref_store64 len{1});swap{2} [6..8] 2; wp => /=.
    conseq (_: st10{1} = st_3{2} /\ k{1} = k_10{2} /\ k1{1} = k_2{2}); 1: smt().
    by sim.
  transitivity{2}
    { M.chacha20_less_than_128(output, plain, len, st_3); }
    (={Glob.mem, output, plain, len} /\ st_1{1} = st_3{2} /\ 0 <= len{1} <= 128 ==> ={Glob.mem})
    (={output, plain, len, Glob.mem, st_3} /\ 0 <= len{2} <= 128 ==> ={Glob.mem}).
  + smt(). + done.
  + by call pref_pavx2_cf_less_than_128; auto.
  by inline{1} M.chacha20_less_than_128; sim.
qed.

equiv pref_pavx2_cf_less_than_257 :  M.chacha20_ref ~ M.chacha20_less_than_257 :
  ={output, plain, len, key, nonce,counter, Glob.mem} /\ 0 <= len{2}  <= 256
  ==>
  ={Glob.mem}.
proof.
  proc => /=. 
  seq 1 1 : (#pre /\ st{1} = st_1{2}); 1: by sim |>.
  if{2}; [call pref_pavx2_cf_between_128_255 | call pref_pavx2_cf_less_than_128];
    skip => /> /#.
qed.

clone import ExactIter as Loop0 with
   type t <- int * int * int * W32.t Array16.t,
   op c <- 8,
   op step <- 64
   proof * by done.

module Body = {
  proc body (t: int * int * int * W32.t Array16.t, i:int) = {
    var output, plain, len, k, st;
    (output, plain, len, st) <- t;
    (k, st) <@ M.chacha20_body(st);
    (output, plain, len) <@ ChaCha20_pref.M.store (output, plain, len, k);
    return (output, plain, len, st);
  }
}.

equiv pref_incr: ChaCha20_pref.M.increment_counter ~ ChaCha20_pref.M.increment_counter : 
  ={st} ==> ={res}.
proof. sim. qed.
  
equiv pref_sum : ChaCha20_pref.M.sum_states ~ ChaCha20_pref.M.sum_states : ={k,st} ==> ={res}.
proof. sim. qed.

equiv pref_rounds : ChaCha20_pref.M.rounds ~ ChaCha20_pref.M.rounds : ={k} ==> ={res}.
proof. sim. qed.

equiv pref_pavx2_cf_more_than_256 : M.chacha20_ref ~ M.chacha20_more_than_256 :
  ={output, plain, len, key, nonce,counter, Glob.mem} /\ 256 < len{2}
  ==>
  ={Glob.mem}.
proof.
  proc => /=.
  seq 1 1 : (  ={output, plain, len, Glob.mem} /\ st{1} = st_1{2} /\ 256 < len{2}); 1: by sim |>.
  transitivity {1} { ILoop(Body).loop1((output, plain, len, st), len); }
    (={output, plain, len, Glob.mem, st} /\ 0 <= len{1} ==> ={Glob.mem}) 
    (={output, plain, len, Glob.mem} /\ 0 <= len{1} /\ st{1} = st_1{2} ==> ={Glob.mem}).
  + smt(). + done.
  + inline M.chacha20_ref_loop ILoop(Body).loop1 Body.body.
    while (={Glob.mem} /\ (output0, plain0, len0, st_1){1} = t{2} /\ 
            len0{1} = (if i <= n then n - i else 0){2}); 2: by wp;skip => />.
    wp; sp; ecall (pref_store len0{1}) => /=.
    by conseq (_: ={Glob.mem, k0} /\ st_1{1} = st0{2}); [smt() | sim].
  transitivity*{1} { ILoop(Body).loopc((output, plain, len, st), len); }.
  + smt(). + done. + by call (Iloop1_loopc Body); skip.
  inline ILoop(Body).loopc.
  seq 4 1 : (={Glob.mem} /\ t{1} = (output,plain,len,st_1){2} /\ len{2} = (n - i){1} /\ 0 <= (n - i){1} < 512).
  + while ( #[/:-2]post /\ (0 <= i <= n){1}); last by auto => /#.
    inline [-tuple] M.body_x8 M.store_x8 Body.body.
    swap{2} [44..46] -43.
    interleave{2} [5:3] [30:1] [39:1] [47:1] [55:1] 8.
    inline M.chacha20_body; unroll for {1} 2;wp.
    do 8! (ecall (pref_store64 len0{1});
      wp; call pref_incr; call pref_sum; call pref_rounds;wp => /=); skip => /> /#.
  if{2}; last by rcondf{1} ^while; auto => /#.
  transitivity * {2} {
    if (256 <= len) {
      k_1 <@ ChaCha20_pref.M.rounds (st_1);
      k_1 <@ ChaCha20_pref.M.sum_states (k_1, st_1);
      st_1 <@ ChaCha20_pref.M.increment_counter (st_1);
      
      k_2 <@ ChaCha20_pref.M.rounds (st_1);
      k_2 <@ ChaCha20_pref.M.sum_states (k_2, st_1);
      st_1 <@ ChaCha20_pref.M.increment_counter (st_1);
      
      k_3 <@ ChaCha20_pref.M.rounds (st_1);
      k_3 <@ ChaCha20_pref.M.sum_states (k_3, st_1);
      st_1 <@ ChaCha20_pref.M.increment_counter (st_1);
      
      k_4 <@ ChaCha20_pref.M.rounds (st_1);
      k_4 <@ ChaCha20_pref.M.sum_states (k_4, st_1);
      st_1 <@ ChaCha20_pref.M.increment_counter (st_1);
      (output, plain, len) <@  M.store_x4(output, plain, len, k_1, k_2, k_3, k_4);
    }
    if (128 <= len) {
      M.chacha20_between_128_255(output, plain, len, st_1);
    } else {
      M.chacha20_less_than_128 (output, plain, len, st_1);
    }
  }; [1: smt()| 2: done]; last first.
  + inline [-tuple] M.store_x8_last M.body_x8 M.chacha20_between_128_255 M.chacha20_less_than_128.
    interleave{2} [2:3] [27:1] [36:1] [47:1] 8.
    interleave{2} [2:6] [55:1] 4.
    if{1}.  
    + rcondt{2} ^if; 1: by auto; conseq (_:true).
      swap{2} [56..59] -26.
      seq 13 33 : (={Glob.mem} /\ output{1} = output0{2} /\ plain{1} = plain0{2} /\ len{1} = len0{2} /\ st_1{1} = st_5{2}); 1: by sim.
      inline M.store_x4_last; if{1}.
      + rcondt{2} ^if;1: by auto; conseq (_:true).
        by inline{2} (4)ChaCha20_pref.M.increment_counter; sim. 
      rcondf{2} ^if;1: by auto; conseq (_:true).
      sim; do 2!(call{2} incr_ll; call{2} sum_states_ll; call{2} rounds_ll;wp).
      by call{2} incr_ll;sim.
    rcondf{2} ^if; 1: by auto; conseq (_:true).  
    swap{2} [30..55] 4.
    do 4! (wp;call{2} incr_ll; call{2} sum_states_ll; call{2} rounds_ll).
    inline M.store_x4_last; if{1}.
    + rcondt{2} ^if;1: by auto; conseq (_:true).
      by inline{2} (4)ChaCha20_pref.M.increment_counter; sim. 
    rcondf{2} ^if;1: by auto; conseq (_:true).
    sim; do 2!(call{2} incr_ll; call{2} sum_states_ll; call{2} rounds_ll;wp).
    by call{2} incr_ll;sim.
  transitivity{2} { M.chacha20_ref_loop(output, plain, len, st_1); }
     (={Glob.mem} /\ t{1} = (output{2}, plain{2}, len{2}, st_1{2}) /\ len{2} = n{1} - i{1} /\ 0 <= len{2} ==> ={Glob.mem})
     (={Glob.mem, output, plain, len, st_1} /\ 0 <= len{1} < 512 ==> ={Glob.mem}).
  + smt(). + done.
  + inline M.chacha20_ref_loop Body.body.
    while (={Glob.mem} /\ (output0, plain0, len0, st_10){2} = t{1} /\ 
            len0{2} = (if i <= n then n - i else 0){1}); 2: by wp;skip => /> /#.
    sp; wp; ecall (pref_store len0{1}) => /=.
    by conseq (_: ={Glob.mem} /\ k0{1} = k{2} /\ st0{1} = st_10{2}); [smt() | sim].
  if{2}; last by if{2}; [call pref_pavx2_cf_between_128_255 | call pref_pavx2_cf_less_than_128]; skip => /> /#.
  inline M.chacha20_ref_loop; sp.
  rcondt{1} ^while; 1: auto=> /#.
  do 3! (rcondt{1} ^while; 1: by move=> &m; do !(ecall (store_len len0); call (_:true) => //=); skip => /#).
  seq 8 13 : ((={Glob.mem} /\ (output0, plain0, len0, st_10){1} = (output, plain, len, st_1){2} /\ 0 <= len0{1} < 256)). 
  + inline [-tuple] M.store_x4 Body.body M.chacha20_body.
    swap{2} [13..15] -12; interleave{2} [4:3] [16:1] [20:1] 4.
    do 4! (wp; ecall (pref_store64 len0{1});wp; call pref_incr; call pref_sum; call pref_rounds => /=).
    by wp; skip => /> * /#. 
  transitivity * {1} { M.chacha20_ref_loop(output0, plain0, len0, st_10); }.
  + smt(). + done. + by inline M.chacha20_ref_loop; sim.
  by if{2}; [call pref_pavx2_cf_between_128_255 | call pref_pavx2_cf_less_than_128]; skip => /> /#.  
qed.

equiv pref_pavx2_cf_chacha20 : ChaCha20_pref.M.chacha20_ref ~ M.chacha20_avx2 :
  ={output, plain, len, key, nonce,counter, Glob.mem} /\ 0 <= len{1} 
  ==>
  ={Glob.mem}. 
proof. 
  transitivity M.chacha20_ref
    (={output, plain, len, key, nonce,counter, Glob.mem} ==>  ={Glob.mem})
    (={output, plain, len, key, nonce,counter, Glob.mem} /\ 0 <= len{1} ==>  ={Glob.mem}).
  + smt(). + done.
  + proc; inline M.chacha20_ref_loop M.chacha20_body. 
    while ((output, plain, len, st, Glob.mem){1} = (output0, plain0, len0, st_1, Glob.mem){2}).
    + by swap{1} -1; sim.
    by wp; conseq (_: ={st}) => />; sim.
  proc *; inline M.chacha20_avx2.
  sp; if{2}.
  + by call pref_pavx2_cf_less_than_257; skip => /> /#.
  by call pref_pavx2_cf_more_than_256; skip => /> /#.
qed.


