require import AllCore List Int IntDiv CoreMap.
require import Array2 Array3 Array4 Array8 Array16. 
require import WArray16 WArray32 WArray64.
require import ChaCha20_Spec ChaCha20_pref ChaCha20_pref_proof ChaCha20_sref_proof.
require import ChaCha20_pavx2 ChaCha20_savx2.
require import StdRing StdOrder.
import IntOrder.

from Jasmin require import JModel.

(* --------------------------------------------------------------------- *)
(*  chach20_less_than_257                                                *)

op x2 (k1 k2:W32.t Array16.t) = 
  Array4.init (fun i => 
    let i = 4*i in
    W8u32.pack8 [k1.[i]; k1.[i+1]; k1.[i+2]; k1.[i+3]; k2.[i]; k2.[i+1]; k2.[i+2]; k2.[i+3]]).

op x2_ (k1 k2:W32.t Array16.t) = 
  Array4.of_list witness [
    W8u32.pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]];
    W8u32.pack8 [k1.[8]; k1.[9]; k1.[10]; k1.[11]; k1.[12]; k1.[13]; k1.[14]; k1.[15]];
    W8u32.pack8 [k2.[0]; k2.[1]; k2.[2]; k2.[3]; k2.[4]; k2.[5]; k2.[6]; k2.[7]];
    W8u32.pack8 [k2.[8]; k2.[9]; k2.[10]; k2.[11]; k2.[12]; k2.[13]; k2.[14]; k2.[15]] ].

op x_ (k1:W32.t Array16.t) = 
  Array2.of_list witness [
    W8u32.pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]];
    W8u32.pack8 [k1.[8]; k1.[9]; k1.[10]; k1.[11]; k1.[12]; k1.[13]; k1.[14]; k1.[15]] ].

lemma g_sigma_pack : g_sigma = pack4 [g_sigma0; g_sigma1; g_sigma2; g_sigma3].
proof. by apply W4u32.allP;cbv delta. qed.

lemma g_p0_pack : g_p0 = W4u32.pack4 [W32.zero; W32.zero; W32.zero; W32.zero].
proof. by apply W4u32.allP; cbv delta. qed.

lemma g_p1_pack : 
  g_p1 = W8u32.pack8 [W32.zero; W32.zero; W32.zero; W32.zero; W32.one; W32.zero; W32.zero; W32.zero].
proof. by apply W8u32.allP; cbv delta. qed.
(* FIXME PY
  apply W8u32.allP => /=. 
  rewrite W8u32.bits32_div 1://.
  rewrite W8u32.bits32_div 1://.
  rewrite W8u32.bits32_div 1://.
  rewrite W8u32.bits32_div 1://.
  rewrite W8u32.bits32_div 1://.
  pose s := W8u32.(\bits32) g_p1 5.
  *)

lemma g_p2_pack :
  g_p2 = pack8[W32.of_int 2; W32.zero; W32.zero; W32.zero; W32.of_int 2; W32.zero; W32.zero; W32.zero].
proof. by apply W8u32.allP; cbv delta. qed.

lemma loadW64_bits32 m p i : 0 <= i < 2 =>
  loadW64 m p \bits32 i = loadW32 m (p + i * 4).
proof. 
  move=> hi; rewrite /loadW64 /loadW32.
  rewrite bits32_W8u8 hi /= !initiE 1..4:/# /=.
  apply W4u8.allP; cbv delta => /#.
qed.

lemma load2u32 mem p : 
  pack2 [loadW32 mem p; loadW32 mem (p + 4)] = loadW64 mem p.
proof. by apply W2u32.allP; rewrite /= /loadW32 /loadW64 /=;split;apply W4u8.allP. qed.

equiv eq_init_x2 :
  ChaCha20_pavx2.M.init_x2 ~ ChaCha20_savx2.M.init_x2 : 
  key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
  (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1}
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc => /=; inline *.
  conseq (_: Array4.all_eq st{2} (x2 st_1 st_2){1}).
  + by move=> *; apply Array4.all_eq_eq.
  do 2! unroll for{1} ^while; wp; skip => /> *.
  cbv delta; rewrite g_sigma_pack /= W64.to_uintD_small /= 1:/# -iotaredE /=.
  by apply W32u8.allP; cbv delta; rewrite W64.to_uintD_small /= 1:/#.
qed.

(* FIXME 
lemma get8_pack4u32 f j: 
  pack4_t (W4u32.Pack.init f) \bits8 j = 
    if 0 <= j < 16 then f (j %/ 4) \bits8 (j %% 4) else W8.zero.
proof.
  rewrite pack4E W8.wordP => i hi.
  rewrite bits8E /= initE hi /= initE.
  have -> /= : (0 <= j * 8 + i < 128) <=> (0 <= j < 16) by smt().
  case : (0 <= j < 16) => hj //=.
  rewrite bits8E /= initE.
  have -> : (j * 8 + i) %/ 32 = j %/4.
  + rewrite {1}(divz_eq j 4) mulzDl mulzA /= -addzA divzMDl //.
    by rewrite (divz_small _ 32) //; smt (modz_cmp).
  rewrite initE hi /= divz_cmp //=; congr.
  rewrite {1}(divz_eq j 4) mulzDl mulzA /= -addzA modzMDl modz_small //; smt (modz_cmp).
qed.
*)
lemma pack8_init_shift8 (k:W32.t Array16.t) : 
  pack8 [k.[8]; k.[9]; k.[10]; k.[11]; k.[12]; k.[13]; k.[14]; k.[15]] = 
  pack8_t (W8u32.Pack.init (fun i => k.[8 + i])).
proof. by apply W8u32.allP. qed.

(*FIXME
lemma get8_pack8u32 f j: 
  pack8_t (W8u32.Pack.init f) \bits8 j = 
    if 0 <= j < 32 then f (j %/ 4) \bits8 (j %% 4) else W8.zero.
proof.
  rewrite pack8E W8.wordP => i hi.
  rewrite bits8E /= initE hi /= initE.
  have -> /= : (0 <= j * 8 + i < 256) <=> (0 <= j < 32) by smt().
  case : (0 <= j < 32) => hj //=.
  rewrite bits8E /= initE.
  have -> : (j * 8 + i) %/ 32 = j %/4.
  + rewrite {1}(divz_eq j 4) mulzDl mulzA /= -addzA divzMDl //.
    by rewrite (divz_small _ 32) //; smt (modz_cmp).
  rewrite initE hi /= divz_cmp //=; congr.
  rewrite {1}(divz_eq j 4) mulzDl mulzA /= -addzA modzMDl modz_small //; smt (modz_cmp).
qed.
*)
(* FIXME: move *)
lemma get_storeW128E m p w j: 
    (storeW128 m p w).[j] = if p <= j < p + 16 then w \bits8 j - p else m.[j].
proof. rewrite storeW128E /= get_storesE /= /#. qed.

lemma get_storeW256E m p w j: 
    (storeW256 m p w).[j] = if p <= j < p + 32 then w \bits8 j - p else m.[j].
proof. rewrite storeW256E /= get_storesE /= /#. qed.

(*lemma pack4_init (k:int ->  W32.t) : 
  pack4 [k 0; k 1; k 2; k 3] = 
  pack4_t (W4u32.Pack.init k).
proof. by congr; apply W4u32.Pack.all_eq_eq; cbv delta. qed.

lemma pack8_init (k:int -> W32.t) : 
  pack8 [k 0; k 1; k 2; k 3; k 4; k 5; k 6; k 7] = 
  pack8_t (W8u32.Pack.init k).
proof. by congr; apply W8u32.Pack.all_eq_eq; cbv delta. qed.
*)
lemma store_256_xor_spec output (k1:W32.t Array16.t) mem plain j:
  (if output + 32 <= j < output + 64 then
     (pack8 [k1.[8]; k1.[9]; k1.[10]; k1.[11]; k1.[12]; k1.[13]; k1.[14]; k1.[15]] \bits8 j - (output + 32)) `^`
     (loadW256 mem (plain + 32) \bits8 j - (output + 32))
   else if output <= j < output + 32 then
     (pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]] \bits8 j - output) `^`
     (loadW256 mem plain \bits8 j - output)
   else mem.[j]) =
   if in_range output 64 j then (WArray64.init32 ("_.[_]" k1)).[j - output] `^` mem.[plain + (j - output)]
   else mem.[j].
proof.
  rewrite /init32 /loadW256 /=.
  case: (output + 32 <= j < output + 64) => hin2.
  + have -> /= : in_range output 64 j by smt().
    have h1 : 0 <= j - (output + 32) < 32 by smt().
    by rewrite pack32bE 1:// bits8_W8u32_red 1:// get_of_list 1:/# W32u8.Pack.initiE 1:// WArray64.initiE /#.
  case:(output <= j < output + 32) => hin3.  
  + have -> /= : in_range output 64 j by smt().
    rewrite /init32 /loadW256 /= initiE; 1: smt (W64.to_uint_cmp).
    have h1 : 0 <= j - output < 32 by smt().
    by rewrite /= pack32bE 1:// initiE 1:// bits8_W8u32 h1 /= get_of_list /#.
  have -> // : !(in_range output 64 j) by smt().
qed.

phoare store_x2_spec output0 plain0 len0 k1 k2 mem0 : [ChaCha20_savx2.M.store_x2 : 
  to_uint output = output0 /\ to_uint plain = plain0 /\ to_uint len = len0 /\ k = x2_ k1 k2 /\ Glob.mem = mem0 /\ 
  128 <= to_uint len /\ (good_ptr output0 plain0 len0) 
  ==>
  to_uint res.`1 = output0 + 128 /\
  to_uint res.`2 = plain0 + 128 /\
  to_uint res.`3 = len0 - 128 /\
  forall j, 
    Glob.mem.[j] =
      if in_range output0 64 j then
        let j = j - output0 in
        (WArray64.init32 (fun (i0 : int) => k1.[i0])).[j] `^` mem0.[plain0 + j]
      else if in_range (output0 + 64) 64 j then
        let j = j - (output0 + 64) in
        (WArray64.init32 (fun (i0 : int) => k2.[i0])).[j] `^` mem0.[plain0 + 64 + j]
      else mem0.[j]]= 1%r.
proof.
  proc => /=.
  inline M.update_ptr; wp.
  do 2! unroll for ^while.
  wp; skip => &hr /> hlen hout hplain.
  rewrite !W64.to_uintD_small /= 1..-2:/#.
  rewrite W32.to_uintB 1:uleE /= 1:/# => j.
  rewrite !get_storeW256E /x2_ /=.
  case: (in_range (to_uint output{hr}) 64 j) => hin.
  + have -> : !(to_uint output{hr} + 96 <= j < to_uint output{hr} + 128) by smt().
    have -> /= : !(to_uint output{hr} + 64 <= j < to_uint output{hr} + 96) by smt().
    by rewrite store_256_xor_spec hin.
  have -> : !(to_uint output{hr} + 32 <= j < to_uint output{hr} + 64) by smt().
  have -> /= : !(to_uint output{hr} <= j < to_uint output{hr} + 32) by smt().
  by rewrite -store_256_xor_spec.
qed.

equiv eq_store_x2 len_ : ChaCha20_pavx2_cf.M.store_x2 ~ M.store_x2 :
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ len{1} = len_ /\ ={Glob.mem} /\
  (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ 128 <= len{1} /\
  k{2} = (x2_ k_1 k_2){1} 
  ==>
  res{1}.`1 = to_uint res{2}.`1 /\ res{1}.`2 = to_uint res{2}.`2 /\ res{1}.`3 = to_uint res{2}.`3 /\ 
  res{1}.`3 = len_ - 128 /\
  (good_ptr res.`1 res.`2 res.`3){1} /\ (inv_ptr res.`1 res.`2 res.`3){1} /\ ={Glob.mem}.
proof.
  proc *.
  ecall{2} (store_x2_spec output{1} plain{1} len{1} k_1{1} k_2{1} Glob.mem{2}).
  inline{1} ChaCha20_pavx2_cf.M.store_x2; wp.
  ecall{1} (store_pref_spec output0{1} plain0{1} len0{1} k_2{1} Glob.mem{1}).
  ecall{1} (store_pref_spec output0{1} plain0{1} len0{1} k_1{1} Glob.mem{1}). 
  wp; skip => />. 
  move=> &1 &2  hgood hinv hlen ?; split; 1: smt().
  move=> ? mem1; have -> : min 64 (to_uint len{2}) = 64 by smt().
  move=> hinv1 hmem1; split; 1: smt().
  move=> _ mem2; have -> /= :  min 64 (to_uint len{2} - 64) = 64 by smt().
  move => hinv2 hmem2 r mem 3!-> hmem /=; split; 1: smt().
  apply mem_eq_ext => j; smt().
qed.

module Store = {
 
  proc store32 (output plain: address, len: int, k:W32.t Array8.t) = {
    var i:int;
    var k8_0, k8: WArray32.t;
    k8 <- witness;
    k8_0 <- WArray32.init32 (fun i => k.[i]);
    i <- 0;  
    while (i < len) {
      k8.[i] <- k8_0.[i] `^` loadW8 Glob.mem (plain + i);
      i <- i + 1;
    }
    i <- 0;
    while (i < len) {
      Glob.mem <- storeW8 Glob.mem (output + i) k8.[i];
      i <- i + 1;
    }
  }

  proc store16 (output plain: address, len: int, k:W32.t Array4.t) = {
    var i:int;
    var k8_0, k8: WArray16.t;
    k8 <- witness;
    k8_0 <- WArray16.init32 (fun i => k.[i]);
    i <- 0;  
    while (i < len) {
      k8.[i] <- k8_0.[i] `^` loadW8 Glob.mem (plain + i);
      i <- i + 1;
    }
    i <- 0;
    while (i < len) {
      Glob.mem <- storeW8 Glob.mem (output + i) k8.[i];
      i <- i + 1;
    }
  }

  proc store64_1 (output plain: address, len: int, k:W32.t Array16.t) = {
    var k1 : W32.t Array8.t; 
    k1 <- Array8.init (fun i => k.[i]);
    if (32 <= len) {
      store32(output, plain, 32, k1);
      (output, plain, len) <@ ChaCha20_pref.M.update_ptr(output, plain, len, 32);
      k1 <- Array8.init (fun i => k.[i + 8]);
    }
    store32(output, plain, len, k1); 
  }

  proc store32_1 (output plain: address, len: int, k:W32.t Array8.t) = {
    var k1 : W32.t Array4.t; 
    k1 <- Array4.init (fun i => k.[i]);
    if (16 <= len) {
      store16(output, plain, 16, k1);
      (output, plain, len) <@ ChaCha20_pref.M.update_ptr(output, plain, len, 16);
      k1 <- Array4.init (fun i => k.[i + 4]);
    }
    store16(output, plain, len, k1); 
  }

  proc store64_2 (output plain: address, len: int, k:W32.t Array16.t) = {
    var k1 : W32.t Array8.t; 
    k1 <- Array8.init (fun i => k.[i]);
    if (32 <= len) {
      store32(output, plain, 32, k1);
      (output, plain, len) <@ ChaCha20_pref.M.update_ptr(output, plain, len, 32);
      k1 <- Array8.init (fun i => k.[i + 8]);
    }
    store32_1(output, plain, len, k1); 
  }
}.

equiv eq_store64_1 : ChaCha20_pref.M.store ~ Store.store64_1 : 
   ={Glob.mem, output, plain, len, k} /\ 0 <= len{1} <= 64 /\ (inv_ptr output plain len){1} ==> ={Glob.mem}.
proof.
  proc => /=.
  sp 2 1; if{2}; last first.
  + inline *; wp.
    while (={i, Glob.mem} /\ output{1} = output0{2} /\ plain{1} = plain0{2} /\ len{1} = len0{2} /\ len{1} <= 32 /\ 0 <= i{1} /\
           (forall j, 0 <= j < len{1} => k8{1}.[j] = k8{2}.[j])).
    + by auto => /> /#.
    wp;while(={i,Glob.mem} /\ plain{1} = plain0{2} /\ len{1} = len0{2} /\ len{1} <= 32 /\ 0 <= i{1} <= len{1} /\
           (forall j, 0 <= j < 32 => k8_0{1}.[j] = k8_0{2}.[j]) /\
           (forall j, 0 <= j < i{1} => k8{1}.[j] = k8{2}.[j])).
    + by auto; smt(WArray64.get_setE WArray32.get_setE).
    by auto;smt (WArray64.initE WArray32.initE Array8.initE).
  inline ChaCha20_pref.M.update_ptr; wp.
  exlim Glob.mem{1} => mem0.
  seq 2 0 : (#{/~k8{1}}pre /\ (forall j, 0 <= j < len => k8.[j] = k8_0.[j] `^` loadW8 mem0 (plain + j)){1}).
  + while{1} ((forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` loadW8 mem0 (plain + j)) /\ 
                mem0 = Glob.mem /\ 0 <= i <= len /\ 0 <= len <= 64){1} (len{1} - i{1}).     
    + by move=> _ z; wp; skip => />; smt (WArray64.get_setE). 
    by auto => /> /#.     
  splitwhile{1} 2: (i < 32);inline *.
  while (={Glob.mem} /\ output2{2} = output{1} + 32 /\ len2{2} = len{1} - 32 /\ 
           i{1} = i0{2} + 32 /\ 32 <= len{1} <= 64 /\ 0 <= i0{2} <= len2{2} /\
           (forall j, 0 <= j < len2{2} => k80{2}.[j] = k8{1}.[j+32])).
  + by wp; skip => /> /#. 
  wp.
  while{2} ((forall j, 0 <= j < i0{2} => k80{2}.[j] = k8_00{2}.[j] `^` loadW8 mem0 (plain2{2} + j)) /\
            (0 <= i0 <= len2){2} /\ 0 <= len2{2} <= 32 /\
            (forall j, 0 <= j < len2{2} => Glob.mem.[plain2 + j] = mem0.[plain2 + j]){2}) (len2 - i0){2}.
  + by move=> _ z; wp; skip => />; smt (WArray32.get_setE).
  wp.
  while (={Glob.mem, i} /\ output{1} = output1{2} /\ len1{2} = 32 /\ (inv_ptr output plain len /\ 0 <= i <= 32 /\ 32 <= len <= 64){1} /\ 
         (forall j, 32 <= j < len => Glob.mem.[plain + j] = mem0.[plain + j]){1} /\
         (forall j, 0 <= j < 32 => k8{1}.[j] = k8{2}.[j])).
  + by wp; skip => />; smt (storeW8E JMemory.get_setE).
  wp; while{2} ((forall j,  0 <= j < i{2} => k8{2}.[j] = k8_0{2}.[j] `^` loadW8 Glob.mem{2} (plain1{2} + j)) /\
                (0 <= i <= len1){2} /\ len1{2} = 32) (len1 - i){2}.
  + by move=> _ z; wp; skip => />; smt (WArray32.get_setE).
  wp; skip => /> &1 &2 h1 h2 h3 h4 h5.
  split; 1: smt(). 
  move=> i_R k8_R;split; 1: smt().
  move=> h6 h7 h8 h9; have ->> : i_R = 32 by smt().
  split; 1:smt (WArray64.initE WArray32.initE Array8.initE).
  move=> mem_R i_R0 h10 h11 h12 h13 h14 h15.
  have ->> /= : i_R0 = 32 by smt().
  have : forall (j : int), 0 <= j => j < len{2} - 32 => mem_R.[plain{2} + 32 + j] = mem0.[plain{2} + 32 + j].
  + by move=> j *; rewrite -addzA h14 /#.
  smt (WArray64.initE WArray32.initE Array8.initE).
qed.

equiv eq_store32_1 : Store.store32 ~ Store.store32_1 : 
   ={Glob.mem, output, plain, len, k} /\ 0 <= len{1} <= 32 /\ (inv_ptr output plain len){1} ==> ={Glob.mem}.
proof.
  proc => /=.
  sp 2 1; if{2}; last first.
  + inline *; wp.
    while (={i, Glob.mem} /\ output{1} = output0{2} /\ plain{1} = plain0{2} /\ len{1} = len0{2} /\ len{1} <= 16 /\ 0 <= i{1} /\
           (forall j, 0 <= j < len{1} => k8{1}.[j] = k8{2}.[j])).
    + by auto => /> /#.
    wp;while(={i,Glob.mem} /\ plain{1} = plain0{2} /\ len{1} = len0{2} /\ len{1} <= 16 /\ 0 <= i{1} <= len{1} /\
           (forall j, 0 <= j < 16 => k8_0{1}.[j] = k8_0{2}.[j]) /\
           (forall j, 0 <= j < i{1} => k8{1}.[j] = k8{2}.[j])).
    + by auto; smt(WArray32.get_setE WArray16.get_setE).
    by wp; skip => />; smt (WArray32.initE WArray16.initE Array4.initE).
  inline ChaCha20_pref.M.update_ptr; wp.
  exlim Glob.mem{1} => mem0.
  seq 2 0 : (#{/~k8{1}}pre /\ (forall j, 0 <= j < len => k8.[j] = k8_0.[j] `^` loadW8 mem0 (plain + j)){1}).
  + while{1} ((forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` loadW8 mem0 (plain + j)) /\ 
                mem0 = Glob.mem /\ 0 <= i <= len /\ 0 <= len <= 32){1} (len{1} - i{1}).     
    + by move=> _ z; wp; skip => />; smt (WArray32.get_setE). 
    by auto => /> /#.     
  splitwhile{1} 2: (i < 16);inline *.
  while (={Glob.mem} /\ output2{2} = output{1} + 16 /\ len2{2} = len{1} - 16 /\ 
           i{1} = i0{2} + 16 /\ 16 <= len{1} <= 32 /\ 0 <= i0{2} <= len2{2} /\
           (forall j, 0 <= j < len2{2} => k80{2}.[j] = k8{1}.[j+16])).
  + by wp; skip => /> /#. 
  wp.
  while{2} ((forall j, 0 <= j < i0{2} => k80{2}.[j] = k8_00{2}.[j] `^` loadW8 mem0 (plain2{2} + j)) /\
            (0 <= i0 <= len2){2} /\ 0 <= len2{2} <= 16 /\
            (forall j, 0 <= j < len2{2} => Glob.mem.[plain2 + j] = mem0.[plain2 + j]){2}) (len2 - i0){2}.
  + by move=> _ z; wp; skip => />; smt (WArray16.get_setE).
  wp.
  while (={Glob.mem, i} /\ output{1} = output1{2} /\ len1{2} = 16 /\ (inv_ptr output plain len /\ 0 <= i <= 16 /\ 16 <= len <= 32){1} /\ 
         (forall j, 16 <= j < len => Glob.mem.[plain + j] = mem0.[plain + j]){1} /\
         (forall j, 0 <= j < 16 => k8{1}.[j] = k8{2}.[j])).
  + by wp; skip => />; smt (storeW8E JMemory.get_setE).
  wp; while{2} ((forall j,  0 <= j < i{2} => k8{2}.[j] = k8_0{2}.[j] `^` loadW8 Glob.mem{2} (plain1{2} + j)) /\
                (0 <= i <= len1){2} /\ len1{2} = 16) (len1 - i){2}.
  + by move=> _ z; wp; skip => />; smt (WArray16.get_setE).
  wp; skip => /> &1 &2 h1 h2 h3 h4 h5; split; 1: smt(). 
  move=> i_R k8_R;split; 1: smt().
  move=> h6 h7 h8 h9; have ->> : i_R = 16 by smt().
  split; 1: smt (WArray32.initE WArray16.initE Array4.initE).
  move=> mem_R i_R0 h10 h11 h12 h13 h14 h15; have ->> /= : i_R0 = 16 by smt().
  have : forall (j : int), 0 <= j => j < len{2} - 16 => mem_R.[plain{2} + 16 + j] = mem0.[plain{2} + 16 + j].
  + by move=> *;rewrite -1?addzA /#.
  smt (WArray32.initE WArray16.initE Array4.initE).
qed.

equiv eq_store64_2 : ChaCha20_pref.M.store ~ Store.store64_2 : 
   ={Glob.mem, output, plain, len, k} /\ 0 <= len{1} <= 64 /\ (inv_ptr output plain len){1} ==> ={Glob.mem}.
proof.
  transitivity Store.store64_1 
    (={Glob.mem, output, plain, len, k} /\ 0 <= len{1} <= 64 /\ (inv_ptr output plain len){1} ==> ={Glob.mem})
    (={Glob.mem, output, plain, len, k} /\ 0 <= len{1} <= 64 /\ (inv_ptr output plain len){1} ==> ={Glob.mem}).
  + smt(). + done.
  + apply eq_store64_1.
  proc => /=.
  call eq_store32_1; conseq />.
  sp; if; [done | | skip => /> /#].
  inline ChaCha20_pref.M.update_ptr; wp.
  conseq (_ : ={output, plain, len, Glob.mem, k}); 1: by move=> /> /#.
  by sim.
qed.

equiv eq_update_ptr output0 plain0 len0 n0 : ChaCha20_pref.M.update_ptr ~  M.update_ptr :
   output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
   output{1} = output0 /\ plain{1} = plain0 /\ len{1} = len0 /\ n{1} = n0 /\
   good_ptr output{1} plain{1} len{1} /\ ={n} /\ 0 <= n{1} <= len{1} ==>
   res{1}.`1 = to_uint res{2}.`1 /\
   res{1}.`2 = to_uint res{2}.`2 /\
   res{1}.`3 = to_uint res{2}.`3 /\ 
   res{1}.`1 = output0 + n0 /\
   res{1}.`2 = plain0 + n0 /\
   res{1}.`3 = len0 - n0 /\
   good_ptr res{1}.`1 res{1}.`2 res{1}.`3.
proof.
  proc; wp; skip => /> &2 h1 h2 h3 h4.
  have hn: W64.to_uint (W64.of_int n0) = n0.
  + rewrite W64.to_uint_small /=; smt (W64.to_uint_cmp).
  rewrite !W64.to_uintD_small hn 1,2:/#. 
  have hn1: W32.to_uint (W32.of_int n0) = n0.
  + rewrite W32.to_uint_small //=. 
    by have /# := W32.to_uint_cmp len{2}.
  by rewrite W32.to_uintB 1:W32.uleE hn1 // /#.
qed.

phoare store32_spec output0 plain0 k0 mem0 : 
  [Store.store32 : 
    output = output0 /\ plain = plain0 /\ len = 32 /\ k = k0 /\ Glob.mem = mem0  
     ==>
  forall j, 
    Glob.mem.[j] =
      if in_range output0 32 j then
        let j = j - output0 in
        (WArray32.init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j]]= 1%r.
proof.
  proc.
  while (0 <= i <= len /\
         forall j, 
          Glob.mem.[j] = if in_range output i j then k8.[j-output] else mem0.[j]) (len - i).
  + move=> z; wp; skip => /> &hr *;smt(storeW8E JMemory.get_setE).
  wp; while (0 <= i <= len /\ len = 32 /\
             forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` Glob.mem.[plain + j]) (len - i).
  + by move=> z; wp; skip => />; smt (WArray32.get_setE).
  wp; skip => />  /#.
qed.

phoare store16_spec output0 plain0 k0 mem0 : 
  [Store.store16 : 
    output = output0 /\ plain = plain0 /\ len = 16 /\ k = k0 /\ Glob.mem = mem0  
     ==>
  forall j, 
    Glob.mem.[j] =
      if in_range output0 16 j then
        let j = j - output0 in
        (WArray16.init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j]]= 1%r.
proof.
  proc.
  while (0 <= i <= len /\
         forall j, 
          Glob.mem.[j] = if in_range output i j then k8.[j-output] else mem0.[j]) (len - i).
  + move=> z; wp; skip => /> &hr *;smt(storeW8E JMemory.get_setE).
  wp; while (0 <= i <= len /\ len = 16 /\
             forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` Glob.mem.[plain + j]) (len - i).
  + by move=> z; wp; skip => />; smt (WArray16.get_setE).
  wp; skip => />  /#.
qed.

(*lemma pack4_init (k:int ->  W32.t) : 
  pack4 [k 0; k 1; k 2; k 3] = 
  pack4_t (W4u32.Pack.init k).
proof. by congr; apply W4u32.Pack.all_eq_eq; cbv delta. qed.

lemma pack4_init_red (k0 k1 k2 k3:int ->  W32.t) :
  k0 = k1 => k0 = k2 => k0 = k3 => 
  pack4 [k0 0; k1 1; k2 2; k3 3] = 
  pack4_t (W4u32.Pack.init k0).
proof. by move=> />;rewrite pack4_init. qed.

hint simplify pack4_init_red. *)

equiv eq_store_last : ChaCha20_pref.M.store ~ M.store_last :
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ ={Glob.mem} /\
  (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ 0 <= len{1} <= 64 /\
  k{2} = x_ k{1} 
  ==>
  ={Glob.mem}.
proof.
  transitivity Store.store64_2 
    (={Glob.mem, output, plain, len, k} /\ 0 <= len{1} <= 64 /\ (inv_ptr output plain len){1} ==> ={Glob.mem})
    (output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ ={Glob.mem} /\
        (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ 0 <= len{1} <= 64 /\
        k{2} = x_ k{1} ==> ={Glob.mem}).
  + by move=> /> &1 &2 *; exists Glob.mem{2} (output,plain,len, k){1} => />.
  + done.  
  + by apply eq_store64_2.
  proc => /=.  
  sp 1 2.
  seq 1 1 : (r0{2} = (W8u32.pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]]){1} /\
            ={Glob.mem} /\ output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ (inv_ptr output plain len){1} /\
            (good_ptr output plain len){1} /\ 0 <= len{1} <= 32).
  + if.
    + by move=> /> *; rewrite W32.uleE.
    + wp; ecall (eq_update_ptr output{1} plain{1} len{1} 32).
      ecall{1} (store32_spec output{1} plain{1} k1{1} Glob.mem{1}); wp; skip => 
        /> &1 &2 h1 h2 hinv h3 h4 h5 mem h6 res_L res_R *.
      rewrite /x_ /=;split; 2: smt().
      apply mem_eq_ext => j; rewrite h6 get_storeW256E /in_range.
      case: (to_uint output{2} <= j < to_uint output{2} + 32) => [h | //].
      have hh : 0 <= j - to_uint output{2} < 32 by smt().
      by rewrite /init32 /loadW256 /= initiE 1:// /= bits8_W8u32 hh /= pack32bE 1:// initiE 1:// /= get_of_list 1:/# initiE /#.
    by skip => /> *; rewrite /x_ /= /#.
  inline Store.store32_1.
  sp 5 1.
  seq 1 1 : (r1{2} = (W4u32.pack4 [k10.[0]; k10.[1];k10.[2];k10.[3]]){1} /\
     ={Glob.mem} /\ output0{1} = to_uint output{2} /\ plain0{1} = to_uint plain{2} /\ len0{1} = to_uint len{2} /\ 
       (inv_ptr output0 plain0 len0){1} /\ (good_ptr output0 plain0 len0){1} /\ 0 <= len0{1} <= 16).
  + if.
    + by move=> /> *; rewrite W32.uleE.
    + wp; ecall (eq_update_ptr output0{1} plain0{1} len0{1} 16).
      ecall{1} (store16_spec output0{1} plain0{1} k10{1} Glob.mem{1}); wp; skip => 
        /> &1 &2 hinv h1 h2 h3 h4 h5 mem h6 res_L res_R *.
      rewrite /VEXTRACTI128 b2i_get 1:// /=; split; 2:smt().
      apply mem_eq_ext => j; rewrite h6 get_storeW128E /in_range.
      case: (to_uint output{2} <= j < to_uint output{2} + 16) => [h | //].
      have hh : 0 <= j - to_uint output{2} < 16 by smt().
      rewrite /init32 /loadW128 /= initiE 1:// /b2i /=.
      rewrite pack16bE 1:// initiE 1:// /= initiE 1:/# bits8_W4u32_red 1:// get_of_list /#.
    skip => /> *; rewrite /VEXTRACTI128 /= /#.
  inline Store.store16; exlim Glob.mem{1} => mem0.
  while (i{1} = to_uint j{2} /\ 0 <= len1{1} <= 16 /\ 0 <= i{1} /\
        len1{1} = to_uint len{2} /\ output1{1} = to_uint output{2} /\ plain1{1} = to_uint plain{2} /\
         ={Glob.mem} /\ 
         (inv_ptr output1 plain1 len1 /\ good_ptr output1 plain1 len1){1} /\
         (forall k, !(in_range output1{1} i{1} k) => Glob.mem{1}.[k] = mem0.[k]) /\
         (forall k, in_range 0 len1{1} k => k8{1}.[k] = s0{2}.[k] `^` mem0.[plain1{1} + k])).
  + wp; skip => /> &1 &2 h1 h2 h3 hinv h4 h5 hmem hk h6 h7.
    rewrite ultE W2u32.to_uint_truncateu32 /=. 
    rewrite !to_uintD_small /= 1..3:/# modz_small 1:/# /=.
    split; 1:smt().
    rewrite hk 1:/# /loadW8 hmem 1:/# W8.xorwC /=.
    by move=> k1 hk1; rewrite storeW8E get_setE /#.
  wp; while{1} (0 <= i <= len1 /\ len1 <= 16 /\
               (forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` Glob.mem.[plain1 + j])){1}
              (len1 - i){1}.
  + by move=> _ z; wp; skip => />; smt(WArray16.get_setE).
  wp; skip => /> &1 &2 *; split; 1:smt().
  move=> i_L k8_L; split; 1:smt().
  move=> h1 h2 h3 h4 ; rewrite ultE W2u32.to_uint_truncateu32 //.
  have ->> : i_L = to_uint len{2} by smt().
  move=> k3 *; rewrite h4 1://.
  have h : 0 <= k3 < 16 by smt().
  by rewrite /init32 initE initE /= bits8_W4u32_red h /= get_of_list /#.
qed.

equiv eq_store len0 : ChaCha20_pref.M.store ~ M.store :
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ ={Glob.mem} /\ len{1} = len0 /\
  (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ 64 <= len{1} /\
  k{2} = (x_ k){1} 
  ==>
  res{1}.`1 = to_uint res{2}.`1 /\ res{1}.`2 = to_uint res{2}.`2 /\ res{1}.`3 = to_uint res{2}.`3 /\ 
  (good_ptr res.`1 res.`2 res.`3){1} /\ (inv_ptr res.`1 res.`2 res.`3){1} /\ ={Glob.mem} /\ res{1}.`3 = len0 - 64.
proof.
  proc *.
  ecall{1} (store_pref_spec output{1} plain{1} len{1} k{1} Glob.mem{1}).
  inline *; wp; skip => /> &1 &2  ????; split; 1: smt (W32.to_uint_cmp).
  move=> ? mem_L.
  have -> : min 64 (to_uint len{2}) = 64 by smt().
  rewrite to_uintB 1:uleE 1:// !to_uintD_small /= 1..4:/# => hinv hmem.
  split; 1:smt().
  apply mem_eq_ext => j.
  rewrite hmem get_storeW256E.
  have <- /= := store_256_xor_spec 
            (to_uint output{2}) k{1} Glob.mem{2} (to_uint plain{2}) j.
  by rewrite /x_ /= get_storeW256E.
qed.

equiv eq_store_x2_last : ChaCha20_pavx2_cf.M.store_x2_last ~ M.store_x2_last :
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ ={Glob.mem} /\
  (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ len{1} <= 128 /\
  k{2} = (x2_ k_1 k_2){1} 
  ==>
  ={Glob.mem}.
proof.
  proc => /=.
  call eq_store_last => /=; sp 1 3.
  if.
  + move=> *; rewrite uleE /= /#.
  + wp; ecall (eq_store len{1}); skip => /> &1 &2 *.
    rewrite /x2_ /= /x_ /=; split.
    + by apply Array2.all_eq_eq.
    move=> *;split;1: smt().
    by apply Array2.all_eq_eq.
  skip => /> &1 &2 *; rewrite /x_ /x2_ /=;split; 1:smt(W32.to_uint_cmp).
  by apply Array2.all_eq_eq.
qed.

(* FIXME *)
hint simplify W8.of_intwE.

phoare perm_x2_spec k1 k2 : [M.perm_x2 : k = x2 k1 k2 ==> res = x2_ k1 k2] = 1%r.
proof.
  proc; conseq (_: Array4.all_eq pk (x2_ k1 k2)).
  + by move=>*; rewrite Array4.ext_eq_all.
  by wp; skip => />; cbv delta.
qed.

equiv eq_sum_states_x2 : ChaCha20_pavx2.M.sum_states_x2 ~ M.sum_states_x2 :
  k{2} = (x2 k1_1 k1_2){1} /\ st{2} = (x2 st_1 st_2){1} 
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc => /=.
  conseq (_: Array4.all_eq k{2} (x2 k1{1} k2{1})).
  + by move=> *; apply Array4.all_eq_eq.
  rewrite /x2 /Array4.all_eq.
  inline *; do 2! unroll for{1} ^while; unroll for{2} ^while.
  by wp; skip => />; rewrite /VPADD_8u32 /=.
qed.

equiv eq_sum_states_x4 : ChaCha20_pavx2.M.sum_states_x4 ~ M.sum_states_x4 :
  k1{2} = (x2 k1_1 k1_2){1} /\ k2{2} = (x2 k2_1 k2_2){1} /\ st{2} = (x2 st_1 st_2){1} 
  ==>
  res{2}.`1 = x2 res{1}.`1 res{1}.`2 /\
  res{2}.`2 = x2 res{1}.`3 res{1}.`4.
proof.
  proc => /=; wp.
  do 2!call eq_sum_states_x2; wp; skip => />.
  by move=> [k3 k4]; apply Array4.all_eq_eq; rewrite /x2 /Array4.all_eq /VPADD_8u32 /= g_p2_pack.
qed.

module M' = {
  proc rotate_x8 (k:W256.t Array4.t, a r:int) = {
    k.[a] <-  W8u32.pack8_t (W8u32.Pack.map (fun (x:W32.t) => rol x r) (W8u32.unpack32 k.[a]));
    return k; 
  }

  proc line_x8 (k:W256.t Array4.t, a:int, b:int, c:int, r:int) : W256.t Array4.t = {
    k.[a %/ 4] <- k.[a %/ 4] \vadd32u256 k.[b %/ 4];
    k.[c %/ 4] <- k.[c %/ 4] `^` k.[a %/ 4];
    k <@ rotate_x8 (k, c %/ 4, r);
    return k;
  }
  
  proc round_x2 (k:W256.t Array4.t) : W256.t Array4.t = {
    k <@ line_x8 (k, 0, 4, 12, 16);
    k <@ line_x8 (k, 8, 12, 4, 12);
    k <@ line_x8 (k, 0, 4, 12, 8);
    k <@ line_x8 (k, 8, 12, 4, 7);
    return k;
  }
}.

op eq_x2 (k: W256.t Array4.t, k1 k2 : W32.t Array16.t) =
  List.all (fun i =>
     W8u32.Pack.all_eq 
       (unpack32 k.[i])
       (let i = 4*i in
         W8u32.Pack.of_list [k1.[i]; k1.[i+1]; k1.[i+2]; k1.[i+3]; k2.[i]; k2.[i+1]; k2.[i+2]; k2.[i+3]]))
       (iota_ 0 4).

lemma eq_x2P k1 k2 k : eq_x2 k k1 k2 => k = x2 k1 k2.
proof.
  move=> /List.allP hall; apply Array4.ext_eq => i hi.
  rewrite /x2 Array4.initiE 1:// /= -(W8u32.unpack32K k.[i]); congr.
  by apply W8u32.Pack.all_eq_eq; apply (hall i); apply mema_iota.
qed.

phoare rotate_x8 k0 i0 r0 : 
  [M.rotate_x8 : 
    k = k0 /\ i = i0 /\ r = r0 /\ 0 <= i < 4 /\ 0 < r < 32 /\ r16 = g_r16 /\ r8 = g_r8 
    ==>
    res = k0.[i0 <- W8u32.pack8_t (W8u32.Pack.map (fun (x:W32.t) => rol x r0) (W8u32.unpack32 k0.[i0]))]] = 1%r.
proof.
  proc => /=.
  if. wp;skip => />; rewrite /to_list /mkseq -iotaredE /= /#.  
  if. wp;skip => />; rewrite /to_list /mkseq -iotaredE /= /#.  
  wp;skip => />  hi1 hi2 hr1 hr2 _ _; congr.
  rewrite W256.xorwC get_setE 1:// /= /to_list /mkseq -iotaredE /=.  
  by rewrite x86_8u32_rol_xor //.
qed.

equiv eq_line_x2 :  M'.line_x8 ~ M.line_x8 : 
  ={k, a, b, c, r} /\ 0 < r{1} < 32 /\ 0 <= c{1} < 16 /\ r16{2} = g_r16 /\ r8{2} = g_r8
  ==>
  ={res}.
proof.
  proc.
  ecall{2} (rotate_x8 k{2} (c %/ 4){2} r{2}).
  by inline *;wp;skip => /> &2 * /#.
qed.

equiv eq_round_x2 :  M'.round_x2 ~ M.round_x2 : 
  ={k} /\ r16{2} = g_r16 /\ r8{2} = g_r8
  ==>
  ={res}.
proof. proc;do 4! call eq_line_x2; skip => />. qed.

equiv eq_column_round_x2_aux : ChaCha20_pavx2.M.column_round_x2 ~ M.round_x2 : 
  k{2} = (x2 k1 k2){1} /\ (r16 = g_r16 /\ r8 = g_r8){2} 
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  transitivity M'.round_x2 
    ( k{2} = (x2 k1 k2){1} ==> res{2} = x2 res{1}.`1 res{1}.`2 )
    ( ={k} /\ (r16 = g_r16 /\ r8 = g_r8){2} ==> ={res} ).
  + smt(). + done.
  + proc => /=.
    conseq (_: eq_x2 k{2} k1{1} k2{1}).
    + by move=> *; apply eq_x2P.
    by inline *; wp; skip; cbv delta => &1 &2 -> /=;
       rewrite !of_listK // -iotaredE /=.
  by apply eq_round_x2.
qed.

equiv eq_column_round_x2 : ChaCha20_pavx2.M.column_round_x2 ~ M.column_round_x2 : 
  k{2} = (x2 k1 k2){1} /\ (r16 = g_r16 /\ r8 = g_r8){2} 
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc *; inline M.column_round_x2;wp;call eq_column_round_x2_aux;wp; skip => />.
qed.

equiv eq_shuffle_state : ChaCha20_pavx2.M.shuffle_state ~ M.shuffle_state :
  k{2} = (x2 k1 k2){1} 
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc => /=.
  inline *; wp; skip => /> &1; cbv delta. 
  by apply Array4.all_eq_eq; rewrite /Array4.all_eq.
qed.

equiv eq_reverse_shuffle_state : ChaCha20_pavx2.M.reverse_shuffle_state ~ M.reverse_shuffle_state :
  k{2} = (x2 k1 k2){1} 
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc => /=.
  inline *; wp; skip => /> &1; cbv delta. 
  by apply Array4.all_eq_eq; rewrite /Array4.all_eq /=.
qed.

equiv eq_diagonal_round_x2 : ChaCha20_pavx2.M.diagonal_round_x2 ~ M.diagonal_round_x2 : 
  k{2} = (x2 k1 k2){1} /\ (r16 = g_r16 /\ r8 = g_r8){2} 
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc => /=.
  call eq_reverse_shuffle_state. 
  call eq_column_round_x2_aux.
  by call eq_shuffle_state; skip.
qed.

equiv eq_rounds_x2 : ChaCha20_pavx2.M.rounds_x2 ~ M.rounds_x2 :
  k{2} = (x2 k1_1 k1_2){1}
  ==>
  res{2} = x2 res{1}.`1 res{1}.`2.
proof.
  proc => /=.
  while (#pre /\ (r16 = g_r16 /\ r8 = g_r8){2} /\ c{1} = to_uint c{2} /\ 0 <= c{1} ); last by auto.
  wp; call eq_diagonal_round_x2; call eq_column_round_x2; skip => /> *.
  by rewrite ultE /= W64.to_uintD_small /= /#.
qed.

equiv eq_rounds_x4 : ChaCha20_pavx2.M.rounds_x4 ~ M.rounds_x4 :
  k1{2} = (x2 k1_1 k1_2){1} /\ k2{2} = (x2 k2_1 k2_2){1}
  ==>
  res{2}.`1 = x2 res{1}.`1 res{1}.`2 /\
  res{2}.`2 = x2 res{1}.`3 res{1}.`4.
proof.
  proc => /=.
  while (#pre /\ (r16 = g_r16 /\ r8 = g_r8){2} /\ c{1} = to_uint c{2} /\ 0 <= c{1} ); last by auto.
  inline ChaCha20_pavx2.M.column_round_x4 ChaCha20_pavx2.M.diagonal_round_x4 
     M.column_round_x4 M.diagonal_round_x4 M.round_x4 
     M.shuffle_state_x2 ChaCha20_pavx2.M.shuffle_state_x2
     M.reverse_shuffle_state_x2 ChaCha20_pavx2.M.reverse_shuffle_state_x2.
  wp.
  do 2! call eq_reverse_shuffle_state; wp.
  do 2! call eq_column_round_x2_aux; wp => /=.
  do 2! call eq_shuffle_state; wp.
  do 2!  call eq_column_round_x2_aux; wp; skip => /> *.
  by rewrite ultE /= W64.to_uintD_small /= /#.
qed.

equiv eq_chacha20_less_than_257 :
  ChaCha20_pavx2.M.chacha20_less_than_257 ~ ChaCha20_savx2.M.chacha20_less_than_257 : 
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
  0 <= len{1} <= 256 /\
  key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
  (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
  (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} 
  ==>
  ={Glob.mem}.
proof. 
  proc => /=.
  seq 1 4 : (output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
             0 <= len{1} <= 256 /\
            st{2} = (x2 st_1 st_2) {1} /\ (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ ={Glob.mem}).
  + call eq_init_x2; wp; skip => />.
  if; 1: by move=> /> *; rewrite ultE.
  + call eq_store_x2_last => /=. 
    ecall (eq_store_x2 len{1})=> /=.
    inline M.perm_x4; wp.
    ecall{2} (perm_x2_spec k2_1{1} k2_2{1}).
    ecall{2} (perm_x2_spec k1_1{1} k1_2{1}); wp => /=.
    call eq_sum_states_x4; call eq_rounds_x4 => /=.
    inline ChaCha20_pavx2.M.copy_state_x4 M.copy_state_x4; wp; skip => /> * /=.
    split; 2: smt(). 
    by apply Array4.all_eq_eq; rewrite /VPADD_8u32 /Array4.all_eq /x2 /= g_p2_pack.
  call eq_store_x2_last => /=.  
  ecall{2} (perm_x2_spec k1_1{1} k1_2{1}).
  call eq_sum_states_x2.
  call eq_rounds_x2.
  by inline M.copy_state_x2; auto => /> /#.
qed.

(* ***************************************************************************************************************)
(* ChaCha20_more_than_256                                                                                        *)

op x8 (k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array16.t) =
  Array16.init (fun i => W8u32.pack8 [k1.[i]; k2.[i]; k3.[i]; k4.[i]; k5.[i]; k6.[i]; k7.[i]; k8.[i]]).
(*
  Array16.of_list W256.zero [
     W8u32.pack8 [k1.[0 ]; k2.[0 ]; k3.[0 ]; k4.[0 ]; k5.[0 ]; k6.[0 ]; k7.[0 ]; k8.[0 ]];
     W8u32.pack8 [k1.[1 ]; k2.[1 ]; k3.[1 ]; k4.[1 ]; k5.[1 ]; k6.[1 ]; k7.[1 ]; k8.[1 ]];
     W8u32.pack8 [k1.[2 ]; k2.[2 ]; k3.[2 ]; k4.[2 ]; k5.[2 ]; k6.[2 ]; k7.[2 ]; k8.[2 ]];
     W8u32.pack8 [k1.[3 ]; k2.[3 ]; k3.[3 ]; k4.[3 ]; k5.[3 ]; k6.[3 ]; k7.[3 ]; k8.[3 ]];
     W8u32.pack8 [k1.[4 ]; k2.[4 ]; k3.[4 ]; k4.[4 ]; k5.[4 ]; k6.[4 ]; k7.[4 ]; k8.[4 ]];
     W8u32.pack8 [k1.[5 ]; k2.[5 ]; k3.[5 ]; k4.[5 ]; k5.[5 ]; k6.[5 ]; k7.[5 ]; k8.[5 ]];
     W8u32.pack8 [k1.[6 ]; k2.[6 ]; k3.[6 ]; k4.[6 ]; k5.[6 ]; k6.[6 ]; k7.[6 ]; k8.[6 ]];
     W8u32.pack8 [k1.[7 ]; k2.[7 ]; k3.[7 ]; k4.[7 ]; k5.[7 ]; k6.[7 ]; k7.[7 ]; k8.[7 ]];
     W8u32.pack8 [k1.[8 ]; k2.[8 ]; k3.[8 ]; k4.[8 ]; k5.[8 ]; k6.[8 ]; k7.[8 ]; k8.[8 ]];
     W8u32.pack8 [k1.[9 ]; k2.[9 ]; k3.[9 ]; k4.[9 ]; k5.[9 ]; k6.[9 ]; k7.[9 ]; k8.[9 ]];
     W8u32.pack8 [k1.[10]; k2.[10]; k3.[10]; k4.[10]; k5.[10]; k6.[10]; k7.[10]; k8.[10]];
     W8u32.pack8 [k1.[11]; k2.[11]; k3.[11]; k4.[11]; k5.[11]; k6.[11]; k7.[11]; k8.[11]];
     W8u32.pack8 [k1.[12]; k2.[12]; k3.[12]; k4.[12]; k5.[12]; k6.[12]; k7.[12]; k8.[12]];
     W8u32.pack8 [k1.[13]; k2.[13]; k3.[13]; k4.[13]; k5.[13]; k6.[13]; k7.[13]; k8.[13]];
     W8u32.pack8 [k1.[14]; k2.[14]; k3.[14]; k4.[14]; k5.[14]; k6.[14]; k7.[14]; k8.[14]];
     W8u32.pack8 [k1.[15]; k2.[15]; k3.[15]; k4.[15]; k5.[15]; k6.[15]; k7.[15]; k8.[15]]
  ].
*)

lemma get_x8 (k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array16.t) i: 
  0 <= i < 16 => 
  (x8 k1 k2 k3 k4 k5 k6 k7 k8).[i] = 
     W8u32.pack8 [k1.[i]; k2.[i]; k3.[i]; k4.[i]; k5.[i]; k6.[i]; k7.[i]; k8.[i]].
proof.
  by move => h; rewrite /x8 initE h.
qed.

lemma set_x8 (k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array16.t) i w1 w2 w3 w4 w5 w6 w7 w8: 
  0 <= i < 16 =>
  (x8 k1 k2 k3 k4 k5 k6 k7 k8).[i <- W8u32.pack8 [w1;w2;w3;w4;w5;w6;w7;w8]] =
  x8 k1.[i<-w1] k2.[i<-w2] k3.[i<-w3] k4.[i<-w4] k5.[i<-w5] k6.[i<-w6] k7.[i<-w7] k8.[i<-w8].
proof.
  move=> hi; apply Array16.ext_eq => j hj.  
  rewrite /x8 setE 2!initE hj /= initE hj /= !Array16.get_set_if hi /=.
  by case: (j = i).
qed.

phoare rotate_x8_s k0 i0 r0 : 
  [M.rotate_x8_s : 
    k = k0 /\ i = i0 /\ r = r0 /\ 0 <= i < 16 /\ 0 < r < 32 /\ r16 = g_r16 /\ r8 = g_r8 
    ==>
    res = k0.[i0 <- W8u32.pack8_t (W8u32.Pack.map (fun (x:W32.t) => rol x r0) (W8u32.unpack32 k0.[i0]))]] = 1%r.
proof.
  proc => /=.
  if; 1: by wp;skip => /> ??; rewrite /unpack32 /= /to_list /mkseq -iotaredE /= !initiE //=.
  if; 1: by wp;skip => /> ??; rewrite /unpack32 /= /to_list /mkseq -iotaredE /= !initiE //=.
  wp;skip => /> &m hi1 hi2 hr1 hr2 _; congr.
  rewrite W256.xorwC get_setE 1:// /unpack32 /= /to_list /mkseq -iotaredE /=. 
  by rewrite x86_8u32_rol_xor //.
qed.

equiv eq_line_x8_v_ a_ c_ k_ : ChaCha20_pavx2.M.line_x1_8 ~ M._line_x8_v :
  ={a,b,c,r} /\ k{2} = k_ /\ a{1} = a_ /\ c{1} = c_ /\
   k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1} /\ 
   0 <= a{1} < 16 /\ 0 <= b{1} < 16 /\ 0 <= c{1} < 16 /\ 0 < r{1} < 32 /\
   r16{2} = g_r16 /\ r8{2} = g_r8 
  ==> 
  res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8 /\
  forall i, 0 <= i < 16 => i <> a_ => i <> c_ => res{2}.[i] = k_.[i].
proof.
  proc => /=.
  inline{1} ChaCha20_pref.M.line.
  interleave{1} [2:4] [11:4] [20:4] [29:4] [38:4] [47:4] [56:4] [65:4] 1.
  swap{1} 1 32.
  interleave{1} [33:1] [38:1] [43:1] [48:1] [53:1] [58:1] [63:1] [68:1] 5.
  sp 32 0.
  seq 16 1 : (#{/~k{2}}pre /\ k{2} = (x8 k k0 k9 k10 k11 k12 k13 k14){1} /\
                forall i, 0 <= i < 16 => i <> a_ => i <> c_ => k{2}.[i] = k_.[i]).
  + wp;skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hr1 hr2.
    split; 1: by rewrite /VPADD_8u32 !get_x8 1,2:// -set_x8.
    by move=> ??? h ?;rewrite Array16.get_setE // h.
  seq 8 1 : (#pre). 
  + wp;skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hr1 hr2 hi.
    split; 1: by rewrite !get_x8 1,2:// -set_x8.
    by move=> ???? h;rewrite Array16.get_setE // h /= hi.
  wp;ecall{2} (rotate_x8_s k{2} c{2} r{2}); skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hr1 hr2 hi.
  split; 1: by rewrite !get_x8 1,2:// -set_x8 // /unpack32 /= /to_list /mkseq -iotaredE /=.
  by move=> ???? h;rewrite Array16.get_setE // h /= hi.
qed.

equiv eq_line_2 a0_ c0_ a1_ c1_ k_ :  ChaCha20_pavx2.M.line_2_x1_8 ~ M.line_x8_v : 
  ={a0,b0,c0,r0,a1,b1,c1,r1} /\ k{2} = k_ /\ a0{1} = a0_ /\ c0{1} = c0_ /\ a1{1} = a1_ /\ c1{1} = c1_ /\
   k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1} /\ 
   0 <= a0{1} < 16 /\ 0 <= b0{1} < 16 /\ 0 <= c0{1} < 16 /\ 0 < r0{1} < 32 /\
   0 <= a1{1} < 16 /\ 0 <= b1{1} < 16 /\ 0 <= c1{1} < 16 /\ 0 < r1{1} < 32 /\
   r16{2} = g_r16 /\ r8{2} = g_r8 
  ==> 
  res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8 /\
  forall i, 0 <= i < 16 => i <> a0_ => i <> c0_ => i <> a1_ => i <> c1_ => res{2}.[i] = k_.[i].
proof.
  proc => /=.
  inline{1} ChaCha20_pavx2.M.line_2.
  interleave{1} [2:8] [18:8] [34:8] [50:8] [66:8] [82:8] [98:8] [114:8] 1.
  swap{1} 1 64.
  interleave{1} [65:1] [73:1] [81:1] [89:1] [97:1] [105:1] [113:1] [121:1] 8.
  sp 64 0.
  seq 16 1 : (#{/~k{2}}pre /\ k{2} = (x8 k k0 k9 k10 k11 k12 k13 k14){1} /\
     forall i, 0 <= i < 16 => i <> a0_ => i <> c0_ => i <> a1_ => i <> c1_ => k{2}.[i] = k_.[i]).
  + wp;skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hd1 hd2 ha1' ha2' hb1' hb2' hc1' hc2' hd1' hd2'.
    split; 1: by rewrite /VPADD_8u32 !get_x8 1,2:// -set_x8.
    by move=> ??? h *;rewrite Array16.get_setE // h.
  seq 8 1 : (#pre).
  + wp;skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hd1 hd2 ha1' ha2' hb1' hb2' hc1' hc2' hd1' hd2' hi.
    split; 1: by rewrite /VPADD_8u32 !get_x8 1,2:// -set_x8. 
    by move=> ????? h *;rewrite Array16.get_setE // h /= hi.
  seq 8 1 : (#pre). 
  + wp;skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hd1 hd2 ha1' ha2' hb1' hb2' hc1' hc2' hd1' hd2' hi.
    split; 1: by rewrite !get_x8 1,2:// -set_x8.
    by move=> ???? h *;rewrite Array16.get_setE // h /= hi.
  seq 8 1 : (#pre). 
  + wp;skip => /> &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hd1 hd2 ha1' ha2' hb1' hb2' hc1' hc2' hd1' hd2' hi.
    split; 1: by rewrite !get_x8 1,2:// -set_x8.
    by move=> ?????? h;rewrite Array16.get_setE // h /= hi.
  seq 8 1 : (#pre).
  + wp; ecall{2} (rotate_x8_s k{2} c0{2} r0{2}); skip => /> 
      &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hd1 hd2 ha1' ha2' hb1' hb2' hc1' hc2' hd1' hd2' hi.
  split; 1: by rewrite !get_x8 1,2:// -set_x8 // /unpack32 /= /to_list /mkseq -iotaredE /=.
    by move=> ???? h *;rewrite Array16.get_setE // h /= hi.
  wp; ecall{2} (rotate_x8_s k{2} c1{2} r1{2}); skip => /> 
    &1 &2 ha1 ha2 hb1 hb2 hc1 hc2 hd1 hd2 ha1' ha2' hb1' hb2' hc1' hc2' hd1' hd2' hi.
  split; 1: by rewrite !get_x8 1,2:// -set_x8 // /unpack32 /= /to_list /mkseq -iotaredE /=.
  by move=> ?????? h;rewrite Array16.get_setE // h /= hi.
qed.

equiv eq_double_quarter_round_x8 a0_ b0_ c0_ d0_ a1_ b1_ c1_ d1_ k_ : 
    ChaCha20_pavx2.M.double_quarter_round_x8 ~ 
    ChaCha20_savx2.M.double_quarter_round_x8: 
    ={a0,b0,c0,d0,a1,b1,c1,d1} /\
     k{2} = k_ /\ a0{1} = a0_ /\ b0{1} = b0_ /\ c0{1} = c0_ /\ d0{1} = d0_ /\
                  a1{1} = a1_ /\ b1{1} = b1_ /\ c1{1} = c1_ /\ d1{1} = d1_ /\ 
     k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1}  /\ 
     0 <= a0{1} < 16 /\ 0 <= b0{1} < 16 /\ 0 <= c0{1} < 16 /\ 0 <= d0{1} < 16  /\
     0 <= a1{1} < 16 /\ 0 <= b1{1} < 16 /\ 0 <= c1{1} < 16 /\ 0 <= d1{1} < 16  /\
     r16{2} = g_r16 /\ r8{2} = g_r8 
    ==> 
    res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8 /\
     forall i, 0 <= i < 16 => i <> a0_ => i <> b0_ => i <> c0_ => i <> d0_ =>
                             i <> a1_ => i <> b1_ => i <> c1_ => i <> d1_ =>
               res{2}.[i] = k_.[i].
proof.
  proc => /=; wp.
  ecall (eq_line_x8_v_ c1_ b1_ k{2})=> /=.
  ecall (eq_line_2 c0_ b0_ a1_ d1_ k{2})=> /=.
  ecall (eq_line_2 a0_ d0_ c1_ b1_ k{2})=> /=.
  ecall (eq_line_2 c0_ b0_ a1_ d1_ k{2})=> /=.
  ecall (eq_line_x8_v_ a0_ d0_ k{2})=> /=; skip => /> /#.
qed.

equiv eq_column_round_x8 : ChaCha20_pavx2.M.column_round_x8 ~ ChaCha20_savx2.M.column_round_x8 : 
  k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1}  /\
   k15{2} = k{2}.[15] /\ s_r16{2} = g_r16 /\ s_r8{2} = g_r8 
  ==> 
  res{2}.`1 = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8 /\
   res{2}.`2 = res{2}.`1.[14].
proof.
  proc => /=; wp.
  ecall (eq_double_quarter_round_x8 1 5 9 13 3 7 11 15 k{2}); wp => /=.
  ecall (eq_double_quarter_round_x8 0 4 8 12 2 6 10 14 k{2}); wp => /=.
  skip => /> &1 r1 hi.
  by rewrite -(hi 15) // Array16.set_notmod /= => r2 ->. 
qed.

equiv eq_diagonal_round_x8 : ChaCha20_pavx2.M.diagonal_round_x8 ~ ChaCha20_savx2.M.diagonal_round_x8 : 
  k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1}  /\
   k14{2} = k{2}.[14] /\ s_r16{2} = g_r16 /\ s_r8{2} = g_r8 
  ==> 
  res{2}.`1 = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8 /\
   res{2}.`2 = res{2}.`1.[15].
proof.
  proc => /=; wp.
  ecall (eq_double_quarter_round_x8 2 7 8 13 3 4 9 14 k{2}); wp => /=.
  ecall (eq_double_quarter_round_x8 1 6 11 12 0 5 10 15 k{2}); wp => /=.
  skip => /> &1 r1 hi.
  by rewrite -(hi 14) // Array16.set_notmod /= => r2 ->. 
qed.

equiv eq_rounds_x8 : ChaCha20_pavx2.M.rounds_x8 ~ ChaCha20_savx2.M.rounds_x8 :
  k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1} /\ s_r16{2} = g_r16 /\ s_r8{2} = g_r8 
  ==> 
  res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8.
proof.
  proc => /=; wp.
  rcondt{1} ^while; 1:by auto.
  while (#pre /\ (k15 = k.[15]){2} /\ c{1} = 10 - W64.to_uint c{2} /\ zf{2} = (c{2} = W64.zero)).
  + wp; call eq_diagonal_round_x8; call eq_column_round_x8; skip => /> &2 ? h2 *.
    have /#:= DEC_64_counter 10 c{2} h2.
  wp; call eq_diagonal_round_x8; call eq_column_round_x8; wp; skip => /> *.
  have h2 : (of_int 10)%W64 <> W64.zero.
  + by apply negP => heq; have : 10 = 0 by rewrite -W64.to_uint0 -heq.
  have /> := DEC_64_counter 10 (W64.of_int 10) h2.
  smt (Array16.set_notmod).
qed.
 
equiv eq_init_x8 : ChaCha20_pavx2.M.init_x8 ~ M.init_x8 : 
  key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
  (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} 
  ==>
  res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8.
proof.
  proc => /=.
  inline ChaCha20_pref.M.init.
  do 2! unroll for{1} ^while; do 2! unroll for{2} ^while.
  conseq (_ : Array16.all_eq st_{2} (x8 st1{1} st2{1} st3{1} st4{1} st5{1} st6{1} st7{1} st8{1})).
  + by move=> *; apply Array16.all_eq_eq.
  wp; skip; cbv delta => /> &2 h1 h2.
  have -> /= : to_uint (key{2} + W64.of_int 4) = to_uint key{2} + 4.
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (key{2} + W64.of_int 8) = to_uint key{2} + 8.  
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (key{2} + W64.of_int 12) = to_uint key{2} + 12.  
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (key{2} + W64.of_int 16) = to_uint key{2} + 16.  
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (key{2} + W64.of_int 20) = to_uint key{2} + 20.  
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (key{2} + W64.of_int 24) = to_uint key{2} + 24.  
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (key{2} + W64.of_int 28) = to_uint key{2} + 28.  
  + by rewrite W64.to_uintD_small //= /#.
  have -> /= : to_uint (nonce{2} + W64.of_int 4) = to_uint nonce{2} + 4.
  + by rewrite W64.to_uintD_small //= /#.
  have -> // : to_uint (nonce{2} + W64.of_int 8) = to_uint nonce{2} + 8.  
  by rewrite W64.to_uintD_small //= /#.
  by rewrite -iotaredE /=.
qed.
  
equiv eq_increment_counter_x8 : ChaCha20_pavx2.M.increment_counter_x8 ~ M.increment_counter_x8 : 
  s{2} = (x8 st1 st2 st3 st4 st5 st6 st7 st8){1} 
  ==> 
  res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8.
proof.
  proc => /=; wp; skip => /> &1.
  rewrite -set_x8 1:// get_x8 1://; congr.
  rewrite /VPADD_8u32 /= /unpack32 /map2 /=; apply W8u32.allP => /=;cbv delta.
  do !(split;1:ring); ring.
qed.

op upd_mem (fs:(int -> W8.t) list) (mem:global_mem_t) (output:address) (j:int) = 
  if in_range output (64 * size fs) j then
    let j = j - output in 
     (nth witness fs (j%/64)) (j%%64)
  else mem.[j].

lemma upd_mem_rcons f fs mem output j :
  upd_mem (rcons fs f) mem output j = 
  if in_range (output + 64 * size fs) 64 j then f ((j-output)%%64) 
  else upd_mem fs mem output j.
proof.
  rewrite /upd_mem size_rcons.
  case: (in_range (output + 64 * size fs) 64 j) => hj. 
  + have -> /= : in_range output (64 * (size fs + 1)) j by smt(size_ge0).  
    by rewrite nth_rcons /#.
  have -> : in_range output (64 * (size fs + 1)) j = in_range output (64 * size fs) j by smt(size_ge0). 
  case: (in_range output (64 * size fs) j) => // hj1.
  by rewrite /= nth_rcons /#.
qed.

lemma upd_mem_one f mem output j :
  upd_mem [f] mem output j = 
  if in_range output 64 j then f ((j-output)%%64) 
  else mem.[j].
proof. rewrite (upd_mem_rcons f [] mem output j) /= /upd_mem /= /#. qed.

op xor_mem (mem:global_mem_t) plain i (k:W32.t Array16.t) j = 
  (WArray64.init32 (fun (i0 : int) => k.[i0])).[j] `^` mem.[plain + 64 * i + j].

op mapi (n:int) (f:int -> 'a -> 'b) (xs:'a list) =
  with xs = "[]" => []
  with xs = (::) y ys => f n y :: mapi (n+1) f ys.

lemma mapi_rcons n (f:int -> 'a -> 'b) xs x :
   mapi n f (rcons xs x) = rcons (mapi n f xs) (f (n + size xs) x).
proof. elim: xs n => //= xs hrec n;rewrite hrec /#. qed.

lemma size_mapi  n (f:int -> 'a -> 'b) xs : size (mapi n f xs) = size xs.
proof. by elim: xs n => //= xs hrec n;rewrite hrec. qed.

hoare store64_spec output0 plain0 len0 k0 mem0 : ChaCha20_pref.M.store : 
  output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 
  64 <= len /\ inv_ptr output plain len 
  ==>
  inv_ptr res.`1 res.`2 res.`3 /\ 
  res = (output0 + 64, plain0 + 64, len0 - 64) /\
  forall j, 
    Glob.mem.[j] = 
      if in_range output0 64 j then
        let j = j - output0 in
        (WArray64.init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j].
proof.
  proc; inline *; wp.
  while (0 <= i <= min 64 len /\ 
    forall j, Glob.mem.[j] = if in_range output i j then k8.[j - output] else mem0.[j]).
  + wp; skip => /> &hr h0i _ hj hi; split; 1: smt().
    by move=> j; rewrite storeW8E get_setE hj; smt().
  wp; while(0 <= i <= min 64 len /\
    forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` loadW8 Glob.mem (plain + j)).
  + wp; skip => />; smt (WArray64.get_setE).
  by wp; skip => /> /#.
qed.

op xor_mem_half (o:int) (mem:global_mem_t) output plain i (k:W32.t Array8.t) j = 
  if o <= j < o + 32 then
     (WArray32.init32
       (fun (i0 : int) => k.[i0])).[j-o] `^` mem.[plain + 64 * i + j]
  else mem.[output + 64 * i + j].

op disj_or_eq (output plain len: int) = 
   plain = output \/ plain + len <= output \/ output + len <= plain.

module StoreHalfInt = {
  proc store_half_x8
    (output:int, plain:int, len:int, k:W256.t Array8.t, o:int) : unit =
  {
    var aux, i : int;
    
    i <- 0;
    while (i < 8) {
      k.[i] <- k.[i] `^` (loadW256 Glob.mem (plain + o + (64 * i)));
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      Glob.mem <- storeW256 Glob.mem (output + o + (64 * i)) k.[i];
      i <- i + 1;
    }
  }
}.

op half_x8 (k1 k2 k3 k4 k5 k6 k7 k8: W32.t Array8.t) =
  Array8.init (fun i => W8u32.pack8 [k1.[i]; k2.[i]; k3.[i]; k4.[i]; k5.[i]; k6.[i]; k7.[i]; k8.[i]]).

op half_x8_ (k1 k2 k3 k4 k5 k6 k7 k8 : W32.t Array8.t) =
  Array8.of_list witness [
    W8u32.pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]];
    W8u32.pack8 [k2.[0]; k2.[1]; k2.[2]; k2.[3]; k2.[4]; k2.[5]; k2.[6]; k2.[7]];
    W8u32.pack8 [k3.[0]; k3.[1]; k3.[2]; k3.[3]; k3.[4]; k3.[5]; k3.[6]; k3.[7]];
    W8u32.pack8 [k4.[0]; k4.[1]; k4.[2]; k4.[3]; k4.[4]; k4.[5]; k4.[6]; k4.[7]];
    W8u32.pack8 [k5.[0]; k5.[1]; k5.[2]; k5.[3]; k5.[4]; k5.[5]; k5.[6]; k5.[7]];
    W8u32.pack8 [k6.[0]; k6.[1]; k6.[2]; k6.[3]; k6.[4]; k6.[5]; k6.[6]; k6.[7]];
    W8u32.pack8 [k7.[0]; k7.[1]; k7.[2]; k7.[3]; k7.[4]; k7.[5]; k7.[6]; k7.[7]];
    W8u32.pack8 [k8.[0]; k8.[1]; k8.[2]; k8.[3]; k8.[4]; k8.[5]; k8.[6]; k8.[7]]].

lemma mapi_map2 n (f : int -> 'a -> 'b) (s : 'a list) :
  mapi n f s = map2 (fun i x => f i x) (range n (n + size s)) s.
proof.
elim: s n => //= [@/range //|x s ih] n.
by rewrite -iotaredE /=. 
rewrite (@range_cat (n + 1)); 1,2:smt(size_ge0).
rewrite rangeS addzCA addzA (@addzC 1) -(@cat1s x).
by rewrite map2_cat //= -ih.
qed.

hoare pavx2_half_store_x8_spec mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0 o0:
  StoreHalfInt.store_half_x8 :
       disj_or_eq output plain len
    /\ k = half_x8_ k1 k2 k3 k4 k5 k6 k7 k8
    /\ (o0 = 0 \/ o0 = 32)
    /\ output = output0
    /\ plain = plain0
    /\ o = o0
    /\ len = len0
    /\ 512 <= len
    /\ Glob.mem = mem0 
  ==>
    forall j, Glob.mem.[j] =
       upd_mem
         (mapi 0 (xor_mem_half o0 mem0 output0 plain0)
         [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j.
proof.
  proc=> /=.
  seq 2 : (#{~k=_}pre /\ forall j, 0 <= j < 8 => 
    k.[j] = (half_x8_ k1 k2 k3 k4 k5 k6 k7 k8).[j] `^` loadW256 mem0 (plain0 + o0 + 64 * j)).
  sp; while {1} (0 <= i <= 8 /\ #[/2:]{~k=_}pre /\ forall j, 0 <= j < 8 =>
    if j < i then
      k.[j] = (half_x8_ k1 k2 k3 k4 k5 k6 k7 k8).[j] `^` loadW256 Glob.mem (plain0 + o0 + 64 * j)
    else k.[j] = (half_x8_ k1 k2 k3 k4 k5 k6 k7 k8).[j]).
  - by auto=> /> *; smt(Array8.get_setE).
  - by auto=> /> /#.
  pose T j := take j [k1; k2; k3; k4; k5; k6; k7; k8].
  sp; while {1} (0 <= i <= 8 /\ #[/2:]{~Glob.mem=_}pre /\ forall (j : address),
    Glob.mem.[j] = upd_mem
      (mapi 0 (xor_mem_half o0 mem0 output0 plain0) (T i)) mem0 output0 j).
  - auto=> /> &hr 5? H4 H5 H6 *; split; 1: by smt().
    move=> j; rewrite /T (@take_nth witness) // -/(T _).
    pose k' := nth _ _ _; rewrite mapi_rcons upd_mem_rcons.
    rewrite size_mapi {1}/T size_take //= H6 //=.
    rewrite get_storeW256E /= H5.
    case (output0 + o0 + 64 * i{hr} <= j < output0 + o0 + 64 * i{hr} + 32) => hj.
    + have -> /= : in_range (output0 + 64 * i{hr}) 64 j by smt().
      rewrite /xor_mem_half. 
      have -> : (j - output0) %% 64 =  j - (output0 + 64 * i{hr}) by smt().
      have -> /= : o0 <= j - (output0 + 64 * i{hr}) < o0 + 32 by smt().
      rewrite H4 1:// W32u8.xorb8E; congr.
      + rewrite /init32 initiE 1:/#. beta.
        have -> : (half_x8_ k1 k2 k3 k4 k5 k6 k7 k8).[i{hr}] = W8u32.pack8 (Array8.to_list k').
        + rewrite /k'; have : i{hr} \in (iota_ 0 8) by rewrite mem_iota.
          move: (i{hr}); apply List.allP; rewrite /= /half_x8_ /= -iotaredE.
          by  rewrite /to_list /mkseq -iotaredE /=.
        rewrite /to_list /mkseq -iotaredE /= bits8_W8u32_red 1:/# get_of_list /#.
      by rewrite /loadW256 pack32bE 1:/#  initiE 1:/# /= /#.
    case (in_range (output0 + 64 * i{hr}) 64 j) => [hj1 | //].
    rewrite {2}/xor_mem_half.
    have -> : (j - output0) %% 64 =  j - (output0 + 64 * i{hr}) by  smt().
    have -> : !(o0 <= j - (output0 + 64 * i{hr}) < o0 + 32) by smt().
    rewrite /= /upd_mem size_mapi {1}/T size_take // /= H6 /= /#.
  by skip => /> @/T; smt().
qed.

hoare savx2_half_store_x8_spec mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0 o0:
  M.store_half_x8 :
       disj_or_eq output0 plain0 len0 /\ good_ptr output0 plain0 len0 
    /\ k = half_x8_ k1 k2 k3 k4 k5 k6 k7 k8
    /\ (o0 = 0 \/ o0 = 32)
    /\ to_uint output = output0
    /\ to_uint plain = plain0
    /\ o = o0
    /\ to_uint len = len0
    /\ 512 <= len0
    /\ Glob.mem = mem0 
  ==>
    forall j, Glob.mem.[j] =
       upd_mem
         (mapi 0 (xor_mem_half o0 mem0 output0 plain0)
         [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j.
proof.
  bypr => &m [#] h1 h2 h3 h4 hout hplain ho hlen h5 hmem.
  have <- : 
    Pr[StoreHalfInt.store_half_x8(output0, plain0, len0, k{m}, o0) @ &m :
      ! (forall (j : address),
        Glob.mem.[j] =
        upd_mem (mapi 0 (xor_mem_half o0 mem0 output0 plain0) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j)] =
    Pr[M.store_half_x8(output{m}, plain{m}, len{m}, k{m}, o{m}) @ &m :
      ! (forall (j : address),
        Glob.mem.[j] =
        upd_mem (mapi 0 (xor_mem_half o0 mem0 output0 plain0) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j)].
  + byequiv (_ : output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ 512 <= len{1} /\
                 (o = 0 \/ o = 32){1} /\
                 ={Glob.mem, o, k} /\ good_ptr output{1} plain{1} len{1} ==> ={Glob.mem}).
    + proc.
      while (={i,o,k,Glob.mem} /\ good_ptr output{1} plain{1} len{1} /\ 0 <= i{1} /\
             output{1} = to_uint output{2} /\ 512 <= len{1} /\ (o = 0 \/ o = 32){1}).
      + wp;skip => /> &1 &2 *;split;2:smt().
        have h : to_uint (W64.of_int (o{2} + 64 * i{2})) = o{2} + 64 * i{2}.
        + by apply W64.to_uint_small => /= /#.
        by rewrite W64.to_uintD_small h /= /#.
      wp; while (={i,o,k,Glob.mem} /\ good_ptr output{1} plain{1} len{1} /\ 0 <= i{1} /\
             plain{1} = to_uint plain{2} /\ 512 <= len{1} /\ (o = 0 \/ o = 32){1}). 
      + wp; skip=> /> &1 &2 *; split; 2:smt().
        have h : to_uint (W64.of_int (o{2} + 64 * i{2})) = o{2} + 64 * i{2}.
        + by apply W64.to_uint_small => /= /#.
        by rewrite W64.to_uintD_small h /= /#.
      by wp; skip => />.
    + by move=> />; rewrite hout hplain hlen ho.
    done.
  byphoare (_:    disj_or_eq output plain len
               /\ k = half_x8_ k1 k2 k3 k4 k5 k6 k7 k8
               /\ (o0 = 0 \/ o0 = 32)
               /\ output = output0
               /\ plain = plain0
               /\ o = o0
               /\ len = len0
               /\ 512 <= len
               /\ Glob.mem = mem0 
             ==>
               !forall j, Glob.mem.[j] =
                  upd_mem
                  (mapi 0 (xor_mem_half o0 mem0 output0 plain0)
                  [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j) => //.
  by hoare; conseq (pavx2_half_store_x8_spec mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0 o0).
qed.

(*
lemma W8u32_bits128_0 (w:W8u32.Pack.pack_t) :
  pack8_t w \bits128 0 = pack4 [w.[0]; w.[1]; w.[2]; w.[3]].
proof. by rewrite -{1}(W8u32.Pack.to_listK w) /= -pack2_4u32_8u32. qed.

lemma W8u32_bits128_1 (w:W8u32.Pack.pack_t) :
  pack8_t w \bits128 1 = pack4 [w.[4]; w.[5]; w.[6]; w.[7]].
proof. by rewrite -{1}(W8u32.Pack.to_listK w) /= -pack2_4u32_8u32. qed.

lemma W4u32_bits64_0 (w:W4u32.Pack.pack_t) :
  pack4_t w \bits64 0 = pack2 [w.[0]; w.[1]].
proof. by rewrite -{1}(W4u32.Pack.to_listK w) /= -pack2_2u32_4u32. qed.

lemma W4u32_bits64_1 (w:W4u32.Pack.pack_t) :
  pack4_t w \bits64 1 = pack2 [w.[2]; w.[3]].
proof. by rewrite -{1}(W4u32.Pack.to_listK w) /= -pack2_2u32_4u32. qed.
*)
(*lemma W2u128_W8u32 (w:W2u128.Pack.pack_t) : 
   pack2_t w = pack8 [w.[0] \bits32 0 ; w.[0] \bits32 1; w.[0] \bits32 2 ; w.[0] \bits32 3;
                      w.[1] \bits32 0 ; w.[1] \bits32 1; w.[1] \bits32 2 ; w.[1] \bits32 3].
proof.
  rewrite -pack2_4u32_8u32; congr.
  apply W2u128.Pack.all_eq_eq; rewrite /all_eq /=.
  rewrite -{1}(W4u32.unpack32K w.[0]) -{1}(W4u32.unpack32K w.[1]).
  by rewrite /unpack32;split;congr;rewrite W4u32.Pack.init_of_list.
qed.*)

(*
hint simplify (W8u32_bits128_0, W8u32_bits128_1, W4u32_bits64_0, W4u32_bits64_1).
*)
(*
lemma VPUNPCKH_8u32_spec (v0 v1 v2 v3 v4 v5 v6 v7 : W32.t) 
                             (w0 w1 w2 w3 w4 w5 w6 w7 : W32.t): 
  VPUNPCKH_8u32 (W8u32.pack8 [v0; v1; v2; v3; v4; v5; v6; v7])
                    (W8u32.pack8 [w0; w1; w2; w3; w4; w5; w6; w7]) =
  W8u32.pack8 [v2; w2; v3; w3; v6; w6; v7; w7].
proof. by cbv delta. qed.
qed.

lemma VPUNPCKL_8u32_spec (v0 v1 v2 v3 v4 v5 v6 v7 : W32.t) 
                             (w0 w1 w2 w3 w4 w5 w6 w7 : W32.t): 
  VPUNPCKL_8u32 (W8u32.pack8 [v0; v1; v2; v3; v4; v5; v6; v7])
                    (W8u32.pack8 [w0; w1; w2; w3; w4; w5; w6; w7]) =
  W8u32.pack8 [v0; w0; v1; w1; v4; w4; v5; w5].
proof.
  by cbv delta; rewrite -(pack2_4u32_8u32 v0 w0); congr; apply W2u128.Pack.all_eq_eq; rewrite /all_eq.
qed.

lemma VPERM2I128_8u32_spec_32 (v0 v1 v2 v3 v4 v5 v6 v7 : W32.t) (w0 w1 w2 w3 w4 w5 w6 w7 : W32.t):
  VPERM2I128 (W8u32.pack8 [v0; v1; v2; v3; v4; v5; v6; v7]) (W8u32.pack8 [w0; w1; w2; w3; w4; w5; w6; w7]) (W8.of_int 32) =
  W8u32.pack8 [v0; v1; v2; v3; w0; w1; w2; w3].
proof.
  by cbv delta; rewrite !of_intwE; cbv delta; rewrite pack2_4u32_8u32.
qed.

lemma VPERM2I128_8u32_spec_49 (v0 v1 v2 v3 v4 v5 v6 v7 : W32.t) (w0 w1 w2 w3 w4 w5 w6 w7 : W32.t):
  VPERM2I128 (W8u32.pack8 [v0; v1; v2; v3; v4; v5; v6; v7]) (W8u32.pack8 [w0; w1; w2; w3; w4; w5; w6; w7]) (W8.of_int 49) =
  W8u32.pack8 [v4; v5; v6; v7; w4; w5; w6; w7].
proof.
  by cbv delta; rewrite !of_intwE; cbv delta; rewrite pack2_4u32_8u32.
qed.

lemma VPUNPCKL_4u64_8u32 (v0 v1 v2 v3 v4 v5 v6 v7 : W32.t) (w0 w1 w2 w3 w4 w5 w6 w7 : W32.t):
  VPUNPCKL_4u64 (W8u32.pack8 [v0; v1; v2; v3; v4; v5; v6; v7]) (W8u32.pack8 [w0; w1; w2; w3; w4; w5; w6; w7]) =
  W8u32.pack8 [v0;v1;w0;w1;v4;v5;w4;w5].
proof.
  by cbv delta; rewrite W2u128.Pack.init_of_list /= !pack2_2u32_4u32 pack2_4u32_8u32 .
qed.

lemma VPUNPCKH_4u64_8u32 (v0 v1 v2 v3 v4 v5 v6 v7 : W32.t) (w0 w1 w2 w3 w4 w5 w6 w7 : W32.t):
  VPUNPCKH_4u64 (W8u32.pack8 [v0; v1; v2; v3; v4; v5; v6; v7]) (W8u32.pack8 [w0; w1; w2; w3; w4; w5; w6; w7]) =
  W8u32.pack8 [v2;v3;w2;w3;v6;v7;w6;w7].
proof.
  by cbv delta; rewrite W2u128.Pack.init_of_list /= !pack2_2u32_4u32 pack2_4u32_8u32 .
qed.

hint simplify (VPUNPCKH_8u32_spec, VPUNPCKL_8u32_spec, VPERM2I128_8u32_spec_32, VPERM2I128_8u32_spec_49,
               VPUNPCKL_4u64_8u32, VPUNPCKH_4u64_8u32).
*)
hoare rotate_spec k1 k2 k3 k4 k5 k6 k7 k8 : ChaCha20_savx2.M.rotate :
   x = half_x8 k1 k2 k3 k4 k5 k6 k7 k8 ==>
   res = half_x8_ k1 k2 k3 k4 k5 k6 k7 k8.
proof.
  conseq (_: Array8.all_eq res (half_x8_ k1 k2 k3 k4 k5 k6 k7 k8)).
  + by move=> *;apply Array8.all_eq_eq.
  proc.
  inline M.sub_rotate.
  unroll for ^while.   
  unroll for ^while.
  by wp; skip => &hr /= ->; cbv delta.
qed.

hoare rotate_stack_spec k1 k2 k3 k4 k5 k6 k7 k8 : ChaCha20_savx2.M.rotate_stack :
   s = half_x8 k1 k2 k3 k4 k5 k6 k7 k8 ==>
   res = half_x8_ k1 k2 k3 k4 k5 k6 k7 k8.
proof.
  conseq (_: Array8.all_eq res (half_x8_ k1 k2 k3 k4 k5 k6 k7 k8)).
  + by move=> *;apply Array8.all_eq_eq.
  proc.
  inline M.sub_rotate.
  do 3!(unroll for ^while).   
  by wp; skip => &hr /= ->;cbv delta.
qed.

phoare store_half_x8_ll : [ M.store_half_x8 : true ==> true] = 1%r.
proof.
  proc.
  while true (8 - i); 1: by move=> z;auto => /#.
  wp; while true (8 - i); 1: by move=> z;auto => /#.
  by auto => /#.
qed.

phoare sub_rotate_ll : [ M.sub_rotate : true ==> true] = 1%r.   
proof. by proc; while true (4 - i); auto => /#. qed.

phoare rotate_stack_pspec k1 k2 k3 k4 k5 k6 k7 k8 : 
  [ChaCha20_savx2.M.rotate_stack :
   s = half_x8 k1 k2 k3 k4 k5 k6 k7 k8 ==>
   res = half_x8_ k1 k2 k3 k4 k5 k6 k7 k8] = 1%r.
proof.
  conseq (_:true ==> true) (rotate_stack_spec k1 k2 k3 k4 k5 k6 k7 k8).
  + done.
  proc;do 2! unroll for ^while.
  by call sub_rotate_ll;auto.
qed.

op sub8 i (k:'a Array16.t) = Array8.of_list witness (Array16.sub k i 8).

hoare rotate_first_half_x8_spec k1 k2 k3 k4 k5 k6 k7 k8 : M.rotate_first_half_x8 : 
   k = x8 k1 k2 k3 k4 k5 k6 k7 k8 ==>
   res.`1 = half_x8_ (sub8 0 k1) (sub8 0 k2) (sub8 0 k3) (sub8 0 k4) (sub8 0 k5) (sub8 0 k6) (sub8 0 k7) (sub8 0 k8) /\
   res.`2 = half_x8 (sub8 8 k1) (sub8 8 k2) (sub8 8 k3) (sub8 8 k4) (sub8 8 k5) (sub8 8 k6) (sub8 8 k7) (sub8 8 k8).
proof.
  proc.
  ecall (rotate_spec (sub8 0 k1) (sub8 0 k2) (sub8 0 k3) (sub8 0 k4) (sub8 0 k5) (sub8 0 k6) (sub8 0 k7) (sub8 0 k8)).
  while (0 <= i <= 8 /\ forall j, 0 <= j < i => k0_7.[j] = k.[j]).
  + by wp; skip; smt (Array8.get_setE).
  wp; while (0 <= i <= 8 /\ forall j, 0 <= j < i => s_k8_15.[j] = k.[8 + j]).
  + by wp; skip; smt (Array8.get_setE).
  wp; skip => />; split; 1:smt().
  move=> i0 s_k8_15 ??? h1; split; 1:smt().
  move=> i1 k0_7 ??? h2.
  have ->> : i0 = 8 by smt().
  have ->> : i1 = 8 by smt().
  split.
  + apply Array8.all_eq_eq; rewrite /Array8.all_eq /=. 
    rewrite !h2; cbv delta => //.
    by rewrite -iotaredE /=.
  + move => ?; apply Array8.all_eq_eq; rewrite /Array8.all_eq /=. 
    rewrite !h1; cbv delta => //.
    by rewrite -iotaredE /=.
qed.

phoare rotate_first_half_x8_pspec k1 k2 k3 k4 k5 k6 k7 k8 : 
  [M.rotate_first_half_x8 : 
   k = x8 k1 k2 k3 k4 k5 k6 k7 k8 ==>
   res.`1 = half_x8_ (sub8 0 k1) (sub8 0 k2) (sub8 0 k3) (sub8 0 k4) (sub8 0 k5) (sub8 0 k6) (sub8 0 k7) (sub8 0 k8) /\
   res.`2 = half_x8 (sub8 8 k1) (sub8 8 k2) (sub8 8 k3) (sub8 8 k4) (sub8 8 k5) (sub8 8 k6) (sub8 8 k7) (sub8 8 k8)] = 1%r.
proof.
  conseq (_:true ==> true) (rotate_first_half_x8_spec k1 k2 k3 k4 k5 k6 k7 k8).
  + done.
  proc; inline M.rotate; wp.
  call sub_rotate_ll.
  by do 3! unroll for ^while;auto.
qed.

lemma sub8_second_half k j: 
  32 <= j < 64 =>
  (WArray32.init32 ("_.[_]" (sub8 8 k))).[j - 32] = (WArray64.init32 ("_.[_]" k)).[j].
proof.
  move=> h;rewrite /WArray32.init32 /WArray64.init32 !initiE /= 1,2:/#.
  by rewrite /sub8 /= /Array16.sub /mkseq -iotaredE /=; smt (Array8.get_of_list).
qed.

lemma sub8_first_half k j: 
  0 <= j < 32 =>
  (WArray32.init32 ("_.[_]" (sub8 0 k))).[j] = (WArray64.init32 ("_.[_]" k)).[j].
proof.
  move=> h;rewrite /WArray32.init32 /WArray64.init32 !initiE /= 1,2:/#.
  by rewrite /sub8 /= /Array16.sub /mkseq -iotaredE  /=; smt (Array8.get_of_list).
qed.

lemma nth_mapi k (f: int -> 'a -> 'b) al dfl j : 
  nth dfl (mapi k f al) j = 
   if 0 <= j < size al then f (k+j) (nth witness al j) else dfl.
proof. elim: al k j => /= [ /# | a al hrec k j]; smt(size_ge0). qed.

lemma upd_mem_mapi_8 output (f : int -> W32.t Array8.t -> int -> W8.t) ks mem j: 
   upd_mem (mapi 0 f ks) mem output j = 
    if in_range output (64 * size ks) j then
      f ((j - output) %/64) (nth witness ks ((j - output) %/64)) ((j-output) %% 64)
    else mem.[j].
proof. 
  rewrite /upd_mem size_mapi; case: (in_range output (64 * size ks) j) => //= hin.
  rewrite nth_mapi ltz_divLR 1:// lez_divRL 1:// /= /#.
qed.

lemma upd_mem_mapi_16 output (f : int -> W32.t Array16.t -> int -> W8.t) ks mem j: 
   upd_mem (mapi 0 f ks) mem output j = 
    if in_range output (64 * size ks) j then
      f ((j - output) %/64) (nth witness ks ((j - output) %/64)) ((j-output) %% 64)
    else mem.[j].
proof. 
  rewrite /upd_mem size_mapi; case: (in_range output (64 * size ks) j) => //= hin.
  rewrite nth_mapi ltz_divLR 1:// lez_divRL 1:// /= /#.
qed.

lemma upd_mem_half_2 len (mem1 mem0 mem2:global_mem_t) output plain k1 k2 k3 k4 k5 k6 k7 k8:
  disj_or_eq output plain len =>  512 <= len => 
  (forall (j : address),
      mem1.[j] =
      upd_mem (mapi 0 (xor_mem_half 0 mem0 output plain)
                 [sub8 0 k1; sub8 0 k2; sub8 0 k3; sub8 0 k4; sub8 0 k5; sub8 0 k6; sub8 0 k7; sub8 0 k8]) mem0 output j) =>
  (forall (j : address),
      mem2.[j] =
      upd_mem (mapi 0 (xor_mem_half 32 mem1 output plain)
                 [sub8 8 k1; sub8 8 k2; sub8 8 k3; sub8 8 k4; sub8 8 k5; sub8 8 k6; sub8 8 k7; sub8 8 k8]) mem1 output j) =>
   (forall (j:address),
      mem2.[j] = 
         upd_mem (mapi 0 (xor_mem mem0 plain) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output j).
proof.
  move=> hd hlen hmem1 hmem2 j.
  rewrite upd_mem_mapi_16 hmem2 upd_mem_mapi_8.
  have -> : [sub8 8 k1; sub8 8 k2; sub8 8 k3; sub8 8 k4; sub8 8 k5; sub8 8 k6; sub8 8 k7; sub8 8 k8] = 
            map (sub8 8) [k1;k2;k3;k4;k5;k6;k7;k8] by done.
  have heq : [sub8 0 k1; sub8 0 k2; sub8 0 k3; sub8 0 k4; sub8 0 k5; sub8 0 k6; sub8 0 k7; sub8 0 k8] = 
            map (sub8 0) [k1;k2;k3;k4;k5;k6;k7;k8] by done.
  have hs : size [k1; k2; k3; k4; k5; k6; k7; k8] = 8 by done.
  rewrite size_map hs.
  pose k := nth witness [k1; k2; k3; k4; k5; k6; k7; k8] ((j - output) %/ 64).
  pose x := nth witness (map (sub8 8) [k1; k2; k3; k4; k5; k6; k7; k8]) ((j - output) %/ 64).
  case _ : (in_range output (64 * 8) j) => hj;last first.
  + by rewrite hmem1 /upd_mem size_mapi /= hj. 
  rewrite /x (nth_map witness witness (sub8 8) ((j - output) %/ 64) [k1;k2;k3;k4;k5;k6;k7;k8]).
  + by rewrite lez_divRL 1:// ltz_divLR //= /#.
  rewrite -/k /xor_mem_half /xor_mem.
  case: (32 <= (j -output) %% 64 < 32 + 32) => h. 
  + congr; 1: by apply sub8_second_half.
    rewrite hmem1 upd_mem_mapi_8 heq size_map hs.
    pose k' := (map (sub8 0) [k1; k2; k3; k4; k5; k6; k7; k8]).   
    case: (in_range output (64 * 8) (plain + 64 * ((j - output) %/ 64) + (j - output) %% 64)) => [h1 | //].
    have ->> : plain = output by smt(divz_eq).
    have -> : output + 64 * ((j - output) %/ 64) + (j - output) %% 64 - output = 
              (j - output) %% 64 + ((j - output) %/ 64) * 64 by ring.
    rewrite modzMDr divzMDr 1:// modz_mod (divz_small ((j - output) %% 64)); 1:smt(modz_cmp).
    rewrite /= /k' (nth_map witness witness (sub8 0)).
    + by rewrite lez_divRL 1:// ltz_divLR //= /#.
    rewrite -/k /xor_mem_half; smt(modz_cmp).
  rewrite hmem1 upd_mem_mapi_8 heq size_map hs.
  pose k' := (map (sub8 0) [k1; k2; k3; k4; k5; k6; k7; k8]). 
  have -> /= : output + 64 * ((j - output) %/ 64) + (j - output) %% 64 = j by smt(divz_eq).  
  rewrite hj /= /k' (nth_map witness witness (sub8 0)).
  + by rewrite lez_divRL 1:// ltz_divLR //= /#.
  rewrite -/k /xor_mem_half. 
  have h1 :  0 <= (j - output) %% 64 < 0 + 32 by smt(modz_cmp).
  by rewrite h1 /=; congr; rewrite sub8_first_half.
qed.

hoare savx2_store_x8_spec mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0:
  ChaCha20_savx2.M.store_x8 : 
    disj_or_eq output0 plain0 len0 /\ good_ptr output0 plain0 len0 /\
    k = x8 k1 k2 k3 k4 k5 k6 k7 k8 /\ 
    to_uint output = output0 /\ to_uint plain = plain0 /\ to_uint len = len0 /\ 512 <= len0 /\ Glob.mem = mem0 
    ==>
    to_uint res.`1 = output0 + 512 /\ to_uint res.`2 = plain0 + 512 /\ to_uint res.`3 = len0 - 512 /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j).
proof.
  proc.
  inline M.update_ptr;wp.
  ecall (savx2_half_store_x8_spec Glob.mem{hr} (sub8 8 k1) (sub8 8 k2) (sub8 8 k3) (sub8 8 k4) (sub8 8 k5) (sub8 8 k6) (sub8 8 k7) (sub8 8 k8)
            output0 plain0 len0 32).
  inline M.rotate_second_half_x8;wp.
  ecall (rotate_stack_spec (sub8 8 k1) (sub8 8 k2) (sub8 8 k3) (sub8 8 k4) (sub8 8 k5) (sub8 8 k6) (sub8 8 k7) (sub8 8 k8)).
  wp.
  ecall (savx2_half_store_x8_spec Glob.mem{hr} (sub8 0 k1) (sub8 0 k2) (sub8 0 k3) (sub8 0 k4) (sub8 0 k5) (sub8 0 k6) (sub8 0 k7) (sub8 0 k8)
            output0 plain0 len0 0).
  ecall (rotate_first_half_x8_spec k1 k2 k3 k4 k5 k6 k7 k8); wp; skip => /> &hr h1 h2 h3 h4 [r1 r2] /= ?? mem1 w1 mem2 w2.
  rewrite !W64.to_uintD_small /= 1..2:/#.
  rewrite W32.to_uintB 1:uleE 1:// /=.
  by apply (upd_mem_half_2 (to_uint len{hr}) mem1 mem0 mem2 (to_uint output{hr}) (to_uint plain{hr}) k1 k2 k3 k4 k5 k6 k7 k8).
qed.

phoare savx2_store_x8 mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0:
  [ChaCha20_savx2.M.store_x8 : 
    disj_or_eq output0 plain0 len0 /\ good_ptr output0 plain0 len0 /\
    k = x8 k1 k2 k3 k4 k5 k6 k7 k8 /\ 
    to_uint output = output0 /\ to_uint plain = plain0 /\ to_uint len = len0 /\ 512 <= len0 /\ Glob.mem = mem0 
    ==>
    to_uint res.`1 = output0 + 512 /\ to_uint res.`2 = plain0 + 512 /\ to_uint res.`3 = len0 - 512 /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j)] = 1%r.
proof.
  conseq (_: true ==> true) (savx2_store_x8_spec mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0);1:done.
  proc;  inline M.rotate_second_half_x8 M.rotate_first_half_x8 M.rotate M.rotate_stack.
  call (_: true); 1: by auto.
  call store_half_x8_ll; wp.
  call sub_rotate_ll; wp.
  while true (4 - i1); 1: by auto => /#.
  wp; while true (4 - i1); 1: by auto => /#.
  wp; call store_half_x8_ll; wp.
  call sub_rotate_ll; wp.
  wp; while true (4 - i0); 1: by auto => /#.
  wp; while true (8 - i); 1: by auto => /#.
  wp; while true (8 - i); auto => /#.
qed.

lemma upd_mem_comp (mem0 mem1 mem2:global_mem_t) output plain len ks (k:W32.t Array16.t) : 
   inv_ptr output plain len =>
   64 * size ks + 64 <= len =>
   let ofs = 64 * size ks in
   (forall j, mem1.[j] = upd_mem (mapi 0 (xor_mem mem0 plain) ks) mem0 output j) =>
   (forall j, mem2.[j] = 
         if in_range (output + ofs) 64 j then
            (WArray64.init32 (fun (i0 : int) => k.[i0])).[j - (output + ofs)] `^`
             mem1.[plain + ofs + (j - (output + ofs))]
         else mem1.[j]) =>
   forall j, mem2.[j] = upd_mem (mapi 0 (xor_mem mem0 plain) (rcons ks k)) mem0 output j.
proof.
  move=> /= hinv hlen hmem1 hupd j.
  rewrite mapi_rcons upd_mem_rcons hupd size_mapi !hmem1.
  case: (in_range (output + 64 * size ks) 64 j) => [hj | //].
  rewrite /upd_mem /= size_mapi /xor_mem.
  have -> /= : !in_range output (64 * size ks) (plain + 64 * size ks + (j - (output + 64 * size ks))) by smt (size_ge0).
  have -> // : j - (output + 64*size ks) = (j - output) %% 64.
  have -> : j - output = j - (output + 64*size ks) + size ks * 64 by ring.
  by rewrite modzMDr modz_small /#.  
qed.
  
phoare pref_store_ll : [ChaCha20_pref.M.store : true ==> true] = 1%r.
proof.
  proc;inline *;wp.
  while true (min 64 len -i).
  + by move=> z; wp; skip => /#.
  wp; while true (min 64 len -i).
  + by move=> z; wp; skip => /#.
  by wp; skip => /#.  
qed.

phoare pavx2_store_x8_spec mem0 k1 k2 k3 k4 k5 k6 k7 k8 output0 plain0 len0:
  [ ChaCha20_pavx2_cf.M.store_x8 : 
    inv_ptr output plain len /\
    k_1 = k1 /\ k_2 = k2 /\ k_3 = k3 /\ k_4 = k4 /\ k_5 = k5 /\ k_6 = k6 /\ k_7 = k7 /\ k_8 = k8 /\
    output = output0 /\ plain = plain0 /\ len = len0 /\ 512 <= len /\ Glob.mem = mem0 
    ==>
    res = (output0 + 512, plain0 + 512, len0 - 512) /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j)] = 1%r.
proof.
  conseq  (_: true ==> true) (_: 
    inv_ptr output plain len /\
    k_1 = k1 /\ k_2 = k2 /\ k_3 = k3 /\ k_4 = k4 /\ k_5 = k5 /\ k_6 = k6 /\ k_7 = k7 /\ k_8 = k8 /\
    output = output0 /\ plain = plain0 /\ len = len0 /\ 512 <= len /\ Glob.mem = mem0 
    ==>
    res = (output0 + 512, plain0 + 512, len0 - 512) /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4; k5; k6; k7; k8]) mem0 output0 j)); last first.
  + by proc; do 8!call pref_store_ll; skip.
  + by move=> />.
  proc => /=.
  ecall (store64_spec output{hr} plain{hr} len{hr} k8 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k7 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k6 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k5 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k4 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k3 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k2 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k1 Glob.mem{hr}).
  skip. move=> &hr [#] hinv 11!->> ? ->> /= />.
  split; [smt() | move=> h1 h2 {h1 h2} mem1 hinv1 hmem1].
  split; [smt() | move=> h {h} mem2 hinv2 hmem2].
  split; [smt() | move=> h {h} mem3 hinv3 hmem3].
  split; [smt() | move=> h {h} mem4 hinv4 hmem4].
  split; [smt() | move=> h {h} mem5 hinv5 hmem5].
  split; [smt() | move=> h {h} mem6 hinv6 hmem6].
  split; [smt() | move=> h {h} mem7 hinv7 hmem7].
  split; [smt() | move=> h {h} mem8 hinv8 hmem8].
  have hup1 := upd_mem_comp mem0 mem0 mem1 output0 plain0 len0 [] k1 hinv _ _ hmem1.
  + smt(). + by move=> j /=; rewrite /upd_mem /= (_:!in_range output0 0 j) 1:/#.
  have hup2 := upd_mem_comp mem0 mem1 mem2 output0 plain0 len0 [k1] k2 hinv _ hup1 hmem2; 1: by smt().
  have hup3 := upd_mem_comp mem0 mem2 mem3 output0 plain0 len0 [k1;k2] k3 hinv _ hup2 hmem3; 1: by smt().
  have hup4 := upd_mem_comp mem0 mem3 mem4 output0 plain0 len0 [k1;k2;k3] k4 hinv _ hup3 hmem4; 1: by smt().
  have hup5 := upd_mem_comp mem0 mem4 mem5 output0 plain0 len0 [k1;k2;k3;k4] k5 hinv _ hup4 hmem5; 1: by smt().
  have hup6 := upd_mem_comp mem0 mem5 mem6 output0 plain0 len0 [k1;k2;k3;k4;k5] k6 hinv _ hup5 hmem6; 1: by smt().
  have hup7 := upd_mem_comp mem0 mem6 mem7 output0 plain0 len0 [k1;k2;k3;k4;k5;k6] k7 hinv _ hup6 hmem7; 1: by smt().
  by apply (upd_mem_comp mem0 mem7 mem8 output0 plain0 len0 [k1;k2;k3;k4;k5;k6;k7] k8 hinv _ hup7 hmem8); smt().
qed.

equiv eq_store_x8 : ChaCha20_pavx2_cf.M.store_x8 ~  M.store_x8 :
  k{2} = (x8 k_1 k_2 k_3 k_4 k_5 k_6 k_7 k_8){1} /\ 
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
  (good_ptr output plain len){1} /\ disj_or_eq output{1} plain{1} len{1} /\ 512 <= len{1} /\
  ={Glob.mem} 
  ==>
  res{1}.`1 = to_uint res{2}.`1 /\ res{1}.`2 = to_uint res{2}.`2 /\ res{1}.`3 = to_uint res{2}.`3 /\ 
  (good_ptr res.`1 res.`2 res.`3){1} /\ (disj_or_eq res.`1 res.`2 res.`3){1} /\
  ={Glob.mem}.
proof.
  proc *.
  ecall{1} (pavx2_store_x8_spec Glob.mem{1} k_1{1} k_2{1} k_3{1} k_4{1} k_5{1} k_6{1} k_7{1} k_8{1} output{1} plain{1} len{1}).
  ecall{2} (savx2_store_x8 Glob.mem{1} k_1{1} k_2{1} k_3{1} k_4{1} k_5{1} k_6{1} k_7{1} k_8{1} output{1} plain{1} len{1}).
  skip => |> &1 &2hg hd hlen /= [r1 r2 r3] mem1 /= 3!-> hmem1; split; 1:smt().
  move=> _ mem2 hmem2 /=;split; [smt() | split;1:smt()].
  by apply JMemory.mem_eq_ext => j;rewrite hmem1 hmem2.
qed.

op x4_ (k1 k2 k3 k4:W32.t Array16.t) = 
  Array8.of_list witness [
    W8u32.pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]];
    W8u32.pack8 [k1.[8]; k1.[9]; k1.[10]; k1.[11]; k1.[12]; k1.[13]; k1.[14]; k1.[15]];
    W8u32.pack8 [k2.[0]; k2.[1]; k2.[2]; k2.[3]; k2.[4]; k2.[5]; k2.[6]; k2.[7]];
    W8u32.pack8 [k2.[8]; k2.[9]; k2.[10]; k2.[11]; k2.[12]; k2.[13]; k2.[14]; k2.[15]];
    W8u32.pack8 [k3.[0]; k3.[1]; k3.[2]; k3.[3]; k3.[4]; k3.[5]; k3.[6]; k3.[7]];
    W8u32.pack8 [k3.[8]; k3.[9]; k3.[10]; k3.[11]; k3.[12]; k3.[13]; k3.[14]; k3.[15]];
    W8u32.pack8 [k4.[0]; k4.[1]; k4.[2]; k4.[3]; k4.[4]; k4.[5]; k4.[6]; k4.[7]];
    W8u32.pack8 [k4.[8]; k4.[9]; k4.[10]; k4.[11]; k4.[12]; k4.[13]; k4.[14]; k4.[15]]
 ].

equiv eq_store_x4_last : ChaCha20_pavx2_cf.M.store_x4_last ~  M.store_x4_last :
  k{2} = (x4_ k_1 k_2 k_3 k_4){1} /\
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
  (good_ptr output plain len){1} /\ inv_ptr output{1} plain{1} len{1} /\ len{1} <= 256 /\
  ={Glob.mem} 
  ==>
  ={Glob.mem}.
proof.
  proc => /=.
  seq 0 3 : (#pre /\ (r.[0] = k.[0] /\ r.[1] = k.[1] /\ r.[2] = k.[2] /\ r.[3] = k.[3]){2}).
  + by unroll for{2} ^while;wp; skip => />.
  sp 2 0.
  if.
  + by move=> /> *; rewrite W32.uleE.
  + call eq_store_x2_last => /=.
    unroll for{2} ^while; wp.
    ecall (eq_store_x2 len{1});skip => /> &1 &2 h1 h2 h3 hlen1 e0 e1 e2 e3 hlen2.
    split. 
    + by apply Array4.all_eq_eq;rewrite /all_eq /= /x2_ e0 e1 e2 e3 /x4_.  
    move=> r1 r2 r3 /> re -> ?????;split; 1:smt().
    by apply Array4.all_eq_eq;rewrite /all_eq /= /x4_ /= /x2_ /=.
  call eq_store_x2_last; skip => /> &1 &2 h1 h2 h3 hlen1 e0 e1 e2 e3 hlen2.
  split; 1:smt(). 
  by apply Array4.all_eq_eq;rewrite /all_eq /= /x2_ e0 e1 e2 e3 /x4_.
qed.

phoare pavx2_store_x4_spec mem0 k1 k2 k3 k4 output0 plain0 len0:
  [ ChaCha20_pavx2_cf.M.store_x4 : 
    inv_ptr output plain len /\
    k_1 = k1 /\ k_2 = k2 /\ k_3 = k3 /\ k_4 = k4 /\
    output = output0 /\ plain = plain0 /\ len = len0 /\ 256 <= len /\ Glob.mem = mem0 
    ==>
    res = (output0 + 256, plain0 + 256, len0 - 256) /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4]) mem0 output0 j)] = 1%r.
proof.
  conseq  (_: true ==> true) (_: 
    inv_ptr output plain len /\
    k_1 = k1 /\ k_2 = k2 /\ k_3 = k3 /\ k_4 = k4 /\ 
    output = output0 /\ plain = plain0 /\ len = len0 /\ 256 <= len /\ Glob.mem = mem0 
    ==>
    res = (output0 + 256, plain0 + 256, len0 - 256) /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4]) mem0 output0 j)); last first.
  + by proc; do 4!call pref_store_ll; skip.
  + by move=> />.
  proc => /=.
  ecall (store64_spec output{hr} plain{hr} len{hr} k4 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k3 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k2 Glob.mem{hr}).
  ecall (store64_spec output{hr} plain{hr} len{hr} k1 Glob.mem{hr}).
  skip=> &hr [#] hinv 7!->> ? ->> /= />.
  split; [smt() | move=> h1 h2 {h1 h2} mem1 hinv1 hmem1].
  split; [smt() | move=> h {h} mem2 hinv2 hmem2].
  split; [smt() | move=> h {h} mem3 hinv3 hmem3].
  split; [smt() | move=> h {h} mem4 hinv4 hmem4].
  have hup1 := upd_mem_comp mem0 mem0 mem1 output0 plain0 len0 [] k1 hinv _ _ hmem1.
  + smt(). + by move=> j /=; rewrite /upd_mem /= (_:!in_range output0 0 j) 1:/#.
  have hup2 := upd_mem_comp mem0 mem1 mem2 output0 plain0 len0 [k1] k2 hinv _ hup1 hmem2; 1: by smt().
  have hup3 := upd_mem_comp mem0 mem2 mem3 output0 plain0 len0 [k1;k2] k3 hinv _ hup2 hmem3; 1: by smt().
  by apply (upd_mem_comp mem0 mem3 mem4 output0 plain0 len0 [k1;k2;k3] k4 hinv _ hup3 hmem4); smt().
qed.

module Store_x4 = {
  proc store_x4 (output:int, plain:int, len:int, k:W256.t Array8.t) : int * int * int = {
    var i:int;
    i <- 0;
    while (i < 8) {
      k.[i] <- k.[i] `^` loadW256 Glob.mem (plain + 32 * i);
      i <- i + 1;
    }
    i <- 0;
    while (i < 8) {
      Glob.mem <- storeW256 Glob.mem (output + (32 * i)) k.[i];
      i <- i + 1;
    }
    (output, plain, len) <@ ChaCha20_pref.M.update_ptr (output, plain, len, 256);
    return (output, plain, len);
  }
}.

lemma storeW256_upd_mem (mem0 mem1:global_mem_t) ks output plain (k1:W32.t Array16.t):
  (forall j, mem1.[j] = upd_mem ks mem0 output j) =>
  (forall j,
      (storeW256
         (storeW256 
            mem1 (output + 64 * size ks)
            (pack8 [k1.[0]; k1.[1]; k1.[2]; k1.[3]; k1.[4]; k1.[5]; k1.[6]; k1.[7]] `^`
                   loadW256 mem0 (plain + 64 * size ks)))
         (output + 64 * size ks + 32)
         (pack8 [k1.[8]; k1.[9]; k1.[10]; k1.[11]; k1.[12]; k1.[13]; k1.[14]; k1.[15]] `^`
                      loadW256 mem0 (plain + 64 * size ks + 32))).[j] = 
          upd_mem (rcons ks (xor_mem mem0 plain (size ks) k1)) mem0 output j).
proof.
  move=> hmem1 j.
  rewrite !get_storeW256E.
  have := store_256_xor_spec (output + 64 * size ks) k1 mem0 (plain + 64 * size ks) j.
  rewrite upd_mem_rcons.
  case: (in_range (output + 64 * size ks) 64 j) => hj; last by smt().
  rewrite /xor_mem.
  have -> /# : (j - output) %% 64 = j - (output + 64 * size ks).
  have -> : j - output = j - (output + 64 * size ks) + size ks * 64 by ring.
  by rewrite modzMDr modz_small /#.
qed.

phoare Store_x4_spec mem0 k1 k2 k3 k4 output0 plain0 len0:
  [Store_x4.store_x4 : 
    k = x4_ k1 k2 k3 k4 /\ 
    output = output0 /\ plain = plain0 /\ len = len0 /\ 256 <= len0 /\ Glob.mem = mem0 
    ==>
    res = (output0 + 256, plain0 + 256, len0 - 256) /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4]) mem0 output0 j)] = 1%r.
proof.
  conseq (_ : true ==> true)
    (_ : k = x4_ k1 k2 k3 k4 /\ 
    output = output0 /\ plain = plain0 /\ len = len0 /\ 256 <= len0 /\ Glob.mem = mem0 
    ==>
    res = (output0 + 256, plain0 + 256, len0 - 256) /\
    (forall j, 
       Glob.mem.[j] =
       upd_mem (mapi 0 (xor_mem mem0 plain0) [k1; k2; k3; k4]) mem0 output0 j)).
  + done. 
  + proc => /=.
    inline ChaCha20_pref.M.update_ptr;wp.
    do 2! unroll for ^while;wp;skip => /> (* hinv *) hlen j.
    rewrite /x4_ /=.
    have hmem1 := storeW256_upd_mem mem0 mem0 [] output0 plain0 k1 _; 1: by smt().
    have {hmem1} hmem2 := storeW256_upd_mem mem0 _ _ output0 plain0 k2 hmem1.
    have {hmem2} hmem3 := storeW256_upd_mem mem0 _ _ output0 plain0 k3 hmem2.
    by apply (storeW256_upd_mem mem0 _ _ output0 plain0 k4 hmem3).
  by proc; inline *; do 2!unroll for ^while;wp;skip.
qed.

equiv eq_store_x4 len0 : ChaCha20_pavx2_cf.M.store_x4 ~ M.store_x4 :
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ len{1} = len0 /\
  ={Glob.mem} /\
  (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ 256 <= len{1} /\
  k{2} = (x4_ k_1 k_2 k_3 k_4){1} 
  ==>
  res{1}.`1 = to_uint res{2}.`1 /\ res{1}.`2 = to_uint res{2}.`2 /\ res{1}.`3 = to_uint res{2}.`3 /\ 
  res{1}.`3 = len0 - 256 /\
  (good_ptr res.`1 res.`2 res.`3){1} /\ (inv_ptr res.`1 res.`2 res.`3){1} /\ ={Glob.mem}.
proof.
  exlim output{1}, plain{1} => output0 plain0.
  transitivity Store_x4.store_x4 
    (={Glob.mem, output, plain, len} /\ k{2} = (x4_ k_1 k_2 k_3 k_4){1} /\ 256 <= len{1} /\
      (output = output0 /\ plain = plain0 /\ len = len0){1} /\
      (good_ptr output plain len){1} /\ (inv_ptr output plain len){1}
     ==> 
       ={Glob.mem, res} /\ res{1} = (output0 + 256, plain0 + 256, len0 - 256) /\
      (good_ptr res.`1 res.`2 res.`3){1} /\ (inv_ptr res.`1 res.`2 res.`3){1})
    (={Glob.mem, k} /\ 
       output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\ 
       (good_ptr output plain len){1} /\ (inv_ptr output plain len){1} /\ 256 <= len{1} ==>
     res{1}.`1 = to_uint res{2}.`1 /\ res{1}.`2 = to_uint res{2}.`2 /\ res{1}.`3 = to_uint res{2}.`3 /\ 
     ={Glob.mem}).
  + move=> /> &1 &2 H H0 H1 H2 H3 H4 H5 H6; exists Glob.mem{2} (output, plain, len, x4_ k_1 k_2 k_3 k_4){1}; rewrite H6 => />.
  + done. 
  + proc *.
    ecall{1} (pavx2_store_x4_spec Glob.mem{1} k_1{1} k_2{1} k_3{1} k_4{1} output0 plain0 len0).
    ecall{2} (Store_x4_spec Glob.mem{1} k_1{1} k_2{1} k_3{1} k_4{1} output0 plain0 len0).
    skip => /> &1 &2 ????? mem1 hmem1 mem2 hmem2; split;2: smt().
    by apply JMemory.mem_eq_ext => j;rewrite hmem1 hmem2.
  proc => /=.
  inline ChaCha20_pref.M.update_ptr  M.update_ptr; wp.
  while (={i,Glob.mem, k} /\ output{1} = to_uint output{2} /\ (good_ptr output plain len){1} /\ 0 <= i{1} /\ 256 <= len{1}).
  + wp; skip => /> &1 &2 h1 h2 h3 h4 h5;split;2:smt(); congr.
    have heq : to_uint (W64.of_int (32 * i{2})) = 32 * i{2}.
    + by rewrite W64.to_uint_small /= /#.
    by rewrite to_uintD_small heq 2:// /#.
  wp; while (={i,Glob.mem, k} /\ plain{1} = to_uint plain{2} /\ (good_ptr output plain len){1} /\ 0 <= i{1} /\ 256 <= len{1}).
  + wp; skip => /> &1 &2 h1 h2 h3 h4 h5;split;2:smt(); congr.
    have heq : to_uint (W64.of_int (32 * i{2})) = 32 * i{2}.
    + by rewrite W64.to_uint_small /= /#.
    by rewrite to_uintD_small heq 2:// /#.
  wp; skip => /> *.
  rewrite to_uintB 1:uleE 1:// !to_uintD_small //= 1,2:/#.
qed.

phoare interleave_0_spec s0 k0 o0 : 
  [M.interleave_0 : s = s0 /\ k = k0 /\ o = o0 ==>
    res = Array8.of_list witness [s0.[o0 + 0];k0.[o0 + 0]; s0.[o0 + 1];k0.[o0 + 1]; s0.[o0 + 2];k0.[o0 + 2]; s0.[o0 + 3];k0.[o0 + 3]]] = 1%r.
proof.
  proc => /=.
  conseq (_: Array8.all_eq sk 
              (Array8.of_list witness [s0.[o0]; k0.[o0]; s0.[o0 + 1]; k0.[o0 + 1]; s0.[o0 + 2]; k0.[o0 + 2]; s0.[o0 + 3]; k0.[o0 + 3]])).
  + by move=> &hr ? sk;rewrite (Array8.ext_eq_all sk).
  by unroll for ^while;wp;skip.
qed.

equiv eq_store_x8_last : ChaCha20_pavx2_cf.M.store_x8_last ~  M.store_x8_last :
  k{2} = (x8 k_1 k_2 k_3 k_4 k_5 k_6 k_7 k_8){1} /\
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
  len{1} <= 512 /\
  (good_ptr output plain len){1} /\ disj_or_eq output{1} plain{1} len{1} /\ 
  ={Glob.mem} 
  ==>
  ={Glob.mem}.
proof.
  proc => /=.
  call eq_store_x4_last => /=.
  conseq |>.
  seq 4 9 : 
    ( s_k0_7{2} = (half_x8_ (sub8 0 k_1) (sub8 0 k_2) (sub8 0 k_3) (sub8 0 k_4) (sub8 0 k_5) (sub8 0 k_6) (sub8 0 k_7) (sub8 0 k_8)){1} /\
      k8_15{2} = (half_x8_ (sub8 8 k_1) (sub8 8 k_2) (sub8 8 k_3) (sub8 8 k_4) (sub8 8 k_5) (sub8 8 k_6) (sub8 8 k_7) (sub8 8 k_8)){1} /\
    i0_7{2} = x4_ r_1{1} r_2{1} r_3{1} r_4{1} /\
    output{1} = to_uint output{2} /\
    plain{1} = to_uint plain{2} /\
    len{1} = to_uint len{2} /\ len{1} <= 512 /\
    good_ptr output{1} plain{1} len{1} /\ inv_ptr output{1} plain{1} len{1} /\ len{1} <= 512 /\ ={Glob.mem}).
  + wp.
    ecall{2} (interleave_0_spec s_k0_7{2} k8_15{2} 0) => /=.
    inline M.rotate_second_half_x8;wp.
    ecall{2} (rotate_stack_pspec (sub8 8 k_1{1}) (sub8 8 k_2{1}) (sub8 8 k_3{1}) (sub8 8 k_4{1}) 
                                 (sub8 8 k_5{1}) (sub8 8 k_6{1}) (sub8 8 k_7{1}) (sub8 8 k_8{1}));wp.
    ecall{2} (rotate_first_half_x8_pspec k_1{1} k_2{1} k_3{1} k_4{1} k_5{1} k_6{1} k_7{1} k_8{1});wp;skip => />.
    move=> &1 &2 h1 h2 h3 h4 [s k] /= -> _;split;2:smt().
    by cbv delta; rewrite -iotaredE /=.
  if.
  + by move=> />;rewrite uleE /=.
  + wp; ecall{2} (interleave_0_spec s_k0_7{2} k8_15{2} 4) => /=.
    ecall (eq_store_x4 len{1}); skip => />.
    move=> &1 &2 h1 h2 h3 h4 h5 [output1 plain1 len1] [output2 plain2 len2] /> h6 h7 h8 h9;split;2:smt().
    by cbv delta; rewrite -iotaredE /=.
  skip => /> /#.
qed.

equiv eq_sum_states_x8 : ChaCha20_pavx2.M.sum_states_x8 ~ M.sum_states_x8 :
  k{2} = (x8 k1 k2 k3 k4 k5 k6 k7 k8){1} /\
  st{2} = (x8 st1 st2 st3 st4 st5 st6 st7 st8){1} 
  ==>
  res{2} = x8 res{1}.`1 res{1}.`2 res{1}.`3 res{1}.`4 res{1}.`5 res{1}.`6 res{1}.`7 res{1}.`8.
proof.
  proc => /=.
  inline *.
  transitivity*{1} { 
    i <- 0;
    while (i < 16) {
      k1.[i] <- k1.[i] + st1.[i];
      k2.[i] <- k2.[i] + st2.[i];
      k3.[i] <- k3.[i] + st3.[i];
      k4.[i] <- k4.[i] + st4.[i];
      k5.[i] <- k5.[i] + st5.[i];
      k6.[i] <- k6.[i] + st6.[i];
      k7.[i] <- k7.[i] + st7.[i];
      k8.[i] <- k8.[i] + st8.[i];
      i <- i + 1;
    }
  }. + smt(). + done.
  + by do 8! unroll for{1} ^while; unroll for{2} ^while; wp; skip => />.
  while (={i} /\ #pre /\ 0 <= i{1}); 2: by auto.
  wp; skip => /> &1 &2 ??; split; 2:smt().
  by rewrite !get_x8 1,2:// -set_x8 1:// /VPADD_8u32.
qed.

equiv eq_chacha20_more_than_256 : 
  ChaCha20_pavx2.M.chacha20_more_than_256 ~ ChaCha20_savx2.M.chacha20_more_than_256 : 
  output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
  key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
  (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
  (good_ptr output plain len){1} /\ (disj_or_eq output plain len){1} 
  ==>
  ={Glob.mem}.
proof.
  proc => /=.
  seq 1 4 : (s_r16{2} = g_r16 /\ s_r8{2} = g_r8 /\ st{2} = (x8 st1 st2 st3 st4 st5 st6 st7 st8){1} /\
            output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
            (good_ptr output plain len){1} /\ (disj_or_eq output plain len){1} /\ ={Glob.mem}).
  + call eq_init_x8; inline{2} M.load_shufb_cmd; wp; skip => />.
  seq 1 1 : (#pre /\ len{1} <= 512).
  + while (#pre). 
    + call eq_increment_counter_x8 => /=.
      call eq_store_x8 => /=.
      call eq_sum_states_x8 => /=.   
      call eq_rounds_x8 => /=. 
      by inline M.copy_state_x8; wp; skip => |> &1 &2 hg hd hl _ [r11 ri2 r13] [r21 r22 r23] /= 3!->> _ _;rewrite uleE.
    by skip => |> *; rewrite uleE /#.
  if; last by done.
  + by move=> /> *; rewrite ultE.
  call eq_store_x8_last.
  call eq_sum_states_x8 => /=.   
  call eq_rounds_x8 => /=. 
  by inline M.copy_state_x8; wp; skip => />.
qed.

equiv eq_chacha20_avx2 : 
   ChaCha20_pavx2.M.chacha20_avx2 ~ ChaCha20_savx2.M.chacha20_avx2 : 
     output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
     key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
     (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
     (good_ptr output plain len){1} /\ (disj_or_eq output plain len){1} 
   ==>
   ={Glob.mem}.
proof.
  proc => /=.
  if.
  + by move=> /> *;rewrite ultE.
  + by call eq_chacha20_less_than_257; skip => />; smt (W32.to_uint_cmp).
  by call eq_chacha20_more_than_256; skip.
qed.

equiv eq_pref_savx2_chacha20 : 
   ChaCha20_pref.M.chacha20_ref ~ ChaCha20_savx2.M.chacha20_avx2 : 
     output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
     key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
     (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
     (good_ptr output plain len){1} /\ (disj_or_eq output plain len){1} 
   ==>
   ={Glob.mem}.
proof.
  transitivity ChaCha20_pavx2.M.chacha20_avx2
    ( ={output, plain, len, key, nonce, counter, Glob.mem} /\ 0 <= len{1} ==> 
      ={Glob.mem})
    ( output{1} = to_uint output{2} /\ plain{1} = to_uint plain{2} /\ len{1} = to_uint len{2} /\
      key{1} = to_uint key{2} /\ nonce{1} = to_uint nonce{2} /\ ={counter,Glob.mem} /\
      (key + 32 < W64.modulus /\ nonce + 12 < W64.modulus){1} /\
      (good_ptr output plain len){1} /\ (disj_or_eq output plain len){1} 
      ==> ={Glob.mem}).
  + smt(W32.to_uint_cmp). + done.
  + by apply eq_pref_pavx2_chacha20.
  by apply eq_chacha20_avx2.
qed.

hoare chacha20_avx2_spec mem0 output0 plain0 key0 len0 nonce0 counter0 : ChaCha20_savx2.M.chacha20_avx2 :
  mem0 = Glob.mem /\ output0 = to_uint output /\ len0 = to_uint len /\
  plain0 = loads_8 Glob.mem (to_uint plain) (to_uint len) /\
  key0 = Array8.of_list W32.zero (loads_32 Glob.mem (to_uint key) 8) /\
  nonce0 = Array3.of_list W32.zero (loads_32 Glob.mem (to_uint nonce) 3) /\
  counter0 = counter /\
  disj_or_eq (to_uint output) (to_uint plain) (to_uint len) /\
  good_ptr (to_uint output) (to_uint plain) (to_uint len) /\
  to_uint key + 32 < W64.modulus /\ 
  to_uint nonce + 12 < W64.modulus 
  ==> 
  (chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = 
     loads_8 Glob.mem output0 len0 /\
  mem_eq_except (in_range output0 len0) Glob.mem mem0.
proof.
  bypr.
  move=> &m [#] h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11. 
  have <-: 
   Pr[ChaCha20_pref.M.chacha20_ref(output0, to_uint plain{m}, len0, to_uint key{m}, 
                                   to_uint nonce{m}, counter{m}) @ &m :
       !((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 =loads_8 Glob.mem output0 len0 /\
        mem_eq_on (predC (in_range output0 len0)) Glob.mem mem0)] =
   Pr[M.chacha20_avx2(output{m}, plain{m}, len{m}, key{m}, nonce{m}, counter{m}) @ &m :
    ! ((chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = loads_8 Glob.mem output0 len0 /\
       mem_eq_on (predC (in_range output0 len0)) Glob.mem mem0)].
  + by byequiv eq_pref_savx2_chacha20 => />;rewrite h2 h3;case: h9.
  pose plain1 := to_uint plain{m}; 
  pose key1 := to_uint key{m};
  pose nonce1 := to_uint nonce{m}.
   byphoare (_: mem0 = Glob.mem /\
   0 <= len /\
   output = output0 /\ plain = plain1 /\ len = len0 /\ key = key1 /\ nonce = nonce1 /\
   disj_or_eq output0 plain1 len0 /\
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
  conseq (chacha20_ref_spec mem0 output0 plain0 key0 nonce0 counter0) => //.
  + by move=> &hr /> /#.
  move: h1 h2 h3 h4 h5 h6 h7; rewrite /plain1 /key1 /nonce1 => /> &hr H1 H2 H3 H4 H5 H6 H7 H8 mem.
  by rewrite -H2 -H3 -H4 -H5 -H6 size_loads_8 /#.  
qed.
