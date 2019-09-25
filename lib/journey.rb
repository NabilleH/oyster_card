class Journey

  attr_reader :full_journey, :fare

  MAXIMUM_FARE = 6
  MINIMUM_FARE = 1

  def initialize
    @full_journey = { entry_station: nil, exit_station: nil }
    @fare = MAXIMUM_FARE

  end

  def start_journey(entry_station)
    @full_journey[:entry_station] = entry_station
  end

  def complete_journey(exit_station)
    @full_journey[:exit_station] = exit_station
  end

  def calc_fare
    if @full_journey[:exit_station] == "NO TOUCH OUT - Max fare charged"
      @fare = MAXIMUM_FARE
    elsif @full_journey[:entry_station] == "NO TOUCH IN - Max fare charged"
      @fare = MAXIMUM_FARE
    else
      @fare = MINIMUM_FARE
    end
  end

end
