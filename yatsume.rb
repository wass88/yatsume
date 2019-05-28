class State
  RAND_SIZE = 10000
  def initialize program
    @prog = program
    s = rand(RAND_SIZE)+1
    @label_nums = Array.new(@prog.size){|i|[s+=rand(RAND_SIZE)+1]}
    @label_nums = Array.new(@prog.size){|i|[10000+i]}
    @pc = 0
    @stackK = []
    @stackD = []
  end
  def next
    op_k, op_d = @prog[@pc]
    def k_pop msg = "Kは先に進みすぎた" 
      raise msg unless @stackK.size >= 1
      @stackK.pop
    end
    def d_pop msg = "Dは先に進みすぎた"
      raise msg unless @stackD.size >= 1
      @stackD.pop
    end
    case op_k
    when "NOP"
      # NOP
    when "POP"
      k_pop
    when "PUSHZ"
      @stackK.push 0
    when "DUP"
      @stackK.push @stackK[-1]
    when "SWAP"
      c1 = k_pop
      c2 = k_pop
      @stackK.push c1
      @stackK.push c2

    when "PUSHN"
      @stackK.push -1
    else
      raise "Unreachable : #{op_k}"
    end
    case op_d
    when "NOP"
      # NOP
    when "POP"
      d_pop
    when "PUSHZ"
      @stackD.push 0
    when "DUP"
      @stackD.push @stackD[-1]
    when "SWAP"
      c1 = d_pop
      c2 = d_pop
      @stackD.push c1
      @stackD.push c2
    when "ADDM"
      c1 = d_pop
      c2 = k_pop "Kを助けられない"
      @stackD.push c1+c2
    else
      raise "Unreachable : #{op_d}"
    end
    @pc += 1 
    self.eof
  end
  def eof
    @pc >= @prog.size
  end
  def to_s
    <<~EOS
    #{@pc} : #{self.eof ? "-" : @prog[@pc].join(", ") }
    K: #{@stackK.join(", ")}
    D: #{@stackD.join(", ")}
    EOS
  end
  def stacks
    [@stackK, @stackD]
  end
end

OPS = [
  ["", "NOP", 1, 1],
  ["怖くなったので帰りました", "POP", 1, 1],
  ["嫌な気分になりました", "PUSHZ", 1, 1],
  ["蛙が鳴いたので急ぎました", "DUP", 1, 1],
  ["走ってたら転びました", "SWAP", 1, 1],

  ["トンネルの前に着きました", "PUSHN", 1, 0],

  ["付き添いで行くことになった", "ADDM", 0, 1],
].map.with_index{|(code, op, sk, sd), i| [code, [i, op, sk==1, sd==1]]}.to_h

class Program
  def initialize lines
    @lines = lines
  end
  def self.raw_to_prog code
    rev = OPS.map{|k, (_, op, _, _)| [op, k]}.to_h
    code.split("\n").map{|c|rev[c.chomp]}.join("\n")
  end
  def self.parse code
    lines = code.split("\n")
    if lines.size % 2 == 1
      lines << ""
    end
    lines = lines.map.with_index{|l, linenum|
      raise "そんな命令はない #{linenum}: '#{l}'" unless OPS.key? l
      i, op, k_op, d_op = OPS[l]
      k_line = linenum % 2 == 0
      p [op, k_line, k_op, d_op]
      raise "Kの命令ではない #{linenum}: '#{l}'" if k_line and !k_op
      raise "Dの命令ではない #{linenum}: '#{l}'" if !k_line and !d_op
      op
    }
    Program.new lines.each_slice(2).to_a
  end
  def size
    @lines.size
  end
  def [] x
    @lines[x]
  end
  def run
    state = State.new self
    puts state.to_s
    while !state.eof
      state.next
      puts state.to_s
    end
    state
  end
end
