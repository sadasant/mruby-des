# Small script to make sure the lib is working with mruby

$LOAD_PATH << "./lib"
require "lib/ruby-des"

def test(name, value, expected)
  raise "#{name} failure, value: #{value} is not: #{expected}" if value != expected
  print "#{name} value is #{expected}\n"
end

# Encrypting
secret = 'mysecret'
data   = RubyDES::Block.new(secret)
key    = RubyDES::Block.new('hushhush')
des    = RubyDES::Ctx.new(data, key)
encrypted_data = des.encrypt

# Decrypting
un_des = RubyDES::Ctx.new(encrypted_data, key)
decrypted_data = un_des.decrypt

# From http://www.tero.co.uk/des/test.php and other sources
expected_hex = "89d829b8fd813404"

test("string", encrypted_data.string.unpack("H*").first, expected_hex)
test("bit_array", encrypted_data.bit_array.join("").to_i(2).to_s(16), expected_hex)
test("data.bit_array eql? decrypted data", data.bit_array.eql?(decrypted_data.bit_array), true)
test("secret", secret, decrypted_data.string)
