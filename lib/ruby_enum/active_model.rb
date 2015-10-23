require 'active_support/concern'

module RubyEnum
  module ActiveModel
    module AttrEnum
      extend ActiveSupport::Concern

      def assign_attributes(new_attributes, optsions = {})
        if new_attributes
          enumeration_attrs = self.class.attr_enums

          new_attributes.each do |k, v|
            enum_attr = enumeration_attrs[k.to_sym]

            if enum_attr.present? && _is_not_enum?(v)
              enum_class_name = enum_attr[:class_name]
              enum_class = Object.const_get enum_class_name
              new_attributes[k] = enum_class.find_by_value(v)
            end
          end
        end

        super
      end

      private

      def _is_not_enum?(value)
        !value.class.ancestors.include? RubyEnum
      end
    end
  end
end
