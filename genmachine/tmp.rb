
# line 1 "tmp.rl"

# line 5 "tmp.rb"
class << self
	attr_accessor :_foo_key_offsets
	private :_foo_key_offsets, :_foo_key_offsets=
end
self._foo_key_offsets = [
	0, 0, 2, 4, 7
]

class << self
	attr_accessor :_foo_trans_keys
	private :_foo_trans_keys, :_foo_trans_keys=
end
self._foo_trans_keys = [
	48, 57, 48, 57, 46, 48, 57, 48, 
	57, 0
]

class << self
	attr_accessor :_foo_single_lengths
	private :_foo_single_lengths, :_foo_single_lengths=
end
self._foo_single_lengths = [
	0, 0, 0, 1, 0
]

class << self
	attr_accessor :_foo_range_lengths
	private :_foo_range_lengths, :_foo_range_lengths=
end
self._foo_range_lengths = [
	0, 1, 1, 1, 1
]

class << self
	attr_accessor :_foo_index_offsets
	private :_foo_index_offsets, :_foo_index_offsets=
end
self._foo_index_offsets = [
	0, 0, 2, 4, 7
]

class << self
	attr_accessor :_foo_trans_targs
	private :_foo_trans_targs, :_foo_trans_targs=
end
self._foo_trans_targs = [
	3, 0, 4, 0, 2, 3, 0, 4, 
	0, 0
]

class << self
	attr_accessor :foo_start
end
self.foo_start = 1;
class << self
	attr_accessor :foo_first_final
end
self.foo_first_final = 3;
class << self
	attr_accessor :foo_error
end
self.foo_error = 0;

class << self
	attr_accessor :foo_en_main
end
self.foo_en_main = 1;


# line 4 "tmp.rl"



# line 79 "tmp.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = foo_start
end

# line 86 "tmp.rb"
begin
	_klen, _trans, _keys = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _foo_key_offsets[cs]
	_trans = _foo_index_offsets[cs]
	_klen = _foo_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _foo_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _foo_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _foo_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _foo_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _foo_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	cs = _foo_trans_targs[_trans]
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 11 "tmp.rl"

