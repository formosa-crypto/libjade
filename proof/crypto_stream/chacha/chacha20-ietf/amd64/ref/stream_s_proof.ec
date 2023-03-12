require import AllCore IntDiv.
require import ChaCha20_sref_proof ChaCha20_sref Stream_s.
from Jasmin require import JModel.

require import Array8 Array16 WArray64.

equiv store_last : ChaCha20_sref.M.store_last ~ M.__store_xor_last_ref :
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

equiv top :  ChaCha20_sref.M.chacha20_ref ~ M.__chacha_xor_ref :
  ={Glob.mem} /\
  arg{1}.`1 = arg{2}.`1 /\
  arg{1}.`2 = arg{2}.`2 /\
  to_uint arg{1}.`3 = to_uint arg{2}.`3 /\
  arg{1}.`4 = arg{2}.`5 /\
  arg{1}.`5 = arg{2}.`4 /\
  arg{1}.`6 = W32.zero
   ==> ={Glob.mem,res}.
proof.
proc => /=; inline {2} 2; inline {2} 14; sp.
seq 2 3 : (to_uint s_len{1} < 64 /\ 
           to_uint s_len{1} = to_uint len1{2} /\ 
           to_uint s_len{1} = to_uint s_len{2} /\ 
           ={Glob.mem,st,k,s_output,counter} /\ 
           s_plain{1} = s_input{2}); last first.
if; 3: by auto.
+ by move => /> &1; rewrite ultE ultE /= /#. 
+ call(store_last). 
  conseq (_: _ ==> ={k, k15}); 1: by smt().
  call(sum_states).
  conseq (_: _ ==> ={k, k15}); 1: by smt().
  call(rounds).
  conseq (_: _ ==> ={k, k15}); 1: by smt().
  by sim.

while(to_uint s_len{1} = to_uint len1{2} /\ 
      to_uint s_len{1} = to_uint s_len{2} /\ 
      ={Glob.mem,st,k,s_output} /\ 
      s_plain{1} = s_input{2}); last first.
+ wp; call(init);auto => />. 
  move => &1 &2; rewrite !uleE !of_uintK /= => ?; split; 1: by smt().
  by move => ??; rewrite !uleE !of_uintK /= /#.

wp;call(increment).
call(sum_store).
call(rounds).
inline *; conseq (_: ={k,k15}); last by sim.
move => &1 &2 />; rewrite !uleE !of_uintK /= => *;split; 1: by smt().
by move => ??????; rewrite !uleE !of_uintK /= /#.
qed.

