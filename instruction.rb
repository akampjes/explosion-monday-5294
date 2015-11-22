class Instruction
  def initialize(line)
    @line = line
    @op = nil
    @arg1 = nil
    @arg2 = nil

    parse_line
  end

  def op
    @op
  end

  def arg1
    @arg1
  end

  def arg2
    @arg2
  end

  private

  def parse_line
    line = @line.split(' ')
    @op = line[0]
    @arg1 = line[1].chomp(',') unless line[1].nil?
    @arg2 = line[2]
  end
end
