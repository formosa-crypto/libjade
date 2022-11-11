require import Stream_ct.

equiv eq_jade_stream_chacha_chacha20_amd64_ref_xor_ct : 
  M.jade_stream_chacha_chacha20_amd64_ref_xor ~ M.jade_stream_chacha_chacha20_amd64_ref_xor :
    ={output, input, len, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_stream_chacha_chacha20_amd64_ref_ct : 
  M.jade_stream_chacha_chacha20_amd64_ref ~ M.jade_stream_chacha_chacha20_amd64_ref :
    ={output, len, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
