# frozen_string_literal: true
# rubocop:disable all
class Interface

  def initialize
    @trains = []
    @stations = []
    @routes = []
  end

  def start
    loop do
      puts "Действие:\n
      1. Создать cтанцию\n
      2. Создать поезд\n
      3. Создавать маршруты и управлять станциями в нем (добавлять, удалять)\n
      4. Назначать маршрут поезду\n
      5. Добавлять вагоны к поезду\n
      6. Отцеплять вагоны от поезда\n
      7. Перемещать поезд по маршруту вперед и назад\n
      8. Просматривать список станций и список поездов на станции\n
      9. Вывести список поездов на станции\n
      10. Вывести список вагонов поезда\n
      11. Занять место в вагоне\n
      0. Выйти"

      input = gets.to_i
      case input
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        direct_route
      when 5
        add_carriages
      when 6
        delete_carriages
      when 7
        move_train
      when 8
        list_stations_trains
      when 9
        list_trains
      when 10
        list_carriages
      when 11
        fill_carriages
      when 0
        break
      end
    end

  # rubocop:enable all
  private

  def create_staiton
    puts 'Введите название станции: '
    station_name = gets.chomp
    @stations << Station.new(station_name)
  end

  def create_train
    puts 'Введите номер поезда: '
    number = gets.chomp
    puts "Выберите тип создаваемого поезда:
    1. Пассажирский,
    2. Грузовой"
    type = gets.chomp.to_i
    case type
    when 1
      @trains = Train.new(number, :passenger)
    when 2
      @trains = Train.new(number, :cargo)
    else
      puts 'Введено неправильное значение! Начните сначала'
      break
    end
  end

  def create_route
    puts 'Выберите начальную станцию: '
    @stations.each_with_index { |index, station| puts "#{index + 1}. #{station.name}" }
    first_station = @stations[gets.to_i - 1]
    puts 'Выберите конечную станцию: '
    @stations.each_with_index { |index, station| puts "#{index + 1}. #{station.name}" }
    last_station = @stations[gets.to_i - 1]
    @routes << Route.new(first_station, last_station)
  end

  def add_station_to_route
    route = select_route
    puts 'Какую станцию добавить в маршрут: '
    route.add_station(gets.chomp)
  end

  def remove_station
    route = select_route
    puts 'Какую станцию удалить из маршрута: '
    route.del_station(gets.chomp)
  end

  def select_route
    puts 'Выберите маршрут из списка: '
    routes.each_index { |r| puts "#{r} - #{routes[r].route}" }
    index_route = gets.chomp.to_i
    routes[index_route]
  end

  # rubocop:disable Metrics/MethodLength
  def direct_route
    puts "Выберите действие с маршрутом:
    1 - Создать новый маршрут
    2 - Добавить станцию в маршрут
    3 - Удалить станцию из маршрута
    0 - Выйти"

    input = gets.chomp.to_i
    case input
    when 1
      create_route
    when 2
      add_station_to_route
    when 3
      remove_station
    when 0
      break
    end
  end

  def add_carriages(type, number)
    train = select_train
    puts "Выберите тип вагона:
    1. Пассажирский,
    2. Грузовой"
    type = gets.chomp.to_i
    puts 'Укажите номер вагона: '
    number = gets.chomp
    case type
    when 1
      total_of_places = gets.chomp
      carriages = PassengerCarriage.new(number, total_of_places)
    when 2
      total_volume = gets.chomp
      carriages = CargoCarriage.new(number, total_volume)
    else
      puts 'Ошибка!!!'
    end
    train.add(carriages)
  end

  # rubocop:enable Metrics/MethodLength
  def delete_carriages
    train = select_train
    carriages = select_carriage(train)
    train.delete(carriages)
  end

  def select_train
    puts 'Выберите поезд из списка: '
    trains.each_index { |t| puts "#{t} - #{trains[t].number} - #{trains[t].type}" }
    index_train = gets.chomp.to_i
    trains[index_train]
  end

  def select_carriage(train)
    puts 'Выберите вагон из состава: '
    train.carriages.each_index { |i| puts "#{i} - #{train.carriages[i]}" }
    index_carriage = gets.chomp.to_i
    train.carriages[index_carriage]
  end

  # rubocop:disable Metrics/MethodLength
  def move_train
    train = select_train
    if train.current_route.nil?
      puts 'Поезду не назначен маршрут. Сначала назначьте'
    else
      puts "Выберите направление движения поезда:
      1. Вперед,
      2. Назад"
      choise = gets.chomp.to_i
      case choise
      when 1
        train.move_next_station
      when 2
        train.move_previous_station
      else
        puts 'Ошибка!!!'
      end
      puts "Текущая станция #{train.current_station}"
    end
  end

  # rubocop:enable Metrics/MethodLength
  def list_stations
    puts 'Список станций: '
    stations.each { |s| puts s.title }
    puts 'Список поездов: '
    trains.each { |t| puts "Номер поезда: #{t.number} Тип: #{t.type}" }
  end

  def list_trains
    my_station = select_station
    puts 'Список поездов на станции: '
    my_station.each_trains do |train|
      puts "Номер: #{train.number},
      тип: #{train.type}, кол. вагонов: #{train.carriages.size}"
    end
  end

  def info_carriages(carriage)
    str = "Номер: #{carriage.number}, тип: #{carriage.type}"
    if carriage.type == :passenger
      puts str + ", занято: #{carriage.taken_seats}, свободно #{c.free_seats}"
    else
      puts str + ", занято: #{carriage.filled_volume}, свободно #{carriage.free_volume}"
    end
  end

  def list_carriages
    my_train = select_train
    puts 'Список вагонов поезда: '
    my_train.list_carriages do |carriage|
      info_carriages(carriage)
    end
  end

  def fill_carriages
    my_carriage = select_carriage(select_train)
    if my_carriage.instance_of?(PassengerCarriage)
      puts 'Сколько мест будет занято?:'
      gets.chomp.to_i.times { my_carriage.take_seat }
    elsif my_carriage.instance_of?(CargoCarriage)
      puts 'Какой объем будет занят?: '
      my_carriage.fill_volume(gets.chomp.to_i)
    end
  end
end
