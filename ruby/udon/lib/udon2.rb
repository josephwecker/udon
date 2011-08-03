require 'udon/version'
require 'udon/udon_children'
require 'strscan'
require 'pp'
module Udon
  class Parser2 < StringScanner
    def init(source,opts={})
      opts ||= {}
      super ensure_encoding(source)
      @children = []
    end

    def parse
      reset
      @base_indent = 100
      @parent_indent = -1
      state_toplevel
      'nyi'
    end

    private


    def state_toplevel
      advance_to_start

    end













    def ensure_encoding(source)
      if defined?(::Encoding)
        if source.encoding == ::Encoding::ASCII_8BIT
          b = source[0, 4].bytes.to_a
          source =
            case
            when b.size>=4 && b[0]==0 && b[1]==0 && b[2]==0; source.dup.force_encoding(::Encoding::UTF_32BE).encode!(::Encoding::UTF_8)
            when b.size>=4 && b[0]==0 && b[2]==0; source.dup.force_encoding(::Encoding::UTF_16BE).encode!(::Encoding::UTF_8)
            when b.size>=4 && b[1]==0 && b[2]==0 && b[3]==0; source.dup.force_encoding(::Encoding::UTF_32LE).encode!(::Encoding::UTF_8)
            when b.size>=4 && b[1]==0 && b[3]==0; source.dup.force_encoding(::Encoding::UTF_16LE).encode!(::Encoding::UTF_8)
            else source.dup end
        else source = source.encode(::Encoding::UTF_8) end
        source.force_encoding(::Encoding::ASCII_8BIT)
      else
        b = source
        source =
          case
          when b.size >= 4 && b[0] == 0 && b[1] == 0 && b[2] == 0; JSON.iconv('utf-8', 'utf-32be', b)
          when b.size >= 4 && b[0] == 0 && b[2] == 0; JSON.iconv('utf-8', 'utf-16be', b)
          when b.size >= 4 && b[1] == 0 && b[2] == 0 && b[3] == 0; JSON.iconv('utf-8', 'utf-32le', b)
          when b.size >= 4 && b[1] == 0 && b[3] == 0; JSON.iconv('utf-8', 'utf-16le', b)
          else b end
      end
      return source
    end
  end
end
