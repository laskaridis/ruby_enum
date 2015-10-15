require 'spec_helper'

describe RubyEnum do
  class Coordinate
    include RubyEnum

    enum :north
    enum :south
    enum :east
    enum :west
  end


  describe 'Coordinate.north' do
    subject { Coordinate.north }

    it { should be_a Coordinate }
    it { should respond_to :north? }
    it { should be_north }
    it { should_not be_south }
    it { should_not be_east }
    it { should_not be_west }
    it 'should have value `north`' do
      expect(subject.value).to eq 'north'
    end
    it 'should have name :north' do
      expect(subject.name).to eq :north
    end
  end

  describe 'Coordinate.south' do
    subject { Coordinate.south }

    it { should be_a Coordinate }
    it { should respond_to :south? }
    it { should be_south }
    it { should_not be_north }
    it { should_not be_east }
    it { should_not be_west }
    it 'should have value `south`' do
      expect(subject.value).to eq 'south'
    end
    it 'should have name :south' do
      expect(subject.name).to eq :south
    end
  end

  describe 'Coordinate.east' do
    subject { Coordinate.east }

    it { should be_a Coordinate }
    it { should respond_to :east? }
    it { should be_east }
    it { should_not be_north }
    it { should_not be_south }
    it { should_not be_west }
    it 'should have value `east`' do
      expect(subject.value).to eq 'east'
    end
    it 'should have name :east' do
      expect(subject.name).to eq :east
    end
  end

  describe 'Coordinate.west' do
    subject { Coordinate.west }

    it { should be_a Coordinate }
    it { should respond_to :west? }
    it { should be_west }
    it { should_not be_north }
    it { should_not be_south }
    it { should_not be_east }
    it 'should have value `west`' do
      expect(subject.value).to eq 'west'
    end
    it 'should have name :west' do
      expect(subject.name).to eq :west
    end
  end

  it 'should make #new private' do
    expect { Coordinate.new }.to raise_error NoMethodError
  end

  it 'should make #allocate private' do
    expect { Coordinate.new }.to raise_error NoMethodError
  end

  it 'should disable #clone' do
    expect { Coordinate.north.clone }.to raise_error TypeError
  end

  it 'should disable #dup' do
    expect { Coordinate.north.dup }.to raise_error TypeError
  end

  it 'should define type checking methods' do
    expect(Coordinate.north).to be_north
    expect(Coordinate.south).to be_south
    expect(Coordinate.east).to be_east
    expect(Coordinate.west).to be_west
  end

  it 'should assign a default associated value to each enumeration instance' do
    expect(Coordinate.north.value).to eq 'north'
    expect(Coordinate.south.value).to eq 'south'
    expect(Coordinate.east.value).to eq 'east'
    expect(Coordinate.west.value).to eq 'west'
  end

  it 'should provide access to specified enumeration instance through symbols' do
    expect(Coordinate::NORTH).to eq Coordinate.north
    expect(Coordinate::SOUTH).to eq Coordinate.south
    expect(Coordinate::EAST).to eq Coordinate.east
    expect(Coordinate::WEST).to eq Coordinate.west
  end

  describe '#[]' do

    it 'should return the specified enumeration instance' do
      expect(Coordinate[:north]).to eq Coordinate.north
      expect(Coordinate[:south]).to eq Coordinate.south
      expect(Coordinate[:east]).to eq Coordinate.east
      expect(Coordinate[:west]).to eq Coordinate.west
    end
  end

  describe '#all' do

    it 'should return all enumeration instances' do
      coordinates = Coordinate.all

      expect(coordinates).to be_an Array
      expect(coordinates.size).to eq 4
      expect(coordinates).to include Coordinate.north
      expect(coordinates).to include Coordinate.south
      expect(coordinates).to include Coordinate.east
      expect(coordinates).to include Coordinate.west
    end
  end

  context 'given an enumeration  with values explicitly assigned to its instances' do
    class Planet
      include RubyEnum

      enum :mercury, 1
      enum :venus, 2
      enum :earth, 3
      enum :mars, 4
    end

    it 'should assign specified values to each instance' do
      expect(Planet.mercury.value).to eq 1
      expect(Planet.venus.value).to eq 2
      expect(Planet.earth.value).to eq 3
      expect(Planet.mars.value).to eq 4
    end
  end

  context 'when an enumeration value has already been defined' do
    before { expect(Planet::MARS).to_not be_nil }

    it 'should raise an error when an enumeration value is defined twice' do
      expect do
        class Planet
          enum :mars
        end
      end.to raise_error ArgumentError
    end

    it 'should not create duplicate enumeration values' do
      planets_count = Planet.all.size

      expect do
        class Planet
          enum :mars
        end
      end.to raise_error ArgumentError
      expect(Planet.all.size).to eq planets_count
    end
  end
end
