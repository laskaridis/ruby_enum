require 'spec_helper'

require 'rails/all'
require 'ruby_enum/active_record'
require 'ruby_enum/active_model'
require 'ruby_enum/railtie'


# TODO move this to spec support
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

::ActiveRecord::Base.send :include, RubyEnum::ActiveRecord::AttrEnum
::ActiveRecord::Base.send :include, RubyEnum::ActiveModel::AttrEnum


ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string :email
    t.string :name
    t.integer :age
    t.string :favorite_color

    t.timestamps
  end
end


module Enums
  class Color
    include RubyEnum
    enum :red
    enum :green
    enum :blue
    enum :black
  end
end

class User < ActiveRecord::Base
  attr_enum :favorite_color, class_name: 'Enums::Color'
end


describe RubyEnum::ActiveRecord::AttrEnum do
  subject { User.new(email: 'none@some.com') }

  it { expect(subject.favorite_color).to be nil }

  it 'can assign an enum attribute' do
    subject.favorite_color = Enums::Color.black
    subject.save!
    expect(subject.favorite_color.value).to eq 'black'
    expect(subject.favorite_color.name).to eq :black
  end

  it 'should be able to assign a ruby enum value to nil' do
    subject.favorite_color = Enums::Color::GREEN
    subject.save!
    expect(subject.favorite_color.value).to eq 'green'
    subject.favorite_color = nil
    subject.save!
    expect(subject.favorite_color).to be nil
  end

  it 'should be able to assign a string value' do
    subject.favorite_color = 'green'
    subject.save!
    expect(subject.favorite_color.value).to eq 'green'
  end

  context 'when enum is not defined' do
    pending "should be defined"
  end
end