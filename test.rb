require "./yatsume"

require "test-unit"

class TestAdd < Test::Unit::TestCase
  def test_run
    test_raw = <<~EOS
    # NOP
    |
    |
    # K: PUSHZ
    |
    PUSHZ
    NOP
    0|
    # D: PUSHZ
    |
    NOP
    PUSHZ
    |0
    # K: POP, D: DUP
    |
    PUSHZ
    PUSHZ
    POP
    DUP
    |0 0
    # K: DUP, D: POP
    |
    PUSHZ
    PUSHZ
    DUP
    POP
    0 0|
    # K cannot POP
    |
    POP
    NOP
    !
    # K: PUSHN, D: ADD
    |
    PUSHZ
    PUSHZ
    PUSHN
    ADD
    0|-1
    # K: SWAP
    |
    PUSHZ
    NOP
    PUSHN
    NOP
    SWAP
    NOP
    -1 0|
    # D: SWAP
    |
    PUSHN
    PUSHZ
    NOP
    PUSHZ
    NOP
    ADD
    NOP
    SWAP
    |-1 0
    # D: MUL -1 -1
    |
    PUSHN
    PUSHZ
    PUSHN
    ADD
    NOP
    MUL
    |1
    # D: NEQ 3 3
    3|3
    NOP
    NEQ
    |1
    # D: NEQ 2 3
    3|2
    NOP
    NEQ
    |0
    # D: LT 2 3
    3|2
    NOP
    LT
    |1
    # D: LT 3 3
    3|3
    NOP
    LT
    |0
    # D: DUPS 3
    1|3
    DUPS
    NOP
    1 1 1 1|
    # D: PUSHS 3
    |3
    PUSHS
    NOP
    3|
    # D: TAKES 3
    4 5 6 7 8|3
    TAKES
    NOP
    4 5 6 7 8 5|
    # D: REVS 3
    4 5 6 7 8|3
    REVS
    NOP
    4 5 8 7 6|
    # D: POSTS 3
    4 3 6 7 8|3
    POPTS
    4|
    # NOJUMP
    |
    PUSHLAB
    PUSHZ
    NOP
    JNZLAB
    |
    # PUSH1
    |
    PUSHN
    PUSHZ
    PUSHN
    ADD
    NOP
    MUL
    PUSHS
    NOP
    1|
    # LOOP
    0|10
    PUSHLAB
    NOP
    PUSHN
    ADD
    NOP
    PUSHZ
    SWAP
    ADD
    PUSHN
    PUSHZ
    PUSHN
    ADD
    NOP
    MUL
    PUSHS
    ADD
    PUSHS
    NOP
    SWAP
    DUP
    DUP
    JNZLAB
    POP
    POP
    10|
    EOS
    test_raw.split(/#.*\n/)[1..-1].map{|raw|
      raw = raw.split("\n")
      src = raw[1...-1]
      stacks = raw[0].split("|",-1).map{|s|s.split(" ").map(&:to_i)}
      p src
      prog = Program.raw_to_prog src.join("\n")
      prog = Program.parse prog

      if raw[-1] == "!"
        assert_raise { prog.run_with_stack *stacks }
      else
        state = prog.run_with_stack *stacks
        stacks = state.stacks
        ans = raw[-1].split("|",-1).map{|s|s.split(" ").map(&:to_i)}
        assert(src){ stacks == ans }
      end
    }

  end
end

