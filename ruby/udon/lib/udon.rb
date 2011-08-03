require 'udon/version'
require 'udon/udon_children'
require 'strscan'
module Udon
  class Parser < StringScanner
    L_SKIP        = /\s+$/u
    L_COMMENT     = /(\s*)#(.*)$/u
    L_FENCE       = /(\s*)(<(?:[^ <\t]*<)+)(['"`]?)/u


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
      self[1].count(" \t")
    end

    def parse
      reset
      @res = []
      until eos?
        case
        when skip(L_SKIP)
          ;
        when scan(L_COMMENT)
          comment = parse_comment(current_indent, self[2])
          @res.push Udon::Children::Comment.new(comment)
        when scan(L_FENCE)
          require 'pp'
          (0..10).each do |i|
            break if self[i].nil?
            print "#{i}: "
            pp self[i]
          end
          puts ""
          fence = parse_fence(current_indent, self[3], self[2])
        else
          raise "Huh?? #{peek(20).inspect}"
        end
      end
      @res
    end

    private

    def parse_comment(indent, comment)
      while true
        case
        when scan(L_SKIP)
          comment += self[0]
        when scan(/(?:^|\n|\r\n)( {#{indent+1},#{indent+900}}.*)$/)
          comment += "\n"+self[1][indent+1..-1]
        else
          break
        end
      end
      return comment
    end

    def parse_fence(indent, type, identity)
      
    end

  end

  module_function

  def parse(source, opts={})
    Parser.new(source,opts).parse
  end
end
