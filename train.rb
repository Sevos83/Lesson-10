# frozen_string_literal: true

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :type, :route, :current_station
  attr_accessor :number

  def valid?
    validate!
  rescue StandardError
    false
  end

  NUMBER_FORMAT = /\A[а-я0-9]{3}-*[а-я0-9]{2}\z/i.freeze

  def initialize(number, type, carriages)
    @number = number
    @type = type
    @carriages = carriages
    @speed = 0
    validate!
    @@trains[number] = self
  end

  def self.find(number)
    @@trains[number]
  end

  def speed_up(speed)
    @speed += speed
  end

  def speed_down(speed)
    @speed -= speed
    @speed = @speed.positive? ? @speed : stop
  end

  def stop
    @speed = 0
  end

  def add_carriages(_carriages)
    @carriages += 1 if @speed.zero?
  end

  def delete_carriages
    @carriages -= 1 if @speed.zero? && carriages.positive?
  end

  def route=(route)
    @route = route
    @current_station = @route.stations.first
    @current_station_index = @route.stations.index(@current_station)
    @current_station.train_in(self)
  end

  def next_station
    @route.stations[@current_station_index + 1] if @route.stations[@current_station_index] != @route.stations.last
  end

  def move_next_station
    return unless next_station

    @current_station.train_out(self)
    next_station.train_in(self)
    @current_station_index += 1
    @current_station = @route.stations[@current_station_index]
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @route.stations[@current_station_index] != @route.stations.first
  end

  def move_previous_station
    return unless previous_station

    @current_station.train_out(self)
    previous_station.train_in(self)
    @current_station_index -= 1
    @current_station = @route.stations[@current_station_index]
  end

  def list_of_carriages(&block)
    carriages.each(&block)
  end

  protected

  def validate!
    raise 'Номер не может быть пустым!' if number.nil?
    raise 'Номер не может быть короче 5 символов!' if number.length < 5
    raise 'Номер поезда не соответствует формату!' if number !~ NUMBER_FORMAT

    true
  end
end
