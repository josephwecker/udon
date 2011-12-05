
# line 1 "denote.rl"


# line 6 "denote.rl"



# line 10 "denote.rb"
class << self
	attr_accessor :_hello_actions
	private :_hello_actions, :_hello_actions=
end
self._hello_actions = [
	0, 1, 0
]

class << self
	attr_accessor :_hello_key_offsets
	private :_hello_key_offsets, :_hello_key_offsets=
end
self._hello_key_offsets = [
	0, 0, 1, 2
]

class << self
	attr_accessor :_hello_trans_keys
	private :_hello_trans_keys, :_hello_trans_keys=
end
self._hello_trans_keys = [
	104, 105, 0
]

class << self
	attr_accessor :_hello_single_lengths
	private :_hello_single_lengths, :_hello_single_lengths=
end
self._hello_single_lengths = [
	0, 1, 1, 0
]

class << self
	attr_accessor :_hello_range_lengths
	private :_hello_range_lengths, :_hello_range_lengths=
end
self._hello_range_lengths = [
	0, 0, 0, 0
]

class << self
	attr_accessor :_hello_index_offsets
	private :_hello_index_offsets, :_hello_index_offsets=
end
self._hello_index_offsets = [
	0, 0, 2, 4
]

class << self
	attr_accessor :_hello_trans_targs
	private :_hello_trans_targs, :_hello_trans_targs=
end
self._hello_trans_targs = [
	2, 0, 3, 0, 0, 0
]

class << self
	attr_accessor :_hello_trans_actions
	private :_hello_trans_actions, :_hello_trans_actions=
end
self._hello_trans_actions = [
	0, 0, 1, 0, 0, 0
]

class << self
	attr_accessor :hello_start
end
self.hello_start = 1;
class << self
	attr_accessor :hello_first_final
end
self.hello_first_final = 3;
class << self
	attr_accessor :hello_error
end
self.hello_error = 0;

class << self
	attr_accessor :hello_en_main
end
self.hello_en_main = 1;


# line 9 "denote.rl"

def run_machine(data)
  
# line 98 "denote.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = hello_start
end

# line 12 "denote.rl"
  
# line 107 "denote.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
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
	_keys = _hello_key_offsets[cs]
	_trans = _hello_index_offsets[cs]
	_klen = _hello_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _hello_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _hello_trans_keys[_mid]
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
	  _klen = _hello_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _hello_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _hello_trans_keys[_mid+1]
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
	cs = _hello_trans_targs[_trans]
	if _hello_trans_actions[_trans] != 0
		_acts = _hello_trans_actions[_trans]
		_nacts = _hello_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _hello_actions[_acts - 1]
when 0 then
# line 5 "denote.rl"
		begin
puts "hello world"		end
# line 191 "denote.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
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

# line 13 "denote.rl"
end
