require_relative 'instruction'

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
        program_lines = ''
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

programs.each do |program|
  program_instructions = parse_program(program)
end
