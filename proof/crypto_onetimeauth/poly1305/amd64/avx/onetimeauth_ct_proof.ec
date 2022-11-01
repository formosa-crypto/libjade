require import Onetimeauth_ct.

equiv eq_jade_onetimeauth_poly1305_amd64_avx_ct : 
  M.jade_onetimeauth_poly1305_amd64_avx ~ M.jade_onetimeauth_poly1305_amd64_avx :
    ={_out, _in, _inlen, _key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_onetimeauth_poly1305_amd64_avx_verify_ct : 
  M.jade_onetimeauth_poly1305_amd64_avx_verify ~ M.jade_onetimeauth_poly1305_amd64_avx_verify :
    ={_h, _in, _inlen, _key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
