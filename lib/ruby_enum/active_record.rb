require 'active_support/concern'

module RubyEnum
  module ActiveRecord
    module AttrEnum
      extend ActiveSupport::Concern

      module ClassMethods

        def attr_enum(name, opts = {})
          _create_attr_descriptor_for(name, opts)
          _define_attr_getter_for name
          _define_attr_setter_for name
        end

        def attr_enums
          @_attr_enums ||= {}
        end

        private

        def _create_attr_descriptor_for(name, opts)
          if attr_enums[name].present?
            raise ArgumentError, "#{self} already has an enum attr named `#{name}`"
          end

          # set a default enumeration class name if none provided
          if opts[:class_name].nil?
            opts[:class_name] = _enum_class_name_for name
          end

          attr_enums[name] = opts
        end

        def _enum_class_name_for(name)
          name.to_s.capitalize
        end

        def _define_attr_getter_for(name)
          define_method name do
            enum = self.class.attr_enums[name]
            enum_class = Object.const_get enum[:class_name]
            enum_class.find_by_value super()
          end

          def _define_attr_setter_for(name)
            define_method "#{name}=" do |new_value|
              if new_value.present?
                super(new_value.value)
              end
            end
          end
        end
      end
    end
  end
end

::ActiveRecord::Base.send :include, RubyEnum::ActiveRecord::AttrEnum
