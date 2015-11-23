require 'pry'

class CPU
  def initialize(instructions)
    @instructions = instructions
    @a = 0
    @b = 0
    @pc = 0
  end

  def run
    return if @pc >= @instructions.count

    perform_op

    @pc += 1
    run
  end

  private

  def perform_op
    instruction = @instructions[@pc]

    case instruction.op
    when 'mov'
      mov(instruction.arg1, instruction.arg2)
    when 'swp'
    when 'sav'
    when 'add'
    when 'sub'
    when 'jmp'
    when 'jez'
    when 'jnz'
    when 'jgz'
    when 'jlz'
    end
  end

  def from_source(source)
    case source
    when 'in'
      STDIN.gets.to_i
    when 'a'
      @a
    when 'null'
      0
    when /\A#\d/
      fail 'Not implemented'
    when /\A\d+\z/
      source.to_i
    else
      fail 'Invalid source'
    end
  end

  def to_destination(destination, integer)
    case destination
    when 'out'
      puts integer
    when 'a'
      @a = integer
    when 'null'
      ;
    when /\A#\d/
      fail 'Not implemented'
    else
      fail 'Invalid destination'
    end
  end

  def mov(source, destination)
    x = from_source(source)

    to_destination(destination, x)
  end
end
