module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

# rubocop:disable all
  module ClassMethods
    def attr_accessor_with_history(*attr_names)
      attr_names.each do |_param|
        define_method(attr_name) do
          instance_variable_get("@#{attr_name}")
        end

        define_method("#{attr_name}_history") do
          instance_variable_get("@#{attr_name}_history")
        end
        define_method("#{attr_name}=") do |value|
          instance_variable_set("@#{attr_name}", value)
          history_values = instance_variable_get("@#{attr_name}_history") || []
          instance_variable_set("@#{attr_name}_history", history_values << value)
        end
      end
    end

# rubocop:enable all
    def strong_attr_accessor(attr_name, attr_class)
      define_method(attr_name.to_s) do
        instance_variable_get("@#{attr_name}")
      end
      define_method("#{attr_name}=") do |value|
        raise TypeError, "Тип должен быть #{attr_class}" unless value.is_a?(attr_class)

        instance_variable_set("@#{attr_name}", value)
      end
    end
  end
end
