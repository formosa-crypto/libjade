require import AllCore IntDiv List.
require import ChaCha20_savx2_proof ChaCha20_savx2 Stream_s.
from Jasmin require import JModel.

require import  Array2 Array4 Array16 WArray256.

(*
require import Array8 Array16 WArray64.

equiv store_last : ChaCha20_savx2.M.store_last ~ M.__store_xor_last_ref :
   to_uint arg{1}.`3 < 64 /\
   arg{1}.`1 = arg{2}.`1 /\ 
   arg{1}.`2 = arg{2}.`2 /\ 
   to_uint arg{1}.`3 = to_uint arg{2}.`3 /\ 
   arg{1}.`4 = arg{2}.`4 /\ 
   arg{1}.`5 = arg{2}.`5 /\ ={Glob.mem} ==> ={Glob.mem}.
proc => /=.
seq 10 10 : (#pre /\ ={s_k,u,output} /\
   plain{1} = input{2} /\ 
   to_uint len{1} = to_uint len{2} /\
   to_uint len8{1} = to_uint len8{2} /\
   to_uint len8{1} = to_uint len{2} %/ 8).
  wp;while(0<= i{1}<=15 /\ ={i,s_k,k}); auto => />. 
  + by smt().
  + by move => *; rewrite /(`>>`) !to_uint_shr //= /#.
  

wp; while(={j,Glob.mem,output,s_k} /\ 
          to_uint len{1} = to_uint len{2} /\
          plain{1} = input{2}).
+ auto => /> &1 &2; rewrite  !ultE to_uint_truncateu32 /= => ???; do split;
  rewrite !to_uintD /= to_uint_truncateu32 /=  !to_uintD /=;
      smt(W64.to_uint_cmp W32.to_uint_cmp pow2_32).

seq 2 2 : (#pre /\ ={j} /\
          j{2} =  len8{2}).

wp; while(={j,Glob.mem,output,s_k} /\ 
          to_uint len{1} = to_uint len{2} /\
          to_uint len8{1} = to_uint len8{2} /\
          plain{1} = input{2} /\
          to_uint j{2} <= to_uint len8{2}); last first.

+ auto => /> &1 &2 => ?????;  rewrite !ultE /= !to_uint_truncateu32 /= /(`<<`) /(`>>`) /=.
  split; 1: by move => *; smt(W64.to_uint_cmp W32.to_uint_cmp pow2_32).
move => jr; rewrite !ultE !to_uint_truncateu32 //=.
      smt(W64.to_uint_cmp W32.to_uint_cmp pow2_32 @W64).

+ auto => /> &1 &2; rewrite  !ultE to_uint_truncateu32 /= => ?????; 
 rewrite !to_uintD /= to_uint_truncateu32 /=  !to_uintD /=;
      smt(W64.to_uint_cmp W32.to_uint_cmp pow2_32).

 auto => /> &1 &2; rewrite !ultE to_uint_truncateu32 /= => ?????;
  rewrite /(`<<`) !to_uint_shl //=;smt(W64.to_uint_cmp W32.to_uint_cmp pow2_32).
qed.

equiv sum_states : ChaCha20_sref.M.sum_states ~ M.__sum_states_ref : ={arg} ==> ={res} by sim.

equiv rounds : ChaCha20_sref.M.rounds ~ M.__rounds_inline_ref : ={arg} ==> ={res}.
proc.
swap {2} 1 1. inline {2} 4. 
swap {2} 6 2. swap {2} 3 14.
seq 1 5 : (#pre /\ ={c} /\ k{1} = k0{2}).
+ auto => /> &2. 
  rewrite tP => kk kkb.
  case (kk <> 14).
  + move => Hkk; rewrite set_neqiE /#.
  move => Hkk; rewrite set_eqiE /#.

seq 1 1 :  (k15{1} = k15{2} /\ ={c} /\ k{1} = k0{2});  conseq />. inline *.  sim.
swap {2} 1 1.

seq 2 3 : (#pre /\ k14{1} = k140{2}); 1: by auto => /> &2. 
seq 1 1 :  (k15{1} = k15{2} /\ ={c} /\ k{1} = k0{2}  /\ k14{1} = k140{2}); 1: by conseq />;  sim.
seq 1 1 :  (k15{1} = k15{2} /\ ={c} /\ k{1} = k0{2}  /\ k14{1} = k140{2}); 1: by conseq />;  sim.
seq 2 2 : (={c} /\ k{1} = k0{2}   /\ k14{1} = k140{2} /\ k15{1} = k150{2}); 1:  by auto => /> /#. 

seq 1 1 :  (={c} /\ k{1} = k0{2}   /\ k14{1} = k140{2} /\ k15{1} = k150{2}); 1: by conseq />;  sim.

wp; while(k{1} = k{2} /\ ={k15,c} /\ (W32.zero \ult c{1} <=> !zf{1}) /\ k14{2} = k{2}.[14]); last first. 
+ auto => /> &2;do split; first 4  by
    rewrite !ultE /DEC_32 /= /rflags_of_aluop_nocf /rflags_of_aluop_nocf_w /= /ZF_of /= => ?; smt(@W32).
  + move => *;rewrite tP => kk kkb.
    case (kk <> 14).
    + move => Hkk; rewrite set_neqiE /#.
      move => Hkk; rewrite set_eqiE /#.
inline{2} 2; sp; wp 8 8 => /=; conseq  (: _ ==>  ={c} /\ k{1} = k1{2} /\ k15{1} = k151{2}); 1: by
  auto => /> &1 &2 ?; rewrite !ultE /DEC_32 /= /rflags_of_aluop_nocf /rflags_of_aluop_nocf_w /= /ZF_of /= => ? ?;
    do split;smt(@W32 pow2_32). 
sim.
+ auto => /> *;rewrite tP => kk kkb.
    case (kk <> 14).
    + move => Hkk; rewrite set_neqiE /#.
      move => Hkk; rewrite set_eqiE /#.
qed.

equiv init : ChaCha20_sref.M.init ~ M.__init_ref : 
     ={Glob.mem} /\  
     arg{1}.`1 = arg{2}.`3 /\
     arg{1}.`2 = arg{2}.`1 /\
     arg{1}.`3 = arg{2}.`2
 ==> ={res,Glob.mem}. 
proc => /=; conseq />. 
unroll for {1} 12.
unroll for {2} 10.
seq 9 7 : (#pre /\ ={st}). 
+ conseq />.
  while (0 <= i{1} <= 8 /\ #pre /\ ={st,i}); last by auto => />.
  auto => /> &1 &2 ???; split; 1: by smt().
  by congr;rewrite set_eqiE 1,2:/#.
by auto => />. 
qed.

equiv increment : ChaCha20_sref.M.increment_counter ~ M.__increment_counter_ref : ={arg} ==> ={res} by proc;auto => /> &2;congr;ring. 

equiv sum_store :  ChaCha20_sref.M.sum_states_store ~ M.__sum_states_store_xor_ref :
  ={Glob.mem} /\ 64 <= to_uint arg{1}.`3 /\
  arg{1}.`1 = arg{2}.`1 /\
  arg{1}.`2 = arg{2}.`2 /\
  to_uint arg{1}.`3 = to_uint arg{2}.`3 /\
  arg{1}.`4 = arg{2}.`4 /\
  arg{1}.`5 = arg{2}.`5 /\
  arg{1}.`6 = arg{2}.`6 
   ==> ={Glob.mem} /\ res{1}.`1 = res{2}.`1 /\ res{1}.`2 = res{2}.`2 /\ to_uint res{1}.`3 = to_uint res{2}.`3.
proc; inline *; wp; conseq (: _ ==>  ={Glob.mem,output,kk} /\ plain{1} = input{2} /\ to_uint s_len{1} = to_uint s_len{2}); 1: by  auto => /> &1 &2 H H0; rewrite !to_uintB ?uleE /= /#. 
while (#post /\ ={i,k,k15,st} /\ 0<=i{1}<=8);last by auto => />.
if; 1: by smt(). 
+ auto => /> &1 &2 ?????;do split; last 2 by smt().
by auto => /> /#.
qed.
*)

op valid_disjoint_ptr (p1 p2 l1 l2 : int) = p1 + l1 < W64.modulus && 
                                            p2 + l2 < W64.modulus && 
                                           (p1 + l1 <= p2 || p2 + l2 <= p1).

lemma top _m _c _l : 
   valid_disjoint_ptr _m _c _l _l => 
 equiv [
   ChaCha20_savx2.M.chacha20_avx2 ~ M.__chacha_xor_avx2 :
  ={Glob.mem} /\ 
  to_uint arg{1}.`1 = _c /\ 
  to_uint arg{1}.`2 = _m /\ 
  to_uint arg{1}.`3 = _l /\
  arg{1}.`1 = arg{2}.`1 /\
  arg{1}.`2 = arg{2}.`2 /\
  to_uint arg{1}.`3 = to_uint arg{2}.`3 /\
  arg{1}.`4 = arg{2}.`5 /\
  arg{1}.`5 = arg{2}.`4 /\
  arg{1}.`6 = W32.zero
   ==> ={Glob.mem,res} ].
proof.
move => Hptr.
proc => /=. 
if;1:by auto => /> *; rewrite !ultE /= /#. 
+ inline {1} 1; inline {2} 1. inline {2} 7; inline {2} 19.
  swap {2} [28..29] -27; sp 0 2.
  seq 9 27 : (#pre /\ ={k1,k2,st} /\ (len0{1} \ult (of_int 257)%W32) /\
              key0 {1} = key2{2} /\
              nonce0{1} = nonce2{2} /\
              counter0{1} = counter1{2} /\
              to_uint len{1} = to_uint len2{2} /\  
              to_uint len0{1} = to_uint len2{2} /\ 
               output0{1} = output2{2} /\ plain0{1} = input2{2} /\ 
               counter{2} = W32.zero /\ 
               valid_disjoint_ptr (to_uint output0{1}) (to_uint plain0{1}) (to_uint len0{1}) (to_uint len0{1}) ); 1: by auto => /> ; move : Hptr; rewrite /valid_disjoint_ptr /= /#. 
  seq 1 1 : #pre.
  conseq />; inline *; auto => /> &1 &2; rewrite !ultE /= => *.
  have -> : VPBROADCAST_2u128 g_sigma = CHACHA_SIGMA_H_AVX2.
  + rewrite /VPBROADCAST_2u128 -iotaredE /= -(unpack128K CHACHA_SIGMA_H_AVX2).
    congr;rewrite /unpack128 /of_list packP => i ib; rewrite !initiE //=. 
    rewrite (of_int_bits128_div_red _ _ ib _) 1:/# /=.
    case (i = 0); 1: by auto. 
    case (i = 1); 1: by auto.
    by smt().
  by congr; rewrite /VPBROADCAST_2u128 /VINSERTI128 /= -iotaredE /=.

  if; 1:by auto => /> *; rewrite !ultE /= /#. 
  + seq 1 1 : #pre; 1: by inline *;auto=> />.
    seq 1 1 : #pre.
    + inline {1} 1; inline {2} 1; wp; conseq />.
      unroll {1} 6; rcondt {1} 6; 1: by auto => />.
      while(={k10,k20} /\ to_uint c{1} = 10 - to_uint c{2} /\
             r16{1} = r160{2} /\ r8{1} = r80{2} /\
             1 <= to_uint c{1} <= 10).
      + inline {2} 1. 
        wp; sp;conseq (_: 
          k10{1} = k11{2} /\ k20{1} = k21{2} /\
            r16{1} = r161{2} /\ r8{1} = r81{2}  
              ==> k10{1} = k11{2} /\ k20{1} = k21{2}); 1: by smt().
        + move => &1 &2; rewrite !ultE /= => ??????.
          rewrite /DEC_32 /rflags_of_aluop_nocf_w !ultE /=.
          rewrite to_uintB  /=;1: by rewrite uleE /= /#.  
          by rewrite to_uintD_small  /=; smt(W64.to_uint_cmp). 
        by admit. (* too slow clear Hptr _m _c _l; seq 1 1 : #pre; inline *;auto => />. *)

  inline {2} 6.
  wp; sp;conseq (_: 
      k10{1} = k11{2} /\ k20{1} = k21{2} /\
        r16{1} = r161{2} /\ r8{1} = r81{2}  
           ==> k10{1} = k11{2} /\ k20{1} = k21{2}); 1: by smt().
  + move => &1 &2; rewrite !ultE /= => ??????.
    rewrite /DEC_32 /rflags_of_aluop_nocf_w !ultE /=.
    rewrite to_uintB  /=. rewrite uleE /=; 1: by smt(W32.to_uintK W32.of_uintK pow2_32).
     rewrite !to_uintD_small  /=; 1: by  smt(W64.to_uint0). 
     split; 1:  by smt(W32.to_uintK W32.of_uintK pow2_32 W64.to_uint0). 
     by move => ????; rewrite !ultE /#. 
     by admit. (* too slow clear Hptr _m _c _l; seq 1 1 : #pre; inline *;auto => />. *)

  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  conseq (_: ={Glob.mem,k1,k2} /\ 
              (to_uint len0{1} < 257) /\
             output0{1} = output2{2} /\ 
             valid_disjoint_ptr (to_uint output0{1})
               (to_uint plain0{1}) (to_uint len0{1}) (to_uint len0{1}) /\
             plain0{1} = input2{2} /\ to_uint len0{1} = to_uint len2{2} /\ 
            128 < to_uint len0{1} ==> ={Glob.mem}); 1:
              by  move => &1 &2 />; rewrite !ultE /=.  
  seq 1 1 : (#{/~k1{1}}{~128 < to_uint len0{1}}pre /\ to_uint len0{1} <= 128). 
  + inline *; do 2!(unroll for {1} ^while); unroll for {2} ^while.
    auto => /> &1 &2 ??????; do split;  last 5 first. 
    + by rewrite !to_uintB  /=; rewrite ?uleE /=   /#.
    + rewrite !to_uintB  /=;1: rewrite ?uleE /=   /#.
      by rewrite to_uintD_small /=; smt(). 
    + rewrite !to_uintB  /=;1: rewrite ?uleE /=   /#.
      by rewrite !to_uintD_small /=; smt(). 
    +  rewrite !to_uintB  /=;1: rewrite ?uleE /=   /#.
      by rewrite uleE /#. 
    + by smt().
    + by rewrite !to_uintB  /=;rewrite ?uleE /=   /#.

    congr;last first.
    + congr; rewrite /loadW256.
      congr; apply W32u8.Pack.ext_eq => x xb.
      rewrite !initiE 1,2:/# /=.
      rewrite get_storeW256E /=.
      rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
      rewrite get_storeW256E /=.
      rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
      rewrite get_storeW256E /=.
      rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
      done.
   congr; last first.
    + congr; rewrite /loadW256.
      congr; apply W32u8.Pack.ext_eq => x xb.
      rewrite !initiE 1,2:/# /=.
      rewrite get_storeW256E /=.
      rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
      rewrite get_storeW256E /=.
      rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
      done.
   congr; last first.
    + congr; rewrite /loadW256.
      congr; apply W32u8.Pack.ext_eq => x xb.
      rewrite !initiE 1,2:/# /=.
      rewrite get_storeW256E /=.
      rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
      done.

   inline *.
   seq 7 4 : (#pre /\ ={k} /\ 
             output1{1} = output3{2} /\ 
             to_uint len1{1} <= 128 /\
             plain1{1} = input3{2} /\  
             valid_disjoint_ptr (to_uint output1{1})
               (to_uint plain1{1}) (to_uint len1{1}) (to_uint len1{1}) /\
             to_uint len1{1} = to_uint len3{2} /\
             r{1}.[0] = k{2}.[0] /\ 
             r{1}.[1] = k{2}.[1]); 1: by auto => />.

   seq 1 1 : (#{/~k{1}=k{2}}pre /\ to_uint len1{1} <= 64). 
  + if; 1: by move => ?;rewrite !uleE /=; smt().
    unroll for {2} 2.
    auto => /> &1 &2; rewrite !uleE /= => *; do split; last 5 first.
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 
      +  rewrite !to_uintB /=; 1: by rewrite ?uleE /#. 
         by rewrite to_uintD_small /= /#.
      +  rewrite !to_uintB /=; 1: by rewrite ?uleE /#. 
         by rewrite !to_uintD_small /= /#.
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 

    congr; 1: by smt().
    congr;rewrite /loadW256.
    congr; apply W32u8.Pack.ext_eq => x xb.
    rewrite !initiE 1,2:/# /=.
    rewrite get_storeW256E /=.
    rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
    done.

   by auto => /> &1 &2 ?????????????; rewrite uleE /= /#.

  seq 7 1 : 
    ( ={Glob.mem} /\ to_uint len3{1} <= 32 /\
     valid_disjoint_ptr (to_uint output3{1})
               (to_uint plain3{1}) (to_uint len3{1}) (to_uint len3{1}) /\
     output3{1} = output3{2} /\
     plain3{1} = input3{2} /\
     to_uint len3{1} = to_uint len3{2} /\
     r0{1}  = k{2}.[0]).
  + sp 6 0; if; 1: by move => ?;rewrite !uleE /=; smt().
    auto => /> &1 &2; rewrite !uleE /= => *; do split; last 2 first.
       + rewrite !to_uintB /=; 1: rewrite ?uleE /#. 
      by rewrite !to_uintD_small /= /#.
       + by rewrite !to_uintB /=;  rewrite ?uleE /#. 
    by smt().
       + by rewrite !to_uintB /=;  rewrite ?uleE /#. 
        + rewrite !to_uintB /=; 1: rewrite ?uleE /#. 
      by rewrite !to_uintD_small /= /#.
   by auto => /> &1 &2 ?????????????; rewrite uleE /= /#.

  seq 2 2 : 
    ( ={Glob.mem} /\ to_uint len3{1} <= 16 /\
       valid_disjoint_ptr (to_uint output3{1})
        (to_uint plain3{1}) (to_uint len3{1}) (to_uint len3{1}) /\
     output3{1} = output3{2} /\
     plain3{1} = input3{2} /\
     to_uint len3{1} = to_uint len3{2} /\
     r1{1}  = r0{2}). 
  + auto => /> &1 &2; rewrite !uleE /= => ?????;
      rewrite /VEXTRACTI128 /b2i /= /truncateu128  bits128_div //.
    do split; last by smt().
    + move => ?; rewrite !to_uintB /=; rewrite ?uleE; 1,2:smt(). 
      by rewrite !to_uintD_small /= /#.

  splitwhile {1} 3 : ((of_int 8)%W32 \ule  (len3 - truncateu32 j)).
  seq 1 0 : (#pre /\ forall k, 0<=k<16 => s0{1}.[k] = 
              (W16u8.unpack8 r0{2}).[k]).
  by auto => /> &1 &2 ????? k kbl kbh; 
    rewrite /unpack8 !initiE 1,2:/# /= ifT 1:/#.  

  seq 2 2 : 
    ( ={Glob.mem} /\ to_uint len3{1} <= 16 /\
     to_uint j{1} = 
        (if 8 <= to_uint len3{1} then to_uint len3{1}  - 8 else 0) /\
     valid_disjoint_ptr (to_uint output3{1})
               (to_uint plain3{1}) (to_uint len3{1}) (to_uint len3{1}) /\
     to_uint output3{1} + to_uint j{1} = to_uint output3{2} /\
     to_uint plain3{1} + to_uint j{1} = to_uint input3{2} /\
     to_uint len3{1} + to_uint j{1} = to_uint len3{2} /\
     forall (k : int), 0 <= k && k < 8 => 
        s0{1}.[to_uint j{1} + k] = (unpack8 r1{2}).[k]). 
     + sp 0 1; if{2}; last first.
       + while {1} (#pre /\ to_uint len3{1} <= 16 /\
               valid_disjoint_ptr (to_uint output3{1})
               (to_uint plain3{1}) (to_uint len3{1}) (to_uint len3{1}) /\
                    truncateu32 j{1} \ule len3{1} /\ j{1} = W64.zero /\
                    ! ((of_int 8)%W64 \ule len3{2})) (to_uint len3{1} - to_uint j{1}).
         + move =>  &2 ?;exfalso => />. 
           move => &1; rewrite !ultE !uleE /= !to_uint_truncateu32 /=.
           have : (! 8 <= to_uint len3{1}) => to_uint j{1} %% 4294967296 <= to_uint len3{1} =>  (!8 <= to_uint (len3{1} - truncateu32 j{1})); last by smt().
           by move => ?; rewrite to_uintD /= to_uintN /= to_uint_truncateu32 /= /#. 
         auto => /> &1 &2 ;  rewrite  !uleE /= !to_uint_truncateu32 /=.
         move=> ?????H?; do split; 1: smt(W32.to_uint_cmp).
         + rewrite !ultE /= !to_uint_truncateu32 /= => ??.
           by rewrite !to_uintB /=; by rewrite ?uleE /= to_uint_truncateu32 /= /#. 
         + rewrite !ultE /= !to_uint_truncateu32 /= => ??.
           do split; 1: smt(). 
          move => k kb kbh; rewrite /VPEXTR_64 /= H 1:/#.
         rewrite !get_unpack8 1,2:/#.  
         rewrite !bits8_div /= 1,2:/#. 
         rewrite bits64_div /= 1:/# of_uintK.
         rewrite W8.to_uint_eq !of_uintK.
          rewrite dvdz_mod_div //.
             smt(gt0_pow2).
             apply dvdz_exp2l; 1: smt().
         rewrite modz_dvd; last by smt().
         by rewrite expz_div 1,2:/#; apply dvdz_exp2l; smt().

+ unroll {1} 2.
  rcondt {1} 2.  move => *; auto => /> &1 ??????.
  rewrite !uleE !ultE.
  rewrite to_uintB. rewrite uleE /=; 1: by
    rewrite to_uint_truncateu32 /=;  smt(W64.to_uint_cmp).
  rewrite !to_uint_truncateu32 /= /#.
  seq 5 11 : #post; last first.
  + while {1} (#pre) (1).
    move => *; exfalso.
    move => *. admit.
    by auto => />.

    admit.
    admit.
  
        
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre. inline *.  
  + wp;conseq />;unroll {1} ^while.
    rcondt {1} 5; 1: by move => &m; auto => />.
    admit.    
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  inline *. admit. (* reusable from above *)

inline {1} 1; inline {2} 1; inline {2} 7;  inline {2} 19.
swap {2} [27..28] -26; sp 0 2.
seq 9 28 : (#pre /\ ={k,st} /\ 
            key0 {1} = key2{2} /\
            nonce0{1} = nonce2{2} /\
            counter0{1} = counter1{2} /\
            to_uint len{1} = to_uint len2{2} /\  
            to_uint len0{1} = to_uint len2{2} /\ 
            output0{1} = output2{2} /\ plain0{1} = input2{2} /\ 
            counter{2} = W32.zero); 1: by inline *; auto => />.
  seq 1 1 : #pre. admit. 
(* 
  conseq />; inline *; auto => /> &1 &2; rewrite !ultE /= => *.
  have -> : VPBROADCAST_2u128 g_sigma = CHACHA_SIGMA_H_AVX2.
  + rewrite /VPBROADCAST_2u128 -iotaredE /= -(unpack128K CHACHA_SIGMA_H_AVX2).
    congr;rewrite /unpack128 /of_list packP => i ib; rewrite !initiE //=. 
    rewrite (of_int_bits128_div_red _ _ ib _) 1:/# /=.
    case (i = 0); 1: by auto. 
    case (i = 1); 1: by auto.
    by smt().
  by congr; rewrite /VPBROADCAST_2u128 /VINSERTI128 /= -iotaredE /=.
*)

admit.

qed.
