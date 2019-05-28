require "power_assert"
require "./yatsume"

prog = Program.parse <<~EOS
怖くなったので帰りました
怖くなったので帰りました
EOS

prog = Program.raw_to_prog <<~EOS
PUSHZ
PUSHZ
POP
POP
EOS
prog = Program.parse prog

prog.run



require "test-unit"

class TestAdd < Test::Unit::TestCase
  def test_run
    test_raw = <<~EOS
    # K: PUSHZ
    PUSHZ
    NOP
    0|
    # D: PUSHZ
    NOP
    PUSHZ
    |0
    # K: POP, D: DUP
    PUSHZ
    PUSHZ
    POP
    DUP
    |0,0
    # K: DUP, D: POP
    PUSHZ
    PUSHZ
    DUP
    POP
    0,0|
    # K cannot POP
    POP
    NOP
    !
    # K: PUSHN, D: ADDM
    PUSHZ
    PUSHZ
    PUSHN
    ADDM
    0|-1
    # K: SWAP
    PUSHZ
    NOP
    PUSHN
    NOP
    SWAP
    NOP
    -1,0|
    # D: SWAP
    PUSHN
    PUSHZ
    NOP
    PUSHZ
    NOP
    ADDM
    NOP
    SWAP
    |-1, 0
    # D: MULM -1 -1
    PUSHN
    PUSHZ
    PUSHN
    ADDM
    NOP
    MULM
    |1
    EOS
    test_raw.split(/#.*\n/)[1..-1].map{|raw|
      raw = raw.split("\n")
      src = raw[0...-1]
      p src
      prog = Program.raw_to_prog src.join("\n")
      prog = Program.parse prog

      if raw[-1] == "!"
        assert_raise { prog.run }
      else
        state = prog.run
        stacks = state.stacks
        ans = raw[-1].split("|",-1).map{|s|s.split(",").map(&:to_i)}
        assert(src){ stacks == ans }
      end
    }

  end
end

