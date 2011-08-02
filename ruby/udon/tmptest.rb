#!/usr/bin/env ruby
require 'rubygems'
require 'udon'

to_parse = <<UDON
  # |This is a comment
    |and this continues it
        |Oh yeah
    #yup
  # A separate comment
UDON


require 'pp'
pp Udon.parse(to_parse)
