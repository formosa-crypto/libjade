require import AllCore List Int IntDiv LoopTransform.
import IterOp.
require import ChaCha20_Spec ChaCha20_pref ChaCha20_pref_proof ChaCha20_sref.
require import Array3 Array8 Array16.
require import WArray64.

from Jasmin require import JWord JModel.

(* ------------------------------------------------------------------------------- *)
(* We start by cloning ChaCha20_sref but using "int" instead of W64.t for pointer. *)
(* Compare to ChaCha20_pref we change the way of writting into memory              *)
theory ChaCha20_srefi.

module M = {
  include ChaCha20_pref.M [init, line, quarter_round, column_round, diagonal_round, round, rounds, sum_states, update_ptr, increment_counter]
  
  proc merge (lo hi: W32.t) : W64.t = {
    var w, aux : W64.t;
    w <- zeroextu64 hi;
    w <- w `<<` W8.of_int 32;
    aux <- zeroextu64 lo;
    w <- w `^` aux;
    return w;
  }

  proc store (output plain: address, len: int, k:W32.t Array16.t)  : int * int * int = {
    var kk:W64.t Array8.t;
    var kkt : W64.t;
    var i:int;

    kk <- witness;
    kkt <@ merge(k.[0], k.[1]); kk.[0] <- kkt;
    kk.[0] <- kk.[0] `^` loadW64 Glob.mem (plain + 8 * 0);
    kkt <@ merge(k.[2], k.[3]); kk.[1] <- kkt;
    kk.[1] <- kk.[1] `^` loadW64 Glob.mem (plain + 8 * 1);
    Glob.mem <- storeW64 Glob.mem (output + 8 * 0) kk.[0];
    i <- 2;
    while (i < 8) {
      kkt <@ merge(k.[2*i], k.[2*i +1]); kk.[i] <- kkt;
      kk.[i] <- kk.[i] `^` loadW64 Glob.mem (plain + 8 * i);
      Glob.mem <- storeW64 Glob.mem (output + 8 * (i - 1)) kk.[i - 1];
      i <- i + 1;
    }
    Glob.mem <- storeW64 Glob.mem (output + 8 * 7) kk.[7];
    (output, plain, len) <@ update_ptr (output, plain, len, 64);
    return (output, plain, len);
  }

  proc sum_states_store1 (output plain: address, len: int, k st:W32.t Array16.t)  : int * int * int = {
    k <@ sum_states (k, st);
    (output, plain, len) <@ store (output, plain, len, k);
    return (output, plain, len);
  }

  proc sum_states_store (output plain: address, len: int, k st:W32.t Array16.t)  : int * int * int = {
    var kk:W64.t Array8.t;
    var kkt : W64.t;
    var i:int;

    kk <- witness;
    k.[0] <- k.[0] + st.[0];
    k.[1] <- k.[1] + st.[1];
    kkt <@ merge(k.[0], k.[1]); kk.[0] <- kkt;
    kk.[0] <- kk.[0] `^` loadW64 Glob.mem (plain + 8 * 0);
    k.[2] <- k.[2] + st.[2];
    k.[3] <- k.[3] + st.[3];
    kkt <@ merge(k.[2], k.[3]); kk.[1] <- kkt;
    kk.[1] <- kk.[1] `^` loadW64 Glob.mem (plain + 8 * 1);
    Glob.mem <- storeW64 Glob.mem (output + 8 * 0) kk.[0];
    i <- 2;
    while (i < 8) {
      k.[2*i] <- k.[2*i] + st.[2*i];
      k.[2*i +1] <- k.[2*i + 1] + st.[2*i + 1];
      kkt <@ merge(k.[2*i], k.[2*i +1]); kk.[i] <- kkt;
      kk.[i] <- kk.[i] `^` loadW64 Glob.mem (plain + 8 * i);
      Glob.mem <- storeW64 Glob.mem (output + 8 * (i - 1)) kk.[i - 1];
      i <- i + 1;
    }
    Glob.mem <- storeW64 Glob.mem (output + 8 * 7) kk.[7];
    (output, plain, len) <@ update_ptr (output, plain, len, 64);
    return (output, plain, len);
  }
  
  proc store_last (output plain: address, len: int, k:W32.t Array16.t) : unit = {
    var len8, j:int;
    var t:W64.t;
    var pi:W8.t;

    len8 <- len %/ 8;
    j <- 0;
    while (j < len8) {
      t <- loadW64 Glob.mem (plain + 8 * j);
      t <- t `^` (get64 (WArray64.init32 (fun i => k.[i])) j);
      Glob.mem <- storeW64 Glob.mem (output + 8 * j) t;
      j <- j + 1;
    }
    j <- j * 8;
    
    while (j < len) {
      pi <- loadW8 Glob.mem (plain + j);
      pi <-  pi `^` get8 (WArray64.init32 (fun i => k.[i])) j;
      Glob.mem <- storeW8 Glob.mem (output + j) pi;
      j <- j + 1;
    }
    return ();
  }

  proc chacha20_ref (output plain:address, len:int, key nonce: address, counter:W32.t) : unit = {
    
    var st:W32.t Array16.t;
    var k:W32.t Array16.t;

    st <@ init (key, nonce, counter);    
    while (64 <= len) {
      k <@ rounds (st);
      (output, plain, len) <@ sum_states_store (output, plain, len, k, st);
      st <@ increment_counter (st);
    }
    if (0 < len) {
      k <@ rounds (st);
      k <@ sum_states (k, st);
      store_last (output, plain, len, k);
    }
  }   
}.

end ChaCha20_srefi.

hoare merge_spec lo0 hi0 : ChaCha20_srefi.M.merge : 
   lo = lo0 /\ hi = hi0 ==> res = W2u32.pack2 [lo0; hi0].
proof.
  proc => /=; wp; skip => />.
  apply W64.wordP=> i hi.
  rewrite /(`<<`) /=  W2u32.pack2wE hi /= !zeroextu64_bit W2u32.Pack.of_listE initiE 1:/# /= /#.
qed.

lemma get_storeW64E m p w j: 
    (storeW64 m p w).[j] = if p <= j < p + 8 then w \bits8 j - p else m.[j].
proof. rewrite storeW64E /= get_storesE /= /#. qed.

lemma storeW64_init32 (mem0 mem1:global_mem_t) (k:W32.t Array16.t) output plain i:
  inv_ptr output plain (8 * i) =>
  1 <= i <= 8 =>
  (forall (j : address),
    mem1.[j] =
      if in_range output (8 * (i - 1)) j then
        (init32 (fun (i0 : int) => k.[i0])).[j - output] `^` mem0.[plain + (j - output)]
      else mem0.[j]) =>
  (forall (j : address),
     (storeW64 mem1 (output + 8 * (i - 1))
        (pack2 [k.[2 * (i - 1)]; k.[2 * (i - 1) + 1]] `^` loadW64 mem0 (plain + 8 * (i - 1)))).[j] =
    if in_range output (8 * i) j then
      (init32 (fun (i0 : int) => k.[i0])).[j - output] `^` mem0.[plain + (j - output)]
    else mem0.[j]).
proof.
  move=> hinv hi hmem1 j.
  rewrite get_storeW64E.
  case _ : (_ <= j < _) => /= h3; last by rewrite hmem1 /#.
  have -> /=: in_range output (8 * i) j by smt().
  have hj': 0 <= j - (output + 8 * (i - 1)) < 8 by smt().
  congr.
  + by rewrite /init32 initiE 1:/# /= bits8_W2u32 W2u32.Pack.of_listE hj' /= initiE /#.
  rewrite /loadW64 /= pack8bE 1:/# initiE 1:/# /=;congr;ring.
qed.

hoare store_srefi_spec output0 plain0 len0 k0 mem0 : ChaCha20_srefi.M.store : 
  output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 
  64 <= len /\ inv_ptr output plain len 
  ==>
  res = (output0 + 64, plain0 + 64, len0 - 64) /\ 
  forall j, 
    Glob.mem.[j] =
      if in_range output0 64 j then
        let j = j - output0 in
        (init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j].
proof.
  proc; inline ChaCha20_srefi.M.update_ptr; wp.
  while (2 <= i <= 8 /\ inv_ptr output plain 64 /\ 
    kk.[i-1] = pack2 [k.[2*(i-1)]; k.[2*(i-1)+1]] `^` loadW64 mem0 (plain + 8 * (i-1)) /\
    forall j, 
      Glob.mem.[j] = 
      if in_range output (8 * (i-1)) j then 
        let j = j - output in
        (init32 (fun (i0 : int) => k.[i0])).[j] `^` mem0.[plain + j]
      else mem0.[j]).
  + wp; ecall (merge_spec (k.[2*i]){hr} (k.[2*i+1]){hr}); skip => /> &hr h1 h2 hinv hki hmem hi.
    split; 1:smt().
    have hi' : 0 <= i{hr} < 8 by smt().
    rewrite !Array8.get_setE 1..3:// /=.
    have -> /= : i{hr} - 1 <> i{hr} by smt().
    split.
    + congr.
      rewrite /loadW64;congr; apply W8u8.Pack.packP => l hl /=.
      rewrite !initiE 1,2:// /= hmem.
      by have -> : !in_range output{hr} (8 * (i{hr} - 1)) (plain{hr} + 8 * i{hr} + l) by smt().
    by rewrite hki;apply storeW64_init32 => // /#.
  wp; ecall (merge_spec (k.[2]){hr} (k.[3]){hr}).
  wp; ecall (merge_spec (k.[0]){hr} (k.[1]){hr}).
  wp; skip => /> hlen hinv; split.
  + split; 1:smt().  
    by have := storeW64_init32 mem0 mem0 k0 output0 plain0 1 _ _ _; 1,3:smt().
  move=> mem i0 kk h1 h2 h3 h4.
  have ->> /= -> hmem: i0 = 8 by smt().
  by apply (storeW64_init32 _ _ _ _ _ 8 h4 _ hmem).
qed.

phoare store_srefi_pspec output0 plain0 len0 k0 mem0 : 
  [ChaCha20_srefi.M.store : 
   output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 
   64 <= len /\ inv_ptr output plain len 
   ==>
   res = (output0 + 64, plain0 + 64, len0 - 64) /\ 
   forall j, 
    Glob.mem.[j] =
      if in_range output0 64 j then
        let j = j - output0 in
        (init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j]] = 1%r.
proof.
  conseq (_: true ==> true) (store_srefi_spec output0 plain0 len0 k0 mem0);1:done.
  proc; inline *;wp; while true (8-i); auto => /#.
qed.

equiv eq_sum_states_store_srefi : ChaCha20_srefi.M.sum_states_store1 ~ ChaCha20_srefi.M.sum_states_store :
  ={output, plain, len, k, st, Glob.mem} ==> ={res, Glob.mem}.
proof.
  proc => /=.
  seq 1 0 : (={output, plain, len, Glob.mem} /\ k{1} = map2 W32.(+) k{2} st{2}).
  + inline *; conseq (_: Array16.all_eq k{1} (map2 W32.(+) k{2} st{2})).
    + move=> |> &2 ?; apply Array16.all_eq_eq.
    by unroll for{1} ^while; wp; skip => />.
  inline ChaCha20_srefi.M.store ChaCha20_srefi.M.update_ptr; wp.
  while (={i,Glob.mem} /\ 2 <= i{1} <= 8 /\ kk.[i-1]{1} = kk.[i-1]{2} /\
         (forall j, 2*i{1} <= j < 16 => k0.[j]{1} = (k.[j] + st.[j]){2}) /\
         output0{1} = output{2} /\ plain0{1} = plain{2}).
  + wp; call(_: true); 1: by sim.
    wp; skip => />; smt (Array16.get_setE Array8.get_setE).
  do 2!(wp; call(_:true); 1: by sim); wp; skip => /> &2.
  smt (Array16.get_setE Array8.get_setE Array16.map2iE).
qed.

hoare store_last_srefi_spec output0 plain0 len0 k0 mem0 : ChaCha20_srefi.M.store_last : 
  output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 
  0 <= len < 64 /\ inv_ptr output plain len 
  ==>
  forall j, 
    Glob.mem.[j] =
      if in_range output0 len0 j then
        let j = j - output0 in
        (init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j].
proof.
  proc=> /=.
  while (0 <= j <= len /\ inv_ptr output plain len /\ 
    forall i, 
      Glob.mem.[i] = 
      if in_range output j i then 
        let i = i - output in
        (init32 (fun (i0 : int) => k.[i0])).[i] `^` mem0.[plain + i]
      else mem0.[i]).
  + wp; skip=> /> &hr ? hi16 hinv hj h0i; split; 1: smt().
    move=> i. 
    rewrite storeW8E get_setE W8.xorwC /get8 /loadW8.
    case: (i = output{hr} + j{hr}) => [-> | hne]. smt().
    rewrite hj.
    have -> // : in_range output{hr} j{hr} i = in_range output{hr} (j{hr} + 1) i. smt().
  wp.
  while (0 <= j <= len8 /\ len8 <= 8 /\ inv_ptr output plain len /\ 8 * len8 <= len /\
    forall i, 
      Glob.mem.[i] = 
      if in_range output (8 * j) i then 
        let i = i - output in
         (init32 (fun (i0 : int) => k.[i0])).[i] `^` mem0.[plain + i]
      else mem0.[i]).
  + wp; skip => /> &hr h0j hj8 hl8 hinv hlen hmem hj;split; 1:smt().
    have -> : get64 (init32 (fun (i0 : int) => k{hr}.[i0])) j{hr} = pack2 [k{hr}.[2*j{hr}];k{hr}.[2*j{hr} + 1]].
    + rewrite get64E /init32 /=; apply W8u8.wordP => i hi.
      by rewrite W8u8.pack8bE 1:// initiE 1:// /= initiE 1:/# /= bits8_W2u32 of_listE initiE 1:/# /= /#.
    have /= := storeW64_init32 mem0 Glob.mem{hr} k{hr} output{hr} plain{hr} (j{hr} + 1) _ _ _; 1..3:smt().
    move=> h i; rewrite W64.xorwC.
    have -> : loadW64 Glob.mem{hr} (plain{hr} + 8 * j{hr}) = loadW64 mem0 (plain{hr} + 8 * j{hr});last by apply h.
    rewrite /loadW64;congr; apply W8u8.Pack.packP => l hl /=.
    rewrite !initiE 1,2:// /= hmem.
    by have -> : !in_range output{hr} (8 * j{hr}) (plain{hr} + 8 * j{hr} + l) by smt().
  wp; skip => /> /#.
qed.

phoare store_last_srefi_pspec output0 plain0 len0 k0 mem0 : [ChaCha20_srefi.M.store_last : 
  output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 
  0 <= len < 64 /\ inv_ptr output plain len 
  ==>
  forall j, 
    Glob.mem.[j] =
      if in_range output0 len0 j then
        let j = j - output0 in
        (init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j]] = 1%r.
proof.
  conseq (_: true ==> true) (store_last_srefi_spec output0 plain0 len0 k0 mem0);1:done.
  proc.
  while true (len -j);1: by auto => /#.
  wp; while true (len8 -j); auto => /#.
qed.

equiv eq_store32_pref_srefi len0 : ChaCha20_pref.M.store ~ ChaCha20_srefi.M.store :
  ={output, plain, len, k, Glob.mem} /\ len{1} = len0 /\ (inv_ptr output plain len){1} /\ 64 <= len{1} ==> 
  ={res, Glob.mem} /\ res{1}.`3 = len0 - 64 /\ (inv_ptr res.`1 res.`2 res.`3){1}.
proof.
  proc *.
  ecall{1}(store_pref_spec output{1} plain{1} len{1} k{1} Glob.mem{1}).
  ecall{2}(store_srefi_pspec output{1} plain{1} len{1} k{1} Glob.mem{1}).
  skip => /> &1 ?? m2 hm2; split; 1: by smt().
  move => ? m1 hinv hm1; have -> : min 64 len0 = 64 by smt().
  do split.
  apply mem_eq_ext => j;rewrite hm1 hm2 /#.
qed.

equiv eq_store_last_pref_srefi : ChaCha20_pref.M.store ~ ChaCha20_srefi.M.store_last :
  ={output, plain, len, k, Glob.mem} /\ (inv_ptr output plain len){1} /\ 0 <= len{1} < 64 ==> 
  ={Glob.mem}.
proof.
  proc *.
  ecall{1}(store_pref_spec output{1} plain{1} len{1} k{1} Glob.mem{1}).
  ecall{2}(store_last_srefi_pspec output{1} plain{1} len{1} k{1} Glob.mem{1}).
  skip => /> &2 /= h h0len hlen m2 hm2 m1 ? hm1.
  by apply mem_eq_ext => j;rewrite hm1 hm2 /#.
qed.

equiv eq_chacha20_pref_srefi : ChaCha20_pref.M.chacha20_ref ~ ChaCha20_srefi.M.chacha20_ref : 
   ={output, plain, len, key, nonce, counter, Glob.mem} /\ (inv_ptr output plain len){1} ==>
   ={Glob.mem}.
proof.
  proc => /=.
  splitwhile{1} 2 : (64 <= len).
  seq 2 2 : (={st, output, plain, len, Glob.mem} /\ (inv_ptr output plain len){1} /\ len{1} < 64).
  + while (={st, output, plain, len, Glob.mem} /\ (inv_ptr output plain len){1}).
    + call (_:true); 1: by sim.
      seq 1 1 : (#pre /\ ={k}).
      + conseq (_: ={k}); 1: by move=> /> /#.
        by sim.
      conseq (_: (={st, output, plain, len, Glob.mem} /\ inv_ptr output{1} plain{1} len{1}));1: smt().
      transitivity {1} {
          (output, plain, len) <@  ChaCha20_srefi.M.sum_states_store1(output, plain, len, k, st);
        }
        ((={st, output, plain, len, Glob.mem,k} /\ inv_ptr output{1} plain{1} len{1}) /\
                  (0 < len{1} /\ 64 <= len{1}) /\ 64 <= len{2} ==>
         (={st, output, plain, len, Glob.mem} /\ inv_ptr output{1} plain{1} len{1}))
        (={Glob.mem, k, st, output, plain, len} ==> ={st,Glob.mem, output, plain, len}) => //.
      + smt().       
      + inline ChaCha20_srefi.M.sum_states_store1.
        wp; ecall (eq_store32_pref_srefi len{1}) => /=.
        swap{2} [1..3] 3; wp.
        conseq (_: k{1} = k0{2} /\ ={st}) => //.
        by sim.
      by call eq_sum_states_store_srefi; auto.
    conseq (_: ={st}); 1: by move=> /> /#.
    by sim.  
  if{2}; last by rcondf{1} 1; auto.
  rcondt{1} 1; 1: by auto.
  rcondf{1} 5.
  + move=> &m2. 
    swap -1; inline ChaCha20_pref.M.store ChaCha20_pref.M.update_ptr; wp.
    swap 6 -5; sp.  
    while (i <= min 64 len0); 1: by wp;skip => /#.
    by wp; conseq (_: true) => //; smt().
  call{1} (_:true ==> true); 1:islossless.
  call eq_store_last_pref_srefi => /=.
  conseq (_: ={output, plain, len, k, Glob.mem}); 1:smt().
  by sim.
qed.

(* ------------------------------------------------------------------------------- *)
(* We now prove that ChaCha20_srefi, is equivalent to the concret implementation   *)
(* ChaCha20_sref                                                                   *)

op good_ptr (output plain len : int) =  
  output + len < W64.modulus /\
  plain + len < W64.modulus.

equiv eq_init_srefi_sref : ChaCha20_srefi.M.init ~ ChaCha20_sref.M.init :
  key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\  (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
    ={Glob.mem, counter} 
  ==>
  ={res}.
proof.
  proc.
  while (={i,st, Glob.mem} /\ nonce{1} = to_uint nonce{2} /\ (nonce + 12 < W64.modulus /\ 0 <= i){1}).
  + wp; skip => /> &2 3?.
    have heq : to_uint (W64.of_int (4 * i{2})) = 4 * i{2}.
    + by rewrite to_uint_small /= /#. 
    by rewrite Array3.get_setE //= to_uintD_small heq /= /#. 
  wp;while(={i,st, Glob.mem} /\ key{1} = to_uint key{2} /\ (key + 32 < W64.modulus /\ 0 <= i){1}).
  + wp;skip => /> &2 3?.
    have heq : to_uint (W64.of_int (4 * i{2})) = 4 * i{2}.
    + by rewrite to_uint_small /= /#.
    by rewrite Array8.get_setE //= to_uintD_small heq /= /#.
  wp;skip => />.
qed.

phoare copy_state_sref_spec st0 : [ChaCha20_sref.M.copy_state : st0 = st ==> st0 = res.`1.[15 <- res.`2]] = 1%r. 
proof.
  proc.
  conseq (_: Array16.all_eq st0 k.[15 <- s_k15]). 
  + by move=> ? -> /= ??; rewrite Array16.ext_eq_all.
  by unroll for ^while; wp; skip => />.
qed.

module AUX = { 
  proc double_quarter_round (k:W32.t Array16.t, a0:int, b0:int,
                                     c0:int, d0:int, a1:int, b1:int, c1:int,
                                     d1:int) = {
    k <@ ChaCha20_pref.M.quarter_round(k, a0, b0, c0, d0);
    k <@ ChaCha20_pref.M.quarter_round(k, a1, b1, c1, d1);
    return k;
  }

  proc round (k:W32.t Array16.t, k15:W32.t) : W32.t Array16.t * W32.t = {
    var k14:W32.t;
    
    k <@ ChaCha20_sref.M.inlined_double_quarter_round (k, 0, 4, 8, 12, 2, 6, 10, 14);
    k14 <- k.[14];
    k.[15] <- k15;
    k <@ ChaCha20_sref.M.inlined_double_quarter_round (k, 1, 5, 9, 13, 3, 7, 11, 15);
    k <@ ChaCha20_sref.M.inlined_double_quarter_round (k, 1, 6, 11, 12, 0, 5, 10, 15);
    k15 <- k.[15];
    k.[14] <- k14;
    k <@ ChaCha20_sref.M.inlined_double_quarter_round (k, 2, 7, 8, 13, 3, 4, 9, 14);
    return (k, k15);
  }

  proc rounds (k:W32.t Array16.t, k15:W32.t) : W32.t Array16.t * W32.t = {
    
    var c:int;
    var zf:bool;
    var  _0:bool;
    var  _1:bool;
    var  _2:bool;
    
    c <- 0; 
    while (c < 10) {
      (k, k15) <@ round(k, k15);
      c <- c + 1;
    }
    return (k, k15);
  }
}.

hint simplify ROL_32_E.

equiv eq_quarter_round : ChaCha20_pref.M.quarter_round ~ ChaCha20_pref.M.quarter_round : ={k, a, b, c, d} ==> ={res}.
proof. sim. qed.

equiv eq_round_srefi_aux : ChaCha20_srefi.M.round ~ AUX.round :
  k{1} = k{2}.[15 <- k15{2}] ==>
  res{1} = res{2}.`1.[15 <- res{2}.`2].
proof.
  proc => /=.
  transitivity {1} {
     k <@ AUX.double_quarter_round(k, 0, 4, 8, 12, 2, 6, 10, 14);
     k <@ AUX.double_quarter_round(k, 1, 5, 9, 13, 3, 7, 11, 15);
     k <@ AUX.double_quarter_round(k, 1, 6, 11, 12, 0, 5, 10, 15); 
     k <@ AUX.double_quarter_round(k, 2, 7, 8, 13, 3, 4, 9, 14);
   }
   (={k} ==> ={k})
   (k{1} = k{2}.[15 <- k15{2}] ==> k{1} = k{2}.[15 <- k15{2}]) => //.
  + smt().
  + inline ChaCha20_pref.M.column_round ChaCha20_pref.M.diagonal_round AUX.double_quarter_round.
    by do !(wp; do !call eq_quarter_round); wp; skip.
  seq 1 1: #pre.
  conseq (_: Array16.all_eq k{1} k{2}.[15 <- k15{2}]).
  + move=> &1 &2 ???; apply Array16.all_eq_eq.
  + by inline *;wp; skip => &1 &2 ->>; cbv delta.
  seq 1 3:  (k{1} = k{2}.[14 <- k14{2}]).
  conseq (_: Array16.all_eq k{1} k{2}.[14 <- k14{2}]).
  + move=> &1 &2 ????; apply Array16.all_eq_eq.
  + by inline *;wp; skip => &1 &2 ->>; cbv delta.
  seq 1 1:  (k{1} = k{2}.[14 <- k14{2}]).
  conseq (_: Array16.all_eq k{1} k{2}.[14 <- k14{2}]).
  + move=> &1 &2 ???; apply Array16.all_eq_eq.
  + by inline *;wp; skip => &1 &2 ->>; cbv delta.
  conseq (_: Array16.all_eq k{1} k{2}.[15 <- k15{2}]).
  + move=> &1 &2 ????; apply Array16.all_eq_eq.
  by inline *;wp; skip => &1 &2 ->>; cbv delta.
qed.

equiv eq_rounds_srefi_sref : ChaCha20_srefi.M.rounds ~ ChaCha20_sref.M.rounds :
  k{1} = k{2}.[15 <- k15{2}] ==>
  res{1} = res{2}.`1.[15 <- res{2}.`2].
proof.
  transitivity AUX.rounds
    (k{1} = k{2}.[15 <- k15{2}] ==> res{1} = res{2}.`1.[15 <- res{2}.`2])
    (={k, k15} ==> ={res}) => //.
  + smt().
  + proc => /=; while (#pre /\ ={c}); last by auto.
    by wp; call eq_round_srefi_aux; auto.
  proc => /=.
  rcondt{1} ^while; 1: by auto.
  while (={k,k15} /\ c{1} = 10 - W32.to_uint c{2} /\ zf{2} = (c{2} = W32.zero)).
  wp.  
  + conseq (_: ={k,k15}).
    + move=> /> &2 [#] h1 h2; do split; move :  (DEC_32_counter 10 c{2} h2) => /#.
    inline AUX.round;sim.
  swap{1} 1 1; swap{2} 1 8;wp.
  conseq (_: ={k,k15}).
  + move=> />; cbv delta; apply negP => heq.
    have // : 9 = 0 by rewrite -W32.to_uint0 -heq.
  inline AUX.round;sim.
qed.
 
equiv eq_sum_states_srefi_sref : ChaCha20_pref.M.sum_states ~ ChaCha20_sref.M.sum_states :
  ={st} /\ k{1} = k{2}.[15 <- k15{2}] ==>
  res{1} = res{2}.`1.[15 <- res{2}.`2].
proof.
  proc => /=.  
  unroll for{1} ^while; unroll for{2} ^while.
  conseq (_: all_eq k{1} k{2}.[15 <- k15{2}]).
  + by move=> &1 &2 _ k1 k2 k15 /Array16.all_eq_eq. 
  wp; skip => />.
qed.

equiv eq_sum_states_store_srefi_sref : ChaCha20_srefi.M.sum_states_store ~ ChaCha20_sref.M.sum_states_store :
  ={Glob.mem, st} /\ output{1} = to_uint s_output{2} /\ plain{1} = to_uint s_plain{2} /\ len{1} = to_uint s_len{2} /\
  k{1} = k{2}.[15 <- k15{2}] /\
  (64 <= len /\ good_ptr output plain len){1} ==>
  ={Glob.mem} /\ (good_ptr res.`1 res.`2 res.`3){1} /\
  res{1} = (to_uint res{2}.`1, to_uint res{2}.`2, to_uint res{2}.`3).
proof.
  proc => /=.
  inline *;wp.
  while (={i, st, Glob.mem, kk} /\ 2 <= i{1} /\ 
          (forall j, 2*i{1} <= j < 16 => k{1}.[j] = k{2}.[15 <- k15{2}].[j]) /\
          output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ 
          (64 <= len /\ good_ptr output plain len){1}).
  + seq 0 1: (#pre /\ k.[2*i + 1]{1} = k.[2*i+1]{2}).
    + wp;skip => /> &1 &2 H H0 H1 H2 H3 H4; split => h.
      + by rewrite h Array16.set_set_eq H0 1:/# /= => *;apply H0.      
      by rewrite H0 1:/#; rewrite Array16.get_setE // h.
    wp;skip => /> &1 &2 h1 h2 h3 h4 h5 h6 h7.
    have heq1 : to_uint (W64.of_int (8 * i{2})) = 8 * i{2}.
    + rewrite W64.to_uint_small /= /#.
    have -> : to_uint (plain{2} + W64.of_int (8 * i{2})) = 
                to_uint plain{2} + 8 * i{2}.
    + by rewrite W64.to_uintD_small heq1 /= /#.
    have heq2 : to_uint (W64.of_int (8 * (i{2} - 1))) = 8 * (i{2} - 1).
    + rewrite W64.to_uint_small /= /#.
    have -> : to_uint (output{2} + W64.of_int (8 * (i{2} - 1))) = 
                to_uint output{2} + 8 * (i{2} - 1).
    + by rewrite W64.to_uintD_small heq2 /= /#.
    smt (Array8.get_setE Array16.get_setE).    
  wp; skip => /> &2 h1 h2 h3.
  rewrite to_uintD_small /= 1:/#.
  split=> *;1: smt(Array16.get_setE).
  rewrite to_uintB 1:uleE //= !to_uintD_small /= /#.
qed.

equiv eq_store_last_srefi_sref : ChaCha20_srefi.M.store_last ~ ChaCha20_sref.M.store_last :
  ={Glob.mem} /\ output{1} = to_uint s_output{2} /\ plain{1} = to_uint s_plain{2} /\ len{1} = to_uint s_len{2} /\
  k{1} = k{2}.[15 <- k15{2}] /\
  (len < 64 /\ good_ptr output plain len){1} ==>
  ={Glob.mem}.
proof.
  proc => /=.
  while (={Glob.mem} /\ k{1} = s_k{2} /\ len{1} < 64 /\
         j{1} = to_uint j{2} /\ output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
         (good_ptr output plain len){1}).
  + wp; skip => /> &2 ???; rewrite !ultE => ?. 
    by rewrite !W2u32.to_uint_truncateu32 !W64.to_uintD_small /= 1..3:/# !modz_small; smt(W64.to_uint_cmp).
  wp.
  while (0 <= j{1} <= len8{1} /\ ={Glob.mem} /\ k{1} = s_k{2} /\
            j{1} = to_uint j{2} /\ output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
            len8{1} = to_uint len8{2} /\ (good_ptr output plain len){1} /\ 8 * len8{1} <= len{1} /\ len8{1} < 8).
  + wp; skip => /> &2 h1 h2 h3 h4 h5 h6 h7.
    rewrite !ultE !W2u32.to_uint_truncateu32 => h8.
    have /= hcmp := W32.to_uint_cmp len{2}.
    have heq : to_uint (W64.of_int 8 * j{2}) = 8 * to_uint j{2}.
    + by rewrite to_uintM_small //= /#.
    by rewrite !to_uintD_small /= 1..3:/# heq /= !modz_small /= /#.
  wp.
  while{2} (i<=15 /\ forall j, 0 <= j < i => s_k.[j] = k.[j]){2} (15-i{2}).
  + move=> ? z;wp; skip; smt(Array16.get_setE).    
  wp; skip => /> &2 ???;split;1:smt().
  move=> i sk;split;1:smt().
  move=> ??; have ->> : i = 15 by smt().
  move=> hsk; rewrite /(`<<`) /(`>>`) /= (_ : 3 %% 64 = 3) 1://; split.
  + rewrite ultE W2u32.to_uint_truncateu32 /= (_: 0 %% 4294967296 = 0) 1:// W32.to_uint_shr 1:// /=.
    rewrite mulzC floor_le 1:// ltz_divLR 1:// divz_ge0 1:// => />; split;1:smt(W32.to_uint_cmp).
    by apply Array16.tP => j hj;rewrite !Array16.get_setE 1,2:// /#.
  move=> jR; rewrite ltz_divLR 1:// lez_divRL 1:// /= => *.
  rewrite ultE  W2u32.to_uint_truncateu32 W64.to_uint_shl 1:// /=; smt(modz_small).
qed.

equiv eq_increment_counter_srefi_sref: ChaCha20_srefi.M.increment_counter ~ ChaCha20_sref.M.increment_counter :
  ={st} ==> ={res}.
proof.
  by proc;auto => /> &2;rewrite W32.WRingA.addrC.
qed.

equiv eq_chacha20_srefi_sref : ChaCha20_srefi.M.chacha20_ref ~ ChaCha20_sref.M.chacha20_ref : 
  key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
  (good_ptr output plain len){1} /\
  ={Glob.mem, counter} 
  ==>
  ={Glob.mem}.
proof.
proc => /=.
sp; seq 1 1 : (#{/~(_ = witness)}pre /\ ={st}).
+ by call eq_init_srefi_sref;skip => />.
seq 1 1 : (={st, Glob.mem} /\ 
           output{1} = to_uint s_output{2} /\ plain{1} = to_uint s_plain{2} /\ len{1} = to_uint s_len{2} /\
           (good_ptr output plain len){1} /\
           len{1} < 64). 
+ while (#{/~ len{1} < _}post).
  + call eq_increment_counter_srefi_sref.
    call eq_sum_states_store_srefi_sref.
    call eq_rounds_srefi_sref.
    by ecall{2} (copy_state_sref_spec st{2});skip => /> *; rewrite uleE.
  skip => /> *; rewrite uleE /= => ??; rewrite uleE => /#.
if=> //.
+ by move=> /> *;rewrite ultE.
call eq_store_last_srefi_sref.
call eq_sum_states_srefi_sref.
call eq_rounds_srefi_sref.
by ecall{2} (copy_state_sref_spec st{2});skip.
qed.

hoare chacha20_sref_spec mem0 output0 plain0 key0 len0 nonce0 counter0 : ChaCha20_sref.M.chacha20_ref :
  mem0 = Glob.mem /\ output0 = to_uint output /\ len0 = to_uint len /\
  plain0 = loads_8 Glob.mem (to_uint plain) (to_uint len) /\
  key0 = Array8.of_list W32.zero (loads_32 Glob.mem (to_uint key) 8) /\
  nonce0 = Array3.of_list W32.zero (loads_32 Glob.mem (to_uint nonce) 3) /\
  counter0 = counter /\
  inv_ptr (to_uint output) (to_uint plain) (to_uint len) /\
  to_uint key + 32 < W64.modulus /\ 
  to_uint nonce + 12 < W64.modulus /\
  to_uint output + to_uint len < W64.modulus /\ 
  to_uint plain + to_uint len < W64.modulus 
  ==> 
  (chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = 
     loads_8 Glob.mem output0 len0 /\
  mem_eq_except (in_range output0 len0) Glob.mem mem0.
proof.
  bypr.
  move=> &m [#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12. 
  have <-: 
   Pr[ChaCha20_srefi.M.chacha20_ref(output0, to_uint plain{m}, len0, to_uint key{m}, 
                                   to_uint nonce{m}, counter{m}) @ &m :
       !((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 =loads_8 Glob.mem output0 len0 /\
        mem_eq_on (predC (in_range output0 len0)) Glob.mem mem0)] =
   Pr[ChaCha20_sref.M.chacha20_ref(output{m}, plain{m}, len{m}, key{m}, nonce{m}, counter{m}) @ &m :
       !((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = loads_8 Glob.mem output0 len0 /\
          mem_eq_on (predC (in_range output0 len0)) Glob.mem mem0)].
  + by byequiv eq_chacha20_srefi_sref => />; rewrite h2 h3.
  have <-: 
   Pr[ChaCha20_pref.M.chacha20_ref(output0, to_uint plain{m}, len0, to_uint key{m}, 
                                   to_uint nonce{m}, counter{m}) @ &m :
       !((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 =loads_8 Glob.mem output0 len0 /\
        mem_eq_on (predC (in_range output0 len0)) Glob.mem mem0)] =
   Pr[ChaCha20_srefi.M.chacha20_ref(output0, to_uint plain{m}, len0, to_uint key{m}, 
                                    to_uint nonce{m}, counter{m}) @ &m :
       !((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = loads_8 Glob.mem output0 len0 /\
          mem_eq_on (predC (in_range output0 len0)) Glob.mem mem0)].
  + by byequiv eq_chacha20_pref_srefi => />; rewrite h2 h3.
  pose plain1 := to_uint plain{m}; 
  pose key1 := to_uint key{m};
  pose nonce1 := to_uint nonce{m}.
  byphoare (_: mem0 = Glob.mem /\
   0 <= len /\
   output = output0 /\ plain = plain1 /\ len = len0 /\ key = key1 /\ nonce = nonce1 /\
   inv_ptr output0 plain1 len0 /\
   plain0 = loads_8 mem0 plain1 len0 /\
   key0 = Array8.of_list W32.zero (loads_32 mem0 key1 8) /\
   nonce0 = Array3.of_list W32.zero (loads_32 mem0 nonce1 3) /\
   counter0 = counter 
   ==> 
   !((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = loads_8 Glob.mem output0 len0 /\
     mem_eq_except (in_range output0 len0) Glob.mem mem0)) => //; last first.
  + move=> />; rewrite h1 h2 h3 h4 /plain1 /key1 /nonce1 h8 h5 h6 /=;
     case: (W32.to_uint_cmp len{m}) => -> //.
  hoare => //.
  conseq (chacha20_ref_spec mem0 output0 plain0 key0 nonce0 counter0) => //; 1: smt().
  move: h1 h2 h3 h4 h5 h6 h7; rewrite /plain1 /key1 /nonce1 => /> &hr 8? mem1.
  rewrite size_loads_8 => />; case: (W32.to_uint_cmp len{m}) => /#. 
qed.


