require 'helper'

describe Address do
  
  # pubkey = '0x30599dba50b5f3ba0b36f856a761eb3c0aee61e830d4beb448ef94b6ad92be39'
  # encoded = 'DfiSM1qqP11ECaekbA64L2ENcsWEpGk8df8wf1LAfV2sBd4'
  # assert_equal Address.encode(pubkey), encoded

  describe "encode" do
    it "encodes an publickey to an address" do
      pubkey = '0xd43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d'
      encoded = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY'
      assert_equal Address.encode(pubkey), encoded
    end

    it "can encode publickey with other prefix" do
      pubkey = '0xd43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d'
      re_encoded = '7sL6eNJj5ZGV5cn3hhV2deRUsivXfBfMH76wCALCqWj1EKzv'
      assert_equal Address.encode(pubkey, 68), re_encoded
    end

    it "can encode publickey with polkadot live address" do
      pubkey = '0x30599dba50b5f3ba0b36f856a761eb3c0aee61e830d4beb448ef94b6ad92be39'
      encoded = 'DfiSM1qqP11ECaekbA64L2ENcsWEpGk8df8wf1LAfV2sBd4'
      assert_equal Address.encode(pubkey, 2), encoded
    end

    it "can encode a 2-byte address" do
      input = Address.array_to_hex_string([0, 1])
      assert_equal Address.encode(input, 68), '2jpAFn'
    end
  end

  describe "#decode" do
    it "should decode an address" do
      address = '5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY'
      pubkey = 'd43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d'
      assert_equal Address.decode(address), pubkey
    end

    it "raise error if decode invalid address_type" do
      address = "DfiSM1qqP11ECaekbA64L2ENcsWEpGk8df8wf1LAfV2sBd4"
      begin
        Address.decode(address, 42)
      rescue Exeption => e
        assert e.message =~ /invalid address type/
      end
    end
  end

end