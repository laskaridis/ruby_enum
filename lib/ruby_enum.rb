require "ruby_enum/version"

module RubyEnum

  def self.included(base)
    # enmeration instances are singleton values
    base.private_class_method(:new, :allocate)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
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

    # the value associated with the enumeration instance
    def value
      @_value
    end

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

    # defines enumeration values
    def enum(name, value = nil)
      normalized_name = _normalize name
      if self[normalized_name]
        raise ArgumentError, "An enumeration value for #{normalized_name} has " \
          "already been defined in #{self.name}."
      else
        value = normalized_name.to_s unless value
        _define_instance_accessor_for normalized_name
        _enumeration_values[normalized_name] = new(normalized_name, value)
      end
    end

    def [](name)
      _enumeration_values[_normalize(name)]
    end

    def all
      _enumeration_values.map { |_, instance| instance }
    end

    private

    def _enumeration_values
      @_instances ||= {}
    end

    def _define_instance_accessor_for(name)
      # check {http://ryanangilly.com/post/234897271/dynamically-adding-class-methods-in-ruby}
      class << self
        self
      end.instance_eval do
        define_method(name) { return self[name] }
      end
    end

    def _normalize(name)
      name.to_s.downcase.to_sym
    end
  end
end
