

a = "⅞  abc"
b = "hello"
require 'pp'
pp a.scan(/./mu)[0]
pp b.scan(/./mu)[0]
pp a.unpack("U*")
