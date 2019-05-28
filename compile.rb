require "./yatsume"

prog = Program.raw_to_prog(readlines.join(""))
puts Program.parse(prog).src