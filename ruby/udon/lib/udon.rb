require 'udon/version'
require 'udon/udon_children'
require 'udon2'
require 'strscan'
module Udon
  class Parser < StringScanner
    NL            = '(?:\n|\r\n|\r|^)'
    NOTHING       = /(?!)/

    L_SKIP        = /\s+$/u                             # Blank lines
    L_COMMENT     = /(\s*)#\s*(.*)$/u                      # Hash to end of line + indented lines after
    L_FENCE       = /(\s*)(<(?:[^ <\t]*<)+)(['"`]?)(.*)$/u   # >> , >f1>f2...>"

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
          @res.push parse_comment(current_indent, self[2])
        when scan(L_FENCE)
          #require 'pp'
          #(0..10).each do |i|
          #  break if self[i].nil?
          #  print "#{i}: "
          #  pp self[i]
          #end
          #puts ""
          #fence = parse_fence(current_indent, self[3], self[2], self[4])
        else
          raise "Huh?? #{peek(20).inspect}"
        end
      end
      @res
    end

    private

    def parse_comment(parent_indent, first)
      res = []
      res.push(first) if !first.nil? && first != ''
      base_indent = parent_indent + 100
      while true
        case
        when scan(L_SKIP)
          res.push self[0].gsub(/\n/,'')
        when scan(/#{NL}( {#{parent_indent+1},#{base_indent}})(.*)$/)
          base_indent = current_indent if current_indent < base_indent
          res.push(self[2])
        else
          break
        end
      end
      Udon::Children::Comment.new(res)
    end

    def parse_raw_block(indent, res='')
      while true
        case
        when scan(L_SKIP)
          res += self[0]
        when scan(/#{NL}( {#{indent+1}}.*)$/u)
          res += "\n"+self[1][indent+1..-1]
        else
          break
        end
      end
      return res
    end

    def parse_fence(indent, type, identity, text)
      text.lstrip!
      case type
      when '"','',nil
        parse_block_text(indent, text, EMB_ALL, ESC_ALL, MC_ALL)
      when "'"
        parse_block_text(indent, text, EMB_ALL, NOTHING, NOTHING)
      when "`"
        parse_block_text(indent, text, NOTHING, NOTHING, NOTHING)
        #parse_raw_block(indent, text)
      end
    end

    def parse_block_text(indent, res, embeds, escapes, metachars)
      while true
        case
        when scan(L_SKIP)
          res += self[0]
        #when scan(/#{NL}( {#{indent+1}}
        # Try to get to the end of the line
        # Get all text up until something that blocked getting to the end of
        # the line
        #when scan(
        end
      end
    end
  end

  module_function

  def parse(source, opts={})
    Parser.new(source,opts).parse
  end

  def parse2(source, opts={})
    Parser2.new(source,opts).parse
  end
end
