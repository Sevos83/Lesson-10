# frozen_string_literal: true

require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    validate!
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def get_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.filter { |train| train.type == type }
  end
end
