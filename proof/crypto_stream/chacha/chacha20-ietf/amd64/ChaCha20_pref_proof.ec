require import AllCore List Int IntDiv.
import IterOp.
require import ChaCha20_Spec ChaCha20_pref.
require import Array3 Array8 Array16.
require import WArray64.

from Jasmin require import JModel.

op loads_8 (mem : global_mem_t) (from : address) (len: int) = 
  map (fun i => loadW8 mem (from + i)) (iota_ 0 len).

op loads_32 (mem: global_mem_t) (from : address) (len : int) = 
  map (fun i => loadW32 mem (from + 4 * i)) (iota_ 0 len).

lemma loads_8D m p (n1 n2:int) : 0 <= n1 => 0 <= n2 =>
  loads_8 m p (n1 + n2) = 
  loads_8 m p n1 ++ loads_8 m (p + n1) n2.
proof.
  move=> hn1 hn2; rewrite /loads_8 iota_add //.
  rewrite map_cat addzC iota_addl /= -map_comp.
  by do 2!congr; apply fun_ext => i; rewrite /(\o); rewrite addzA.
qed.

op mem_eq_on (P:int -> bool) (m1 m2: global_mem_t) =
   forall i, P i => loadW8 m1 i = loadW8 m2 i.

abbrev mem_eq_except P = mem_eq_on (predC P).

op in_range (p n i:int) = p <= i < p + n.

lemma loads_8_eq m1 m2 (p n:int): 
  mem_eq_on (in_range p n) m1 m2 =>
  loads_8 m1 p n = loads_8 m2 p n. 
proof.
  move=> hmem;apply eq_in_map => /= i /mema_iota hi.
  apply hmem => /#.
qed.

lemma mem_eq_except_storeW8 m1 m2 p len len1 k v:
  0 <= len => 0 <= k => len1 = max len (k+1) =>
  mem_eq_except (in_range p len) m1 m2 =>
  mem_eq_except (in_range p len1) (storeW8 m1 (p + k) v) m2.
proof.
  move=> hlen hk ->>; rewrite /mem_eq_on /predC /in_range => h i hni.
  rewrite /loadW8 storeW8E get_setE /#.
qed.

lemma size_loads_8 mem p s : size (loads_8 mem p s) = max 0 s.
proof. by rewrite /loads_8 size_map size_iota. qed.

lemma take_loads_8 mem p (n1 n2:int) : n1 <= n2 =>
  take n1 (loads_8 mem p n2) = loads_8 mem p n1.
proof. by move=> hn;rewrite /loads_8 -map_take take_iota /#. qed.

lemma size_bytes_of_block st : size (bytes_of_block st) = 64.
proof. by rewrite /bytes_of_block WArray64.size_to_list. qed.

(* -------------------------------------------------------------------------------- *)
op inv_ptr (output plain: address) (len:int) = 
  !(plain < output /\ output < plain + len).

(* -------------------------------------------------------------------------------- *)

lemma line_diff a b d s st i:
  i <> a => i <> d => (line a b d s st).[i] = st.[i].
proof.
  by move=> ha hd; rewrite /line /= !Array16.get_set_if ha hd /=.
qed.

lemma line_morph a b d s (st1 st2: state) i:
  i = a || i = d => 
  st1.[a] = st2.[a] => st1.[b] = st2.[b] => st1.[d] = st2.[d] =>
  (line a b d s st1).[i] = (line a b d s st2).[i].
proof.
  by rewrite /line => hi ha hb hd /=; rewrite !Array16.get_set_if /#.
qed.

lemma quarter_round_diff st a b c d i:
   i <> a => i <> b => i <> c => i <> d => 
   (quarter_round a b c d st).[i] = st.[i].
proof.
  by move=> ha hb hc hd; rewrite /quarter_round /(\oo) !line_diff.
qed.

lemma quarter_round_morph a b c d (st1 st2:state) i:
  i = a || i = b || i = c || i = d => 
  a <> b => a <> c => a <> d =>
  b <> c => b <> d => c <> d =>
  st1.[a] = st2.[a] => st1.[b] = st2.[b] => st1.[c] = st2.[c] => st1.[d] = st2.[d] =>
  (quarter_round a b c d st1).[i] = (quarter_round a b c d st2).[i].
proof.
  move=> hor ha hb hc hd hab hac had hbc hbd hcd; rewrite /quarter_round /(\oo).
  smt (line_morph line_diff).
qed.

op column_round'  : state -> state  =
  quarter_round 0 4 8 12 \oo quarter_round 2 6 10 14 \oo 
  quarter_round 1 5 9 13 \oo  quarter_round 3 7 11 15.

lemma column_round'_spec st: column_round st = column_round' st.
proof.
  delta column_round' column_round (\oo) => /=.
  congr; move: (quarter_round 0 4 8 12 st) => {st} st.
  apply Array16.ext_eq => i hi_bound; smt (quarter_round_morph quarter_round_diff). 
qed.

op diagonal_round' : state -> state =
  quarter_round 1 6 11 12 \oo quarter_round 0 5 10 15 \oo quarter_round 2 7 8 13 \oo quarter_round 3 4 9 14.

lemma diagonal_round'_spec st: diagonal_round st = diagonal_round' st.
proof.
  delta diagonal_round' diagonal_round (\oo) => /=.
  do 2! congr.
  apply Array16.ext_eq => i hi_bound; smt (quarter_round_morph quarter_round_diff). 
qed.

hoare line_spec (st0:state) a0 b0 c0 r0 : M.line : 
  k = st0 /\ (a,b,c,r) = (a0,b0,c0,r0) /\ 
  0 <= a0 < 16 /\ 0 <= b0 < 16 /\ 0 <= c0 < 16 /\ 
  a0 <> c0 
  ==>
  res = line a0 b0 c0 r0 st0.
proof.
  proc;auto => /> h0a ha h0b hb h0c hc;rewrite eq_sym => hac (* h0r hr *). 
  apply Array16.ext_eq => i hi.
  rewrite /line /= !Array16.get_set_if /= /#.
qed.

hoare quarter_round_spec (st0:state) a0 b0 c0 d0 : M.quarter_round : 
  k = st0 /\ (a,b,c,d) = (a0,b0,c0,d0) /\ 
  a0 <> d0 /\ c0 <> b0 /\ 
  0 <= a0 < 16 /\ 0 <= b0 < 16 /\ 0 <= c0 < 16 /\ 0 <= d0 < 16
  ==>
  res = quarter_round a0 b0 c0 d0 st0.
proof.
  proc => /=.
  ecall (line_spec (line a0 b0 d0 8 (line c0 d0 b0 12 (line a0 b0 d0 16 st0))) c0 d0 b0 7).
  ecall (line_spec (line c0 d0 b0 12 (line a0 b0 d0 16 st0)) a0 b0 d0 8).
  ecall (line_spec (line a0 b0 d0 16 st0) c0 d0 b0 12).
  ecall (line_spec st0 a0 b0 d0 16); auto.
qed.

hoare column_round_spec (st0:state) : M.column_round : 
  k = st0 ==> res = column_round st0.
proof.
  conseq (_: res = column_round' st0).
  + by move=> &m _ r ->; rewrite column_round'_spec.
  proc; delta column_round' (\oo) => /=.
  ecall (quarter_round_spec (quarter_round 1 5 9 13 
             (quarter_round 2 6 10 14 (quarter_round 0 4 8 12 st0))) 3 7 11 15).
  ecall (quarter_round_spec (quarter_round 2 6 10 14 (quarter_round 0 4 8 12 st0)) 1 5 9 13).
  ecall (quarter_round_spec (quarter_round 0 4 8 12 st0) 2 6 10 14).  
  ecall (quarter_round_spec st0 0 4 8 12);auto.
qed.

hoare diagonal_round_spec (st0:state) : M.diagonal_round : 
  k = st0 ==> res = diagonal_round st0.
proof.
  conseq (_: res = diagonal_round' st0).
  + by move=> &m _ r ->; rewrite diagonal_round'_spec.
  proc; delta diagonal_round' (\oo) => /=.
  ecall (quarter_round_spec (quarter_round 2 7 8 13 (quarter_round 0 5 10 15 
                            (quarter_round 1 6 11 12 st0))) 3 4 9 14).
  ecall (quarter_round_spec (quarter_round 0 5 10 15 (quarter_round 1 6 11 12 st0)) 2 7 8 13).
  ecall (quarter_round_spec (quarter_round 1 6 11 12 st0) 0 5 10 15).
  ecall (quarter_round_spec st0 1 6 11 12);auto.
qed.

hoare round_spec (st0:state) : M.round : 
  k = st0 ==> res = double_round st0.
proof.
  proc.
  ecall (diagonal_round_spec (column_round st0)).
  by ecall (column_round_spec st0);skip;delta double_round (\oo).
qed.

hoare rounds_spec (st0:state) : M.rounds :
  k = st0 ==> res = rounds st0.
proof.
  proc.
  while (0 <= c <= 10 /\ k = iter c double_round st0).
  + wp; ecall (round_spec (iter c double_round st0)); skip => />.
    move=> &m hc _ hc10; rewrite iterS //= /#.
  wp;skip => /= &m;rewrite iter0 1:// /rounds=> /> /#.
qed.

(* FIXME: move this *)
lemma size_map2 (f:'a -> 'b -> 'c) (l1:'a list) l2 : size (map2 f l1 l2) = min (size l1) (size l2).
proof.
  elim: l1 l2 => [ | a l1 hrec] [| b l2] //=; smt (size_ge0).
qed.

lemma nth_map2 dfla dflb dflc (f:'a -> 'b -> 'c) (l1:'a list) l2 i: 
  0 <= i < min (size l1) (size l2) => 
  nth dflc (map2 f l1 l2) i = f (nth dfla l1 i) (nth dflb l2 i).
proof.
  elim: l1 l2 i => [ | a l1 hrec] [ | b l2] i /=; 1..3:smt(size_ge0).
  case: (i=0) => [->> // | hi ?].
  apply hrec;smt().
qed.

lemma nth_loads_8 len mem p j : 0 <= j < len =>
   loadW8 mem (p + j) = (loads_8 mem p len).[j].
proof.
  move=> hj; rewrite /loads_8. 
  by rewrite (nth_map 0 W8.zero) 1:size_iota 1:/# /= nth_iota. 
qed.

hoare store_spec output0 plain0 len0 k0 mem0 : M.store :
  output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 0 <= len0 /\
  inv_ptr output0 plain0 (min 64 len0)
  ==>
  loads_8 Glob.mem output0 (min 64 len0) = map2 W8.(+^) (bytes_of_block k0) (loads_8 mem0 plain0 (min 64 len0)) /\
  mem_eq_except (in_range output0 (min 64 len0)) Glob.mem mem0 /\
  res.`1 = output0 + min 64 len0 /\
  res.`2 = plain0  + min 64 len0 /\
  res.`3 = len0    - min 64 len0.
proof.
  proc; inline *; wp => /=.
  pose len1 := min 64 len0.
  sp 2.
  seq 2 : (#{/~k8}pre /\ 
           forall j, 0 <= j < len1 => k8.[j] = k8_0.[j] `^` loadW8 mem0 (plain0 + j)).
  + while (#{/~k8}pre /\ 0 <= i <= len1 /\ 
            forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` loadW8 mem0 (plain0 + j)).  
    + wp; skip; smt (WArray64.get_setE).
    by wp; skip => /#.
  while (0 <= i <= len1 /\ output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ 0 <= len0 /\
         loads_8 Glob.mem output0 i = take i (to_list k8) /\ mem_eq_except (in_range output0 i) Glob.mem mem0).
  + wp;skip => &hr [#] h0i hilen1 4!->> h0len0 hload heqexc hi.
    pose l8 := to_list k8{hr}; move=> /=.
    rewrite (take_nth W8.zero); 1: rewrite /l8 /= /#.
    split; 1:smt().
    split => //.
    split. 
    + rewrite loads_8D 1,2:// -cats1; congr.
      + by rewrite -hload;apply loads_8_eq => j hj; rewrite storeW8E /loadW8 get_set_neqE_s 1:/#.
      by rewrite /loads_8 /= /loadW8 storeW8E -iotaredE /= /l8 WArray64.get_to_list.
    apply: mem_eq_except_storeW8 heqexc => // /#.
  wp; skip => &hr [#] 6!->> h0len0 hinv hj; do split; 1,2: by smt(). 
  by rewrite take0 /= /loads_8 -iotaredE /=.
  (pose l8 := to_list k8{hr}) => mem1 i hi /> ??? hl heq.
  have ->> : i = min 64 len0 by smt().
  rewrite heq hl /=.
  have ? : 0 <= min 64 len0 by smt().
  apply (eq_from_nth W8.zero).
  + rewrite size_take 1:// size_map2 size_bytes_of_block size_loads_8 /l8 /= /#.
  have -> : size (take (min 64 len0) l8) = min 64 len0.
  + by rewrite size_take 1:// /l8 /= /#.
  move=> j h_j.
  rewrite nth_take 1:// 1:/# (nth_map2 W8.zero W8.zero W8.zero).
  + by rewrite size_loads_8 size_bytes_of_block /#.
  rewrite /l8  WArray64.get_to_list hj 1://.
  rewrite /bytes_of_block WArray64.get_to_list.
  by rewrite (nth_loads_8 (min 64 len0)).
qed.
  
hoare sum_states_spec k0 st0 : M.sum_states : 
  k = k0 /\ st = st0
  ==>
  res = Array16.map2 (fun (x y: W32.t) => x + y) k0 st0.
proof.
  proc.
  rewrite /is_state. 
  unroll for ^while;wp;skip => />.
  by apply Array16.all_eq_eq;rewrite /all_eq.
qed.

hoare chacha20_ref_spec mem0 output0 plain0 key0 nonce0 counter0 : M.chacha20_ref :
  mem0 = Glob.mem /\
  0 <= len /\
  output = output0 /\ 
  inv_ptr output plain len /\
  plain0 = loads_8 Glob.mem plain len /\
  key0 = Array8.of_list W32.zero (loads_32 Glob.mem key 8) /\
  nonce0 = Array3.of_list W32.zero (loads_32 Glob.mem nonce 3) /\
  counter0 = counter 
  ==> 
  (chacha20_CTR_encrypt_bytes key0 nonce0 counter0 plain0).`1 = 
     loads_8 Glob.mem output0 (size plain0) /\
  mem_eq_except (in_range output0 (size plain0)) Glob.mem mem0.
proof.
  proc; rewrite /chacha20_CTR_encrypt_bytes /=.
  while 
    (inv_ptr output plain len /\ 0 <= len /\
     exists plain1 c, 
      let splain1 = size plain1 in
      output0 = output{hr} - splain1 /\
      plain0 = plain1 ++ loads_8 Glob.mem plain len /\
      st = setup key0 nonce0 c /\
      (0 < len => splain1 %% 64 = 0) /\
      iter (splain1 %/ 64 + b2i (splain1 %% 64 <> 0) ) (ctr_round key0 nonce0) ([], plain0, counter0) = 
         (loads_8 Glob.mem output0 splain1, loads_8 Glob.mem plain len, c) /\
      mem_eq_except (in_range output0 (size plain1)) Glob.mem mem0).
  + inline M.increment_counter; wp.
    ecall (store_spec output plain len k Glob.mem).
    ecall (sum_states_spec k st).
    ecall (rounds_spec st); skip => /> &hr hinv h0len0 plain1 c1 hmod hiter heq_on hlen.
    split; 1: smt().
    move=> hinvmin [output' plain' len'] mem' hloads heq_on' /= 3!->>. 
    split; [smt() | split; 1:smt()].
    exists (plain1 ++ loads_8 Glob.mem{hr} plain{hr} (min 64 len{hr})) (c1 + W32.of_int 1).
    split.
    + by rewrite size_cat size_loads_8 /#.
    split.
    + have {1}-> : len{hr} = min 64 len{hr} + (len{hr} - min 64 len{hr})  by ring.
      rewrite loads_8D 1,2:/# catA; congr.
      by apply loads_8_eq => /#.
    split.
    + rewrite /setup /=; apply Array16.all_eq_eq. 
      rewrite -!catA /Array16.all_eq /=.
      by rewrite !nth_cat; rewrite Array8.size_to_list /=.
    split.
    + move=> hlen1; have -> : min 64 len{hr} = 64 by smt().
      by rewrite size_cat size_loads_8 /max /= modzDr hmod.
    split; 2: by rewrite size_cat size_loads_8;smt (size_ge0).
    pose len1 := min 64 len{hr}.
    pose plain2 := plain1 ++ loads_8 Glob.mem{hr} plain{hr} len1.
    have -> : size plain2 %/ 64 + b2i (size plain2 %% 64 <> 0) = 
              ((size plain1 %/ 64 + b2i (size plain1 %% 64 <> 0))) + 1.
    + rewrite /plain2 size_cat size_loads_8 (_ : max 0 len1 = len1) 1:/# hmod 1:// /b2i /=.
      have ?: 64 %| size plain1 by rewrite /(%|) hmod. 
      rewrite dvdz_modzDl 1:// divzDl 1://.
      case: (64 <= len{hr}) => hlt.
      + smt (modzz divzz).
      smt (divz_small modz_small). 
    rewrite iterS. 
    + smt (modz_ge0 divz_ge0 size_ge0).
    rewrite hiter /ctr_round /=;split.
    + rewrite /plain2 size_cat size_loads_8 /max (_: 0 < len1) 1:/# /=.
      rewrite loads_8D 1:size_ge0 1:/#;congr.
      + by apply loads_8_eq => /#.
      have -> : output{hr} - size plain1 + size plain1 = output{hr} by ring.
      rewrite hloads /chacha20_block /chacha20_core /=.
      rewrite map2C; 1:by apply W8.xorwC.
      case : (len{hr} < 64) => hlt; 1:smt().
      have -> : min 64 len{hr} = 64 by smt().
      by rewrite map2_take2 size_bytes_of_block take_loads_8 1:/#.
    case : (64 < len{hr}) => hlt;last first.
    + by rewrite drop_oversize 1:size_loads_8 1:/# /len1 /min hlt /= /loads_8 -iotaredE/=.
    have {1} -> : len{hr} = len1 + (len{hr} - len1) by ring.
    rewrite loads_8D 1,2:/#.
    have -> : len1 = 64 by rewrite /len1 /min hlt.
    rewrite drop_size_cat 1:size_loads_8 1:// /=.
    by apply loads_8_eq => /#.
  inline M.init.
  do 2! unroll for ^while; wp; skip => &m /> ??;split.
  + exists [] counter{m}.
    rewrite /(%/) /(%%) /b2i /= iter0 // /loads_8 /=.
    rewrite /setup /loads_32 /= -iotaredE /=;split;2:smt().
    rewrite Array8.of_listK 1:// Array3.of_listK 1:// /=.
    by apply Array16.all_eq_eq; rewrite /Array16.all_eq.
  move=> mem len0 output1 plain1 ? hinv ? plain2 c.
  have ->> : len0 = 0 by smt().
  rewrite {2}/loads_8 /= -!iotaredE /= cats0 => />. search max (<=).
  by rewrite size_loads_8 (StdOrder.IntOrder.ler_maxr _ _) => // => ->. 
qed.

(* ----------------------------------------------------------------------------------------- *)
(* Extra spec usefull for other part of the proof                                            *)

phoare store_pref_spec output0 plain0 len0 k0 mem0 : [ChaCha20_pref.M.store : 
  output = output0 /\ plain = plain0 /\ len = len0 /\ k = k0 /\ Glob.mem = mem0 /\ 
  0 <= len /\ inv_ptr output plain len 
  ==>
  inv_ptr res.`1 res.`2 res.`3 /\ res = (output0 + min 64 len0, plain0 + min 64 len0, len0 - min 64 len0) /\
  forall j, 
    Glob.mem.[j] =
      if in_range output0 (min 64 len0) j then
        let j = j - output0 in
        (init32 (fun (i0 : int) => k0.[i0])).[j] `^` mem0.[plain0 + j]
      else mem0.[j]]= 1%r.
proof.
  proc; inline *; wp.
  while (0 <= i <= min 64 len /\ 
    forall j, Glob.mem.[j] = if in_range output i j then k8.[j - output] else mem0.[j]) (min 64 len - i).
  + move=> z;wp; skip => /> &hr h0i _ hj hi; split; 2: smt().
    split; 1: smt().
    by move=> j; rewrite storeW8E get_setE hj; smt().
  wp; while(0 <= i <= min 64 len /\
    forall j, 0 <= j < i => k8.[j] = k8_0.[j] `^` loadW8 Glob.mem (plain + j)) (min 64 len - i).
  + move=> z;wp; skip => />; smt (WArray64.get_setE).
  by wp; skip => /> /#.
qed.

