require import Extracted_ct.

equiv eq_jade_stream_salsa20_salsa2012_amd64_ref_xor_ct : 
  M.jade_stream_salsa20_salsa2012_amd64_ref_xor ~ M.jade_stream_salsa20_salsa2012_amd64_ref_xor :
    ={output, input, input_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv eq_jade_stream_salsa20_salsa2012_amd64_ref_ct : 
  M.jade_stream_salsa20_salsa2012_amd64_ref ~ M.jade_stream_salsa20_salsa2012_amd64_ref :
    ={stream, stream_length, nonce, key, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
