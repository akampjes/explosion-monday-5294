require_relative '../instruction'
require_relative '../CPU'

RSpec.describe CPU do
  describe '#new' do
    it 'creates a new CPU' do
      CPU.new([])
    end
  end

  let(:instructions) do
    [
      Instruction.new("mov in, a   ~ accept integer from input bus, store in a register"),
      Instruction.new("jez +4      ~ if a equals 0, jump to the end of the program"),
      Instruction.new("add input   ~ add integer from input bus to a, store result in a"),
      Instruction.new("mov a, out  ~ writes register a to output bus"),
      Instruction.new("jmp -4      ~ jumps back to start of program")
    ]
  end

  describe '#run' do
    it 'has no insturctions' do
      CPU.new([]).run
    end

    context 'outputting something' do
      let(:instructions) do
        [
          Instruction.new("mov 42, out  ~ writes register a to output bus")
        ]
      end

      it 'writes 42 to stdout' do
        expect(STDOUT).to receive(:puts).with(42)

        CPU.new(instructions).run
      end
    end

    context 'outputting the input' do
      let(:instructions) do
        [
          Instruction.new("mov in, a    ~ accept integer from input bus, store in a register"),
          Instruction.new("mov a, out   ~ writes register a to output bus")
        ]
      end

      it 'writes 1 to stdout from input' do
        allow(STDIN).to receive(:gets).and_return('1')
        expect(STDOUT).to receive(:puts).with(1)

        CPU.new(instructions).run
      end
    end

    context 'adding two numbers' do
      let(:instructions) do
        [
          Instruction.new("mov in, a   ~ accept integer from input bus, store in a register"),
          Instruction.new("add input   ~ add integer from input bus to a, store result in a"),
          Instruction.new("mov a, out  ~ writes register a to output bus"),
        ]

      end

      it 'writes 1 to stdout from input' do
        allow(STDIN).to receive(:gets).and_return('1', '2')
        expect(STDOUT).to receive(:puts).with(3)

        CPU.new(instructions).run
      end

    end
  end
end
