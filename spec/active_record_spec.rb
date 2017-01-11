require "spec_helper"

require "active_record"
require "active_model"
require "ruby_enum/active_record"
require "ruby_enum/active_model"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.send(:include, RubyEnum::ActiveRecord::AttrEnum)
ActiveRecord::Base.send(:include, RubyEnum::ActiveModel::AttrEnum)
ActiveRecord::Schema.define do
  self.verbose = false
  create_table :users, :force => true do |t|
    t.string :name
    t.string :favorite_color
  end
end

class Color
  include RubyEnum

  enum :red
  enum :green
  enum :blue
  enum :black
end

class User < ActiveRecord::Base
  attr_enum :favorite_color, class_name: 'Color'
end

module RubyEnum
  module ActiveRecord

    describe AttrEnum do

      context "when passing an enumeration instance to initializer opts" do
        subject { User.new(favorite_color: Color.green) }

        it { expect(subject.favorite_color).to eq Color.green }
      end

      context "when passing an enumeration instance value to initializer options" do
        subject { User.new(favorite_color: Color.green.value) }

        it { expect(subject.favorite_color).to eq Color.green }
      end

      context "when passing null to initializer options" do
        subject { User.new(favorite_color: nil) }

        it { expect(subject.favorite_color).to be_nil }
      end

      context "given an active record model" do
        subject { User.new }

        it "should set an enumeration attribute to an enumeration value" do
          subject.favorite_color = Color.green
          expect(subject.favorite_color).to eq Color.green
        end

        it "should set an enumeration attribute to nil" do
          subject.favorite_color = Color.green
          subject.favorite_color = nil
          expect(subject.favorite_color).to be_nil
        end

        it "should persist an enumeration attribute" do
          subject.favorite_color = Color.green
          subject.save!
          subject.reload
          expect(subject.favorite_color).to eq Color.green
        end

        it "should not set a non enumeration value to an enumeration attribute" do
          expect do
            subject.favorite_color = "green"
          end.to raise_error(StandardError)
        end
      end
    end
  end
end
