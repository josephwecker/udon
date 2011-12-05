require 'strscan'

module Denote

  module Pure
    class Parser < StringScanner
      COMMENT      = /\s*#[^\n\r]*[\n\r]/
      MLCOMMENT_ST = /\s*#

      BLOCKS = {
        # Name           start     | end      | esc-self | contains | ignore-d | capture
        :comment     => ['#',        "\n",      false,     [],        true,      false           ],
        :mlcomment   => ['|#',       "#|",      true,      ['|#'],    true,      false           ],
        :nopcomment  => ['|---',     "\n",      false,     [],        true,      false           ],
        :nopcomment2 => ['|===',     "\n",      false,     [],        true,      false           ],
        
        :directive   => ['!',        "\n",      false,     [],        false,     true            ],
        :special     => [':',        :blk,      false,     [],        false,     :parse_special  ],
        
        :imp_tag     => ['[',        :blk,      false,     [],        false,     :parse_implied  ],
        :mlstring    => ["|'",       "'|",      true,      [],        false,     true            ],
        :mlrawstring => ["|`",       "`|",      false,     [],        false,     true            ],
        :

      WS1 = ' '
      WS2 = "\t"
      INLINE_COMMENT = '#'

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
                     else
                       source.dup
                     end
          else
            source = source.encode(::Encoding::UTF_8)
          end
          source.force_encoding(::Encoding::ASCII_8BIT)
        else
          require 'iconv'
          b = source
          source = case
                   when b.size >= 4 && b[0] == 0 && b[1] == 0 && b[2] == 0
                     Iconv.conv('utf-8', 'utf-32be', b)
                   when b.size >= 4 && b[0] == 0 && b[2] == 0
                     Iconv.conv('utf-8', 'utf-16be', b)
                   when b.size >= 4 && b[1] == 0 && b[2] == 0 && b[3] == 0
                     Iconv.conv('utf-8', 'utf-32le', b)
                   when b.size >= 4 && b[1] == 0 && b[3] == 0
                     Iconv.conv('utf-8', 'utf-16le', b)
                   else
                     b
                   end
        end
        super source
        if !opts.key?(:max_nesting)
          @max_nesting = 19
        elsif opts[:max_nesting]
          @max_nesting = opts[:max_nesting]
        else
          @max_nesting = 0
        end
        @state = :toplvl
        @indents = [0]
        @obj = []
      end
    end

    alias source string

    def parse
      reset
      until eos?
        parse_children
      end
      @obj
    end

    def parse_children
      # Ignore blank lines
      # Ignore lines with just comments in them
      # Any line with a comment doesn't care about indents
      case
      when scan(WS1)

      end
    end

  end
end

