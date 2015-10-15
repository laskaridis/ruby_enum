require 'spec_helper'

describe RubyEnum do
  class Coordinate
    include RubyEnum

    enum :north
    enum :south
    enum :east
    enum :west
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

  it 'should define enumeration instances' do
    expect(Coordinate.north).to be_a Coordinate
    expect(Coordinate.south).to be_a Coordinate
    expect(Coordinate.east).to be_a Coordinate
    expect(Coordinate.west).to be_a Coordinate
  end

  it 'should assign default values to each enumeration instance' do
    expect(Coordinate.north.raw_value).to eq 'north'
    expect(Coordinate.south.raw_value).to eq 'south'
    expect(Coordinate.east.raw_value).to eq 'east'
    expect(Coordinate.west.raw_value).to eq 'west'
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
      expect(Planet.mercury.raw_value).to eq 1
      expect(Planet.venus.raw_value).to eq 2
      expect(Planet.earth.raw_value).to eq 3
      expect(Planet.mars.raw_value).to eq 4
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
