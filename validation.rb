module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  class ValidationError < StandardError
  end

  module InstanceMethods
    def validate!
      validations = self.class.instance_variable_get('@validations')
      errors = []
      validations.each do |validation|
        value = instance_variable_get("@#{validation[:attribute]}")
        error = send validation[:type], value, validation

        errors << error unless error.nil?
      end

      raise ValidationError, errors unless errors.empty?

      true
    end

    def valid?
      validate!
      true
    rescue ValidationError
      false
    end

    private

    def presence(_value, _validation)
      attr_names[:message] ||= 'Пустая строка или nil'
    end

    def format(value, _validation)
      attr_names[:message] ||= "Не соответствует формату #{attr_names[:attr_name]}"
      attr_names[:message] unless attr_names[:attr_name].match(value.to_s)
    end

    def type(value, attr_names)
      attr_names[:message] ||= "Ожидается тип #{attr_names[:attr_name]}"
      attr_names[:message] unless value.is_a?(attr_names[:attr_name])
    end

    def first_last_uniq(value, attr_names)
      attr_names[:message] ||= 'Первый и последний эл-ты идентичны'
      attr_names[:message] if value.first == value.last
    end

    def each_type(value, attr_names)
      attr_names[:message] ||= "Содержит тип, отличающийся от #{attr_names[:attr_name]}"
      attr_names[:message] if value.reject { |v| v.is_a?(attr_names[:attr_name]) }.length.nil?
    end
  end

  module ClassMethods
    def validate(*attr_names)
      @validations ||= []

      @validations << {
        attribute: attr_names[0],
        type: attr_names[1],
        attr_name: attr_names[2] || nil,
        message: attr_names.last.is_a?(Hash) && attr_names.last.key?(:message) ? attr_names.last[:message] : nil
      }
    end
  end
end
