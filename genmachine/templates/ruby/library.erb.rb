require 'strscan'
require 'pp'

$KCODE="U"

module <%= classname %>
  def self.parse(str)
    Parser.new(str).parse
  end

  def self.parse_file(fname)
    Parser.new(IO.read(fname)).parse
  end

  class Node
    attr_accessor :name, :children, :start_line, :start_pos, :end_line, :end_pos
    def initialize(name='node',line=:unknown,pos=:unknown)
      @name = name
      @children = []
      @start_line = line
      @start_pos = pos
    end
    def <<(val) @children<<val end
  end

  class Parser < StringScanner
    def init(source, opts={})
      opts ||= {}
      super ensure_encoding(source)
      @global = {}
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

    def parse
      reset
      @line = 1
      @pos = 1
      @leading = true
      @indent = 0
      @ast = <%= @first_state %>
      pp @ast  # tmp for debugging
    end

    private

    def error(msg)
      $stderr.puts "#{msg} | line: #{@line} | char: #{@pos}"
    end

    def global_state(c)
      # Unicode newline characters & combinations
      # Plus leading space for indents.
      # Also tracks line and position for the AST
      @last_is_newline = @last_is_space = false
      case c
      when 0x0b, 0x0c, 0x85, 0x2028, 0x2029
        @last_is_newline = true; @line += 1; @pos = 1
        @leading = true; @indent = 0
      when 0x0a
        nc = peek(1).unpack('U')[0]
        if nc == 0x0d then getch; c = 0x0a0d end
        @last_is_newline = true; @line += 1; @pos = 1
        @leading = true; @indent = 0
      when 0x0d
        nc = peek(1).unpack('U')[0]
        if nc == 0x0a then getch; c = 0x0d0a end
        @last_is_newline = true; @line += 1; @pos = 1
        @leading = true; @indent = 0
      when 0x20
        @indent += 1 if @leading
        @last_is_space = true; @pos += 1
      else @leading = false; @pos += 1 end
      return @last_c = c
    end

    def nl?() return @last_is_newline end
    def space?() return @last_is_space end

    def nextchar
      if @fwd then @fwd = false; return @last_c
      else
        c = getch
        if c.nil?
          c = :eof
          @last_is_space = @last_is_newline = false
          return @last_c = c
        end
        return global_state(c.unpack('U')[0])
      end
    end

<% @table.each do |name, args, cmds, first_state, states| %>
  <% args << "name='#{name}'" %>
  <% args << "from=nil" %>
    def <%= name %>(<%= args.join(',') %>)
      <% cmds.each do |c| %><%= c.gsub(/\$/,'@') %>
      <% end %>state='<%= first_state %>'
      <% if states.size > 1 or aggregates?(states) or makes_calls?(states) %>
      this = Node.new(name,@line,@pos)<% end %>
      loop do
        c = nextchar
        break
      end
    end
<% end %>

=begin
    def document(from=nil,name='document')
      this = Node.new(name, @line, @pos)
      state = :ws
      loop do
        c = nextchar
        case state
        when :ws
          case
          when space?,nl?,c==9; next
          when c == :eof; return this
          else @fwd=true; state=:child end
        when :child
          case
          when c==35; comment(this); state=:ws
          else
            error('Not yet implemented.')
            to_nextline(this,'to_nextline')
            state = :ws
          end
        end
      end
    end

    def to_nextline(from=nil,name='to-nextline')
      # Doesn't aggregate and doesn't call another- don't create a node
      # for it at all.
      # state = :scan - only one inner state so no need to specify
      loop do
        c = nextchar
        # only one inner-state so no state case statement
        case
        when nl?; @fwd = true; return
        when c == :eof; @fwd = true; return
        else next end
      end
    end

    def comment(from=nil,name='comment')
      this = Node.new(name, @line, @pos)
      ___ipar = @indent
      ___ibase = ___ipar + 100
      ___a = '' # Detected from later clause
      state = :'1st:ws'
      loop do
        c = nextchar
        state = :eof if c == :eof  # General action described
        case state
        when :'1st:ws'
          case
          when space?, c==9; next
          when nl?; state=:nl; next
          # instead of c != :eof because general eof handled
          else ___a<<c; state=:'1st'; next end
        when :'1st'
          case
          # implied by <<< in source
          when nl?; this<<___a; ___a=''; state=:nl; next
          else ___a<<c; next end
        when :nl
          case
          when @indent==___ibase; @fwd=true; state=:child; next
          when nl?,space?,c==9; next
          when @indent<=___ipar; @fwd=true; from<<this; return
          else ___a<<c; ___ibase=@indent; state=:child; next end
        when :child
          case
          when nl?; this<<___a; ___a=''; state=:nl; next
          else ___a<<c; next end
        when :eof; this<<___a; from<<this; return end
        # fallthrough to here means generic error
        error("Unexpected #{c}")
        @fwd = true
        return
      end
    end
=end
  end
end
