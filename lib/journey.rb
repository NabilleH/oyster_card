class Journey

  attr_reader :full_journey, :fare

  def initialize(entry_station)
    @full_journey = { entry_station: entry_station, exit_station: nil }
    @fare = 0

  end

  def complete_journey(exit_station)
    @full_journey[:exit_station] = exit_station
  end


end
