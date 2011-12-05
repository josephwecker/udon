class String
  # Alternative would be to do indent/dedent with '{' and '}' - but I'd
  # probably need to then also make sure that they aren't already there - but
  # that should probably be part of the algorithm anyway w/ dedent/indent
  #
  # Alternative to partial dedent is doing super-indents - where if you
  # double-indent the second line but single-indent the third line- the code
  # goes back and treats the second line as if it were a continuation of the
  # first; the third line becomes the first "indented" line.
  # The problem, of course is how to deal with (and efficiently) something
  # like:
  #   line 1
  #       line 2
  #      line 3
  #     line 4
  #    line 5
  #

  def with_dents(indent="\u200C", dedent="\u200D", partial_dedent="\u200B", strict=false, dents=[0])
    r = ''
    each_line do |line|
      line =~ /^([ \t]*)/
      lvl = $1.length
      if lvl > dents.last
        dents.push lvl
        r += indent
      end
      while lvl < dents.last
        dents.pop
        if lvl > dents.last
          raise "Bad indentation level: #{line}" if strict
          r += partial_dedent
          dents.push lvl
        else r += dedent end
      end
      r += line
    end
    return r
  end
end


class DentProcessor
  attr_accessor :indent_token, :dedent_token, :partial_dedent_token, :strict

  def initialize(indent="\u200C", dedent="\u200D", partial="\u200B", strict=false, dents=[0])
    @indent_token = indent
    @dedent_token = dedent
    @partial_dedent_token = partial
    @strict = strict
    @dents = [0]
  end

  def add_exemption(start, finish, props={})
    props[:start] =          start
    props[:finish] =         finish
    props[:escaping] ||=     true
    props[:containing] ||=   true
    props[:total_ignore] ||= false # Ignore even initial indentation level

    @exemptions ||= {}
    @exemptions[start] = props
  end

  def inject_dents(s)
    @out = ''
    exemption_filter = /(#{@exemptions.keys.join('|')})/
    s.each_char do |c| # can't do char-by-char - some exemptions may need more than that.

    end
  end

  def starts_exemption?
    @exemptions.map{|s,r|
  end
end
