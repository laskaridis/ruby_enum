require "ruby_enum/version"

module RubyEnum

  def self.included(base)
    # enmeration instances are singleton values
    base.private_class_method(:new, :allocate)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module InstanceMethods

    # the value associated with the enumeration instance
    def raw_value
      @_value
    end

    def clone
      raise TypeError, "can't clone instance of enum #{self.class}"
    end

    def dup
      raise TypeError, "can't dupe instance of enum #{self.class}"
    end

    private

    def initialize(value)
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
      @_instances ||= {}

      normalized_name = normalize name
      if self[normalized_name]
        raise ArgumentError, "An enumeration value for #{normalized_name} has " \
          "already been defined in #{self.name}."
      else
        value = normalized_name.to_s unless value
        define_instance_accessor_for normalized_name
        @_instances[normalized_name] = new value
      end
    end

    def [](name)
      @_instances[normalize(name)]
    end

    def all
      @_instances.map { |_, instance| instance }
    end

    private

    def define_instance_accessor_for(name)
      self.class.instance_eval do
        define_method(name) { return self[name] }
      end
    end

    def normalize(name)
      name.to_s.downcase.to_sym
    end
  end
end
