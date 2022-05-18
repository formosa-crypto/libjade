require import Crypto_verify_16_ct.

equiv eq___crypto_verify_p_u8x16_r_u64x2_ct : 
  M.__crypto_verify_p_u8x16_r_u64x2 ~ M.__crypto_verify_p_u8x16_r_u64x2 :
    ={_h, h, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

