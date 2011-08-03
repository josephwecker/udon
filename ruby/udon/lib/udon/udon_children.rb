module Udon
  module Children
    class Child
      attr_accessor :child_type, :children

      def [](key) @children[key] end

      def ident
        child_type
      end

      def inspect(lvl=0)
        dnt = ' ' * lvl * 2
        begin
          "#{dnt}<{-#{ident}-[\n#{@children.map{|c|c.inspect(lvl+1)}.join(",\n")}\n#{dnt}]"
        rescue
          "#{dnt}<{-#{ident}-[\n#{@children.map{|c|c.inspect}.join(",\n")}\n#{dnt}]"
        end
      end
    end

    class Comment < Child
      attr_accessor :value
      def initialize(children)
        @child_type = :comment
        @children = children
      end
      def value() @children.join("\n") end
    end

    class Element < Child
      attr_accessor :name, :id, :unaries, :attributes
      def initialize(args={})
        @child_type = :element
        @name =       args.delete(:name)
        @id =         args.delete(:id)
        @unaries =    args.delete(:unaries) || []
        @attributes = args.delete(:attributes) || {}
        @children =   args.delete(:children) || []
      end

      #-------------------- Pretty printing --------------------------
      # TODO:
      #  - Attributes in extra-embed-list-style when enough of them / too long
      #  - Bonus if attribute values line up in eels
      #  - Remove quotes from value if in eels
      #  - Even single children start on next line if blk + attributes take up too
      #    much space.
      #  - Optional online pre-children-pipe
      #  - Make sure sax parser combines sequential characters so we don't
      #    introduce bad whitespace.
      #  - Text blocks (including inlined tags
      #    * 
      def id_str
        @id.nil? ? '' : "[#{@id.gsub(/(\[|\])/){|s|"\\#{s}"}}]"
      end

      def unary_str
        @unaries.count < 1 ? '' : ".#{@unaries.map{|u|u.gsub('.','\.')}.join('.')}"
      end

      def embedstyle
        out = "<{#{@name}#{id_str}#{unary_str}"
        if @attributes.count > 0
          out += " " + @attributes.map{|k,v| inline_attr(k,v)}.join(' ')
        end
        if @children.count > 0
          out += ' '
          @children.each{|c| out += c.is_a?(String) ? c : c.embedstyle}
        end
        return out + "}>"
      end

      def inline_attr(k,v)
        k = '"'+k.gsub('"','\"')+'"' if k =~ /\s/
        v = '"'+v.gsub('"','\"')+'"' if v =~ /\s/
        ":#{k} #{v}"
      end

      def canonical(depth=0)
        ind = '' + ('  '*depth)
        out = ind + "|#{@name}#{id_str}#{unary_str}"
        if @attributes.count > 0
          out += " " + @attributes.map{|k,v| inline_attr(k,v)}.join(' ')
        end
        if @children.count == 1 && @children[0].is_a?(String)
          out += " #{@children[0]}\n"
        elsif @children.count > 1 && mixed(@children)
          out += "\n" + ind + '  '
          @children.each{|c| out += c.is_a?(String) ?  c : c.embedstyle}
          out += "\n"
        else
          out += "\n"
          @children.each do |c|
            if c.is_a? String
              out += ind + '  ' + c.strip + "\n"
            else
              out += c.canonical(depth+1)
            end
          end
        end
        return out
      end

      def mixed(list)
        found_str = false
        found_node = false
        list.each do |l|
          if l.is_a?(String) then found_str = true
          else found_node = true end
        end
        return (found_str && found_node)
      end
    end
  end
end
