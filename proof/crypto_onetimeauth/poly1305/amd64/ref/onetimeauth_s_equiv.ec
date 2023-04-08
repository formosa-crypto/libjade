require import AllCore IntDiv CoreMap List Distr StdOrder Ring Poly1305_spec.
from Jasmin require import JModel.

require import Array2 Array3 Array4 Array5.
require import WArray16 WArray24 WArray64 WArray96 WArray128 WArray160.

require import Poly1305_spec Poly1305_savx2 Rep3Limb W64limbs Zp.
require import Onetimeauth_s.

import Zp.

module Mrep3_ref = {
  proc clamp = Onetimeauth_s.M.__clamp
  proc load_add = Onetimeauth_s.M.__load_add
  proc load_last_add = Onetimeauth_s.M.__load_last_add
  proc mulmod = Onetimeauth_s.M.__mulmod
  proc freeze = Onetimeauth_s.M.__freeze
  proc load2 = Onetimeauth_s.M.__load2
  proc store2 = Onetimeauth_s.M.__store2
  proc add2 = Onetimeauth_s.M.__add2
  proc setup = Onetimeauth_s.M.__poly1305_setup_ref
  proc update = Onetimeauth_s.M.__poly1305_update_ref
  proc finish = Onetimeauth_s.M.__poly1305_last_ref
}.

equiv clamp_e : Mrep3_ref.clamp ~ Mrep3.clamp : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv load_add_e : Mrep3_ref.load_add ~ Mrep3.load_add : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv load_last_add_e : Mrep3_ref.load_last_add ~ Mrep3.load_last_add : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv mulmod_e : Mrep3_ref.mulmod ~ Mrep3.mulmod : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv freeze_e : Mrep3_ref.freeze ~ Mrep3.freeze : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv load2_e : Mrep3_ref.load2 ~ Mrep3.load2 : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv store2_e : Mrep3_ref.store2 ~ Mrep3.store2 : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv add2_e : Mrep3_ref.add2 ~ Mrep3.add2 : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv setup_e : Mrep3_ref.setup ~ Mrep3.setup : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv update_e : Mrep3_ref.update ~ Mrep3.update : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.
equiv finish_e : Mrep3_ref.finish ~ Mrep3.finish : ={arg, Glob.mem} ==> ={res, Glob.mem} by sim.

lemma clamp_spec_ref_h mem kk:
 hoare [ Mrep3_ref.clamp:
           Glob.mem = mem /\ kk = k /\  good_ptr (to_uint kk) 16
          ==>
           Rep3r_ok res /\ repres3r res = load_clamp mem kk ].
bypr => &m [#] ????.
rewrite Pr[mu_not].
have -> : Pr[Mrep3_ref.clamp(arg{m}) @ &m : true] = 1%r
  by byphoare => //; islossless.
have -> : Pr[Mrep3_ref.clamp(arg{m}) @ &m : Rep3r_ok res /\ repres3r res = load_clamp mem kk] = 1%r; last by done.
byphoare (_: 
    Glob.mem = mem /\ kk = k /\  good_ptr (to_uint kk) 16
          ==>
           Rep3r_ok res /\ repres3r res = load_clamp mem kk
  ) => //; by 
   conseq clamp_e  (clamp_spec mem kk) => // /#.
qed.

lemma load_add_spec_ref_h mem hh inp:
 hoare [ Mrep3_ref.load_add:
           Glob.mem = mem /\ hh = h /\ inp = in_0 /\ ubW64 4 hh.[2] /\ good_ptr (to_uint inp) 16
          ==>
           ubW64 6 res.[2] /\
           repres3 res = repres3 hh + (load_block mem inp) ].
bypr => &m [#] ??????.
rewrite Pr[mu_not].
have -> : Pr[Mrep3_ref.load_add(h{m},in_0{m}) @ &m : true] = 1%r
  by byphoare => //; islossless.
have -> : Pr[Mrep3_ref.load_add(h{m}, in_0{m}) @ &m : ubW64 6 res.[2] /\ repres3 res = repres3 hh + load_block mem inp] = 1%r; last by done.
byphoare (_: 
    Glob.mem = mem /\ hh = h /\ inp = in_0 /\ ubW64 4 hh.[2] /\ good_ptr (to_uint inp) 16
          ==>
           ubW64 6 res.[2] /\
           repres3 res = repres3 hh + (load_block mem inp) 
  ) => //; by 
   conseq load_add_e  (load_add_spec mem hh inp) => // /#.
qed.


lemma load_last_add_spec_ref_h mem hh inp inlen:
 hoare [ Mrep3_ref.load_last_add:
           Glob.mem = mem /\ h = hh /\ in_0 = inp /\ len = inlen /\ ubW64 4 hh.[2] /\
           to_uint inlen < 16 /\ good_ptr (to_uint in_0) (to_uint inlen)
          ==>
           ubW64 6 res.[2] /\
           repres3 res = repres3 hh + (load_lblock mem inlen inp) ] by
  conseq load_last_add_e (load_last_add_spec_h mem hh inp inlen) => // /#.


lemma mulmod_spec_ref_h (hh: W64.t Array3.t) rr :
  hoare [ Mrep3_ref.mulmod: 
             ubW64 6 hh.[2] /\ Rep3r_ok rr /\
             hh = h /\ rr = r  
             ==>
             ubW64 4 res.[2] /\
             repres3 res = (repres3 hh * repres3r rr) ] by
  conseq mulmod_e (mulmod_spec_h hh rr) => // /#.


lemma freeze_spec_ref_h hh:
  hoare [ Mrep3_ref.freeze :
            hh = h /\ ubW64 4 h.[2]
          ==>
            valRep2 res = (asint (repres3 hh)) %% 2^128 ]  by
  conseq freeze_e (freeze_spec_h hh) => // /#.

lemma load2_spec_ref_h mem kk:
 hoare [ Mrep3_ref.load2:
           Glob.mem = mem /\ kk = p /\ good_ptr (to_uint kk) 16
          ==>
           valRep2 res = W128.to_uint (loadW128 mem (to_uint kk)) ].
bypr => &m [#] ????.
rewrite Pr[mu_not].
have -> : Pr[Mrep3_ref.load2(arg{m}) @ &m : true] = 1%r
  by byphoare => //; islossless.
have -> : Pr[Mrep3_ref.load2(arg{m}) @ &m : valRep2 res = to_uint (loadW128 mem (to_uint kk))] = 1%r; last by done.
byphoare (_: 
   Glob.mem = mem /\ kk = p /\ good_ptr (to_uint kk) 16
          ==>
           valRep2 res = W128.to_uint (loadW128 mem (to_uint kk))
  ) => //; by 
   conseq load2_e  (load2_spec mem kk) => // /#.
qed.

lemma store2_ref_ll : islossless Mrep3_ref.store2 by islossless.

lemma store2_spec_ref_h mem pp xx:
 hoare [ Mrep3_ref.store2:
           Glob.mem = mem /\ pp = p /\ xx = x /\ good_ptr (to_uint pp) 16
          ==>
           Glob.mem = storeW128 mem (to_uint pp) (W128.of_int (valRep2 xx))].
bypr => &m [#] ?????.
rewrite Pr[mu_not].
have -> : Pr[Mrep3_ref.store2(p{m}, x{m}) @ &m : true] = 1%r
  by byphoare => //; islossless.
have -> : Pr[Mrep3_ref.store2(p{m}, x{m}) @ &m : Glob.mem = storeW128 mem (to_uint pp) ((of_int (valRep2 xx)))%W128] = 1%r; last by done.
byphoare (_: 
  Glob.mem = mem /\ pp = p /\ xx = x /\ good_ptr (to_uint pp) 16
          ==>
           Glob.mem = storeW128 mem (to_uint pp) (W128.of_int (valRep2 xx))
  ) => //; by 
   conseq store2_e  (store2_spec mem pp xx) => // /#.
qed.

lemma add2_spec_ref_h (hh ss: W64.t Array2.t):
 hoare [ Mrep3_ref.add2 : 
             hh = h /\ ss = s  
          ==>
             valRep2 res = (valRep2 hh + valRep2 ss)%%2^128 ].
bypr => &m [#] ??.
rewrite Pr[mu_not].
have -> : Pr[Mrep3_ref.add2(h{m}, s{m}) @ &m : true] = 1%r
  by byphoare => //; islossless.
have -> : Pr[Mrep3_ref.add2(h{m}, s{m}) @ &m : valRep2 res = (valRep2 hh + valRep2 ss) %% W128.modulus] = 1%r; last by done.
byphoare (_: 
  hh = h /\ ss = s  
          ==>
  valRep2 res = (valRep2 hh + valRep2 ss)%%2^128 ) => //; by 
   conseq add2_e  (add2_spec hh ss) => // /#.
qed.

op next_multiple(p : W64.t) = if to_uint p %% 16 = 0 
                              then to_uint p 
                              else (to_uint p %/ 16 + 1) * 16.

op inv_ptr_mem (k in_0 out len : int) : bool = good_ptr k 32 /\ 
                                                     good_ptr in_0 len /\ 
                                                     good_ptr out 16.
op poly1305_post_mem (r : Zp.zp) (s : int) (m : Zp_msg) (outt : int) (memO memN : global_mem_t) :
  bool = memN = storeW128 memO outt (W128.of_int (poly1305_ref r s m)).


lemma jade_onetimeauth_poly1305_amd64_ref mem rr ss mm outt inn inl kk :
  hoare [ Onetimeauth_s.M.jade_onetimeauth_poly1305_amd64_ref : 
           Glob.mem = mem /\
           mac = outt /\ input = inn /\ input_length = inl /\ key = kk /\
           inv_ptr_mem (to_uint kk) (to_uint inn) (to_uint outt) (to_uint inl) /\
           poly1305_pre rr ss mm mem inn inl kk ==> 
           poly1305_post_mem rr ss mm (to_uint outt) mem Glob.mem /\ res = W64.zero].
proc => /=. 
inline 5. inline 10. inline 18. inline 17. inline 16.
seq 37 : (#pre /\ k1 = kk + W64.of_int 16  /\ out = outt /\ ubW64 4 h0.[2] /\ let n = size mm in repres3  h0 = poly1305_loop rr mm n); last first.
+ wp; ecall (store2_spec_ref_h Glob.mem out h2).
  wp; ecall (add2_spec_ref_h h21 s).
  wp; ecall (load2_spec_ref_h Glob.mem k1).
  wp; ecall (freeze_spec_ref_h h0).
  rewrite /poly1305_pre_mem /poly1305_post_mem /poly1305_ref /load_clamp /set0_64_; auto => /> &hr ????????bh <- r1 ->; do split; 1, 3:  smt(W64.to_uint_cmp). 
  by rewrite !to_uintD_small; smt(W64.to_uint_cmp). 

sp 8; conseq />.

rewrite /poly1305_loop /poly1305_pre. 
seq 28 : (#pre /\ k1 = kk + W64.of_int 16 /\ to_uint in_01 = to_uint inn + to_uint inl %/ 16 * 16  /\ to_uint inlen1 = to_uint inl - to_uint inl %/ 16 * 16 /\ ubW64 4 h0.[2] /\ Rep3r_ok r1 /\ repres3r r1{hr} = load_clamp mem kk /\ let n =  to_uint inl %/ 16 in repres3  h0 = poly1305_loop rr mm n); last first.
if; last by auto => /> &hr ????????????; rewrite ultE /= => ?; smt( divz_eq W64.to_uint_cmp pow2_64).

print mulmod_spec_ref_h.
ecall(mulmod_spec_ref_h h0 r1).
ecall(load_last_add_spec_ref_h Glob.mem h0 in_01 inlen1).
auto => /> &hr ?????? sz mmv????????r1v r3old;  rewrite !ultE /= => ?; split; 1: by smt(W64.to_uint_cmp).
move => ??? rr1 ? rr1val rr2 ? rr2val. 
have -> : (size mm = to_uint inl %/ 16 + 1) by smt( divz_eq W64.to_uint_cmp pow2_64).
rewrite rr2val rr1val.
rewrite /poly1305_loop in r3old.
rewrite iotaSr /= 1:/# foldl_rcons /= -r3old r1v mmv; congr; congr.
rewrite /load_lblock /=.
rewrite (onth_nth witness); 1: by smt(size_mkseq).
rewrite oget_some nth_mkseq /= 1:/# ifF; 1: by smt( divz_eq W64.to_uint_cmp pow2_64).

have -> : W64.to_uint (inl - (W64.of_int (to_uint inl %/ 16 * 16)))= to_uint inlen1{hr}.
+ rewrite to_uintB /=; 1:  rewrite uleE /=; smt(@W64 pow2_64).
congr;congr;congr;congr;congr;rewrite fun_ext => x.
have -> : W64.to_uint (inn + (W64.of_int (to_uint inl %/ 16 * 16)))= to_uint in_01{hr}; last by done.
by  rewrite to_uintD_small /=;  smt(@W64 pow2_64).

wp;conseq />.

seq 19 : 
 (#pre /\ 
 good_ptr (to_uint in_02) (to_uint inlen2) /\
 k0 = key + (of_int 16)%W64 /\
  to_uint in_02 = to_uint input /\
  to_uint inlen2 = to_uint input_length  /\
  ubW64 4 h1.[2] /\ r2 = r0 /\
  (ubW64 1152921504606846975 r2.[0] /\
   (ubW64 1152921504606846975 r2.[0] =>
    ubW64 1152921504606846972 r2.[1] /\
    (ubW64 1152921504606846972 r2.[1] =>
     4 %| to_uint r2.[1] /\
     (4 %| to_uint r2.[1] =>
      to_uint r2.[2] = 5 * (to_uint r2.[1] %/ 4) /\
      (to_uint r2.[2] = 5 * (to_uint r2.[1] %/ 4) => ubW64 1441151880758558715 r2.[2]))))) /\
  repres3r r2 = load_clamp Glob.mem key /\
  repres3 h1 = poly1305_loop (load_clamp Glob.mem key) mm 0).
+ unroll for ^while; wp; ecall (clamp_spec_ref_h Glob.mem k2).
  auto => /> ????????; split;1:smt().
  by move => ?? rr1 ??????; rewrite repres3E valRep3E /=.

conseq />.

while (
  Glob.mem = mem /\
  to_uint input = to_uint inn /\
  to_uint input_length = to_uint inl /\
  size mm = (if to_uint input_length %% 16 = 0 then to_uint input_length %/ 16 else to_uint input_length %/ 16 + 1) /\
  mm =
  mkseq
    (fun (i0 : int) =>
       let offset = (of_int (i0 * 16))%W64 in
       (if i0 < size mm - 1 then load_block mem (inn + offset) else load_lblock mem (inl - offset) (inn + offset)))
    (size mm) /\
  repres3r r2 = load_clamp Glob.mem key /\
  (ubW64 1152921504606846975 r2.[0] /\
   (ubW64 1152921504606846975 r2.[0] =>
    ubW64 1152921504606846972 r2.[1] /\
    (ubW64 1152921504606846972 r2.[1] =>
     4 %| to_uint r2.[1] /\
     (4 %| to_uint r2.[1] =>
      to_uint r2.[2] = 5 * (to_uint r2.[1] %/ 4) /\
      (to_uint r2.[2] = 5 * (to_uint r2.[1] %/ 4) => ubW64 1441151880758558715 r2.[2]))))) /\
  good_ptr (to_uint inn) (to_uint inl) /\
  good_ptr (to_uint in_02) (to_uint inlen2) /\
  (to_uint input_length - to_uint inlen2) %% 16 = 0 /\
  to_uint input_length %% 16 <= to_uint inlen2 <= to_uint input_length /\
  let _i = (to_uint input_length - to_uint inlen2) %/ 16 in
  to_uint in_02 = to_uint input + _i * 16 /\
  to_uint inlen2 = to_uint input_length - _i * 16 /\
  ubW64 4 h1.[2] /\ repres3 h1 = poly1305_loop (load_clamp Glob.mem key) mm (_i)
).
wp;ecall(mulmod_spec_ref_h h1 r2).
ecall(load_add_spec_ref_h Glob.mem h1 in_02).
auto => /> &hr ? mms mmv r2v????????????????rrov;rewrite uleE /= => ?; do split; 1,2: smt().
move => ?? rr1 ? rr1v ?????rr0 ? rr0val;do split. 
+ rewrite to_uintB /=; 1: rewrite uleE /=; smt(W64.to_uint_cmp pow2_64).
  rewrite to_uintB /=.  rewrite uleE /=; smt(W64.to_uint_cmp pow2_64).
  rewrite !to_uintD_small /=;  smt(W64.to_uint_cmp pow2_64).
+ rewrite to_uintB /=; rewrite ?uleE /=; smt(W64.to_uint_cmp pow2_64).
+ rewrite to_uintB /=; rewrite ?uleE /=; smt(W64.to_uint_cmp pow2_64).
+ rewrite to_uintB /=; rewrite ?uleE /=; smt(W64.to_uint_cmp pow2_64).
+ rewrite to_uintB /=.  rewrite uleE /=; smt(W64.to_uint_cmp pow2_64).
  rewrite !to_uintD_small /=;  smt(W64.to_uint_cmp pow2_64).
+ rewrite to_uintB /=.  rewrite uleE /=; smt(W64.to_uint_cmp pow2_64).
  smt(W64.to_uint_cmp pow2_64).

rewrite rr0val rr1v rrov r2v.
have -> : ((to_uint input_length{hr} - to_uint (inlen2{hr} - (of_int 16)%W64)) %/ 16) =
          ((((to_uint input_length{hr} - to_uint inlen2{hr}) %/ 16)) + 1). 
+ rewrite to_uintB /=;  rewrite ?uleE /= /#.

rewrite /poly1305_loop mmv. 
rewrite iotaSr /=; 1: by smt(W64.to_uint_cmp pow2_64).
 rewrite foldl_rcons /=. congr. congr. 
rewrite (onth_nth witness). 
+ rewrite size_mkseq /max /=; 1:   by smt(W64.to_uint_cmp pow2_64).
rewrite oget_some  nth_mkseq /=; 1:   by smt(W64.to_uint_cmp pow2_64).
rewrite /load_block /load_lblock /=.
pose ms := (if to_uint input_length{hr} %% 16 = 0 then to_uint input_length{hr} %/ 16 else to_uint input_length{hr} %/ 16 + 1).

case ((to_uint input_length{hr} - to_uint inlen2{hr}) %/ 16 < ms - 1).
+ move => *.
  congr;congr;congr;congr;congr;rewrite fun_ext => x.
  rewrite to_uintD_small /= of_uintK /= !modz_small ;by smt(W64.to_uint_cmp pow2_64).

+ move => *.
  congr;congr. rewrite -to_uint_eq. congr. congr. rewrite fun_ext => x.
  rewrite to_uintB /=.  rewrite uleE /=  of_uintK /=. smt(W64.to_uint_cmp pow2_64).
  rewrite !to_uintD_small /= of_uintK /=. smt(W64.to_uint_cmp pow2_64). 
  smt(W64.to_uint_cmp pow2_64).
  have -> :  to_uint (inl - (of_int ((to_uint input_length{hr} - to_uint inlen2{hr}) %/ 16 * 16))%W64) = 16; last by auto.
  rewrite to_uintB /=.  rewrite uleE /=  of_uintK /=. smt(W64.to_uint_cmp pow2_64).
  rewrite of_uintK /=. smt(W64.to_uint_cmp pow2_64). 


auto => /> &hr ????????????????????;do  split; 1..2:smt(). 
+ by smt(W64.to_uint_cmp pow2_64).
+ by have ->  /=: ((to_uint inl - to_uint inlen2{hr}) %/ 16) = 0 by smt().
+ by smt(W64.to_uint_cmp pow2_64).
+ by have ->  /=: ((to_uint inl - to_uint inlen2{hr}) %/ 16) = 0 by smt().

move => h10 in020 inlen20; rewrite uleE /= => ????????;smt().

qed.
