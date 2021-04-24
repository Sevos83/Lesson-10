# frozen_string_literal: true

class Carriage
  include InstanceCounter
  include Manufacturer

  attr_reader :type
  attr_accessor :number

  def initialize(number)
    @number = number
    validate!
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  protected

  def validate!
    raise 'Номер не может быть пустым!' if number.nil?
    raise 'Номер не может быть короче 3 символов!' if number.length < 3

    true
  end
end
