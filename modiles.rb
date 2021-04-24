# frozen_string_literal: true

module Manufacturer
  attr_accessor :manufacturer
end

module InstanceCounter
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods
    protected

    def register_instance; end
  end
end
