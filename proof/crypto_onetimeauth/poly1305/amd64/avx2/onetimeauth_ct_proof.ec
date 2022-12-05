require import Onetimeauth_ct.

equiv eq_jade_onetimeauth_poly1305_amd64_avx2_ct : 
  M.jade_onetimeauth_poly1305_amd64_avx2 ~ M.jade_onetimeauth_poly1305_amd64_avx2 :
    ={mac, input, input_length, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_onetimeauth_poly1305_amd64_avx2_verify_ct : 
  M.jade_onetimeauth_poly1305_amd64_avx2_verify ~ M.jade_onetimeauth_poly1305_amd64_avx2_verify :
    ={mac, input, input_length, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
