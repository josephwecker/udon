require 'udon/version'
require 'udon/udon_children'
require 'strscan'
module Udon
  class Parser < StringScanner
    L_COMMENT                    = /^(\s*)#(.*)$/u
    L_SKIP                       = /^\s*$/u

    TEXT                         = /^(\s*)(.*)$/u


    def initialize(source, opts={})
      opts ||= {}
      if defined?(::Encoding)
        if source.encoding == ::Encoding::ASCII_8BIT
          b = source[0, 4].bytes.to_a
          source = case
                   when b.size >= 4 && b[0] == 0 && b[1] == 0 && b[2] == 0
                     source.dup.force_encoding(::Encoding::UTF_32BE).encode!(::Encoding::UTF_8)
                   when b.size >= 4 && b[0] == 0 && b[2] == 0
                     source.dup.force_encoding(::Encoding::UTF_16BE).encode!(::Encoding::UTF_8)
                   when b.size >= 4 && b[1] == 0 && b[2] == 0 && b[3] == 0
                     source.dup.force_encoding(::Encoding::UTF_32LE).encode!(::Encoding::UTF_8)
                   when b.size >= 4 && b[1] == 0 && b[3] == 0
                     source.dup.force_encoding(::Encoding::UTF_16LE).encode!(::Encoding::UTF_8)
                   else source.dup end
        else source = source.encode(::Encoding::UTF_8) end
        source.force_encoding(::Encoding::ASCII_8BIT)
      else
        b = source
        source = case
                 when b.size >= 4 && b[0] == 0 && b[1] == 0 && b[2] == 0
                   JSON.iconv('utf-8', 'utf-32be', b)
                 when b.size >= 4 && b[0] == 0 && b[2] == 0
                   JSON.iconv('utf-8', 'utf-16be', b)
                 when b.size >= 4 && b[1] == 0 && b[2] == 0 && b[3] == 0
                   JSON.iconv('utf-8', 'utf-32le', b)
                 when b.size >= 4 && b[1] == 0 && b[3] == 0
                   JSON.iconv('utf-8', 'utf-16le', b)
                 else b end
      end
      super source
    end

    def current_indent
      self[1].size
    end

    def parse
      reset
      @res = []
      until eos?
        case
        when scan(L_COMMENT)
          comment = parse_comment(current_indent, self[2])
          puts "COMMENT! >>\n------\n#{comment}\n------"
        when skip(L_SKIP)
          puts "(skip)"
        else
          puts "huh?"
          raise peek(20)
        end
      end
    end

    private

    def parse_comment(indent, comment)
      while scan(/^(\s{#{indent+2},#{indent+900}}.*)$/)
        comment += "\n"+self[1][indent+2..-1]
      end
      return comment
    end

  end

  module_function

  def parse(source, opts={})
    Parser.new(source,opts).parse
  end
end
