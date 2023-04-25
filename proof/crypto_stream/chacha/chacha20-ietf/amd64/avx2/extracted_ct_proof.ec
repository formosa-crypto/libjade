require import Extracted_ct.

equiv eq_jade_stream_chacha_chacha20_ietf_amd64_avx2_xor_ct : 
  M.jade_stream_chacha_chacha20_ietf_amd64_avx2_xor ~ M.jade_stream_chacha_chacha20_ietf_amd64_avx2_xor :
    ={output, input, input_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_stream_chacha_chacha20_ietf_amd64_avx2_ct : 
  M.jade_stream_chacha_chacha20_ietf_amd64_avx2 ~ M.jade_stream_chacha_chacha20_ietf_amd64_avx2 :
    ={stream, stream_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

(** **)

equiv eq_jade_stream_chacha_chacha20_ietf_amd64_avx2_xor_ic_ct : 
  M.jade_stream_chacha_chacha20_ietf_amd64_avx2_xor_ic ~ M.jade_stream_chacha_chacha20_ietf_amd64_avx2_xor_ic :
    ={output, input, input_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_stream_chacha_chacha20_ietf_amd64_avx2_ic_ct : 
  M.jade_stream_chacha_chacha20_ietf_amd64_avx2_ic ~ M.jade_stream_chacha_chacha20_ietf_amd64_avx2_ic :
    ={stream, stream_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
