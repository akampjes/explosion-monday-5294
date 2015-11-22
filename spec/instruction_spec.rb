require_relative '../instruction'

RSpec.describe Instruction do
  subject { Instruction.new(line) }
  let(:line) { 'mov in, a   ~ accept integer from input bus, store in a register' }

  describe '#new' do
    context 'with no args' do
      let(:line) { 'swp' }

      it 'has an operation' do
        expect(subject.op).to eq 'swp'
      end
    end

    context 'with one arg' do
      let(:line) { 'jez +4' }

      it 'has an operation' do
        expect(subject.op).to eq 'jez'
      end

      it 'has an arg' do
        expect(subject.arg1).to eq '+4'
      end
    end

    context 'with two args' do
      let(:line) { 'mov in, a' }

      it 'has an operation' do
        expect(subject.op).to eq 'mov'
      end

      it 'has an arg' do
        expect(subject.arg1).to eq 'in'
      end

      it 'has another arg' do
        expect(subject.arg2).to eq 'a'
      end
    end

    context 'with a comment' do
      let(:line) { 'mov in, a   ~ accept integer from input bus, store in a register' }

      it 'has an operation' do
        expect(subject.op).to eq 'mov'
      end

      it 'has an arg' do
        expect(subject.arg1).to eq 'in'
      end

      it 'has another arg' do
        expect(subject.arg2).to eq 'a'
      end
    end
  end
end
