require_relative 'instruction'
require_relative 'cpu'

def parse_programs(filename)
  programs = []

  current_cpu = 0
  program_lines = []
  File.open(filename).each_line do |line|
    new_cpu = /\A#(\d)/.match(line)
    if new_cpu
      # setup new cpu
      unless program_lines.empty?
        programs[current_cpu] = program_lines
        program_lines = []
      end

      current_cpu = new_cpu[1].to_i
    else
      program_lines << line.chomp unless line.chomp.empty?
    end
  end

  unless program_lines.empty?
    programs[current_cpu] = program_lines
  end

  programs
end

def parse_program(program_lines)
  program_lines.map do |line|
    Instruction.new(line)
  end
end

filename = ARGV[0]
fail "Input program filename needs to end in .a" unless filename =~ /.*\.a/

programs = parse_programs(filename)
# cpu_comms[to][from]
cpu_comms = [[Queue.new, Queue.new], [Queue.new, Queue.new]]

Thread.abort_on_exception = true

cpus = programs.each_with_index.map do |program, cpu_index|
  program_instructions = parse_program(program)
  cpu = CPU.new(program_instructions, cpu_index, cpu_comms)
  puts "here2"

  Thread.new do
    cpu.run
  end
end

loop do
end
