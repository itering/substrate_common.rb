require "substrate_common/version"
require 'xxhash'
require 'blake2b'
require 'base58'


require 'substrate_common/address'

class Array
  def to_hex_string
    raise "Not a byte array" unless self.is_byte_array?
    '0x' + self.map { |b| b.to_s(16).rjust(2, '0') }.join
  end

  def to_bin_string
    raise "Not a byte array" unless self.is_byte_array?
    '0b' + self.map { |b| b.to_s(2).rjust(8, '0') }.join
  end

  def to_hex_array
    raise "Not a byte array" unless self.is_byte_array?
    self.map { |b| b.to_s(16).rjust(2, '0') }
  end

  def to_bin_array
    raise "Not a byte array" unless self.is_byte_array?
    self.map { |b| b.to_s(2).rjust(8, '0') }
  end

  def to_utf8
    raise "Not a byte array" unless self.is_byte_array?
    self.pack('C*').force_encoding('utf-8')
  end

  def is_byte_array?
    self.all? {|e| e >= 0 and e <= 255 }
  end
end

class String
  def constantize
    Object.const_get(self)
  end

  def to_byte_array
    data = self.start_with?('0x') ? self[2..] : self
    raise "Not valid hex string" if data.length % 2 != 0
    data.scan(/../).map(&:hex)
  end
end

def xxhash128(data)
  bytes = []
  2.times do |i|
    result = XXhash.xxh64 data, i
    bytes = bytes + result.to_s(16).rjust(16, '0').to_byte_array.reverse
  end
  bytes.to_hex_string
end

# https://github.com/paritytech/substrate/wiki/External-Address-Format-(SS58)
# base58encode ( concat ( <address-type>, <address>, <checksum> ) )
def ss58_encode(address, address_type=42)
  address_bytes = address.to_byte_array
  checksum_length = address_bytes.length == 32 ? 2 : 1
  input = [address_type] + address_bytes
  checksum = sshash(input)
  content = input + checksum[0...checksum_length]
  Base58.encode(content.to_hex_string.to_i(16), :bitcoin)
end

def sshash(input)
  checksum_prefix = 'SS58PRE'.unpack('C*')
  data = checksum_prefix + input
  Blake2b.bytes(input.to_utf8, Blake2b::Key.none, 64)
end
