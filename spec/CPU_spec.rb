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
          Instruction.new("add 1"),
          Instruction.new("add 2"),
          Instruction.new("mov a, out")
        ]

      end

      it 'writes 1 to stdout from input' do
        expect(STDOUT).to receive(:puts).with(3)

        CPU.new(instructions).run
      end
    end

    context 'subtracting two numbers' do
      let(:instructions) do
        [
          Instruction.new("mov 5, a"),
          Instruction.new("sub 8"),
          Instruction.new("mov a, out")
        ]

      end

      it 'writes 1 to stdout from input' do
        expect(STDOUT).to receive(:puts).with(-3)

        CPU.new(instructions).run
      end
    end

    context 'with swp and sav ops' do
      let(:instructions) do
        [
          Instruction.new("mov 5, a"),
          Instruction.new("sav"),
          Instruction.new("mov 4, a"),
          Instruction.new("swp"),
          Instruction.new("mov a, out"),
        ]
      end

      it 'writes 5 to stdout' do
        expect(STDOUT).to receive(:puts).with(5)

        CPU.new(instructions).run
      end
    end

    context 'with jez op' do
      context 'when zero' do
        let(:instructions) do
          [
            Instruction.new("mov 0, a"),
            Instruction.new("jez +2"),
            Instruction.new("mov 4, a"),
            Instruction.new("mov a, out"),
          ]
        end

        it 'writes 0 to stdout' do
          expect(STDOUT).to receive(:puts).with(0)

          CPU.new(instructions).run
        end
      end

      context 'when not zero' do
        let(:instructions) do
          [
            Instruction.new("mov 1, a"),
            Instruction.new("jez +2"),
            Instruction.new("mov 4, a"),
            Instruction.new("mov a, out"),
          ]
        end

        it 'writes 4 to stdout' do
          expect(STDOUT).to receive(:puts).with(4)

          CPU.new(instructions).run
        end
      end
    end

    context 'with jmp op' do
      context 'when jmp 0' do
        let(:instructions) do
          [
            Instruction.new("jmp 0"),
            Instruction.new("mov 4, a"),
            Instruction.new("mov a, out"),
          ]
        end

        it 'writes 4 to stdout' do
          #expect(STDOUT).to receive(:puts).with(4)

          # lol infinate loop duh
          #CPU.new(instructions).run
        end

      end

      context 'when jmp negative' do
      end

      context 'when jmp positive' do
        let(:instructions) do
          [
            Instruction.new("jmp +2"),
            Instruction.new("mov 4, a"),
            Instruction.new("mov a, out"),
          ]
        end

        it 'writes 0 to stdout' do
          expect(STDOUT).to receive(:puts).with(0)

          CPU.new(instructions).run
        end
      end
    end

    context 'jmp back outside of loop' do
    end
  end
end
