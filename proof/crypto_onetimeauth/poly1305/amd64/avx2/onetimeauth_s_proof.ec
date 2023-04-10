require import AllCore IntDiv CoreMap List Distr StdOrder Ring EClib Array2.
from Jasmin require import JModel.

require import Poly1305_spec.
require import Poly1305_savx2_vec.
require import Onetimeauth_s_equiv.
require import Onetimeauth_s.
require import Poly1305_savx2.

(* ****************************************************)
(* Getting Hoare and LL for previou simplementation   *)
(* ****************************************************)

lemma avx2_ll  mem rr ss mm inn inl kk :
  phoare [ M.poly1305_avx2 : 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> true] = 1%r.
proof.
bypr => // &m *.
have : Pr[M.poly1305_avx2(inn,inl,kk) @ &m : true] >= 1%r; last by smt(mu_bounded).
+ byphoare (_:  Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> true); last 2 by smt().
  conseq (_: Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem).
  bypr => &mm *. 
  have -> : Pr[M.poly1305_avx2(in_0{mm}, inlen{mm}, k{mm}) @ &mm : 
                   poly1305_post rr ss mm res mem Glob.mem ]= 1%r; 2: by smt().
  by byphoare (_: 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem ) => //=; apply avx2_corr.
qed.

lemma avx2_corr_h mem rr ss mm inn inl kk :
  hoare [ M.poly1305_avx2 : 
           Glob.mem = mem /\
            in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem ].
bypr => /= &1 [#] ??????.
rewrite Pr[mu_not].
have -> : Pr[M.poly1305_avx2(in_0{1}, inlen{1}, k{1}) @ &1 : true] = 1%r by
 byphoare (_:  Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> true);[ apply avx2_ll | smt() | smt()].
 have -> : Pr[M.poly1305_avx2(in_0{1}, inlen{1}, k{1}) @ &1 : poly1305_post rr ss mm res mem Glob.mem ] = 1%r.
 by byphoare (_: 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem) => //=; apply avx2_corr.
by ring.
qed.

(* ****************************************************)
(* Getting Hoare and LL for reg based simplementation *)
(* ****************************************************)
print onetimeauth_s_r_equiv.

lemma Onetimeauth_s__poly1305_r_avx2_corr_h mem rr ss mm inn inl kk :
  hoare [ Onetimeauth_s.M.__poly1305_r_avx2 : 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
            poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem ].
conseq (onetimeauth_s_r_equiv (to_uint inn) (to_uint inl)) (avx2_corr_h mem rr ss mm inn inl kk).
move => &1 [#] /= ????; rewrite /poly1305_pre /inv_ptr /= => [#] *.
exists mem (in_0{1},inlen{1},k{1}) => /=.
split; last first; do split; smt(W64.to_uint_cmp). 
by smt().
qed.

lemma Onetimeauth_s__poly1305_r_avx2_ll mem rr ss mm inn inl kk :
  phoare [ Onetimeauth_s.M.__poly1305_r_avx2 : 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==>  
           true] = 1%r.
conseq (onetimeauth_s_r_equiv (to_uint inn) (to_uint inl)) (avx2_ll mem rr ss mm inn inl kk).
move => &1 [#] /= ????; rewrite /poly1305_pre /inv_ptr /= => [#] *.
exists mem (in_0{1},inlen{1},k{1}) => /=.
split; last first; do split; smt(W64.to_uint_cmp).
by smt().
qed.

lemma Onetimeauth_s__poly1305_avx2__r_corr mem rr ss mm inn inl kk :
  phoare [ Onetimeauth_s.M.__poly1305_r_avx2 : 
           Glob.mem = mem /\
           in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr (to_uint kk) (to_uint inn) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post rr ss mm res mem Glob.mem ] = 1%r
 by conseq (Onetimeauth_s__poly1305_r_avx2_ll mem rr ss mm inn inl kk) 
      (Onetimeauth_s__poly1305_r_avx2_corr_h mem rr ss mm inn inl kk); smt().

(* ****************************************************)
(* Proving entry point for MAC computation is correct *)
(* ****************************************************)

op inv_ptr_mem (k in_0 out len : int) : bool = good_ptr k 32 /\ 
                                                     good_ptr in_0 len /\ 
                                                     good_ptr out 16.

op poly1305_post_mem (r : Zp.Zp.zp) (s : int) (m : Zp_msg) (outt : int) (memO memN : global_mem_t) :
  bool = memN = storeW128 memO outt (W128.of_int (poly1305_ref r s m)).

lemma Onetimeauth_s__poly1305_avx2_corr_h mem rr ss mm outt inn inl kk :
  hoare [ Onetimeauth_s.M.__poly1305_avx2 : 
           Glob.mem = mem /\
           out = outt /\ in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint outt) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post_mem rr ss mm (to_uint outt) mem Glob.mem ].
proof. 
proc => /=.
seq 2 : (poly1305_post rr ss mm h2 mem Glob.mem /\ good_ptr (to_uint out) 16 /\ out = outt).
call(Onetimeauth_s__poly1305_r_avx2_corr_h mem rr ss mm inn inl kk); 1: by auto => />.
inline *; auto => /> &hr; rewrite /poly1305_post /poly1305_post_mem /= => *.
rewrite to_uintD_small /=; 1: by smt(W64.to_uint_cmp).
by rewrite -store2u64 of_int2u64 /= /#.
qed.

lemma Onetimeauth_s__poly1305_avx2_ll mem rr ss mm outt inn inl kk :
  phoare [ Onetimeauth_s.M.__poly1305_avx2 : 
           Glob.mem = mem /\
           out = outt /\ in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint outt) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           true ] = 1%r.
proof. 
proc => /=. 
call(_: true); 1: by islossless.
by call(Onetimeauth_s__poly1305_r_avx2_ll mem rr ss mm inn inl kk); 1: by auto => />.
qed.

lemma Onetimeauth_s__poly1305_avx2_corr mem rr ss mm outt inn inl kk :
  phoare [ Onetimeauth_s.M.__poly1305_avx2 : 
           Glob.mem = mem /\
           out = outt /\ in_0 = inn /\ inlen = inl /\ k = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint outt) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post_mem rr ss mm (to_uint outt) mem Glob.mem ] = 1%r by
 conseq (Onetimeauth_s__poly1305_avx2_ll mem rr ss mm outt inn inl kk) 
      (Onetimeauth_s__poly1305_avx2_corr_h mem rr ss mm outt inn inl kk); smt().


(* MAIN THEOREM *)

(*
abbrev good_ptr (ptr: int) len = ptr  <= ptr + len < W64.modulus.

op inv_ptr (k in_0 len: int) = good_ptr k 32 /\ good_ptr in_0 len.

op poly1305_pre (r : zp) (s : int) (m : Zp_msg)
                (mem : global_mem_t) (inn, inl, kk : W64.t)  = 
      (size m = if  W64.to_uint inl %% 16 = 0 
           then to_uint inl %/ 16
           else to_uint inl %/ 16 + 1) /\
       m = mkseq (fun i => 
            let offset = W64.of_int (i * 16) in
               if i < size m - 1
               then load_block mem (inn + offset)
               else load_lblock mem (inl - offset) (inn + offset))
                     (size m) /\
        r = load_clamp mem kk /\
        s = to_uint (loadW128 mem (to_uint (kk + W64.of_int 16))).

op poly1305_post (r : zp) (s : int) (m : Zp_msg) (ors : W64.t Array2.t) 
     (memO memN : global_mem_t) = 
  ors = Array2.init 
     (fun i =>  W64.of_int (poly1305_ref r s m %/ (if i = 0 then 1 else W64.modulus))) /\
     memO = memN.

*)

lemma jade_onetimeauth_poly1305_amd64_avx2 mem rr ss mm outt inn inl kk :
  phoare [ Onetimeauth_s.M.jade_onetimeauth_poly1305_amd64_avx2 : 
           Glob.mem = mem /\
           mac = outt /\ input = inn /\ input_length = inl /\ key = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint outt) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post_mem rr ss mm (to_uint outt) mem Glob.mem /\ res = W64.zero] = 1%r by
 proc => //; wp;sp => /=;
   call (Onetimeauth_s__poly1305_avx2_corr mem rr ss mm outt inn inl kk); auto => />.

(* ****************************************************)
(* Proving entry point for MAC verification is correct *)
(* ****************************************************)

require import Crypto_verify_16_s. 
require import Crypto_verify_16_s_proof. 

equiv verify_eq : Onetimeauth_s.M.__crypto_verify_p_u8x16_r_u64x2 ~
                  Crypto_verify_16_s.M.__crypto_verify_p_u8x16_r_u64x2  : ={Glob.mem,arg} ==> ={Glob.mem,res}  by sim.

lemma verify_h (hold : int) (hnew : W64.t Array2.t) (hhp : W64.t) (mem : global_mem_t):
      hoare[ Onetimeauth_s.M.__crypto_verify_p_u8x16_r_u64x2 :
              (good_ptr (to_uint hhp) 16)%Crypto_verify_16_s_proof /\
              _h = hhp /\ hold = to_uint (loadW128 mem (to_uint hhp)) /\ h = hnew /\ Glob.mem = mem ==>
              Glob.mem = mem /\
              (res = Crypto_verify_16_s_proof.zero_u64) =
              (hnew = (init (fun (i : int) => (of_int (hold %/ if i = 0 then 1 else 18446744073709551616))%W64))%Array2)].
conseq verify_eq (Crypto_verify_16_s_proof.verify_h hold hnew hhp mem).
move => &1 [#] /> ??; exists Glob.mem{1} arg{1} => //=.
smt().
qed.

lemma jade_onetimeauth_poly1305_amd64_avx2_verify_h mem hh rr ss mm hhp inn inl kk :
  hoare [ Onetimeauth_s.M.jade_onetimeauth_poly1305_amd64_avx2_verify : 
           Glob.mem = mem /\
           mac = hhp /\ input = inn /\ input_length = inl /\ key = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint hhp) (to_uint inl) /\
           poly1305_pre_verif rr hh ss mm mem hhp inn inl kk ==> 
           poly1305_post_verif rr hh ss mm  (res = W64.zero) mem Glob.mem].
 proc => /=.
 inline 5.
 seq 10 : (Poly1305_spec.good_ptr (W64.to_uint hhp) 16 /\ h = hhp /\
         poly1305_post rr ss mm hc mem Glob.mem /\
         hh = to_uint (loadW128 mem (to_uint hhp))); 1: by 
  call(Onetimeauth_s__poly1305_r_avx2_corr_h mem rr ss mm inn inl kk); auto => />. 
 wp; rewrite  /poly1305_post /poly1305_post_verif /= /poly1305_ref_verif /=; conseq />.
 ecall (verify_h hh hc hhp mem).
auto => /> ??  rres ->.
pose a := (loadW128 mem (to_uint hhp)).
pose b :=poly1305_ref _ _ _.

rewrite (divz_eq (W128.to_uint a) (2^64)) => /=.
rewrite (divz_eq b (2^64)) => /=. 
have [H1 H2] : 
(Array2.init
  (fun (i : int) =>
     (of_int
        ((b %/ 18446744073709551616 * 18446744073709551616 + b %% 18446744073709551616) %/
         if i = 0 then 1 else 18446744073709551616))%W64) =
Array2.init
  (fun (i : int) =>
     (of_int
        ((to_uint a %/ 18446744073709551616 * 18446744073709551616 + to_uint a %% 18446744073709551616) %/
         if i = 0 then 1 else 18446744073709551616))%W64)) <=>
(to_uint a %/ 18446744073709551616 = b %/ 18446744073709551616 /\
to_uint a %% 18446744073709551616 = b %% 18446744073709551616); last by smt().
rewrite tP.
split; last by  move => [-> ->] /=.
move => H;move : (H 0 _) => //=; move : (H 1 _) => //=.
rewrite !to_uint_eq !of_uintK /=. 
move => H1 H2.
split; last by smt().
rewrite edivz_eq in H1; 1: by smt().
rewrite edivz_eq in H1; 1: by smt().
rewrite modz_small in H1; 1:  by smt(W128.to_uint_cmp pow2_128).
rewrite modz_small in H1; by smt(W128.to_uint_cmp pow2_128).
qed.

lemma jade_onetimeauth_poly1305_amd64_avx2_verify_ll mem hh rr ss mm hhp inn inl kk :
  phoare [ Onetimeauth_s.M.jade_onetimeauth_poly1305_amd64_avx2_verify : 
           Glob.mem = mem /\
           mac = hhp /\ input = inn /\ input_length = inl /\ key = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint hhp) (to_uint inl) /\
           poly1305_pre_verif rr hh ss mm mem hhp inn inl kk ==> 
           true] = 1%r.
 proc => /=.
 inline 5.
 seq 10 :true => //.
 call(Onetimeauth_s__poly1305_r_avx2_ll mem rr ss mm inn inl kk);1:by  auto => />. 
 by islossless.
qed.

(* Main theorem *)

(*
abbrev good_ptr (ptr: int) len = ptr  <= ptr + len < W64.modulus.

op inv_ptr (k in_0 len: int) = good_ptr k 32 /\ good_ptr in_0 len.

op poly1305_pre (r : zp) (s : int) (m : Zp_msg)
                (mem : global_mem_t) (inn, inl, kk : W64.t)  = 
      (size m = if  W64.to_uint inl %% 16 = 0 
           then to_uint inl %/ 16
           else to_uint inl %/ 16 + 1) /\
       m = mkseq (fun i => 
            let offset = W64.of_int (i * 16) in
               if i < size m - 1
               then load_block mem (inn + offset)
               else load_lblock mem (inl - offset) (inn + offset))
                     (size m) /\
        r = load_clamp mem kk /\
        s = to_uint (loadW128 mem (to_uint (kk + W64.of_int 16))).

op poly1305_post (r : zp) (s : int) (m : Zp_msg) (ors : W64.t Array2.t) 
     (memO memN : global_mem_t) = 
  ors = Array2.init 
     (fun i =>  W64.of_int (poly1305_ref r s m %/ (if i = 0 then 1 else W64.modulus))) /\
     memO = memN.

op poly1305_pre_verif (r : Zp.zp) ( h s : int) (m : Zp_msg) (mem : global_mem_t) (hhp inn inl kk : W64.t) : bool =
  poly1305_pre r s m mem inn inl kk /\
  h = to_uint (loadW128 mem (to_uint hhp)).

op poly1305_post_verif (r : Zp.zp) (h s : int) (m : Zp_msg) (ov : bool) (memO memN : global_mem_t) :
  bool = ov = poly1305_ref_verif r h s m /\
  memO = memN.

*)

lemma jade_onetimeauth_poly1305_amd64_avx2_verify mem hh rr ss mm hhp inn inl kk :
  phoare [ Onetimeauth_s.M.jade_onetimeauth_poly1305_amd64_avx2_verify : 
           Glob.mem = mem /\
           mac = hhp /\ input = inn /\ input_length = inl /\ key = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint hhp) (to_uint inl) /\
           poly1305_pre_verif rr hh ss mm mem hhp inn inl kk ==> 
           poly1305_post_verif rr hh ss mm  (res = W64.zero) mem Glob.mem] = 1%r
  by conseq (jade_onetimeauth_poly1305_amd64_avx2_verify_ll mem hh rr ss mm hhp inn inl kk)
       (jade_onetimeauth_poly1305_amd64_avx2_verify_h mem hh rr ss mm hhp inn inl kk).
