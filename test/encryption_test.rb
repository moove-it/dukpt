require 'test/unit'
require 'dukpt'

class DUKPT::EncryptionTest < Test::Unit::TestCase
  include DUKPT::Encryption
  
  def test_least_signinficant_16_nibbles_mask
    expected = 0x00009876543210E00008
    actual   = 0xFFFF9876543210E00008 & LS16_MASK
    assert_equal expected, actual
  end
  
  def test_register_8_mask
    expected = 0x00009876543210e00000
    actual   = 0xFFFF9876543210E00008 & REG8_MASK
    assert_equal expected, actual
  end
  
  def test_register_3_mask
    expected = 0x1FFFFF
    actual   = 0xFFFFFFFFFFFFFFFFFFFF & REG3_MASK
    assert_equal expected, actual
  end
  
  def test_derive_ipek
    ksn = "FFFF9876543210E00008"
    bdk = "0123456789ABCDEFFEDCBA9876543210"
    ipek = derive_IPEK(bdk, ksn)
    assert_equal '6ac292faa1315b4d858ab3a3d7d5933a', ipek
  end
  
  def test_derive_pek
    ksn = "FFFF9876543210E00008"
    pek = derive_PEK('6ac292faa1315b4d858ab3a3d7d5933a', ksn)
    assert_equal '27f66d5244ff621eaa6f6120edeb427f', pek
  end
  
  def test_triple_des_decrypt
    ciphertext = "C25C1D1197D31CAA87285D59A892047426D9182EC11353C051ADD6D0F072A6CB3436560B3071FC1FD11D9F7E74886742D9BEE0CFD1EA1064C213BB55278B2F12"
    data_decrypted = triple_des_decrypt('27f66d5244ff621eaa6f6120edeb427f', ciphertext)
    assert_equal '2542353435323330303535313232373138395e484f47414e2f5041554c2020202020205e30383034333231303030303030303732353030303030303f00000000', data_decrypted
  end
  
  def test_unpacking_decrypted_data
    data_decrypted = '2542353435323330303535313232373138395e484f47414e2f5041554c2020202020205e30383034333231303030303030303732353030303030303f00000000'
    expected = "%B5452300551227189^HOGAN/PAUL      ^08043210000000725000000?\x00\x00\x00\x00"
    assert_equal expected, [data_decrypted].pack('H*')
  end
    
end