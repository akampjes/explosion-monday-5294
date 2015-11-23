require 'pry'

class CPU
  def initialize(instructions, cpu_index, cpu_comms)
    @instructions = instructions
    @cpu_index = cpu_index
    @cpu_comms = cpu_comms
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
      swp
    when 'sav'
      sav
    when 'add'
      add(instruction.arg1)
    when 'sub'
      sub(instruction.arg1)
    when 'jmp'
      jmp(instruction.arg1)
    when 'jez'
      jez(instruction.arg1)
    when 'jnz'
      jnz(instruction.arg1)
    when 'jgz'
      jgz(instruction.arg1)
    when 'jlz'
      jlz(instruction.arg1)
    else
      fail 'Not an instruction'
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
      cpu = /\A#\d/.match(source)[1].to_i
      # cpu_comms[to][from]
      @cpu_comms[@cpu_index][cpu].pop
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
      cpu = /\A#\d/.match(destination)[1].to_i
      @cpu_comms[cpu][@cpu_index] << integer
    else
      fail 'Invalid destination'
    end
  end

  def mov(source, destination)
    x = from_source(source)

    to_destination(destination, x)
  end

  def swp
    tmp = @a
    @a = @b
    @b = tmp
  end

  def sav
    @b = @a
  end

  def add(source)
    @a += from_source(source)
  end

  def sub(source)
    @a -= from_source(source)
  end

  def jmp(location)
    if match = /\A\+(\d+)\z/.match(location)
      @pc += (match[1].to_i - 1)
    elsif match = /\A-(\d+)\z/.match(location)
      @pc -= (match[1].to_i + 1)
    elsif match = /\A0\z/.match(location)
      @pc -= 1
    else
      fail 'Not a valid location'
    end
  end

  def jez(location)
    jmp(location) if @a.zero?
  end

  def jnz(location)
    jmp(location) unless @a.zero?
  end

  def jgz(location)
    jmp(location) if @a > 0
  end

  def jlz(location)
    jmp(location) if @a < 0
  end
end
