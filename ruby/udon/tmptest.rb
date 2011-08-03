#!/usr/bin/env ruby
require 'rubygems'
require 'udon'

to_parse = <<UDON
  <<'
  # |This is a comment
    |and this continues it
      | in two

        |Oh yeah
    #yup
  # A separate comment
      Same offset
    Same offset
   Same offset

  <<'Starting
  <<"
  <hi<`
  <hi<there<"
  <hi<there<again<"
UDON


require 'pp'
pp Udon.parse(to_parse)
