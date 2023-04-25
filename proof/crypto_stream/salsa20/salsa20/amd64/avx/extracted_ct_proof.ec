require import Extracted_ct.

equiv eq_jade_stream_salsa20_salsa20_amd64_avx_xor_ct : 
  M.jade_stream_salsa20_salsa20_amd64_avx_xor ~ M.jade_stream_salsa20_salsa20_amd64_avx_xor :
    ={output, input, input_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_stream_salsa20_salsa20_amd64_avx_ct : 
  M.jade_stream_salsa20_salsa20_amd64_avx ~ M.jade_stream_salsa20_salsa20_amd64_avx :
    ={stream, stream_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
