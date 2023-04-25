require import AllCore IntDiv CoreMap List Distr StdOrder Ring Poly1305_spec.
from Jasmin require import JModel.

require import Array2 Array3 Array4 Array5.
require import WArray16 WArray24 WArray64 WArray96 WArray128 WArray160.

require import Poly1305_savx2.
require import Extracted_s.

lemma nosmt ltr_weexpn2l (x : int):
   1 < x => forall (m n : int), 0 <= m && m < n => x ^ m < x ^ n.
proof. 
move => Hx m n Hnl.
have := IntOrder.ler_weexpn2l x _ m (n-1) _ => //=;1,2:smt().
have := IntOrder.ler_weexpn2l x _ (n-1) (n) _ => //=;1..2:smt().
by smt(IntOrder.ieexprIn).
qed.

op next_multiple(p : W64.t) = if to_uint p %% 16 = 0 
                              then to_uint p 
                              else (to_uint p %/ 16 + 1) * 16.

(* EQUIVALENCE BETWEEN REG BASED AND MEMORY OUTPUT *)
equiv onetimeauth_s_r_mem_equiv mem outt :
    M.__poly1305_r_avx2 ~ M.__poly1305_avx2 :
    Glob.mem{1} = mem /\ ={Glob.mem} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    good_ptr (to_uint out{2}) 16 /\ out{2} = outt /\
    ={in_0,inlen,k} ==> 
     Glob.mem{1} = mem /\
     Glob.mem{2} = storeW128 mem (W64.to_uint outt)
       (W2u64.pack2 [res{1}.[0];res{1}.[1]]).
proof. 
proc* => //=; inline {2} 1.
sp; seq 1 1 : (={Glob.mem} /\ Glob.mem{1} = mem /\ 
    to_uint out0{2} <= to_uint out{2} + 16 /\ 
     to_uint out0{2} + 16 < 18446744073709551616 /\
    out0{2} = outt /\ r{1} = h2{2}); 1: by conseq />; sim.
inline *; auto => /> &2 ??.
by rewrite store2u64 /= to_uintD_small /=; smt(W64.to_uint_cmp pow2_64).
qed.

(* MAIN PROOF OF EQUIVALENCE TO PREVIOUS VERSION OF POLY FOR MEM BASED *)


equiv update_e :  M.__poly1305_update_ref ~ Poly1305_savx2.M.poly1305_ref3_update : ={Glob.mem,arg} ==> ={res}  by sim.

hoare update_h : M.__poly1305_update_ref :
    good_ptr (to_uint in_0) (next_multiple inlen) ==> 
    to_uint res.`2 < 16 /\ (0< to_uint res.`2 => good_ptr (to_uint res.`1) 16).
proc. 
while (good_ptr (to_uint in_0) (next_multiple inlen)); last by 
  auto => /> &m ?? in_0 inlen; 
  rewrite uleE /next_multiple /=; smt(W64.to_uint_cmp).
inline 2; wp => /=; conseq />.
inline *; auto => />.
auto => /= ???; rewrite uleE /next_multiple /= => ?. 
rewrite to_uintD_small /=; 1:  smt(W64.to_uint_cmp).
rewrite to_uintB /=; 1: by rewrite uleE; smt(W64.to_uint_cmp).
by smt(W64.to_uint_cmp).
qed.

equiv update :  M.__poly1305_update_ref ~ Poly1305_savx2.M.poly1305_ref3_update : 
   good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\ ={Glob.mem,arg} ==> 
   ={res} /\ to_uint res{1}.`2 < 16 /\ 
   (0 < to_uint res{1}.`2 => good_ptr (to_uint res{1}.`1) 16) by conseq update_e update_h.

equiv update_avx2_e :  M.__poly1305_avx2_update ~ Poly1305_savx2.M.poly1305_avx2_update : ={Glob.mem,arg} ==> ={res}.
proc.
wp;call(_: ={Glob.mem}).
+ by  sim; auto => />. 
wp;call(_: ={Glob.mem}).
+ wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}).
  + do 8!(unroll for {1} ^while).
    by auto => />.
  by auto => />.
  wp;conseq (_: _ ==> ={h, m, s_mask26, s_bit25, r1234, r1234x5,in_0,r4444,r4444x5,Glob.mem} /\ inlen{1} = len{2}); 1: by smt().
  while (#post); last first. 
  + inline *. 
    unroll for {1} ^while.
    unroll for {2} ^while.
    by auto => />; rewrite !W4u64.of_uint_pack4 /VPBROADCAST_4u64 -iotaredE /=. 
  wp;conseq (_: _ ==> ={h, m, s_mask26, s_bit25, r1234, r1234x5,in_0} /\ inlen{1} = len{2}); 1: by smt().  
  wp; call(_: ={Glob.mem}); 1: by auto => />.
  by auto => />.
qed.

lemma update_avx2_h : 
  hoare [ M.__poly1305_avx2_update :
    256 <= to_uint inlen /\
    good_ptr (to_uint in_0) (next_multiple inlen) ==> 
    (0< to_uint res.`2 => good_ptr (to_uint res.`1) (next_multiple res.`2))].
proc => /=. 
call(_: true); 1: by auto => />.
call(_: true); 1: by auto => />.
wp; conseq />;1:smt().
while (64 <= to_uint inlen /\ good_ptr (to_uint in_0) (next_multiple (inlen - W64.of_int 64))); last first. 
+ unroll for 5; inline *; auto => /> &hr;rewrite /next_multiple /= => H H0 H1;  do split.
  + smt(). 
  + rewrite to_uintD_small /=; smt(W64.to_uint_cmp).
  rewrite to_uintD_small /=; 1: smt(W64.to_uint_cmp).
  by  rewrite to_uintB /=; 1: rewrite uleE /=; smt(W64.to_uint_cmp uleE).

inline 1; wp; conseq />; auto => />.
rewrite uleE /next_multiple /= => &hr H H0 H1 H2.
move : H0 H1. 
 rewrite !to_uintB /=; 1: by rewrite uleE /=; smt(W64.to_uint_cmp uleE).
  rewrite uleE  !to_uintB /=; 1: by rewrite uleE /=; smt(W64.to_uint_cmp uleE).
  by smt().
 by  rewrite uleE /=; smt(W64.to_uint_cmp).

move => ??; rewrite to_uintD_small /=;smt(W64.to_uint_cmp). 
qed.

lemma update_avx2 : 
 equiv[  M.__poly1305_avx2_update ~ Poly1305_savx2.M.poly1305_avx2_update : 
   256 <= to_uint inlen{1} /\
   good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\ ={Glob.mem,arg} ==> 
   ={res} /\ (0< to_uint res{1}.`2 => good_ptr (to_uint res{1}.`1) (next_multiple res{1}.`2))] by 
  conseq update_avx2_e update_avx2_h  => /#.

equiv load_last :
  M.__load_last_add ~ Poly1305_savx2.M.load_last_add :
  good_ptr  (to_uint in_0{2}) 16 /\
  to_uint len{1} < 16 /\
  ={arg,Glob.mem} ==> ={res,Glob.mem} by sim.

equiv onetimeauth_s_r_equiv :
    M.__poly1305_r_avx2 ~ Poly1305_savx2.M.poly1305_avx2 :
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    ={Glob.mem} /\ ={arg} ==> ={res,Glob.mem}.
proc => /=.
seq 7 1 : #pre; 1: by auto.
if{2}.
rcondf{1} 1.
+ move => &2; auto => />; rewrite ultE uleE => /> /#.
  inline {2} 1. inline {2} 9.
  inline {1} 1. inline {1} 9.
  wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}); 1: by sim.
  conseq />.
  seq 15 15 : (#post /\ ={Glob.mem,in_01,inlen1} /\ r1{1} = r0{2} /\ (0 < to_uint inlen1{2} => good_ptr (to_uint in_01{2}) 16) /\ to_uint inlen1{2} < 16); last first.
  + if; first by auto.
    wp;call(_: ={Glob.mem}); 1: by sim.
    conseq />.
    call load_last;  auto => />; smt(W64.to_uint_cmp).
    by auto => />.
  wp;call update.
  wp;call(_: ={Glob.mem}); 1: by sim.
  by auto => />.  

rcondt{1} 1.
move => &2; auto => />; rewrite ultE uleE => /> /#.
inline {2} 1. inline {2} 15.
inline {1} 5. 
wp;call(_: ={Glob.mem}); 1: by sim.
wp;call(_: ={Glob.mem}); 1: by sim.
wp;call(_: ={Glob.mem}); 1: by sim.
conseq />.
seq 11 21 : (#post /\ ={Glob.mem} /\ inlen0{1} = inlen1{2} /\ in_00{1} = in_01{2} /\ r0{1} = r0{2}  /\ (0<to_uint inlen1{2} => good_ptr (to_uint in_01{2}) 16) /\ to_uint inlen1{2} < 16); last first.
+ if; first by auto.
  wp;call(_: ={Glob.mem}); 1: by sim.
  conseq />. 
    call load_last;  auto => />; smt(W64.to_uint_cmp).
  by auto => />.

wp;call update.
wp;call update_avx2.

wp;call(_: ={Glob.mem}).
+ wp;call(_: ={Glob.mem}); 1: by sim.
  wp;call(_: ={Glob.mem}); 1: by sim.
  do 2!(unroll for {1} ^while).
  do 2!(unroll for {2} ^while).
  inline {1} M.__unpack_avx2.
  conseq />.
  seq 35 31 : (#pre /\ ={rt,r1234,r1234x5,r4444,r4444x5,i}); 1: by auto.
  seq 2 2: #pre. 
  + call(_:true); 1:  by sim. 
    by auto => />.
  seq 24 20 : #pre; 1: by  auto. 
  seq 2 2: #pre. 
  + call(_:true); 1:  by sim. 
    by auto => />.
  seq 24 20 : #pre; 1: by  auto. 
  seq 2 2: #pre. 
  + call(_:true); 1:  by sim. 
    by auto => />.
  by auto => />.

wp; call(_: ={Glob.mem}); 1: by sim.
auto => /> &1??.
rewrite ultE /= => ?; do split; 1: by smt(). 
move => ? rr ?.
case ( 0 < to_uint rr.`2); 1: by smt().
move => *. 
have : (to_uint rr.`2) = 0 by smt(W64.to_uint_cmp).
move => Hrr.
rewrite /next_multiple /= Hrr /=.
by smt(W64.to_uint_cmp pow2_64).
qed.

(* Equivalence to memory based *)

equiv onetimeauth_s_equiv mem outt :
    Poly1305_savx2.M.poly1305_avx2 ~ M.__poly1305_avx2 :
    Glob.mem{1} = mem /\ ={Glob.mem} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    good_ptr (to_uint out{2}) 16 /\ out{2} = outt /\
    ={in_0,inlen,k} ==> 
     Glob.mem{1} = mem /\
     Glob.mem{2} = storeW128 mem (W64.to_uint outt)
       (W2u64.pack2 [res{1}.[0];res{1}.[1]]).
proof. 
transitivity M.__poly1305_r_avx2 
    (={Glob.mem, in_0, inlen, k} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1})
      ==> ={res,Glob.mem})
    (Glob.mem{1} = mem /\ ={Glob.mem} /\ 
    good_ptr (to_uint in_0{1}) (next_multiple inlen{1}) /\
    good_ptr (to_uint out{2}) 16 /\ out{2} = outt /\
    ={in_0,inlen,k} ==> 
     Glob.mem{1} = mem /\
     Glob.mem{2} = storeW128 mem (W64.to_uint outt)
       (W2u64.pack2 [res{1}.[0];res{1}.[1]])).
+ move => /> &1 &2 => *; rewrite /inv_ptr /=. 
  exists mem arg{1} => //=; do split; smt(W64.to_uint_cmp).
+ smt().
+ by symmetry;proc*;call onetimeauth_s_r_equiv; auto => />.
by proc*; call (onetimeauth_s_r_mem_equiv mem outt); auto => />.
qed.
