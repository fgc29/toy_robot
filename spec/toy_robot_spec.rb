require_relative '../lib/toy_robot'

describe ToyRobot do
  describe '.play' do
    context 'valid commands' do
      it 'returns 0,1,NORTH' do
        commands = 'PLACE 0,0,NORTH MOVE REPORT'
        output   = '0,1,NORTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 0,0,WEST' do
        commands = 'PLACE 0,0,NORTH LEFT REPORT'
        output   = '0,0,WEST'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 3,3,NORTH' do
        commands = 'PLACE 1,2,EAST MOVE MOVE LEFT MOVE REPORT'
        output   = '3,3,NORTH'

        expect(described_class.play(commands)).to eq output
      end
    end

    context 'ignore commands before PLACE' do
      it 'returns 2,2,EAST' do
        commands = 'MOVE LEFT MOVE PLACE 1,2,EAST MOVE REPORT'
        output   = '2,2,EAST'

        expect(described_class.play(commands)).to eq output
      end
    end

    context 'invalid commands' do
      it 'returns string error msg if missing PLACE command' do
        commands = '1,2,EAST MOVE MOVE LEFT MOVE REPORT'

        expect{described_class.play(commands)}.to raise_error described_class::ERROR_MSG
      end

      it 'returns string error msg if x and y are outbounds' do
        commands = '5,5,EAST MOVE MOVE LEFT MOVE REPORT'

        expect{described_class.play(commands)}.to raise_error described_class::ERROR_MSG
      end

      it 'returns string error msg if x is above upper bound' do
        commands = '5,1,EAST MOVE MOVE LEFT MOVE REPORT'

        expect{described_class.play(commands)}.to raise_error described_class::ERROR_MSG
      end

      it 'returns string error msg if y is above upper bound' do
        commands = '1,5,EAST MOVE MOVE LEFT MOVE REPORT'

        expect{described_class.play(commands)}.to raise_error described_class::ERROR_MSG
      end

      it 'returns string error msg if x is below lower bound' do
        commands = '-1,5,EAST MOVE MOVE LEFT MOVE REPORT'

        expect{described_class.play(commands)}.to raise_error described_class::ERROR_MSG
      end

      it 'returns string error msg if y is below lower bound' do
        commands = '1,-5,EAST MOVE MOVE LEFT MOVE REPORT'

        expect{described_class.play(commands)}.to raise_error described_class::ERROR_MSG
      end
    end

    context 'ignores commands that would place robot outside of the board' do
      it 'returns 4,4,NORTH' do
        commands = 'PLACE 4,4,NORTH MOVE MOVE MOVE REPORT'
        output   = '4,4,NORTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 3,4,WEST' do
        commands = 'PLACE 4,4,NORTH MOVE MOVE LEFT MOVE REPORT'
        output   = '3,4,WEST'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 4,3,SOUTH' do
        commands = 'PLACE 4,4,NORTH MOVE MOVE LEFT LEFT MOVE REPORT'
        output   = '4,3,SOUTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 4,1,NORTH' do
        commands = 'PLACE 4,0,EAST MOVE MOVE LEFT MOVE REPORT'
        output   = '4,1,NORTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 3,0,WEST' do
        commands = 'PLACE 4,0,EAST MOVE MOVE RIGHT RIGHT MOVE REPORT'
        output   = '3,0,WEST'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 0,3,SOUTH' do
        commands = 'PLACE 0,4,WEST MOVE MOVE LEFT MOVE REPORT'
        output   = '0,3,SOUTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 1,4,EAST' do
        commands = 'PLACE 0,4,WEST MOVE MOVE LEFT LEFT MOVE REPORT'
        output   = '1,4,EAST'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 0,0,SOUTH' do
        commands = 'PLACE 0,0,WEST MOVE MOVE LEFT MOVE REPORT'
        output   = '0,0,SOUTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 0,1,NORTH' do
        commands = 'PLACE 0,0,WEST MOVE MOVE RIGHT MOVE REPORT'
        output   = '0,1,NORTH'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 1,0,EAST' do
        commands = 'PLACE 0,0,WEST MOVE MOVE LEFT LEFT MOVE REPORT'
        output   = '1,0,EAST'

        expect(described_class.play(commands)).to eq output
      end

      it 'returns 0,1,NORTH' do
        commands = 'PLACE 0,0,WEST MOVE MOVE LEFT LEFT LEFT MOVE REPORT'
        output   = '0,1,NORTH'

        expect(described_class.play(commands)).to eq output
      end
    end
  end
end