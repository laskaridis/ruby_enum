require "ruby_enum/version"

module RubyEnum

  def self.included(base)
    # enmeration instances are singleton values
    base.private_class_method(:new, :allocate)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module InstanceMethods

    def method_missing(method, *args, &block)
      if method.to_s =~ /^(.*)\?/
        enum_names = self.class.all.map(&:name)
        expected_name = $1.to_sym
        if enum_names.include?(expected_name)
          return name == expected_name
        end
      end
    end

    def respond_to?(method)
      if method.to_s =~ /^(.*)\?/
        enum_names = self.class.all.map(&:name)
        return enum_names.include? $1.to_sym
      end
    end

    # @return [String] the associated value of the enumeration instance
    def value
      @_value
    end

    # @return [Symbol] the name of the enumeration instance
    def name
      @_name
    end

    def clone
      raise TypeError, "can't clone instance of enum #{self.class}"
    end

    def dup
      raise TypeError, "can't dupe instance of enum #{self.class}"
    end

    private

    def initialize(name, value)
      @_name = name
      @_value = value
    end
  end

  module ClassMethods

    # enable retrieving enumeration values as constants
    def const_missing(name)
      self[name] || super
    end

    def enum(name, value = nil)
      raise ArgumentError, 'name is required for an enumeration' if name.nil?

      normalized_name = _normalize name
      if self[normalized_name]
        raise ArgumentError, "an enumeration value for #{normalized_name} has " \
          "already been defined in #{self.name}."
      else
        value = normalized_name.to_s unless value
        if find_by_value value
          raise ArgumentError, "duplicate associated value `#{value}` for enumeration" \
            "with name `#{name}`"
        end
        _define_instance_accessor_for normalized_name
        _enumeration_values[normalized_name] = new(normalized_name, value)
      end
    end

    # @return the enumeration instance with the specified name or nil if none exists
    def [](name)
      _enumeration_values[_normalize(name)]
    end

    # @return [Array] all enumeration instances defined in this enumeration class
    def all
      _enumeration_values.map { |_, instance| instance }
    end

    # @return the enumeration instance with the specified associated value
    # @raise [ArgumentError] when no enumeration instance with the associated value is found
    def find_by_value!(value)
      result = find_by_value(value) 
      unless result
        raise ArgumentError, "No enumeration value with associated value #{value} found"
      end

      result
    end

    # @return the enumeration instance with the specifed associated value
    def find_by_value(value)
      all.find { |instance| instance.value == value }
    end

    private

    def _enumeration_values
      @_instances ||= {}
    end

    def _define_instance_accessor_for(name)
      # check {http://ryanangilly.com/post/234897271/dynamically-adding-class-methods-in-ruby}
      _metaclass.instance_eval do
        define_method(name) { return self[name] }
      end
    end

    def _metaclass
      class << self
        self
      end
    end

    def _normalize(name)
      name.to_s.downcase.to_sym
    end
  end
end

if defined? Rails
  require 'ruby_enum/active_record'
  require 'ruby_enum/active_model'
  require 'ruby_enum/railtie'
end
