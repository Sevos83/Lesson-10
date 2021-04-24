# frozen_string_literal: true

class CargoCarriage
  attr_reader :total_volume, :filled_volume, :free_volume

  def initialize(number, total_volume)
    @number = number
    @type = :cargo
    @total_volume = total_volume
    @free_volume = total_volume
  end

  def fill_volume(volume)
    self.filled_volume += volume
    self.free_volume = total_volume - self.filled_volume
  end

  protected

  attr_writer :filled_volume, :free_volume
end
