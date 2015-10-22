module RubyEnum
  class Railtie < ::Rails::Railtie
    initializer 'rubyenum.initialize' do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send :include, RubyEnum::ActiveRecord::AttrEnum
        ::ActiveRecord::Base.send :include, RubyEnum::ActiveModel::AttrEnum
      end
    end
  end
end
