require "substrate_common/version"
require 'xxhash'
require 'blake2b'
require 'base58'


require 'substrate_common/address'

class Array
  def bytes_to_hex
    raise "Not a byte array" unless self.is_byte_array?
    '0x' + self.map { |b| b.to_s(16).rjust(2, '0') }.join
  end

  def bytes_to_bin
    raise "Not a byte array" unless self.is_byte_array?
    '0b' + self.map { |b| b.to_s(2).rjust(8, '0') }.join
  end

  def bytes_to_bin
    raise "Not a byte array" unless self.is_byte_array?
    self.map { |b| b.to_s(2).rjust(8, '0') }
  end

  def bytes_to_utf8
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

  def hex_to_bytes
    data = self.start_with?('0x') ? self[2..] : self
    raise "Not valid hex string" if data.length % 2 != 0
    data.scan(/../).map(&:hex)
  end
end

module Crypto
  def xxhash_128(data)
    bytes = []
    2.times do |i|
      result = XXhash.xxh64 data, i
      bytes = bytes + result.to_s(16).rjust(16, '0').hex_to_bytes.reverse
    end
    bytes.bytes_to_hex
  end

  def black2_256(data)
    Blake2b.hex data, Blake2b::Key.none, 32
  end
end
