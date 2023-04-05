require import AllCore IntDiv List.
require import ChaCha20_savx2_proof ChaCha20_savx2 Stream_s.
from Jasmin require import JModel.

require import  Array2 Array4 Array8 Array16 WArray256.


op valid_disjoint_ptr (p1 p2 l1 l2 : int) = p1 + l1 < W64.modulus && 
                                            p2 + l2 < W64.modulus && 
                                           (p1 + l1 <= p2 || p2 + l2 <= p1).

lemma xor_bits8( w1 w2 : W64.t) : (w1 `^` w2) \bits8 0 = (w1 \bits8 0) `^` (w2 \bits8 0).
apply W8.wordP => k kb.
by rewrite bits8iE 1:kb !xorwE !bits8iE 1,2:kb.
qed.

lemma shr0 (w:W64.t) : w `>>` W8.zero = w.
proof. rewrite /(`>>`) wordP /=/#. qed.

equiv store_x2: ChaCha20_savx2.M.store_x2 ~    M.__store_xor_h_avx2: 
   ={Glob.mem,k} /\ 
   to_uint len{1} < 257 /\
   output{1} = output{2} /\ 
   valid_disjoint_ptr (to_uint output{1})
               (to_uint plain{1}) (to_uint len{1}) (to_uint len{1}) /\
             plain{1} = input{2} /\ to_uint len{1} = to_uint len{2} /\ 
            128 <= to_uint len{1} ==> 
    ={Glob.mem} /\ res{1}.`1 = res{2}.`1 /\ res{1}.`2 = res{2}.`2 /\ 
        valid_disjoint_ptr (to_uint res{1}.`1)
               (to_uint res{1}.`2) (to_uint res{1}.`3) (to_uint res{1}.`3) /\
        to_uint res{1}.`3 = to_uint res{2}.`3 /\ 
     to_uint res{1}.`3 <= 128.
proc. 
inline *; do 2!(unroll for {1} ^while); unroll for {2} ^while.
auto => /> &1 &2 ??????; do split;  last 4 first.
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
qed.

equiv store_x2_last_corr : 
  ChaCha20_savx2.M.store_x2_last ~  M.__store_xor_last_h_avx2 :
  (={Glob.mem} /\
   ={k} /\
   to_uint len{1} < 257 /\
   output{1} = output{2} /\
   valid_disjoint_ptr (to_uint output{1}) (to_uint plain{1}) (to_uint len{1}) (to_uint len{1}) /\
   plain{1} = input{2} /\ to_uint len{1} = to_uint len{2}) /\
  to_uint len{1} <= 128
  ==> 
 ={Glob.mem}.
proc => /=.
   inline *.
   seq 3 0 : (#pre /\
             r{1}.[0] = k{2}.[0] /\ 
             r{1}.[1] = k{2}.[1]); 1: by auto => />.

   seq 1 1 : (#{/~k{1}=k{2}}pre /\ to_uint len{1} <= 64). 
  + if; 1: by move => ?;rewrite !uleE /=; smt().
    unroll for {2} 2.
    auto => /> &1 &2; rewrite !uleE /= => *; do split; last 6 first.
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 
      +  rewrite !to_uintB /=; 1: by rewrite ?uleE /#. 
         by rewrite to_uintD_small /= /#.
      +  rewrite !to_uintB /=; 1: by rewrite ?uleE /#. 
         by rewrite !to_uintD_small /= /#.
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 
      +  rewrite !to_uintB /=; by rewrite ?uleE /#. 

    congr; 1: by smt().
    congr;rewrite /loadW256.
    congr; apply W32u8.Pack.ext_eq => x xb.
    rewrite !initiE 1,2:/# /=.
    rewrite get_storeW256E /=.
    rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
    done.

   by auto => /> &1 &2 ????????; rewrite uleE /= /#.

  seq 7 1 : 
    ( ={Glob.mem} /\ to_uint len1{1} <= 32 /\
     valid_disjoint_ptr (to_uint output1{1})
               (to_uint plain1{1}) (to_uint len1{1}) (to_uint len1{1}) /\
     output1{1} = output{2} /\
     plain1{1} = input{2} /\
     to_uint len1{1} = to_uint len{2} /\
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
   by auto => /> &1 &2 ?????????; rewrite uleE /= /#.

  seq 2 2 : 
    ( ={Glob.mem} /\ to_uint len1{1} <= 16 /\
       valid_disjoint_ptr (to_uint output1{1})
        (to_uint plain1{1}) (to_uint len1{1}) (to_uint len1{1}) /\
     output1{1} = output{2} /\
     plain1{1} = input{2} /\
     to_uint len1{1} = to_uint len{2} /\
     r1{1}  = r0{2}). 
  + auto => /> &1 &2; rewrite !uleE /= => ?????;
      rewrite /VEXTRACTI128 /b2i /= /truncateu128  bits128_div //.
    do split; last by smt().
    + move => ?; rewrite !to_uintB /=; rewrite ?uleE; 1,2:smt(). 
      by rewrite !to_uintD_small /= /#.

  seq 1 0 : (#pre /\ forall k, 0<=k<16 => s0{1}.[k] = 
              (W16u8.unpack8 r0{2}).[k]).
  by auto => /> &1 &2 ????? k kbl kbh; 
    rewrite /unpack8 !initiE 1,2:/# /= ifT 1:/#.  

  splitwhile {1} 2 : ((of_int 8)%W32 \ule  len1 /\ 
                     (truncateu32 j) \ult (W32.of_int 8)).

  seq 2 2 : 
    ( ={Glob.mem} /\ to_uint len{2} <= 8 /\
     to_uint j{1} = 
        (if 8 <= to_uint len1{1} then 8 else 0) /\
     valid_disjoint_ptr (to_uint output1{1})
               (to_uint plain1{1}) (to_uint len1{1}) (to_uint len1{1}) /\
     to_uint output1{1} + to_uint j{1} = to_uint output{2} /\
     to_uint plain1{1} + to_uint j{1} = to_uint input{2} /\
     to_uint len1{1} - to_uint j{1} = to_uint len{2} /\
     forall (k : int), 0 <= k && k < 8 => 
        s0{1}.[to_uint j{1} + k] = (unpack8 r1{2}).[k]). 
     + sp 0 1; if{2}; last first.
       + while {1} (#pre /\ j{1} = W64.zero /\
                    ! ((of_int 8)%W64 \ule len{2})) (to_uint len1{1} - to_uint j{1}).
         + move =>  &2 ?;exfalso => />. 
           by move => &1; rewrite !ultE !uleE /= !to_uint_truncateu32 /= /#.
         auto => /> &1 &2 ;  rewrite  !uleE /=.
         move=> ?????H?; do split; 1: smt(W32.to_uint_cmp).
         move => ?; do split; 1,2: by smt().
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

+ do 8!(unroll {1} ^while).
  rcondt {1} 2.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 6.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 10.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 14.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 18.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 22.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 26.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  rcondt {1} 30.
  + move => *; auto => /> &1 ??????.
    by rewrite !uleE !ultE /=!to_uint_truncateu32 /= /#.
  while {1} (#post /\ to_uint j{1} = 8) (8 - to_uint j{1}).
  + by move => &1 ?; auto => /> /#. 
  auto => /> &1 &2 ????? H0; rewrite uleE /= => H; do split; first last.
  + rewrite to_uintB /=; rewrite ?uleE /=; smt(W64.to_uint_cmp). 
  + by smt().
  + rewrite to_uintD_small /= /#. 
  + rewrite to_uintD_small /= /#. 
  + rewrite to_uintB /=;  rewrite ?uleE /=; smt(W64.to_uint_cmp). 
  + move => k kbl kbh;  rewrite /unpack8 initiE 1:/# /= /VPEXTR_64 /= H0 1:/#.  
    rewrite get_unpack8 1:/#.  
    rewrite !bits8_div /= 1,2:/#. 
    rewrite !bits64_div /= 1:/# of_uintK.
    rewrite W8.to_uint_eq !of_uintK.
     rewrite !dvdz_mod_div //; 1: by 
        smt(gt0_pow2).
        apply dvdz_exp2l; 1: smt().
    rewrite !modz_dvd.
    by rewrite expz_div 1,2:/#; apply dvdz_exp2l; smt().
    rewrite mulrDr /= exprD_nneg 1,2:/# -divzMl /=; by smt(gt0_pow2). 
  + by smt().
  + apply mem_eq_ext => add.
    case (!(to_uint output{2} <= add && add < to_uint output{2} + 8)).
    + move => outrange; rewrite /storeW8 /storeW64. 
      rewrite get_storesE /= ifF 1:/#.
      by rewrite !get_set_neqE_s; rewrite ?to_uintD_small /#.
    move => inrange; rewrite /storeW8 /storeW64 /loadW8. 
    rewrite get_storesE /= ifT 1:/#.
    case (add - to_uint output{2} = 0). 
    + move => pos0; do 7!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by smt().
      rewrite W8.WRing.addrC xor_bits8. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      by rewrite /loadW8 /loadW64 pack8bE 1:/# /=. 
    case (add - to_uint output{2} = 1). 
    + move => pos1 npos0; rewrite ifT 1:/# /=; do 6!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#.
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      by rewrite  /loadW64 pack8bE 1:/# /=  to_uintD_small /#.
    case (add - to_uint output{2} = 2). 
    + move => pos2 pos1 npos0; rewrite ifF 1:/# ifT 1:/# /=; do 5!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      do 2!(rewrite get_set_neqE_s; 1: by rewrite !to_uintD_small /#).
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      rewrite  /loadW64 pack8bE 1:/# /=  !to_uintD_small /#.
     case (add - to_uint output{2} = 3). 
    + move => pos3 pos2 pos1 npos0; rewrite ifF 1:/# ifF 1:/# ifT 1:/# /=; 
        do 4!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      do 3!(rewrite get_set_neqE_s; 1: by rewrite !to_uintD_small /#).
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      rewrite  /loadW64 pack8bE 1:/# /=  !to_uintD_small /#.
     case (add - to_uint output{2} = 4). 
    + move => pos4 pos3 pos2 pos1 npos0; do 3!(rewrite ifF 1:/#); rewrite ifT 1:/# /=; 
        do 3!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      do 4!(rewrite get_set_neqE_s; 1: by rewrite !to_uintD_small /#).
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      rewrite  /loadW64 pack8bE 1:/# /=  !to_uintD_small /#.
     case (add - to_uint output{2} = 5). 
    + move => pos5 pos4 pos3 pos2 pos1 npos0; do 4!(rewrite ifF 1:/#); rewrite ifT 1:/# /=; 
        do 2!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      do 5!(rewrite get_set_neqE_s; 1: by rewrite !to_uintD_small /#).
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      rewrite  /loadW64 pack8bE 1:/# /=  !to_uintD_small /#.
     case (add - to_uint output{2} = 6). 
    + move => pos6 pos5 pos4 pos3 pos2 pos1 npos0; do 5!(rewrite ifF 1:/#); rewrite ifT 1:/# /=; 
        do 1!(rewrite get_set_neqE_s; 1: by rewrite to_uintD_small /#).
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      do 6!(rewrite get_set_neqE_s; 1: by rewrite !to_uintD_small /#).
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      rewrite  /loadW64 pack8bE 1:/# /=  !to_uintD_small /#.
     case (add - to_uint output{2} = 7). 
    + move => pos7 pos6 pos5 pos4 pos3 pos2 pos1 npos0; do 6!(rewrite ifF 1:/#); rewrite ifT 1:/# /=; 
      rewrite get_set_eqE_s; 1: by rewrite to_uintD_small /#.
      do 7!(rewrite get_set_neqE_s; 1: by rewrite !to_uintD_small /#).
      rewrite W8.WRing.addrC. congr.
      + rewrite /VPEXTR_64 /= H0 1:/#.
        by rewrite !get_unpack8 1,2:/#. 
      rewrite  /loadW64 pack8bE 1:/# /=  !to_uintD_small /#.
    by smt().

  while (={Glob.mem} /\ to_uint j{1} <= to_uint len1{1} /\ to_uint len{2} <= 8 /\
         valid_disjoint_ptr (to_uint output1{1}) (to_uint plain1{1}) (to_uint len1{1}) (to_uint len1{1}) /\
         to_uint output1{1} + to_uint j{1} = to_uint output{2} /\
         to_uint plain1{1} + to_uint j{1} = to_uint input{2} /\
         to_uint len1{1} - to_uint j{1} = to_uint len{2} /\
         forall k, 0<= k < to_uint len1{1} - to_uint j{1} =>
           s0{1}.[to_uint j{1} + k] = truncateu8 (r1{2} `>>` W8.of_int (8*k))

  ); last first.
   + auto => /> &1 &2 ????????H; do split.  
    + by smt(W64.to_uint_cmp).
    + by move => k kbl kbh; rewrite (H k _) 1:/# /unpack8 initiE 1:/# /= to_uint_eq to_uint_truncateu8 bits8_div 1:/# /= /(`>>`) to_uint_shr /= /#.
    + by rewrite !ultE /= to_uint_truncateu32; smt(W64.to_uint_cmp).
    + by rewrite !ultE /= to_uint_truncateu32; smt(W64.to_uint_cmp).

  auto => /> &1 &2 ???????? HH; rewrite !ultE /= !to_uint_truncateu32 /= => H H0;do split.  
    + by rewrite (HH 0 _) 1:/#  /= W8.WRing.addrC !to_uintD_small /= 1,2: /# shr0 /#.
    + rewrite  !to_uintD_small /=; smt(W64.to_uint_cmp).
    + rewrite  !to_uintB /=; by  rewrite ?uleE /= ;smt(W64.to_uint_cmp).     
    + rewrite  !to_uintD_small /=; smt(W64.to_uint_cmp). 
    + rewrite  !to_uintD_small /=; smt(W64.to_uint_cmp). 
    + rewrite  !to_uintB /=; 1: by  rewrite uleE /= ;smt(W64.to_uint_cmp).    rewrite  !to_uintD_small /=; smt(W64.to_uint_cmp).   
    + rewrite  to_uintD_small /=; 1: by smt(W64.to_uint_cmp). 
      move => k kbl kbh; move : (HH (1+k) _); 1:by smt().
     rewrite /(`>>`) shrw_add //= 1:/#. 
     rewrite !(modz_small _ 256); smt( StdOrder.IntOrder.ger0_norm W64.to_uint_cmp pow2_64 W32.to_uint_cmp pow2_32). 
    + rewrite  !to_uintB /=; 1: by  rewrite uleE /= ;smt(W64.to_uint_cmp).    rewrite  !to_uintD_small /=;1: smt( W64.to_uint_cmp). 
      rewrite modz_small in H. 
       rewrite StdOrder.IntOrder.ger0_norm //;  smt(W64.to_uint_cmp W32.to_uint_cmp pow2_64 pow2_32).
        smt(W64.to_uint_cmp W32.to_uint_cmp pow2_64 pow2_32).
    +  rewrite  !to_uintB /=; 1: by  rewrite uleE /= ;smt(W64.to_uint_cmp).    rewrite  !to_uintD_small /=;1: smt( W64.to_uint_cmp). 
      rewrite modz_small in H. 
       rewrite StdOrder.IntOrder.ger0_norm //;  smt(W64.to_uint_cmp W32.to_uint_cmp pow2_64 pow2_32).
        smt(W64.to_uint_cmp W32.to_uint_cmp pow2_64 pow2_32).
qed.

equiv line_x8 : ChaCha20_savx2.M.line_x8 ~  M.__line_h_avx2 : 
   ={k,r16,r8,r} /\ 
   a{1} %/4 = a{2} /\
   b{1} %/4 = b{2} /\
   c{1} %/4 = c{2}  ==> ={res} by proc; inline *; auto => />.

equiv column_round : ChaCha20_savx2.M.column_round_x2 ~ M.__column_round_h_avx2 :
  ={arg} ==> ={res}.
proc; call(_: true); last by auto.
by do 4!(call line_x8); auto => />.
qed.

equiv diagonal_round : ChaCha20_savx2.M.diagonal_round_x2 ~ M.__diagonal_round_h_avx2 :
  ={arg} ==> ={res}.
proc. 
seq 1 1: #pre; 1: by sim.
seq 1 1: #pre; last by sim.
call(_: true); last by auto.
by do 4!(call line_x8); auto => />.
qed.

equiv diagonal_roundx4 : 
  ChaCha20_savx2.M.diagonal_round_x4 ~  M.__diagonal_round_h_x2_avx2 :
   ={arg} ==> ={res}.
proc. 
seq 1 1 : #pre; 1: by sim.
seq 1 1 : #pre; 2: by sim.
call(_: true); last by auto.
inline {1} 2; inline {1} 1.
by inline *; auto => />. 
qed.

equiv column_roundx4 : 
  ChaCha20_savx2.M.column_round_x4 ~  M.__column_round_h_x2_avx2 :
   ={arg} ==> ={res}.
proc. 
call(_: true); last by auto.
by inline *; auto => />. 
qed.

equiv column_roundx8 : 
  ChaCha20_savx2.M.column_round_x8 ~ M.__column_round_v_1_avx2  : ={arg} ==> ={res} by sim.                          

equiv diagonal_roundx8 : 
   ChaCha20_savx2.M.diagonal_round_x8 ~ M.__diagonal_round_v_1_avx2 : ={arg} ==> ={res} by sim.                                                         

equiv rounds_x8 :
  ChaCha20_savx2.M.rounds_x8 ~ M.__rounds_v_avx2 :
   ={arg} ==> ={res}.
proc. 
sp 1 1; swap {1} 1 2; swap {2} 1 1.
inline {2} 1; sp.
wp; conseq (: _ ==> ={k,k15}); 1: by smt().
while(#post /\ s_r16{1} = r16{2} /\ s_r8{1} = r8{2} /\
       to_uint c{1} = to_uint c{2} /\ 
       zf{1} = (to_uint c{2} = 0)).
+ wp;inline {2} 1;wp; call(diagonal_roundx8);call(column_roundx8); auto => /> &1 &2 ??; rewrite !ultE /= => ?.
  rewrite /DEC_32 /DEC_64 /rflags_of_aluop_nocf_w /= /ZF_of /=.
  rewrite !to_uintB; 1,2: rewrite ?uleE /= /#.
  do split. 
  + smt().
  + rewrite to_uint_eq !to_uintB; rewrite ?uleE /= /#.
  + rewrite to_uint_eq !to_uintB; rewrite ?uleE /= /#.
  + rewrite to_uint_eq !to_uintB; rewrite ?uleE /= /#.

wp; call(diagonal_roundx8);call(column_roundx8); auto => />. 
rewrite /DEC_32 /DEC_64 /rflags_of_aluop_nocf_w /= /ZF_of /=.
  + rewrite to_uint_eq /#.
qed.

op interleave_rel(i07: W256.t Array8.t,  k03 k47 : W256.t Array4.t) : bool =
    i07.[0] = k03.[0] /\
    i07.[1] = k03.[1] /\
    i07.[2] = k03.[2] /\
    i07.[3] = k03.[3] /\
    i07.[4] = k47.[0] /\
    i07.[5] = k47.[1] /\
    i07.[6] = k47.[2] /\
    i07.[7] = k47.[3].

equiv interleave :
  ChaCha20_savx2.M.interleave_0 ~ M.__interleave_avx2 :
     ={arg} ==> interleave_rel res{1} res{2}.`1 res{2}.`2.
proc; unroll for {1} ^while; auto => />.
qed.

equiv store_x8_last : 
  ChaCha20_savx2.M.store_x8_last ~ M.__store_xor_last_v_avx2 :
   to_uint len{1} < 512 /\
   ={Glob.mem} /\ 
   arg{1}.`1 = arg{2}.`1 /\
   arg{1}.`2 = arg{2}.`2 /\
   to_uint arg{1}.`3 = to_uint arg{2}.`3 /\
   arg{1}.`4 = arg{2}.`4 /\
   valid_disjoint_ptr (to_uint output{1})
               (to_uint plain{1}) (to_uint len{1}) (to_uint len{1}) /\
             plain{1} = input{2}
   ==>
    ={Glob.mem}.
proc => /=. 
seq 6 7 : (#pre /\ ={k0_7, s_k8_15,s_k0_7}); 1: by conseq />;sim.
seq 2 2 : (#pre /\ ={k8_15}); 1: by conseq />;sim.
seq 1 1 : (#pre /\ interleave_rel i0_7{1} k0_3{2} k4_7{2}); 1: by call(interleave); auto => />.
seq 1 1 : (#pre /\ to_uint len{1}  <= 256); last first.
+ inline{1} 1; inline {2} 1.
  seq 7 5 : (#pre /\ ={output0} /\ r{1}= k1{2} /\
          interleave_rel k0{1} k1{2} k2{2} /\
            plain0{1} = input0{2} /\
      to_uint len0{1} = to_uint len0{2} /\
      valid_disjoint_ptr (to_uint output0{1}) (to_uint plain0{1}) (to_uint len0{1}) (to_uint len0{1}) /\
      to_uint len0{1} <= 256).
  + unroll for {1} 7; auto => /> *; rewrite tP => k kb.
    smt(Array4.set_eqiE Array4.set_neqiE Array8.set_eqiE Array8.set_neqiE).
  seq 1 1 : (#{/~interleave_rel k0{1} k1{2} k2{2}}pre /\ to_uint len0{1} <= 128 /\ r{1} = k1{2} 
   /\ k0{1}.[4] = k2{2}.[0]
   /\ k0{1}.[5] = k2{2}.[1]
   /\ k0{1}.[6] = k2{2}.[2]
   /\ k0{1}.[7] = k2{2}.[3]); 
     last by call(store_x2_last_corr); auto => /> /#.
  if; 1,3: by auto => /> &1 &2; rewrite !uleE /= /#.
  seq 1 1 : #{/~r{1}}post; 1: by 
  call(store_x2); auto => /> &1 &2 ???????????????????????????; rewrite !uleE /= => ?;do split;  smt(). 
  unroll for {1} 2. auto => /> &1 &2 ????????????????????????; rewrite /copy_256 /=; do split;1,2:
    smt(Array4.tP Array4.set_eqiE Array4.set_neqiE Array8.set_eqiE Array8.set_neqiE).

if; last first ;1, 2: by  auto => />; rewrite ?uleE /= /#.
call(interleave).
inline {1} 1; inline {2} 1.
inline *; do 2!(unroll for {1} ^while); do 2!(unroll for {2} ^while).
auto => /> &1 &2; rewrite !uleE /= => ????????????????????????; do split;  last 4 first.
 + rewrite !to_uintB  /=; rewrite ?uleE /=   /#.
 + rewrite !to_uintB  /=;1: rewrite ?uleE /=   /#.
   by rewrite to_uintD_small /=; smt(). 
 + rewrite !to_uintB  /=;1: rewrite ?uleE /=   /#.
   by rewrite !to_uintD_small /=; smt(). 
 + by rewrite !to_uintB  /=;rewrite ?uleE /=   /#.
 + by rewrite !to_uintB  /=;rewrite ?uleE /=   /#.

 congr;last first.
 + have -> : i0_7{1}.[7] = k4_7{2}.[3] by smt().
   congr; rewrite /loadW256.
   congr;apply W32u8.Pack.ext_eq => x xb.   
   rewrite !initiE 1,2:/# /=.
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   done.
congr; last first.
 + have -> : i0_7{1}.[6] = k4_7{2}.[2] by smt().
   congr; rewrite /loadW256.
   congr; apply W32u8.Pack.ext_eq => x xb.
   rewrite !initiE 1,2:/# /=.
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   done.
congr; last first.
 + have -> : i0_7{1}.[5] = k4_7{2}.[1] by smt().
   congr; rewrite /loadW256.
   congr; apply W32u8.Pack.ext_eq => x xb.
   rewrite !initiE 1,2:/# /=.
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   done.
congr; last first.
 + have -> : i0_7{1}.[4] = k4_7{2}.[0] by smt().
   congr; rewrite /loadW256.
   congr; apply W32u8.Pack.ext_eq => x xb.
   rewrite !initiE 1,2:/# /=.
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   done.
congr; last first.
 + have -> : i0_7{1}.[3] = k0_3{2}.[3] by smt().
   congr; rewrite /loadW256.
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
 + have -> : i0_7{1}.[2] = k0_3{2}.[2] by smt().
   congr; rewrite /loadW256.
   congr; apply W32u8.Pack.ext_eq => x xb.
   rewrite !initiE 1,2:/# /=.
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   done.
congr; last first.
 + have -> : i0_7{1}.[1] = k0_3{2}.[1] by smt().
   congr; rewrite /loadW256.
   congr; apply W32u8.Pack.ext_eq => x xb.
   rewrite !initiE 1,2:/# /=.
   rewrite get_storeW256E /=.
   rewrite ifF; 1: by rewrite !to_uintD_small /= /#. 
   done.
have -> : i0_7{1}.[0] = k0_3{2}.[0] by smt().
smt().
qed.

equiv store_x8 : 
  ChaCha20_savx2.M.store_x8 ~  M.__store_xor_v_avx2 :
   ={Glob.mem} /\ 512 <= to_uint len{1} /\
   arg{1}.`1 = arg{2}.`1 /\
   arg{1}.`2 = arg{2}.`2 /\
   to_uint arg{1}.`3 = to_uint arg{2}.`3 /\
   arg{1}.`4 = arg{2}.`4 /\
   valid_disjoint_ptr (to_uint arg{1}.`1) (to_uint arg{1}.`2) (to_uint arg{1}.`3) (to_uint arg{1}.`3)
   ==>
    ={Glob.mem} /\
   res{1}.`1 = res{2}.`1 /\
   res{1}.`2 = res{2}.`2 /\
   to_uint res{1}.`3 = to_uint res{2}.`3 /\
   valid_disjoint_ptr (to_uint res{1}.`1) (to_uint res{1}.`2) (to_uint res{1}.`3) (to_uint res{1}.`3).
proc. 
seq 3 3 :( #pre /\ ={k0_7,s_k8_15}); 1: by conseq />;sim.
seq 1 1 :( #pre); 1: by conseq />;sim.
seq 1 1 :( #pre).
+ by inline {1} 1; inline {2} 1; conseq />; sim.
seq 1 1 :( #pre /\ ={k8_15}); 1: by conseq />;sim.
seq 1 1 :( #pre); last first .  
+ conseq />; inline *; auto => />.
  move => &1 &2 ?????; rewrite !to_uintB /=; rewrite ?uleE /=; 1,2:smt().
  split; 1: by smt().
  rewrite !to_uintD_small /= /#. 
by conseq />; inline *; sim.
qed.

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
  + seq 1 1 : #pre; 1: by inline *;conseq />;sim.
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
        by call(diagonal_roundx4);call(column_roundx4); auto => />.

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
     by call(diagonal_roundx4);call(column_roundx4); auto => />.

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
  + by call(store_x2); auto => /> /#.
  by call(store_x2_last_corr);   auto => />.
 
(************)


  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre.
  + inline {1} 1; inline {2} 1.  
    wp;conseq />;unroll {1} ^while.
    rcondt {1} 5; 1: by move => &m; auto => />.
    while(={k} /\ to_uint c{1} = 10 - to_uint c{2} /\ 1<=to_uint c{1} <= 10 /\ r16{1} = r160{2} /\ r8{1} = r80{2}).
    + inline {2} 1.
      wp; call(diagonal_round).
      wp; call(column_round).
      auto => /> &1 &2 ???; rewrite /DEC_32 !ultE /rflags_of_aluop_nocf_w /= => ??.
      rewrite  to_uintB; 1: rewrite ?uleE /= /#. 
      by rewrite !to_uintD_small /= /#.
    + inline {2} 5.
      wp; call(diagonal_round).
      wp; call(column_round).
      by auto => />.
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.

  by call(store_x2_last_corr);   auto => />;
     move => &1 &2; rewrite  !ultE /= /#.

(*********)
(*********)
(*********)
(*********)
(*********)
(*********)

inline {1} 1; inline {2} 1; inline {2} 7;  inline {2} 19.
swap {2} [27..28] -26; sp 0 2.
seq 9 28 : (#pre /\ ={k,st} /\ 
            key0 {1} = key2{2} /\
            nonce0{1} = nonce2{2} /\
            counter0{1} = counter1{2} /\
            to_uint len{1} = to_uint len2{2} /\  
            to_uint len0{1} = to_uint len2{2} /\ 
            output0{1} = output2{2} /\ plain0{1} = input2{2} /\ 
            valid_disjoint_ptr (to_uint output0{1}) (to_uint plain0{1}) (to_uint len0{1}) (to_uint len0{1}) /\
            counter{2} = W32.zero /\
            s_r16{1} = r16{2} /\
            s_r8{1} = r8{2}); 1: by
  inline *; auto => /> &1 &2; rewrite !ultE /=; smt(pow2_64).
  seq 1 1 : #pre. 
  + conseq />; inline *.
    do 2!( unroll for {1} ^while).
    do 3!( unroll for {2} ^while). print CHACHA_SIGMA_V_AVX2.
    auto =>  &1 &2; pose xx := CHACHA_SIGMA_V_AVX2; rewrite !ultE => /> *.
    do 13!(congr).
    congr; last first.
    + rewrite /VPBROADCAST_8u32 -iotaredE /= -(unpack32K xx.[3]).
      congr;rewrite /unpack32 /of_list packP => i ib; rewrite !initiE //=. 
      rewrite (of_int_bits32_div_red _ _ ib _) 1:/# /=.
      case (i = 0); 1: by auto. 
      case (i = 1); 1: by auto.
      case (i = 2); 1: by auto.
      case (i = 3); 1: by auto.
      case (i = 4); 1: by auto.
      case (i = 5); 1: by auto.
      case (i = 6); 1: by auto.
      case (i = 7); 1: by auto.
      by smt().
    congr; last first.
    + rewrite /VPBROADCAST_8u32 -iotaredE /= -(unpack32K xx.[2]).
      congr;rewrite /unpack32 /of_list packP => i ib; rewrite !initiE //=. 
      rewrite (of_int_bits32_div_red _ _ ib _) 1:/# /=.
      case (i = 0); 1: by auto. 
      case (i = 1); 1: by auto.
      case (i = 2); 1: by auto.
      case (i = 3); 1: by auto.
      case (i = 4); 1: by auto.
      case (i = 5); 1: by auto.
      case (i = 6); 1: by auto.
      case (i = 7); 1: by auto.
      by smt().
     congr; last first.
    + rewrite /VPBROADCAST_8u32 -iotaredE /= -(unpack32K xx.[1]).
      congr;rewrite /unpack32 /of_list packP => i ib; rewrite !initiE //=. 
      rewrite (of_int_bits32_div_red _ _ ib _) 1:/# /=.
      case (i = 0); 1: by auto. 
      case (i = 1); 1: by auto.
      case (i = 2); 1: by auto.
      case (i = 3); 1: by auto.
      case (i = 4); 1: by auto.
      case (i = 5); 1: by auto.
      case (i = 6); 1: by auto.
      case (i = 7); 1: by auto.
      by smt().
     congr.
    + rewrite /VPBROADCAST_8u32 -iotaredE /= -(unpack32K xx.[0]).
      congr;rewrite /unpack32 /of_list packP => i ib; rewrite !initiE //=. 
      rewrite (of_int_bits32_div_red _ _ ib _) 1:/# /=.
      case (i = 0); 1: by auto. 
      case (i = 1); 1: by auto.
      case (i = 2); 1: by auto.
      case (i = 3); 1: by auto.
      case (i = 4); 1: by auto.
      case (i = 5); 1: by auto.
      case (i = 6); 1: by auto.
      case (i = 7); 1: by auto.
      by smt().
   
seq 1 1 : (#{/~! (len{1} \ult (W32.of_int 257))}
          {~to_uint len{1} = to_uint len{2}}
        {~to_uint len{1} = to_uint len2{2}}pre /\ 
        valid_disjoint_ptr (to_uint output0{1}) (to_uint plain0{1}) (to_uint len0{1}) (to_uint len0{1}) /\
        to_uint len0{1} < 512); last first.
if; 1: by move => &1 &2; rewrite !ultE /= /#.
+ seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre;1 : by  call(rounds_x8); auto => />.
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  call(store_x8_last); auto => /> &1 &2; rewrite ultE /= => ????????. by auto => />.

while(#{/~! (len{1} \ult (W32.of_int 257))}
        {~to_uint len{1} = to_uint len{2}}
        {~to_uint len{1} = to_uint len2{2}}pre).
+ seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #pre;1 : by  call(rounds_x8); auto => />.
  seq 1 1 : #pre; 1: by conseq />; inline *; sim.
  seq 1 1 : #post. 
  +  call(store_x8).
      auto => /> &1 &2 ?????????; rewrite !uleE /= => ??; split; 1: by smt().
     move => ???; rewrite !uleE /= => ??????; split;  smt().
   by conseq />; inline *; sim.
  
  auto => />.
  move => &1 &2; rewrite !uleE !ultE /= =>  ????????????; split; 1: by smt().
   move => ????;rewrite !uleE  /= =>  ??????; smt().
qed.
